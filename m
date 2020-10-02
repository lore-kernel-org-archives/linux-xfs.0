Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27ABCC4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 08:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1C1B20738
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 08:53:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QKGrm4qh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgJBIxW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 04:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJBIxW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 04:53:22 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE12C0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 01:53:22 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t23so428568pji.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 01:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GoLH7TKrt0RaTKPiJV36cH8Pqiw7tGuEVNohqKkUgY8=;
        b=QKGrm4qhzCmM1dUzNnu0r8rXVoAZu0urjnLpnXfCEHXtE4N3Wf7h/7rkEGZ2b2dP5i
         mTSRKnuxwOh/gSDQejEnQFCFk6IuNkL69cFg9L2sR51LUQXAVrpWWXTe43BoOrv2PWJm
         MPWye78/YmDz3dYEgElbhsEzP2lUtibNaKmXQ5TVp7cxrc4fEt7uhbr4bXzIz+hvlMBv
         L4UFkXMrHWizsXt8QfVOzluBoG2Hw/SWT+P9aV1o+DiWcMwy41mss2XU1RdW4GncjC47
         Y+MUjnUZcQ85jOsCSlbbGbINMCYfxBP1xOr7+9W0yd+cm7kzp0olz25nkG1E0bkjGnKk
         f0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GoLH7TKrt0RaTKPiJV36cH8Pqiw7tGuEVNohqKkUgY8=;
        b=qeM93ZTCcCHhwH8ShcDWkJqYHYvPodo7Ip9KiKQC/JJ47BFotyvjiZJRKqB1vt3pPg
         2Uafim3hLuqpeCZ/UpceEsg9bsD5sP2qN/nVL81QPI7cO254zBR9foeLXJq3fSKaVCzX
         bfI0/DlSMsrXEHpT1P9Uk4+b5fVDnRatkvQFnpbuUywMx9mS3XHUQ29nrbKy3XAhtQ32
         rlqKZzZV8dNmMso56BcJ7W4q0/RuIm2UW2XsImUMM8ohLiWeD8n26+hKq1Lwn2NTrEF/
         4u0wQPWQ8tICQ8IJT6DVX9aLTs/GwFf+f3meiUBSJWFnMAAnr67ldhOZTSI9i6GsQYOr
         WAVQ==
X-Gm-Message-State: AOAM533ov4QfKOY36MeAOk048bEeZ7tRyw9IjzD53OdoNmiC2UPDpwW6
        snqRce/TI6eWeSJMntptTlOy/LQH4Oo=
X-Google-Smtp-Source: ABdhPJzmYiAKZmngnonLDgBDBCHw0rzFXpTX598JZsgeW2E9IjCwHXGvOGyE2wm/WpawkTuW+637Hw==
X-Received: by 2002:a17:90b:20a:: with SMTP id fy10mr1696428pjb.209.1601628801514;
        Fri, 02 Oct 2020 01:53:21 -0700 (PDT)
Received: from garuda.localnet ([122.172.184.91])
        by smtp.gmail.com with ESMTPSA id h35sm967950pgl.31.2020.10.02.01.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 01:53:20 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: streamline xfs_getfsmap performance
Date:   Fri, 02 Oct 2020 14:22:55 +0530
Message-ID: <1731855.LdHk33rxQF@garuda>
In-Reply-To: <160161417069.1967459.11222290374186255598.stgit@magnolia>
References: <160161415855.1967459.13623226657245838117.stgit@magnolia> <160161417069.1967459.11222290374186255598.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 2 October 2020 10:19:30 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_getfsmap to improve its performance: instead of indirectly
> calling a function that copies one record to userspace at a time, create
> a shadow buffer in the kernel and copy the whole array once at the end.
> This should speed it up significantly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Overall code flow is logically correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/xfs_fsmap.c |   35 +++++++++++++++-----------
>  fs/xfs/xfs_fsmap.h |    6 +----
>  fs/xfs/xfs_ioctl.c |   69 ++++++++++++++++++++++------------------------------
>  3 files changed, 50 insertions(+), 60 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index aa36e7daf82c..3f2666c62a60 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -155,8 +155,7 @@ xfs_fsmap_owner_from_rmap(
>  /* getfsmap query state */
>  struct xfs_getfsmap_info {
>  	struct xfs_fsmap_head	*head;
> -	xfs_fsmap_format_t	formatter;	/* formatting fn */
> -	void			*format_arg;	/* format buffer */
> +	struct fsmap		*fsmap_recs;	/* mapping records */
>  	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
>  	xfs_daddr_t		next_daddr;	/* next daddr we expect */
>  	u64			missing_owner;	/* owner of holes */
> @@ -224,6 +223,20 @@ xfs_getfsmap_is_shared(
>  	return 0;
>  }
>  
> +static inline void
> +xfs_getfsmap_format(
> +	struct xfs_mount		*mp,
> +	struct xfs_fsmap		*xfm,
> +	struct xfs_getfsmap_info	*info)
> +{
> +	struct fsmap			*rec;
> +
> +	trace_xfs_getfsmap_mapping(mp, xfm);
> +
> +	rec = &info->fsmap_recs[info->head->fmh_entries++];
> +	xfs_fsmap_from_internal(rec, xfm);
> +}
> +
>  /*
>   * Format a reverse mapping for getfsmap, having translated rm_startblock
>   * into the appropriate daddr units.
> @@ -288,10 +301,7 @@ xfs_getfsmap_helper(
>  		fmr.fmr_offset = 0;
>  		fmr.fmr_length = rec_daddr - info->next_daddr;
>  		fmr.fmr_flags = FMR_OF_SPECIAL_OWNER;
> -		error = info->formatter(&fmr, info->format_arg);
> -		if (error)
> -			return error;
> -		info->head->fmh_entries++;
> +		xfs_getfsmap_format(mp, &fmr, info);
>  	}
>  
>  	if (info->last)
> @@ -323,11 +333,8 @@ xfs_getfsmap_helper(
>  		if (shared)
>  			fmr.fmr_flags |= FMR_OF_SHARED;
>  	}
> -	error = info->formatter(&fmr, info->format_arg);
> -	if (error)
> -		return error;
> -	info->head->fmh_entries++;
>  
> +	xfs_getfsmap_format(mp, &fmr, info);
>  out:
>  	rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
>  	if (info->next_daddr < rec_daddr)
> @@ -796,7 +803,7 @@ xfs_getfsmap_check_keys(
>  
>  /*
>   * Get filesystem's extents as described in head, and format for
> - * output.  Calls formatter to fill the user's buffer until all
> + * output.  Calls xfs_getfsmap_format to fill the user's buffer until all
>   * extents are mapped, until the passed-in head->fmh_count slots have
>   * been filled, or until the formatter short-circuits the loop, if it
>   * is tracking filled-in extents on its own.
> @@ -819,8 +826,7 @@ int
>  xfs_getfsmap(
>  	struct xfs_mount		*mp,
>  	struct xfs_fsmap_head		*head,
> -	xfs_fsmap_format_t		formatter,
> -	void				*arg)
> +	struct fsmap			*fsmap_recs)
>  {
>  	struct xfs_trans		*tp = NULL;
>  	struct xfs_fsmap		dkeys[2];	/* per-dev keys */
> @@ -895,8 +901,7 @@ xfs_getfsmap(
>  
>  	info.next_daddr = head->fmh_keys[0].fmr_physical +
>  			  head->fmh_keys[0].fmr_length;
> -	info.formatter = formatter;
> -	info.format_arg = arg;
> +	info.fsmap_recs = fsmap_recs;
>  	info.head = head;
>  
>  	/*
> diff --git a/fs/xfs/xfs_fsmap.h b/fs/xfs/xfs_fsmap.h
> index c6c57739b862..a0775788e7b1 100644
> --- a/fs/xfs/xfs_fsmap.h
> +++ b/fs/xfs/xfs_fsmap.h
> @@ -27,13 +27,9 @@ struct xfs_fsmap_head {
>  	struct xfs_fsmap fmh_keys[2];	/* low and high keys */
>  };
>  
> -void xfs_fsmap_from_internal(struct fsmap *dest, struct xfs_fsmap *src);
>  void xfs_fsmap_to_internal(struct xfs_fsmap *dest, struct fsmap *src);
>  
> -/* fsmap to userspace formatter - copy to user & advance pointer */
> -typedef int (*xfs_fsmap_format_t)(struct xfs_fsmap *, void *);
> -
>  int xfs_getfsmap(struct xfs_mount *mp, struct xfs_fsmap_head *head,
> -		xfs_fsmap_format_t formatter, void *arg);
> +		struct fsmap *out_recs);
>  
>  #endif /* __XFS_FSMAP_H__ */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index bca7659fb5c6..e0f2100b74b0 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1716,38 +1716,15 @@ xfs_ioc_getbmap(
>  	return error;
>  }
>  
> -struct getfsmap_info {
> -	struct xfs_mount	*mp;
> -	struct fsmap_head __user *data;
> -	unsigned int		idx;
> -	__u32			last_flags;
> -};
> -
> -STATIC int
> -xfs_getfsmap_format(struct xfs_fsmap *xfm, void *priv)
> -{
> -	struct getfsmap_info	*info = priv;
> -	struct fsmap		fm;
> -
> -	trace_xfs_getfsmap_mapping(info->mp, xfm);
> -
> -	info->last_flags = xfm->fmr_flags;
> -	xfs_fsmap_from_internal(&fm, xfm);
> -	if (copy_to_user(&info->data->fmh_recs[info->idx++], &fm,
> -			sizeof(struct fsmap)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
>  STATIC int
>  xfs_ioc_getfsmap(
>  	struct xfs_inode	*ip,
>  	struct fsmap_head	__user *arg)
>  {
> -	struct getfsmap_info	info = { NULL };
>  	struct xfs_fsmap_head	xhead = {0};
>  	struct fsmap_head	head;
> +	struct fsmap		*recs;
> +	unsigned int		count;
>  	bool			aborted = false;
>  	int			error;
>  
> @@ -1760,38 +1737,50 @@ xfs_ioc_getfsmap(
>  		       sizeof(head.fmh_keys[1].fmr_reserved)))
>  		return -EINVAL;
>  
> +	count = min_t(unsigned int, head.fmh_count,
> +			UINT_MAX / sizeof(struct fsmap));
> +	recs = kvzalloc(count * sizeof(struct fsmap), GFP_KERNEL);
> +	if (!recs)
> +		return -ENOMEM;
> +
>  	xhead.fmh_iflags = head.fmh_iflags;
> -	xhead.fmh_count = head.fmh_count;
> +	xhead.fmh_count = count;
>  	xfs_fsmap_to_internal(&xhead.fmh_keys[0], &head.fmh_keys[0]);
>  	xfs_fsmap_to_internal(&xhead.fmh_keys[1], &head.fmh_keys[1]);
>  
>  	trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
>  	trace_xfs_getfsmap_high_key(ip->i_mount, &xhead.fmh_keys[1]);
>  
> -	info.mp = ip->i_mount;
> -	info.data = arg;
> -	error = xfs_getfsmap(ip->i_mount, &xhead, xfs_getfsmap_format, &info);
> +	error = xfs_getfsmap(ip->i_mount, &xhead, recs);
>  	if (error == -ECANCELED) {
>  		error = 0;
>  		aborted = true;
>  	} else if (error)
> -		return error;
> -
> -	/* If we didn't abort, set the "last" flag in the last fmx */
> -	if (!aborted && info.idx) {
> -		info.last_flags |= FMR_OF_LAST;
> -		if (copy_to_user(&info.data->fmh_recs[info.idx - 1].fmr_flags,
> -				&info.last_flags, sizeof(info.last_flags)))
> -			return -EFAULT;
> -	}
> +		goto out_free;
>  
>  	/* copy back header */
> +	error = -EFAULT;
>  	head.fmh_entries = xhead.fmh_entries;
>  	head.fmh_oflags = xhead.fmh_oflags;
>  	if (copy_to_user(arg, &head, sizeof(struct fsmap_head)))
> -		return -EFAULT;
> +		goto out_free;
>  
> -	return 0;
> +	/* Copy records if userspace wasn't asking only for a record count. */
> +	if (head.fmh_count > 0) {
> +		/* If we didn't abort, set the "last" flag in the last record */
> +		if (!aborted && xhead.fmh_entries > 0)
> +			recs[xhead.fmh_entries - 1].fmr_flags |= FMR_OF_LAST;
> +
> +		/* Copy all records out to userspace. */
> +		if (copy_to_user(arg->fmh_recs, recs,
> +				 xhead.fmh_entries * sizeof(struct fsmap)))
> +			goto out_free;
> +	}
> +
> +	error = 0;
> +out_free:
> +	kmem_free(recs);
> +	return error;
>  }
>  
>  STATIC int
> 
> 


-- 
chandan



