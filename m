Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7B0C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3973320823
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:39:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="si6K/Qht"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgETUjD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 16:39:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60608 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgETUjD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 16:39:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKVbAj019417;
        Wed, 20 May 2020 20:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JQ9M3GjwqxwnlRl7BAhTAkGkgUJ6VbBBiknT6T0UfW4=;
 b=si6K/QhtPKcVbHnglzj8gQTxpnrZvnztOInKLDFrUuN4KHeoyimoYtJbjmB74d5RUca6
 SbEsONeFfgHtyMuHUg1kYVXrHoIF7Jy9rI2wI/tg+8tWWsaKI80EC6tKoPfiprZ8f3L/
 QJ3Cf3q8hUZJ8Xh8VGjVTmW16ZqOSdeGW4oZXs4MT6fOacIqYo9ajo9Yewmneis0BdA3
 Z/+gr6zrIBrb/ciNWao7mcYmRL/pq0tw8UsKElGA+sgXVaPNGkFHQ94XwjtI1k+syfYK
 HnaC0bJXJW5dSUAwn/rMmVPoPlhZiAOcK8Agfe8iFT3qShj6WhpTmtSxQpkTha0cBW0n Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31501rbu4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 20:38:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKXDBY029349;
        Wed, 20 May 2020 20:36:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 315020ypru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 20:36:58 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04KKauLW028908;
        Wed, 20 May 2020 20:36:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 13:36:56 -0700
Date:   Wed, 20 May 2020 13:36:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4.5/6] xfs: switch xfs_get_defquota to take explicit type
Message-ID: <20200520203655.GC17627@magnolia>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <842a7671-b514-d698-b996-5c1ccf65a6ad@redhat.com>
 <e27a2dff-f728-f69e-32b6-a83eee7effef@redhat.com>
 <0368b615-37af-27fb-b267-b7846f3b73d9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0368b615-37af-27fb-b267-b7846f3b73d9@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=1 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200163
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

On Wed, May 20, 2020 at 01:41:25PM -0500, Eric Sandeen wrote:
> xfs_get_defquota() currently takes an xfs_dquot, and from that obtains
> the type of default quota we should get (user/group/project).
> 
> But early in init, we don't have access to a fully set up quota, and
> so we will fail to set these defaults.
> 
> Switch xfs_get_defquota to take an explicit type, and add a helper 
> function to obtain that type from an xfs_dquot for the existing
> callers.

Ah, so this patch isn't itself fixing anything, it's preparing code for
something that happens in the next patch.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 6d6afc0297b3..fdeaccc67d91 100644
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
> index e97a3802939c..64ba943e0675 100644
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
> index 3a850401b102..06df406fdf72 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -113,6 +113,19 @@ xfs_quota_inode(xfs_mount_t *mp, uint dq_flags)
>  	return NULL;
>  }
>  
> +static inline int
> +xfs_dquot_type(struct xfs_dquot *dqp)
> +{
> +	if (XFS_QM_ISUDQ(dqp))
> +		return XFS_DQ_USER;
> +	else if (XFS_QM_ISGDQ(dqp))
> +		return XFS_DQ_GROUP;
> +	else {
> +		ASSERT(XFS_QM_ISPDQ(dqp));
> +		return XFS_DQ_PROJ;

/me suspects this could be tidier, e.g.

if (UDQ)
	return XFS_DQ_USER;
if (GDQ)
	return XFS_DQ_GROUP;
ASSERT(PDQ);
return XFS_DQ_PROJ;

Otherwise the rest looks ok.

--D


> +	}
> +}
> +
>  extern void	xfs_trans_mod_dquot(struct xfs_trans *tp, struct xfs_dquot *dqp,
>  				    uint field, int64_t delta);
>  extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
> @@ -164,17 +177,22 @@ extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
>  extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
>  
>  static inline struct xfs_def_quota *
> -xfs_get_defquota(struct xfs_dquot *dqp, struct xfs_quotainfo *qi)
> +xfs_get_defquota(struct xfs_quotainfo *qi, int type)
>  {
>  	struct xfs_def_quota *defq;
>  
> -	if (XFS_QM_ISUDQ(dqp))
> +	switch (type) {
> +	case XFS_DQ_USER:
>  		defq = &qi->qi_usr_default;
> -	else if (XFS_QM_ISGDQ(dqp))
> +		break;
> +	case XFS_DQ_GROUP:
>  		defq = &qi->qi_grp_default;
> -	else {
> -		ASSERT(XFS_QM_ISPDQ(dqp));
> +		break;
> +	case XFS_DQ_PROJ:
>  		defq = &qi->qi_prj_default;
> +		break;
> +	default:
> +		ASSERT(0);
>  	}
>  	return defq;
>  }
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 301a284ee4f9..13196d07c84e 100644
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
