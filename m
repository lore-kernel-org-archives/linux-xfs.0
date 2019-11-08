Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCAAC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C50921D6C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:20:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FIkP1xzk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfKHAUH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:20:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59202 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfKHAUH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:20:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80IrUT158043;
        Fri, 8 Nov 2019 00:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=U4O53X4geaCVcAQaep52+7yaYMrIS1hKbCHlLNkIwGo=;
 b=FIkP1xzkiW5U3Uw2VIbv3dvhPVi2M+/FGJ2BwD7kYtwBPYFxhekDHa0ahILm/iQ5QnXh
 99NfoChy4f5Ck6t+kf7CrZZzWCH8lB+5AVAgFbHUpGyGrsMrNzA2CAi8ZWVsYuSmzRUi
 r5Jj1Un1Cqi56D/2+HDcTgMhp2/XTXJHKqdkwt8VlHbkq6kGgBUC6lAJz/oY/70/BPk8
 wNpiWSYpjmwXsMBQI0kqiB8d2ymannFUaT2SJP08gr9iJOsDnfgRrHBuqwnyl/ghyUAQ
 gqhMOq+u6fIyBSiV2tZnU3yJ+Lsgm1JYtR/TCEGQ+AcXDt8IEDUiVXJM6RkXZMVmcpmB vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w19u6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:19:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80IqhF073074;
        Fri, 8 Nov 2019 00:19:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w41wjjphs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:19:50 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA80JnSQ012318;
        Fri, 8 Nov 2019 00:19:49 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:19:49 -0800
Date:   Thu, 7 Nov 2019 16:19:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: remove the xfs_quotainfo_t typedef
Message-ID: <20191108001949.GO6219@magnolia>
References: <20191107113549.110129-1-preichl@redhat.com>
 <20191107113549.110129-4-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107113549.110129-4-preichl@redhat.com>
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

On Thu, Nov 07, 2019 at 12:35:47PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/xfs_qm.c          | 14 +++++++-------
>  fs/xfs/xfs_qm.h          |  4 ++--
>  fs/xfs/xfs_trans_dquot.c |  2 +-
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index a8b278348f5a..4088273adb11 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -32,7 +32,7 @@
>  STATIC int	xfs_qm_init_quotainos(xfs_mount_t *);
>  STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
>  
> -STATIC void	xfs_qm_destroy_quotainos(xfs_quotainfo_t *qi);
> +STATIC void	xfs_qm_destroy_quotainos(struct xfs_quotainfo *qi);
>  STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
>  /*
>   * We use the batch lookup interface to iterate over the dquots as it
> @@ -539,9 +539,9 @@ xfs_qm_shrink_count(
>  
>  STATIC void
>  xfs_qm_set_defquota(
> -	xfs_mount_t	*mp,
> -	uint		type,
> -	xfs_quotainfo_t	*qinf)
> +	xfs_mount_t		*mp,

Please de-typedef this while you're touching the lines.

Otherwise looks good!

--D

> +	uint			type,
> +	struct xfs_quotainfo	*qinf)
>  {
>  	struct xfs_dquot	*dqp;
>  	struct xfs_def_quota    *defq;
> @@ -642,7 +642,7 @@ xfs_qm_init_quotainfo(
>  
>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
>  
> -	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), 0);
> +	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(struct xfs_quotainfo), 0);
>  
>  	error = list_lru_init(&qinf->qi_lru);
>  	if (error)
> @@ -711,7 +711,7 @@ void
>  xfs_qm_destroy_quotainfo(
>  	xfs_mount_t	*mp)
>  {
> -	xfs_quotainfo_t *qi;
> +	struct xfs_quotainfo *qi;
>  
>  	qi = mp->m_quotainfo;
>  	ASSERT(qi != NULL);
> @@ -1559,7 +1559,7 @@ xfs_qm_init_quotainos(
>  
>  STATIC void
>  xfs_qm_destroy_quotainos(
> -	xfs_quotainfo_t	*qi)
> +	struct xfs_quotainfo	*qi)
>  {
>  	if (qi->qi_uquotaip) {
>  		xfs_irele(qi->qi_uquotaip);
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index b41b75089548..185c9d89a5cd 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -54,7 +54,7 @@ struct xfs_def_quota {
>   * Various quota information for individual filesystems.
>   * The mount structure keeps a pointer to this.
>   */
> -typedef struct xfs_quotainfo {
> +struct xfs_quotainfo {
>  	struct radix_tree_root qi_uquota_tree;
>  	struct radix_tree_root qi_gquota_tree;
>  	struct radix_tree_root qi_pquota_tree;
> @@ -77,7 +77,7 @@ typedef struct xfs_quotainfo {
>  	struct xfs_def_quota	qi_grp_default;
>  	struct xfs_def_quota	qi_prj_default;
>  	struct shrinker  qi_shrinker;
> -} xfs_quotainfo_t;
> +};
>  
>  static inline struct radix_tree_root *
>  xfs_dquot_tree(
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index ceb25d1cfdb1..4789f7e11f53 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -585,7 +585,7 @@ xfs_trans_dqresv(
>  	xfs_qwarncnt_t		warnlimit;
>  	xfs_qcnt_t		total_count;
>  	xfs_qcnt_t		*resbcountp;
> -	xfs_quotainfo_t		*q = mp->m_quotainfo;
> +	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	struct xfs_def_quota	*defq;
>  
>  
> -- 
> 2.23.0
> 
