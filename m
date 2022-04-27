Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A39AC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 20:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiD0UcT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 16:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbiD0UcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 16:32:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95208B2477
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 13:29:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F81161D0A
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 20:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DBCC385A7;
        Wed, 27 Apr 2022 20:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651091345;
        bh=iNRkpJ1oAga0XYKRwGox7jQfxBnWV6YmIPF2OkRRx8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lgkRMImArsDqjCTf0GsObU5fDQMTxfnnf3DQaLMfSUa03Yc100ypg744WYoXnHHRu
         OQUOm46Dk3jMJ7soFuKy5mF3GbXfG5p4jhlouvHCI5s0666ZFzqwCvQSocR0r6HAlm
         AZj1fXxP4nIts2xEaq611WBS/iNl+eAGZX0HW+ZLAZfWaG0FKroDQQ2thJsVRac2rn
         Q4A3Wk3Hf0i5fTbpEUvlvwQo9ZwHtthCUnzxW/KPPjULtnnEtXRxGsXZArP7x471CR
         pwCb2gDm+xC1oGeg64XA/REmgcmKQMrmYW79ml+RHbop+GULt86/kXBF6JSMO4y76F
         zgjHmdD5JYe+g==
Date:   Wed, 27 Apr 2022 13:29:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 1/2] xfs: remove quota warning limit from struct
 xfs_quota_limits
Message-ID: <20220427202905.GK17025@magnolia>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <20220421165815.87837-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220421165815.87837-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 21, 2022 at 09:58:14AM -0700, Catherine Hoang wrote:
> Warning limits in xfs quota is an unused feature that is currently
> documented as unimplemented, and it is unclear what the intended behavior
> of these limits are. Remove the ‘warn’ field from struct xfs_quota_limits
> and any other related code.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Oh, yeah, I suppose I did forget to RVBtag this:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm.c          |  9 ---------
>  fs/xfs/xfs_qm.h          |  5 -----
>  fs/xfs/xfs_qm_syscalls.c | 17 +++--------------
>  fs/xfs/xfs_quotaops.c    |  3 ---
>  fs/xfs/xfs_trans_dquot.c |  3 +--
>  5 files changed, 4 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index f165d1a3de1d..8fc813cb6011 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -582,9 +582,6 @@ xfs_qm_init_timelimits(
>  	defq->blk.time = XFS_QM_BTIMELIMIT;
>  	defq->ino.time = XFS_QM_ITIMELIMIT;
>  	defq->rtb.time = XFS_QM_RTBTIMELIMIT;
> -	defq->blk.warn = XFS_QM_BWARNLIMIT;
> -	defq->ino.warn = XFS_QM_IWARNLIMIT;
> -	defq->rtb.warn = XFS_QM_RTBWARNLIMIT;
>  
>  	/*
>  	 * We try to get the limits from the superuser's limits fields.
> @@ -608,12 +605,6 @@ xfs_qm_init_timelimits(
>  		defq->ino.time = dqp->q_ino.timer;
>  	if (dqp->q_rtb.timer)
>  		defq->rtb.time = dqp->q_rtb.timer;
> -	if (dqp->q_blk.warnings)
> -		defq->blk.warn = dqp->q_blk.warnings;
> -	if (dqp->q_ino.warnings)
> -		defq->ino.warn = dqp->q_ino.warnings;
> -	if (dqp->q_rtb.warnings)
> -		defq->rtb.warn = dqp->q_rtb.warnings;
>  
>  	xfs_qm_dqdestroy(dqp);
>  }
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 5bb12717ea28..9683f0457d19 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -34,7 +34,6 @@ struct xfs_quota_limits {
>  	xfs_qcnt_t		hard;	/* default hard limit */
>  	xfs_qcnt_t		soft;	/* default soft limit */
>  	time64_t		time;	/* limit for timers */
> -	xfs_qwarncnt_t		warn;	/* limit for warnings */
>  };
>  
>  /* Defaults for each quota type: time limits, warn limits, usage limits */
> @@ -134,10 +133,6 @@ struct xfs_dquot_acct {
>  #define XFS_QM_RTBTIMELIMIT	(7 * 24*60*60)          /* 1 week */
>  #define XFS_QM_ITIMELIMIT	(7 * 24*60*60)          /* 1 week */
>  
> -#define XFS_QM_BWARNLIMIT	5
> -#define XFS_QM_IWARNLIMIT	5
> -#define XFS_QM_RTBWARNLIMIT	5
> -
>  extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
>  
>  /* quota ops */
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 7d5a31827681..e7f3ac60ebd9 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -250,17 +250,6 @@ xfs_setqlim_limits(
>  	return true;
>  }
>  
> -static inline void
> -xfs_setqlim_warns(
> -	struct xfs_dquot_res	*res,
> -	struct xfs_quota_limits	*qlim,
> -	int			warns)
> -{
> -	res->warnings = warns;
> -	if (qlim)
> -		qlim->warn = warns;
> -}
> -
>  static inline void
>  xfs_setqlim_timer(
>  	struct xfs_mount	*mp,
> @@ -355,7 +344,7 @@ xfs_qm_scall_setqlim(
>  	if (xfs_setqlim_limits(mp, res, qlim, hard, soft, "blk"))
>  		xfs_dquot_set_prealloc_limits(dqp);
>  	if (newlim->d_fieldmask & QC_SPC_WARNS)
> -		xfs_setqlim_warns(res, qlim, newlim->d_spc_warns);
> +		res->warnings = newlim->d_spc_warns;
>  	if (newlim->d_fieldmask & QC_SPC_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim->d_spc_timer);
>  
> @@ -371,7 +360,7 @@ xfs_qm_scall_setqlim(
>  
>  	xfs_setqlim_limits(mp, res, qlim, hard, soft, "rtb");
>  	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
> -		xfs_setqlim_warns(res, qlim, newlim->d_rt_spc_warns);
> +		res->warnings = newlim->d_rt_spc_warns;
>  	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim->d_rt_spc_timer);
>  
> @@ -387,7 +376,7 @@ xfs_qm_scall_setqlim(
>  
>  	xfs_setqlim_limits(mp, res, qlim, hard, soft, "ino");
>  	if (newlim->d_fieldmask & QC_INO_WARNS)
> -		xfs_setqlim_warns(res, qlim, newlim->d_ino_warns);
> +		res->warnings = newlim->d_ino_warns;
>  	if (newlim->d_fieldmask & QC_INO_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim->d_ino_timer);
>  
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 07989bd67728..8b80cc43a6d1 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -40,9 +40,6 @@ xfs_qm_fill_state(
>  	tstate->spc_timelimit = (u32)defq->blk.time;
>  	tstate->ino_timelimit = (u32)defq->ino.time;
>  	tstate->rt_spc_timelimit = (u32)defq->rtb.time;
> -	tstate->spc_warnlimit = defq->blk.warn;
> -	tstate->ino_warnlimit = defq->ino.warn;
> -	tstate->rt_spc_warnlimit = defq->rtb.warn;
>  	if (tempqip)
>  		xfs_irele(ip);
>  }
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 9ba7e6b9bed3..7b8c24ede1fd 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -597,8 +597,7 @@ xfs_dqresv_check(
>  	if (softlimit && total_count > softlimit) {
>  		time64_t	now = ktime_get_real_seconds();
>  
> -		if ((res->timer != 0 && now > res->timer) ||
> -		    (res->warnings != 0 && res->warnings >= qlim->warn)) {
> +		if (res->timer != 0 && now > res->timer) {
>  			*fatal = true;
>  			return QUOTA_NL_ISOFTLONGWARN;
>  		}
> -- 
> 2.27.0
> 
