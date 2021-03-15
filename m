Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A69EC433E9
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE76B64F56
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbhCOOqE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 10:46:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239119AbhCOOp4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 10:45:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AIhkO4rWOjf6PXkHFFXo0Az6oUeqAVICAUsrl8zh0WQ=;
        b=axzKzdcs8MCnqx6bPLo0P83u8ZxA4+sEF2iNympaHHSvIsQYpdyq5Ssd5/leqNe0ZacPVd
        IYK/bAu0FjboFywDJy0f/PSePdKrLEx1c++LS0BoaEVjdQzeK/d/9IG9g9K6P8dVnhuNDF
        DEUQ33MpMFY4G0NyCzzJcYBe040hIJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-o5GFcdLJOKukg_U3RXUNYw-1; Mon, 15 Mar 2021 10:45:54 -0400
X-MC-Unique: o5GFcdLJOKukg_U3RXUNYw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B508839A42;
        Mon, 15 Mar 2021 14:45:53 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43B2210023B5;
        Mon, 15 Mar 2021 14:45:53 +0000 (UTC)
Date:   Mon, 15 Mar 2021 10:45:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/45] xfs: remove need_start_rec parameter from
 xlog_write()
Message-ID: <YE9zH1QAMGRlhLex@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-8-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:05PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The CIL push is the only call to xlog_write that sets this variable
> to true. The other callers don't need a start rec, and they tell
> xlog_write what to do by passing the type of ophdr they need written
> in the flags field. The need_start_rec parameter essentially tells
> xlog_write to to write an extra ophdr with a XLOG_START_TRANS type,
> so get rid of the variable to do this and pass XLOG_START_TRANS as
> the flag value into xlog_write() from the CIL push.
> 
> $ size fs/xfs/xfs_log.o*
>   text	   data	    bss	    dec	    hex	filename
>  27595	    560	      8	  28163	   6e03	fs/xfs/xfs_log.o.orig
>  27454	    560	      8	  28022	   6d76	fs/xfs/xfs_log.o.patched
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log.c      | 44 +++++++++++++++++++++----------------------
>  fs/xfs/xfs_log_cil.c  |  3 ++-
>  fs/xfs/xfs_log_priv.h |  3 +--
>  3 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fee76c485727..364694a83de6 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -2449,13 +2448,15 @@ xlog_write(
>  			 * write a start record. Only do this for the first
>  			 * iclog we write to.
>  			 */
> -			if (need_start_rec) {
> +			if (optype & XLOG_START_TRANS) {
>  				xlog_write_start_rec(ptr, ticket);
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  						sizeof(struct xlog_op_header));
> +				optype &= ~XLOG_START_TRANS;
> +				wrote_start_rec = true;

I think this overload of optype and op header flags is sufficiently
subtle and fragile that this warrants a comment. E.g., something like:

"Now that we've written the start record, we must clear the flag now so
it doesn't leak into subsequent op headers."

Otherwise, I think it's pretty much a guarantee that somebody will come
along later and attempt to optimize away what looks like an unnecessary
boolean by moving the flag clear further down without realizing why it's
here.

In fact, I think what would have been more clean and simple overall is
to translate the new optype param back into the preexisting flags (as a
local variable) and need_start_rec parameters right after optype is
consumed by xlog_write_calc_vec_length(). Then we wouldn't have to tweak
as much functional logic to accommodate a subtle variable overload
(i.e., basically just removing code changes from this patch) and the
code would be self explanatory. That said, the remaining changes look Ok
to me so long as the above is clearly documented.

Brian

>  			}
>  
> -			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, flags);
> +			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, optype);
>  			if (!ophdr)
>  				return -EIO;
>  
> @@ -2486,14 +2487,13 @@ xlog_write(
>  			}
>  			copy_len += sizeof(struct xlog_op_header);
>  			record_cnt++;
> -			if (need_start_rec) {
> +			if (wrote_start_rec) {
>  				copy_len += sizeof(struct xlog_op_header);
>  				record_cnt++;
> -				need_start_rec = false;
>  			}
>  			data_cnt += contwr ? copy_len : 0;
>  
> -			error = xlog_write_copy_finish(log, iclog, flags,
> +			error = xlog_write_copy_finish(log, iclog, optype,
>  						       &record_cnt, &data_cnt,
>  						       &partial_copy,
>  						       &partial_copy_len,
> @@ -2537,7 +2537,7 @@ xlog_write(
>  	spin_lock(&log->l_icloglock);
>  	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
>  	if (commit_iclog) {
> -		ASSERT(flags & XLOG_COMMIT_TRANS);
> +		ASSERT(optype & XLOG_COMMIT_TRANS);
>  		*commit_iclog = iclog;
>  	} else {
>  		error = xlog_state_release_iclog(log, iclog);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b4cdb8b6c4c3..c04d5d37a3a2 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -829,7 +829,8 @@ xlog_cil_push_work(
>  	 */
>  	wait_for_completion(&bdev_flush);
>  
> -	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0, true);
> +	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL,
> +				XLOG_START_TRANS);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index ee7786b33da9..56e1942c47df 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -480,8 +480,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
>  		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
> -		struct xlog_in_core **commit_iclog, uint flags,
> -		bool need_start_rec);
> +		struct xlog_in_core **commit_iclog, uint optype);
>  int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
>  		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
>  void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
> -- 
> 2.28.0
> 

