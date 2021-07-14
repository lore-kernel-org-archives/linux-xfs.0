Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F9AC12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35781613CF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhGNX2w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229666AbhGNX2w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:28:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1D2B60E08;
        Wed, 14 Jul 2021 23:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626305160;
        bh=iMmL/H8mmEXofwaiJEjXwVW2L1DmJp3QDhGqfhOKbwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iYlMpGtlbu4nqRuDaTWSNiddscrtr5FC9i225ymbc34fuZkvopYQZHHxKTHQhrExb
         0n077sU7Tp91BNmDkbUfyZ+/MPqTNP/6OukTiHC4xThZX2SXaXMKmfUZ2QzIeUigd5
         VhTBF012UrQmnzlNfqmrxBsxx62/GIitXrzzDlb7dBgx9huPf31rho2LBTBwg/A5QR
         OP6enVGJnHnH8XcelB9MLjFOYareaRRxXSzms5s5tgPmW2xyATsfmqfEtA43Ckh19p
         J9KrNuvxhq9wGP6IrDlCYy/kwfICBVSYCpfMY3bKFnCOd5z5fOHXWvCwTzSm7YCBlW
         P1L3lOqdrAjdg==
Date:   Wed, 14 Jul 2021 16:25:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: move the CIL workqueue to the CIL
Message-ID: <20210714232559.GK22402@magnolia>
References: <20210714050600.2632218-1-david@fromorbit.com>
 <20210714050600.2632218-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714050600.2632218-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 03:06:00PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We only use the CIL workqueue in the CIL, so it makes no sense to
> hang it off the xfs_mount and have to walk multiple pointers back up
> to the mount when we have the CIL structures right there.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I /had/ wondered about that...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c  | 20 +++++++++++++++++---
>  fs/xfs/xfs_log_priv.h |  1 +
>  fs/xfs/xfs_mount.h    |  1 -
>  fs/xfs/xfs_super.c    | 15 +--------------
>  4 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index ea11d0eea9e8..99e24c75788b 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1134,7 +1134,7 @@ xlog_cil_push_background(
>  	spin_lock(&cil->xc_push_lock);
>  	if (cil->xc_push_seq < cil->xc_current_sequence) {
>  		cil->xc_push_seq = cil->xc_current_sequence;
> -		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_ctx->push_work);
> +		queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
>  	}
>  
>  	/*
> @@ -1200,7 +1200,7 @@ xlog_cil_push_now(
>  
>  	/* start on any pending background push to minimise wait time on it */
>  	if (!async)
> -		flush_workqueue(log->l_mp->m_cil_workqueue);
> +		flush_workqueue(cil->xc_push_wq);
>  
>  	/*
>  	 * If the CIL is empty or we've already pushed the sequence then
> @@ -1214,7 +1214,7 @@ xlog_cil_push_now(
>  
>  	cil->xc_push_seq = push_seq;
>  	cil->xc_push_commit_stable = async;
> -	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_ctx->push_work);
> +	queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
>  	spin_unlock(&cil->xc_push_lock);
>  }
>  
> @@ -1453,6 +1453,15 @@ xlog_cil_init(
>  	cil = kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
>  	if (!cil)
>  		return -ENOMEM;
> +	/*
> +	 * Limit the CIL pipeline depth to 4 concurrent works to bound the
> +	 * concurrency the log spinlocks will be exposed to.
> +	 */
> +	cil->xc_push_wq = alloc_workqueue("xfs-cil/%s",
> +			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
> +			4, log->l_mp->m_super->s_id);
> +	if (!cil->xc_push_wq)
> +		goto out_destroy_cil;
>  
>  	INIT_LIST_HEAD(&cil->xc_cil);
>  	INIT_LIST_HEAD(&cil->xc_committing);
> @@ -1469,6 +1478,10 @@ xlog_cil_init(
>  	xlog_cil_ctx_switch(cil, ctx);
>  
>  	return 0;
> +
> +out_destroy_cil:
> +	kmem_free(cil);
> +	return -ENOMEM;
>  }
>  
>  void
> @@ -1482,6 +1495,7 @@ xlog_cil_destroy(
>  	}
>  
>  	ASSERT(list_empty(&log->l_cilp->xc_cil));
> +	destroy_workqueue(log->l_cilp->xc_push_wq);
>  	kmem_free(log->l_cilp);
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 6ce3b1eda758..2389b1bc95b2 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -264,6 +264,7 @@ struct xfs_cil {
>  	struct xlog		*xc_log;
>  	struct list_head	xc_cil;
>  	spinlock_t		xc_cil_lock;
> +	struct workqueue_struct	*xc_push_wq;
>  
>  	struct rw_semaphore	xc_ctx_lock ____cacheline_aligned_in_smp;
>  	struct xfs_cil_ctx	*xc_ctx;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index c78b63fe779a..752cd93cf46f 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -92,7 +92,6 @@ typedef struct xfs_mount {
>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
>  	struct workqueue_struct *m_buf_workqueue;
>  	struct workqueue_struct	*m_unwritten_workqueue;
> -	struct workqueue_struct	*m_cil_workqueue;
>  	struct workqueue_struct	*m_reclaim_workqueue;
>  	struct workqueue_struct *m_gc_workqueue;
>  	struct workqueue_struct	*m_sync_workqueue;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 10c1b4e43d71..8b7a9895b4a2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -501,21 +501,11 @@ xfs_init_mount_workqueues(
>  	if (!mp->m_unwritten_workqueue)
>  		goto out_destroy_buf;
>  
> -	/*
> -	 * Limit the CIL pipeline depth to 4 concurrent works to bound the
> -	 * concurrency the log spinlocks will be exposed to.
> -	 */
> -	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
> -			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
> -			4, mp->m_super->s_id);
> -	if (!mp->m_cil_workqueue)
> -		goto out_destroy_unwritten;
> -
>  	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
>  			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
>  			0, mp->m_super->s_id);
>  	if (!mp->m_reclaim_workqueue)
> -		goto out_destroy_cil;
> +		goto out_destroy_unwritten;
>  
>  	mp->m_gc_workqueue = alloc_workqueue("xfs-gc/%s",
>  			WQ_SYSFS | WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM,
> @@ -534,8 +524,6 @@ xfs_init_mount_workqueues(
>  	destroy_workqueue(mp->m_gc_workqueue);
>  out_destroy_reclaim:
>  	destroy_workqueue(mp->m_reclaim_workqueue);
> -out_destroy_cil:
> -	destroy_workqueue(mp->m_cil_workqueue);
>  out_destroy_unwritten:
>  	destroy_workqueue(mp->m_unwritten_workqueue);
>  out_destroy_buf:
> @@ -551,7 +539,6 @@ xfs_destroy_mount_workqueues(
>  	destroy_workqueue(mp->m_sync_workqueue);
>  	destroy_workqueue(mp->m_gc_workqueue);
>  	destroy_workqueue(mp->m_reclaim_workqueue);
> -	destroy_workqueue(mp->m_cil_workqueue);
>  	destroy_workqueue(mp->m_unwritten_workqueue);
>  	destroy_workqueue(mp->m_buf_workqueue);
>  }
> -- 
> 2.31.1
> 
