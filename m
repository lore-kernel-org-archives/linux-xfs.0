Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE108C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 836D021D79
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cuKchr5q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfKHAVN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:21:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41832 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727813AbfKHAVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:21:12 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80Iin4131188;
        Fri, 8 Nov 2019 00:20:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=D4l1wKXyrjef9J0sulO4sFqLcPCch6dF+tdGK4DI99Y=;
 b=cuKchr5q8JOhoY9savZjdRPz7mXkSBqip55HZTU2/pm8iL1azCsCN/A+81MwDAZlzKDU
 fiP2KsQDeF0f6po67/QP3YBVeiL+Eh+H8ebQyNvovRatajstlPgX45CbiAwN/AroGFm3
 /1tDt7ICF2abU+3jJcW3LOi9QQQOdujW90S2n/YxrXQk4tJCIYby9Uyk28cCI5PDhpcp
 vzWsttf1ipLG/oHnw+MlHhmEMW6lDNi0gWRae4x7X1Vyp++NvlHEvE/fTLahkwoqb7QP
 Nvy/s02x5GvW7ng9R7Fx2r7n4datW8XV7tfH43LhOpQ1W9q2rlBaXVwAB5SZ0uBI+eDg Ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w41w11uac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:20:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80IoYr138885;
        Fri, 8 Nov 2019 00:20:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w41wb5bag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:20:52 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA80KpWj018166;
        Fri, 8 Nov 2019 00:20:51 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:20:51 -0800
Date:   Thu, 7 Nov 2019 16:20:50 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: remove the xfs_qoff_logitem_t typedef
Message-ID: <20191108002050.GQ6219@magnolia>
References: <20191107113549.110129-1-preichl@redhat.com>
 <20191107113549.110129-6-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107113549.110129-6-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080002
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 12:35:49PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
>  fs/xfs/xfs_dquot_item.h        | 14 ++++++++------
>  fs/xfs/xfs_qm_syscalls.c       | 20 ++++++++++----------
>  fs/xfs/xfs_trans_dquot.c       |  8 ++++----
>  4 files changed, 24 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 271cca13565b..eb7fe42b1d61 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -741,7 +741,7 @@ xfs_calc_qm_dqalloc_reservation(
>  
>  /*
>   * Turning off quotas.
> - *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
> + *    sizeof(struct xfs_qoff_logitem) * 2
>   *    the superblock for the quota flags: sector size
>   */
>  STATIC uint
> @@ -754,7 +754,7 @@ xfs_calc_qm_quotaoff_reservation(
>  
>  /*
>   * End of turning off quotas.
> - *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
> + *    sizeof(struct xfs_qoff_logitem) * 2
>   */
>  STATIC uint
>  xfs_calc_qm_quotaoff_end_reservation(void)
> diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
> index e0a24eb7a545..e2348a99fa1a 100644
> --- a/fs/xfs/xfs_dquot_item.h
> +++ b/fs/xfs/xfs_dquot_item.h
> @@ -17,18 +17,20 @@ struct xfs_dq_logitem {
>  	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
>  };
>  
> -typedef struct xfs_qoff_logitem {
> +struct xfs_qoff_logitem {
>  	struct xfs_log_item	 qql_item;	/* common portion */
>  	struct xfs_qoff_logitem *qql_start_lip; /* qoff-start logitem, if any */
>  	unsigned int		qql_flags;
> -} xfs_qoff_logitem_t;
> +};
>  
>  
>  extern void		   xfs_qm_dquot_logitem_init(struct xfs_dquot *);
> -extern xfs_qoff_logitem_t *xfs_qm_qoff_logitem_init(struct xfs_mount *,
> -					struct xfs_qoff_logitem *, uint);
> -extern xfs_qoff_logitem_t *xfs_trans_get_qoff_item(struct xfs_trans *,
> -					struct xfs_qoff_logitem *, uint);
> +extern struct xfs_qoff_logitem *xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
> +					struct xfs_qoff_logitem *start,
> +					uint flags);
> +extern struct xfs_qoff_logitem *xfs_trans_get_qoff_item(struct xfs_trans *tp,
> +					struct xfs_qoff_logitem *startqoff,
> +					uint flags);
>  extern void		   xfs_trans_log_quotaoff_item(struct xfs_trans *,
>  					struct xfs_qoff_logitem *);
>  
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index da7ad0383037..72b476e80ab2 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -19,9 +19,9 @@
>  #include "xfs_qm.h"
>  #include "xfs_icache.h"
>  
> -STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
> -STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
> -					uint);
> +STATIC int xfs_qm_log_quotaoff(xfs_mount_t *, struct xfs_qoff_logitem **, uint);
> +STATIC int xfs_qm_log_quotaoff_end(xfs_mount_t *, struct xfs_qoff_logitem *,
> +				   uint);
>  
>  /*
>   * Turn off quota accounting and/or enforcement for all udquots and/or
> @@ -40,7 +40,7 @@ xfs_qm_scall_quotaoff(
>  	uint			dqtype;
>  	int			error;
>  	uint			inactivate_flags;
> -	xfs_qoff_logitem_t	*qoffstart;
> +	struct xfs_qoff_logitem	*qoffstart;
>  
>  	/*
>  	 * No file system can have quotas enabled on disk but not in core.
> @@ -541,12 +541,12 @@ xfs_qm_scall_setqlim(
>  STATIC int
>  xfs_qm_log_quotaoff_end(
>  	xfs_mount_t		*mp,
> -	xfs_qoff_logitem_t	*startqoff,
> +	struct xfs_qoff_logitem	*startqoff,
>  	uint			flags)
>  {
>  	xfs_trans_t		*tp;
>  	int			error;
> -	xfs_qoff_logitem_t	*qoffi;
> +	struct xfs_qoff_logitem	*qoffi;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
>  	if (error)
> @@ -569,12 +569,12 @@ xfs_qm_log_quotaoff_end(
>  STATIC int
>  xfs_qm_log_quotaoff(
>  	xfs_mount_t	       *mp,
> -	xfs_qoff_logitem_t     **qoffstartp,
> +	struct xfs_qoff_logitem **qoffstartp,
>  	uint		       flags)
>  {
> -	xfs_trans_t	       *tp;
> -	int			error;
> -	xfs_qoff_logitem_t     *qoffi;
> +	xfs_trans_t			*tp;
> +	int				error;
> +	struct xfs_qoff_logitem		*qoffi;
>  
>  	*qoffstartp = NULL;
>  
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 4789f7e11f53..8b6f328f83d5 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -824,13 +824,13 @@ xfs_trans_reserve_quota_nblks(
>  /*
>   * This routine is called to allocate a quotaoff log item.
>   */
> -xfs_qoff_logitem_t *
> +struct xfs_qoff_logitem *
>  xfs_trans_get_qoff_item(
>  	xfs_trans_t		*tp,
> -	xfs_qoff_logitem_t	*startqoff,
> +	struct xfs_qoff_logitem	*startqoff,
>  	uint			flags)
>  {
> -	xfs_qoff_logitem_t	*q;
> +	struct xfs_qoff_logitem	*q;
>  
>  	ASSERT(tp != NULL);
>  
> @@ -853,7 +853,7 @@ xfs_trans_get_qoff_item(
>  void
>  xfs_trans_log_quotaoff_item(
>  	xfs_trans_t		*tp,

Might as well convert all these typedefs too, just like the other
patches.  Otherwise this looks fine to me.

--D

> -	xfs_qoff_logitem_t	*qlp)
> +	struct xfs_qoff_logitem	*qlp)
>  {
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
> -- 
> 2.23.0
> 
