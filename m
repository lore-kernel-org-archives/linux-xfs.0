Return-Path: <SRS0=maQ1=AO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1346C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 04:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A65AE208C7
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 04:11:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="onRNCaNx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbgGCELc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:11:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38120 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgGCELc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jul 2020 00:11:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06348i5A117562
        for <linux-xfs@vger.kernel.org>; Fri, 3 Jul 2020 04:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xF6W4pBcqnjgMUHKVSGCWJvJkoBl2lK7xjem13P0Tfw=;
 b=onRNCaNxfqVCgo3w5fjHqT80VGeqyiPTXehXe1Y83WYRqLoByYbisfUCrZ0RU9Rj2mBZ
 qhipskgfg/Rb7vIC8zCeL7ercb7wVtfcdi6ZwW6PP7bC8ZjLfSfx7vERLTrHUL/mfzIC
 UMG06/aTq9Cqny1M5BXy7dqmNNxfttN7kwzBOEEbP/wvAkh+q62fqJBopPm+Zxy8uq0l
 k0bhLmzH2i+GO2rzCz8hYhcFoeWLiN6GnaOkCW95h+/BrCfo/QSivQFi2a/103TZyzkV
 hbBwlwcX4d3eswHqYTlFqO/QLlt/3p17kQy1eaP4yzhyg2EHQ8k6V1Nm6a4ZeNIcuvBB Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31wxrnkpjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jul 2020 04:11:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06348tkh035375
        for <linux-xfs@vger.kernel.org>; Fri, 3 Jul 2020 04:11:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31y52nq8c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jul 2020 04:11:30 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0634BTuR009842
        for <linux-xfs@vger.kernel.org>; Fri, 3 Jul 2020 04:11:29 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 04:11:29 +0000
Subject: Re: [PATCH 15/18] xfs: refactor xfs_qm_scall_setqlim
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353180627.2864738.644970181923295002.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <63697176-bee2-af5f-4ae5-b1814bbdcd4f@oracle.com>
Date:   Thu, 2 Jul 2020 21:11:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353180627.2864738.644970181923295002.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:43 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we can pass around quota resource and limit structures, clean
> up the open-coded field setting in xfs_qm_scall_setqlim.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, I followed it through, and I think it looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_qm_syscalls.c |  164 ++++++++++++++++++++++++++--------------------
>   1 file changed, 93 insertions(+), 71 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 5423e02f9837..5044c333af5c 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -436,6 +436,58 @@ xfs_qm_scall_quotaon(
>   #define XFS_QC_MASK \
>   	(QC_LIMIT_MASK | QC_TIMER_MASK | QC_WARNS_MASK)
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
>   /*
>    * Adjust quota limits, and start/stop timers accordingly.
>    */
> @@ -450,6 +502,8 @@ xfs_qm_scall_setqlim(
>   	struct xfs_dquot	*dqp;
>   	struct xfs_trans	*tp;
>   	struct xfs_def_quota	*defq;
> +	struct xfs_dquot_res	*res;
> +	struct xfs_def_qres	*dres;
>   	int			error;
>   	xfs_qcnt_t		hard, soft;
>   
> @@ -489,102 +543,70 @@ xfs_qm_scall_setqlim(
>   	xfs_trans_dqjoin(tp, dqp);
>   
>   	/*
> +	 * Update quota limits, warnings, and timers, and the defaults
> +	 * if we're touching id == 0.
> +	 *
>   	 * Make sure that hardlimits are >= soft limits before changing.
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
>   	 */
> +
> +	/* Blocks on the data device. */
>   	hard = (newlim->d_fieldmask & QC_SPC_HARD) ?
>   		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_spc_hardlimit) :
>   			dqp->q_blk.hardlimit;
>   	soft = (newlim->d_fieldmask & QC_SPC_SOFT) ?
>   		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_spc_softlimit) :
>   			dqp->q_blk.softlimit;
> -	if (hard == 0 || hard >= soft) {
> -		dqp->q_blk.hardlimit = hard;
> -		dqp->q_blk.softlimit = soft;
> +	res = &dqp->q_blk;
> +	dres = id == 0 ? &defq->dfq_blk : NULL;
> +
> +	if (xfs_setqlim_limits(mp, res, dres, hard, soft, "blk"))
>   		xfs_dquot_set_prealloc_limits(dqp);
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
>   	hard = (newlim->d_fieldmask & QC_RT_SPC_HARD) ?
>   		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_rt_spc_hardlimit) :
>   			dqp->q_rtb.hardlimit;
>   	soft = (newlim->d_fieldmask & QC_RT_SPC_SOFT) ?
>   		(xfs_qcnt_t) XFS_B_TO_FSB(mp, newlim->d_rt_spc_softlimit) :
>   			dqp->q_rtb.softlimit;
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
>   	hard = (newlim->d_fieldmask & QC_INO_HARD) ?
>   		(xfs_qcnt_t) newlim->d_ino_hardlimit :
>   			dqp->q_ino.hardlimit;
>   	soft = (newlim->d_fieldmask & QC_INO_SOFT) ?
>   		(xfs_qcnt_t) newlim->d_ino_softlimit :
>   			dqp->q_ino.softlimit;
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
>   	if (newlim->d_fieldmask & QC_INO_WARNS)
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
>   	if (newlim->d_fieldmask & QC_INO_TIMER)
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
>   	if (id != 0) {
>   		/*
> 
