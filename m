Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfFNOne (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 10:43:34 -0400
Date: Fri, 14 Jun 2019 10:43:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/20] xfs: remove the iop_push implementation for quota
 off items
Message-ID: <20190614144332.GH26586@bfoster>
References: <20190613180300.30447-1-hch@lst.de>
 <20190613180300.30447-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613180300.30447-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 08:02:45PM +0200, Christoph Hellwig wrote:
> If we want to push the log to make progress on the items we'd need to
> return XFS_ITEM_PINNED instead of XFS_ITEM_LOCKED.  Removing the
> method will do exactly that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Wasn't this one supposed to be dropped?

Brian

>  fs/xfs/xfs_dquot_item.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 486eea151fdb..a61a8a770d7f 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -288,18 +288,6 @@ xfs_qm_qoff_logitem_format(
>  	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_qoff_logitem));
>  }
>  
> -/*
> - * There isn't much you can do to push a quotaoff item.  It is simply
> - * stuck waiting for the log to be flushed to disk.
> - */
> -STATIC uint
> -xfs_qm_qoff_logitem_push(
> -	struct xfs_log_item	*lip,
> -	struct list_head	*buffer_list)
> -{
> -	return XFS_ITEM_LOCKED;
> -}
> -
>  STATIC xfs_lsn_t
>  xfs_qm_qoffend_logitem_committed(
>  	struct xfs_log_item	*lip,
> @@ -327,7 +315,6 @@ static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
>  	.iop_size	= xfs_qm_qoff_logitem_size,
>  	.iop_format	= xfs_qm_qoff_logitem_format,
>  	.iop_committed	= xfs_qm_qoffend_logitem_committed,
> -	.iop_push	= xfs_qm_qoff_logitem_push,
>  };
>  
>  /*
> @@ -336,7 +323,6 @@ static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
>  static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
>  	.iop_size	= xfs_qm_qoff_logitem_size,
>  	.iop_format	= xfs_qm_qoff_logitem_format,
> -	.iop_push	= xfs_qm_qoff_logitem_push,
>  };
>  
>  /*
> -- 
> 2.20.1
> 
