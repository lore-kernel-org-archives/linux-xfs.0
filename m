Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68AEC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 22:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiCUWxX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 18:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiCUWxQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 18:53:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737D83CCCC8
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 15:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44D02B81A70
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 21:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E077CC340F0;
        Mon, 21 Mar 2022 21:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899781;
        bh=qx9K+B1KyilX2uuGdsZKcH3fKEAHWpzzpAUODobqgL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fLvNNGWZEHBVB94AcCl0Ov1tUR+Ti+QDWxO835iVi3+YZj2qMIY5PkXY8xreNFqyF
         H7IbV5SLZcCNL8pzi4DaZ88KSJizjB6t1LVx3wj8SGs5eKJGq+p2dfEkTUK1gOm/K+
         QcSpCcDv7hWBaXuStKDaZphHYf0Nla9wdid5y9jFk4aCokrUb9NtYHErWxQTwtcBtY
         PdFdoeTCrENIwxvgSpXP68MNlKIs6odq2TMqu3EXzqmCJo0Nr5wCpldbLJGUF1fj0w
         BhMX9jTDN53Rxpeivc6OOgi7aB2Sv49VaM7bk5DoL5mTHMYFrLr3xVC5nf02t+4qrQ
         0Si4nGh7a+mKw==
Date:   Mon, 21 Mar 2022 14:56:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: aborting inodes on shutdown may need buffer lock
Message-ID: <20220321215620.GL8224@magnolia>
References: <20220321012329.376307-1-david@fromorbit.com>
 <20220321012329.376307-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321012329.376307-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 12:23:28PM +1100, Dave Chinner wrote:
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
> ---
>  fs/xfs/xfs_icache.c     |   2 +-
>  fs/xfs/xfs_inode.c      |   2 +-
>  fs/xfs/xfs_inode_item.c | 156 ++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_inode_item.h |   1 +
>  4 files changed, 122 insertions(+), 39 deletions(-)
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
> index aab55a06ece7..07be0992321c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3612,7 +3612,7 @@ xfs_iflush_cluster(
>  
>  	/*
>  	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
> -	 * can remove itself from the list.
> +	 * will remove itself from the list.
>  	 */
>  	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
>  		iip = (struct xfs_inode_log_item *)lip;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 11158fa81a09..79504b721ffe 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -721,17 +721,6 @@ xfs_iflush_ail_updates(
>  		if (INODE_ITEM(lip)->ili_flush_lsn != lip->li_lsn)
>  			continue;
>  
> -		/*
> -		 * dgc: Not sure how this happens, but it happens very
> -		 * occassionaly via generic/388.  xfs_iflush_abort() also
> -		 * silently handles this same "under writeback but not in AIL at
> -		 * shutdown" condition via xfs_trans_ail_delete().
> -		 */
> -		if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> -			ASSERT(xlog_is_shutdown(lip->li_log));
> -			continue;
> -		}
> -
>  		lsn = xfs_ail_delete_one(ailp, lip);
>  		if (!tail_lsn && lsn)
>  			tail_lsn = lsn;
> @@ -834,46 +823,139 @@ xfs_buf_inode_io_fail(
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
> +	 * Capture the associated buffer and lock it if the caller didn't
> +	 * pass us the locked buffer to begin with.
> +	 */
> +	spin_lock(&iip->ili_lock);
> +	bp = iip->ili_item.li_buf;
> +	xfs_iflush_abort_clean(iip);
> +	spin_unlock(&iip->ili_lock);

Is the comment here incorrect?  The _shutdown_abort variant will go
ahead and lock the buffer, but this function does not do that...?

> +
> +	/*
> +	 * Clear the failed bit before removing the item from the AIL so
> +	 * xfs_trans_ail_delete() doesn't try to clear and release the buffer
> +	 * attached to the log item before we are done with it.
> +	 */
> +	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
> +	xfs_trans_ail_delete(&iip->ili_item, 0);
> +
> +	xfs_iflags_clear(ip, XFS_IFLUSHING);
> +
> +	/* we can now release the buffer reference the inode log item held. */
> +	if (bp)
> +		xfs_buf_rele(bp);
> +}
>  
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
> +	 * Got two references to bp. The first will get droped by 

"The first will get dropped by..." (spelling and stgit nagging me about
trailing whitespace)

> +	 * xfs_iflush_abort() when the item is removed from the buffer list, but
> +	 * we can't drop our reference until _abort() returns because we have to
> +	 * unlock the buffer as well. Hence we abort and then unlock and release
> +	 * our reference to the buffer.

...and presumably xfs_iflush_abort will drop the other bp reference at
some point after where we unlocked the inode item, locked the (held)
buffer, and relocked the inode item?

--D

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
