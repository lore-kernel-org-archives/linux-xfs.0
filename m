Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CCFC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 21:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D945A2067C
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 21:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YN/q2tgw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgHaVOD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 17:14:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42358 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbgHaVOD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 17:14:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VL44Km103600;
        Mon, 31 Aug 2020 21:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JtEw9tDQyP7SqzewcZitCX5fg8ysFFhbox0YqLD/fng=;
 b=YN/q2tgw5M5OfzBYdV4mmJ0ciKlCSJ4pDKyjx5dQlDkL7zznOv8T4xLaz3l013B8BRJM
 g13dWZdUI38l2gCOa4C46/TWTrpTRbv5uhpE9CPNyris2djRj00BdVIgNWiZlJKayMkN
 Dhit46ACUeEITT376MXVwQ2I8iVulRHhsTqAf8Tl7J0k2ZNmjw1m+PqqdcijIKwPvcjN
 W6xald3vxE2da9hJ6IdbHmNf1MLY1Q07aaqeEq4Ec91qB6kC7znr6r2IhFSLOE5Xb1A0
 UsM10Q1IGu+3PVSrsgRhspNF/3Z/7Jkm3xwPocQv/c+zCnoZCV7JNRPyUWl/qPVeguva 9Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 337eym0kp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 21:13:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VLAYD3073827;
        Mon, 31 Aug 2020 21:13:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3380x1bdbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 21:13:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VLDqAo022179;
        Mon, 31 Aug 2020 21:13:53 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 14:13:52 -0700
Date:   Mon, 31 Aug 2020 14:13:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: Extend data/attr fork extent counter width
Message-ID: <20200831211356.GA6096@magnolia>
References: <20200831130010.454-1-chandanrlinux@gmail.com>
 <20200831130010.454-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831130010.454-4-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 06:30:10PM +0530, Chandan Babu R wrote:
> The commit xfs: fix inode fork extent count overflow
> (3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
> data fork extents should be possible to create. However the
> corresponding on-disk field has a signed 32-bit type. Hence this
> commit extends the per-inode data extent counter to 47 bits. The
> length of 47-bits was chosen because,
> Maximum file size = 2^63.
> Maximum extent count when using 64k block size = 2^63 / 2^16 = 2^47.

Sorry I forgot to reply to your follow up to this question the last time
you sent this series.  I still don't understand why you're consuming 32
more bits of xfs_dinode for the data fork extent count but only using 15
bits of that space.

On a 1k block filesystem, we can have 2^(63-10) = 2^53 extents.
Block sizes this small are still supported by the V5 format.

On a 4k block filesystem, we can have 2^(63-12) = 2^51 extents.
This blocksize is the default on x86.

Granted, that would be aw{ful,esome}, but I do not see why it's necessary
to have this limitation.

> Also, XFS has a per-inode xattr extent counter which is 16 bits
> wide. A workload which
> 1. Creates 1 million 255-byte sized xattrs,
> 2. Deletes 50% of these xattrs in an alternating manner,
> 3. Tries to insert 400,000 new 255-byte sized xattrs
>    causes the xattr extent counter to overflow.
> 
> Dave tells me that there are instances where a single file has more than
> 100 million hardlinks. With parent pointers being stored in xattrs, we
> will overflow the signed 16-bits wide xattr extent counter when large
> number of hardlinks are created. Hence this commit extends the on-disk
> field to 32-bits.
> 
> The following changes are made to accomplish this,
> 
> 1. A new incompat superblock flag to prevent older kernels from mounting
>    the filesystem. This flag has to be set during mkfs time.
> 2. Carve out a new 32-bit field from xfs_dinode->di_pad2[]. This field
>    holds the most significant 15 bits of the data extent counter.
> 3. Carve out a new 16-bit field from xfs_dinode->di_pad2[]. This field
>    holds the most significant 16 bits of the attr extent counter.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c        |  8 ++++---
>  fs/xfs/libxfs/xfs_format.h      | 20 ++++++++++++----
>  fs/xfs/libxfs/xfs_inode_buf.c   | 42 ++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_inode_buf.h   |  4 ++--
>  fs/xfs/libxfs/xfs_inode_fork.h  | 17 +++++++++----
>  fs/xfs/libxfs/xfs_log_format.h  |  8 ++++---
>  fs/xfs/libxfs/xfs_types.h       | 10 ++++----
>  fs/xfs/scrub/inode.c            |  2 +-
>  fs/xfs/xfs_inode.c              |  2 +-
>  fs/xfs/xfs_inode_item.c         | 12 ++++++++--
>  fs/xfs/xfs_inode_item_recover.c | 20 ++++++++++++----
>  11 files changed, 105 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 16b983b8977d..8788f47ba59e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
>  	xfs_mount_t	*mp,		/* file system mount structure */
>  	int		whichfork)	/* data or attr fork */
>  {
> +	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>  	int		level;		/* btree level */
>  	uint		maxblocks;	/* max blocks at this level */
> -	uint		maxleafents;	/* max leaf entries possible */
>  	int		maxrootrecs;	/* max records in root block */
>  	int		minleafrecs;	/* min records in leaf block */
>  	int		minnoderecs;	/* min records in node block */
> @@ -64,7 +64,9 @@ xfs_bmap_compute_maxlevels(
>  	 * The maximum number of extents in a file, hence the maximum number of
>  	 * leaf entries, is controlled by the size of the on-disk extent count,
>  	 * either a signed 32-bit number for the data fork, or a signed 16-bit
> -	 * number for the attr fork.
> +	 * number for the attr fork. With mkfs.xfs' wide-extcount option
> +	 * enabled, the data fork extent count is unsigned 47-bits wide, while
> +	 * the corresponding attr fork extent count is unsigned 32-bits wide.
>  	 *
>  	 * Note that we can no longer assume that if we are in ATTR1 that
>  	 * the fork offset of all the inodes will be
> @@ -464,7 +466,7 @@ xfs_bmap_check_leaf_extents(
>  	if (bp_release)
>  		xfs_trans_brelse(NULL, bp);
>  error_norelse:
> -	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
> +	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
>  		__func__, i);
>  	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
>  	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 5f41e177dbda..2684cafd0356 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -465,10 +465,12 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
>  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> -#define XFS_SB_FEAT_INCOMPAT_ALL \
> +#define XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT	(1 << 3)	/* Wider data/attr fork extent counters */
> +#define XFS_SB_FEAT_INCOMPAT_ALL		\
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
> +		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> +		 XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> @@ -551,6 +553,12 @@ static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
>  		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
>  }
>  
> +static inline bool xfs_sb_version_haswideextcnt(struct xfs_sb *sbp)
> +{
> +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT);
> +}
> +
>  static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
>  {
>  	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> @@ -873,8 +881,8 @@ typedef struct xfs_dinode {
>  	__be64		di_size;	/* number of bytes in file */
>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>  	__be32		di_extsize;	/* basic/minimum extent size for file */
> -	__be32		di_nextents;	/* number of extents in data fork */
> -	__be16		di_anextents;	/* number of extents in attribute fork*/
> +	__be32		di_nextents_lo;	/* lower part of data fork extent count */
> +	__be16		di_anextents_lo;/* lower part of attr fork extent count */
>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	__s8		di_aformat;	/* format of attr fork's data */
>  	__be32		di_dmevmask;	/* DMIG event mask */
> @@ -891,7 +899,9 @@ typedef struct xfs_dinode {
>  	__be64		di_lsn;		/* flush sequence */
>  	__be64		di_flags2;	/* more random flags */
>  	__be32		di_cowextsize;	/* basic cow extent size for file */
> -	__u8		di_pad2[12];	/* more padding for future expansion */
> +	__be32		di_nextents_hi; /* higher part of data fork extent count */
> +	__be16		di_anextents_hi;/* higher part of attr fork extent count */
> +	__u8		di_pad2[6];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
>  	xfs_timestamp_t	di_crtime;	/* time created */
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index cce2aa99aad8..8212bd4b12db 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -258,6 +258,7 @@ xfs_inode_to_disk(
>  	struct xfs_dinode	*to,
>  	xfs_lsn_t		lsn)
>  {
> +	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
>  	struct xfs_icdinode	*from = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  
> @@ -284,8 +285,8 @@ xfs_inode_to_disk(
>  	to->di_size = cpu_to_be64(from->di_size);
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
> -	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> -	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
> +	to->di_nextents_lo = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> +	to->di_anextents_lo = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> @@ -299,6 +300,15 @@ xfs_inode_to_disk(
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		if (xfs_sb_version_haswideextcnt(sbp)) {
> +			to->di_nextents_hi
> +				= cpu_to_be32(xfs_ifork_nextents(&ip->i_df)
> +					>> 32);

I thought you were only using this u32 field for the lower 15 bits?  If
that's really true ("47-bit field") then there ought to be some masking.

(Or you could just support BMBT_STARTOFF_MASK extents...)

Also, this might be a good time to add a helper to decode the extent
counts from the dinode/log dinode.

> +			to->di_anextents_hi
> +				= cpu_to_be16(xfs_ifork_nextents(ip->i_afp)
> +					>> 16);
> +		}
> +
>  		to->di_ino = cpu_to_be64(ip->i_ino);
>  		to->di_lsn = cpu_to_be64(lsn);
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> @@ -312,9 +322,12 @@ xfs_inode_to_disk(
>  
>  void
>  xfs_log_dinode_to_disk(
> +	struct xfs_mount	*mp,
>  	struct xfs_log_dinode	*from,
>  	struct xfs_dinode	*to)
>  {
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +
>  	to->di_magic = cpu_to_be16(from->di_magic);
>  	to->di_mode = cpu_to_be16(from->di_mode);
>  	to->di_version = from->di_version;
> @@ -337,8 +350,8 @@ xfs_log_dinode_to_disk(
>  	to->di_size = cpu_to_be64(from->di_size);
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
> -	to->di_nextents = cpu_to_be32(from->di_nextents);
> -	to->di_anextents = cpu_to_be16(from->di_anextents);
> +	to->di_nextents_lo = cpu_to_be32(from->di_nextents_lo);
> +	to->di_anextents_lo = cpu_to_be16(from->di_anextents_lo);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> @@ -352,6 +365,10 @@ xfs_log_dinode_to_disk(
>  		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> +		if (xfs_sb_version_haswideextcnt(sbp)) {
> +			to->di_nextents_hi = cpu_to_be32(from->di_nextents_hi);
> +			to->di_anextents_hi = cpu_to_be16(from->di_anextents_hi);
> +		}
>  		to->di_ino = cpu_to_be64(from->di_ino);
>  		to->di_lsn = cpu_to_be64(from->di_lsn);
>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> @@ -368,7 +385,7 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	uint32_t		di_nextents;
> +	xfs_extnum_t		di_nextents;
>  	xfs_extnum_t		max_extents;
>  
>  	di_nextents = xfs_dfork_nextents(&mp->m_sb, dip, whichfork);
> @@ -408,10 +425,17 @@ xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip, int whichfork)
>  {
>  	xfs_extnum_t nextents;
>  
> -	if (whichfork == XFS_DATA_FORK)
> -		nextents = be32_to_cpu(dip->di_nextents);
> -	else
> -		nextents = be16_to_cpu(dip->di_anextents);
> +	if (whichfork == XFS_DATA_FORK) {
> +		nextents = be32_to_cpu(dip->di_nextents_lo);
> +		if (xfs_sb_version_haswideextcnt(sbp))
> +			nextents |=
> +				((xfs_extnum_t)be32_to_cpu(dip->di_nextents_hi) << 32);
> +	} else {
> +		nextents = be16_to_cpu(dip->di_anextents_lo);
> +		if (xfs_sb_version_haswideextcnt(sbp))
> +			nextents |=
> +				((xfs_aextnum_t)be16_to_cpu(dip->di_anextents_hi) << 16);
> +	}
>  
>  	return nextents;
>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index a97caf675aaf..288ac17626fd 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -49,8 +49,8 @@ void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
>  void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
>  			  xfs_lsn_t lsn);
>  int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
> -void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
> -			       struct xfs_dinode *to);
> +void	xfs_log_dinode_to_disk(struct xfs_mount *mp,
> +		struct xfs_log_dinode *from, struct xfs_dinode *to);
>  
>  xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
>  			   struct xfs_dinode *dip);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 75e07078967e..bc9246d1fd78 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -21,10 +21,10 @@ struct xfs_ifork {
>  		void		*if_root;	/* extent tree root */
>  		char		*if_data;	/* inline file data */
>  	} if_u1;
> +	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
>  	short			if_broot_bytes;	/* bytes allocated for root */
>  	unsigned char		if_flags;	/* per-fork flags */
>  	int8_t			if_format;	/* format of this fork */
> -	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
>  };
>  
>  /*
> @@ -157,10 +157,17 @@ static inline xfs_extnum_t xfs_iext_max(struct xfs_sb *sbp, int whichfork)
>  {
>  	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
>  
> -	if (whichfork == XFS_DATA_FORK)
> -		return MAXEXTNUM;
> -	else
> -		return MAXAEXTNUM;
> +	if (whichfork == XFS_DATA_FORK) {
> +		if (xfs_sb_version_haswideextcnt(sbp))
> +			return MAXEXTNUM_HI;
> +		else
> +			return MAXEXTNUM;
> +	} else {
> +		if (xfs_sb_version_haswideextcnt(sbp))
> +			return MAXAEXTNUM_HI;
> +		else
> +			return MAXAEXTNUM;
> +	}
>  }
>  
>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index e3400c9c71cd..938883c0218d 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -396,8 +396,8 @@ struct xfs_log_dinode {
>  	xfs_fsize_t	di_size;	/* number of bytes in file */
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> -	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
> -	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
> +	uint32_t	di_nextents_lo;	/* lower part of data fork extent count */
> +	uint16_t	di_anextents_lo;/* lower part of attr fork extent count */
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	int8_t		di_aformat;	/* format of attr fork's data */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
> @@ -414,7 +414,9 @@ struct xfs_log_dinode {
>  	xfs_lsn_t	di_lsn;		/* flush sequence */
>  	uint64_t	di_flags2;	/* more random flags */
>  	uint32_t	di_cowextsize;	/* basic cow extent size for file */
> -	uint8_t		di_pad2[12];	/* more padding for future expansion */
> +	uint32_t	di_nextents_hi; /* higher part of data fork extent count */
> +	uint16_t	di_anextents_hi;/* higher part of attr fork extent count */
> +	uint8_t		di_pad2[6];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
>  	xfs_ictimestamp_t di_crtime;	/* time created */
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 397d94775440..c302a89d5c63 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -12,8 +12,8 @@ typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
>  typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
>  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
>  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
> -typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
> -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> +typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
> +typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
>  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
>  typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
>  
> @@ -59,8 +59,10 @@ typedef void *		xfs_failaddr_t;
>   * Max values for extlen, extnum, aextnum.
>   */
>  #define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
> -#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> +#define	MAXEXTNUM	((int32_t)0x7fffffff)		/* signed int */
> +#define	MAXAEXTNUM	((int16_t)0x7fff)		/* signed short */
> +#define MAXEXTNUM_HI	((xfs_extnum_t)0x7fffffffffff)	/* unsigned 47 bits */
> +#define MAXAEXTNUM_HI	((xfs_aextnum_t)0xffffffff)	/* unsigned 32 bits */
>  
>  /*
>   * Minimum and maximum blocksize and sectorsize.
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index e428ad0eef03..e6a58e59720e 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -206,7 +206,7 @@ xchk_dinode(
>  	size_t			fork_recs;
>  	unsigned long long	isize;
>  	uint64_t		flags2;
> -	uint32_t		nextents;
> +	xfs_extnum_t		nextents;
>  	uint16_t		flags;
>  	uint16_t		mode;
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8d195b6ef326..d11d22f7755b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3517,7 +3517,7 @@ xfs_iflush(
>  				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
>  		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
>  			"%s: detected corrupt incore inode %Lu, "
> -			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
> +			"total extents = %llu, nblocks = %Ld, ptr "PTR_FMT,

Might be a good time to get rid of these nonstandard "%Ld" format
specifiers too...

>  			__func__, ip->i_ino,
>  			ip->i_df.if_nextents + xfs_ifork_nextents(ip->i_afp),
>  			ip->i_d.di_nblocks, ip);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 895f61b2b4f0..a65fd62237c6 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -301,6 +301,7 @@ xfs_inode_to_log_dinode(
>  	struct xfs_log_dinode	*to,
>  	xfs_lsn_t		lsn)
>  {
> +	struct xfs_sb		*sbp = &ip->i_mount->m_sb;
>  	struct xfs_icdinode	*from = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
>  
> @@ -326,8 +327,8 @@ xfs_inode_to_log_dinode(
>  	to->di_size = from->di_size;
>  	to->di_nblocks = from->di_nblocks;
>  	to->di_extsize = from->di_extsize;
> -	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
> -	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
> +	to->di_nextents_lo = xfs_ifork_nextents(&ip->i_df);
> +	to->di_anextents_lo = xfs_ifork_nextents(ip->i_afp);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_dmevmask = from->di_dmevmask;
> @@ -344,6 +345,13 @@ xfs_inode_to_log_dinode(
>  		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
>  		to->di_flags2 = from->di_flags2;
>  		to->di_cowextsize = from->di_cowextsize;
> +		if (xfs_sb_version_haswideextcnt(sbp)) {
> +			to->di_nextents_hi
> +				= xfs_ifork_nextents(&ip->i_df) >> 32;
> +			to->di_anextents_hi
> +				= xfs_ifork_nextents(ip->i_afp) >> 16;
> +		}
> +
>  		to->di_ino = ip->i_ino;
>  		to->di_lsn = lsn;
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 5e0d291835b3..d2bf9e5b0e24 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -126,6 +126,8 @@ xlog_recover_inode_commit_pass2(
>  	struct xfs_mount		*mp = log->l_mp;
>  	struct xfs_buf			*bp;
>  	struct xfs_dinode		*dip;
> +	xfs_extnum_t                    nextents;
> +	xfs_aextnum_t                   anextents;
>  	int				len;
>  	char				*src;
>  	char				*dest;
> @@ -256,16 +258,24 @@ xlog_recover_inode_commit_pass2(
>  			goto out_release;
>  		}
>  	}
> -	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
> +
> +	nextents = ldip->di_nextents_lo;
> +	if (xfs_sb_version_haswideextcnt(&mp->m_sb))
> +		nextents |= ((xfs_extnum_t)(ldip->di_nextents_hi) << 32);
> +
> +	anextents = ldip->di_anextents_lo;
> +	if (xfs_sb_version_haswideextcnt(&mp->m_sb))
> +		anextents |= ((xfs_aextnum_t)(ldip->di_anextents_hi) << 16);
> +
> +	if (unlikely(nextents + anextents > ldip->di_nblocks)) {
>  		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
>  				     sizeof(*ldip));
>  		xfs_alert(mp,
>  	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
> -	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
> +	"dino bp "PTR_FMT", ino %Ld, total extents = %llu, nblocks = %Ld",
>  			__func__, item, dip, bp, in_f->ilf_ino,
> -			ldip->di_nextents + ldip->di_anextents,
> -			ldip->di_nblocks);
> +			nextents + anextents, ldip->di_nblocks);
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}
> @@ -293,7 +303,7 @@ xlog_recover_inode_commit_pass2(
>  	}
>  
>  	/* recover the log dinode inode into the on disk inode */
> -	xfs_log_dinode_to_disk(ldip, dip);
> +	xfs_log_dinode_to_disk(mp, ldip, dip);
>  
>  	fields = in_f->ilf_fields;
>  	if (fields & XFS_ILOG_DEV)
> -- 
> 2.28.0
> 
