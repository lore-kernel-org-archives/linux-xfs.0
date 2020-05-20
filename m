Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7899BC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D7B320823
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="slKlg3Jz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgETUbb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 16:31:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgETUbb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 16:31:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKVRw9019322;
        Wed, 20 May 2020 20:31:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=G2+oKH/d0d+3tA5tLQ+zI1sKLm4/9QPYhZYCd8aRbtk=;
 b=slKlg3JzOUHEq4qbx8AJrnL3iO/iydSXtsUxQLs6xQv7omPGggJHu+JrI5aJX1TN0upy
 RkZ/YTC+njj7t9+6wxJMneKgXvohVZyZKc26v+/f6paeGF+Kw4HjpzUkD37chyPIUBT4
 l1Po83FNQwXcbVxTH+d+ngp2jEwnD+4uHF+7TL7orL34nZX3Y8RlmrfSSENnll45MO7N
 boWobsxfxBNmS3pGwjOAPcRZf8vLI3W4d/u3i3tOS1QioQrbwoCYrBrbGUzYxK/o2xzk
 WM52p1sYksyR4AzDkWc55VgP8wvHzsE0YLZ0VPhdP3RjSltOpy/yow3FuesjYA3bRhuf Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31501rbt53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 20:31:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKSehJ117638;
        Wed, 20 May 2020 20:31:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 313gj46rx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 20:31:25 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04KKVN8A011118;
        Wed, 20 May 2020 20:31:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 13:31:23 -0700
Date:   Wed, 20 May 2020 13:31:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5/6 V2] xfs: per-type quota timers and warn limits
Message-ID: <20200520203120.GB17627@magnolia>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <842a7671-b514-d698-b996-5c1ccf65a6ad@redhat.com>
 <e27a2dff-f728-f69e-32b6-a83eee7effef@redhat.com>
 <95743095-0be7-a137-44f9-8a225b15d5db@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95743095-0be7-a137-44f9-8a225b15d5db@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 01:43:15PM -0500, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Move timers and warnings out of xfs_quotainfo and into xfs_def_quota
> so that we can utilize them on a per-type basis, rather than enforcing
> them based on the values found in the first enabled quota type.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>

There's been kind of a lot of changes to keep Allison's RVB, especially
since you didn't add mine...

(...says the king of forgetting to apply RVBs :P)

> [zlang: new way to get defquota in xfs_qm_init_timelimits]
> [zlang: remove redundant defq assign]
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> V2: Use the by-type defquota-getter
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index fdeaccc67d91..49c235c5d42c 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -116,8 +116,12 @@ xfs_qm_adjust_dqtimers(
>  	struct xfs_mount	*mp,
>  	struct xfs_dquot	*dq)
>  {
> +	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  	struct xfs_disk_dquot	*d = &dq->q_core;
> +	struct xfs_def_quota	*defq;
> +
>  	ASSERT(d->d_id);
> +	*defq = xfs_get_defquota(qi, xfs_dquot_type(dq));

This isn't supposed to be a structure copy, right?

--D

>  
>  #ifdef DEBUG
>  	if (d->d_blk_hardlimit)
> @@ -139,7 +143,7 @@ xfs_qm_adjust_dqtimers(
>  		     (be64_to_cpu(d->d_bcount) >
>  		      be64_to_cpu(d->d_blk_hardlimit)))) {
>  			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
> -					mp->m_quotainfo->qi_btimelimit);
> +					defq->btimelimit);
>  		} else {
>  			d->d_bwarns = 0;
>  		}
> @@ -162,7 +166,7 @@ xfs_qm_adjust_dqtimers(
>  		     (be64_to_cpu(d->d_icount) >
>  		      be64_to_cpu(d->d_ino_hardlimit)))) {
>  			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
> -					mp->m_quotainfo->qi_itimelimit);
> +					defq->itimelimit);
>  		} else {
>  			d->d_iwarns = 0;
>  		}
> @@ -185,7 +189,7 @@ xfs_qm_adjust_dqtimers(
>  		     (be64_to_cpu(d->d_rtbcount) >
>  		      be64_to_cpu(d->d_rtb_hardlimit)))) {
>  			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
> -					mp->m_quotainfo->qi_rtbtimelimit);
> +					defq->rtbtimelimit);
>  		} else {
>  			d->d_rtbwarns = 0;
>  		}
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 64ba943e0675..dd38c73ce36e 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -577,19 +577,22 @@ xfs_qm_set_defquota(
>  static void
>  xfs_qm_init_timelimits(
>  	struct xfs_mount	*mp,
> -	struct xfs_quotainfo	*qinf)
> +	uint			type)
>  {
> +	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
> +	struct xfs_def_quota	*defq;
>  	struct xfs_disk_dquot	*ddqp;
>  	struct xfs_dquot	*dqp;
> -	uint			type;
>  	int			error;
>  
> -	qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
> -	qinf->qi_itimelimit = XFS_QM_ITIMELIMIT;
> -	qinf->qi_rtbtimelimit = XFS_QM_RTBTIMELIMIT;
> -	qinf->qi_bwarnlimit = XFS_QM_BWARNLIMIT;
> -	qinf->qi_iwarnlimit = XFS_QM_IWARNLIMIT;
> -	qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
> +	defq = xfs_get_defquota(qinf, type);
> +
> +	defq->btimelimit = XFS_QM_BTIMELIMIT;
> +	defq->itimelimit = XFS_QM_ITIMELIMIT;
> +	defq->rtbtimelimit = XFS_QM_RTBTIMELIMIT;
> +	defq->bwarnlimit = XFS_QM_BWARNLIMIT;
> +	defq->iwarnlimit = XFS_QM_IWARNLIMIT;
> +	defq->rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
>  
>  	/*
>  	 * We try to get the limits from the superuser's limits fields.
> @@ -597,39 +600,30 @@ xfs_qm_init_timelimits(
>  	 *
>  	 * Since we may not have done a quotacheck by this point, just read
>  	 * the dquot without attaching it to any hashtables or lists.
> -	 *
> -	 * Timers and warnings are globally set by the first timer found in
> -	 * user/group/proj quota types, otherwise a default value is used.
> -	 * This should be split into different fields per quota type.
>  	 */
> -	if (XFS_IS_UQUOTA_RUNNING(mp))
> -		type = XFS_DQ_USER;
> -	else if (XFS_IS_GQUOTA_RUNNING(mp))
> -		type = XFS_DQ_GROUP;
> -	else
> -		type = XFS_DQ_PROJ;
>  	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
>  	if (error)
>  		return;
>  
>  	ddqp = &dqp->q_core;
> +
>  	/*
>  	 * The warnings and timers set the grace period given to
>  	 * a user or group before he or she can not perform any
>  	 * more writing. If it is zero, a default is used.
>  	 */
>  	if (ddqp->d_btimer)
> -		qinf->qi_btimelimit = be32_to_cpu(ddqp->d_btimer);
> +		defq->btimelimit = be32_to_cpu(ddqp->d_btimer);
>  	if (ddqp->d_itimer)
> -		qinf->qi_itimelimit = be32_to_cpu(ddqp->d_itimer);
> +		defq->itimelimit = be32_to_cpu(ddqp->d_itimer);
>  	if (ddqp->d_rtbtimer)
> -		qinf->qi_rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
> +		defq->rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
>  	if (ddqp->d_bwarns)
> -		qinf->qi_bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
> +		defq->bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
>  	if (ddqp->d_iwarns)
> -		qinf->qi_iwarnlimit = be16_to_cpu(ddqp->d_iwarns);
> +		defq->iwarnlimit = be16_to_cpu(ddqp->d_iwarns);
>  	if (ddqp->d_rtbwarns)
> -		qinf->qi_rtbwarnlimit = be16_to_cpu(ddqp->d_rtbwarns);
> +		defq->rtbwarnlimit = be16_to_cpu(ddqp->d_rtbwarns);
>  
>  	xfs_qm_dqdestroy(dqp);
>  }
> @@ -675,7 +669,9 @@ xfs_qm_init_quotainfo(
>  
>  	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
>  
> -	xfs_qm_init_timelimits(mp, qinf);
> +	xfs_qm_init_timelimits(mp, XFS_DQ_USER);
> +	xfs_qm_init_timelimits(mp, XFS_DQ_GROUP);
> +	xfs_qm_init_timelimits(mp, XFS_DQ_PROJ);
>  
>  	if (XFS_IS_UQUOTA_RUNNING(mp))
>  		xfs_qm_set_defquota(mp, XFS_DQ_USER, qinf);
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 06df406fdf72..c2d141715e91 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -41,7 +41,14 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
>   */
>  #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
>  
> +/* Defaults for each quota type: time limits, warn limits, usage limits */
>  struct xfs_def_quota {
> +	time64_t	btimelimit;	/* limit for blks timer */
> +	time64_t	itimelimit;	/* limit for inodes timer */
> +	time64_t	rtbtimelimit;	/* limit for rt blks timer */
> +	xfs_qwarncnt_t	bwarnlimit;	/* limit for blks warnings */
> +	xfs_qwarncnt_t	iwarnlimit;	/* limit for inodes warnings */
> +	xfs_qwarncnt_t	rtbwarnlimit;	/* limit for rt blks warnings */
>  	xfs_qcnt_t	bhardlimit;	/* default data blk hard limit */
>  	xfs_qcnt_t	bsoftlimit;	/* default data blk soft limit */
>  	xfs_qcnt_t	ihardlimit;	/* default inode count hard limit */
> @@ -64,12 +71,6 @@ struct xfs_quotainfo {
>  	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
>  	struct list_lru		qi_lru;
>  	int			qi_dquots;
> -	time64_t		qi_btimelimit;	/* limit for blks timer */
> -	time64_t		qi_itimelimit;	/* limit for inodes timer */
> -	time64_t		qi_rtbtimelimit;/* limit for rt blks timer */
> -	xfs_qwarncnt_t		qi_bwarnlimit;	/* limit for blks warnings */
> -	xfs_qwarncnt_t		qi_iwarnlimit;	/* limit for inodes warnings */
> -	xfs_qwarncnt_t		qi_rtbwarnlimit;/* limit for rt blks warnings */
>  	struct mutex		qi_quotaofflock;/* to serialize quotaoff */
>  	xfs_filblks_t		qi_dqchunklen;	/* # BBs in a chunk of dqs */
>  	uint			qi_dqperchunk;	/* # ondisk dq in above chunk */
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 13196d07c84e..4dbcc27eba23 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -563,23 +563,23 @@ xfs_qm_scall_setqlim(
>  		 * for warnings.
>  		 */
>  		if (newlim->d_fieldmask & QC_SPC_TIMER) {
> -			q->qi_btimelimit = newlim->d_spc_timer;
> +			defq->btimelimit = newlim->d_spc_timer;
>  			ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
>  		}
>  		if (newlim->d_fieldmask & QC_INO_TIMER) {
> -			q->qi_itimelimit = newlim->d_ino_timer;
> +			defq->itimelimit = newlim->d_ino_timer;
>  			ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
>  		}
>  		if (newlim->d_fieldmask & QC_RT_SPC_TIMER) {
> -			q->qi_rtbtimelimit = newlim->d_rt_spc_timer;
> +			defq->rtbtimelimit = newlim->d_rt_spc_timer;
>  			ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
>  		}
>  		if (newlim->d_fieldmask & QC_SPC_WARNS)
> -			q->qi_bwarnlimit = newlim->d_spc_warns;
> +			defq->bwarnlimit = newlim->d_spc_warns;
>  		if (newlim->d_fieldmask & QC_INO_WARNS)
> -			q->qi_iwarnlimit = newlim->d_ino_warns;
> +			defq->iwarnlimit = newlim->d_ino_warns;
>  		if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
> -			q->qi_rtbwarnlimit = newlim->d_rt_spc_warns;
> +			defq->rtbwarnlimit = newlim->d_rt_spc_warns;
>  	} else {
>  		/*
>  		 * If the user is now over quota, start the timelimit.
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index cb16a91dd1d4..51be282d28b3 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -21,9 +21,9 @@ xfs_qm_fill_state(
>  	struct qc_type_state	*tstate,
>  	struct xfs_mount	*mp,
>  	struct xfs_inode	*ip,
> -	xfs_ino_t		ino)
> +	xfs_ino_t		ino,
> +	struct xfs_def_quota	*defq)
>  {
> -	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	bool			tempqip = false;
>  
>  	tstate->ino = ino;
> @@ -37,12 +37,12 @@ xfs_qm_fill_state(
>  	tstate->flags |= QCI_SYSFILE;
>  	tstate->blocks = ip->i_d.di_nblocks;
>  	tstate->nextents = ip->i_d.di_nextents;
> -	tstate->spc_timelimit = (u32)q->qi_btimelimit;
> -	tstate->ino_timelimit = (u32)q->qi_itimelimit;
> -	tstate->rt_spc_timelimit = (u32)q->qi_rtbtimelimit;
> -	tstate->spc_warnlimit = q->qi_bwarnlimit;
> -	tstate->ino_warnlimit = q->qi_iwarnlimit;
> -	tstate->rt_spc_warnlimit = q->qi_rtbwarnlimit;
> +	tstate->spc_timelimit = (u32)defq->btimelimit;
> +	tstate->ino_timelimit = (u32)defq->itimelimit;
> +	tstate->rt_spc_timelimit = (u32)defq->rtbtimelimit;
> +	tstate->spc_warnlimit = defq->bwarnlimit;
> +	tstate->ino_warnlimit = defq->iwarnlimit;
> +	tstate->rt_spc_warnlimit = defq->rtbwarnlimit;
>  	if (tempqip)
>  		xfs_irele(ip);
>  }
> @@ -77,11 +77,11 @@ xfs_fs_get_quota_state(
>  		state->s_state[PRJQUOTA].flags |= QCI_LIMITS_ENFORCED;
>  
>  	xfs_qm_fill_state(&state->s_state[USRQUOTA], mp, q->qi_uquotaip,
> -			  mp->m_sb.sb_uquotino);
> +			  mp->m_sb.sb_uquotino, &q->qi_usr_default);
>  	xfs_qm_fill_state(&state->s_state[GRPQUOTA], mp, q->qi_gquotaip,
> -			  mp->m_sb.sb_gquotino);
> +			  mp->m_sb.sb_gquotino, &q->qi_grp_default);
>  	xfs_qm_fill_state(&state->s_state[PRJQUOTA], mp, q->qi_pquotaip,
> -			  mp->m_sb.sb_pquotino);
> +			  mp->m_sb.sb_pquotino, &q->qi_prj_default);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index edde366ca8e9..c0f73b82c055 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -602,7 +602,7 @@ xfs_trans_dqresv(
>  			softlimit = defq->bsoftlimit;
>  		timer = be32_to_cpu(dqp->q_core.d_btimer);
>  		warns = be16_to_cpu(dqp->q_core.d_bwarns);
> -		warnlimit = dqp->q_mount->m_quotainfo->qi_bwarnlimit;
> +		warnlimit = defq->bwarnlimit;
>  		resbcountp = &dqp->q_res_bcount;
>  	} else {
>  		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
> @@ -614,7 +614,7 @@ xfs_trans_dqresv(
>  			softlimit = defq->rtbsoftlimit;
>  		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
>  		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
> -		warnlimit = dqp->q_mount->m_quotainfo->qi_rtbwarnlimit;
> +		warnlimit = defq->rtbwarnlimit;
>  		resbcountp = &dqp->q_res_rtbcount;
>  	}
>  
> @@ -650,7 +650,7 @@ xfs_trans_dqresv(
>  			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
>  			timer = be32_to_cpu(dqp->q_core.d_itimer);
>  			warns = be16_to_cpu(dqp->q_core.d_iwarns);
> -			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
> +			warnlimit = defq->iwarnlimit;
>  			hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
>  			if (!hardlimit)
>  				hardlimit = defq->ihardlimit;
> 
> 
