Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12623FC6196
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 22:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE41320865
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 22:18:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lMZCGQWZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbfKHWS2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 17:18:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729232AbfKHWS2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 17:18:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8MEc23045250;
        Fri, 8 Nov 2019 22:18:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=6udmGZE0wgmnWl1UOYl/qN35qS4yRy5I7BH7zzkMJa0=;
 b=lMZCGQWZwzqHdhlqI65kFVLv1q0TpIC9DdltRMN/00WDxNDL3asmYeXFjhXuVxZbltBu
 N7dCo/vKFHF3uM607QwuMkda0kSg7T21MFnDoAm5lAs4VoLAoNLhdgImFDLOJAghx9LJ
 FJyxUUhiwRcRo+h4BvMF66PwA02MLlNeFyCibK/xNrGUrhJLyN9Bofplj98QDclMLvaH
 yjfTndHpQHC4h3IQIhnSOZCqiopFo6m5xmT6Bz2ytmVzWgXx9dtZ6drPc49UCp8MIhbe
 t1Y64+A6ut1CNdk14yJquSRtfYrRIETC+kLFHI1i2ERGYOlYK4YeSCKgKf7nXqsnYIsu dQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w41w1g0pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 22:18:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8M9BT8126355;
        Fri, 8 Nov 2019 22:16:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w4k34m483-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 22:16:18 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA8MGIA6018020;
        Fri, 8 Nov 2019 22:16:18 GMT
Received: from localhost (/10.159.140.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 22:16:18 +0000
Date:   Fri, 8 Nov 2019 14:16:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] xfs: remove the xfs_quotainfo_t typedef
Message-ID: <20191108221617.GL6219@magnolia>
References: <20191108210612.423439-1-preichl@redhat.com>
 <20191108210612.423439-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108210612.423439-3-preichl@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080213
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080214
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 10:06:10PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/xfs_qm.c          | 20 ++++++++++----------
>  fs/xfs/xfs_qm.h          |  4 ++--
>  fs/xfs/xfs_trans_dquot.c |  2 +-
>  3 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index c11b3b1af8e9..92d8756b628e 100644
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
>  	struct xfs_def_quota    *defq;
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
> +	struct xfs_mount     *mp)

This indentation here   ^^^^^ should be tabs, not spaces.

>  {
> -	xfs_quotainfo_t *qi;
> +	struct xfs_quotainfo *qi;

Please fix this space here  ^ to be a tab too.

(FYI, the 'list' option in vim will show you tabs vs. spaces to make
your life easier...)

--D
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
