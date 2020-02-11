Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766D8C3B187
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 416A8206D6
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:31:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="umsm2Gbz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgBKFbH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 00:31:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48632 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgBKFbH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 00:31:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01B5V2uv010642;
        Tue, 11 Feb 2020 05:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HVVvKDgh2ho1nwytGm5pPvOwbKhlVKkR/D837aCkDeU=;
 b=umsm2GbzaT3b2KDIxdsFli6wqwoTryqGLJDEBRGcrNM7EWnKEOyxr5oIb3QlbRDX4CZq
 CNYNN9fmVeBfHoG1hL0/bFI+lVegvrGfSzTFqcFmfUIgUXI3CO8YkIcAPv8w0SWIv+uL
 6TJYcDbRhLy801MdYb1p8exl7Hk2No7KyvRP47X2BduHA0I8wxXd2lMOLkYV2Ukb9wnS
 m/4I2i3Eh5KVYGA2Bh6lqnN7yp4Wz11s+eNfZmRe57xuuUhLqkbDqTVdoWhaz0EriN2n
 KVvBsM6qBgrA3P6e+b5OHds+NV/afJouoCjGrxwswdhP2QkXqThpYH+AY99Uxy85Johj mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y2p3s8tut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Feb 2020 05:31:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01B5SQ0C023693;
        Tue, 11 Feb 2020 05:30:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2y26sp12dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Feb 2020 05:30:59 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01B5Uxk5032441;
        Tue, 11 Feb 2020 05:30:59 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Feb 2020 21:30:59 -0800
Subject: Re: [PATCH 4/4] xfs: per-type quota timers and warn limits
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
 <7a35e397-dbc7-b991-6277-5f9931d03950@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <dce1462e-eb83-0600-998d-da0acf7223c7@oracle.com>
Date:   Mon, 10 Feb 2020 22:30:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7a35e397-dbc7-b991-6277-5f9931d03950@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002110039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002110039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/8/20 2:12 PM, Eric Sandeen wrote:
> Move timers and warnings out of xfs_quotainfo and into xfs_def_quota
> so that we can utilize them on a per-type basis, rather than enforcing
> them based on the values found in the first enabled quota type.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Ok I think it makes sense
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_dquot.c       |  9 ++++--
>   fs/xfs/xfs_qm.c          | 61 ++++++++++++++++++++++++----------------
>   fs/xfs/xfs_qm.h          | 13 +++++----
>   fs/xfs/xfs_qm_syscalls.c | 12 ++++----
>   fs/xfs/xfs_quotaops.c    | 22 +++++++--------
>   fs/xfs/xfs_trans_dquot.c |  6 ++--
>   6 files changed, 69 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 5c5fdb62f69c..4aff555cfab0 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -116,7 +116,10 @@ xfs_qm_adjust_dqtimers(
>   	struct xfs_dquot	*dq)
>   {
>   	struct xfs_disk_dquot	*d = &dq->q_core;
> +	struct xfs_def_quota	*defq;
> +
>   	ASSERT(d->d_id);
> +	defq = xfs_get_defquota(dq);
>   
>   #ifdef DEBUG
>   	if (d->d_blk_hardlimit)
> @@ -138,7 +141,7 @@ xfs_qm_adjust_dqtimers(
>   		     (be64_to_cpu(d->d_bcount) >
>   		      be64_to_cpu(d->d_blk_hardlimit)))) {
>   			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
> -					mp->m_quotainfo->qi_btimelimit);
> +					defq->btimelimit);
>   		} else {
>   			d->d_bwarns = 0;
>   		}
> @@ -161,7 +164,7 @@ xfs_qm_adjust_dqtimers(
>   		     (be64_to_cpu(d->d_icount) >
>   		      be64_to_cpu(d->d_ino_hardlimit)))) {
>   			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
> -					mp->m_quotainfo->qi_itimelimit);
> +					defq->itimelimit);
>   		} else {
>   			d->d_iwarns = 0;
>   		}
> @@ -184,7 +187,7 @@ xfs_qm_adjust_dqtimers(
>   		     (be64_to_cpu(d->d_rtbcount) >
>   		      be64_to_cpu(d->d_rtb_hardlimit)))) {
>   			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
> -					mp->m_quotainfo->qi_rtbtimelimit);
> +					defq->rtbtimelimit);
>   		} else {
>   			d->d_rtbwarns = 0;
>   		}
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 4e543e2bc290..25003591ecb4 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -571,20 +571,37 @@ xfs_qm_set_defquota(
>   /* Initialize quota time limits from the root dquot. */
>   static void
>   xfs_qm_init_timelimits(
> -	struct xfs_mount	*mp)
> +	struct xfs_mount	*mp,
> +	uint			type)
>   {
>   	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
> +	struct xfs_def_quota	*defq;
>   	struct xfs_disk_dquot	*ddqp;
>   	struct xfs_dquot	*dqp;
> -	uint			type;
>   	int			error;
>   
> -	qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
> -	qinf->qi_itimelimit = XFS_QM_ITIMELIMIT;
> -	qinf->qi_rtbtimelimit = XFS_QM_RTBTIMELIMIT;
> -	qinf->qi_bwarnlimit = XFS_QM_BWARNLIMIT;
> -	qinf->qi_iwarnlimit = XFS_QM_IWARNLIMIT;
> -	qinf->qi_rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
> +
> +	switch (type) {
> +	case XFS_DQ_USER:
> +		defq = &qinf->qi_usr_default;
> +		break;
> +	case XFS_DQ_GROUP:
> +		defq = &qinf->qi_grp_default;
> +		break;
> +	case XFS_DQ_PROJ:
> +		defq = &qinf->qi_prj_default;
> +		break;
> +	default:
> +		ASSERT(0);
> +		/* fall through */
> +	}
> +
> +	defq->btimelimit = XFS_QM_BTIMELIMIT;
> +	defq->itimelimit = XFS_QM_ITIMELIMIT;
> +	defq->rtbtimelimit = XFS_QM_RTBTIMELIMIT;
> +	defq->bwarnlimit = XFS_QM_BWARNLIMIT;
> +	defq->iwarnlimit = XFS_QM_IWARNLIMIT;
> +	defq->rtbwarnlimit = XFS_QM_RTBWARNLIMIT;
>   
>   	/*
>   	 * We try to get the limits from the superuser's limits fields.
> @@ -592,39 +609,31 @@ xfs_qm_init_timelimits(
>   	 *
>   	 * Since we may not have done a quotacheck by this point, just read
>   	 * the dquot without attaching it to any hashtables or lists.
> -	 *
> -	 * Timers and warnings are globally set by the first timer found in
> -	 * user/group/proj quota types, otherwise a default value is used.
> -	 * This should be split into different fields per quota type.
>   	 */
> -	if (XFS_IS_UQUOTA_RUNNING(mp))
> -		type = XFS_DQ_USER;
> -	else if (XFS_IS_GQUOTA_RUNNING(mp))
> -		type = XFS_DQ_GROUP;
> -	else
> -		type = XFS_DQ_PROJ;
>   	error = xfs_qm_dqget_uncached(mp, 0, type, &dqp);
>   	if (error)
>   		return;
>   
>   	ddqp = &dqp->q_core;
> +	defq = xfs_get_defquota(dqp);
> +
>   	/*
>   	 * The warnings and timers set the grace period given to
>   	 * a user or group before he or she can not perform any
>   	 * more writing. If it is zero, a default is used.
>   	 */
>   	if (ddqp->d_btimer)
> -		qinf->qi_btimelimit = be32_to_cpu(ddqp->d_btimer);
> +		defq->btimelimit = be32_to_cpu(ddqp->d_btimer);
>   	if (ddqp->d_itimer)
> -		qinf->qi_itimelimit = be32_to_cpu(ddqp->d_itimer);
> +		defq->itimelimit = be32_to_cpu(ddqp->d_itimer);
>   	if (ddqp->d_rtbtimer)
> -		qinf->qi_rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
> +		defq->rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
>   	if (ddqp->d_bwarns)
> -		qinf->qi_bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
> +		defq->bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
>   	if (ddqp->d_iwarns)
> -		qinf->qi_iwarnlimit = be16_to_cpu(ddqp->d_iwarns);
> +		defq->iwarnlimit = be16_to_cpu(ddqp->d_iwarns);
>   	if (ddqp->d_rtbwarns)
> -		qinf->qi_rtbwarnlimit = be16_to_cpu(ddqp->d_rtbwarns);
> +		defq->rtbwarnlimit = be16_to_cpu(ddqp->d_rtbwarns);
>   
>   	xfs_qm_dqdestroy(dqp);
>   }
> @@ -670,7 +679,9 @@ xfs_qm_init_quotainfo(
>   
>   	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
>   
> -	xfs_qm_init_timelimits(mp);
> +	xfs_qm_init_timelimits(mp, XFS_DQ_USER);
> +	xfs_qm_init_timelimits(mp, XFS_DQ_GROUP);
> +	xfs_qm_init_timelimits(mp, XFS_DQ_PROJ);
>   
>   	if (XFS_IS_UQUOTA_RUNNING(mp))
>   		xfs_qm_set_defquota(mp, XFS_DQ_USER);
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 4cefe1abb1d4..9866e9f4edfd 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -41,7 +41,14 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
>    */
>   #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
>   
> +/* Defaults for each quota type: time limits, warn limits, usage limits */
>   struct xfs_def_quota {
> +	time64_t	btimelimit;	/* limit for blks timer */
> +	time64_t	itimelimit;	/* limit for inodes timer */
> +	time64_t	rtbtimelimit;	/* limit for rt blks timer */
> +	xfs_qwarncnt_t	bwarnlimit;	/* limit for blks warnings */
> +	xfs_qwarncnt_t	iwarnlimit;	/* limit for inodes warnings */
> +	xfs_qwarncnt_t	rtbwarnlimit;	/* limit for rt blks warnings */
>   	xfs_qcnt_t	bhardlimit;	/* default data blk hard limit */
>   	xfs_qcnt_t	bsoftlimit;	/* default data blk soft limit */
>   	xfs_qcnt_t	ihardlimit;	/* default inode count hard limit */
> @@ -64,12 +71,6 @@ struct xfs_quotainfo {
>   	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
>   	struct list_lru		qi_lru;
>   	int			qi_dquots;
> -	time64_t		qi_btimelimit;	/* limit for blks timer */
> -	time64_t		qi_itimelimit;	/* limit for inodes timer */
> -	time64_t		qi_rtbtimelimit;/* limit for rt blks timer */
> -	xfs_qwarncnt_t		qi_bwarnlimit;	/* limit for blks warnings */
> -	xfs_qwarncnt_t		qi_iwarnlimit;	/* limit for inodes warnings */
> -	xfs_qwarncnt_t		qi_rtbwarnlimit;/* limit for rt blks warnings */
>   	struct mutex		qi_quotaofflock;/* to serialize quotaoff */
>   	xfs_filblks_t		qi_dqchunklen;	/* # BBs in a chunk of dqs */
>   	uint			qi_dqperchunk;	/* # ondisk dq in above chunk */
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index ba79f355a14e..063850003c97 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -562,23 +562,23 @@ xfs_qm_scall_setqlim(
>   		 * for warnings.
>   		 */
>   		if (newlim->d_fieldmask & QC_SPC_TIMER) {
> -			q->qi_btimelimit = newlim->d_spc_timer;
> +			defq->btimelimit = newlim->d_spc_timer;
>   			ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
>   		}
>   		if (newlim->d_fieldmask & QC_INO_TIMER) {
> -			q->qi_itimelimit = newlim->d_ino_timer;
> +			defq->itimelimit = newlim->d_ino_timer;
>   			ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
>   		}
>   		if (newlim->d_fieldmask & QC_RT_SPC_TIMER) {
> -			q->qi_rtbtimelimit = newlim->d_rt_spc_timer;
> +			defq->rtbtimelimit = newlim->d_rt_spc_timer;
>   			ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
>   		}
>   		if (newlim->d_fieldmask & QC_SPC_WARNS)
> -			q->qi_bwarnlimit = newlim->d_spc_warns;
> +			defq->bwarnlimit = newlim->d_spc_warns;
>   		if (newlim->d_fieldmask & QC_INO_WARNS)
> -			q->qi_iwarnlimit = newlim->d_ino_warns;
> +			defq->iwarnlimit = newlim->d_ino_warns;
>   		if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
> -			q->qi_rtbwarnlimit = newlim->d_rt_spc_warns;
> +			defq->rtbwarnlimit = newlim->d_rt_spc_warns;
>   	} else {
>   		/*
>   		 * If the user is now over quota, start the timelimit.
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index cb16a91dd1d4..51be282d28b3 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -21,9 +21,9 @@ xfs_qm_fill_state(
>   	struct qc_type_state	*tstate,
>   	struct xfs_mount	*mp,
>   	struct xfs_inode	*ip,
> -	xfs_ino_t		ino)
> +	xfs_ino_t		ino,
> +	struct xfs_def_quota	*defq)
>   {
> -	struct xfs_quotainfo	*q = mp->m_quotainfo;
>   	bool			tempqip = false;
>   
>   	tstate->ino = ino;
> @@ -37,12 +37,12 @@ xfs_qm_fill_state(
>   	tstate->flags |= QCI_SYSFILE;
>   	tstate->blocks = ip->i_d.di_nblocks;
>   	tstate->nextents = ip->i_d.di_nextents;
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
>   	if (tempqip)
>   		xfs_irele(ip);
>   }
> @@ -77,11 +77,11 @@ xfs_fs_get_quota_state(
>   		state->s_state[PRJQUOTA].flags |= QCI_LIMITS_ENFORCED;
>   
>   	xfs_qm_fill_state(&state->s_state[USRQUOTA], mp, q->qi_uquotaip,
> -			  mp->m_sb.sb_uquotino);
> +			  mp->m_sb.sb_uquotino, &q->qi_usr_default);
>   	xfs_qm_fill_state(&state->s_state[GRPQUOTA], mp, q->qi_gquotaip,
> -			  mp->m_sb.sb_gquotino);
> +			  mp->m_sb.sb_gquotino, &q->qi_grp_default);
>   	xfs_qm_fill_state(&state->s_state[PRJQUOTA], mp, q->qi_pquotaip,
> -			  mp->m_sb.sb_pquotino);
> +			  mp->m_sb.sb_pquotino, &q->qi_prj_default);
>   	return 0;
>   }
>   
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 7ae907ec7d47..e4eca607e512 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -601,7 +601,7 @@ xfs_trans_dqresv(
>   			softlimit = defq->bsoftlimit;
>   		timer = be32_to_cpu(dqp->q_core.d_btimer);
>   		warns = be16_to_cpu(dqp->q_core.d_bwarns);
> -		warnlimit = dqp->q_mount->m_quotainfo->qi_bwarnlimit;
> +		warnlimit = defq->bwarnlimit;
>   		resbcountp = &dqp->q_res_bcount;
>   	} else {
>   		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
> @@ -613,7 +613,7 @@ xfs_trans_dqresv(
>   			softlimit = defq->rtbsoftlimit;
>   		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
>   		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
> -		warnlimit = dqp->q_mount->m_quotainfo->qi_rtbwarnlimit;
> +		warnlimit = defq->rtbwarnlimit;
>   		resbcountp = &dqp->q_res_rtbcount;
>   	}
>   
> @@ -649,7 +649,7 @@ xfs_trans_dqresv(
>   			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
>   			timer = be32_to_cpu(dqp->q_core.d_itimer);
>   			warns = be16_to_cpu(dqp->q_core.d_iwarns);
> -			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
> +			warnlimit = defq->iwarnlimit;
>   			hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
>   			if (!hardlimit)
>   				hardlimit = defq->ihardlimit;
> 
