Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750961AbeBHNMc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Feb 2018 08:12:32 -0500
Date: Thu, 8 Feb 2018 08:12:30 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: account format bouncing into rmapbt swapext tx
 reservation
Message-ID: <20180208131230.GB13929@bfoster.bfoster>
References: <20180205174601.51574-1-bfoster@redhat.com>
 <20180205174601.51574-3-bfoster@redhat.com>
 <20180208015634.GD5433@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208015634.GD5433@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 07, 2018 at 05:56:34PM -0800, Darrick J. Wong wrote:
> On Mon, Feb 05, 2018 at 12:45:59PM -0500, Brian Foster wrote:
> > The extent swap mechanism requires a unique implementation for
> > rmapbt enabled filesystems. Because the rmapbt tracks extent owner
> > information, extent swap must individually unmap and remap each
> > extent between the two inodes.
> > 
> > The rmapbt extent swap transaction block reservation currently
> > accounts for the worst case bmapbt block and rmapbt block
> > consumption based on the extent count of each inode. There is a
> > corner case that exists due to the extent swap implementation that
> > is not covered by this reservation, however.
> > 
> > If one of the associated inodes is just over the max extent count
> > used for extent format inodes (i.e., the inode is in btree format by
> > a single extent), the unmap/remap cycle of the extent swap can
> > bounce the inode between extent and btree format multiple times,
> > almost as many times as there are extents in the inode (if the
> > opposing inode happens to have one less, for example). Each back and
> > forth cycle involves a block free and allocation, which isn't a
> > problem except for that the initial transaction reservation must
> > account for the total number of block allocations performed by the
> > chain of deferred operations. If not, a block reservation overrun
> > occurs and the filesystem shuts down.
> > 
> > Update the rmapbt extent swap block reservation to check for this
> > situation and add some block reservation slop to ensure the entire
> > operation succeeds. We'd never likely require reservation for both
> > inodes as fsr wouldn't defrag the file in that case, but the
> > additional reservation is constrained by the data fork size so be
> > cautious and check for both.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c | 29 ++++++++++++++++++++---------
> >  1 file changed, 20 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index c83f549dc17b..e0a442f504e5 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1899,17 +1899,28 @@ xfs_swap_extents(
> >  	 * performed with log redo items!
> >  	 */
> >  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > +		int		w	= XFS_DATA_FORK;
> > +		uint32_t	ipnext	= XFS_IFORK_NEXTENTS(ip, w);
> > +		uint32_t	tipnext	= XFS_IFORK_NEXTENTS(tip, w);
> > +
> > +		/*
> > +		 * Conceptually this shouldn't affect the shape of either bmbt,
> > +		 * but since we atomically move extents one by one, we reserve
> > +		 * enough space to rebuild both trees.
> > +		 */
> > +		resblks = XFS_SWAP_RMAP_SPACE_RES(mp, ipnext, w);
> > +		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
> > +
> >  		/*
> > -		 * Conceptually this shouldn't affect the shape of either
> > -		 * bmbt, but since we atomically move extents one by one,
> > -		 * we reserve enough space to rebuild both trees.
> > +		 * Handle the corner case where either inode might straddle the
> > +		 * btree format boundary. If so, the inode could bounce between
> > +		 * btree <-> extent format on unmap -> remap cycles, freeing and
> > +		 * allocating a bmapbt block each time.
> >  		 */
> > -		resblks = XFS_SWAP_RMAP_SPACE_RES(mp,
> > -				XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK),
> > -				XFS_DATA_FORK) +
> > -			  XFS_SWAP_RMAP_SPACE_RES(mp,
> > -				XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK),
> > -				XFS_DATA_FORK);
> > +		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
> > +			resblks += XFS_IFORK_MAXEXT(ip, w);
> > +		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
> > +			resblks += XFS_IFORK_MAXEXT(tip, w);
> 
> I think this looks good enough to fix the problem, but I've been
> wondering (in a more general sense) if it really makes sense to be
> repeatedly freeing and allocating bmbt blocks like this?
> 

It is a bit cringe-worthy of a behavior when you look at these
pathological corner cases, but I think this one really is a corner case
in the sense that we should probably question the value of anything that
adds real complexity to the overall operation just for this particular
situation. To me, swapext seemed a limited enough operation that it
wasn't worth thinking too hard about something that avoided the higher
level behavior.

I'm not against doing something more clever, but it would be in addition
to this fix and should probably require more justification that this
case alone.

> What I mean is, there are a few operations (like rmapbt updates) that
> can cause a lot of similar thrashing behavior when we delete a record
> from one place and reinsert it shortly thereafter.  If the btree block
> has the exact minimum number of records then it'll try to disperse the
> records into the adjoining blocks, which is completely unnecessary if we
> know that we're about to reinsert it somewhere else in the block.
> 

Indeed. Something that comes to mind initially would be to find a way
for an operation to pin a particular structure format over a broader
operation, where pin is loosely defined to mean "don't shrink it." An
obvious challenge there is that we still need to handle cases where
shuffling around metadata records does actually result in legitimate
shrink due to creation of contiguity or whatnot. Perhaps such tasks
could be deferred post high-level op (i.e., such as cursor release) vs.
always done inline to a particular modification.

Alternatively, I believe we've already loosely taken advantage of the
concept of reusing freed blocks in the delalloc case (i.e.,
xfs_bmap_split_indlen()). Perhaps we could apply something like that to
transactions and physical blocks that have been (deferred) freed.

But I'm just throwing stuff against the wall here.. :P

> Granted in swapext-with-rmap we also have a lot of log update machinery
> in the way so there might not be a good way to hold on to blocks.  It
> might introduce so much extra complexity it's not worth it either, since
> I think we'd have to claw back references to the buffer in the log,
> remove the extent busy record, and change the buffer type...?
> 

Yeah, I think anything that relies on undoing a particular modification
that has been made in buffers but just hadn't hit disk is probably not
going to get us very far. Those buffers may have already been unlocked
or even relogged with other changes by the time we'd get at them again,
I think.

OTOH, I do think deferred operations could facilitate such a mechanism,
but I suppose we'd still have to make sure the appropriate rmapbt
updates are made, accounting/reservation is done correctly, think about
the case where extents should be busy and thus shouldn't immediately be
reused, etc. There's definitely enough complexity there that we'd
probably want to identify whether there are strong enough benefits.
I.e., what's the problem to this solution? :)

Brian

> --D
> 
> >  	}
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> >  	if (error)
> > -- 
> > 2.13.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
