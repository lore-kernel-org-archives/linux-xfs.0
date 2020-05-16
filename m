Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F81DC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25545206D4
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wekAfEB/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgEPRun (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 13:50:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgEPRun (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 13:50:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHgwFT022002;
        Sat, 16 May 2020 17:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Kf49YHH/IgJ8aIlkpnC/iM9Y7ahqvak8pjOIVY1w2h8=;
 b=wekAfEB/dxsik3sUf75bSfPt9NKwLHyaY7ZgL3/Wdz0wZnL6DZluPP58A0bFvBgpvGIm
 P3G1vcVsqDNEXKQfYXesoohvCtbjNLXx8IoNq9TZ1mIdnOu/RSbNliAoq4jhNlAFFdQx
 F+RthQw1LEsz03okt3rXan1AQe6PQSwSp8KkMc14t5woFKheIKhsU8COA4fdOxuEG093
 b+RN2RdAMX5g7mDytF7syH8YjUJwhe+ErUiZJ/FqdvKiZBnBdZ17Ke6quV61z8q2c4i2
 YYrbaT4I9i0RIkA1sExhTU+VyhfOQhN65cjp6bYT+tGtb0UqsiChu7bR1KT1eYmaSrZ9 lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127kqsfbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 17:50:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHiD1U027470;
        Sat, 16 May 2020 17:50:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31259rg7g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 17:50:40 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04GHodWk009196;
        Sat, 16 May 2020 17:50:39 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 10:50:39 -0700
Date:   Sat, 16 May 2020 10:50:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/12] xfs: improve local fork verification
Message-ID: <20200516175038.GZ6714@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-11-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 phishscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=5 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:21AM +0200, Christoph Hellwig wrote:
> Call the data/attr local fork verifies as soon as we are ready for them.
> This keeps them close to the code setting up the forks, and avoids a
> few branches later on.  Also open code xfs_inode_verify_forks in the
> only remaining caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.c |  8 +++++++-
>  fs/xfs/xfs_icache.c            |  6 ------
>  fs/xfs/xfs_inode.c             | 28 +++++++++-------------------
>  fs/xfs/xfs_inode.h             |  2 --
>  fs/xfs/xfs_log_recover.c       |  5 -----
>  5 files changed, 16 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 401921975d75b..2fe325e38fd88 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -227,6 +227,7 @@ xfs_iformat_data_fork(
>  	struct xfs_dinode	*dip)
>  {
>  	struct inode		*inode = VFS_I(ip);
> +	int			error;
>  
>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFIFO:
> @@ -241,8 +242,11 @@ xfs_iformat_data_fork(
>  	case S_IFDIR:
>  		switch (dip->di_format) {
>  		case XFS_DINODE_FMT_LOCAL:
> -			return xfs_iformat_local(ip, dip, XFS_DATA_FORK,
> +			error = xfs_iformat_local(ip, dip, XFS_DATA_FORK,
>  					be64_to_cpu(dip->di_size));
> +			if (!error)
> +				error = xfs_ifork_verify_local_data(ip);
> +			return error;
>  		case XFS_DINODE_FMT_EXTENTS:
>  			return xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
>  		case XFS_DINODE_FMT_BTREE:
> @@ -282,6 +286,8 @@ xfs_iformat_attr_fork(
>  	case XFS_DINODE_FMT_LOCAL:
>  		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK,
>  				xfs_dfork_attr_shortform_size(dip));
> +		if (!error)
> +			error = xfs_ifork_verify_local_attr(ip);
>  		break;
>  	case XFS_DINODE_FMT_EXTENTS:
>  		error = xfs_iformat_extents(ip, dip, XFS_ATTR_FORK);
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index af5748f5d9271..5a3a520b95288 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -543,14 +543,8 @@ xfs_iget_cache_miss(
>  			goto out_destroy;
>  	}
>  
> -	if (!xfs_inode_verify_forks(ip)) {
> -		error = -EFSCORRUPTED;
> -		goto out_destroy;
> -	}
> -
>  	trace_xfs_iget_miss(ip);
>  
> -
>  	/*
>  	 * Check the inode free state is valid. This also detects lookup
>  	 * racing with unlinks.
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c8abdefe00377..549ff468b7b60 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3707,23 +3707,6 @@ xfs_iflush(
>  	return error;
>  }
>  
> -/*
> - * If there are inline format data / attr forks attached to this inode,
> - * make sure they're not corrupt.
> - */
> -bool
> -xfs_inode_verify_forks(
> -	struct xfs_inode	*ip)
> -{
> -	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
> -	    xfs_ifork_verify_local_data(ip))
> -		return false;
> -	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL &&
> -	    xfs_ifork_verify_local_attr(ip))
> -		return false;
> -	return true;
> -}
> -
>  STATIC int
>  xfs_iflush_int(
>  	struct xfs_inode	*ip,
> @@ -3808,8 +3791,15 @@ xfs_iflush_int(
>  	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
>  		ip->i_d.di_flushiter++;
>  
> -	/* Check the inline fork data before we write out. */
> -	if (!xfs_inode_verify_forks(ip))
> +	/*
> +	 * If there are inline format data / attr forks attached to this inode,
> +	 * make sure they are not corrupt.
> +	 */
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
> +	    xfs_ifork_verify_local_data(ip))
> +		goto flush_out;
> +	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL &&
> +	    xfs_ifork_verify_local_attr(ip))
>  		goto flush_out;
>  
>  	/*
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 83073c883fbf9..ff846197941e4 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -498,8 +498,6 @@ extern struct kmem_zone	*xfs_inode_zone;
>  /* The default CoW extent size hint. */
>  #define XFS_DEFAULT_COWEXTSZ_HINT 32
>  
> -bool xfs_inode_verify_forks(struct xfs_inode *ip);
> -
>  int xfs_iunlink_init(struct xfs_perag *pag);
>  void xfs_iunlink_destroy(struct xfs_perag *pag);
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 3960caf51c9f7..87b940cb760db 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2878,11 +2878,6 @@ xfs_recover_inode_owner_change(
>  	if (error)
>  		goto out_free_ip;
>  
> -	if (!xfs_inode_verify_forks(ip)) {
> -		error = -EFSCORRUPTED;
> -		goto out_free_ip;
> -	}
> -
>  	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
>  		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);
>  		error = xfs_bmbt_change_owner(NULL, ip, XFS_DATA_FORK,
> -- 
> 2.26.2
> 
