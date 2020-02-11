Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C07C35242
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 434C120714
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:30:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I08a3IDR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgBKFa5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 00:30:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59410 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbgBKFa5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 00:30:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01B5SRbf125067;
        Tue, 11 Feb 2020 05:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KTdjX7660fD/FDtWeXuNtT6jGEW3slmfJ337gyoctW4=;
 b=I08a3IDRPFVl/0VWiXKMVin50taV8RNty3jq5PLc5NRySdmkhkG1U6CvQULXzVvxLl0Y
 Fc2/ZEUN4kIdlL6PmeA3AEoBPmpa1EVEBBbZBouUdWsJ57mnOqQ7wb4Yalb1BkPbge+3
 DODfeSvd6S1tQYhJ3kKGsYybfIQ0ngInmUY2gE/dJhuW+YcJ7cfwf+2vIEzYAA1Etani
 7EzaGB2uNnN4Mw+Lqia+32zEln5jCpJ6mQY/9RO5EVzh8I1PM8E9hTEWX5XG+w7ZXhbc
 vFNZgOQwc4/XMoiwsu7GLMYl4nIa6NTk/8/GkMPozHGhBELuIvQm/kBwMLrEywrYcfWV 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2y2jx616au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Feb 2020 05:30:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01B5QviW183687;
        Tue, 11 Feb 2020 05:30:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2y26fgg4r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Feb 2020 05:30:53 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01B5UrwT011491;
        Tue, 11 Feb 2020 05:30:53 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Feb 2020 21:30:52 -0800
Subject: Re: [PATCH 2/4] xfs: simplify args to xfs_get_defquota
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
 <26218bfd-b003-c1fc-3ea3-e53d9c35187d@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <de89bec0-5cb6-d61b-30b9-858bbb2d1aa3@oracle.com>
Date:   Mon, 10 Feb 2020 22:30:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <26218bfd-b003-c1fc-3ea3-e53d9c35187d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002110039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002110039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/8/20 2:11 PM, Eric Sandeen wrote:
> There's no real reason to pass both xfs_dquot and xfs_quotainfo to
> xfs_get_defquota, because the latter can be obtained from the former.
> This simplifies a bit more of the argument passing.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Looks ok to me
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_dquot.c       |  3 +--
>   fs/xfs/xfs_qm.c          | 17 ++++++++---------
>   fs/xfs/xfs_qm.h          |  3 ++-
>   fs/xfs/xfs_qm_syscalls.c |  2 +-
>   fs/xfs/xfs_trans_dquot.c |  3 +--
>   5 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 02f433d1f13a..ddf41c24efcd 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -69,13 +69,12 @@ xfs_qm_adjust_dqlimits(
>   	struct xfs_mount	*mp,
>   	struct xfs_dquot	*dq)
>   {
> -	struct xfs_quotainfo	*q = mp->m_quotainfo;
>   	struct xfs_disk_dquot	*d = &dq->q_core;
>   	struct xfs_def_quota	*defq;
>   	int			prealloc = 0;
>   
>   	ASSERT(d->d_id);
> -	defq = xfs_get_defquota(dq, q);
> +	defq = xfs_get_defquota(dq);
>   
>   	if (defq->bsoftlimit && !d->d_blk_softlimit) {
>   		d->d_blk_softlimit = cpu_to_be64(defq->bsoftlimit);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 0b0909657bad..b3cd87d0bccb 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -541,8 +541,7 @@ xfs_qm_shrink_count(
>   STATIC void
>   xfs_qm_set_defquota(
>   	struct xfs_mount	*mp,
> -	uint			type,
> -	struct xfs_quotainfo	*qinf)
> +	uint			type)
>   {
>   	struct xfs_dquot	*dqp;
>   	struct xfs_def_quota	*defq;
> @@ -554,7 +553,7 @@ xfs_qm_set_defquota(
>   		return;
>   
>   	ddqp = &dqp->q_core;
> -	defq = xfs_get_defquota(dqp, qinf);
> +	defq = xfs_get_defquota(dqp);
>   
>   	/*
>   	 * Timers and warnings have been already set, let's just set the
> @@ -572,9 +571,9 @@ xfs_qm_set_defquota(
>   /* Initialize quota time limits from the root dquot. */
>   static void
>   xfs_qm_init_timelimits(
> -	struct xfs_mount	*mp,
> -	struct xfs_quotainfo	*qinf)
> +	struct xfs_mount	*mp)
>   {
> +	struct xfs_quotainfo	*qinf = mp->m_quotainfo;
>   	struct xfs_disk_dquot	*ddqp;
>   	struct xfs_dquot	*dqp;
>   	uint			type;
> @@ -671,14 +670,14 @@ xfs_qm_init_quotainfo(
>   
>   	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
>   
> -	xfs_qm_init_timelimits(mp, qinf);
> +	xfs_qm_init_timelimits(mp);
>   
>   	if (XFS_IS_UQUOTA_RUNNING(mp))
> -		xfs_qm_set_defquota(mp, XFS_DQ_USER, qinf);
> +		xfs_qm_set_defquota(mp, XFS_DQ_USER);
>   	if (XFS_IS_GQUOTA_RUNNING(mp))
> -		xfs_qm_set_defquota(mp, XFS_DQ_GROUP, qinf);
> +		xfs_qm_set_defquota(mp, XFS_DQ_GROUP);
>   	if (XFS_IS_PQUOTA_RUNNING(mp))
> -		xfs_qm_set_defquota(mp, XFS_DQ_PROJ, qinf);
> +		xfs_qm_set_defquota(mp, XFS_DQ_PROJ);
>   
>   	qinf->qi_shrinker.count_objects = xfs_qm_shrink_count;
>   	qinf->qi_shrinker.scan_objects = xfs_qm_shrink_scan;
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 3a850401b102..4cefe1abb1d4 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -164,9 +164,10 @@ extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
>   extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
>   
>   static inline struct xfs_def_quota *
> -xfs_get_defquota(struct xfs_dquot *dqp, struct xfs_quotainfo *qi)
> +xfs_get_defquota(struct xfs_dquot *dqp)
>   {
>   	struct xfs_def_quota *defq;
> +	struct xfs_quotainfo *qi = dqp->q_mount->m_quotainfo;
>   
>   	if (XFS_QM_ISUDQ(dqp))
>   		defq = &qi->qi_usr_default;
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 1ea82764bf89..e08c2f04f3ab 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -478,7 +478,7 @@ xfs_qm_scall_setqlim(
>   		goto out_unlock;
>   	}
>   
> -	defq = xfs_get_defquota(dqp, q);
> +	defq = xfs_get_defquota(dqp);
>   	xfs_dqunlock(dqp);
>   
>   	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_setqlim, 0, 0, 0, &tp);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index d1b9869bc5fa..7470b02c5198 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -585,13 +585,12 @@ xfs_trans_dqresv(
>   	xfs_qwarncnt_t		warnlimit;
>   	xfs_qcnt_t		total_count;
>   	xfs_qcnt_t		*resbcountp;
> -	struct xfs_quotainfo	*q = mp->m_quotainfo;
>   	struct xfs_def_quota	*defq;
>   
>   
>   	xfs_dqlock(dqp);
>   
> -	defq = xfs_get_defquota(dqp, q);
> +	defq = xfs_get_defquota(dqp);
>   
>   	if (flags & XFS_TRANS_DQ_RES_BLKS) {
>   		hardlimit = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
> 
