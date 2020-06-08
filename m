Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195ADC433DF
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 17:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E08A720885
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 17:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lPLrCpKM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730709AbgFHRVf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 13:21:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41818 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbgFHRVf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 13:21:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058HC0i6053258;
        Mon, 8 Jun 2020 17:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=t5aJnosOt3Yh6JyLkOaoJWMngZYQOkGqj11s7+DLNSg=;
 b=lPLrCpKMNaAYJlViiVYYf6mtG/YeJdefLPJJrFowxgNwoCxGTv2GRaAHrg12O33pcy6b
 fDYPy6KeKOGtBoFpG2BdhQu4jMWApfaY7ZaRHU9Feb/AkM7Jer4Esb6jfhiIy6xFMM7R
 Qtlcjos0n4UamxaqEFjBBMZG9FJfIJHki8rB4F9MZNT/0upqX8b4NBCXrxgIKHpP/0/Q
 V66gng4Pd1XWZJJwZ8uEIUSQqDJhILP7hgZyMg0JpD1/ShUcQnO6F0/ZE82Ik7slqbfo
 4Zk2sUXA8X9xVe6F0n+9o89kfQmCyjDyjv1aXfYq+grx+93OBXIr7vhbFNKVvlGiKLKf Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31g3smqysv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 17:21:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058HIJ08159768;
        Mon, 8 Jun 2020 17:21:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31gn23cyap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 17:21:25 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 058HLOqw009129;
        Mon, 8 Jun 2020 17:21:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 10:21:24 -0700
Date:   Mon, 8 Jun 2020 10:21:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 7/7] xfs: Extend attr extent counter to 32 bits
Message-ID: <20200608172121.GG1334206@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
 <20200606082745.15174-8-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606082745.15174-8-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=5 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=5
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 06, 2020 at 01:57:45PM +0530, Chandan Babu R wrote:
> This commit extends the per-inode attr extent counter to 32 bits.
> 
> The following changes are made to accomplish this,
> 1. A new ro-compat superblock flag to prevent older kernels from
>    mounting the filesystem in read-write mode. This flag is set for the
>    first time when an inode would end up having more than 2^15 extents.
> 3. Carve out a new 16-bit field from xfs_dinode->di_pad2[]. This field
>    holds the most significant 16 bits of the attr extent counter.

How difficult is it to end up with an attr fork mapping more than 2^32
blocks?  Supposing I have a file with nlinks==2^32-1, each mapped to a
255-byte name and some number of other xattrs?

> 2. A new inode->di_flags2 flag to indicate that the newly added field
>    contains valid data. This flag is set when one of the following two
>    conditions are met,
>    - When the inode is about to have more than 2^15 extents.
>    - When flushing the incore inode (See xfs_iflush_int()), if
>      the superblock ro-compat flag is already set.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_format.h      | 25 ++++++++++---
>  fs/xfs/libxfs/xfs_inode_buf.c   | 23 +++++++++---
>  fs/xfs/libxfs/xfs_inode_fork.c  | 62 ++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_log_format.h  |  5 +--
>  fs/xfs/libxfs/xfs_types.h       |  5 +--
>  fs/xfs/scrub/inode.c            |  5 +--
>  fs/xfs/xfs_inode.c              |  4 +++
>  fs/xfs/xfs_inode_item.c         |  5 ++-
>  fs/xfs/xfs_inode_item_recover.c |  8 ++++-
>  9 files changed, 113 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 91bee33aa988..2e37d887fd35 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -450,11 +450,13 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
>  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
>  #define XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR (1 << 3)	/* 47bit data extents */
> +#define XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR (1 << 4)	/* 32bit attr extents */

Can we bundle both of these changes in a single feature flag?  I would
like to keep our feature testing matrix as small as we can.

/* 64-bit data fork extent counts and 32-bit attr fork extent counts */
#define XFS_SB_FEAT_RO_COMPAT_BIG_FORK	(1 << 4)

>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
>  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
> -		 XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR)
> +		 XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR | \
> +		 XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR)
>  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
>  static inline bool
>  xfs_sb_has_ro_compat_feature(
> @@ -577,6 +579,18 @@ static inline void xfs_sb_version_add47bitext(struct xfs_sb *sbp)
>  	sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR;
>  }
>  
> +static inline bool xfs_sb_version_has32bitaext(struct xfs_sb *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		(sbp->sb_features_ro_compat &
> +			XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR);
> +}
> +
> +static inline void xfs_sb_version_add32bitaext(struct xfs_sb *sbp)
> +{
> +	sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR;
> +}
> +
>  /*
>   * end of superblock version macros
>   */
> @@ -888,7 +902,7 @@ typedef struct xfs_dinode {
>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>  	__be32		di_extsize;	/* basic/minimum extent size for file */
>  	__be32		di_nextents_lo;	/* number of extents in data fork */
> -	__be16		di_anextents;	/* number of extents in attribute fork*/
> +	__be16		di_anextents_lo;/* lower part of xattr extent count */
>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	__s8		di_aformat;	/* format of attr fork's data */
>  	__be32		di_dmevmask;	/* DMIG event mask */
> @@ -906,7 +920,8 @@ typedef struct xfs_dinode {
>  	__be64		di_flags2;	/* more random flags */
>  	__be32		di_cowextsize;	/* basic cow extent size for file */
>  	__be32		di_nextents_hi;
> -	__u8		di_pad2[8];	/* more padding for future expansion */
> +	__be16		di_anextents_hi;/* higher part of xattr extent count */
> +	__u8		di_pad2[6];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
>  	xfs_timestamp_t	di_crtime;	/* time created */
> @@ -1073,14 +1088,16 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
>  #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
>  #define XFS_DIFLAG2_47BIT_NEXTENTS_BIT 3 /* Uses di_nextents_hi field */
> +#define XFS_DIFLAG2_32BIT_ANEXTENTS_BIT 4 /* Uses di_anextents_hi field  */

Same thing here.

>  #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
>  #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
>  #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
>  #define XFS_DIFLAG2_47BIT_NEXTENTS (1 << XFS_DIFLAG2_47BIT_NEXTENTS_BIT)
> +#define XFS_DIFLAG2_32BIT_ANEXTENTS (1 << XFS_DIFLAG2_32BIT_ANEXTENTS_BIT)
>  
>  #define XFS_DIFLAG2_ANY \
>  	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
> -	 XFS_DIFLAG2_47BIT_NEXTENTS)
> +	 XFS_DIFLAG2_47BIT_NEXTENTS | XFS_DIFLAG2_32BIT_ANEXTENTS)
>  
>  /*
>   * Inode number format:
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 8b89fe080f70..285cbce0cd10 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -309,7 +309,8 @@ xfs_inode_to_disk(
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
>  	to->di_nextents_lo = cpu_to_be32(xfs_ifork_nextents(&ip->i_df) &
>  					0xffffffffU);
> -	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
> +	to->di_anextents_lo = cpu_to_be16(xfs_ifork_nextents(ip->i_afp) &
> +					0xffffU);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> @@ -327,6 +328,10 @@ xfs_inode_to_disk(
>  			to->di_nextents_hi
>  				= cpu_to_be32(xfs_ifork_nextents(&ip->i_df)
>  					>> 32);
> +		if (from->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> +			to->di_anextents_hi
> +				= cpu_to_be16(xfs_ifork_nextents(ip->i_afp)
> +					>> 16);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
>  		to->di_lsn = cpu_to_be64(lsn);
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> @@ -366,7 +371,7 @@ xfs_log_dinode_to_disk(
>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
>  	to->di_extsize = cpu_to_be32(from->di_extsize);
>  	to->di_nextents_lo = cpu_to_be32(from->di_nextents_lo);
> -	to->di_anextents = cpu_to_be16(from->di_anextents);
> +	to->di_anextents_lo = cpu_to_be16(from->di_anextents_lo);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = from->di_aformat;
>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> @@ -383,6 +388,9 @@ xfs_log_dinode_to_disk(
>  		if (from->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
>  			to->di_nextents_hi =
>  				cpu_to_be32(from->di_nextents_hi);
> +		if (from->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> +			to->di_anextents_hi =
> +				cpu_to_be16(from->di_anextents_hi);
>  		to->di_ino = cpu_to_be64(from->di_ino);
>  		to->di_lsn = cpu_to_be64(from->di_lsn);
>  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> @@ -566,7 +574,7 @@ xfs_dinode_verify(
>  		default:
>  			return __this_address;
>  		}
> -		if (dip->di_anextents)
> +		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
>  			return __this_address;
>  	}
>  
> @@ -745,8 +753,13 @@ xfs_dfork_nextents(
>  			&& (dip->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS))
>  			nextents |= (u64)(be32_to_cpu(dip->di_nextents_hi))
>  				<< 32;
> -		return nextents;
>  	} else {
> -		return be16_to_cpu(dip->di_anextents);
> +		nextents = be16_to_cpu(dip->di_anextents_lo);
> +		if (xfs_sb_version_has_v3inode(sbp)
> +			&& (dip->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS))
> +			nextents |= (u32)(be16_to_cpu(dip->di_anextents_hi))

<same if test logic vs. if body statement indentation complaint>

> +				<< 16;
>  	}
> +
> +	return nextents;
>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index ec682e2d5bcb..169e16947ece 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -301,7 +301,10 @@ xfs_iformat_attr_fork(
>  	ip->i_afp->if_format = dip->di_aformat;
>  	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
>  		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> -	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
> +	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents_lo);
> +	if (ip->i_d.di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> +		ip->i_afp->if_nextents |=
> +			(u32)(be16_to_cpu(dip->di_anextents_hi)) << 16;
>  
>  	switch (ip->i_afp->if_format) {
>  	case XFS_DINODE_FMT_LOCAL:
> @@ -777,6 +780,48 @@ xfs_next_set_data(
>  	return 0;
>  }
>  
> +static int
> +xfs_next_set_attr(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	struct xfs_ifork	*ifp,
> +	int			delta)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_aextnum_t		nr_exts;
> +
> +	nr_exts = ifp->if_nextents + delta;
> +
> +	if ((delta > 0 && nr_exts < ifp->if_nextents) ||
> +		(delta < 0 && nr_exts > ifp->if_nextents))
> +		return -EOVERFLOW;
> +
> +	if (ifp->if_nextents <= MAXAEXTNUM15BIT &&
> +		nr_exts > MAXAEXTNUM15BIT &&
> +		!(ip->i_d.di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS) &&
> +		xfs_sb_version_has_v3inode(&mp->m_sb)) {
> +		if (!xfs_sb_version_has32bitaext(&mp->m_sb)) {

Indentation complaint^2

> +			bool log_sb = false;
> +
> +			spin_lock(&mp->m_sb_lock);
> +			if (!xfs_sb_version_has32bitaext(&mp->m_sb)) {
> +				xfs_sb_version_add32bitaext(&mp->m_sb);
> +				log_sb = true;
> +			}
> +			spin_unlock(&mp->m_sb_lock);
> +
> +			if (log_sb)
> +				xfs_log_sb(tp);
> +		}
> +
> +		ip->i_d.di_flags2 |= XFS_DIFLAG2_32BIT_ANEXTENTS;
> +	}
> +
> +	ifp->if_nextents = nr_exts;
> +
> +	return 0;
> +}
> +
>  int
>  xfs_next_set(
>  	struct xfs_trans	*tp,
> @@ -785,23 +830,16 @@ xfs_next_set(
>  	int			delta)
>  {
>  	struct xfs_ifork	*ifp;
> -	int64_t			nr_exts;
>  	int			error = 0;
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  
> -	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
> +	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
>  		error = xfs_next_set_data(tp, ip, ifp, delta);
> -	} else if (whichfork == XFS_ATTR_FORK) {
> -		nr_exts = ifp->if_nextents + delta;
> -		if ((delta > 0 && nr_exts > MAXAEXTNUM)
> -			|| (delta < 0 && nr_exts < 0))
> -			return -EOVERFLOW;
> -
> -		ifp->if_nextents = nr_exts;
> -	} else {
> +	else if (whichfork == XFS_ATTR_FORK)
> +		error = xfs_next_set_attr(tp, ip, ifp, delta);
> +	else
>  		ASSERT(0);
> -	}
>  
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 879aadff7692..db419fc862bc 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -397,7 +397,7 @@ struct xfs_log_dinode {
>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
>  	uint32_t	di_nextents_lo;	/* number of extents in data fork */
> -	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
> +	uint16_t	di_anextents_lo;/* lower part of xattr extent count */
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	int8_t		di_aformat;	/* format of attr fork's data */
>  	uint32_t	di_dmevmask;	/* DMIG event mask */
> @@ -415,7 +415,8 @@ struct xfs_log_dinode {
>  	uint64_t	di_flags2;	/* more random flags */
>  	uint32_t	di_cowextsize;	/* basic cow extent size for file */
>  	uint32_t	di_nextents_hi;
> -	uint8_t		di_pad2[8];	/* more padding for future expansion */
> +	uint16_t	di_anextents_hi;/* higher part of xattr extent count */
> +	uint8_t		di_pad2[6];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
>  	xfs_ictimestamp_t di_crtime;	/* time created */
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index c68ff2178976..974737a9e9c1 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -13,7 +13,7 @@ typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
>  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
>  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
>  typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
> -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> +typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
>  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
>  typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
>  
> @@ -62,7 +62,8 @@ typedef void *		xfs_failaddr_t;
>  #define	MAXEXTNUM31BIT	((xfs_extnum_t)0x7fffffff)	/* 31 bits */
>  #define	MAXEXTNUM	((xfs_extnum_t)0x7fffffffffff)	/* 47 bits */
>  #define	MAXDIREXTNUM	((xfs_extnum_t)0x7ffffff)	/* 27 bits */
> -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> +#define	MAXAEXTNUM15BIT	((xfs_aextnum_t)0x7fff)		/* 15 bits */
> +#define	MAXAEXTNUM	((xfs_aextnum_t)0xffffffff)	/* 32 bits */
>  
>  /*
>   * Minimum and maximum blocksize and sectorsize.
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index be41fd242ff2..01e60c78a3a3 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -371,10 +371,12 @@ xchk_dinode(
>  		break;
>  	}
>  
> +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
> +
>  	/* di_forkoff */
>  	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
>  		xchk_ino_set_corrupt(sc, ino);
> -	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
> +	if (nextents != 0 && dip->di_forkoff == 0)
>  		xchk_ino_set_corrupt(sc, ino);
>  	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
>  		xchk_ino_set_corrupt(sc, ino);
> @@ -386,7 +388,6 @@ xchk_dinode(
>  		xchk_ino_set_corrupt(sc, ino);
>  
>  	/* di_anextents */
> -	nextents = be16_to_cpu(dip->di_anextents);
>  	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
>  	switch (dip->di_aformat) {
>  	case XFS_DINODE_FMT_EXTENTS:
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4418a66cf6d6..6ec34e069344 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3789,6 +3789,10 @@ xfs_iflush_int(
>  		&& xfs_sb_version_has47bitext(&mp->m_sb))
>  		ip->i_d.di_flags2 |= XFS_DIFLAG2_47BIT_NEXTENTS;
>  
> +	if (!(ip->i_d.di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> +		&& xfs_sb_version_has32bitaext(&mp->m_sb))
> +		ip->i_d.di_flags2 |= XFS_DIFLAG2_32BIT_ANEXTENTS;
> +
>  	/*
>  	 * Copy the dirty parts of the inode into the on-disk inode.  We always
>  	 * copy out the core of the inode, because if the inode is dirty at all
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 6f27ac7c8631..40f0a19d1c07 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -327,7 +327,7 @@ xfs_inode_to_log_dinode(
>  	to->di_nblocks = from->di_nblocks;
>  	to->di_extsize = from->di_extsize;
>  	to->di_nextents_lo = xfs_ifork_nextents(&ip->i_df) & 0xffffffffU;
> -	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
> +	to->di_anextents_lo = xfs_ifork_nextents(ip->i_afp) & 0xffffU;
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
>  	to->di_dmevmask = from->di_dmevmask;
> @@ -347,6 +347,9 @@ xfs_inode_to_log_dinode(
>  		if (from->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
>  			to->di_nextents_hi =
>  				xfs_ifork_nextents(&ip->i_df) >> 32;
> +		if (from->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> +			to->di_anextents_hi =
> +				xfs_ifork_nextents(ip->i_afp) >> 16;
>  		to->di_ino = ip->i_ino;
>  		to->di_lsn = lsn;
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 8d64b861fb66..c8b5fbba848b 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -135,6 +135,7 @@ xlog_recover_inode_commit_pass2(
>  	uint				isize;
>  	int				need_free = 0;
>  	xfs_extnum_t			nextents;
> +	xfs_aextnum_t			anextents;
>  
>  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
>  		in_f = item->ri_buf[0].i_addr;
> @@ -262,7 +263,12 @@ xlog_recover_inode_commit_pass2(
>  		ldip->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
>  		nextents |= ((u64)(ldip->di_nextents_hi) << 32);
>  
> -	nextents += ldip->di_anextents;
> +	anextents = ldip->di_anextents_lo;
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> +		ldip->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> +		anextents |= ((u32)(ldip->di_anextents_hi) << 16);
> +
> +	nextents += anextents;
>  
>  	if (unlikely(nextents > ldip->di_nblocks)) {
>  		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
> -- 
> 2.20.1
> 
