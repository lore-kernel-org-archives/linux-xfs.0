Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29259C18E5B
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA46320663
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 14:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731551AbgCPOoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 10:44:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37574 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731555AbgCPOoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 10:44:54 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GEZOhw192559
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 10:44:53 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ytb4t8trc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2020 10:44:52 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Mon, 16 Mar 2020 14:44:51 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 16 Mar 2020 14:44:48 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02GEim0A45613538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 14:44:48 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2BFBAE055;
        Mon, 16 Mar 2020 14:44:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26669AE051;
        Mon, 16 Mar 2020 14:44:47 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.73.127])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Mar 2020 14:44:46 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: only check the superblock version for dinode size calculation
Date:   Mon, 16 Mar 2020 20:17:47 +0530
Organization: IBM
In-Reply-To: <20200312142235.550766-3-hch@lst.de>
References: <20200312142235.550766-1-hch@lst.de> <20200312142235.550766-3-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20031614-4275-0000-0000-000003AD4254
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031614-4276-0000-0000-000038C26882
Message-Id: <2587660.TbEoGhrBLE@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-16_03:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=5 malwarescore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160068
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thursday, March 12, 2020 7:52 PM Christoph Hellwig wrote: 
> The size of the dinode structure is only dependent on the file system
> version, so instead of checking the individual inode version just use
> the newly added xfs_sb_version_has_large_dinode helper, and simplify
> various calling conventions.
>

I don't see any logical issues.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  5 ++---
>  fs/xfs/libxfs/xfs_bmap.c       | 10 ++++------
>  fs/xfs/libxfs/xfs_format.h     | 15 +++++++--------
>  fs/xfs/libxfs/xfs_ialloc.c     |  2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c  |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h |  9 ++-------
>  fs/xfs/libxfs/xfs_log_format.h | 10 ++++------
>  fs/xfs/xfs_inode_item.c        |  4 ++--
>  fs/xfs/xfs_log_recover.c       |  2 +-
>  fs/xfs/xfs_symlink.c           |  2 +-
>  11 files changed, 26 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 4be04aeee278..a4757e5e64ca 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -537,7 +537,7 @@ xfs_attr_shortform_bytesfit(
>  	int			offset;
>  
>  	/* rounded down */
> -	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
> +	offset = (XFS_LITINO(mp) - bytes) >> 3;
>  
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_DEV) {
>  		minforkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
> @@ -604,8 +604,7 @@ xfs_attr_shortform_bytesfit(
>  	minforkoff = roundup(minforkoff, 8) >> 3;
>  
>  	/* attr fork btree root can have at least this many key/ptr pairs */
> -	maxforkoff = XFS_LITINO(mp, dp->i_d.di_version) -
> -			XFS_BMDR_SPACE_CALC(MINABTPTRS);
> +	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
>  	maxforkoff = maxforkoff >> 3;	/* rounded down */
>  
>  	if (offset >= maxforkoff)
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 43ae2ab21084..a2fe8a585100 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -193,14 +193,12 @@ xfs_default_attroffset(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	uint			offset;
>  
> -	if (mp->m_sb.sb_inodesize == 256) {
> -		offset = XFS_LITINO(mp, ip->i_d.di_version) -
> -				XFS_BMDR_SPACE_CALC(MINABTPTRS);
> -	} else {
> +	if (mp->m_sb.sb_inodesize == 256)
> +		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
> +	else
>  		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
> -	}
>  
> -	ASSERT(offset < XFS_LITINO(mp, ip->i_d.di_version));
> +	ASSERT(offset < XFS_LITINO(mp));
>  	return offset;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index a28bf6a978ad..aeca184d63ee 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -942,8 +942,11 @@ enum xfs_dinode_fmt {
>  /*
>   * Inode size for given fs.
>   */
> -#define XFS_LITINO(mp, version) \
> -	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
> +#define XFS_DINODE_SIZE(mp) \
> +       (xfs_sb_version_has_large_dinode(&(mp)->m_sb) ? \
> +        sizeof(struct xfs_dinode) : offsetof(struct xfs_dinode, di_crc))
> +#define XFS_LITINO(mp) \
> +	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(mp))
>  
>  /*
>   * Inode data & attribute fork sizes, per inode.
> @@ -952,13 +955,9 @@ enum xfs_dinode_fmt {
>  #define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
>  
>  #define XFS_DFORK_DSIZE(dip,mp) \
> -	(XFS_DFORK_Q(dip) ? \
> -		XFS_DFORK_BOFF(dip) : \
> -		XFS_LITINO(mp, (dip)->di_version))
> +	(XFS_DFORK_Q(dip) ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
>  #define XFS_DFORK_ASIZE(dip,mp) \
> -	(XFS_DFORK_Q(dip) ? \
> -		XFS_LITINO(mp, (dip)->di_version) - XFS_DFORK_BOFF(dip) : \
> -		0)
> +	(XFS_DFORK_Q(dip) ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
>  #define XFS_DFORK_SIZE(dip,mp,w) \
>  	((w) == XFS_DATA_FORK ? \
>  		XFS_DFORK_DSIZE(dip, mp) : \
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 6adffaa68fb8..26de817351fa 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -339,7 +339,7 @@ xfs_ialloc_inode_init(
>  		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
>  		for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
>  			int	ioffset = i << mp->m_sb.sb_inodelog;
> -			uint	isize = xfs_dinode_size(version);
> +			uint	isize = XFS_DINODE_SIZE(mp);
>  
>  			free = xfs_make_iptr(mp, fbuf, i);
>  			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index a5aa2f220c28..34ccf162abe1 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -432,7 +432,7 @@ xfs_dinode_verify_forkoff(
>  	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
>  	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
>  	case XFS_DINODE_FMT_BTREE:
> -		if (dip->di_forkoff >= (XFS_LITINO(mp, dip->di_version) >> 3))
> +		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
>  			return __this_address;
>  		break;
>  	default:
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index ad2b9c313fd2..518c6f0ec3a6 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -183,7 +183,7 @@ xfs_iformat_local(
>  	 */
>  	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
>  		xfs_warn(ip->i_mount,
> -	"corrupt inode %Lu (bad size %d for local fork, size = %d).",
> +	"corrupt inode %Lu (bad size %d for local fork, size = %zd).",
>  			(unsigned long long) ip->i_ino, size,
>  			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 500333d0101e..668ee942be22 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -46,14 +46,9 @@ struct xfs_ifork {
>  			(ip)->i_afp : \
>  			(ip)->i_cowfp))
>  #define XFS_IFORK_DSIZE(ip) \
> -	(XFS_IFORK_Q(ip) ? \
> -		XFS_IFORK_BOFF(ip) : \
> -		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version))
> +	(XFS_IFORK_Q(ip) ? XFS_IFORK_BOFF(ip) : XFS_LITINO((ip)->i_mount))
>  #define XFS_IFORK_ASIZE(ip) \
> -	(XFS_IFORK_Q(ip) ? \
> -		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version) - \
> -			XFS_IFORK_BOFF(ip) : \
> -		0)
> +	(XFS_IFORK_Q(ip) ? XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : 0)
>  #define XFS_IFORK_SIZE(ip,w) \
>  	((w) == XFS_DATA_FORK ? \
>  		XFS_IFORK_DSIZE(ip) : \
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 9bac0d2e56dc..76defbea8000 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -424,12 +424,10 @@ struct xfs_log_dinode {
>  	/* structure must be padded to 64 bit alignment */
>  };
>  
> -static inline uint xfs_log_dinode_size(int version)
> -{
> -	if (version == 3)
> -		return sizeof(struct xfs_log_dinode);
> -	return offsetof(struct xfs_log_dinode, di_next_unlinked);
> -}
> +#define xfs_log_dinode_size(mp)						\
> +	(xfs_sb_version_has_large_dinode(&(mp)->m_sb) ?				\
> +		sizeof(struct xfs_log_dinode) :				\
> +		offsetof(struct xfs_log_dinode, di_next_unlinked))
>  
>  /*
>   * Buffer Log Format definitions
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index f021b55a0301..451f9b6b2806 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -125,7 +125,7 @@ xfs_inode_item_size(
>  
>  	*nvecs += 2;
>  	*nbytes += sizeof(struct xfs_inode_log_format) +
> -		   xfs_log_dinode_size(ip->i_d.di_version);
> +		   xfs_log_dinode_size(ip->i_mount);
>  
>  	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
>  	if (XFS_IFORK_Q(ip))
> @@ -370,7 +370,7 @@ xfs_inode_item_format_core(
>  
>  	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
>  	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
> -	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
> +	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_mount));
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e5e976b5cc11..79fc85a4ff08 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3068,7 +3068,7 @@ xlog_recover_inode_pass2(
>  		error = -EFSCORRUPTED;
>  		goto out_release;
>  	}
> -	isize = xfs_log_dinode_size(ldip->di_version);
> +	isize = xfs_log_dinode_size(mp);
>  	if (unlikely(item->ri_buf[1].i_len > isize)) {
>  		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
>  				     XFS_ERRLEVEL_LOW, mp, ldip,
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index ea42e25ec1bf..fa0fa3c70f1a 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -192,7 +192,7 @@ xfs_symlink(
>  	 * The symlink will fit into the inode data fork?
>  	 * There can't be any attributes so we get the whole variable part.
>  	 */
> -	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
> +	if (pathlen <= XFS_LITINO(mp))
>  		fs_blocks = 0;
>  	else
>  		fs_blocks = xfs_symlink_blocks(mp, pathlen);
> 


-- 
chandan



