Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A969C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6F4320724
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:32:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AP4HdbgA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgCRPcv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 11:32:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39166 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgCRPcv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 11:32:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IFOHwh084944;
        Wed, 18 Mar 2020 15:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jIEg2RG5crk4RywVvK+m108L0LJiavzdaIFVA+wfnfY=;
 b=AP4HdbgA/IOFez7tUrEoaziuCiKPMWqDmAhuqr45EYc1MDXJ0CzbfthjjEyhFZSwv10B
 /Xu5a38kCkFuBB6rV8sKUmPS8QxNnhoN/EzWEd5BmdZYgtgL8d0UH1X090ESHjJPZKze
 Waa2Uxmaerm0Fdbqlr6wiVzfqdI0NVuQimOcx25RaafNdHX9YJwqMXav+3fLYslbWC+1
 uLWP7T1LUQ8Ulr6o+/z1PfJmpEVqMrXSo/CAkjCQN8Q/r5HpxFup2smpxgzao2COpF/B
 Wf93P4kAFXfXI6XNNBMx9AmwAkzcrxqYwBgMr12cPX3K6hADJe8HJ6KsoHkUinEZp94s 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yub2736pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:32:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IFMdpI144145;
        Wed, 18 Mar 2020 15:32:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ys8tu14uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:32:42 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02IFWf5Q006682;
        Wed, 18 Mar 2020 15:32:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Mar 2020 08:32:41 -0700
Date:   Wed, 18 Mar 2020 08:32:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 2/5] xfs: only check the superblock version for dinode
 size calculation
Message-ID: <20200318153240.GA256767@magnolia>
References: <20200317185756.1063268-1-hch@lst.de>
 <20200317185756.1063268-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317185756.1063268-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=2 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003180073
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 suspectscore=2
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180073
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 11:57:53AM -0700, Christoph Hellwig wrote:
> The size of the dinode structure is only dependent on the file system
> version, so instead of checking the individual inode version just use
> the newly added xfs_sb_version_has_large_dinode helper, and simplify
> various calling conventions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

Blergh macros,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c  |  5 ++---
>  fs/xfs/libxfs/xfs_bmap.c       | 10 ++++------
>  fs/xfs/libxfs/xfs_format.h     | 16 ++++++++--------
>  fs/xfs/libxfs/xfs_ialloc.c     |  2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c  |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c |  2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h |  9 ++-------
>  fs/xfs/libxfs/xfs_log_format.h | 10 ++++------
>  fs/xfs/xfs_inode_item.c        |  4 ++--
>  fs/xfs/xfs_log_recover.c       |  2 +-
>  fs/xfs/xfs_symlink.c           |  2 +-
>  11 files changed, 27 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 6eda1828a079..863444e2dda7 100644
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
> index 8057486c02b5..fda13cd7add0 100644
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
> index 19899d48517c..045556e78ee2 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -954,8 +954,12 @@ enum xfs_dinode_fmt {
>  /*
>   * Inode size for given fs.
>   */
> -#define XFS_LITINO(mp, version) \
> -	((int)(((mp)->m_sb.sb_inodesize) - xfs_dinode_size(version)))
> +#define XFS_DINODE_SIZE(sbp) \
> +	(xfs_sb_version_has_v3inode(sbp) ? \
> +		sizeof(struct xfs_dinode) : \
> +		offsetof(struct xfs_dinode, di_crc))
> +#define XFS_LITINO(mp) \
> +	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
>  
>  /*
>   * Inode data & attribute fork sizes, per inode.
> @@ -964,13 +968,9 @@ enum xfs_dinode_fmt {
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
> index 4de61af3b840..7fcf62b324b0 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -339,7 +339,7 @@ xfs_ialloc_inode_init(
>  		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
>  		for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
>  			int	ioffset = i << mp->m_sb.sb_inodelog;
> -			uint	isize = xfs_dinode_size(version);
> +			uint	isize = XFS_DINODE_SIZE(&mp->m_sb);
>  
>  			free = xfs_make_iptr(mp, fbuf, i);
>  			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index c862c8f1aaa9..240d74840306 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -417,7 +417,7 @@ xfs_dinode_verify_forkoff(
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
> index 9bac0d2e56dc..e3400c9c71cd 100644
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
> +	(xfs_sb_version_has_v3inode(&(mp)->m_sb) ?			\
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
> index c467488212c2..308cc5dcac14 100644
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
> -- 
> 2.24.1
> 
