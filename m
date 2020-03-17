Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585AEC10F29
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B3EA20738
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dhyYCaA1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgCQNYf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:24:35 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:56971 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgCQNYf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 09:24:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584451473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QokCAIZzS9/uulULLGnjWg3JAlBDjFa3PPpuldyOrSU=;
        b=dhyYCaA1x5DRlcWpxd+k2ujMFBqgsROvEQ160zzLc0zk+nuimp4eas+g7hj3xHxTT6wgmu
        mykvVA8fw8pPNX/Lx2eeQjY3uo70ldeKib6D8PMTzqV9nmxmwsGC5MfaWbRtsjSz1DY+Ov
        itj7mfJlRjElSeopQpnTC2zouTRYhUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-9CFWqNdEP6Cjm5KSbm-VQA-1; Tue, 17 Mar 2020 09:24:32 -0400
X-MC-Unique: 9CFWqNdEP6Cjm5KSbm-VQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31850107ACC4;
        Tue, 17 Mar 2020 13:24:31 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CBB5E9352B;
        Tue, 17 Mar 2020 13:24:30 +0000 (UTC)
Date:   Tue, 17 Mar 2020 09:24:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/14] xfs: remove the aborted parameter to
 xlog_state_done_syncing
Message-ID: <20200317132429.GF24078@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-6-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:24PM +0100, Christoph Hellwig wrote:
> We can just check for a shut down log all the way down in
> xlog_cil_committed instead of passing the parameter.  This means a
> slight behavior change in that we now also abort log items if the
> shutdown came in halfway into the I/O completion processing, which
> actually is the right thing to do.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c     | 48 +++++++++++++++-----------------------------
>  fs/xfs/xfs_log.h     |  2 +-
>  fs/xfs/xfs_log_cil.c | 12 +++++------
>  3 files changed, 23 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7af9c292540b..8ede2852f104 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -2891,25 +2879,22 @@ xlog_state_do_callback(
>   */
>  STATIC void
>  xlog_state_done_syncing(
> -	struct xlog_in_core	*iclog,
> -	bool			aborted)
> +	struct xlog_in_core	*iclog)
>  {
>  	struct xlog		*log = iclog->ic_log;
>  
>  	spin_lock(&log->l_icloglock);
> -
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
>  
>  	/*
>  	 * If we got an error, either on the first buffer, or in the case of
> -	 * split log writes, on the second, we mark ALL iclogs STATE_IOERROR,
> -	 * and none should ever be attempted to be written to disk
> -	 * again.
> +	 * split log writes, on the second, we shut down the file system and
> +	 * none should ever be attempted to be written to disk again.

"none" refers to iclogs in the original comment, which has been removed.
This could probably read "... and iclogs should never ..." instead.

With that fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	 */
> -	if (iclog->ic_state == XLOG_STATE_SYNCING)
> +	if (!XLOG_FORCED_SHUTDOWN(log)) {
> +		ASSERT(iclog->ic_state == XLOG_STATE_SYNCING);
>  		iclog->ic_state = XLOG_STATE_DONE_SYNC;
> -	else
> -		ASSERT(iclog->ic_state == XLOG_STATE_IOERROR);
> +	}
>  
>  	/*
>  	 * Someone could be sleeping prior to writing out the next
> @@ -2918,9 +2903,8 @@ xlog_state_done_syncing(
>  	 */
>  	wake_up_all(&iclog->ic_write_wait);
>  	spin_unlock(&log->l_icloglock);
> -	xlog_state_do_callback(log, aborted);	/* also cleans log */
> -}	/* xlog_state_done_syncing */
> -
> +	xlog_state_do_callback(log);	/* also cleans log */
> +}
>  
>  /*
>   * If the head of the in-core log ring is not (ACTIVE or DIRTY), then we must
> @@ -3884,7 +3868,7 @@ xfs_log_force_umount(
>  	spin_lock(&log->l_cilp->xc_push_lock);
>  	wake_up_all(&log->l_cilp->xc_commit_wait);
>  	spin_unlock(&log->l_cilp->xc_push_lock);
> -	xlog_state_do_callback(log, true);
> +	xlog_state_do_callback(log);
>  
>  	/* return non-zero if log IOERROR transition had already happened */
>  	return retval;
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index b38602216c5a..cc77cc36560a 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -137,7 +137,7 @@ void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
>  
>  void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
>  				xfs_lsn_t *commit_lsn, bool regrant);
> -void	xlog_cil_process_committed(struct list_head *list, bool aborted);
> +void	xlog_cil_process_committed(struct list_head *list);
>  bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>  
>  void	xfs_log_work_queue(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 047ac253edfe..adc4af336c97 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -574,10 +574,10 @@ xlog_discard_busy_extents(
>   */
>  static void
>  xlog_cil_committed(
> -	struct xfs_cil_ctx	*ctx,
> -	bool			abort)
> +	struct xfs_cil_ctx	*ctx)
>  {
>  	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
> +	bool			abort = XLOG_FORCED_SHUTDOWN(ctx->cil->xc_log);
>  
>  	/*
>  	 * If the I/O failed, we're aborting the commit and already shutdown.
> @@ -613,15 +613,14 @@ xlog_cil_committed(
>  
>  void
>  xlog_cil_process_committed(
> -	struct list_head	*list,
> -	bool			aborted)
> +	struct list_head	*list)
>  {
>  	struct xfs_cil_ctx	*ctx;
>  
>  	while ((ctx = list_first_entry_or_null(list,
>  			struct xfs_cil_ctx, iclog_entry))) {
>  		list_del(&ctx->iclog_entry);
> -		xlog_cil_committed(ctx, aborted);
> +		xlog_cil_committed(ctx);
>  	}
>  }
>  
> @@ -878,7 +877,8 @@ xlog_cil_push_work(
>  out_abort_free_ticket:
>  	xfs_log_ticket_put(tic);
>  out_abort:
> -	xlog_cil_committed(ctx, true);
> +	ASSERT(XLOG_FORCED_SHUTDOWN(log));
> +	xlog_cil_committed(ctx);
>  }
>  
>  /*
> -- 
> 2.24.1
> 

