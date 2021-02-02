Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBC8C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 20:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF8964E4A
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 20:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhBBU0D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 15:26:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233225AbhBBUYM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 15:24:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 564F164E4A;
        Tue,  2 Feb 2021 20:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612297411;
        bh=escaI3pq/sTxSP13AtNsARIbdO1h7N9gKgT196oVGOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y3VcJvKuL9zDTpYHij1uxgy3ORZSPRHAcZWyOQr/O4V2zKPFbb6mfAvpWaL+oLNz1
         5i8son11q809Kw+u69Dw47PbQbaIVaWq48Q/89yNnNUsSREK/f3dIKInaWT0e8jwUd
         scE8bFMn4XTLfl1XXpcoW2uQFag7V+NcWK8ToExKVPcRP8j6VDATYs3581hllQ34zv
         TKUmV0gFJc8xYKNcbpoSa4RO7ZuajUAmD2fEl1uF2M2JbzKjMGnKyhq044Y57kuaF1
         J46tSK1K3+Hs1I/z+AuyDbOK48YI7XvzZLsiXy08/hl05+sRgWD2UM1d3+BwNd5fs9
         kfuCeKc+HyBuQ==
Date:   Tue, 2 Feb 2021 12:23:30 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: rename xfs_wait_buftarg() to xfs_buftarg_drain()
Message-ID: <20210202202330.GS7193@magnolia>
References: <20201210144607.1922026-1-bfoster@redhat.com>
 <20201210144607.1922026-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210144607.1922026-2-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 10, 2020 at 09:46:06AM -0500, Brian Foster wrote:
> xfs_wait_buftarg() is vaguely named and somewhat overloaded. Its
> primary purpose is to reclaim all buffers from the provided buffer
> target LRU. In preparation to refactor xfs_wait_buftarg() into
> serialization and LRU draining components, rename the function and
> associated helpers to something more descriptive. This patch has no
> functional changes with the minor exception of renaming a
> tracepoint.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Hmmm, I guess my RVB never made it to the list...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c   | 12 ++++++------
>  fs/xfs/xfs_buf.h   | 10 +++++-----
>  fs/xfs/xfs_log.c   |  6 +++---
>  fs/xfs/xfs_mount.c |  4 ++--
>  fs/xfs/xfs_trace.h |  2 +-
>  5 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 4e4cf91f4f9f..db918ed20c40 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -43,7 +43,7 @@ static kmem_zone_t *xfs_buf_zone;
>   *	  pag_buf_lock
>   *	    lru_lock
>   *
> - * xfs_buftarg_wait_rele
> + * xfs_buftarg_drain_rele
>   *	lru_lock
>   *	  b_lock (trylock due to inversion)
>   *
> @@ -88,7 +88,7 @@ xfs_buf_vmap_len(
>   * because the corresponding decrement is deferred to buffer release. Buffers
>   * can undergo I/O multiple times in a hold-release cycle and per buffer I/O
>   * tracking adds unnecessary overhead. This is used for sychronization purposes
> - * with unmount (see xfs_wait_buftarg()), so all we really need is a count of
> + * with unmount (see xfs_buftarg_drain()), so all we really need is a count of
>   * in-flight buffers.
>   *
>   * Buffers that are never released (e.g., superblock, iclog buffers) must set
> @@ -1786,7 +1786,7 @@ __xfs_buf_mark_corrupt(
>   * while freeing all the buffers only held by the LRU.
>   */
>  static enum lru_status
> -xfs_buftarg_wait_rele(
> +xfs_buftarg_drain_rele(
>  	struct list_head	*item,
>  	struct list_lru_one	*lru,
>  	spinlock_t		*lru_lock,
> @@ -1798,7 +1798,7 @@ xfs_buftarg_wait_rele(
>  
>  	if (atomic_read(&bp->b_hold) > 1) {
>  		/* need to wait, so skip it this pass */
> -		trace_xfs_buf_wait_buftarg(bp, _RET_IP_);
> +		trace_xfs_buf_drain_buftarg(bp, _RET_IP_);
>  		return LRU_SKIP;
>  	}
>  	if (!spin_trylock(&bp->b_lock))
> @@ -1816,7 +1816,7 @@ xfs_buftarg_wait_rele(
>  }
>  
>  void
> -xfs_wait_buftarg(
> +xfs_buftarg_drain(
>  	struct xfs_buftarg	*btp)
>  {
>  	LIST_HEAD(dispose);
> @@ -1841,7 +1841,7 @@ xfs_wait_buftarg(
>  
>  	/* loop until there is nothing left on the lru list. */
>  	while (list_lru_count(&btp->bt_lru)) {
> -		list_lru_walk(&btp->bt_lru, xfs_buftarg_wait_rele,
> +		list_lru_walk(&btp->bt_lru, xfs_buftarg_drain_rele,
>  			      &dispose, LONG_MAX);
>  
>  		while (!list_empty(&dispose)) {
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index bfd2907e7bc4..ea32369f8f77 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -152,7 +152,7 @@ typedef struct xfs_buf {
>  	struct list_head	b_list;
>  	struct xfs_perag	*b_pag;		/* contains rbtree root */
>  	struct xfs_mount	*b_mount;
> -	xfs_buftarg_t		*b_target;	/* buffer target (device) */
> +	struct xfs_buftarg	*b_target;	/* buffer target (device) */
>  	void			*b_addr;	/* virtual address of buffer */
>  	struct work_struct	b_ioend_work;
>  	struct completion	b_iowait;	/* queue for I/O waiters */
> @@ -344,11 +344,11 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  /*
>   *	Handling of buftargs.
>   */
> -extern xfs_buftarg_t *xfs_alloc_buftarg(struct xfs_mount *,
> -			struct block_device *, struct dax_device *);
> +extern struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *,
> +		struct block_device *, struct dax_device *);
>  extern void xfs_free_buftarg(struct xfs_buftarg *);
> -extern void xfs_wait_buftarg(xfs_buftarg_t *);
> -extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
> +extern void xfs_buftarg_drain(struct xfs_buftarg *);
> +extern int xfs_setsize_buftarg(struct xfs_buftarg *, unsigned int);
>  
>  #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
>  #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fa2d05e65ff1..5ad4d5e78019 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -741,7 +741,7 @@ xfs_log_mount_finish(
>  		xfs_log_force(mp, XFS_LOG_SYNC);
>  		xfs_ail_push_all_sync(mp->m_ail);
>  	}
> -	xfs_wait_buftarg(mp->m_ddev_targp);
> +	xfs_buftarg_drain(mp->m_ddev_targp);
>  
>  	if (readonly)
>  		mp->m_flags |= XFS_MOUNT_RDONLY;
> @@ -936,13 +936,13 @@ xfs_log_quiesce(
>  
>  	/*
>  	 * The superblock buffer is uncached and while xfs_ail_push_all_sync()
> -	 * will push it, xfs_wait_buftarg() will not wait for it. Further,
> +	 * will push it, xfs_buftarg_drain() will not wait for it. Further,
>  	 * xfs_buf_iowait() cannot be used because it was pushed with the
>  	 * XBF_ASYNC flag set, so we need to use a lock/unlock pair to wait for
>  	 * the IO to complete.
>  	 */
>  	xfs_ail_push_all_sync(mp->m_ail);
> -	xfs_wait_buftarg(mp->m_ddev_targp);
> +	xfs_buftarg_drain(mp->m_ddev_targp);
>  	xfs_buf_lock(mp->m_sb_bp);
>  	xfs_buf_unlock(mp->m_sb_bp);
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 7110507a2b6b..29a553f0877d 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1023,8 +1023,8 @@ xfs_mountfs(
>  	xfs_log_mount_cancel(mp);
>   out_fail_wait:
>  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
> -		xfs_wait_buftarg(mp->m_logdev_targp);
> -	xfs_wait_buftarg(mp->m_ddev_targp);
> +		xfs_buftarg_drain(mp->m_logdev_targp);
> +	xfs_buftarg_drain(mp->m_ddev_targp);
>   out_free_perag:
>  	xfs_free_perag(mp);
>   out_free_dir:
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 86951652d3ed..7b4d8a5f2a49 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -340,7 +340,7 @@ DEFINE_BUF_EVENT(xfs_buf_get_uncached);
>  DEFINE_BUF_EVENT(xfs_buf_item_relse);
>  DEFINE_BUF_EVENT(xfs_buf_iodone_async);
>  DEFINE_BUF_EVENT(xfs_buf_error_relse);
> -DEFINE_BUF_EVENT(xfs_buf_wait_buftarg);
> +DEFINE_BUF_EVENT(xfs_buf_drain_buftarg);
>  DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
>  
>  /* not really buffer traces, but the buf provides useful information */
> -- 
> 2.26.2
> 
