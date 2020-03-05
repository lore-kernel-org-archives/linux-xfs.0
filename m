Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB351C3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B27E2072D
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 18:05:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D5Atr4/y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgCESFi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:05:38 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34191 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726049AbgCESFh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 13:05:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583431535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WX1nYbtFAYpqdVwieVgYRevSAmWyJkwdlAk/to/+48M=;
        b=D5Atr4/y3lw6s31DDd6wGz7xblVKvH4eTJ3cucRR92LX3LDO6j+iDini11Qqhx8rh2h7/5
        JGI7a67AuplEfPlbcOfiWdvLutZM8EQ/5pzNfvrUwqMtOsDxSl4l/yR6Q6clsTzDe2bSAP
        kxF3ts/pbrtU704R9Xw60OI7A7o6OEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-YUTPX9UjNBu6NHWFOADWSA-1; Thu, 05 Mar 2020 13:05:34 -0500
X-MC-Unique: YUTPX9UjNBu6NHWFOADWSA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55B56184C805;
        Thu,  5 Mar 2020 18:05:33 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 049E19CA3;
        Thu,  5 Mar 2020 18:05:32 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:05:31 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: don't try to write a start record into every
 iclog
Message-ID: <20200305180531.GA28340@bfoster>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-2-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:51PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The xlog_write() function iterates over iclogs until it completes
> writing all the log vectors passed in. The ticket tracks whether
> a start record has been written or not, so only the first iclog gets
> a start record. We only ever pass single use tickets to
> xlog_write() we only ever need to write a start record once per

	      ^ "so we only ever ..." ?

> xlog_write() call.
> 
> Hence we don't need to store whether we should write a start record
> in the ticket as the callers provide all the information we need to
> determine if a start record should be written. For the moment, we
> have to ensure that we clear the XLOG_TIC_INITED appropriately so
> the code in xfs_log_done() still works correctly for committing
> transactions.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 68 +++++++++++++++++++++++++-----------------------
>  1 file changed, 35 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f6006d94a581..5b0568a86c07 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -2404,25 +2391,29 @@ xlog_write(
>  	int			record_cnt = 0;
>  	int			data_cnt = 0;
>  	int			error = 0;
> +	int			start_rec_size = sizeof(struct xlog_op_header);
>  
>  	*start_lsn = 0;
>  
> -	len = xlog_write_calc_vec_length(ticket, log_vector);
>  
>  	/*
>  	 * Region headers and bytes are already accounted for.
>  	 * We only need to take into account start records and
>  	 * split regions in this function.
>  	 */
> -	if (ticket->t_flags & XLOG_TIC_INITED)
> +	if (ticket->t_flags & XLOG_TIC_INITED) {
>  		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +		ticket->t_flags &= ~XLOG_TIC_INITED;
> +	}
>  
>  	/*
>  	 * Commit record headers need to be accounted for. These
>  	 * come in as separate writes so are easy to detect.
>  	 */
> -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> +	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
>  		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +		start_rec_size = 0;
> +	}

This is more of a flaw in the existing code than this patch, but please
update the comment to document why we reset start_rec_size here since
it's not obvious from the context of the function. Otherwise looks Ok to
me modulo Christoph's comments (in particular the data_cnt bit). My one
nit is that I think start_rec might be a better name than start_rec_size
given how it's used, but I don't care that much.

Brian

>  
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
> @@ -2431,6 +2422,8 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> +	len = xlog_write_calc_vec_length(ticket, log_vector, start_rec_size);
> +
>  	index = 0;
>  	lv = log_vector;
>  	vecp = lv->lv_iovecp;
> @@ -2446,9 +2439,20 @@ xlog_write(
>  		ASSERT(log_offset <= iclog->ic_size - 1);
>  		ptr = iclog->ic_datap + log_offset;
>  
> -		/* start_lsn is the first lsn written to. That's all we need. */
> +		/*
> +		 * Before we start formatting log vectors, we need to write a
> +		 * start record and record the lsn of the iclog that we write
> +		 * the start record into. Only do this for the first iclog we
> +		 * write to.
> +		 */
>  		if (!*start_lsn)
>  			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +		if (start_rec_size) {
> +			xlog_write_start_rec(ptr, ticket);
> +			xlog_write_adv_cnt(&ptr, &len, &log_offset,
> +					start_rec_size);
> +			record_cnt++;
> +		}
>  
>  		/*
>  		 * This loop writes out as many regions as can fit in the amount
> @@ -2457,7 +2461,6 @@ xlog_write(
>  		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  			struct xfs_log_iovec	*reg;
>  			struct xlog_op_header	*ophdr;
> -			int			start_rec_copy;
>  			int			copy_len;
>  			int			copy_off;
>  			bool			ordered = false;
> @@ -2473,13 +2476,6 @@ xlog_write(
>  			ASSERT(reg->i_len % sizeof(int32_t) == 0);
>  			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
>  
> -			start_rec_copy = xlog_write_start_rec(ptr, ticket);
> -			if (start_rec_copy) {
> -				record_cnt++;
> -				xlog_write_adv_cnt(&ptr, &len, &log_offset,
> -						   start_rec_copy);
> -			}
> -
>  			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, flags);
>  			if (!ophdr)
>  				return -EIO;
> @@ -2509,10 +2505,15 @@ xlog_write(
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  						   copy_len);
>  			}
> -			copy_len += start_rec_copy + sizeof(xlog_op_header_t);
> +			copy_len += sizeof(xlog_op_header_t);
>  			record_cnt++;
>  			data_cnt += contwr ? copy_len : 0;
>  
> +			if (start_rec_size) {
> +				copy_len += start_rec_size;
> +				start_rec_size = 0;
> +			}
> +
>  			error = xlog_write_copy_finish(log, iclog, flags,
>  						       &record_cnt, &data_cnt,
>  						       &partial_copy,
> @@ -2550,6 +2551,7 @@ xlog_write(
>  				break;
>  			}
>  		}
> +		start_rec_size = 0;
>  	}
>  
>  	ASSERT(len == 0);
> -- 
> 2.24.0.rc0
> 

