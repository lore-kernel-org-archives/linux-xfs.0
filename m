Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	TVD_PH_BODY_META_ALL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E25C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 07:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF6D64EC9
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 07:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhBXHSx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 02:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234425AbhBXHSh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 02:18:37 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864DEC061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 23:17:56 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id o10so895829pgg.4
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 23:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=rSpxeVQF34bpz9F1y3dtwv97RqsBaC4UBtHHqrTSGtw=;
        b=HDmMA+lW+qg8ucLesz60n44hmVvZkBT0EcMgX7xK7cAGLpZlpij90F47I6jq0Cwltd
         XPZuz+mvLpeqG6ekUSX76OG+WFVJ6TVwsIcbr6mTwm++AHtqCErAkA0yq+g3wDFI7t3z
         ECnElyQIm5FZelwci7HUUkB18vtgfL+rTkg4efm+OeTZzpMv8Fm/WNL/KvFqcyLz2VlF
         wx/kcisLJUpCXNt1S3LQSPZkV2zirnqYRLPeQNnLS1Nnt8Fnj2YEjiuaFG13tVZPVQeO
         piHul4FUwQRHd5GorH0/rtIkwFPj+aTdy4KXnsumJ8ggzSTJ3k0CelOS0buCF+iWRWbe
         kcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=rSpxeVQF34bpz9F1y3dtwv97RqsBaC4UBtHHqrTSGtw=;
        b=mZbRHmOInufVRNGRhdUQRqhBIc8FSjiMsYsV6pFBTLyKG00U96VzUJ7p9VfLOq78G7
         fbKYmUP6i8KbfX72a1r+ewCC2LCVYZC9V05n5pkaU5QyrcMgE0QesSwEFJ5+VnZsSp0y
         RDlQ0ISxzaD8vz4TLps9F643IBr1ue3F1v6Z+Ojpgb00D+OXRchPWKvhKzhspFHNesNY
         FM1KAsleMaTm3AjgjX6vYlV8rtkZgg19eBx49tkk0JLho73HYOq2S8Hwad3jDsCu6tAm
         h5Kn4+EDydPyHzHCM9xczkGugr8BG6FyFg86ARQhu6MwbkG4Qqqiki469gRG2X4gdhfV
         E2/g==
X-Gm-Message-State: AOAM533RTrn0aQ4aNGSiTtyLe9L93Fp0uGKyCrq4ehodberF/ox+PlFR
        syXDeyZt61mOKL1fzcy8tLNPsAmmt30=
X-Google-Smtp-Source: ABdhPJxMB/dzhJz6nF4+8b7Pdd2eqfvPBKchieCYpY+Y3/b0NgfqQYu4pT7eg/74fO58qcLTvftbAA==
X-Received: by 2002:aa7:854e:0:b029:1ec:eae7:1565 with SMTP id y14-20020aa7854e0000b02901eceae71565mr30350675pfn.35.1614151075891;
        Tue, 23 Feb 2021 23:17:55 -0800 (PST)
Received: from garuda ([122.171.161.92])
        by smtp.gmail.com with ESMTPSA id r202sm1613085pfc.10.2021.02.23.23.17.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Feb 2021 23:17:55 -0800 (PST)
References: <20210223033442.3267258-1-david@fromorbit.com> <20210223033442.3267258-7-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: remove need_start_rec parameter from xlog_write()
In-reply-to: <20210223033442.3267258-7-david@fromorbit.com>
Date:   Wed, 24 Feb 2021 12:47:53 +0530
Message-ID: <87tuq2orxa.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Feb 2021 at 09:04, Dave Chinner wrote:
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

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 44 +++++++++++++++++++++----------------------
>  fs/xfs/xfs_log_cil.c  |  3 ++-
>  fs/xfs/xfs_log_priv.h |  3 +--
>  3 files changed, 25 insertions(+), 25 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 493454c98c6f..6c3fb6dcb505 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -871,9 +871,7 @@ xlog_wait_on_iclog_lsn(
>  static int
>  xlog_write_unmount_record(
>  	struct xlog		*log,
> -	struct xlog_ticket	*ticket,
> -	xfs_lsn_t		*lsn,
> -	uint			flags)
> +	struct xlog_ticket	*ticket)
>  {
>  	struct xfs_unmount_log_format ulf = {
>  		.magic = XLOG_UNMOUNT_TYPE,
> @@ -890,7 +888,7 @@ xlog_write_unmount_record(
>  
>  	/* account for space used by record data */
>  	ticket->t_curr_res -= sizeof(ulf);
> -	return xlog_write(log, &vec, ticket, lsn, NULL, flags, false);
> +	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
>  }
>  
>  /*
> @@ -904,15 +902,13 @@ xlog_unmount_write(
>  	struct xfs_mount	*mp = log->l_mp;
>  	struct xlog_in_core	*iclog;
>  	struct xlog_ticket	*tic = NULL;
> -	xfs_lsn_t		lsn;
> -	uint			flags = XLOG_UNMOUNT_TRANS;
>  	int			error;
>  
>  	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
>  	if (error)
>  		goto out_err;
>  
> -	error = xlog_write_unmount_record(log, tic, &lsn, flags);
> +	error = xlog_write_unmount_record(log, tic);
>  	/*
>  	 * At this point, we're umounting anyway, so there's no point in
>  	 * transitioning log state to IOERROR. Just continue...
> @@ -1604,8 +1600,7 @@ xlog_commit_record(
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return -EIO;
>  
> -	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
> -			   false);
> +	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
>  	if (error)
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	return error;
> @@ -2202,13 +2197,16 @@ static int
>  xlog_write_calc_vec_length(
>  	struct xlog_ticket	*ticket,
>  	struct xfs_log_vec	*log_vector,
> -	bool			need_start_rec)
> +	uint			optype)
>  {
>  	struct xfs_log_vec	*lv;
> -	int			headers = need_start_rec ? 1 : 0;
> +	int			headers = 0;
>  	int			len = 0;
>  	int			i;
>  
> +	if (optype & XLOG_START_TRANS)
> +		headers++;
> +
>  	for (lv = log_vector; lv; lv = lv->lv_next) {
>  		/* we don't write ordered log vectors */
>  		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
> @@ -2428,8 +2426,7 @@ xlog_write(
>  	struct xlog_ticket	*ticket,
>  	xfs_lsn_t		*start_lsn,
>  	struct xlog_in_core	**commit_iclog,
> -	uint			flags,
> -	bool			need_start_rec)
> +	uint			optype)
>  {
>  	struct xlog_in_core	*iclog = NULL;
>  	struct xfs_log_vec	*lv = log_vector;
> @@ -2457,8 +2454,9 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> -	len = xlog_write_calc_vec_length(ticket, log_vector, need_start_rec);
> -	*start_lsn = 0;
> +	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
> +	if (start_lsn)
> +		*start_lsn = 0;
>  	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  		void		*ptr;
>  		int		log_offset;
> @@ -2472,7 +2470,7 @@ xlog_write(
>  		ptr = iclog->ic_datap + log_offset;
>  
>  		/* start_lsn is the first lsn written to. That's all we need. */
> -		if (!*start_lsn)
> +		if (start_lsn && !*start_lsn)
>  			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  
>  		/*
> @@ -2485,6 +2483,7 @@ xlog_write(
>  			int			copy_len;
>  			int			copy_off;
>  			bool			ordered = false;
> +			bool			wrote_start_rec = false;
>  
>  			/* ordered log vectors have no regions to write */
>  			if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> @@ -2502,13 +2501,15 @@ xlog_write(
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
>  			}
>  
> -			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, flags);
> +			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, optype);
>  			if (!ophdr)
>  				return -EIO;
>  
> @@ -2539,14 +2540,13 @@ xlog_write(
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
> @@ -2590,7 +2590,7 @@ xlog_write(
>  	spin_lock(&log->l_icloglock);
>  	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
>  	if (commit_iclog) {
> -		ASSERT(flags & XLOG_COMMIT_TRANS);
> +		ASSERT(optype & XLOG_COMMIT_TRANS);
>  		*commit_iclog = iclog;
>  	} else {
>  		error = xlog_state_release_iclog(log, iclog);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 8bcacd463f06..4093d2d0db7c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -827,7 +827,8 @@ xlog_cil_push_work(
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
> index a7ac85aaff4e..10a41b1dd895 100644
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


-- 
chandan
