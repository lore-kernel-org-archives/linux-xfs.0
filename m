Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CFEC5ACD6
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 14:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF04A20714
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 14:48:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hiOyi9z/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgCROsy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 10:48:54 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:25403 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbgCROsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 10:48:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584542932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kHMj0zERRrGesu5BwdygnpVelyJ0N5QS/TwYt3N4I6A=;
        b=hiOyi9z/e5waVlwz2t1FSVwNVH3lH3M8onMuwHVtH6KXC9VZczQKLmcp8IFMtqb/mdIZNX
        vKdH/u4yeax04TxUH0MeN2ci2SsN2xdzIFLetbS2MCmKb6gP2WUCm1WrGmhNIKm8fropEb
        TXtQqtJl7HJ13HwCA6iVnLf0A7H0ueo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-l_w7u7BeNiGIwY5F06ppKg-1; Wed, 18 Mar 2020 10:48:50 -0400
X-MC-Unique: l_w7u7BeNiGIwY5F06ppKg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A3511005509;
        Wed, 18 Mar 2020 14:48:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E448960BFB;
        Wed, 18 Mar 2020 14:48:48 +0000 (UTC)
Date:   Wed, 18 Mar 2020 10:48:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/14] xfs: remove xlog_state_want_sync
Message-ID: <20200318144847.GE32848@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-14-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:32PM +0100, Christoph Hellwig wrote:
> Open code the xlog_state_want_sync logic in its two callers given that
> this function is a trivial wrapper around xlog_state_switch_iclogs.
> 
> Move the lockdep assert into xlog_state_switch_iclogs to not lose this
> debugging aid, and improve the comment that documents
> xlog_state_switch_iclogs as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 50 +++++++++++++++++-------------------------------
>  1 file changed, 18 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 865dd1e08679..761b138d97ec 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -62,11 +62,6 @@ xlog_state_switch_iclogs(
>  	struct xlog_in_core	*iclog,
>  	int			eventual_size);
>  STATIC void
> -xlog_state_want_sync(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog);
> -
> -STATIC void
>  xlog_grant_push_ail(
>  	struct xlog		*log,
>  	int			need_bytes);
> @@ -938,7 +933,11 @@ xfs_log_write_unmount_record(
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
>  	atomic_inc(&iclog->ic_refcnt);
> -	xlog_state_want_sync(log, iclog);
> +	if (iclog->ic_state == XLOG_STATE_ACTIVE)
> +		xlog_state_switch_iclogs(log, iclog, 0);
> +	else
> +		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> +		       iclog->ic_state == XLOG_STATE_IOERROR);
>  	error = xlog_state_release_iclog(log, iclog);
>  	xlog_wait_on_iclog(iclog);
>  
> @@ -2293,7 +2292,11 @@ xlog_write_copy_finish(
>  		*record_cnt = 0;
>  		*data_cnt = 0;
>  
> -		xlog_state_want_sync(log, iclog);
> +		if (iclog->ic_state == XLOG_STATE_ACTIVE)
> +			xlog_state_switch_iclogs(log, iclog, 0);
> +		else
> +			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> +			       iclog->ic_state == XLOG_STATE_IOERROR);
>  		if (!commit_iclog)
>  			goto release_iclog;
>  		spin_unlock(&log->l_icloglock);
> @@ -3069,11 +3072,12 @@ xlog_ungrant_log_space(
>  }
>  
>  /*
> - * This routine will mark the current iclog in the ring as WANT_SYNC
> - * and move the current iclog pointer to the next iclog in the ring.
> - * When this routine is called from xlog_state_get_iclog_space(), the
> - * exact size of the iclog has not yet been determined.  All we know is
> - * that every data block.  We have run out of space in this log record.
> + * Mark the current iclog in the ring as WANT_SYNC and move the current iclog
> + * pointer to the next iclog in the ring.
> + *
> + * When called from xlog_state_get_iclog_space(), the exact size of the iclog
> + * has not yet been determined, all we know is that we have run out of space in
> + * the current iclog.
>   */
>  STATIC void
>  xlog_state_switch_iclogs(
> @@ -3082,6 +3086,8 @@ xlog_state_switch_iclogs(
>  	int			eventual_size)
>  {
>  	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
> +	assert_spin_locked(&log->l_icloglock);
> +
>  	if (!eventual_size)
>  		eventual_size = iclog->ic_offset;
>  	iclog->ic_state = XLOG_STATE_WANT_SYNC;
> @@ -3323,26 +3329,6 @@ xfs_log_force_lsn(
>  	return ret;
>  }
>  
> -/*
> - * Called when we want to mark the current iclog as being ready to sync to
> - * disk.
> - */
> -STATIC void
> -xlog_state_want_sync(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog)
> -{
> -	assert_spin_locked(&log->l_icloglock);
> -
> -	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
> -		xlog_state_switch_iclogs(log, iclog, 0);
> -	} else {
> -		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -		       iclog->ic_state == XLOG_STATE_IOERROR);
> -	}
> -}
> -
> -
>  /*****************************************************************************
>   *
>   *		TICKET functions
> -- 
> 2.24.1
> 

