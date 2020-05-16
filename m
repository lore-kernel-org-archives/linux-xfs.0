Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80118C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 00:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 535CB2065C
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 00:22:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QWaWIOda"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgEPAWZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 20:22:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35148 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgEPAWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 20:22:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04G0Dwtd108589;
        Sat, 16 May 2020 00:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=x2ONmlydyzrL+TQFGBKQeAWkFM4YDnMP6VZtxd37uoM=;
 b=QWaWIOdaguPL+gmQiyQeUD5paAGOfrx+y5UlTnhxTPI6yh2TopiRYwIIEEB+bVc1Sw8t
 fnc0vqdlE5HgsWj4FpWPXv1SkuMCuO0CdZl0FE7kPI3FHwWFagxlM1CjF/GNxgD7P/nE
 B/oSBFPlpGijPGrKBxgIPWV9H3v//6W0yDSqrFwG8B2bRMPnHz8cH7TuaFJAIDPjdShJ
 /hsLnw2AJuQEs/34MDAMlPImJ5rK7PfshLtGva8Xvvvct6gGg/q22uyyTPzCN/oCOq2D
 ptHKwltbZLmqPYIgDvxqBYNy2wTR1BYcYdEyTCJD3JG6TRyWlRxlX6upA+jbt776c84T Gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 311nu5pjd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 00:22:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04G0IC4h132800;
        Sat, 16 May 2020 00:22:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3100yfq2a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 00:22:19 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04G0MIoU004532;
        Sat, 16 May 2020 00:22:18 GMT
Received: from localhost (/10.159.241.121)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 17:22:18 -0700
Date:   Fri, 15 May 2020 17:22:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: split xfs_iformat_fork
Message-ID: <20200516002217.GS6714@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-4-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=5 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005160000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9622 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 suspectscore=5 spamscore=0 lowpriorityscore=0 cotscore=-2147483648
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150203
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:14AM +0200, Christoph Hellwig wrote:
> xfs_iformat_fork is a weird catchall.  Split it into one helper for
> the data fork and one for the attr fork, and then call both helper
> as well as the COW fork initialization from xfs_inode_from_disk.  Order
> the COW fork initialization after the attr fork initialization given
> that it can't fail to simplify the error handling.
> 
> Note that the newly split helpers are moved down the file in
> xfs_inode_fork.c to avoid the need for forward declarations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c  |  20 +++-
>  fs/xfs/libxfs/xfs_inode_fork.c | 186 +++++++++++++++------------------
>  fs/xfs/libxfs/xfs_inode_fork.h |   3 +-
>  3 files changed, 103 insertions(+), 106 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index dc00ce6fc4a2f..abdecc80579e3 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -187,6 +187,10 @@ xfs_inode_from_disk(
>  {
>  	struct xfs_icdinode	*to = &ip->i_d;
>  	struct inode		*inode = VFS_I(ip);
> +	int			error;
> +
> +	ASSERT(ip->i_cowfp == NULL);
> +	ASSERT(ip->i_afp == NULL);
>  
>  	/*
>  	 * Convert v1 inodes immediately to v2 inode format as this is the
> @@ -242,7 +246,21 @@ xfs_inode_from_disk(
>  		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
>  	}
>  
> -	return xfs_iformat_fork(ip, from);
> +	error = xfs_iformat_data_fork(ip, from);
> +	if (error)
> +		return error;
> +	if (XFS_DFORK_Q(from)) {
> +		error = xfs_iformat_attr_fork(ip, from);
> +		if (error)
> +			goto out_destroy_data_fork;
> +	}
> +	if (xfs_is_reflink_inode(ip))
> +		xfs_ifork_init_cow(ip);
> +	return 0;
> +
> +out_destroy_data_fork:
> +	xfs_idestroy_fork(ip, XFS_DATA_FORK);
> +	return error;
>  }
>  
>  void
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 3e9a42f1e23b9..5fadfa9a17eb9 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -26,110 +26,6 @@
>  
>  kmem_zone_t *xfs_ifork_zone;
>  
> -STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
> -STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
> -STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
> -
> -/*
> - * Copy inode type and data and attr format specific information from the
> - * on-disk inode to the in-core inode and fork structures.  For fifos, devices,
> - * and sockets this means set i_rdev to the proper value.  For files,
> - * directories, and symlinks this means to bring in the in-line data or extent
> - * pointers as well as the attribute fork.  For a fork in B-tree format, only
> - * the root is immediately brought in-core.  The rest will be read in later when
> - * first referenced (see xfs_iread_extents()).
> - */
> -int
> -xfs_iformat_fork(
> -	struct xfs_inode	*ip,
> -	struct xfs_dinode	*dip)
> -{
> -	struct inode		*inode = VFS_I(ip);
> -	struct xfs_attr_shortform *atp;
> -	int			size;
> -	int			error = 0;
> -	xfs_fsize_t             di_size;
> -
> -	switch (inode->i_mode & S_IFMT) {
> -	case S_IFIFO:
> -	case S_IFCHR:
> -	case S_IFBLK:
> -	case S_IFSOCK:
> -		ip->i_d.di_size = 0;
> -		inode->i_rdev = xfs_to_linux_dev_t(xfs_dinode_get_rdev(dip));
> -		break;
> -
> -	case S_IFREG:
> -	case S_IFLNK:
> -	case S_IFDIR:
> -		switch (dip->di_format) {
> -		case XFS_DINODE_FMT_LOCAL:
> -			di_size = be64_to_cpu(dip->di_size);
> -			size = (int)di_size;
> -			error = xfs_iformat_local(ip, dip, XFS_DATA_FORK, size);
> -			break;
> -		case XFS_DINODE_FMT_EXTENTS:
> -			error = xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
> -			break;
> -		case XFS_DINODE_FMT_BTREE:
> -			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
> -			break;
> -		default:
> -			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> -					dip, sizeof(*dip), __this_address);
> -			return -EFSCORRUPTED;
> -		}
> -		break;
> -
> -	default:
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> -				sizeof(*dip), __this_address);
> -		return -EFSCORRUPTED;
> -	}
> -	if (error)
> -		return error;
> -
> -	if (xfs_is_reflink_inode(ip)) {
> -		ASSERT(ip->i_cowfp == NULL);
> -		xfs_ifork_init_cow(ip);
> -	}
> -
> -	if (!XFS_DFORK_Q(dip))
> -		return 0;
> -
> -	ASSERT(ip->i_afp == NULL);
> -	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
> -
> -	switch (dip->di_aformat) {
> -	case XFS_DINODE_FMT_LOCAL:
> -		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
> -		size = be16_to_cpu(atp->hdr.totsize);
> -
> -		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);
> -		break;
> -	case XFS_DINODE_FMT_EXTENTS:
> -		error = xfs_iformat_extents(ip, dip, XFS_ATTR_FORK);
> -		break;
> -	case XFS_DINODE_FMT_BTREE:
> -		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
> -		break;
> -	default:
> -		xfs_inode_verifier_error(ip, error, __func__, dip,
> -				sizeof(*dip), __this_address);
> -		error = -EFSCORRUPTED;
> -		break;
> -	}
> -	if (error) {
> -		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
> -		ip->i_afp = NULL;
> -		if (ip->i_cowfp)
> -			kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
> -		ip->i_cowfp = NULL;
> -		xfs_idestroy_fork(ip, XFS_DATA_FORK);
> -	}
> -	return error;
> -}
> -
>  void
>  xfs_init_local_fork(
>  	struct xfs_inode	*ip,
> @@ -325,6 +221,88 @@ xfs_iformat_btree(
>  	return 0;
>  }
>  
> +int
> +xfs_iformat_data_fork(
> +	struct xfs_inode	*ip,
> +	struct xfs_dinode	*dip)
> +{
> +	struct inode		*inode = VFS_I(ip);
> +
> +	switch (inode->i_mode & S_IFMT) {
> +	case S_IFIFO:
> +	case S_IFCHR:
> +	case S_IFBLK:
> +	case S_IFSOCK:
> +		ip->i_d.di_size = 0;
> +		inode->i_rdev = xfs_to_linux_dev_t(xfs_dinode_get_rdev(dip));
> +		return 0;
> +	case S_IFREG:
> +	case S_IFLNK:
> +	case S_IFDIR:
> +		switch (dip->di_format) {
> +		case XFS_DINODE_FMT_LOCAL:
> +			return xfs_iformat_local(ip, dip, XFS_DATA_FORK,
> +					be64_to_cpu(dip->di_size));
> +		case XFS_DINODE_FMT_EXTENTS:
> +			return xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
> +		case XFS_DINODE_FMT_BTREE:
> +			return xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
> +		default:
> +			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> +					dip, sizeof(*dip), __this_address);
> +			return -EFSCORRUPTED;
> +		}
> +		break;
> +	default:
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> +				sizeof(*dip), __this_address);
> +		return -EFSCORRUPTED;
> +	}
> +}
> +
> +static uint16_t
> +xfs_dfork_attr_shortform_size(
> +	struct xfs_dinode		*dip)
> +{
> +	struct xfs_attr_shortform	*atp =
> +		(struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
> +
> +	return be16_to_cpu(atp->hdr.totsize);
> +}
> +
> +int
> +xfs_iformat_attr_fork(
> +	struct xfs_inode	*ip,
> +	struct xfs_dinode	*dip)
> +{
> +	int			error = 0;
> +
> +	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
> +	switch (dip->di_aformat) {
> +	case XFS_DINODE_FMT_LOCAL:
> +		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK,
> +				xfs_dfork_attr_shortform_size(dip));
> +		break;
> +	case XFS_DINODE_FMT_EXTENTS:
> +		error = xfs_iformat_extents(ip, dip, XFS_ATTR_FORK);
> +		break;
> +	case XFS_DINODE_FMT_BTREE:
> +		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
> +		break;
> +	default:
> +		xfs_inode_verifier_error(ip, error, __func__, dip,
> +				sizeof(*dip), __this_address);
> +		error = -EFSCORRUPTED;
> +		break;
> +	}
> +
> +	if (error) {
> +		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
> +		ip->i_afp = NULL;
> +	}
> +	return error;
> +}
> +
>  /*
>   * Reallocate the space for if_broot based on the number of records
>   * being added or deleted as indicated in rec_diff.  Move the records
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 668ee942be224..8487b0c88a75e 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -88,7 +88,8 @@ struct xfs_ifork {
>  
>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>  
> -int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
> +int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
> +int		xfs_iformat_attr_fork(struct xfs_inode *, struct xfs_dinode *);
>  void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
>  				struct xfs_inode_log_item *, int);
>  void		xfs_idestroy_fork(struct xfs_inode *, int);
> -- 
> 2.26.2
> 
