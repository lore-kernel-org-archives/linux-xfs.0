Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3101C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE672206D4
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:51:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O0dmspJx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgEPRvd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 13:51:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50000 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgEPRvd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 13:51:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHh0Zw022018;
        Sat, 16 May 2020 17:51:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=oHtt0TecP+i0fmbH4YLzEkzTj5VVZWF+hBsJ8fbIoZI=;
 b=O0dmspJx37swWqYxVgJyKCXFROB/Gf7YNa8ek5RPQ06S4xewQna2RNOVLzZOgPJvb2fT
 IxMqSubFreD/LGNK2RU03RuNHKUb6xK86NPpLk+7kmDJhy9qObkj8s8swfMAL6RBNdvN
 SlhWLhhIh9jpCgpI6xjbyuqf3QEdp+Ne3HP1ju1muhfUtfk+k0T9JU+2AoaDmHB1VkHU
 i1MZVEZpAjpGvOZJQQwPeEEBuiQ4/i1HAWhqcSOc8S+Pa8NksZ8b8o8bpBFO4SqoK1Fx
 oCNN4QJ8QkaCwjNrJK5NsFZMoEf0nFg2jyfkZ9RpN7IzbjRD9oLhVyjcKuYI4JOowZUR EA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127kqsfd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 17:51:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHiCU1027407;
        Sat, 16 May 2020 17:49:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31259rg5mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 17:49:29 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04GHnSQC028396;
        Sat, 16 May 2020 17:49:28 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 10:49:28 -0700
Date:   Sat, 16 May 2020 10:49:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: refactor xfs_inode_verify_forks
Message-ID: <20200516174927.GY6714@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-10-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:20AM +0200, Christoph Hellwig wrote:
> The split between xfs_inode_verify_forks and the two helpers
> implementing the actual functionality is a little strange.  Reshuffle
> it so that xfs_inode_verify_forks verifies if the data and attr forks
> are actually in local format and only call the low-level helpers if
> that is the case.  Handle the actual error reporting in the low-level
> handlers to streamline the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.c | 51 ++++++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_inode_fork.h |  4 +--
>  fs/xfs/xfs_inode.c             | 21 +++-----------
>  3 files changed, 40 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index e346e143f1053..401921975d75b 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -674,34 +674,51 @@ xfs_ifork_init_cow(
>  }
>  
>  /* Verify the inline contents of the data fork of an inode. */
> -xfs_failaddr_t
> -xfs_ifork_verify_data(
> +int
> +xfs_ifork_verify_local_data(
>  	struct xfs_inode	*ip)
>  {
> -	/* Non-local data fork, we're done. */
> -	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> -		return NULL;
> +	xfs_failaddr_t		fa = NULL;
>  
> -	/* Check the inline data fork if there is one. */
>  	switch (VFS_I(ip)->i_mode & S_IFMT) {
>  	case S_IFDIR:
> -		return xfs_dir2_sf_verify(ip);
> +		fa = xfs_dir2_sf_verify(ip);
> +		break;
>  	case S_IFLNK:
> -		return xfs_symlink_shortform_verify(ip);
> +		fa = xfs_symlink_shortform_verify(ip);
> +		break;
>  	default:
> -		return NULL;
> +		break;
>  	}
> +
> +	if (fa) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> +			ip->i_df.if_u1.if_data, ip->i_df.if_bytes, fa);

Needs more indent, but I could fix this on merge...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> +		return -EFSCORRUPTED;
> +	}
> +
> +	return 0;
>  }
>  
>  /* Verify the inline contents of the attr fork of an inode. */
> -xfs_failaddr_t
> -xfs_ifork_verify_attr(
> +int
> +xfs_ifork_verify_local_attr(
>  	struct xfs_inode	*ip)
>  {
> -	/* There has to be an attr fork allocated if aformat is local. */
> -	if (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
> -		return NULL;
> -	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
> -		return __this_address;
> -	return xfs_attr_shortform_verify(ip);
> +	struct xfs_ifork	*ifp = ip->i_afp;
> +	xfs_failaddr_t		fa;
> +
> +	if (!ifp)
> +		fa = __this_address;
> +	else
> +		fa = xfs_attr_shortform_verify(ip);
> +
> +	if (fa) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> +			ifp ? ifp->if_u1.if_data : NULL,
> +			ifp ? ifp->if_bytes : 0, fa);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 3f84d33abd3b7..f46a8c1db5964 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -176,7 +176,7 @@ extern struct kmem_zone	*xfs_ifork_zone;
>  
>  extern void xfs_ifork_init_cow(struct xfs_inode *ip);
>  
> -xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip);
> -xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip);
> +int xfs_ifork_verify_local_data(struct xfs_inode *ip);
> +int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
>  
>  #endif	/* __XFS_INODE_FORK_H__ */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 25c00ffe18409..c8abdefe00377 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3715,25 +3715,12 @@ bool
>  xfs_inode_verify_forks(
>  	struct xfs_inode	*ip)
>  {
> -	struct xfs_ifork	*ifp;
> -	xfs_failaddr_t		fa;
> -
> -	fa = xfs_ifork_verify_data(ip);
> -	if (fa) {
> -		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> -				ifp->if_u1.if_data, ifp->if_bytes, fa);
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
> +	    xfs_ifork_verify_local_data(ip))
>  		return false;
> -	}
> -
> -	fa = xfs_ifork_verify_attr(ip);
> -	if (fa) {
> -		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> -				ifp ? ifp->if_u1.if_data : NULL,
> -				ifp ? ifp->if_bytes : 0, fa);
> +	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL &&
> +	    xfs_ifork_verify_local_attr(ip))
>  		return false;
> -	}
>  	return true;
>  }
>  
> -- 
> 2.26.2
> 
