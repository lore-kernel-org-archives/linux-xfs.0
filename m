Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32439C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F14A0222D3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:44:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dCzct2D9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfKMEoR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:44:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56708 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfKMEoR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 23:44:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4i4YY153659;
        Wed, 13 Nov 2019 04:44:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=foWyu2sj0IM5RM2ycxLNIerfLxz2XXeWz8sCgFEB/NU=;
 b=dCzct2D9Vky8UqshCR3y+a4WnoL+5kHvzSD/tL7ka9ueevcCg4JTmrrBrCFgpPhwcfni
 HovrArutWnIFXA0OZKoWMyOzmJ/y7JjJVPb2K9WUeZ+75JLjmaNGox0Rv4HLcxAyp33v
 1dotKVOQQSp0ayuXZTYYCnTUoeBUwwAE1FkKB2Duud3nt3lOTK5u4wqS6kmpgnB2b71D
 B8ElG6ZzP3mR5Hvs5L83W6F/KdXYXZdvF/DLtyhXvJAj4o4JJSgkpsoXHVbNbPkLhOBW
 VAFquU3WZ4R64REVDdh5GJ8AfM7uzqSM2zir3CQp+JuFxB/VYoeflzKL8oXf2YXTnYjA rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w5p3qsfx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:44:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4hibI188278;
        Wed, 13 Nov 2019 04:44:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w7vbc58gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:44:13 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD4iCjK010759;
        Wed, 13 Nov 2019 04:44:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 20:44:12 -0800
Date:   Tue, 12 Nov 2019 20:44:11 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/5] xfs: remove the xfs_qoff_logitem_t typedef
Message-ID: <20191113044411.GM6219@magnolia>
References: <20191112213310.212925-1-preichl@redhat.com>
 <20191112213310.212925-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112213310.212925-5-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130041
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 10:33:09PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |  5 ++---
>  fs/xfs/xfs_dquot_item.h        | 28 +++++++++++++++-------------
>  fs/xfs/xfs_qm_syscalls.c       | 29 ++++++++++++++++-------------
>  fs/xfs/xfs_trans_dquot.c       | 12 ++++++------
>  4 files changed, 39 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 271cca13565b..da6642488177 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -741,8 +741,7 @@ xfs_calc_qm_dqalloc_reservation(
>  
>  /*
>   * Turning off quotas.
> - *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
> - *    the superblock for the quota flags: sector size
> + * the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
>   */
>  STATIC uint
>  xfs_calc_qm_quotaoff_reservation(
> @@ -754,7 +753,7 @@ xfs_calc_qm_quotaoff_reservation(
>  
>  /*
>   * End of turning off quotas.
> - *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
> + * the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
>   */
>  STATIC uint
>  xfs_calc_qm_quotaoff_end_reservation(void)
> diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
> index 3a64a7fd3b8a..3bb19e556ade 100644
> --- a/fs/xfs/xfs_dquot_item.h
> +++ b/fs/xfs/xfs_dquot_item.h
> @@ -12,24 +12,26 @@ struct xfs_mount;
>  struct xfs_qoff_logitem;
>  
>  struct xfs_dq_logitem {
> -	struct xfs_log_item	 qli_item;	/* common portion */
> +	struct xfs_log_item	qli_item;	/* common portion */
>  	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
> -	xfs_lsn_t		 qli_flush_lsn;	/* lsn at last flush */
> +	xfs_lsn_t		qli_flush_lsn;	/* lsn at last flush */
>  };
>  
> -typedef struct xfs_qoff_logitem {
> -	struct xfs_log_item	 qql_item;	/* common portion */
> -	struct xfs_qoff_logitem *qql_start_lip; /* qoff-start logitem, if any */
> +struct xfs_qoff_logitem {
> +	struct xfs_log_item	qql_item;	/* common portion */
> +	struct xfs_qoff_logitem *qql_start_lip;	/* qoff-start logitem, if any */
>  	unsigned int		qql_flags;
> -} xfs_qoff_logitem_t;
> +};
>  
>  
> -extern void		   xfs_qm_dquot_logitem_init(struct xfs_dquot *);
> -extern xfs_qoff_logitem_t *xfs_qm_qoff_logitem_init(struct xfs_mount *,
> -					struct xfs_qoff_logitem *, uint);
> -extern xfs_qoff_logitem_t *xfs_trans_get_qoff_item(struct xfs_trans *,
> -					struct xfs_qoff_logitem *, uint);
> -extern void		   xfs_trans_log_quotaoff_item(struct xfs_trans *,
> -					struct xfs_qoff_logitem *);
> +void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
> +struct xfs_qoff_logitem	*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
> +		struct xfs_qoff_logitem *start,
> +		uint flags);
> +struct xfs_qoff_logitem	*xfs_trans_get_qoff_item(struct xfs_trans *tp,
> +		struct xfs_qoff_logitem *startqoff,
> +		uint flags);
> +void xfs_trans_log_quotaoff_item(struct xfs_trans *tp,
> +		struct xfs_qoff_logitem *qlp);
>  
>  #endif	/* __XFS_DQUOT_ITEM_H__ */
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index da7ad0383037..e685b9ae90b9 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -19,9 +19,12 @@
>  #include "xfs_qm.h"
>  #include "xfs_icache.h"
>  
> -STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
> -STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
> -					uint);
> +STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
> +					struct xfs_qoff_logitem **qoffstartp,
> +					uint flags);
> +STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
> +					struct xfs_qoff_logitem *startqoff,
> +					uint flags);
>  
>  /*
>   * Turn off quota accounting and/or enforcement for all udquots and/or
> @@ -40,7 +43,7 @@ xfs_qm_scall_quotaoff(
>  	uint			dqtype;
>  	int			error;
>  	uint			inactivate_flags;
> -	xfs_qoff_logitem_t	*qoffstart;
> +	struct xfs_qoff_logitem	*qoffstart;
>  
>  	/*
>  	 * No file system can have quotas enabled on disk but not in core.
> @@ -540,13 +543,13 @@ xfs_qm_scall_setqlim(
>  
>  STATIC int
>  xfs_qm_log_quotaoff_end(
> -	xfs_mount_t		*mp,
> -	xfs_qoff_logitem_t	*startqoff,
> +	struct xfs_mount	*mp,
> +	struct xfs_qoff_logitem	*startqoff,
>  	uint			flags)
>  {
> -	xfs_trans_t		*tp;
> +	struct xfs_trans	*tp;
>  	int			error;
> -	xfs_qoff_logitem_t	*qoffi;
> +	struct xfs_qoff_logitem	*qoffi;
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
>  	if (error)
> @@ -568,13 +571,13 @@ xfs_qm_log_quotaoff_end(
>  
>  STATIC int
>  xfs_qm_log_quotaoff(
> -	xfs_mount_t	       *mp,
> -	xfs_qoff_logitem_t     **qoffstartp,
> -	uint		       flags)
> +	struct xfs_mount	*mp,
> +	struct xfs_qoff_logitem	**qoffstartp,
> +	uint			flags)
>  {
> -	xfs_trans_t	       *tp;
> +	struct xfs_trans	*tp;
>  	int			error;
> -	xfs_qoff_logitem_t     *qoffi;
> +	struct xfs_qoff_logitem	*qoffi;
>  
>  	*qoffstartp = NULL;
>  
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index d319347093d6..454fc83c588a 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -824,13 +824,13 @@ xfs_trans_reserve_quota_nblks(
>  /*
>   * This routine is called to allocate a quotaoff log item.
>   */
> -xfs_qoff_logitem_t *
> +struct xfs_qoff_logitem *
>  xfs_trans_get_qoff_item(
> -	xfs_trans_t		*tp,
> -	xfs_qoff_logitem_t	*startqoff,
> +	struct xfs_trans	*tp,
> +	struct xfs_qoff_logitem	*startqoff,
>  	uint			flags)
>  {
> -	xfs_qoff_logitem_t	*q;
> +	struct xfs_qoff_logitem	*q;
>  
>  	ASSERT(tp != NULL);
>  
> @@ -852,8 +852,8 @@ xfs_trans_get_qoff_item(
>   */
>  void
>  xfs_trans_log_quotaoff_item(
> -	xfs_trans_t		*tp,
> -	xfs_qoff_logitem_t	*qlp)
> +	struct xfs_trans	*tp,
> +	struct xfs_qoff_logitem	*qlp)
>  {
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
> -- 
> 2.23.0
> 
