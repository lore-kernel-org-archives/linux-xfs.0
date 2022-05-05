Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217CCC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238490AbiEEQXn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiEEQXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:23:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7051E5C36B
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:20:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18185B82C77
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA889C385A8;
        Thu,  5 May 2022 16:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651767599;
        bh=6lDLPgl8f98WPY2Ca6A2I+f7YYPeh+1D/BaiBaJMYSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AH6daMkm/rtBw0ZVYJOFHsrdnzruvg17aaKOh7kMsHc1gxzYqNSdbp9+5QcKqibKz
         95BHF9RRSoUmvhf3rMcgjvK0FSflIzK0iHLh8IcZRJ0fakoNSRtn2UNSJC/S2+SDZJ
         mYP5V17OBVrQfUc1fYrwPR406QJNEtaY56QKHgdwrmFytLb6SclLEclk2Zr1Jkg/On
         ss57hXVkhup0DdIlAc0QDUpeouJFZdABW5lDA33eCbROBg6zyhMezjnht+YxPi2UKI
         FSC/2jHhPiuXtPmtKKAQyj5kxFpuDRE4lFSmyBfbarQtWxVhYzP15MFY9faVqboBgr
         XQOjfD9KP0oGw==
Date:   Thu, 5 May 2022 09:19:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] xfs: remove warning counters from struct
 xfs_dquot_res
Message-ID: <20220505161959.GA27212@magnolia>
References: <20220505011815.20075-1-catherine.hoang@oracle.com>
 <20220505011815.20075-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505011815.20075-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 04, 2022 at 06:18:14PM -0700, Catherine Hoang wrote:
> Warning counts are not used anywhere in the kernel. In addition, there
> are no use cases, test coverage, or documentation for this
> functionality. Remove the 'warnings' field from struct xfs_dquot_res and
> any other related code.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_quota_defs.h |  1 -
>  fs/xfs/xfs_dquot.c             | 15 ++++-----------
>  fs/xfs/xfs_dquot.h             |  8 --------
>  fs/xfs/xfs_qm_syscalls.c       | 12 +++---------
>  4 files changed, 7 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index a02c5062f9b2..c1e96abefed2 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -16,7 +16,6 @@
>   * and quota-limits. This is a waste in the common case, but hey ...
>   */
>  typedef uint64_t	xfs_qcnt_t;
> -typedef uint16_t	xfs_qwarncnt_t;
>  
>  typedef uint8_t		xfs_dqtype_t;
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 5afedcbc78c7..aff727ba603f 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -136,10 +136,7 @@ xfs_qm_adjust_res_timer(
>  			res->timer = xfs_dquot_set_timeout(mp,
>  					ktime_get_real_seconds() + qlim->time);
>  	} else {
> -		if (res->timer == 0)
> -			res->warnings = 0;
> -		else
> -			res->timer = 0;
> +		res->timer = 0;
>  	}
>  }
>  
> @@ -589,10 +586,6 @@ xfs_dquot_from_disk(
>  	dqp->q_ino.count = be64_to_cpu(ddqp->d_icount);
>  	dqp->q_rtb.count = be64_to_cpu(ddqp->d_rtbcount);
>  
> -	dqp->q_blk.warnings = be16_to_cpu(ddqp->d_bwarns);
> -	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
> -	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
> -
>  	dqp->q_blk.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_btimer);
>  	dqp->q_ino.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_itimer);
>  	dqp->q_rtb.timer = xfs_dquot_from_disk_ts(ddqp, ddqp->d_rtbtimer);
> @@ -634,9 +627,9 @@ xfs_dquot_to_disk(
>  	ddqp->d_icount = cpu_to_be64(dqp->q_ino.count);
>  	ddqp->d_rtbcount = cpu_to_be64(dqp->q_rtb.count);
>  
> -	ddqp->d_bwarns = cpu_to_be16(dqp->q_blk.warnings);
> -	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
> -	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
> +    ddqp->d_bwarns = 0;
> +    ddqp->d_iwarns = 0;
> +    ddqp->d_rtbwarns = 0;

Indenting damage here.

>  
>  	ddqp->d_btimer = xfs_dquot_to_disk_ts(dqp, dqp->q_blk.timer);
>  	ddqp->d_itimer = xfs_dquot_to_disk_ts(dqp, dqp->q_ino.timer);
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 6b5e3cf40c8b..80c8f851a2f3 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -44,14 +44,6 @@ struct xfs_dquot_res {
>  	 * in seconds since the Unix epoch.
>  	 */
>  	time64_t		timer;
> -
> -	/*
> -	 * For root dquots, this is the maximum number of warnings that will
> -	 * be issued for this quota type.  Otherwise, this is the number of
> -	 * warnings issued against this quota.  Note that none of this is
> -	 * implemented.
> -	 */
> -	xfs_qwarncnt_t		warnings;
>  };
>  
>  static inline bool
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index e7f3ac60ebd9..2149c203b1d0 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -343,8 +343,6 @@ xfs_qm_scall_setqlim(
>  
>  	if (xfs_setqlim_limits(mp, res, qlim, hard, soft, "blk"))
>  		xfs_dquot_set_prealloc_limits(dqp);
> -	if (newlim->d_fieldmask & QC_SPC_WARNS)
> -		res->warnings = newlim->d_spc_warns;

Ok, so in this patch I guess setting warning counters is a soft fail, in
that you tell the kernel to store '5' and an immediate re-read returns
'0'.  I think that's not an ABI break since two programs racing to set
'5' and '0' could see the same behavior.

(So it's the next patch where we actually introduce the hard failure, if
I'm reading this all correctly.)

With the indentation corrected,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	if (newlim->d_fieldmask & QC_SPC_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim->d_spc_timer);
>  
> @@ -359,8 +357,6 @@ xfs_qm_scall_setqlim(
>  	qlim = id == 0 ? &defq->rtb : NULL;
>  
>  	xfs_setqlim_limits(mp, res, qlim, hard, soft, "rtb");
> -	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
> -		res->warnings = newlim->d_rt_spc_warns;
>  	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim->d_rt_spc_timer);
>  
> @@ -375,8 +371,6 @@ xfs_qm_scall_setqlim(
>  	qlim = id == 0 ? &defq->ino : NULL;
>  
>  	xfs_setqlim_limits(mp, res, qlim, hard, soft, "ino");
> -	if (newlim->d_fieldmask & QC_INO_WARNS)
> -		res->warnings = newlim->d_ino_warns;
>  	if (newlim->d_fieldmask & QC_INO_TIMER)
>  		xfs_setqlim_timer(mp, res, qlim, newlim->d_ino_timer);
>  
> @@ -417,13 +411,13 @@ xfs_qm_scall_getquota_fill_qc(
>  	dst->d_ino_count = dqp->q_ino.reserved;
>  	dst->d_spc_timer = dqp->q_blk.timer;
>  	dst->d_ino_timer = dqp->q_ino.timer;
> -	dst->d_ino_warns = dqp->q_ino.warnings;
> -	dst->d_spc_warns = dqp->q_blk.warnings;
> +	dst->d_ino_warns = 0;
> +	dst->d_spc_warns = 0;
>  	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.hardlimit);
>  	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.softlimit);
>  	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
>  	dst->d_rt_spc_timer = dqp->q_rtb.timer;
> -	dst->d_rt_spc_warns = dqp->q_rtb.warnings;
> +	dst->d_rt_spc_warns = 0;
>  
>  	/*
>  	 * Internally, we don't reset all the timers when quota enforcement
> -- 
> 2.27.0
> 
