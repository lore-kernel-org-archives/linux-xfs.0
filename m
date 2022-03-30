Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D86C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 01:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241605AbiC3BW6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 21:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241599AbiC3BW5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 21:22:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C59A49913
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 18:21:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21B3EB81AB1
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 01:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C5AC2BBE4;
        Wed, 30 Mar 2022 01:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648603270;
        bh=5rxU8QVU0XnXHAsnArbZEgWDZYzs5CHpw0KTHcQ7UaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V/jihYhpcNzsBUuK/t9ZSW1/dmfocWqg3e0VOisQYTCWuqmm/nvRgPnPG8ljOOqwl
         ocPgD9GZz4tITqL9V9hEiEM5W8HfIDL3NZlXVyZdSRZr/D7FYCoYo9USyqIPRYm9Vs
         ZluTuv8qjZHi/5MlSbGw8yI90HRAZGWvvYdn5VcwHzro8Igzn/ZrNSm7wdLYBczhyy
         EVEPPmbh51i53SDUjMg2VyGvkHaFaiZfbR4sga4LFIqkufodVjzSGsRO2uucFpm0Zq
         5kQ+EmymOCNyyCqlcsFQb9bSe+r2oJIJDaTJIVrvwot4Ct920So+l/39b5p0CCwsW3
         1wXchKdP/8sGA==
Date:   Tue, 29 Mar 2022 18:21:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: aborting inodes on shutdown may need buffer lock
Message-ID: <20220330012110.GH27713@magnolia>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330011048.1311625-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 30, 2022 at 12:10:41PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Most buffer io list operations are run with the bp->b_lock held, but
> xfs_iflush_abort() can be called without the buffer lock being held
> resulting in inodes being removed from the buffer list while other
> list operations are occurring. This causes problems with corrupted
> bp->b_io_list inode lists during filesystem shutdown, leading to
> traversals that never end, double removals from the AIL, etc.
> 
> Fix this by passing the buffer to xfs_iflush_abort() if we have
> it locked. If the inode is attached to the buffer, we're going to
> have to remove it from the buffer list and we'd have to get the
> buffer off the inode log item to do that anyway.
> 
> If we don't have a buffer passed in (e.g. from xfs_reclaim_inode())
> then we can determine if the inode has a log item and if it is
> attached to a buffer before we do anything else. If it does have an
> attached buffer, we can lock it safely (because the inode has a
> reference to it) and then perform the inode abort.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me now.  Overnight tests with the v2 patchset didn't shake
anything loose, so I expect nothing weird will happen with v3.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c     |   2 +-
>  fs/xfs/xfs_inode.c      |   2 +-
>  fs/xfs/xfs_inode_item.c | 162 +++++++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_inode_item.h |   1 +
>  4 files changed, 136 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 4148cdf7ce4a..6c7267451b82 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -883,7 +883,7 @@ xfs_reclaim_inode(
>  	 */
>  	if (xlog_is_shutdown(ip->i_mount->m_log)) {
>  		xfs_iunpin_wait(ip);
> -		xfs_iflush_abort(ip);
> +		xfs_iflush_shutdown_abort(ip);
>  		goto reclaim;
>  	}
>  	if (xfs_ipincount(ip))
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 26227d26f274..9de6205fe134 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3631,7 +3631,7 @@ xfs_iflush_cluster(
>  
>  	/*
>  	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
> -	 * can remove itself from the list.
> +	 * will remove itself from the list.
>  	 */
>  	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
>  		iip = (struct xfs_inode_log_item *)lip;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 11158fa81a09..9e6ef55cf29e 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -544,10 +544,17 @@ xfs_inode_item_push(
>  	uint			rval = XFS_ITEM_SUCCESS;
>  	int			error;
>  
> -	ASSERT(iip->ili_item.li_buf);
> +	if (!bp || (ip->i_flags & XFS_ISTALE)) {
> +		/*
> +		 * Inode item/buffer is being being aborted due to cluster
> +		 * buffer deletion. Trigger a log force to have that operation
> +		 * completed and items removed from the AIL before the next push
> +		 * attempt.
> +		 */
> +		return XFS_ITEM_PINNED;
> +	}
>  
> -	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
> -	    (ip->i_flags & XFS_ISTALE))
> +	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp))
>  		return XFS_ITEM_PINNED;
>  
>  	if (xfs_iflags_test(ip, XFS_IFLUSHING))
> @@ -834,46 +841,143 @@ xfs_buf_inode_io_fail(
>  }
>  
>  /*
> - * This is the inode flushing abort routine.  It is called when
> - * the filesystem is shutting down to clean up the inode state.  It is
> - * responsible for removing the inode item from the AIL if it has not been
> - * re-logged and clearing the inode's flush state.
> + * Clear the inode logging fields so no more flushes are attempted.  If we are
> + * on a buffer list, it is now safe to remove it because the buffer is
> + * guaranteed to be locked. The caller will drop the reference to the buffer
> + * the log item held.
> + */
> +static void
> +xfs_iflush_abort_clean(
> +	struct xfs_inode_log_item *iip)
> +{
> +	iip->ili_last_fields = 0;
> +	iip->ili_fields = 0;
> +	iip->ili_fsync_fields = 0;
> +	iip->ili_flush_lsn = 0;
> +	iip->ili_item.li_buf = NULL;
> +	list_del_init(&iip->ili_item.li_bio_list);
> +}
> +
> +/*
> + * Abort flushing the inode from a context holding the cluster buffer locked.
> + *
> + * This is the normal runtime method of aborting writeback of an inode that is
> + * attached to a cluster buffer. It occurs when the inode and the backing
> + * cluster buffer have been freed (i.e. inode is XFS_ISTALE), or when cluster
> + * flushing or buffer IO completion encounters a log shutdown situation.
> + *
> + * If we need to abort inode writeback and we don't already hold the buffer
> + * locked, call xfs_iflush_shutdown_abort() instead as this should only ever be
> + * necessary in a shutdown situation.
>   */
>  void
>  xfs_iflush_abort(
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_inode_log_item *iip = ip->i_itemp;
> -	struct xfs_buf		*bp = NULL;
> +	struct xfs_buf		*bp;
>  
> -	if (iip) {
> -		/*
> -		 * Clear the failed bit before removing the item from the AIL so
> -		 * xfs_trans_ail_delete() doesn't try to clear and release the
> -		 * buffer attached to the log item before we are done with it.
> -		 */
> -		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
> -		xfs_trans_ail_delete(&iip->ili_item, 0);
> +	if (!iip) {
> +		/* clean inode, nothing to do */
> +		xfs_iflags_clear(ip, XFS_IFLUSHING);
> +		return;
> +	}
> +
> +	/*
> +	 * Remove the inode item from the AIL before we clear its internal
> +	 * state. Whilst the inode is in the AIL, it should have a valid buffer
> +	 * pointer for push operations to access - it is only safe to remove the
> +	 * inode from the buffer once it has been removed from the AIL.
> +	 *
> +	 * We also clear the failed bit before removing the item from the AIL
> +	 * as xfs_trans_ail_delete()->xfs_clear_li_failed() will release buffer
> +	 * references the inode item owns and needs to hold until we've fully
> +	 * aborted the inode log item and detached it from the buffer.
> +	 */
> +	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
> +	xfs_trans_ail_delete(&iip->ili_item, 0);
> +
> +	/*
> +	 * Grab the inode buffer so can we release the reference the inode log
> +	 * item holds on it.
> +	 */
> +	spin_lock(&iip->ili_lock);
> +	bp = iip->ili_item.li_buf;
> +	xfs_iflush_abort_clean(iip);
> +	spin_unlock(&iip->ili_lock);
>  
> +	xfs_iflags_clear(ip, XFS_IFLUSHING);
> +	if (bp)
> +		xfs_buf_rele(bp);
> +}
> +
> +/*
> + * Abort an inode flush in the case of a shutdown filesystem. This can be called
> + * from anywhere with just an inode reference and does not require holding the
> + * inode cluster buffer locked. If the inode is attached to a cluster buffer,
> + * it will grab and lock it safely, then abort the inode flush.
> + */
> +void
> +xfs_iflush_shutdown_abort(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
> +	struct xfs_buf		*bp;
> +
> +	if (!iip) {
> +		/* clean inode, nothing to do */
> +		xfs_iflags_clear(ip, XFS_IFLUSHING);
> +		return;
> +	}
> +
> +	spin_lock(&iip->ili_lock);
> +	bp = iip->ili_item.li_buf;
> +	if (!bp) {
> +		spin_unlock(&iip->ili_lock);
> +		xfs_iflush_abort(ip);
> +		return;
> +	}
> +
> +	/*
> +	 * We have to take a reference to the buffer so that it doesn't get
> +	 * freed when we drop the ili_lock and then wait to lock the buffer.
> +	 * We'll clean up the extra reference after we pick up the ili_lock
> +	 * again.
> +	 */
> +	xfs_buf_hold(bp);
> +	spin_unlock(&iip->ili_lock);
> +	xfs_buf_lock(bp);
> +
> +	spin_lock(&iip->ili_lock);
> +	if (!iip->ili_item.li_buf) {
>  		/*
> -		 * Clear the inode logging fields so no more flushes are
> -		 * attempted.
> +		 * Raced with another removal, hold the only reference
> +		 * to bp now. Inode should not be in the AIL now, so just clean
> +		 * up and return;
>  		 */
> -		spin_lock(&iip->ili_lock);
> -		iip->ili_last_fields = 0;
> -		iip->ili_fields = 0;
> -		iip->ili_fsync_fields = 0;
> -		iip->ili_flush_lsn = 0;
> -		bp = iip->ili_item.li_buf;
> -		iip->ili_item.li_buf = NULL;
> -		list_del_init(&iip->ili_item.li_bio_list);
> +		ASSERT(list_empty(&iip->ili_item.li_bio_list));
> +		ASSERT(!test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags));
> +		xfs_iflush_abort_clean(iip);
>  		spin_unlock(&iip->ili_lock);
> +		xfs_iflags_clear(ip, XFS_IFLUSHING);
> +		xfs_buf_relse(bp);
> +		return;
>  	}
> -	xfs_iflags_clear(ip, XFS_IFLUSHING);
> -	if (bp)
> -		xfs_buf_rele(bp);
> +
> +	/*
> +	 * Got two references to bp. The first will get dropped by
> +	 * xfs_iflush_abort() when the item is removed from the buffer list, but
> +	 * we can't drop our reference until _abort() returns because we have to
> +	 * unlock the buffer as well. Hence we abort and then unlock and release
> +	 * our reference to the buffer.
> +	 */
> +	ASSERT(iip->ili_item.li_buf == bp);
> +	spin_unlock(&iip->ili_lock);
> +	xfs_iflush_abort(ip);
> +	xfs_buf_relse(bp);
>  }
>  
> +
>  /*
>   * convert an xfs_inode_log_format struct from the old 32 bit version
>   * (which can have different field alignments) to the native 64 bit version
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 1a302000d604..bbd836a44ff0 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -44,6 +44,7 @@ static inline int xfs_inode_clean(struct xfs_inode *ip)
>  extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
>  extern void xfs_inode_item_destroy(struct xfs_inode *);
>  extern void xfs_iflush_abort(struct xfs_inode *);
> +extern void xfs_iflush_shutdown_abort(struct xfs_inode *);
>  extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
>  					 struct xfs_inode_log_format *);
>  
> -- 
> 2.35.1
> 
