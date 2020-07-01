Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77B7C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 986642074D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:52:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ar7ljAOx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgGAIw1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGAIw1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:52:27 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A53C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:52:26 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f2so9647250plr.8
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 01:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Caq+fzji3kH41uD8CDMMNdnBljdqnIcJczuAhiWULY=;
        b=ar7ljAOxw9307yUG5waC7Byr/61gMBjJEsRRobu9lhBN+logD3h0K38ZAm8/7sNcAh
         PrmifAuVx9xYRQnmLcbNB7wS2m/LRbN0BYbOOg9lWLpKK3n4AhefWGjLMTNkpuLsdJAx
         8kWJXeIkiO09Su7glFH8JE4kIHKKkE3XwYDCEZFEXpw5573pfLl3hiAAZUIJzGRQTy2b
         Tr7z+gQ9yn7MRNQDZusXNW5QXSfCkZpQLu5CTN/JC/zZoH7iP9qVqoSk2OM7P7Df1KXs
         aO7sVoK7Mc+6bWV0YEgevuPoo6ocrgb/+ZEukP3s+dWZ3t3M0Wu8N8NZpNN8xOka2jkR
         x6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Caq+fzji3kH41uD8CDMMNdnBljdqnIcJczuAhiWULY=;
        b=cFhZKDTneR0+nI6qDtM2uou7UCSopBo1WB0ULtrxiv7qk7YDi4ViVEsYxENOWw5/e3
         knxhIBjFyxD3/YPyWcFzkzVfirUiScrwjOGKwzCbhquy1V88VmzZZqvmoTXXn/8nMP/G
         iy1oTwmnNcXxF84NkyLmTQFBb7qV5wLvS5NZI0H0CUHMuPMrab/Voy2Ga6g4o/84VReQ
         DpsQI5rVupo9wpsHb09ofGtSJkiQ76//Xdsi2DZeiOOziOE8BA0+A8gDzG5MMqhzeFdK
         yqjPBzlpXIqzLt/igry4iW8+5+uSCjvDyEdh1JzJyswSF8Pk5idcSFhXeN/WkdzlIUvn
         CNZA==
X-Gm-Message-State: AOAM5316ldJE6HNlqK1VWhNMdEBkZDen6Htcz1rBJxdhq6WcJrRZpZSi
        v5b3A5lKMud33hc0PpT9EHkSZXOD
X-Google-Smtp-Source: ABdhPJz6ohvriELgwp47s/EExHnjMa94lZl1UqbPuOS8wN/OT+wVhopd+qTvlW4PPAy4+KrhAjD7Mg==
X-Received: by 2002:a17:90a:ea86:: with SMTP id h6mr26255299pjz.200.1593593546294;
        Wed, 01 Jul 2020 01:52:26 -0700 (PDT)
Received: from garuda.localnet ([122.171.188.144])
        by smtp.gmail.com with ESMTPSA id q24sm2314622pfg.34.2020.07.01.01.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 01:52:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/18] xfs: refactor default quota limits by resource
Date:   Wed, 01 Jul 2020 14:22:23 +0530
Message-ID: <1658715.XKNHrzK5kB@garuda>
In-Reply-To: <159353178739.2864738.11605071453935920102.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353178739.2864738.11605071453935920102.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:13:07 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've split up the dquot resource fields into separate structs,
> do the same for the default limits to enable further refactoring.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c       |   30 +++++++++++++++---------------
>  fs/xfs/xfs_qm.c          |   36 ++++++++++++++++++------------------
>  fs/xfs/xfs_qm.h          |   22 ++++++++++------------
>  fs/xfs/xfs_qm_syscalls.c |   24 ++++++++++++------------
>  fs/xfs/xfs_quotaops.c    |   12 ++++++------
>  fs/xfs/xfs_trans_dquot.c |   18 +++++++++---------
>  6 files changed, 70 insertions(+), 72 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 2d6b50760962..6975c27145fc 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -76,22 +76,22 @@ xfs_qm_adjust_dqlimits(
>  	ASSERT(dq->q_id);
>  	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
>  
> -	if (defq->bsoftlimit && !dq->q_blk.softlimit) {
> -		dq->q_blk.softlimit = defq->bsoftlimit;
> +	if (defq->dfq_blk.softlimit && !dq->q_blk.softlimit) {
> +		dq->q_blk.softlimit = defq->dfq_blk.softlimit;
>  		prealloc = 1;
>  	}
> -	if (defq->bhardlimit && !dq->q_blk.hardlimit) {
> -		dq->q_blk.hardlimit = defq->bhardlimit;
> +	if (defq->dfq_blk.hardlimit && !dq->q_blk.hardlimit) {
> +		dq->q_blk.hardlimit = defq->dfq_blk.hardlimit;
>  		prealloc = 1;
>  	}
> -	if (defq->isoftlimit && !dq->q_ino.softlimit)
> -		dq->q_ino.softlimit = defq->isoftlimit;
> -	if (defq->ihardlimit && !dq->q_ino.hardlimit)
> -		dq->q_ino.hardlimit = defq->ihardlimit;
> -	if (defq->rtbsoftlimit && !dq->q_rtb.softlimit)
> -		dq->q_rtb.softlimit = defq->rtbsoftlimit;
> -	if (defq->rtbhardlimit && !dq->q_rtb.hardlimit)
> -		dq->q_rtb.hardlimit = defq->rtbhardlimit;
> +	if (defq->dfq_ino.softlimit && !dq->q_ino.softlimit)
> +		dq->q_ino.softlimit = defq->dfq_ino.softlimit;
> +	if (defq->dfq_ino.hardlimit && !dq->q_ino.hardlimit)
> +		dq->q_ino.hardlimit = defq->dfq_ino.hardlimit;
> +	if (defq->dfq_rtb.softlimit && !dq->q_rtb.softlimit)
> +		dq->q_rtb.softlimit = defq->dfq_rtb.softlimit;
> +	if (defq->dfq_rtb.hardlimit && !dq->q_rtb.hardlimit)
> +		dq->q_rtb.hardlimit = defq->dfq_rtb.hardlimit;
>  
>  	if (prealloc)
>  		xfs_dquot_set_prealloc_limits(dq);
> @@ -136,7 +136,7 @@ xfs_qm_adjust_dqtimers(
>  		    (dq->q_blk.hardlimit &&
>  		     (dq->q_blk.count > dq->q_blk.hardlimit))) {
>  			dq->q_blk.timer = ktime_get_real_seconds() +
> -					defq->btimelimit;
> +					defq->dfq_blk.timelimit;
>  		} else {
>  			dq->q_blk.warnings = 0;
>  		}
> @@ -155,7 +155,7 @@ xfs_qm_adjust_dqtimers(
>  		    (dq->q_ino.hardlimit &&
>  		     (dq->q_ino.count > dq->q_ino.hardlimit))) {
>  			dq->q_ino.timer = ktime_get_real_seconds() +
> -					defq->itimelimit;
> +					defq->dfq_ino.timelimit;
>  		} else {
>  			dq->q_ino.warnings = 0;
>  		}
> @@ -174,7 +174,7 @@ xfs_qm_adjust_dqtimers(
>  		    (dq->q_rtb.hardlimit &&
>  		     (dq->q_rtb.count > dq->q_rtb.hardlimit))) {
>  			dq->q_rtb.timer = ktime_get_real_seconds() +
> -					defq->rtbtimelimit;
> +					defq->dfq_rtb.timelimit;
>  		} else {
>  			dq->q_rtb.warnings = 0;
>  		}
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index a56c6e4a5d99..28326a6264a8 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -562,12 +562,12 @@ xfs_qm_set_defquota(
>  	 * Timers and warnings have been already set, let's just set the
>  	 * default limits for this quota type
>  	 */
> -	defq->bhardlimit = dqp->q_blk.hardlimit;
> -	defq->bsoftlimit = dqp->q_blk.softlimit;
> -	defq->ihardlimit = dqp->q_ino.hardlimit;
> -	defq->isoftlimit = dqp->q_ino.softlimit;
> -	defq->rtbhardlimit = dqp->q_rtb.hardlimit;
> -	defq->rtbsoftlimit = dqp->q_rtb.softlimit;
> +	defq->dfq_blk.hardlimit = dqp->q_blk.hardlimit;
> +	defq->dfq_blk.softlimit = dqp->q_blk.softlimit;
> +	defq->dfq_ino.hardlimit = dqp->q_ino.hardlimit;
> +	defq->dfq_ino.softlimit = dqp->q_ino.softlimit;
> +	defq->dfq_rtb.hardlimit = dqp->q_rtb.hardlimit;
> +	defq->dfq_rtb.softlimit = dqp->q_rtb.softlimit;
>  	xfs_qm_dqdestroy(dqp);
>  }
>  
> @@ -584,12 +584,12 @@ xfs_qm_init_timelimits(
>  
>  	defq = xfs_get_defquota(qinf, type);
>  
> -	defq->btimelimit = XFS_QM_BTIMELIMIT;
> -	defq->itimelimit = XFS_QM_ITIMELIMIT;
> -	defq->rtbtimelimit = XFS_QM_RTBTIMELIMIT;
> -	defq->bwarnlimit = XFS_QM_BWARNLIMIT;
> -	defq->iwarnlimit = XFS_QM_IWARNLIMIT;
> -	defq->rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
> +	defq->dfq_blk.timelimit = XFS_QM_BTIMELIMIT;
> +	defq->dfq_ino.timelimit = XFS_QM_ITIMELIMIT;
> +	defq->dfq_rtb.timelimit = XFS_QM_RTBTIMELIMIT;
> +	defq->dfq_blk.warnlimit = XFS_QM_BWARNLIMIT;
> +	defq->dfq_ino.warnlimit = XFS_QM_IWARNLIMIT;
> +	defq->dfq_rtb.warnlimit = XFS_QM_RTBWARNLIMIT;
>  
>  	/*
>  	 * We try to get the limits from the superuser's limits fields.
> @@ -608,17 +608,17 @@ xfs_qm_init_timelimits(
>  	 * more writing. If it is zero, a default is used.
>  	 */
>  	if (dqp->q_blk.timer)
> -		defq->btimelimit = dqp->q_blk.timer;
> +		defq->dfq_blk.timelimit = dqp->q_blk.timer;
>  	if (dqp->q_ino.timer)
> -		defq->itimelimit = dqp->q_ino.timer;
> +		defq->dfq_ino.timelimit = dqp->q_ino.timer;
>  	if (dqp->q_rtb.timer)
> -		defq->rtbtimelimit = dqp->q_rtb.timer;
> +		defq->dfq_rtb.timelimit = dqp->q_rtb.timer;
>  	if (dqp->q_blk.warnings)
> -		defq->bwarnlimit = dqp->q_blk.warnings;
> +		defq->dfq_blk.warnlimit = dqp->q_blk.warnings;
>  	if (dqp->q_ino.warnings)
> -		defq->iwarnlimit = dqp->q_ino.warnings;
> +		defq->dfq_ino.warnlimit = dqp->q_ino.warnings;
>  	if (dqp->q_rtb.warnings)
> -		defq->rtbwarnlimit = dqp->q_rtb.warnings;
> +		defq->dfq_rtb.warnlimit = dqp->q_rtb.warnings;
>  
>  	xfs_qm_dqdestroy(dqp);
>  }
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 6ed4ae942603..e2f0027f0ac1 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -41,20 +41,18 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
>   */
>  #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
>  
> +struct xfs_def_qres {
> +	xfs_qcnt_t		hardlimit;	/* default hard limit */
> +	xfs_qcnt_t		softlimit;	/* default soft limit */
> +	time64_t		timelimit;	/* limit for timers */
> +	xfs_qwarncnt_t		warnlimit;	/* limit for warnings */
> +};
> +
>  /* Defaults for each quota type: time limits, warn limits, usage limits */
>  struct xfs_def_quota {
> -	time64_t	btimelimit;	/* limit for blks timer */
> -	time64_t	itimelimit;	/* limit for inodes timer */
> -	time64_t	rtbtimelimit;	/* limit for rt blks timer */
> -	xfs_qwarncnt_t	bwarnlimit;	/* limit for blks warnings */
> -	xfs_qwarncnt_t	iwarnlimit;	/* limit for inodes warnings */
> -	xfs_qwarncnt_t	rtbwarnlimit;	/* limit for rt blks warnings */
> -	xfs_qcnt_t	bhardlimit;	/* default data blk hard limit */
> -	xfs_qcnt_t	bsoftlimit;	/* default data blk soft limit */
> -	xfs_qcnt_t	ihardlimit;	/* default inode count hard limit */
> -	xfs_qcnt_t	isoftlimit;	/* default inode count soft limit */
> -	xfs_qcnt_t	rtbhardlimit;	/* default realtime blk hard limit */
> -	xfs_qcnt_t	rtbsoftlimit;	/* default realtime blk soft limit */
> +	struct xfs_def_qres	dfq_blk;
> +	struct xfs_def_qres	dfq_ino;
> +	struct xfs_def_qres	dfq_rtb;
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 1b2b70b1660f..393b88612cc8 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -502,8 +502,8 @@ xfs_qm_scall_setqlim(
>  		dqp->q_blk.softlimit = soft;
>  		xfs_dquot_set_prealloc_limits(dqp);
>  		if (id == 0) {
> -			defq->bhardlimit = hard;
> -			defq->bsoftlimit = soft;
> +			defq->dfq_blk.hardlimit = hard;
> +			defq->dfq_blk.softlimit = soft;
>  		}
>  	} else {
>  		xfs_debug(mp, "blkhard %Ld < blksoft %Ld", hard, soft);
> @@ -518,8 +518,8 @@ xfs_qm_scall_setqlim(
>  		dqp->q_rtb.hardlimit = hard;
>  		dqp->q_rtb.softlimit = soft;
>  		if (id == 0) {
> -			defq->rtbhardlimit = hard;
> -			defq->rtbsoftlimit = soft;
> +			defq->dfq_rtb.hardlimit = hard;
> +			defq->dfq_rtb.softlimit = soft;
>  		}
>  	} else {
>  		xfs_debug(mp, "rtbhard %Ld < rtbsoft %Ld", hard, soft);
> @@ -535,8 +535,8 @@ xfs_qm_scall_setqlim(
>  		dqp->q_ino.hardlimit = hard;
>  		dqp->q_ino.softlimit = soft;
>  		if (id == 0) {
> -			defq->ihardlimit = hard;
> -			defq->isoftlimit = soft;
> +			defq->dfq_ino.hardlimit = hard;
> +			defq->dfq_ino.softlimit = soft;
>  		}
>  	} else {
>  		xfs_debug(mp, "ihard %Ld < isoft %Ld", hard, soft);
> @@ -554,11 +554,11 @@ xfs_qm_scall_setqlim(
>  
>  	if (id == 0) {
>  		if (newlim->d_fieldmask & QC_SPC_WARNS)
> -			defq->bwarnlimit = newlim->d_spc_warns;
> +			defq->dfq_blk.warnlimit = newlim->d_spc_warns;
>  		if (newlim->d_fieldmask & QC_INO_WARNS)
> -			defq->iwarnlimit = newlim->d_ino_warns;
> +			defq->dfq_ino.warnlimit = newlim->d_ino_warns;
>  		if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
> -			defq->rtbwarnlimit = newlim->d_rt_spc_warns;
> +			defq->dfq_rtb.warnlimit = newlim->d_rt_spc_warns;
>  	}
>  
>  	/*
> @@ -579,11 +579,11 @@ xfs_qm_scall_setqlim(
>  
>  	if (id == 0) {
>  		if (newlim->d_fieldmask & QC_SPC_TIMER)
> -			defq->btimelimit = newlim->d_spc_timer;
> +			defq->dfq_blk.timelimit = newlim->d_spc_timer;
>  		if (newlim->d_fieldmask & QC_INO_TIMER)
> -			defq->itimelimit = newlim->d_ino_timer;
> +			defq->dfq_ino.timelimit = newlim->d_ino_timer;
>  		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
> -			defq->rtbtimelimit = newlim->d_rt_spc_timer;
> +			defq->dfq_rtb.timelimit = newlim->d_rt_spc_timer;
>  	}
>  
>  	if (id != 0) {
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index bf809b77a316..c86a6fe263da 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -37,12 +37,12 @@ xfs_qm_fill_state(
>  	tstate->flags |= QCI_SYSFILE;
>  	tstate->blocks = ip->i_d.di_nblocks;
>  	tstate->nextents = ip->i_df.if_nextents;
> -	tstate->spc_timelimit = (u32)defq->btimelimit;
> -	tstate->ino_timelimit = (u32)defq->itimelimit;
> -	tstate->rt_spc_timelimit = (u32)defq->rtbtimelimit;
> -	tstate->spc_warnlimit = defq->bwarnlimit;
> -	tstate->ino_warnlimit = defq->iwarnlimit;
> -	tstate->rt_spc_warnlimit = defq->rtbwarnlimit;
> +	tstate->spc_timelimit = (u32)defq->dfq_blk.timelimit;
> +	tstate->ino_timelimit = (u32)defq->dfq_ino.timelimit;
> +	tstate->rt_spc_timelimit = (u32)defq->dfq_rtb.timelimit;
> +	tstate->spc_warnlimit = defq->dfq_blk.warnlimit;
> +	tstate->ino_warnlimit = defq->dfq_ino.warnlimit;
> +	tstate->rt_spc_warnlimit = defq->dfq_rtb.warnlimit;
>  	if (tempqip)
>  		xfs_irele(ip);
>  }
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 28b59a4069a3..392e51baad6f 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -587,25 +587,25 @@ xfs_trans_dqresv(
>  	if (flags & XFS_TRANS_DQ_RES_BLKS) {
>  		hardlimit = dqp->q_blk.hardlimit;
>  		if (!hardlimit)
> -			hardlimit = defq->bhardlimit;
> +			hardlimit = defq->dfq_blk.hardlimit;
>  		softlimit = dqp->q_blk.softlimit;
>  		if (!softlimit)
> -			softlimit = defq->bsoftlimit;
> +			softlimit = defq->dfq_blk.softlimit;
>  		timer = dqp->q_blk.timer;
>  		warns = dqp->q_blk.warnings;
> -		warnlimit = defq->bwarnlimit;
> +		warnlimit = defq->dfq_blk.warnlimit;
>  		resbcountp = &dqp->q_blk.reserved;
>  	} else {
>  		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
>  		hardlimit = dqp->q_rtb.hardlimit;
>  		if (!hardlimit)
> -			hardlimit = defq->rtbhardlimit;
> +			hardlimit = defq->dfq_rtb.hardlimit;
>  		softlimit = dqp->q_rtb.softlimit;
>  		if (!softlimit)
> -			softlimit = defq->rtbsoftlimit;
> +			softlimit = defq->dfq_rtb.softlimit;
>  		timer = dqp->q_rtb.timer;
>  		warns = dqp->q_rtb.warnings;
> -		warnlimit = defq->rtbwarnlimit;
> +		warnlimit = defq->dfq_rtb.warnlimit;
>  		resbcountp = &dqp->q_rtb.reserved;
>  	}
>  
> @@ -640,13 +640,13 @@ xfs_trans_dqresv(
>  			total_count = dqp->q_ino.reserved + ninos;
>  			timer = dqp->q_ino.timer;
>  			warns = dqp->q_ino.warnings;
> -			warnlimit = defq->iwarnlimit;
> +			warnlimit = defq->dfq_ino.warnlimit;
>  			hardlimit = dqp->q_ino.hardlimit;
>  			if (!hardlimit)
> -				hardlimit = defq->ihardlimit;
> +				hardlimit = defq->dfq_ino.hardlimit;
>  			softlimit = dqp->q_ino.softlimit;
>  			if (!softlimit)
> -				softlimit = defq->isoftlimit;
> +				softlimit = defq->dfq_ino.softlimit;
>  
>  			if (hardlimit && total_count > hardlimit) {
>  				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
> 
> 


-- 
chandan



