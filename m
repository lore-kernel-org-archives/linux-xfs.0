Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B422AC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DB0D2081A
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 16:25:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E/e1bnGP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgESQZ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 12:25:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54486 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbgESQZ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 12:25:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGHOW6195645;
        Tue, 19 May 2020 16:25:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=BAZmJ8q+T05FXSpPCVkrlxpIp2qu0ZqSfKcDpzzPRcQ=;
 b=E/e1bnGPR3n9XapmhqS6fgLy2fnrZj+x29S46biAuOje6qAPIg//0t6BRmDAv3Y7qeeq
 IDFrFOCweSKl66d9ak8E/lnleWgik0DlNMY7b4H16/3wIUAitOfK09T15bGXlGGjBH9y
 LCMvrcG887nKHz9AoFCiP2D7ZqNbNXOD6cy++102RL2vRf7NNq9FqjB0M3mSs7D4V32a
 Izxp/YKSTl76XKdIpul8QPcyChT9dU1BBVlhshhmjh05gpRYjHOG0t+wOuTK0uMaAdDA
 Vc9A5gmGqQIOvci1+FPAwRKqo/cKKej5nXt8BxOu96YKtzt7qMFF28eMsHCi6RbqnbYe YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3128tnebfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 16:25:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JGNCM0163071;
        Tue, 19 May 2020 16:25:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 312sxt3b02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 16:25:53 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04JGPqev014609;
        Tue, 19 May 2020 16:25:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 09:25:52 -0700
Date:   Tue, 19 May 2020 09:25:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/6] xfs: fix up some whitespace in quota code
Message-ID: <20200519162551.GM17627@magnolia>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <842a7671-b514-d698-b996-5c1ccf65a6ad@redhat.com>
 <ca896e6a-9390-4ea8-ea70-642dba320686@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca896e6a-9390-4ea8-ea70-642dba320686@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 01:49:42PM -0500, Eric Sandeen wrote:
> There is a fair bit of whitespace damage in the quota code, so
> fix up enough of it that subsequent patches are restricted to
> functional change to aid review.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_dquot.c    | 16 ++++++++--------
>  fs/xfs/xfs_qm.h       | 44 +++++++++++++++++++++----------------------
>  fs/xfs/xfs_quotaops.c |  8 ++++----
>  3 files changed, 34 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index af2c8e5ceea0..96e33390c6a0 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -205,16 +205,16 @@ xfs_qm_adjust_dqtimers(
>   */
>  STATIC void
>  xfs_qm_init_dquot_blk(
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
>  {
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
> -	xfs_dqblk_t	*d;
> -	xfs_dqid_t	curid;
> -	int		i;
> +	xfs_dqblk_t		*d;
> +	xfs_dqid_t		curid;
> +	int			i;
>  
>  	ASSERT(tp);
>  	ASSERT(xfs_buf_islocked(bp));
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 4e57edca8bce..3a850401b102 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -42,12 +42,12 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
>  #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
>  
>  struct xfs_def_quota {
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
>  };
>  
>  /*
> @@ -55,28 +55,28 @@ struct xfs_def_quota {
>   * The mount structure keeps a pointer to this.
>   */
>  struct xfs_quotainfo {
> -	struct radix_tree_root qi_uquota_tree;
> -	struct radix_tree_root qi_gquota_tree;
> -	struct radix_tree_root qi_pquota_tree;
> -	struct mutex qi_tree_lock;
> +	struct radix_tree_root	qi_uquota_tree;
> +	struct radix_tree_root	qi_gquota_tree;
> +	struct radix_tree_root	qi_pquota_tree;
> +	struct mutex		qi_tree_lock;
>  	struct xfs_inode	*qi_uquotaip;	/* user quota inode */
>  	struct xfs_inode	*qi_gquotaip;	/* group quota inode */
>  	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
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
>  	struct xfs_def_quota	qi_usr_default;
>  	struct xfs_def_quota	qi_grp_default;
>  	struct xfs_def_quota	qi_prj_default;
> -	struct shrinker	qi_shrinker;
> +	struct shrinker		qi_shrinker;
>  };
>  
>  static inline struct radix_tree_root *
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 38669e827206..cb16a91dd1d4 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -23,8 +23,8 @@ xfs_qm_fill_state(
>  	struct xfs_inode	*ip,
>  	xfs_ino_t		ino)
>  {
> -	struct xfs_quotainfo *q = mp->m_quotainfo;
> -	bool tempqip = false;
> +	struct xfs_quotainfo	*q = mp->m_quotainfo;
> +	bool			tempqip = false;
>  
>  	tstate->ino = ino;
>  	if (!ip && ino == NULLFSINO)
> @@ -109,8 +109,8 @@ xfs_fs_set_info(
>  	int			type,
>  	struct qc_info		*info)
>  {
> -	struct xfs_mount *mp = XFS_M(sb);
> -	struct qc_dqblk newlim;
> +	struct xfs_mount	*mp = XFS_M(sb);
> +	struct qc_dqblk		newlim;
>  
>  	if (sb_rdonly(sb))
>  		return -EROFS;
> -- 
> 2.17.0
> 
