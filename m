Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_PH_BODY_ACCOUNTS_PRE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99154C43331
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 11:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 609B620409
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 11:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sy6q+pRI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgCZLJg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 07:09:36 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:54000 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727590AbgCZLJf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 07:09:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585220974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tIIidZwReBUxQwqXE2sCehI/9yeSD2B+fj9YpHb8JPk=;
        b=Sy6q+pRIS8uIgE0FrQUFSomozLKwV4MJ1+TyF0nAG0FCevh95p+BAXeqAQu7CJOAklHMK5
        HD2qCezag/+GsunCXEgZoudmt3gPNd6JreujFR6eEM2yC25HIWGabQO8glJyo4Sl/YRVkM
        PyeuwlSu6eDPCDfR6EnNgmQsNKtVMt4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-Ya2X87EYOKylCS-vxUKJXg-1; Thu, 26 Mar 2020 07:09:30 -0400
X-MC-Unique: Ya2X87EYOKylCS-vxUKJXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFC4386A067;
        Thu, 26 Mar 2020 11:09:28 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 67F9F9CA3;
        Thu, 26 Mar 2020 11:09:28 +0000 (UTC)
Date:   Thu, 26 Mar 2020 07:09:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/8] xfs: don't try to write a start record into every
 iclog
Message-ID: <20200326110926.GB19262@bfoster>
References: <20200325184305.1361872-1-hch@lst.de>
 <20200325184305.1361872-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325184305.1361872-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 07:42:58PM +0100, Christoph Hellwig wrote:
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
> [hch: pass an explicit need_start_rec argument]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 77 +++++++++++++++++++++----------------------
>  fs/xfs/xfs_log_cil.c  |  2 +-
>  fs/xfs/xfs_log_priv.h | 12 +++----
>  3 files changed, 42 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2a90a483c2d6..617b393272de 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -2375,23 +2363,22 @@ xlog_write(
>  
>  	*start_lsn = 0;
>  
> -	len = xlog_write_calc_vec_length(ticket, log_vector);
>  
>  	/*
> -	 * Region headers and bytes are already accounted for.
> -	 * We only need to take into account start records and
> -	 * split regions in this function.
> +	 * Region headers and bytes are already accounted for.  We only need to
> +	 * take into account start records and split regions in this function.
>  	 */
> -	if (ticket->t_flags & XLOG_TIC_INITED)
> -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> +	if (ticket->t_flags & XLOG_TIC_INITED) {
> +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +		ticket->t_flags &= ~XLOG_TIC_INITED;
> +	}
>  
>  	/*
> -	 * Commit record headers need to be accounted for. These
> -	 * come in as separate writes so are easy to detect.
> +	 * Commit record headers and unmount records need to be accounted for.
> +	 * These come in as separate writes so are easy to detect.
>  	 */
> -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> -		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> -
> +	if (!need_start_rec)
> +		ticket->t_curr_res -= sizeof(struct xlog_op_header);

So this technically is still different from upstream in that if the
caller clears XLOG_UNMOUNT_TRANS, upstream wouldn't account this
reservation from the log ticket because both t_flags and flags are
zeroed. With this change, we always account the op header one way or the
other. I don't see anything else that changes functionally in the
xlog_write() code based on flags (i.e. other than what we write out to
disk), so perhaps this logic is correct.

Could you (or Darrick?) update the commit log to note that tweak? With
that, the rest looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
>  		     "ctx ticket reservation ran out. Need to up reservation");
> @@ -2399,6 +2386,8 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> +	len = xlog_write_calc_vec_length(ticket, log_vector, need_start_rec);
> +
>  	index = 0;
>  	lv = log_vector;
>  	vecp = lv->lv_iovecp;
> @@ -2425,7 +2414,6 @@ xlog_write(
>  		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  			struct xfs_log_iovec	*reg;
>  			struct xlog_op_header	*ophdr;
> -			int			start_rec_copy;
>  			int			copy_len;
>  			int			copy_off;
>  			bool			ordered = false;
> @@ -2441,11 +2429,15 @@ xlog_write(
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
> @@ -2477,8 +2469,13 @@ xlog_write(
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
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 64cc0bf2ab3b..e0aeb316ce6c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -801,7 +801,7 @@ xlog_cil_push_work(
>  	lvhdr.lv_iovecp = &lhdr;
>  	lvhdr.lv_next = ctx->lv_chain;
>  
> -	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0);
> +	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0, true);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 2b0aec37e73e..b895e16460ee 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -439,14 +439,10 @@ xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
>  
>  void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
> -int
> -xlog_write(
> -	struct xlog		*log,
> -	struct xfs_log_vec	*log_vector,
> -	struct xlog_ticket	*tic,
> -	xfs_lsn_t		*start_lsn,
> -	struct xlog_in_core	**commit_iclog,
> -	uint			flags);
> +int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
> +		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
> +		struct xlog_in_core **commit_iclog, uint flags,
> +		bool need_start_rec);
>  
>  /*
>   * When we crack an atomic LSN, we sample it first so that the value will not
> -- 
> 2.25.1
> 

