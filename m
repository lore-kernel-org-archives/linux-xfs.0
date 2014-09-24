Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D58C97F3F
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 07:28:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A75888F8037
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 05:27:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jZPObEl3kQy7BydJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 05:27:56 -0700 (PDT)
Date: Wed, 24 Sep 2014 08:27:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: borrow indirect blocks from freed extent when
	available
Message-ID: <20140924122746.GA53094@bfoster.bfoster>
References: <1411500538-6831-1-git-send-email-bfoster@redhat.com>
	<20140923215816.GC4322@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140923215816.GC4322@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 24, 2014 at 07:58:16AM +1000, Dave Chinner wrote:
> On Tue, Sep 23, 2014 at 03:28:58PM -0400, Brian Foster wrote:
> > xfs_bmap_del_extent() handles extent removal from the in-core and
> > on-disk extent lists. When removing a delalloc range, it updates the
> > indirect block reservation appropriately based on the removal. It
> > currently enforces that the new indirect block reservation is less than
> > or equal to the original. This is normally the case in all situations
> > except for when the removed range creates a hole in a single delalloc
> > extent, thus splitting a single delalloc extent in two.
> > 
> > The indirect block reservation is divided evenly between the two new
> > extents in this scenario. However, it is possible with small enough
> > extents to split an indlen==1 extent into two such slightly smaller
> > extents. This leaves one extent with 0 indirect blocks and leads to
> > assert failures in other areas (e.g., xfs_bunmapi() if the extent
> > happens to be removed).
> 
> I had long suspected we had an issue in this code, but was never
> able to nail down a reproducer that triggered it. Do you have a
> reproducer, or did you find this by reading/tracing the code?
> 

I have a setup on which fsx reproduces an instance of this within a few
minutes consistently. It looks like the same sequence of events each
occurrence so I can try to derive a more specific test case for it. I
suspect the right sequence of delayed allocation followed by hole
punching or zeroing should be able to trigger it.

> > Refactor xfs_bunmapi() to make the updates that must be consistent
> > against the inode (e.g., delalloc block counter, quota reservation)
> > right before the extent is deleted. Move the sb block counter update
> > after the extent is deleted and update xfs_bmap_del_extent() to steal
> > some blocks from the freed extent if a larger overall indirect
> > reservation is required by the extent removal.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > I'm seeing the following assert more frequently with fsx and the recent
> > xfs_free_file_space() changes (at least on 1k fsb fs'):
> > 
> > XFS: Assertion failed: startblockval(del.br_startblock) > 0, file: fs/xfs/libxfs/xfs_bmap.c, line: 5281
> > 
> > This occurs for the reason described in the commit log description. This
> > is a quick experiment I wanted to test to verify the problem goes away
> > (so far, so good). Very lightly tested so far.
> 
> I suspect it's also the cause of these occasional assert failures
> that I see:
> 
> XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 327
> 
> during delalloc conversion because there wasn't a space reservation
> for the blocks allocated (i.e. indlen was zero) and so we overrun
> the transaction block reservation.
> 

Interesting, I've seen this as well though I'll have to go back and see
where I was getting it from. I did run fsx overnight without any assert
failures at all, which seems rare lately. ;) I wasn't running my usual
parallel fsstress however. I've started that and I reproduce an instance
of that assert failure within a few minutes, so if related it appears
this might not be the only contributer. I'll look more into that one
next.

> > I'm not too fond of changing br_blockcount like this. It seems like a
> > potential landmine. Alternative approaches could be to kill the assert
> > if we think indlen==0 extents is not a huge problem in this scenario,
> 
> A delalloc extent always needs a reservation....
> 

Ok.

> > update the counters independently in xfs_bmap_del_extent() to get the
> > needed blocks or pass a separate output parameter rather than messing
> > with br_blockcount (e.g., '*ofreedblks'). The latter might mean we could
> > just move the entire hunk that updates the inode/quota and whatnot
> > rather than splitting it up.
> > 
> > I wanted to put this on the list for comments. Thoughts? Other ideas?
> > Thanks.
> > 
> > Brian
> > 
> >  fs/xfs/libxfs/xfs_bmap.c | 64 ++++++++++++++++++++++++++++++------------------
> >  1 file changed, 40 insertions(+), 24 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 86df952..1858e6b 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4969,6 +4969,11 @@ xfs_bmap_del_extent(
> >  			temp2 = xfs_bmap_worst_indlen(ip, temp2);
> >  			new.br_startblock = nullstartblock((int)temp2);
> >  			da_new = temp + temp2;
> > +			/* pull blocks from extent to make up the difference */
> > +			while (da_new > da_old && del->br_blockcount) {
> > +				del->br_blockcount--;
> > +				da_new--;
> > +			}
> >  			while (da_new > da_old) {
> >  				if (temp) {
> >  					temp--;
> 
> So this is the crux of the fix, right? The block stealing from the
> deleted extent? I have no objections to doing this given that we
> already munge the indirect reservations inteh loop below, but
> I think we should make this cleaner and more understandable. i.e.
> refactor the indlen adjustment code into a helper, and integrate the
> block stealing into the existing adjustment loop?
> 

Yes, the problem is that we basically split the existing reservation
amongst the new extents. The 'punch a hole in a small delalloc extent'
scenario can mean we have to split 1 indlen block across two extents,
thus creating the indlen==0 condition for one of the two. IOW, the
existing reservation doesn't always cover the requirements of the new
extent(s).

If the fundamental fix is sane I'll look into the associated cleanups.
Thanks for the feedback.

> > @@ -5277,9 +5282,37 @@ xfs_bunmapi(
> >  				goto nodelete;
> >  			}
> >  		}
> > +
> > +		/*
> > +		 * If it's the case where the directory code is running
> > +		 * with no block reservation, and the deleted block is in
> > +		 * the middle of its extent, and the resulting insert
> > +		 * of an extent would cause transformation to btree format,
> > +		 * then reject it.  The calling code will then swap
> > +		 * blocks around instead.
> > +		 * We have to do this now, rather than waiting for the
> > +		 * conversion to btree format, since the transaction
> > +		 * will be dirty.
> > +		 */
> > +		if (!wasdel && xfs_trans_get_block_res(tp) == 0 &&
> > +		    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
> > +		    XFS_IFORK_NEXTENTS(ip, whichfork) >= /* Note the >= */
> > +			XFS_IFORK_MAXEXT(ip, whichfork) &&
> > +		    del.br_startoff > got.br_startoff &&
> > +		    del.br_startoff + del.br_blockcount <
> > +		    got.br_startoff + got.br_blockcount) {
> > +			error = -ENOSPC;
> > +			goto error0;
> > +		}
> > +
> > +		/*
> > +		 * Unreserve quota and update realtime free space, if
> > +		 * appropriate. If delayed allocation, update the inode delalloc
> > +		 * counter now and wait to update the sb counters as
> > +		 * xfs_bmap_del_extent() might need to borrow some blocks.
> > +		 */
> >  		if (wasdel) {
> >  			ASSERT(startblockval(del.br_startblock) > 0);
> > -			/* Update realtime/data freespace, unreserve quota */
> >  			if (isrt) {
> >  				xfs_filblks_t rtexts;
> >  
> 
> Perhaps this should be separated into it's own patch that is applied
> first? It doesn't seem to be directly related to the accounting fix...
> 

Yeah, I actually have this as an independent patch and initial cleanup
in my dev. branch and I just squashed everything to send off here. This
was probably unnecessary to propose the fundamental fix. Sorry for the
added noise.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
