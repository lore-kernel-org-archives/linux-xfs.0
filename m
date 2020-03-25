Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A97FBC43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 12:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EBAA2076A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 12:33:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cGe4Vcc4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgCYMdX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 08:33:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:43870 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727177AbgCYMdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 08:33:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585139601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7e30IcRwkpFDSKRLUrKT2Gv7ZjOigwgrZRbkLiN5fQE=;
        b=cGe4Vcc48aTMKMOo5kiF6BH51JyuwFiphP5G1YMnOLQE8riI2swCTlaEMcBIMZ3y/eyL2f
        4Yoev1jL+Ru2ZYfHTHlvbUIR7U8JJxoX8z9wU1L+YIOwQi16lKjK6ojMYVwLcXQy85gRSj
        iUm1Oo2UtcOkqG0OP3vjOOwkUASaWUk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-yK60_9orOvqG9rJY29AQJw-1; Wed, 25 Mar 2020 08:33:18 -0400
X-MC-Unique: yK60_9orOvqG9rJY29AQJw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C116107ACC4;
        Wed, 25 Mar 2020 12:33:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A4BB010002AE;
        Wed, 25 Mar 2020 12:33:16 +0000 (UTC)
Date:   Wed, 25 Mar 2020 08:33:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/8] xfs: don't try to write a start record into every
 iclog
Message-ID: <20200325123314.GC10922@bfoster>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324174459.770999-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 06:44:52PM +0100, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The xlog_write() function iterates over iclogs until it completes
> writing all the log vectors passed in. The ticket tracks whether
> a start record has been written or not, so only the first iclog gets
> a start record. We only ever pass single use tickets to
> xlog_write() so we only ever need to write a start record once per
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
> [hch: use an need_start_rec bool]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 63 ++++++++++++++++++++++++------------------------
>  1 file changed, 32 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2a90a483c2d6..bf071552094a 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -2372,25 +2359,29 @@ xlog_write(
>  	int			record_cnt = 0;
>  	int			data_cnt = 0;
>  	int			error = 0;
> +	bool			need_start_rec = true;
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
> -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +	if (ticket->t_flags & XLOG_TIC_INITED) {
> +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +		ticket->t_flags &= ~XLOG_TIC_INITED;
> +	}
>  
>  	/*
>  	 * Commit record headers need to be accounted for. These
>  	 * come in as separate writes so are easy to detect.
>  	 */
> -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +		need_start_rec = false;
> +	}

Hmm.. I was asking for a comment update in v1 for this logic change.
Looking through it again, what happens here if
xfs_log_write_unmount_record() clears the UNMOUNT_TRANS flag for that
summary counter check? That looks like a potential behavior change wrt
to the start record..

Brian

>  
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
> @@ -2399,6 +2390,8 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> +	len = xlog_write_calc_vec_length(ticket, log_vector, need_start_rec);
> +
>  	index = 0;
>  	lv = log_vector;
>  	vecp = lv->lv_iovecp;
> @@ -2425,7 +2418,6 @@ xlog_write(
>  		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  			struct xfs_log_iovec	*reg;
>  			struct xlog_op_header	*ophdr;
> -			int			start_rec_copy;
>  			int			copy_len;
>  			int			copy_off;
>  			bool			ordered = false;
> @@ -2441,11 +2433,15 @@ xlog_write(
>  			ASSERT(reg->i_len % sizeof(int32_t) == 0);
>  			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
>  
> -			start_rec_copy = xlog_write_start_rec(ptr, ticket);
> -			if (start_rec_copy) {
> -				record_cnt++;
> +			/*
> +			 * Before we start formatting log vectors, we need to
> +			 * write a start record. Only do this for the first
> +			 * iclog we write to.
> +			 */
> +			if (need_start_rec) {
> +				xlog_write_start_rec(ptr, ticket);
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
> -						   start_rec_copy);
> +						sizeof(struct xlog_op_header));
>  			}
>  
>  			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, flags);
> @@ -2477,8 +2473,13 @@ xlog_write(
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  						   copy_len);
>  			}
> -			copy_len += start_rec_copy + sizeof(xlog_op_header_t);
> +			copy_len += sizeof(struct xlog_op_header);
>  			record_cnt++;
> +			if (need_start_rec) {
> +				copy_len += sizeof(struct xlog_op_header);
> +				record_cnt++;
> +				need_start_rec = false;
> +			}
>  			data_cnt += contwr ? copy_len : 0;
>  
>  			error = xlog_write_copy_finish(log, iclog, flags,
> -- 
> 2.25.1
> 

