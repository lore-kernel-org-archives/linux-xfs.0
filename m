Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901A6C35242
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F64320714
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:30:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="v48Kopbd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgBKFao (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 00:30:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59126 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbgBKFao (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 00:30:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01B5SuKr151697;
        Tue, 11 Feb 2020 05:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4lEin/ugnkMSGL5mdFY1w9lc/VdMGfR+r7/lCzlAzMs=;
 b=v48KopbdDey3ARqFvQ6CIbMnAlYXzpaoHbwrwsbdpYxQHmMnzvgK/h6PDE2/k2JpggF3
 rz7Qp+zJ7ne7NCP22LZ6v+pYReurxpKtYw/YoLHq4BkSaS8z/jlZNgQKF81GFx4mWhQn
 lbJVkX3UZeAhQZbe6HJqUDBx9UE9w3JNCXf2vy8oJmPv3P/uzHwz14ji168zBMft+iL4
 vuGqYmxkaAmhS44oBoKAJtDO+BJtdQTrCzLOe3D1dx3Mmti69CxS5cQjocu7aszlKUTX
 QXeUaYs0ALRWL8gh7hDEmBzFvXn+bmFEj+0pwKZRwqv0QC+30CYR7oK5Ln33L4V5X6pf Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y2jx616ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Feb 2020 05:30:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01B5S80J076587;
        Tue, 11 Feb 2020 05:30:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y26hu98da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Feb 2020 05:30:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01B5Uc7F010672;
        Tue, 11 Feb 2020 05:30:39 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Feb 2020 21:30:38 -0800
Subject: Re: [PATCH 1/4] xfs: fix up some whitespace in quota code
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <333ea747-8b45-52ae-006e-a1804e14de32@redhat.com>
 <31c57459-2b3e-984d-cb20-e85566caafd0@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <8bfbb955-a3eb-e204-0125-5cce621691e3@oracle.com>
Date:   Mon, 10 Feb 2020 22:30:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <31c57459-2b3e-984d-cb20-e85566caafd0@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

On 2/8/20 2:10 PM, Eric Sandeen wrote:
> There is a fair bit of whitespace damage in the quota code, so
> fix up enough of it that subsequent patches are restricted to
> functional change to aid review.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Ok, looks like a good clean up
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_dquot.c    | 16 ++++++++--------
>   fs/xfs/xfs_qm.h       | 44 +++++++++++++++++++++----------------------
>   fs/xfs/xfs_quotaops.c |  8 ++++----
>   3 files changed, 34 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d223e1ae90a6..02f433d1f13a 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -205,16 +205,16 @@ xfs_qm_adjust_dqtimers(
>    */
>   STATIC void
>   xfs_qm_init_dquot_blk(
> -	xfs_trans_t	*tp,
> -	xfs_mount_t	*mp,
> -	xfs_dqid_t	id,
> -	uint		type,
> -	xfs_buf_t	*bp)
> +	struct xfs_trans	*tp,
> +	struct xfs_mount	*mp,
> +	xfs_dqid_t		id,
> +	uint			type,
> +	struct xfs_buf		*bp)
>   {
>   	struct xfs_quotainfo	*q = mp->m_quotainfo;
> -	xfs_dqblk_t	*d;
> -	xfs_dqid_t	curid;
> -	int		i;
> +	xfs_dqblk_t		*d;
> +	xfs_dqid_t		curid;
> +	int			i;
>   
>   	ASSERT(tp);
>   	ASSERT(xfs_buf_islocked(bp));
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 4e57edca8bce..3a850401b102 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -42,12 +42,12 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
>   #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
>   
>   struct xfs_def_quota {
> -	xfs_qcnt_t       bhardlimit;     /* default data blk hard limit */
> -	xfs_qcnt_t       bsoftlimit;	 /* default data blk soft limit */
> -	xfs_qcnt_t       ihardlimit;	 /* default inode count hard limit */
> -	xfs_qcnt_t       isoftlimit;	 /* default inode count soft limit */
> -	xfs_qcnt_t	 rtbhardlimit;   /* default realtime blk hard limit */
> -	xfs_qcnt_t	 rtbsoftlimit;   /* default realtime blk soft limit */
> +	xfs_qcnt_t	bhardlimit;	/* default data blk hard limit */
> +	xfs_qcnt_t	bsoftlimit;	/* default data blk soft limit */
> +	xfs_qcnt_t	ihardlimit;	/* default inode count hard limit */
> +	xfs_qcnt_t	isoftlimit;	/* default inode count soft limit */
> +	xfs_qcnt_t	rtbhardlimit;	/* default realtime blk hard limit */
> +	xfs_qcnt_t	rtbsoftlimit;	/* default realtime blk soft limit */
>   };
>   
>   /*
> @@ -55,28 +55,28 @@ struct xfs_def_quota {
>    * The mount structure keeps a pointer to this.
>    */
>   struct xfs_quotainfo {
> -	struct radix_tree_root qi_uquota_tree;
> -	struct radix_tree_root qi_gquota_tree;
> -	struct radix_tree_root qi_pquota_tree;
> -	struct mutex qi_tree_lock;
> +	struct radix_tree_root	qi_uquota_tree;
> +	struct radix_tree_root	qi_gquota_tree;
> +	struct radix_tree_root	qi_pquota_tree;
> +	struct mutex		qi_tree_lock;
>   	struct xfs_inode	*qi_uquotaip;	/* user quota inode */
>   	struct xfs_inode	*qi_gquotaip;	/* group quota inode */
>   	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
> -	struct list_lru	 qi_lru;
> -	int		 qi_dquots;
> -	time64_t	 qi_btimelimit;	 /* limit for blks timer */
> -	time64_t	 qi_itimelimit;	 /* limit for inodes timer */
> -	time64_t	 qi_rtbtimelimit;/* limit for rt blks timer */
> -	xfs_qwarncnt_t	 qi_bwarnlimit;	 /* limit for blks warnings */
> -	xfs_qwarncnt_t	 qi_iwarnlimit;	 /* limit for inodes warnings */
> -	xfs_qwarncnt_t	 qi_rtbwarnlimit;/* limit for rt blks warnings */
> -	struct mutex	 qi_quotaofflock;/* to serialize quotaoff */
> -	xfs_filblks_t	 qi_dqchunklen;	 /* # BBs in a chunk of dqs */
> -	uint		 qi_dqperchunk;	 /* # ondisk dqs in above chunk */
> +	struct list_lru		qi_lru;
> +	int			qi_dquots;
> +	time64_t		qi_btimelimit;	/* limit for blks timer */
> +	time64_t		qi_itimelimit;	/* limit for inodes timer */
> +	time64_t		qi_rtbtimelimit;/* limit for rt blks timer */
> +	xfs_qwarncnt_t		qi_bwarnlimit;	/* limit for blks warnings */
> +	xfs_qwarncnt_t		qi_iwarnlimit;	/* limit for inodes warnings */
> +	xfs_qwarncnt_t		qi_rtbwarnlimit;/* limit for rt blks warnings */
> +	struct mutex		qi_quotaofflock;/* to serialize quotaoff */
> +	xfs_filblks_t		qi_dqchunklen;	/* # BBs in a chunk of dqs */
> +	uint			qi_dqperchunk;	/* # ondisk dq in above chunk */
>   	struct xfs_def_quota	qi_usr_default;
>   	struct xfs_def_quota	qi_grp_default;
>   	struct xfs_def_quota	qi_prj_default;
> -	struct shrinker	qi_shrinker;
> +	struct shrinker		qi_shrinker;
>   };
>   
>   static inline struct radix_tree_root *
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 38669e827206..cb16a91dd1d4 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -23,8 +23,8 @@ xfs_qm_fill_state(
>   	struct xfs_inode	*ip,
>   	xfs_ino_t		ino)
>   {
> -	struct xfs_quotainfo *q = mp->m_quotainfo;
> -	bool tempqip = false;
> +	struct xfs_quotainfo	*q = mp->m_quotainfo;
> +	bool			tempqip = false;
>   
>   	tstate->ino = ino;
>   	if (!ip && ino == NULLFSINO)
> @@ -109,8 +109,8 @@ xfs_fs_set_info(
>   	int			type,
>   	struct qc_info		*info)
>   {
> -	struct xfs_mount *mp = XFS_M(sb);
> -	struct qc_dqblk newlim;
> +	struct xfs_mount	*mp = XFS_M(sb);
> +	struct qc_dqblk		newlim;
>   
>   	if (sb_rdonly(sb))
>   		return -EROFS;
> 
