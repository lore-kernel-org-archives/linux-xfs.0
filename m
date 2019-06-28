Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55794 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbfF1Rl7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 13:41:59 -0400
Date: Fri, 28 Jun 2019 10:41:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/13] xfs: remove XFS_TRANS_NOFS
Message-ID: <20190628174135.GC1404256@magnolia>
References: <20190627104836.25446-1-hch@lst.de>
 <20190627104836.25446-7-hch@lst.de>
 <20190627223030.GS5171@magnolia>
 <20190628053717.GB26902@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628053717.GB26902@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jun 28, 2019 at 07:37:17AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 27, 2019 at 03:30:30PM -0700, Darrick J. Wong wrote:
> > I think the wording of this is too indirect.  The reason we need to set
> > NOFS is because we could be doing writeback as part of reclaiming
> > memory, which means that we cannot recurse back into filesystems to
> > satisfy the memory allocation needed to create a transaction.  The NOFS
> > part applies to any memory allocation, of course.
> > 
> > If you're fine with the wording below I'll just edit that into the
> > patch:
> > 
> > 	/*
> > 	 * We can allocate memory here while doing writeback on behalf of
> > 	 * memory reclaim.  To avoid memory allocation deadlocks set the
> > 	 * task-wide nofs context for the following operations.
> > 	 */
> > 	nofs_flag = memalloc_nofs_save();
> 
> Fine with me.
> 
> > >  	trace_xfs_end_io_direct_write(ip, offset, size);
> > > @@ -395,10 +396,11 @@ xfs_dio_write_end_io(
> > >  	 */
> > >  	XFS_STATS_ADD(ip->i_mount, xs_write_bytes, size);
> > >  
> > > +	nofs_flag = memalloc_nofs_save();
> > 
> > Hmm, do we need this here?  I can't remember if there was a need for
> > setting NOFS under xfs_reflink_end_cow from a dio completion or if that
> > was purely the buffered writeback case...
> 
> We certainly had to add it for the unwritten extent conversion, maybe
> the corner case just didn't manage to show up for COW yet:

AFAICT the referenced patch solved the problem of writeback ioend
completion deadlocking with memory reclaim by changing the transaction
allocation call in the xfs_iomap_write_unwritten function, which is
called by writeback ioend completion.

However, the directio endio code also calls xfs_iomap_write_unwritten.
I can't tell if NOFS is actually needed in that context, or if we've
just been operating like that for a decade because that's the method
that was chosen to solve the deadlock.

I think this boils down to -- does writeback induced by memory reclaim
ever block on directio?

I don't think it does, but as a counterpoint xfs has been like this for
10 years and there don't seem to be many complaints about directio endio
pushing memory reclaim too hard...

--D

> 
> commit 80641dc66a2d6dfb22af4413227a92b8ab84c7bb
> Author: Christoph Hellwig <hch@infradead.org>
> Date:   Mon Oct 19 04:00:03 2009 +0000
> 
>     xfs: I/O completion handlers must use NOFS allocations
>     
>     When completing I/O requests we must not allow the memory allocator to
>     recurse into the filesystem, as we might deadlock on waiting for the
>     I/O completion otherwise.  The only thing currently allocating normal
>     GFP_KERNEL memory is the allocation of the transaction structure for
>     the unwritten extent conversion.  Add a memflags argument to
>     _xfs_trans_alloc to allow controlling the allocator behaviour.
>     
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>     Reported-by: Thomas Neumann <tneumann@users.sourceforge.net>
>     Tested-by: Thomas Neumann <tneumann@users.sourceforge.net>
>     Reviewed-by: Alex Elder <aelder@sgi.com>
>     Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 2d0b3e1da9e6..6f83f58c099f 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -611,7 +611,7 @@ xfs_fs_log_dummy(
>  	xfs_inode_t	*ip;
>  	int		error;
>  
> -	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
> +	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP);
>  	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
>  	if (error) {
>  		xfs_trans_cancel(tp, 0);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 67ae5555a30a..7294abce6ef2 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -860,8 +860,15 @@ xfs_iomap_write_unwritten(
>  		 * set up a transaction to convert the range of extents
>  		 * from unwritten to real. Do allocations in a loop until
>  		 * we have covered the range passed in.
> +		 *
> +		 * Note that we open code the transaction allocation here
> +		 * to pass KM_NOFS--we can't risk to recursing back into
> +		 * the filesystem here as we might be asked to write out
> +		 * the same inode that we complete here and might deadlock
> +		 * on the iolock.
>  		 */
> -		tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
> +		xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> +		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
>  		tp->t_flags |= XFS_TRANS_RESERVE;
>  		error = xfs_trans_reserve(tp, resblks,
>  				XFS_WRITE_LOG_RES(mp), 0,
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 8b6c9e807efb..4d509f742bd2 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1471,7 +1471,7 @@ xfs_log_sbcount(
>  	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
>  		return 0;
>  
> -	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT);
> +	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
>  	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
>  					XFS_DEFAULT_LOG_COUNT);
>  	if (error) {
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 66b849358e62..237badcbac3b 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -236,19 +236,20 @@ xfs_trans_alloc(
>  	uint		type)
>  {
>  	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> -	return _xfs_trans_alloc(mp, type);
> +	return _xfs_trans_alloc(mp, type, KM_SLEEP);
>  }
>  
>  xfs_trans_t *
>  _xfs_trans_alloc(
>  	xfs_mount_t	*mp,
> -	uint		type)
> +	uint		type,
> +	uint		memflags)
>  {
>  	xfs_trans_t	*tp;
>  
>  	atomic_inc(&mp->m_active_trans);
>  
> -	tp = kmem_zone_zalloc(xfs_trans_zone, KM_SLEEP);
> +	tp = kmem_zone_zalloc(xfs_trans_zone, memflags);
>  	tp->t_magic = XFS_TRANS_MAGIC;
>  	tp->t_type = type;
>  	tp->t_mountp = mp;
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index ed47fc77759c..a0574f593f52 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -924,7 +924,7 @@ typedef struct xfs_trans {
>   * XFS transaction mechanism exported interfaces.
>   */
>  xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
> -xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint);
> +xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint);
>  xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
>  int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
>  				  uint, uint);
