Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C35C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F35620722
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YHBl7zi/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgGAIef (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgGAIee (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:34:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D66C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:34:34 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b92so10731721pjc.4
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 01:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yK0YufsLwwLFkmJMFJXGt5Tl9QOUi2gxFG5zu7oIbNA=;
        b=YHBl7zi/0aAgBVOZUW8YrFojGn0n7baVToAHTyFVb3j9pIfXqDWNNyqlvfV+EglPp5
         3jzbVujfzMv23AnWuabJoCiP7EqUHPCQoZYd9BtzHdhmBs86C9kYgUkX2HukRmYZFBUw
         F/0j+2M/WNy3tF+Y4axfoX+hSzZzPJAMOjOg3vPwkBUNjeCUZTTOQYbHhU7WRJxzWZUl
         i5nnsRH1sPb/g+x91F+xDHgbDUy7r9+hRkeirCqRj9J35sID/kzitERnQAKTIRXS3Yuz
         PGVOhv8qHqKKUlk3kIJRuEq6EHpHbR/cOhi6ME4vL7W3fYQM3ig6er3tRpiSrsFbmN0A
         QvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yK0YufsLwwLFkmJMFJXGt5Tl9QOUi2gxFG5zu7oIbNA=;
        b=pDzyR5QNu+6bJQQJ/P7qhvJJvj9kHDSquqE1uLSHtR4ivE8x1P+Tuh5+QgbJIqucqR
         RNJsTrwB3YuawcKzIkXSI2g9yExqKmslhhcgxX7bD94QG5m7NSjLp8yTAvtndvkLWctX
         mikUYnLAX5WdJ6lXRijOn5S1etKHkNgY2OLwM66Jf4kA7Z0yub4+XWUvnNqjIfMDunwz
         2iWkHbIFkMoUK2BfD4d5qFJlcSmt4xKKEeg3IAjTBN1td1zJCPalm8GI/aSiEQnoeEdX
         uD6lvF5c82j0h9s//hhuZriZ3rFmwQF6f6M//oI5KU6UNraC2wqgstd8jt8YGfB/arXz
         +Q2g==
X-Gm-Message-State: AOAM531wTRGzXTGafzb65UBXvTug0TZYaduareXJaKSNGCx1tTv9I21W
        4zhjgRRY5gsVd/B8v8ucdkQwCBue
X-Google-Smtp-Source: ABdhPJw2uTLZNJ2W7O4Uu5LVuDdJ1qW7v+UNAnEw0ieji7n1UDc7Po5Lp01+f86ZPZw3rfqU9tAadQ==
X-Received: by 2002:a17:90a:1a17:: with SMTP id 23mr26565055pjk.231.1593592474018;
        Wed, 01 Jul 2020 01:34:34 -0700 (PDT)
Received: from garuda.localnet ([122.171.188.144])
        by smtp.gmail.com with ESMTPSA id 7sm5024526pgw.85.2020.07.01.01.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 01:34:33 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/18] xfs: stop using q_core warning counters in the quota code
Date:   Wed, 01 Jul 2020 14:03:53 +0530
Message-ID: <2469034.gFGatWfaE4@garuda>
In-Reply-To: <159353176856.2864738.18281608729457160086.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353176856.2864738.18281608729457160086.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:12:48 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add warning counter fields to the incore dquot, and use that instead of
> the ones in qcore.  This eliminates a bunch of endian conversions and
> will eventually allow us to remove qcore entirely.
>

The changes are logically correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c       |   14 +++++++++++---
>  fs/xfs/xfs_dquot.h       |    8 ++++++++
>  fs/xfs/xfs_qm.c          |   12 ++++++------
>  fs/xfs/xfs_qm_syscalls.c |   12 ++++++------
>  fs/xfs/xfs_trans_dquot.c |    6 +++---
>  5 files changed, 34 insertions(+), 18 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 02eae8c2ba1b..a1edb49ceda5 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -139,7 +139,7 @@ xfs_qm_adjust_dqtimers(
>  			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
>  					defq->btimelimit);
>  		} else {
> -			d->d_bwarns = 0;
> +			dq->q_blk.warnings = 0;
>  		}
>  	} else {
>  		if ((!dq->q_blk.softlimit ||
> @@ -158,7 +158,7 @@ xfs_qm_adjust_dqtimers(
>  			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
>  					defq->itimelimit);
>  		} else {
> -			d->d_iwarns = 0;
> +			dq->q_ino.warnings = 0;
>  		}
>  	} else {
>  		if ((!dq->q_ino.softlimit ||
> @@ -177,7 +177,7 @@ xfs_qm_adjust_dqtimers(
>  			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
>  					defq->rtbtimelimit);
>  		} else {
> -			d->d_rtbwarns = 0;
> +			dq->q_rtb.warnings = 0;
>  		}
>  	} else {
>  		if ((!dq->q_rtb.softlimit ||
> @@ -542,6 +542,10 @@ xfs_dquot_from_disk(
>  	dqp->q_ino.count = be64_to_cpu(ddqp->d_icount);
>  	dqp->q_rtb.count = be64_to_cpu(ddqp->d_rtbcount);
>  
> +	dqp->q_blk.warnings = be16_to_cpu(ddqp->d_bwarns);
> +	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
> +	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
> +
>  	/*
>  	 * Reservation counters are defined as reservation plus current usage
>  	 * to avoid having to add every time.
> @@ -573,6 +577,10 @@ xfs_dquot_to_disk(
>  	ddqp->d_bcount = cpu_to_be64(dqp->q_blk.count);
>  	ddqp->d_icount = cpu_to_be64(dqp->q_ino.count);
>  	ddqp->d_rtbcount = cpu_to_be64(dqp->q_rtb.count);
> +
> +	ddqp->d_bwarns = cpu_to_be16(dqp->q_blk.warnings);
> +	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
> +	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
>  }
>  
>  /* Allocate and initialize the dquot buffer for this in-core dquot. */
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 23e05b0d7567..5840bc54b772 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -37,6 +37,14 @@ struct xfs_dquot_res {
>  	/* Absolute and preferred limits. */
>  	xfs_qcnt_t		hardlimit;
>  	xfs_qcnt_t		softlimit;
> +
> +	/*
> +	 * For root dquots, this is the maximum number of warnings that will
> +	 * be issued for this quota type.  Otherwise, this is the number of
> +	 * warnings issued against this quota.  Note that none of this is
> +	 * implemented.
> +	 */
> +	xfs_qwarncnt_t		warnings;
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b47bba204240..4e233cfef46d 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -616,12 +616,12 @@ xfs_qm_init_timelimits(
>  		defq->itimelimit = be32_to_cpu(ddqp->d_itimer);
>  	if (ddqp->d_rtbtimer)
>  		defq->rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
> -	if (ddqp->d_bwarns)
> -		defq->bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
> -	if (ddqp->d_iwarns)
> -		defq->iwarnlimit = be16_to_cpu(ddqp->d_iwarns);
> -	if (ddqp->d_rtbwarns)
> -		defq->rtbwarnlimit = be16_to_cpu(ddqp->d_rtbwarns);
> +	if (dqp->q_blk.warnings)
> +		defq->bwarnlimit = dqp->q_blk.warnings;
> +	if (dqp->q_ino.warnings)
> +		defq->iwarnlimit = dqp->q_ino.warnings;
> +	if (dqp->q_rtb.warnings)
> +		defq->rtbwarnlimit = dqp->q_rtb.warnings;
>  
>  	xfs_qm_dqdestroy(dqp);
>  }
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index ab596d389e3e..5d3bccdbd3bf 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -548,11 +548,11 @@ xfs_qm_scall_setqlim(
>  	 * Update warnings counter(s) if requested
>  	 */
>  	if (newlim->d_fieldmask & QC_SPC_WARNS)
> -		ddq->d_bwarns = cpu_to_be16(newlim->d_spc_warns);
> +		dqp->q_blk.warnings = newlim->d_spc_warns;
>  	if (newlim->d_fieldmask & QC_INO_WARNS)
> -		ddq->d_iwarns = cpu_to_be16(newlim->d_ino_warns);
> +		dqp->q_ino.warnings = newlim->d_ino_warns;
>  	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
> -		ddq->d_rtbwarns = cpu_to_be16(newlim->d_rt_spc_warns);
> +		dqp->q_rtb.warnings = newlim->d_rt_spc_warns;
>  
>  	if (id == 0) {
>  		if (newlim->d_fieldmask & QC_SPC_WARNS)
> @@ -627,13 +627,13 @@ xfs_qm_scall_getquota_fill_qc(
>  	dst->d_ino_count = dqp->q_ino.reserved;
>  	dst->d_spc_timer = be32_to_cpu(dqp->q_core.d_btimer);
>  	dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
> -	dst->d_ino_warns = be16_to_cpu(dqp->q_core.d_iwarns);
> -	dst->d_spc_warns = be16_to_cpu(dqp->q_core.d_bwarns);
> +	dst->d_ino_warns = dqp->q_ino.warnings;
> +	dst->d_spc_warns = dqp->q_blk.warnings;
>  	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.hardlimit);
>  	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.softlimit);
>  	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
>  	dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
> -	dst->d_rt_spc_warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
> +	dst->d_rt_spc_warns = dqp->q_rtb.warnings;
>  
>  	/*
>  	 * Internally, we don't reset all the timers when quota enforcement
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index b36d747989a7..21ed8eda3c80 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -592,7 +592,7 @@ xfs_trans_dqresv(
>  		if (!softlimit)
>  			softlimit = defq->bsoftlimit;
>  		timer = be32_to_cpu(dqp->q_core.d_btimer);
> -		warns = be16_to_cpu(dqp->q_core.d_bwarns);
> +		warns = dqp->q_blk.warnings;
>  		warnlimit = defq->bwarnlimit;
>  		resbcountp = &dqp->q_blk.reserved;
>  	} else {
> @@ -604,7 +604,7 @@ xfs_trans_dqresv(
>  		if (!softlimit)
>  			softlimit = defq->rtbsoftlimit;
>  		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
> -		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
> +		warns = dqp->q_rtb.warnings;
>  		warnlimit = defq->rtbwarnlimit;
>  		resbcountp = &dqp->q_rtb.reserved;
>  	}
> @@ -639,7 +639,7 @@ xfs_trans_dqresv(
>  		if (ninos > 0) {
>  			total_count = dqp->q_ino.reserved + ninos;
>  			timer = be32_to_cpu(dqp->q_core.d_itimer);
> -			warns = be16_to_cpu(dqp->q_core.d_iwarns);
> +			warns = dqp->q_ino.warnings;
>  			warnlimit = defq->iwarnlimit;
>  			hardlimit = dqp->q_ino.hardlimit;
>  			if (!hardlimit)
> 
> 


-- 
chandan



