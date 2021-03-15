Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2C1C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 332CD64F0D
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237462AbhCOOlr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 10:41:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236991AbhCOOku (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 10:40:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DImtT1osHw18COx2lmijh06i8lNPB4R7cwYBf3SBVDo=;
        b=ULsosiPRPchK7TZd8bB5Vuv4KG4Axlm+LQTCT5e8ypvB2xRalx+9MKSNwFSHNxIfr6Ccbi
        0cwM1JRALrSOu5UtaxqcoXoBx9pMxysffyVypSo82GVT0l8Jfcw7io7/B4nMyOkygAr451
        HDEkjY4q9rBJ4EiDLxeRejIm/dh+enQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-ADpj11c8P_-k5nl9L3dHwA-1; Mon, 15 Mar 2021 10:40:45 -0400
X-MC-Unique: ADpj11c8P_-k5nl9L3dHwA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCF0983DD2B;
        Mon, 15 Mar 2021 14:40:43 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DD0219727;
        Mon, 15 Mar 2021 14:40:43 +0000 (UTC)
Date:   Mon, 15 Mar 2021 10:40:41 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/45] xfs: remove xfs_blkdev_issue_flush
Message-ID: <YE9x6fwIQhJP5/ev@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-5-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:02PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's a one line wrapper around blkdev_issue_flush(). Just replace it
> with direct calls to blkdev_issue_flush().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf.c   | 2 +-
>  fs/xfs/xfs_file.c  | 6 +++---
>  fs/xfs/xfs_log.c   | 2 +-
>  fs/xfs/xfs_super.c | 7 -------
>  fs/xfs/xfs_super.h | 1 -
>  5 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 37a1d12762d8..7043546a04b8 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1958,7 +1958,7 @@ xfs_free_buftarg(
>  	percpu_counter_destroy(&btp->bt_io_count);
>  	list_lru_destroy(&btp->bt_lru);
>  
> -	xfs_blkdev_issue_flush(btp);
> +	blkdev_issue_flush(btp->bt_bdev);
>  
>  	kmem_free(btp);
>  }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a007ca0711d9..24c7f45fc4eb 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -197,9 +197,9 @@ xfs_file_fsync(
>  	 * inode size in case of an extending write.
>  	 */
>  	if (XFS_IS_REALTIME_INODE(ip))
> -		xfs_blkdev_issue_flush(mp->m_rtdev_targp);
> +		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
>  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
> -		xfs_blkdev_issue_flush(mp->m_ddev_targp);
> +		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
>  
>  	/*
>  	 * Any inode that has dirty modifications in the log is pinned.  The
> @@ -219,7 +219,7 @@ xfs_file_fsync(
>  	 */
>  	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
>  	    mp->m_logdev_targp == mp->m_ddev_targp)
> -		xfs_blkdev_issue_flush(mp->m_ddev_targp);
> +		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
>  
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 317c466232d4..fee76c485727 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1962,7 +1962,7 @@ xlog_sync(
>  	 * layer state machine for preflushes.
>  	 */
>  	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
> -		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
> +		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
>  		need_flush = false;
>  	}
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e5e0713bebcd..ca2cb0448b5e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -339,13 +339,6 @@ xfs_blkdev_put(
>  		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
>  }
>  
> -void
> -xfs_blkdev_issue_flush(
> -	xfs_buftarg_t		*buftarg)
> -{
> -	blkdev_issue_flush(buftarg->bt_bdev);
> -}
> -
>  STATIC void
>  xfs_close_devices(
>  	struct xfs_mount	*mp)
> diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
> index 1ca484b8357f..79cb2dece811 100644
> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -88,7 +88,6 @@ struct block_device;
>  
>  extern void xfs_quiesce_attr(struct xfs_mount *mp);
>  extern void xfs_flush_inodes(struct xfs_mount *mp);
> -extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
>  extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
>  					   xfs_agnumber_t agcount);
>  
> -- 
> 2.28.0
> 

