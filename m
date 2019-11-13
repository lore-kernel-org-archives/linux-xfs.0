Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA711C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE26C2245A
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:44:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QcOR5BA5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfKMEoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:44:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49014 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfKMEoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 23:44:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4i4sO173750;
        Wed, 13 Nov 2019 04:44:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=d9sT1GLpJG6ebymAqMPtqKLI+IP/NYrUrsNcOjnhgBo=;
 b=QcOR5BA5Elh6MvDAnKqHumc7fYcIb9yctiHbbFVOL102D/YhuUdWI4pJCrZYCXt0RVJK
 lQr9GXNH31llAjxqeqmnILNd63CP2b2VNYpscwRVu8PES7Moex2Tsrza3StTJVCZ5b1/
 +PW2d24ihBMiDpHUcKRA4dwmhdOwajyYpT805d8ERoRqk6C5JRHIJD0pHBJU57Gv6s2T
 rySAEPo2ZP/CKKxV4XUi/HzEfDaJcPOcFknHcUFlfO+z9uG8UMRrIBmToLCdIhwWFQD6
 RD3yDLIiXP4St9oBv8r6lJBNZLZvkzJe/Fn11WvVBVFemLyCOmm81UBJjhF43hcFqVK6 IQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w5ndq9kmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:44:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4h0Ch073437;
        Wed, 13 Nov 2019 04:44:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w7j04ysd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:44:50 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD4iniS011103;
        Wed, 13 Nov 2019 04:44:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 20:44:49 -0800
Date:   Tue, 12 Nov 2019 20:44:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 2/5] xfs: remove the xfs_quotainfo_t typedef
Message-ID: <20191113044448.GO6219@magnolia>
References: <20191112213310.212925-1-preichl@redhat.com>
 <20191112213310.212925-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112213310.212925-3-preichl@redhat.com>
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

On Tue, Nov 12, 2019 at 10:33:07PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks fine,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_qm.c          | 20 ++++++++++----------
>  fs/xfs/xfs_qm.h          |  6 +++---
>  fs/xfs/xfs_trans_dquot.c |  2 +-
>  3 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 035930a4f0dd..64a944296fda 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -30,10 +30,10 @@
>   * quota functionality, including maintaining the freelist and hash
>   * tables of dquots.
>   */
> -STATIC int	xfs_qm_init_quotainos(xfs_mount_t *);
> -STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
> +STATIC int	xfs_qm_init_quotainos(struct xfs_mount *mp);
> +STATIC int	xfs_qm_init_quotainfo(struct xfs_mount *mp);
>  
> -STATIC void	xfs_qm_destroy_quotainos(xfs_quotainfo_t *qi);
> +STATIC void	xfs_qm_destroy_quotainos(struct xfs_quotainfo *qi);
>  STATIC void	xfs_qm_dqfree_one(struct xfs_dquot *dqp);
>  /*
>   * We use the batch lookup interface to iterate over the dquots as it
> @@ -540,9 +540,9 @@ xfs_qm_shrink_count(
>  
>  STATIC void
>  xfs_qm_set_defquota(
> -	xfs_mount_t	*mp,
> -	uint		type,
> -	xfs_quotainfo_t	*qinf)
> +	struct xfs_mount	*mp,
> +	uint			type,
> +	struct xfs_quotainfo	*qinf)
>  {
>  	struct xfs_dquot	*dqp;
>  	struct xfs_def_quota	*defq;
> @@ -643,7 +643,7 @@ xfs_qm_init_quotainfo(
>  
>  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
>  
> -	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(xfs_quotainfo_t), 0);
> +	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(struct xfs_quotainfo), 0);
>  
>  	error = list_lru_init(&qinf->qi_lru);
>  	if (error)
> @@ -710,9 +710,9 @@ xfs_qm_init_quotainfo(
>   */
>  void
>  xfs_qm_destroy_quotainfo(
> -	xfs_mount_t	*mp)
> +	struct xfs_mount	*mp)
>  {
> -	xfs_quotainfo_t *qi;
> +	struct xfs_quotainfo	*qi;
>  
>  	qi = mp->m_quotainfo;
>  	ASSERT(qi != NULL);
> @@ -1568,7 +1568,7 @@ xfs_qm_init_quotainos(
>  
>  STATIC void
>  xfs_qm_destroy_quotainos(
> -	xfs_quotainfo_t	*qi)
> +	struct xfs_quotainfo	*qi)
>  {
>  	if (qi->qi_uquotaip) {
>  		xfs_irele(qi->qi_uquotaip);
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index b41b75089548..7823af39008b 100644
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
> @@ -76,8 +76,8 @@ typedef struct xfs_quotainfo {
>  	struct xfs_def_quota	qi_usr_default;
>  	struct xfs_def_quota	qi_grp_default;
>  	struct xfs_def_quota	qi_prj_default;
> -	struct shrinker  qi_shrinker;
> -} xfs_quotainfo_t;
> +	struct shrinker	qi_shrinker;
> +};
>  
>  static inline struct radix_tree_root *
>  xfs_dquot_tree(
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 0b7f6f228662..d319347093d6 100644
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
