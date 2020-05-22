Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46DBC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B3B2078B
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ll0AdFWM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgEVCaW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:30:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43366 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgEVCaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:30:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2M4TE053405;
        Fri, 22 May 2020 02:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qpHyp6Y2CL7+P+zAmg5M43bJKT9gpoJrG3j6D7h5gPI=;
 b=ll0AdFWMVLUInPm6FRlHrw8DIJYcVJtd1P3dSSaPYydz8wKyzJ14+eCF6X2hk3W1EHcH
 3HE5Y7D1Z3onpZRjM0fZNeU4lUaD9S3n6WSE2F79HzHZhTSgx3V10GIQt14Ym+U5Jsp2
 /Jlj0xDXTrb+dE6AgsCxlJu+bqVujahyMR4vGylyy6pl52BwA3EkuQgp5XCq80oz3XC+
 db2HqXdBuxRkQV3wARrYBx5dzg1YS/DrGp7PIO/WIf65tQUq4+HSmy4meP2O2TqwNwh8
 UbzUFf7l0DKGfP85acv5vf+oUXXve7gbo/6GC+q0c2WVOu7V+bA+ueeB117e+Vhi+xYd SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284mbghe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:29:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2TG6s125392;
        Fri, 22 May 2020 02:29:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t3d2cmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:29:48 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M2TlKx020206;
        Fri, 22 May 2020 02:29:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:29:47 -0700
Date:   Thu, 21 May 2020 19:29:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7 V2] xfs: switch xfs_get_defquota to take explicit type
Message-ID: <20200522022946.GA8230@magnolia>
References: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
 <1590028518-6043-6-git-send-email-sandeen@redhat.com>
 <58bbabff-ac0e-9ab4-8caa-9981ff7e2fe8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58bbabff-ac0e-9ab4-8caa-9981ff7e2fe8@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220017
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 10:05:40AM -0500, Eric Sandeen wrote:
> xfs_get_defquota() currently takes an xfs_dquot, and from that obtains
> the type of default quota we should get (user/group/project).
> 
> But early in init, we don't have access to a fully set up quota, so
> that's not possible.  The next patch needs go set up default quota
> timers early, so switch xfs_get_defquota to take an explicit type
> and add a helper function to obtain that type from an xfs_dquot
> for the existing callers.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V2: Make hch's suggested tidiness changes.
> 
> Yes I did run this through the quota tests again, still pass. :)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 714eceacbab2..6196f7c52b24 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -75,7 +75,7 @@ xfs_qm_adjust_dqlimits(
>  	int			prealloc = 0;
>  
>  	ASSERT(d->d_id);
> -	defq = xfs_get_defquota(dq, q);
> +	defq = xfs_get_defquota(q, xfs_dquot_type(dq));
>  
>  	if (defq->bsoftlimit && !d->d_blk_softlimit) {
>  		d->d_blk_softlimit = cpu_to_be64(defq->bsoftlimit);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 6609b4bb1628..ac0b5e7f8522 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -558,7 +558,7 @@ xfs_qm_set_defquota(
>  		return;
>  
>  	ddqp = &dqp->q_core;
> -	defq = xfs_get_defquota(dqp, qinf);
> +	defq = xfs_get_defquota(qinf, xfs_dquot_type(dqp));
>  
>  	/*
>  	 * Timers and warnings have been already set, let's just set the
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 3a850401b102..c6f83171357e 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -113,6 +113,17 @@ xfs_quota_inode(xfs_mount_t *mp, uint dq_flags)
>  	return NULL;
>  }
>  
> +static inline int
> +xfs_dquot_type(struct xfs_dquot *dqp)
> +{
> +	if (XFS_QM_ISUDQ(dqp))
> +		return XFS_DQ_USER;
> +	if (XFS_QM_ISGDQ(dqp))
> +		return XFS_DQ_GROUP;
> +	ASSERT(XFS_QM_ISPDQ(dqp));
> +	return XFS_DQ_PROJ;
> +}
> +
>  extern void	xfs_trans_mod_dquot(struct xfs_trans *tp, struct xfs_dquot *dqp,
>  				    uint field, int64_t delta);
>  extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
> @@ -164,19 +175,19 @@ extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
>  extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
>  
>  static inline struct xfs_def_quota *
> -xfs_get_defquota(struct xfs_dquot *dqp, struct xfs_quotainfo *qi)
> +xfs_get_defquota(struct xfs_quotainfo *qi, int type)
>  {
> -	struct xfs_def_quota *defq;
> -
> -	if (XFS_QM_ISUDQ(dqp))
> -		defq = &qi->qi_usr_default;
> -	else if (XFS_QM_ISGDQ(dqp))
> -		defq = &qi->qi_grp_default;
> -	else {
> -		ASSERT(XFS_QM_ISPDQ(dqp));
> -		defq = &qi->qi_prj_default;
> +	switch (type) {
> +	case XFS_DQ_USER:
> +		return &qi->qi_usr_default;
> +	case XFS_DQ_GROUP:
> +		return &qi->qi_grp_default;
> +	case XFS_DQ_PROJ:
> +		return &qi->qi_prj_default;
> +	default:
> +		ASSERT(0);
> +		return NULL;
>  	}
> -	return defq;
>  }
>  
>  #endif /* __XFS_QM_H__ */
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index bd0f005570af..6fa08ae0b5f5 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -479,7 +479,7 @@ xfs_qm_scall_setqlim(
>  		goto out_unlock;
>  	}
>  
> -	defq = xfs_get_defquota(dqp, q);
> +	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
>  	xfs_dqunlock(dqp);
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_setqlim, 0, 0, 0, &tp);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 20542076e32a..edde366ca8e9 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -591,7 +591,7 @@ xfs_trans_dqresv(
>  
>  	xfs_dqlock(dqp);
>  
> -	defq = xfs_get_defquota(dqp, q);
> +	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
>  
>  	if (flags & XFS_TRANS_DQ_RES_BLKS) {
>  		hardlimit = be64_to_cpu(dqp->q_core.d_blk_hardlimit);
> 
> 
