Return-Path: <SRS0=maQ1=AO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CEBC433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 13:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8135206BE
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 13:00:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YY2Z0fFx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgGCNAn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jul 2020 09:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgGCNAn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jul 2020 09:00:43 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8D7C08C5C1
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2020 06:00:42 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id g17so12634845plq.12
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jul 2020 06:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wt3MkmXmoaXfJJniP4vokOZdwB9eiiGjdupdnxZK93o=;
        b=YY2Z0fFxLh851CCJtG4PJAUxwvqSW6oHCpgDAHNwmZ90rd3JH+Q45YVy34iVxna1p8
         qCbYvcDk1Tzdnhd9EkOzEJbcQYhHJewgw2+qELHu4vervI5m4nF2CwzUlfpTW5rSWXaq
         MdpfCf4nOtHCIkNRyyROmEpc2DqcTu7phLcYA+yi2kG5gqRtvm10JJJv0ncLQ5ORkrm8
         C8mrk9WVqBi+hOPbEfbWpi9V7y6I5d3ZkoVtikZYmTv/Bz90QZ1nu6BoP0OjeYV+kELh
         78IOxtBDgvrOlCurbsI5QrJYm6lSJnqzePwOscHUI7xdrp2/MltHjQ1jwn7V+wWihdJU
         RzRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wt3MkmXmoaXfJJniP4vokOZdwB9eiiGjdupdnxZK93o=;
        b=KE++c+rEuYSyOIfF3R6R5Ve/aPa/2A6Gl0+ryvVUrSZt7VtsaqxItHnkrppJvlvNCb
         eTy2mrjCiQCl9ZBV+T0+NVfOkP+WpT+GALxyx84ht2FNSRbm1B2j2yE2eVwArj+X3dX9
         KkQD/aLQVUjab/q22DGaHz9nMy0bIPnIj578enlEDNLnB1o0yKycvMDmAoAtZhsFKCbV
         rwdLpP2Fl2Abe9mVnukllMiQJt9JxKzwYdFb1G3HlggE7XfnTvJ1Dg6ZEpTpE6oqn/da
         eMC11nmU4140coY/+3GTwFXHwiK6Np2ePGrBhRgrZGRKRR7qs1Db3be8cLjBL4Nvb5lg
         +rBQ==
X-Gm-Message-State: AOAM530EFugodiDt9JOQK49xgCFXOfmOY923PMpv5mhrdAq+jkak3wk3
        IIz1gFbZeMkTWlohu1Lts10=
X-Google-Smtp-Source: ABdhPJycXO02shqbtK2CHtpdHmsl0Tfi03DzI3bXsl9m7LyhHYfpHGubf4U6T+Uwu82bEPlpQUAtbQ==
X-Received: by 2002:a17:90a:d910:: with SMTP id c16mr27201975pjv.136.1593781242346;
        Fri, 03 Jul 2020 06:00:42 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.21])
        by smtp.gmail.com with ESMTPSA id n137sm12110438pfd.194.2020.07.03.06.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 06:00:41 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/18] xfs: refactor xfs_trans_dqresv
Date:   Fri, 03 Jul 2020 18:30:39 +0530
Message-ID: <6301483.sknlpyQ4iU@garuda>
In-Reply-To: <159353181258.2864738.8355431623063896449.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353181258.2864738.8355431623063896449.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:13:32 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've refactored the resource usage and limits into
> per-resource structures, we can refactor some of the open-coded
> reservation limit checking in xfs_trans_dqresv.
>

The changes are consistent with the previous functionality.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_trans_dquot.c |  153 +++++++++++++++++++++++-----------------------
>  1 file changed, 78 insertions(+), 75 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 2712814d696d..30a011dc9828 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -554,6 +554,58 @@ xfs_quota_warn(
>  			   mp->m_super->s_dev, type);
>  }
>  
> +/*
> + * Decide if we can make an additional reservation against a quota resource.
> + * Returns an inode QUOTA_NL_ warning code and whether or not it's fatal.
> + *
> + * Note that we assume that the numeric difference between the inode and block
> + * warning codes will always be 3 since it's userspace ABI now, and will never
> + * decrease the quota reservation, so the *BELOW messages are irrelevant.
> + */
> +static inline int
> +xfs_dqresv_check(
> +	struct xfs_dquot_res	*res,
> +	struct xfs_def_qres	*dres,
> +	int64_t			delta,
> +	bool			*fatal)
> +{
> +	xfs_qcnt_t		hardlimit = res->hardlimit;
> +	xfs_qcnt_t		softlimit = res->softlimit;
> +	xfs_qcnt_t		total_count = res->reserved + delta;
> +
> +	BUILD_BUG_ON(QUOTA_NL_BHARDWARN     != QUOTA_NL_IHARDWARN + 3);
> +	BUILD_BUG_ON(QUOTA_NL_BSOFTLONGWARN != QUOTA_NL_ISOFTLONGWARN + 3);
> +	BUILD_BUG_ON(QUOTA_NL_BSOFTWARN     != QUOTA_NL_ISOFTWARN + 3);
> +
> +	*fatal = false;
> +	if (delta <= 0)
> +		return QUOTA_NL_NOWARN;
> +
> +	if (!hardlimit)
> +		hardlimit = dres->hardlimit;
> +	if (!softlimit)
> +		softlimit = dres->softlimit;
> +
> +	if (hardlimit && total_count > hardlimit) {
> +		*fatal = true;
> +		return QUOTA_NL_IHARDWARN;
> +	}
> +
> +	if (softlimit && total_count > softlimit) {
> +		time64_t	now = ktime_get_real_seconds();
> +
> +		if ((res->timer != 0 && now > res->timer) ||
> +		    (res->warnings != 0 && res->warnings >= dres->warnlimit)) {
> +			*fatal = true;
> +			return QUOTA_NL_ISOFTLONGWARN;
> +		}
> +
> +		return QUOTA_NL_ISOFTWARN;
> +	}
> +
> +	return QUOTA_NL_NOWARN;
> +}
> +
>  /*
>   * This reserves disk blocks and inodes against a dquot.
>   * Flags indicate if the dquot is to be locked here and also
> @@ -569,99 +621,51 @@ xfs_trans_dqresv(
>  	long			ninos,
>  	uint			flags)
>  {
> -	xfs_qcnt_t		hardlimit;
> -	xfs_qcnt_t		softlimit;
> -	time64_t		timer;
> -	xfs_qwarncnt_t		warns;
> -	xfs_qwarncnt_t		warnlimit;
> -	xfs_qcnt_t		total_count;
> -	xfs_qcnt_t		*resbcountp;
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	struct xfs_def_quota	*defq;
> -
> +	struct xfs_dquot_res	*blkres;
> +	struct xfs_def_qres	*def_blkres;
>  
>  	xfs_dqlock(dqp);
>  
>  	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
>  
>  	if (flags & XFS_TRANS_DQ_RES_BLKS) {
> -		hardlimit = dqp->q_blk.hardlimit;
> -		if (!hardlimit)
> -			hardlimit = defq->dfq_blk.hardlimit;
> -		softlimit = dqp->q_blk.softlimit;
> -		if (!softlimit)
> -			softlimit = defq->dfq_blk.softlimit;
> -		timer = dqp->q_blk.timer;
> -		warns = dqp->q_blk.warnings;
> -		warnlimit = defq->dfq_blk.warnlimit;
> -		resbcountp = &dqp->q_blk.reserved;
> +		blkres = &dqp->q_blk;
> +		def_blkres = &defq->dfq_blk;
>  	} else {
> -		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
> -		hardlimit = dqp->q_rtb.hardlimit;
> -		if (!hardlimit)
> -			hardlimit = defq->dfq_rtb.hardlimit;
> -		softlimit = dqp->q_rtb.softlimit;
> -		if (!softlimit)
> -			softlimit = defq->dfq_rtb.softlimit;
> -		timer = dqp->q_rtb.timer;
> -		warns = dqp->q_rtb.warnings;
> -		warnlimit = defq->dfq_rtb.warnlimit;
> -		resbcountp = &dqp->q_rtb.reserved;
> +		blkres = &dqp->q_rtb;
> +		def_blkres = &defq->dfq_rtb;
>  	}
>  
>  	if ((flags & XFS_QMOPT_FORCE_RES) == 0 && dqp->q_id &&
>  	    ((XFS_IS_UQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISUDQ(dqp)) ||
>  	     (XFS_IS_GQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISGDQ(dqp)) ||
>  	     (XFS_IS_PQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISPDQ(dqp)))) {
> -		if (nblks > 0) {
> +		int		quota_nl;
> +		bool		fatal;
> +
> +		/*
> +		 * dquot is locked already. See if we'd go over the hardlimit
> +		 * or exceed the timelimit if we'd reserve resources.
> +		 */
> +		quota_nl = xfs_dqresv_check(blkres, def_blkres, nblks, &fatal);
> +		if (quota_nl != QUOTA_NL_NOWARN) {
>  			/*
> -			 * dquot is locked already. See if we'd go over the
> -			 * hardlimit or exceed the timelimit if we allocate
> -			 * nblks.
> +			 * Quota block warning codes are 3 more than the inode
> +			 * codes, which we check above.
>  			 */
> -			total_count = *resbcountp + nblks;
> -			if (hardlimit && total_count > hardlimit) {
> -				xfs_quota_warn(mp, dqp, QUOTA_NL_BHARDWARN);
> +			xfs_quota_warn(mp, dqp, quota_nl + 3);
> +			if (fatal)
>  				goto error_return;
> -			}
> -			if (softlimit && total_count > softlimit) {
> -				if ((timer != 0 &&
> -				     ktime_get_real_seconds() > timer) ||
> -				    (warns != 0 && warns >= warnlimit)) {
> -					xfs_quota_warn(mp, dqp,
> -						       QUOTA_NL_BSOFTLONGWARN);
> -					goto error_return;
> -				}
> -
> -				xfs_quota_warn(mp, dqp, QUOTA_NL_BSOFTWARN);
> -			}
>  		}
> -		if (ninos > 0) {
> -			total_count = dqp->q_ino.reserved + ninos;
> -			timer = dqp->q_ino.timer;
> -			warns = dqp->q_ino.warnings;
> -			warnlimit = defq->dfq_ino.warnlimit;
> -			hardlimit = dqp->q_ino.hardlimit;
> -			if (!hardlimit)
> -				hardlimit = defq->dfq_ino.hardlimit;
> -			softlimit = dqp->q_ino.softlimit;
> -			if (!softlimit)
> -				softlimit = defq->dfq_ino.softlimit;
>  
> -			if (hardlimit && total_count > hardlimit) {
> -				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
> +		quota_nl = xfs_dqresv_check(&dqp->q_ino, &defq->dfq_ino, ninos,
> +				&fatal);
> +		if (quota_nl != QUOTA_NL_NOWARN) {
> +			xfs_quota_warn(mp, dqp, quota_nl);
> +			if (fatal)
>  				goto error_return;
> -			}
> -			if (softlimit && total_count > softlimit) {
> -				if  ((timer != 0 &&
> -				      ktime_get_real_seconds() > timer) ||
> -				     (warns != 0 && warns >= warnlimit)) {
> -					xfs_quota_warn(mp, dqp,
> -						       QUOTA_NL_ISOFTLONGWARN);
> -					goto error_return;
> -				}
> -				xfs_quota_warn(mp, dqp, QUOTA_NL_ISOFTWARN);
> -			}
>  		}
>  	}
>  
> @@ -669,9 +673,8 @@ xfs_trans_dqresv(
>  	 * Change the reservation, but not the actual usage.
>  	 * Note that q_blk.reserved = q_blk.count + resv
>  	 */
> -	(*resbcountp) += (xfs_qcnt_t)nblks;
> -	if (ninos != 0)
> -		dqp->q_ino.reserved += (xfs_qcnt_t)ninos;
> +	blkres->reserved += (xfs_qcnt_t)nblks;
> +	dqp->q_ino.reserved += (xfs_qcnt_t)ninos;
>  
>  	/*
>  	 * note the reservation amt in the trans struct too,
> 
> 


-- 
chandan



