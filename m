Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4BBC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C616C20775
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVingWQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgGAIec (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgGAIeb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:34:31 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4789C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:34:31 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t6so11372196pgq.1
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 01:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NjP0CSvxK/eU/V8E1buKNc08PyhvedSefTV5jxsFpbo=;
        b=RVingWQX5m4ONhHFn2di89wZgMcjlj7VYh8HeQ2SGbhzwa++VE1WOLdYGs68T3oDev
         VKizK23UwMPxud0rcTWiUDzk1luzWfSCyuLO/O8Yx9R4spjsYhAfyRuo08ad4B4CyMTI
         z/nX6Da1ucNtZemrZRGuecgh4JqD7kxjJ6XEhvMQCeg0ZUdz176TjyPQO2G3t2/YJ7so
         dSUodSOkdhlDtXev/e6gSyR/q/T5sbW1NAHK82fu+d0aDObggEdvxlhyeEULgBOGA1Kj
         f8IiP81VldCuaTNU5V00qKrMHuNcN6EpghpVCHRiVGseYBca9umrJrMIc3Ayn2dqcNDU
         r3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NjP0CSvxK/eU/V8E1buKNc08PyhvedSefTV5jxsFpbo=;
        b=q7itRF/CYpdNTD3sCFoQwb+KA1HqBsmnC1s8VUI6b4WbqIcdcmcPy7bAVBlme/gw1N
         2eRe8sca6yey+iNoRO+j89eM2f4U3KG2X0I7vE9dtxyUH5RyxA3UzrUiYEX+eV5Cz6u5
         R1oN6pq4DCMx1hTKOlVUhikeCEqb7tozQf4BPFOG5xtO3yVljHbF2YPMmN0RSRWRwOYS
         EfJNk7R+s0RFEhzzLs0uFmppbbgRovfq5846bM7ih4+RirQOzWLyvwd+L8U3hCmudI7D
         o3Wk5/YkzeT61c62Axh2Yqo6SdOd+Bfd3YJnaHOEMy64CJQL+0SCPqU8+6QIUY0g9c3L
         orwg==
X-Gm-Message-State: AOAM531wdTNadsAHIWUrXieREp0zzb0KLyBoX8LwjVDguWeO2oTmDwBV
        Ik7jN7aIY3me46MRDiZzrnyEwzgH
X-Google-Smtp-Source: ABdhPJySPzm1caEk3aQJlGCV2LGjZ/QbQP1dOGoOtA2D+SXeIAK+b+yaLqWhL6P33aVVqSXxO7S0wA==
X-Received: by 2002:aa7:86c1:: with SMTP id h1mr10443255pfo.175.1593592471165;
        Wed, 01 Jul 2020 01:34:31 -0700 (PDT)
Received: from garuda.localnet ([122.171.188.144])
        by smtp.gmail.com with ESMTPSA id 10sm5011848pfx.136.2020.07.01.01.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 01:34:30 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/18] xfs: stop using q_core timers in the quota code
Date:   Wed, 01 Jul 2020 14:04:01 +0530
Message-ID: <1753373.Ggxvy1xQFO@garuda>
In-Reply-To: <159353177481.2864738.2222411495060044495.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353177481.2864738.2222411495060044495.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:12:54 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add timers fields to the incore dquot, and use that instead of the ones
> in qcore.  This eliminates a bunch of endian conversions and will
> eventually allow us to remove qcore entirely.
>

The changes are logically correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c       |   41 +++++++++++++++++++++++------------------
>  fs/xfs/xfs_dquot.h       |    7 +++++++
>  fs/xfs/xfs_qm.c          |   15 ++++++---------
>  fs/xfs/xfs_qm_syscalls.c |   18 ++++++++----------
>  fs/xfs/xfs_trans_dquot.c |    6 +++---
>  5 files changed, 47 insertions(+), 40 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index a1edb49ceda5..7434ee57ec43 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -116,7 +116,6 @@ xfs_qm_adjust_dqtimers(
>  	struct xfs_dquot	*dq)
>  {
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> -	struct xfs_disk_dquot	*d = &dq->q_core;
>  	struct xfs_def_quota	*defq;
>  
>  	ASSERT(dq->q_id);
> @@ -131,13 +130,13 @@ xfs_qm_adjust_dqtimers(
>  		ASSERT(dq->q_rtb.softlimit <= dq->q_rtb.hardlimit);
>  #endif
>  
> -	if (!d->d_btimer) {
> +	if (!dq->q_blk.timer) {
>  		if ((dq->q_blk.softlimit &&
>  		     (dq->q_blk.count > dq->q_blk.softlimit)) ||
>  		    (dq->q_blk.hardlimit &&
>  		     (dq->q_blk.count > dq->q_blk.hardlimit))) {
> -			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
> -					defq->btimelimit);
> +			dq->q_blk.timer = ktime_get_real_seconds() +
> +					defq->btimelimit;
>  		} else {
>  			dq->q_blk.warnings = 0;
>  		}
> @@ -146,17 +145,17 @@ xfs_qm_adjust_dqtimers(
>  		     (dq->q_blk.count <= dq->q_blk.softlimit)) &&
>  		    (!dq->q_blk.hardlimit ||
>  		    (dq->q_blk.count <= dq->q_blk.hardlimit))) {
> -			d->d_btimer = 0;
> +			dq->q_blk.timer = 0;
>  		}
>  	}
>  
> -	if (!d->d_itimer) {
> +	if (!dq->q_ino.timer) {
>  		if ((dq->q_ino.softlimit &&
>  		     (dq->q_ino.count > dq->q_ino.softlimit)) ||
>  		    (dq->q_ino.hardlimit &&
>  		     (dq->q_ino.count > dq->q_ino.hardlimit))) {
> -			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
> -					defq->itimelimit);
> +			dq->q_ino.timer = ktime_get_real_seconds() +
> +					defq->itimelimit;
>  		} else {
>  			dq->q_ino.warnings = 0;
>  		}
> @@ -165,17 +164,17 @@ xfs_qm_adjust_dqtimers(
>  		     (dq->q_ino.count <= dq->q_ino.softlimit))  &&
>  		    (!dq->q_ino.hardlimit ||
>  		     (dq->q_ino.count <= dq->q_ino.hardlimit))) {
> -			d->d_itimer = 0;
> +			dq->q_ino.timer = 0;
>  		}
>  	}
>  
> -	if (!d->d_rtbtimer) {
> +	if (!dq->q_rtb.timer) {
>  		if ((dq->q_rtb.softlimit &&
>  		     (dq->q_rtb.count > dq->q_rtb.softlimit)) ||
>  		    (dq->q_rtb.hardlimit &&
>  		     (dq->q_rtb.count > dq->q_rtb.hardlimit))) {
> -			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
> -					defq->rtbtimelimit);
> +			dq->q_rtb.timer = ktime_get_real_seconds() +
> +					defq->rtbtimelimit;
>  		} else {
>  			dq->q_rtb.warnings = 0;
>  		}
> @@ -184,7 +183,7 @@ xfs_qm_adjust_dqtimers(
>  		     (dq->q_rtb.count <= dq->q_rtb.softlimit)) &&
>  		    (!dq->q_rtb.hardlimit ||
>  		     (dq->q_rtb.count <= dq->q_rtb.hardlimit))) {
> -			d->d_rtbtimer = 0;
> +			dq->q_rtb.timer = 0;
>  		}
>  	}
>  }
> @@ -546,6 +545,10 @@ xfs_dquot_from_disk(
>  	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
>  	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
>  
> +	dqp->q_blk.timer = be32_to_cpu(ddqp->d_btimer);
> +	dqp->q_ino.timer = be32_to_cpu(ddqp->d_itimer);
> +	dqp->q_rtb.timer = be32_to_cpu(ddqp->d_rtbtimer);
> +
>  	/*
>  	 * Reservation counters are defined as reservation plus current usage
>  	 * to avoid having to add every time.
> @@ -581,6 +584,10 @@ xfs_dquot_to_disk(
>  	ddqp->d_bwarns = cpu_to_be16(dqp->q_blk.warnings);
>  	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
>  	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
> +
> +	ddqp->d_btimer = cpu_to_be32(dqp->q_blk.timer);
> +	ddqp->d_itimer = cpu_to_be32(dqp->q_ino.timer);
> +	ddqp->d_rtbtimer = cpu_to_be32(dqp->q_rtb.timer);
>  }
>  
>  /* Allocate and initialize the dquot buffer for this in-core dquot. */
> @@ -1135,8 +1142,6 @@ static xfs_failaddr_t
>  xfs_qm_dqflush_check(
>  	struct xfs_dquot	*dqp)
>  {
> -	struct xfs_disk_dquot	*ddq = &dqp->q_core;
> -
>  	if (hweight8(dqp->dq_flags & XFS_DQ_ALLTYPES) != 1)
>  		return __this_address;
>  
> @@ -1144,15 +1149,15 @@ xfs_qm_dqflush_check(
>  		return NULL;
>  
>  	if (dqp->q_blk.softlimit && dqp->q_blk.count > dqp->q_blk.softlimit &&
> -	    !ddq->d_btimer)
> +	    !dqp->q_blk.timer)
>  		return __this_address;
>  
>  	if (dqp->q_ino.softlimit && dqp->q_ino.count > dqp->q_ino.softlimit &&
> -	    !ddq->d_itimer)
> +	    !dqp->q_ino.timer)
>  		return __this_address;
>  
>  	if (dqp->q_rtb.softlimit && dqp->q_rtb.count > dqp->q_rtb.softlimit &&
> -	    !ddq->d_rtbtimer)
> +	    !dqp->q_rtb.timer)
>  		return __this_address;
>  
>  	return NULL;
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 5840bc54b772..414bae537b1d 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -38,6 +38,13 @@ struct xfs_dquot_res {
>  	xfs_qcnt_t		hardlimit;
>  	xfs_qcnt_t		softlimit;
>  
> +	/*
> +	 * For root dquots, this is the default grace period, in seconds.
> +	 * Otherwise, this is when the quota grace period expires,
> +	 * in seconds since the Unix epoch.
> +	 */
> +	time64_t		timer;
> +
>  	/*
>  	 * For root dquots, this is the maximum number of warnings that will
>  	 * be issued for this quota type.  Otherwise, this is the number of
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 4e233cfef46d..a56c6e4a5d99 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -579,7 +579,6 @@ xfs_qm_init_timelimits(
>  {
>  	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
>  	struct xfs_def_quota	*defq;
> -	struct xfs_disk_dquot	*ddqp;
>  	struct xfs_dquot	*dqp;
>  	int			error;
>  
> @@ -603,19 +602,17 @@ xfs_qm_init_timelimits(
>  	if (error)
>  		return;
>  
> -	ddqp = &dqp->q_core;
> -
>  	/*
>  	 * The warnings and timers set the grace period given to
>  	 * a user or group before he or she can not perform any
>  	 * more writing. If it is zero, a default is used.
>  	 */
> -	if (ddqp->d_btimer)
> -		defq->btimelimit = be32_to_cpu(ddqp->d_btimer);
> -	if (ddqp->d_itimer)
> -		defq->itimelimit = be32_to_cpu(ddqp->d_itimer);
> -	if (ddqp->d_rtbtimer)
> -		defq->rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
> +	if (dqp->q_blk.timer)
> +		defq->btimelimit = dqp->q_blk.timer;
> +	if (dqp->q_ino.timer)
> +		defq->itimelimit = dqp->q_ino.timer;
> +	if (dqp->q_rtb.timer)
> +		defq->rtbtimelimit = dqp->q_rtb.timer;
>  	if (dqp->q_blk.warnings)
>  		defq->bwarnlimit = dqp->q_blk.warnings;
>  	if (dqp->q_ino.warnings)
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 5d3bccdbd3bf..1b2b70b1660f 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -447,7 +447,6 @@ xfs_qm_scall_setqlim(
>  	struct qc_dqblk		*newlim)
>  {
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
> -	struct xfs_disk_dquot	*ddq;
>  	struct xfs_dquot	*dqp;
>  	struct xfs_trans	*tp;
>  	struct xfs_def_quota	*defq;
> @@ -488,7 +487,6 @@ xfs_qm_scall_setqlim(
>  
>  	xfs_dqlock(dqp);
>  	xfs_trans_dqjoin(tp, dqp);
> -	ddq = &dqp->q_core;
>  
>  	/*
>  	 * Make sure that hardlimits are >= soft limits before changing.
> @@ -573,11 +571,11 @@ xfs_qm_scall_setqlim(
>  	 * the soft limit.
>  	 */
>  	if (newlim->d_fieldmask & QC_SPC_TIMER)
> -		ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
> +		dqp->q_blk.timer = newlim->d_spc_timer;
>  	if (newlim->d_fieldmask & QC_INO_TIMER)
> -		ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
> +		dqp->q_ino.timer = newlim->d_ino_timer;
>  	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
> -		ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
> +		dqp->q_rtb.timer = newlim->d_rt_spc_timer;
>  
>  	if (id == 0) {
>  		if (newlim->d_fieldmask & QC_SPC_TIMER)
> @@ -621,18 +619,18 @@ xfs_qm_scall_getquota_fill_qc(
>  	memset(dst, 0, sizeof(*dst));
>  	dst->d_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_blk.hardlimit);
>  	dst->d_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_blk.softlimit);
> -	dst->d_ino_hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
> -	dst->d_ino_softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
> +	dst->d_ino_hardlimit = dqp->q_ino.hardlimit;
> +	dst->d_ino_softlimit = dqp->q_ino.softlimit;
>  	dst->d_space = XFS_FSB_TO_B(mp, dqp->q_blk.reserved);
>  	dst->d_ino_count = dqp->q_ino.reserved;
> -	dst->d_spc_timer = be32_to_cpu(dqp->q_core.d_btimer);
> -	dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
> +	dst->d_spc_timer = dqp->q_blk.timer;
> +	dst->d_ino_timer = dqp->q_ino.timer;
>  	dst->d_ino_warns = dqp->q_ino.warnings;
>  	dst->d_spc_warns = dqp->q_blk.warnings;
>  	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.hardlimit);
>  	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.softlimit);
>  	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
> -	dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
> +	dst->d_rt_spc_timer = dqp->q_rtb.timer;
>  	dst->d_rt_spc_warns = dqp->q_rtb.warnings;
>  
>  	/*
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 21ed8eda3c80..28b59a4069a3 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -591,7 +591,7 @@ xfs_trans_dqresv(
>  		softlimit = dqp->q_blk.softlimit;
>  		if (!softlimit)
>  			softlimit = defq->bsoftlimit;
> -		timer = be32_to_cpu(dqp->q_core.d_btimer);
> +		timer = dqp->q_blk.timer;
>  		warns = dqp->q_blk.warnings;
>  		warnlimit = defq->bwarnlimit;
>  		resbcountp = &dqp->q_blk.reserved;
> @@ -603,7 +603,7 @@ xfs_trans_dqresv(
>  		softlimit = dqp->q_rtb.softlimit;
>  		if (!softlimit)
>  			softlimit = defq->rtbsoftlimit;
> -		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
> +		timer = dqp->q_rtb.timer;
>  		warns = dqp->q_rtb.warnings;
>  		warnlimit = defq->rtbwarnlimit;
>  		resbcountp = &dqp->q_rtb.reserved;
> @@ -638,7 +638,7 @@ xfs_trans_dqresv(
>  		}
>  		if (ninos > 0) {
>  			total_count = dqp->q_ino.reserved + ninos;
> -			timer = be32_to_cpu(dqp->q_core.d_itimer);
> +			timer = dqp->q_ino.timer;
>  			warns = dqp->q_ino.warnings;
>  			warnlimit = defq->iwarnlimit;
>  			hardlimit = dqp->q_ino.hardlimit;
> 
> 


-- 
chandan



