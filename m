Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:44538 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbeAYIk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 03:40:28 -0500
Received: by mail-wm0-f65.google.com with SMTP id t74so13146137wme.3
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jan 2018 00:40:27 -0800 (PST)
Date: Thu, 25 Jan 2018 09:40:24 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/3] Split buffer's b_fspriv field
Message-ID: <20180125084024.vu5ckic3zokim4zk@odin.usersys.redhat.com>
References: <20180124084736.17411-1-cmaiolino@redhat.com>
 <20180124084736.17411-3-cmaiolino@redhat.com>
 <20180124214932.GC9068@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180124214932.GC9068@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> > @@ -1052,9 +1051,19 @@ STATIC void
> >  xfs_buf_do_callbacks_fail(
> >  	struct xfs_buf		*bp)
> >  {
> > +	struct xfs_log_item	*lip = bp->b_li_list;
> >  	struct xfs_log_item	*next;
> > -	struct xfs_log_item	*lip = bp->b_fspriv;
> > -	struct xfs_ail		*ailp = lip->li_ailp;
> > +	struct xfs_ail		*ailp;
> > +
> > +	/*
> > +	 * Buffer log item errors are handled directly by xfs_buf_item_push()
> > +	 * and xfs_buf_iodone_callback_error, and they have no IO error
> > +	 * callbacks. Check only for items in b_li_list.
> > +	 */
> > +	if (lip == NULL)
> > +		return;
> > +	else
> > +		ailp = lip->li_ailp;
> 
> I still think you could do:
> 
> if (lip == NULL)
> 	return;
> 
> ailp = lip->li_ailp;
> spin_lock(...);
> 
> here, but rather than blather over formatting I'll just fix it on its
> way in.

Your call, although I wonder if it's necessary, this chunk is going away on next
patch anyway. But I have no objections in changing it anyway.

Cheers

> 
> --D
> 
> >  
> >  	spin_lock(&ailp->xa_lock);
> >  	for (; lip; lip = next) {
> > @@ -1069,12 +1078,23 @@ static bool
> >  xfs_buf_iodone_callback_error(
> >  	struct xfs_buf		*bp)
> >  {
> > -	struct xfs_log_item	*lip = bp->b_fspriv;
> > -	struct xfs_mount	*mp = lip->li_mountp;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> > +	struct xfs_log_item	*lip = bp->b_li_list;
> > +	struct xfs_mount	*mp;
> >  	static ulong		lasttime;
> >  	static xfs_buftarg_t	*lasttarg;
> >  	struct xfs_error_cfg	*cfg;
> >  
> > +	/*
> > +	 * The failed buffer might not have a buf_log_item attached or the
> > +	 * log_item list might be empty. Get the mp from the available
> > +	 * xfs_log_item
> > +	 */
> > +	if (bip == NULL)
> > +		mp = lip->li_mountp;
> > +	else
> > +		mp = bip->bli_item.li_mountp;
> > +
> >  	/*
> >  	 * If we've already decided to shutdown the filesystem because of
> >  	 * I/O errors, there's no point in giving this a retry.
> > @@ -1183,7 +1203,8 @@ xfs_buf_iodone_callbacks(
> >  	bp->b_first_retry_time = 0;
> >  
> >  	xfs_buf_do_callbacks(bp);
> > -	bp->b_fspriv = NULL;
> > +	bp->b_log_item = NULL;
> > +	bp->b_li_list = NULL;
> >  	bp->b_iodone = NULL;
> >  	xfs_buf_ioend(bp);
> >  }
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c9e40d4fc939..8a3ff6343d91 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2272,7 +2272,7 @@ xfs_ifree_cluster(
> >  		 * stale first, we will not attempt to lock them in the loop
> >  		 * below as the XFS_ISTALE flag will be set.
> >  		 */
> > -		lip = bp->b_fspriv;
> > +		lip = bp->b_li_list;
> >  		while (lip) {
> >  			if (lip->li_type == XFS_LI_INODE) {
> >  				iip = (xfs_inode_log_item_t *)lip;
> > @@ -3649,7 +3649,7 @@ xfs_iflush_int(
> >  	/* generate the checksum. */
> >  	xfs_dinode_calc_crc(mp, dip);
> >  
> > -	ASSERT(bp->b_fspriv != NULL);
> > +	ASSERT(bp->b_li_list != NULL);
> >  	ASSERT(bp->b_iodone != NULL);
> >  	return 0;
> >  
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 6ee5c3bf19ad..993736032b4b 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -722,7 +722,7 @@ xfs_iflush_done(
> >  	 * Scan the buffer IO completions for other inodes being completed and
> >  	 * attach them to the current inode log item.
> >  	 */
> > -	blip = bp->b_fspriv;
> > +	blip = bp->b_li_list;
> >  	prev = NULL;
> >  	while (blip != NULL) {
> >  		if (blip->li_cb != xfs_iflush_done) {
> > @@ -734,7 +734,7 @@ xfs_iflush_done(
> >  		/* remove from list */
> >  		next = blip->li_bio_list;
> >  		if (!prev) {
> > -			bp->b_fspriv = next;
> > +			bp->b_li_list = next;
> >  		} else {
> >  			prev->li_bio_list = next;
> >  		}
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index c1f266c34af7..20483b654ef1 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1242,7 +1242,7 @@ xlog_space_left(
> >  static void
> >  xlog_iodone(xfs_buf_t *bp)
> >  {
> > -	struct xlog_in_core	*iclog = bp->b_fspriv;
> > +	struct xlog_in_core	*iclog = bp->b_log_item;
> >  	struct xlog		*l = iclog->ic_log;
> >  	int			aborted = 0;
> >  
> > @@ -1773,7 +1773,7 @@ STATIC int
> >  xlog_bdstrat(
> >  	struct xfs_buf		*bp)
> >  {
> > -	struct xlog_in_core	*iclog = bp->b_fspriv;
> > +	struct xlog_in_core	*iclog = bp->b_log_item;
> >  
> >  	xfs_buf_lock(bp);
> >  	if (iclog->ic_state & XLOG_STATE_IOERROR) {
> > @@ -1919,7 +1919,7 @@ xlog_sync(
> >  	}
> >  
> >  	bp->b_io_length = BTOBB(count);
> > -	bp->b_fspriv = iclog;
> > +	bp->b_log_item = iclog;
> >  	bp->b_flags &= ~XBF_FLUSH;
> >  	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
> >  
> > @@ -1958,7 +1958,7 @@ xlog_sync(
> >  		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
> >  		xfs_buf_associate_memory(bp,
> >  				(char *)&iclog->ic_header + count, split);
> > -		bp->b_fspriv = iclog;
> > +		bp->b_log_item = iclog;
> >  		bp->b_flags &= ~XBF_FLUSH;
> >  		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
> >  
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index d864380b6575..00240c9ee72e 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -400,9 +400,9 @@ xlog_recover_iodone(
> >  	 * On v5 supers, a bli could be attached to update the metadata LSN.
> >  	 * Clean it up.
> >  	 */
> > -	if (bp->b_fspriv)
> > +	if (bp->b_log_item)
> >  		xfs_buf_item_relse(bp);
> > -	ASSERT(bp->b_fspriv == NULL);
> > +	ASSERT(bp->b_log_item == NULL);
> >  
> >  	bp->b_iodone = NULL;
> >  	xfs_buf_ioend(bp);
> > @@ -2630,7 +2630,7 @@ xlog_recover_validate_buf_type(
> >  		ASSERT(!bp->b_iodone || bp->b_iodone == xlog_recover_iodone);
> >  		bp->b_iodone = xlog_recover_iodone;
> >  		xfs_buf_item_init(bp, mp);
> > -		bip = bp->b_fspriv;
> > +		bip = bp->b_log_item;
> >  		bip->bli_item.li_lsn = current_lsn;
> >  	}
> >  }
> > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > index 74563cd2970c..653ce379d36b 100644
> > --- a/fs/xfs/xfs_trans_buf.c
> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -82,12 +82,12 @@ _xfs_trans_bjoin(
> >  	ASSERT(bp->b_transp == NULL);
> >  
> >  	/*
> > -	 * The xfs_buf_log_item pointer is stored in b_fsprivate.  If
> > +	 * The xfs_buf_log_item pointer is stored in b_log_item.  If
> >  	 * it doesn't have one yet, then allocate one and initialize it.
> >  	 * The checks to see if one is there are in xfs_buf_item_init().
> >  	 */
> >  	xfs_buf_item_init(bp, tp->t_mountp);
> > -	bip = bp->b_fspriv;
> > +	bip = bp->b_log_item;
> >  	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
> >  	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> >  	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
> > @@ -118,7 +118,7 @@ xfs_trans_bjoin(
> >  	struct xfs_buf		*bp)
> >  {
> >  	_xfs_trans_bjoin(tp, bp, 0);
> > -	trace_xfs_trans_bjoin(bp->b_fspriv);
> > +	trace_xfs_trans_bjoin(bp->b_log_item);
> >  }
> >  
> >  /*
> > @@ -159,7 +159,7 @@ xfs_trans_get_buf_map(
> >  		}
> >  
> >  		ASSERT(bp->b_transp == tp);
> > -		bip = bp->b_fspriv;
> > +		bip = bp->b_log_item;
> >  		ASSERT(bip != NULL);
> >  		ASSERT(atomic_read(&bip->bli_refcount) > 0);
> >  		bip->bli_recur++;
> > @@ -175,7 +175,7 @@ xfs_trans_get_buf_map(
> >  	ASSERT(!bp->b_error);
> >  
> >  	_xfs_trans_bjoin(tp, bp, 1);
> > -	trace_xfs_trans_get_buf(bp->b_fspriv);
> > +	trace_xfs_trans_get_buf(bp->b_log_item);
> >  	return bp;
> >  }
> >  
> > @@ -211,7 +211,7 @@ xfs_trans_getsb(
> >  	 */
> >  	bp = mp->m_sb_bp;
> >  	if (bp->b_transp == tp) {
> > -		bip = bp->b_fspriv;
> > +		bip = bp->b_log_item;
> >  		ASSERT(bip != NULL);
> >  		ASSERT(atomic_read(&bip->bli_refcount) > 0);
> >  		bip->bli_recur++;
> > @@ -224,7 +224,7 @@ xfs_trans_getsb(
> >  		return NULL;
> >  
> >  	_xfs_trans_bjoin(tp, bp, 1);
> > -	trace_xfs_trans_getsb(bp->b_fspriv);
> > +	trace_xfs_trans_getsb(bp->b_log_item);
> >  	return bp;
> >  }
> >  
> > @@ -267,7 +267,7 @@ xfs_trans_read_buf_map(
> >  	if (bp) {
> >  		ASSERT(xfs_buf_islocked(bp));
> >  		ASSERT(bp->b_transp == tp);
> > -		ASSERT(bp->b_fspriv != NULL);
> > +		ASSERT(bp->b_log_item != NULL);
> >  		ASSERT(!bp->b_error);
> >  		ASSERT(bp->b_flags & XBF_DONE);
> >  
> > @@ -280,7 +280,7 @@ xfs_trans_read_buf_map(
> >  			return -EIO;
> >  		}
> >  
> > -		bip = bp->b_fspriv;
> > +		bip = bp->b_log_item;
> >  		bip->bli_recur++;
> >  
> >  		ASSERT(atomic_read(&bip->bli_refcount) > 0);
> > @@ -330,7 +330,7 @@ xfs_trans_read_buf_map(
> >  
> >  	if (tp) {
> >  		_xfs_trans_bjoin(tp, bp, 1);
> > -		trace_xfs_trans_read_buf(bp->b_fspriv);
> > +		trace_xfs_trans_read_buf(bp->b_log_item);
> >  	}
> >  	*bpp = bp;
> >  	return 0;
> > @@ -370,7 +370,7 @@ xfs_trans_brelse(
> >  	}
> >  
> >  	ASSERT(bp->b_transp == tp);
> > -	bip = bp->b_fspriv;
> > +	bip = bp->b_log_item;
> >  	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
> >  	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
> >  	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> > @@ -462,7 +462,7 @@ xfs_trans_bhold(
> >  	xfs_trans_t		*tp,
> >  	xfs_buf_t		*bp)
> >  {
> > -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  
> >  	ASSERT(bp->b_transp == tp);
> >  	ASSERT(bip != NULL);
> > @@ -483,7 +483,7 @@ xfs_trans_bhold_release(
> >  	xfs_trans_t		*tp,
> >  	xfs_buf_t		*bp)
> >  {
> > -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  
> >  	ASSERT(bp->b_transp == tp);
> >  	ASSERT(bip != NULL);
> > @@ -504,7 +504,7 @@ xfs_trans_dirty_buf(
> >  	struct xfs_trans	*tp,
> >  	struct xfs_buf		*bp)
> >  {
> > -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  
> >  	ASSERT(bp->b_transp == tp);
> >  	ASSERT(bip != NULL);
> > @@ -561,7 +561,7 @@ xfs_trans_log_buf(
> >  	uint			first,
> >  	uint			last)
> >  {
> > -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  
> >  	ASSERT(first <= last && last < BBTOB(bp->b_length));
> >  	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED));
> > @@ -607,7 +607,7 @@ xfs_trans_binval(
> >  	xfs_trans_t		*tp,
> >  	xfs_buf_t		*bp)
> >  {
> > -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  	int			i;
> >  
> >  	ASSERT(bp->b_transp == tp);
> > @@ -662,7 +662,7 @@ xfs_trans_inode_buf(
> >  	xfs_trans_t		*tp,
> >  	xfs_buf_t		*bp)
> >  {
> > -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  
> >  	ASSERT(bp->b_transp == tp);
> >  	ASSERT(bip != NULL);
> > @@ -686,7 +686,7 @@ xfs_trans_stale_inode_buf(
> >  	xfs_trans_t		*tp,
> >  	xfs_buf_t		*bp)
> >  {
> > -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  
> >  	ASSERT(bp->b_transp == tp);
> >  	ASSERT(bip != NULL);
> > @@ -711,7 +711,7 @@ xfs_trans_inode_alloc_buf(
> >  	xfs_trans_t		*tp,
> >  	xfs_buf_t		*bp)
> >  {
> > -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  
> >  	ASSERT(bp->b_transp == tp);
> >  	ASSERT(bip != NULL);
> > @@ -733,7 +733,7 @@ xfs_trans_ordered_buf(
> >  	struct xfs_trans	*tp,
> >  	struct xfs_buf		*bp)
> >  {
> > -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  
> >  	ASSERT(bp->b_transp == tp);
> >  	ASSERT(bip != NULL);
> > @@ -763,7 +763,7 @@ xfs_trans_buf_set_type(
> >  	struct xfs_buf		*bp,
> >  	enum xfs_blft		type)
> >  {
> > -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  
> >  	if (!tp)
> >  		return;
> > @@ -780,8 +780,8 @@ xfs_trans_buf_copy_type(
> >  	struct xfs_buf		*dst_bp,
> >  	struct xfs_buf		*src_bp)
> >  {
> > -	struct xfs_buf_log_item	*sbip = src_bp->b_fspriv;
> > -	struct xfs_buf_log_item	*dbip = dst_bp->b_fspriv;
> > +	struct xfs_buf_log_item	*sbip = src_bp->b_log_item;
> > +	struct xfs_buf_log_item	*dbip = dst_bp->b_log_item;
> >  	enum xfs_blft		type;
> >  
> >  	type = xfs_blft_from_flags(&sbip->__bli_format);
> > @@ -805,7 +805,7 @@ xfs_trans_dquot_buf(
> >  	xfs_buf_t		*bp,
> >  	uint			type)
> >  {
> > -	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> > +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  
> >  	ASSERT(type == XFS_BLF_UDQUOT_BUF ||
> >  	       type == XFS_BLF_PDQUOT_BUF ||
> > -- 
> > 2.14.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
