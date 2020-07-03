Return-Path: <SRS0=maQ1=AO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6287FC433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 12:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 374AF20CC7
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 12:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="auwPDK+D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgGCMj3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jul 2020 08:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgGCMj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jul 2020 08:39:29 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6A0C08C5C1
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2020 05:39:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l63so15040459pge.12
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jul 2020 05:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7QX7e85XBZZBwq/dK0aQBCqeRK751iZicWzZVmU3KoA=;
        b=auwPDK+Doh3qyLTcE/fq40oNvWXvNAeyjl3eZj/Ssko4uPqvC+bMZcAMbIZLfY6IQL
         YPGpJPw826GC7FzRSqoUsb3cMz2UjcMubRSOh2p4M/KTIgtcqhTGrSGbOqd2zJu8oNZe
         bZnd6hdkduEeYjmvMUdqo7JYZjodQpb42tJDzRYqLs2fv3I6SvRQWacFJbY++aBHZetn
         JYZEFI48MQEZ1yRE8dTC62GVjHrZZJDjz7JV/+jHnJ8XsHc0lNiM9HRyeY3rY2JHeRCX
         Zndzg+lkBBFoeAMvMhVKtFm5ul6ZVzsct1Edix8No32avXeWZ1UA31dRfbTg6lEy1AJi
         Dwdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7QX7e85XBZZBwq/dK0aQBCqeRK751iZicWzZVmU3KoA=;
        b=fbOfaqql27hPz41gJh1PWKk7d7P0w5WCSkJaxGZ/tURD/XPvIuU+WKQCdUy7hS3/qv
         2YIwRx76Nq5QJDjhDb7jZwtYqMgiD9ZNsmdeanFhF+xnRz37tB4r4qonyHTk1dieHh0U
         f1tlv03ikp1oR2UomlXLyjKT5TVvGzJ/SSl3+RezSQZgZZh59IfSxQBkmXY+GFGM9wfw
         vvnXGew8aYJlwnwgFEQLWFbYSTRALorAeajsupzbwNvTKJQhluuB+emSXWjzzlV4URcX
         BIb2mF6LwbUgppkKFR9VsQX6lAW1G6ImuDtH9JrU/qbYRuVvSLAo5gWveq9WSB/gmEFI
         7Y7Q==
X-Gm-Message-State: AOAM533C/nRYnT+hx8Jjmpxwe2nlxCwJXTRxL2W9VF4+sJBCN/ZFrBdN
        KvPbALjn8oTS0oPhF+6dwko=
X-Google-Smtp-Source: ABdhPJw7I3IDoebeQ+sadv/zWAp8ww28uX9zUqR6F9XqAwpvb+5QjlagX3VshWyR6wHdTmwj7sYE0A==
X-Received: by 2002:a63:d10a:: with SMTP id k10mr29137471pgg.382.1593779968717;
        Fri, 03 Jul 2020 05:39:28 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.21])
        by smtp.gmail.com with ESMTPSA id y8sm10945677pju.49.2020.07.03.05.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 05:39:28 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/18] xfs: refactor xfs_qm_scall_setqlim
Date:   Fri, 03 Jul 2020 18:09:25 +0530
Message-ID: <11069869.t8T49tFK3y@garuda>
In-Reply-To: <159353180627.2864738.644970181923295002.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353180627.2864738.644970181923295002.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:13:26 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we can pass around quota resource and limit structures, clean
> up the open-coded field setting in xfs_qm_scall_setqlim.
>

The changes are logically correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_qm_syscalls.c |  164 ++++++++++++++++++++++++++--------------------
>  1 file changed, 93 insertions(+), 71 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 5423e02f9837..5044c333af5c 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -436,6 +436,58 @@ xfs_qm_scall_quotaon(
>  #define XFS_QC_MASK \
>  	(QC_LIMIT_MASK | QC_TIMER_MASK | QC_WARNS_MASK)
>  
> +/*
> + * Adjust limits of this quota, and the defaults if passed in.  Returns true
> + * if the new limits made sense and were applied, false otherwise.
> + */
> +static inline bool
> +xfs_setqlim_limits(
> +	struct xfs_mount	*mp,
> +	struct xfs_dquot_res	*res,
> +	struct xfs_def_qres	*dres,
> +	xfs_qcnt_t		hard,
> +	xfs_qcnt_t		soft,
> +	const char		*tag)
> +{
> +	/* The hard limit can't be less than the soft limit. */
> +	if (hard != 0 && hard < soft) {
> +		xfs_debug(mp, "%shard %lld < %ssoft %lld", tag, hard, tag,
> +				soft);
> +		return false;
> +	}
> +
> +	res->hardlimit = hard;
> +	res->softlimit = soft;
> +	if (dres) {
> +		dres->hardlimit = hard;
> +		dres->softlimit = soft;
> +	}
> +
> +	return true;
> +}
> +
> +static inline void
> +xfs_setqlim_warns(
> +	struct xfs_dquot_res	*res,
> +	struct xfs_def_qres	*dres,
> +	int			warns)
> +{
> +	res->warnings = warns;
> +	if (dres)
> +		dres->warnlimit = warns;
> +}
> +
> +static inline void
> +xfs_setqlim_timer(
> +	struct xfs_dquot_res	*res,
> +	struct xfs_def_qres	*dres,
> +	s64			timer)
> +{
> +	res->timer = timer;
> +	if (dres)
> +		dres->timelimit = timer;
> +}
> +
>  /*
>   * Adjust quota limits, and start/stop timers accordingly.
>   */
> @@ -450,6 +502,8 @@ xfs_qm_scall_setqlim(
>  	struct xfs_dquot	*dqp;
>  	struct xfs_trans	*tp;
>  	struct xfs_def_quota	*defq;
> +	struct xfs_dquot_res	*res;
> +	struct xfs_def_qres	*dres;
>  	int			error;
>  	xfs_qcnt_t		hard, soft;
>  
> @@ -489,102 +543,70 @@ xfs_qm_scall_setqlim(
>  	xfs_trans_dqjoin(tp, dqp);
>  
>  	/*
> +	 * Update quota limits, warnings, and timers, and the defaults
> +	 * if we're touching id == 0.
> +	 *
>  	 * Make sure that hardlimits are >= soft limits before changing.
> +	 *
> +	 * Update warnings counter(s) if requested.
> +	 *
> +	 * Timelimits for the super user set the relative time the other users
> +	 * can be over quota for this file system. If it is zero a default is
> +	 * used.  Ditto for the default soft and hard limit values (already
> +	 * done, above), and for warnings.
> +	 *
> +	 * For other IDs, userspace can bump out the grace period if over
> +	 * the soft limit.
>  	 */
> +
> +	/* Blocks on the data device. */
>  	hard = (newlim->d_fieldmask & QC_SPC_HARD) ?
>  		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_spc_hardlimit) :
>  			dqp->q_blk.hardlimit;
>  	soft = (newlim->d_fieldmask & QC_SPC_SOFT) ?
>  		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_spc_softlimit) :
>  			dqp->q_blk.softlimit;
> -	if (hard == 0 || hard >= soft) {
> -		dqp->q_blk.hardlimit = hard;
> -		dqp->q_blk.softlimit = soft;
> +	res = &dqp->q_blk;
> +	dres = id == 0 ? &defq->dfq_blk : NULL;
> +
> +	if (xfs_setqlim_limits(mp, res, dres, hard, soft, "blk"))
>  		xfs_dquot_set_prealloc_limits(dqp);
> -		if (id == 0) {
> -			defq->dfq_blk.hardlimit = hard;
> -			defq->dfq_blk.softlimit = soft;
> -		}
> -	} else {
> -		xfs_debug(mp, "blkhard %Ld < blksoft %Ld", hard, soft);
> -	}
> +	if (newlim->d_fieldmask & QC_SPC_WARNS)
> +		xfs_setqlim_warns(res, dres, newlim->d_spc_warns);
> +	if (newlim->d_fieldmask & QC_SPC_TIMER)
> +		xfs_setqlim_timer(res, dres, newlim->d_spc_timer);
> +
> +	/* Blocks on the realtime device. */
>  	hard = (newlim->d_fieldmask & QC_RT_SPC_HARD) ?
>  		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_rt_spc_hardlimit) :
>  			dqp->q_rtb.hardlimit;
>  	soft = (newlim->d_fieldmask & QC_RT_SPC_SOFT) ?
>  		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_rt_spc_softlimit) :
>  			dqp->q_rtb.softlimit;
> -	if (hard == 0 || hard >= soft) {
> -		dqp->q_rtb.hardlimit = hard;
> -		dqp->q_rtb.softlimit = soft;
> -		if (id == 0) {
> -			defq->dfq_rtb.hardlimit = hard;
> -			defq->dfq_rtb.softlimit = soft;
> -		}
> -	} else {
> -		xfs_debug(mp, "rtbhard %Ld < rtbsoft %Ld", hard, soft);
> -	}
> +	res = &dqp->q_rtb;
> +	dres = id == 0 ? &defq->dfq_rtb : NULL;
>  
> +	xfs_setqlim_limits(mp, res, dres, hard, soft, "rtb");
> +	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
> +		xfs_setqlim_warns(res, dres, newlim->d_rt_spc_warns);
> +	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
> +		xfs_setqlim_timer(res, dres, newlim->d_rt_spc_timer);
> +
> +	/* Inodes */
>  	hard = (newlim->d_fieldmask & QC_INO_HARD) ?
>  		(xfs_qcnt_t) newlim->d_ino_hardlimit :
>  			dqp->q_ino.hardlimit;
>  	soft = (newlim->d_fieldmask & QC_INO_SOFT) ?
>  		(xfs_qcnt_t) newlim->d_ino_softlimit :
>  			dqp->q_ino.softlimit;
> -	if (hard == 0 || hard >= soft) {
> -		dqp->q_ino.hardlimit = hard;
> -		dqp->q_ino.softlimit = soft;
> -		if (id == 0) {
> -			defq->dfq_ino.hardlimit = hard;
> -			defq->dfq_ino.softlimit = soft;
> -		}
> -	} else {
> -		xfs_debug(mp, "ihard %Ld < isoft %Ld", hard, soft);
> -	}
> +	res = &dqp->q_ino;
> +	dres = id == 0 ? &defq->dfq_ino : NULL;
>  
> -	/*
> -	 * Update warnings counter(s) if requested
> -	 */
> -	if (newlim->d_fieldmask & QC_SPC_WARNS)
> -		dqp->q_blk.warnings = newlim->d_spc_warns;
> +	xfs_setqlim_limits(mp, res, dres, hard, soft, "ino");
>  	if (newlim->d_fieldmask & QC_INO_WARNS)
> -		dqp->q_ino.warnings = newlim->d_ino_warns;
> -	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
> -		dqp->q_rtb.warnings = newlim->d_rt_spc_warns;
> -
> -	if (id == 0) {
> -		if (newlim->d_fieldmask & QC_SPC_WARNS)
> -			defq->dfq_blk.warnlimit = newlim->d_spc_warns;
> -		if (newlim->d_fieldmask & QC_INO_WARNS)
> -			defq->dfq_ino.warnlimit = newlim->d_ino_warns;
> -		if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
> -			defq->dfq_rtb.warnlimit = newlim->d_rt_spc_warns;
> -	}
> -
> -	/*
> -	 * Timelimits for the super user set the relative time the other users
> -	 * can be over quota for this file system. If it is zero a default is
> -	 * used.  Ditto for the default soft and hard limit values (already
> -	 * done, above), and for warnings.
> -	 *
> -	 * For other IDs, userspace can bump out the grace period if over
> -	 * the soft limit.
> -	 */
> -	if (newlim->d_fieldmask & QC_SPC_TIMER)
> -		dqp->q_blk.timer = newlim->d_spc_timer;
> +		xfs_setqlim_warns(res, dres, newlim->d_ino_warns);
>  	if (newlim->d_fieldmask & QC_INO_TIMER)
> -		dqp->q_ino.timer = newlim->d_ino_timer;
> -	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
> -		dqp->q_rtb.timer = newlim->d_rt_spc_timer;
> -
> -	if (id == 0) {
> -		if (newlim->d_fieldmask & QC_SPC_TIMER)
> -			defq->dfq_blk.timelimit = newlim->d_spc_timer;
> -		if (newlim->d_fieldmask & QC_INO_TIMER)
> -			defq->dfq_ino.timelimit = newlim->d_ino_timer;
> -		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
> -			defq->dfq_rtb.timelimit = newlim->d_rt_spc_timer;
> -	}
> +		xfs_setqlim_timer(res, dres, newlim->d_ino_timer);
>  
>  	if (id != 0) {
>  		/*
> 
> 


-- 
chandan



