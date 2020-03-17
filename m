Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CC8C10F29
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A16E20752
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BmqKV6UL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgCQNYI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:24:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:58491 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgCQNYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 09:24:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584451446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YHvhE1NV9o0jJAVJwla6F7756udcYjoN3n5PxW4See8=;
        b=BmqKV6ULDdnOwwumtLdKk5m2eH2CQ0qZS3OxlreDpaKS1Kz63GzqADG4zK9Xm3wwURzj1z
        qO5+kep0JYpiFvHEWaLASUZbzePp4zRgGVeg3zAevH2KuctsKkVMBfZR6KoQQlCOYt033g
        uEJzIOF6gMjkhe5fF+YNSjULpBc5tTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-sT9UFIksOw2gW688-dTNKA-1; Tue, 17 Mar 2020 09:24:03 -0400
X-MC-Unique: sT9UFIksOw2gW688-dTNKA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE2691005513;
        Tue, 17 Mar 2020 13:24:01 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 83A3D60BE0;
        Tue, 17 Mar 2020 13:24:01 +0000 (UTC)
Date:   Tue, 17 Mar 2020 09:23:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/14] xfs: simplify the xfs_log_release_iclog calling
 convention
Message-ID: <20200317132359.GD24078@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:22PM +0100, Christoph Hellwig wrote:
> The only caller of xfs_log_release_iclog doesn't care about the return
> value, so remove it.  Also don't bother passing the mount pointer,
> given that we can trivially derive it from the iclog.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c     | 10 ++++------
>  fs/xfs/xfs_log.h     |  3 +--
>  fs/xfs/xfs_log_cil.c |  2 +-
>  3 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 955df2902c2c..17ba92b115ea 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -597,12 +597,11 @@ xlog_state_release_iclog(
>  	return 0;
>  }
>  
> -int
> +void
>  xfs_log_release_iclog(
> -	struct xfs_mount        *mp,
>  	struct xlog_in_core	*iclog)
>  {
> -	struct xlog		*log = mp->m_log;
> +	struct xlog		*log = iclog->ic_log;
>  	bool			sync;
>  
>  	if (iclog->ic_state == XLOG_STATE_IOERROR)
> @@ -618,10 +617,9 @@ xfs_log_release_iclog(
>  		if (sync)
>  			xlog_sync(log, iclog);
>  	}
> -	return 0;
> +	return;
>  error:
> -	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> -	return -EIO;
> +	xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 84e06805160f..b38602216c5a 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -121,8 +121,7 @@ void	xfs_log_mount_cancel(struct xfs_mount *);
>  xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
>  xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
>  void	  xfs_log_space_wake(struct xfs_mount *mp);
> -int	  xfs_log_release_iclog(struct xfs_mount *mp,
> -			 struct xlog_in_core	 *iclog);
> +void	  xfs_log_release_iclog(struct xlog_in_core *iclog);
>  int	  xfs_log_reserve(struct xfs_mount *mp,
>  			  int		   length,
>  			  int		   count,
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 6a6278b8eb2d..047ac253edfe 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -866,7 +866,7 @@ xlog_cil_push_work(
>  	spin_unlock(&cil->xc_push_lock);
>  
>  	/* release the hounds! */
> -	xfs_log_release_iclog(log->l_mp, commit_iclog);
> +	xfs_log_release_iclog(commit_iclog);
>  	return;
>  
>  out_skip:
> -- 
> 2.24.1
> 

