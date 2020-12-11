Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A97C4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 09:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D1723F36
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Dec 2020 09:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405593AbgLKJYT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Dec 2020 04:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405592AbgLKJXy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Dec 2020 04:23:54 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFFAC06179C
        for <linux-xfs@vger.kernel.org>; Fri, 11 Dec 2020 01:22:43 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id p6so4296453plo.6
        for <linux-xfs@vger.kernel.org>; Fri, 11 Dec 2020 01:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=piiXfIXgdNVp9OFBZD1gr2OLPhWAfZPLPmxKji7NJxY=;
        b=SHvP0/30ZlGGU/wrrtUoCWeyT9gHVG4+G3gVx+zwAuyVyTK8tuQUcqUUqyRn+jBulC
         Sacm5u8zSUlp9xmVc/RuMbTZI3drRP0OEDs0FnUnHS2ELRCz+ah2nF5ci+mCHk2+1Ioh
         btPn73bEv/SZyXxF2PlyaG4DagFWPv2HARpB7rolqfF5aO6UxUxJFpC+C0M0E7EgQSK1
         Q2nMLHHz0C/eGeI2EippKZuCfc77A+VgglmRqz8fN1V0MDaHMikgJxGrzkyFi20Na7A3
         8J4ylU3Ikep/VLEgUqwIILT+SDeCiygtUVD/mEoJ8YI6885hF52IyAXWeQV9BltgP7yv
         i5xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=piiXfIXgdNVp9OFBZD1gr2OLPhWAfZPLPmxKji7NJxY=;
        b=kbvSbeb3tDgOAE153xAuGkrT2VM5SRqQPprTbvWrXSPytqsa8Pz/OUqon/gWf7AQU8
         xlT68wr5KYjWBpSaL5Yauqe1JZ8hGAnkDN7kY1+vYwfr2yr1aRUKCZLuCI0PdxBiAQk8
         gwm1GcAnU3SkcSvRU+cDaHtNEsyloHDsUhMOoTlxomFhg9lPdQfCtAlpNxr1VJlBk1re
         uExYPQFt17cv7ko/jA7DaoamXmKkodh1u895gHnXIwUmRBEjazIR8woThIZ7t/LsFxMg
         MYC2CHSJ49iEZwlxrORR1vBBQgwmnmVY1z9ibEEEPRtCX58YaNHhrM0Q2rm+WaEDcYF1
         cNYA==
X-Gm-Message-State: AOAM532Fmql+5lGFTSm+rA8GYUn+qavWImv5ikaHFHq5HKjvztJJgpcl
        ryoA+ol5+i4a+UzE9HNiGJw=
X-Google-Smtp-Source: ABdhPJwJF9j3TLfu4yAliM3mJLhbnLa+rSYI7kgptz0OXFqZv6SYKS/1lXLw5ToxWPnqjgNZKIhJ6Q==
X-Received: by 2002:a17:902:7001:b029:da:bbb6:c7e2 with SMTP id y1-20020a1709027001b02900dabbb6c7e2mr10196907plk.50.1607678562987;
        Fri, 11 Dec 2020 01:22:42 -0800 (PST)
Received: from garuda.localnet ([122.167.39.189])
        by smtp.gmail.com with ESMTPSA id s21sm9554503pgk.52.2020.12.11.01.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 01:22:42 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: rename xfs_wait_buftarg() to xfs_buftarg_drain()
Date:   Fri, 11 Dec 2020 14:52:39 +0530
Message-ID: <1854967.ZGscP5OW6Q@garuda>
In-Reply-To: <20201210144607.1922026-2-bfoster@redhat.com>
References: <20201210144607.1922026-1-bfoster@redhat.com> <20201210144607.1922026-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 10 Dec 2020 09:46:06 -0500, Brian Foster wrote:
> xfs_wait_buftarg() is vaguely named and somewhat overloaded. Its
> primary purpose is to reclaim all buffers from the provided buffer
> target LRU. In preparation to refactor xfs_wait_buftarg() into
> serialization and LRU draining components, rename the function and
> associated helpers to something more descriptive. This patch has no
> functional changes with the minor exception of renaming a
> tracepoint.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Brian Foster <bfoster@redhat.com>
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
> 


-- 
chandan



