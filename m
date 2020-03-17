Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D20BC10F29
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3260120738
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BnYSbkxC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgCQNXL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:23:11 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:22098 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726407AbgCQNXL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 09:23:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584451390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B9h3U4LlrXI869AeZg7AIBqDkIWFkRrassHatfHIPZE=;
        b=BnYSbkxCDz2E4mLWuSrHtoEPFWoGow5HHkzwQCbq1J6Qx6rJ/r2xXRucXktE6Dj17sAE4V
        QTiofZyNjlDR/BoBWxb40RIP+SmA1+Ao2MsaXscfUiVHBroXGG5FxVOkAskQyp+FJaQlFz
        DlThM4ofRCWForrNrOhu8Yypi2wLTdU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-YW-VR1leNBm-ip2aIfZclQ-1; Tue, 17 Mar 2020 09:23:08 -0400
X-MC-Unique: YW-VR1leNBm-ip2aIfZclQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F8B3801E72;
        Tue, 17 Mar 2020 13:23:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32BF35C1BB;
        Tue, 17 Mar 2020 13:23:07 +0000 (UTC)
Date:   Tue, 17 Mar 2020 09:23:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/14] xfs: merge xlog_cil_push into xlog_cil_push_work
Message-ID: <20200317132305.GB24078@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:20PM +0100, Christoph Hellwig wrote:
> xlog_cil_push is only called by xlog_cil_push_work, so merge the two
> functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_cil.c | 46 +++++++++++++++++---------------------------
>  1 file changed, 18 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 48435cf2aa16..6a6278b8eb2d 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -626,24 +626,26 @@ xlog_cil_process_committed(
>  }
>  
>  /*
> - * Push the Committed Item List to the log. If @push_seq flag is zero, then it
> - * is a background flush and so we can chose to ignore it. Otherwise, if the
> - * current sequence is the same as @push_seq we need to do a flush. If
> - * @push_seq is less than the current sequence, then it has already been
> + * Push the Committed Item List to the log.
> + *
> + * If the current sequence is the same as xc_push_seq we need to do a flush. If
> + * xc_push_seq is less than the current sequence, then it has already been
>   * flushed and we don't need to do anything - the caller will wait for it to
>   * complete if necessary.
>   *
> - * @push_seq is a value rather than a flag because that allows us to do an
> - * unlocked check of the sequence number for a match. Hence we can allows log
> - * forces to run racily and not issue pushes for the same sequence twice. If we
> - * get a race between multiple pushes for the same sequence they will block on
> - * the first one and then abort, hence avoiding needless pushes.
> + * xc_push_seq is checked unlocked against the sequence number for a match.
> + * Hence we can allows log forces to run racily and not issue pushes for the
> + * same sequence twice.  If we get a race between multiple pushes for the same
> + * sequence they will block on the first one and then abort, hence avoiding
> + * needless pushes.
>   */
> -STATIC int
> -xlog_cil_push(
> -	struct xlog		*log)
> +static void
> +xlog_cil_push_work(
> +	struct work_struct	*work)
>  {
> -	struct xfs_cil		*cil = log->l_cilp;
> +	struct xfs_cil		*cil =
> +		container_of(work, struct xfs_cil, xc_push_work);
> +	struct xlog		*log = cil->xc_log;
>  	struct xfs_log_vec	*lv;
>  	struct xfs_cil_ctx	*ctx;
>  	struct xfs_cil_ctx	*new_ctx;
> @@ -657,9 +659,6 @@ xlog_cil_push(
>  	xfs_lsn_t		commit_lsn;
>  	xfs_lsn_t		push_seq;
>  
> -	if (!cil)
> -		return 0;
> -
>  	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
>  
> @@ -867,28 +866,19 @@ xlog_cil_push(
>  	spin_unlock(&cil->xc_push_lock);
>  
>  	/* release the hounds! */
> -	return xfs_log_release_iclog(log->l_mp, commit_iclog);
> +	xfs_log_release_iclog(log->l_mp, commit_iclog);
> +	return;
>  
>  out_skip:
>  	up_write(&cil->xc_ctx_lock);
>  	xfs_log_ticket_put(new_ctx->ticket);
>  	kmem_free(new_ctx);
> -	return 0;
> +	return;
>  
>  out_abort_free_ticket:
>  	xfs_log_ticket_put(tic);
>  out_abort:
>  	xlog_cil_committed(ctx, true);
> -	return -EIO;
> -}
> -
> -static void
> -xlog_cil_push_work(
> -	struct work_struct	*work)
> -{
> -	struct xfs_cil		*cil = container_of(work, struct xfs_cil,
> -							xc_push_work);
> -	xlog_cil_push(cil->xc_log);
>  }
>  
>  /*
> -- 
> 2.24.1
> 

