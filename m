Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750808AbdBCQWj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 11:22:39 -0500
Date: Fri, 3 Feb 2017 11:22:38 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: don't block the log commit handler for discards
Message-ID: <20170203162237.GE45388@bfoster.bfoster>
References: <1485715421-17182-1-git-send-email-hch@lst.de>
 <1485715421-17182-5-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485715421-17182-5-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Jan 29, 2017 at 07:43:41PM +0100, Christoph Hellwig wrote:
> Instead we submit the discard requests and use another workqueue to
> release the extents from the extent busy list.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_discard.c  | 29 ------------------
>  fs/xfs/xfs_discard.h  |  1 -
>  fs/xfs/xfs_log_cil.c  | 84 ++++++++++++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_log_priv.h |  1 +
>  fs/xfs/xfs_mount.c    |  1 +
>  fs/xfs/xfs_super.c    |  8 +++++
>  fs/xfs/xfs_super.h    |  2 ++
>  7 files changed, 88 insertions(+), 38 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 4e9feb1..7a74c9f 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1057,6 +1057,7 @@ xfs_unmountfs(
>  	cancel_delayed_work_sync(&mp->m_cowblocks_work);
>  
>  	xfs_fs_unreserve_ag_blocks(mp);
> +	flush_workqueue(xfs_discard_wq);

Shouldn't this happen after we force the log?

Also, now that discards are async with respect to log flush, what
prevents breaking down the fs completely before we ever get a reply from
disk? E.g., don't we have to wait on in-flight discards before we bother
to wait on the wq?

Brian

>  	xfs_qm_unmount_quotas(mp);
>  	xfs_rtunmount_inodes(mp);
>  	IRELE(mp->m_rootip);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d894ed0..ca05fb0 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1957,12 +1957,20 @@ xfs_init_workqueues(void)
>  	if (!xfs_alloc_wq)
>  		return -ENOMEM;
>  
> +	xfs_discard_wq = alloc_workqueue("xfsdiscard", WQ_UNBOUND, 0);
> +	if (!xfs_discard_wq)
> +		goto out_free_alloc_wq;
> +
>  	return 0;
> +out_free_alloc_wq:
> +	destroy_workqueue(xfs_alloc_wq);
> +	return -ENOMEM;
>  }
>  
>  STATIC void
>  xfs_destroy_workqueues(void)
>  {
> +	destroy_workqueue(xfs_discard_wq);
>  	destroy_workqueue(xfs_alloc_wq);
>  }
>  
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index b6418ab..5f2f324 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -73,6 +73,8 @@ extern const struct quotactl_ops xfs_quotactl_operations;
>  
>  extern void xfs_reinit_percpu_counters(struct xfs_mount *mp);
>  
> +extern struct workqueue_struct *xfs_discard_wq;
> +
>  #define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
>  
>  #endif	/* __XFS_SUPER_H__ */
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
