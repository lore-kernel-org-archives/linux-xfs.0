Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42182 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbdBOTgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2017 14:36:44 -0500
Date: Wed, 15 Feb 2017 11:36:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't reserve blocks for right shift transactions
Message-ID: <20170215193637.GA28933@birch.djwong.org>
References: <1487171128-5335-1-git-send-email-bfoster@redhat.com>
 <20170215180955.GG6813@birch.djwong.org>
 <20170215191530.GC62565@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170215191530.GC62565@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>

On Wed, Feb 15, 2017 at 02:15:30PM -0500, Brian Foster wrote:
> On Wed, Feb 15, 2017 at 10:09:55AM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 15, 2017 at 10:05:28AM -0500, Brian Foster wrote:
> > > The block reservation for the transaction allocated in
> > > xfs_shift_file_space() is an artifact of the original collapse range
> > > support. It exists to handle the case where a collapse range occurs,
> > > the initial extent is left shifted into a location that forms a
> > > contiguous boundary with the previous extent and thus the extents
> > > are merged. This code was subsequently refactored and reused for
> > > insert range (right shift) support.
> > > 
> > > If an insert range occurs under low free space conditions, the
> > > extent at the starting offset is split before the first shift
> > > transaction is allocated. If the block reservation fails, this
> > > leaves separate, but contiguous extents around in the inode. While
> > > not a fatal problem, this is unexpected and will flag a warning on
> > > subsequent insert range operations on the inode. This problem has
> > > been reproduce intermittently by generic/270 running against a
> > > ramdisk device.
> > > 
> > > Since right shift does not create new extent boundaries in the
> > > inode, a block reservation for extent merge is unnecessary. Update
> > > xfs_shift_file_space() to conditionally reserve fs blocks for left
> > > shift transactions only. This avoids the warning reproduced by
> > > generic/270.
> > > 
> > > Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_bmap_util.c | 20 ++++++++++----------
> > >  1 file changed, 10 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > index 7c3bfaf..6be5f26 100644
> > > --- a/fs/xfs/xfs_bmap_util.c
> > > +++ b/fs/xfs/xfs_bmap_util.c
> > > @@ -1385,10 +1385,16 @@ xfs_shift_file_space(
> > >  	xfs_fileoff_t		stop_fsb;
> > >  	xfs_fileoff_t		next_fsb;
> > >  	xfs_fileoff_t		shift_fsb;
> > > +	uint			resblks;
> > >  
> > >  	ASSERT(direction == SHIFT_LEFT || direction == SHIFT_RIGHT);
> > >  
> > >  	if (direction == SHIFT_LEFT) {
> > > +		/*
> > > +		 * Reserve blocks to cover potential extent merges after left
> > > +		 * shift operations.
> > > +		 */
> > > +		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> > >  		next_fsb = XFS_B_TO_FSB(mp, offset + len);
> > >  		stop_fsb = XFS_B_TO_FSB(mp, VFS_I(ip)->i_size);
> > >  	} else {
> > > @@ -1396,6 +1402,7 @@ xfs_shift_file_space(
> > >  		 * If right shift, delegate the work of initialization of
> > >  		 * next_fsb to xfs_bmap_shift_extent as it has ilock held.
> > >  		 */
> > > +		resblks = 0;
> > 
> > Hmmmm.  I am convinced that this patch removes the most likely cause of
> > _trans_alloc failure, and therefore makes the g/270 failures go away.
> > 
> > However, I worry that if we split the extent and _trans_alloc fails for
> > some other reason (e.g. ENOMEM) then we'll still end up two adjacent
> > bmap extents that should be combined.  Granted, the only solution that I
> > can think of is very complicated (create a redo log item, link
> > everything together with the deferred ops mechanism, thereby making
> > right shift an atomic operation) for something that's unlikely to
> > happen(?) during an operation that might not be all that frequent
> > anyway.  I'm also not sure about the implications of adjacent mergeable
> > bmaps -- I think we can handle it, but it's not like I've researched
> > this thoroughly.
> > 
> > <shrug> Thoughts?
> > 
> 
> Yeah, this isn't a pure fix given the way the code is organized. I think
> I meant to point that out in the commit log; that technically this state
> is still possible, but probably not as likely to occur. I also
> considered killing off the warning, but it still seems useful to me for
> similar reasons. (Effectively, the motivation for this patch is really
> just to shut the test up. :).

:)

I tossed the patch on the 4.11 pile and we'll see if a quick round
of testing turns anything up.

> I considered error handling just enough to realize that there wasn't a
> simple solution. Given that this change seemed correct regardless, I
> figured this works for now and we can revisit if this remains a problem
> in practice.
> 
> Beyond that... an atomic rewrite using the deferred ops stuff seems like
> a reasonable approach technically, but probably should be more motivated
> by the broader fact that afaict any of the collapse/insert range
> operations can fail midway through the overall operation and leave the
> file in a halfway shifted state with respect to the original request.

Yep.

> Would deferred ops address that problem (e.g., what if a subsequent
> transaction allocation failed in that model, after one or more extents
> had already been shifted)?

Yep, that's exactly what deferred ops do -- it queues up a large
operation, logs an intent for the whole operation, and re-logs
successively smaller intent items as we incrementally finish little
pieces of the big operation.  If something happens midway through, we go
offline so that later on journal recovery will know exactly where we
left off and can restart the operation.

(This is a little dangerous -- if large operation fails because of
corrupted metadata then recovery will never succeed, forcing the user to
zero the log and see what xfs_repair will do...)

If we ever /do/ redesign the code to use defer ops then we'll also have
to set a log incompat feature flag because right now we only ever use
the bmap defer ops if rmap or reflink are enabled.

> Then again, I _thought_ that all came up when the collapse range stuff
> was originally posted and wasn't considered a major problem to the users
> (either that or we didn't have a straightforward approach to make the
> whole thing atomic at the time) because ultimately the operation can be
> retried or the original state recovered from userspace...

Userspace can try to figure out where things went wrong and restart the
operation, but if they don't then we get left in this weird state with
adjacent bmaps.  There wasn't a straightforward way to create an atomic
compound operation until deferred ops came along in 4.8.

--D

> 
> Brian
> 
> > --D
> > 
> > >  		next_fsb = NULLFSBLOCK;
> > >  		stop_fsb = XFS_B_TO_FSB(mp, offset);
> > >  	}
> > > @@ -1437,21 +1444,14 @@ xfs_shift_file_space(
> > >  	}
> > >  
> > >  	while (!error && !done) {
> > > -		/*
> > > -		 * We would need to reserve permanent block for transaction.
> > > -		 * This will come into picture when after shifting extent into
> > > -		 * hole we found that adjacent extents can be merged which
> > > -		 * may lead to freeing of a block during record update.
> > > -		 */
> > > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
> > > -				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
> > > +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0,
> > > +					&tp);
> > >  		if (error)
> > >  			break;
> > >  
> > >  		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > >  		error = xfs_trans_reserve_quota(tp, mp, ip->i_udquot,
> > > -				ip->i_gdquot, ip->i_pdquot,
> > > -				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
> > > +				ip->i_gdquot, ip->i_pdquot, resblks, 0,
> > >  				XFS_QMOPT_RES_REGBLKS);
> > >  		if (error)
> > >  			goto out_trans_cancel;
> > > -- 
> > > 2.7.4
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
