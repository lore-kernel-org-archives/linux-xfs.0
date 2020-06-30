Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A16C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE44720724
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:53:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CrrjIe9h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgF3Rx7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:53:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48862 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgF3Rx7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 13:53:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHqJVI081274;
        Tue, 30 Jun 2020 17:53:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=gOuCTI/u7nLLbevxMjV6aDWjz2dBW/JrIwFpZqZCuHo=;
 b=CrrjIe9hybPYVBcI7TmLbdWnCdUQQW2YU8nP7jukKrGlxf1+KUuHw5++TDF6eW/4lHdp
 KArYVmVPGh4xh6zqsZRa8FS0VUJagctTBDjyi8KXzP++ur0GCVPlSTvqtJeo0JGKlF7K
 c6JG0RxJ69L/3D9iSnu3k+7CfQrTvXZz9iwM7Uwr/bBxXAEkHjN0PMgH/9mS2OxJy+vB
 R4Cj6qH1ImIxJjYIVn2xUvd8bpFcBgIsju+P8T2ea9EuSYesMCZZLmE00JbJnxjZDopE
 WOkIyHwkD78CAz2Fm8WNW0ysDPUTREtuKxSsa7ZXaDlg8w7JNZO4eLZylIteF8Mnp3oI /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31xx1dtwnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 17:53:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHmZEv087786;
        Tue, 30 Jun 2020 17:51:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31xfvst5ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 17:51:55 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UHpsJ1018912;
        Tue, 30 Jun 2020 17:51:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 17:51:54 +0000
Date:   Tue, 30 Jun 2020 10:51:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/15] xfs: use a union for i_cowextsize and i_flushiter
Message-ID: <20200630175153.GE7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620071102.462554-9-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=1 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 07:10:55AM +0000, Christoph Hellwig wrote:
> The i_cowextsize field is only used for v3 inodes, and the i_flushiter
> field is only used for v1/v2 inodes.  Use a union to pack the inode a
> littler better after adding a few missing guards around their usage.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me had previously wondered why it was that _from_disk didn't set the
fields conditionally, but it all looks all right now, so,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 3 ++-
>  fs/xfs/xfs_inode.c            | 6 ++++--
>  fs/xfs/xfs_inode.h            | 7 +++++--
>  fs/xfs/xfs_ioctl.c            | 6 +++++-
>  4 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 03bd7cdd0ddc81..8c4b7bd69285fa 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -205,7 +205,8 @@ xfs_inode_from_disk(
>  	 * inode. If the inode is unused, mode is zero and we shouldn't mess
>  	 * with the unitialized part of it.
>  	 */
> -	ip->i_flushiter = be16_to_cpu(from->di_flushiter);
> +	if (!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb))
> +		ip->i_flushiter = be16_to_cpu(from->di_flushiter);
>  	inode->i_generation = be32_to_cpu(from->di_gen);
>  	inode->i_mode = be16_to_cpu(from->di_mode);
>  	if (!inode->i_mode)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5e0336e0dbae44..fd111e05c0bb2e 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3794,8 +3794,10 @@ xfs_iflush_int(
>  	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
>  
>  	/* Wrap, we never let the log put out DI_MAX_FLUSH */
> -	if (ip->i_flushiter == DI_MAX_FLUSH)
> -		ip->i_flushiter = 0;
> +	if (!xfs_sb_version_has_v3inode(&mp->m_sb)) {
> +		if (ip->i_flushiter == DI_MAX_FLUSH)
> +			ip->i_flushiter = 0;
> +	}
>  
>  	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
>  	if (XFS_IFORK_Q(ip))
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 581618ea1156da..a0444b9ce3f792 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -58,8 +58,11 @@ typedef struct xfs_inode {
>  	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
>  	uint32_t		i_projid;	/* owner's project id */
>  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
> -	xfs_extlen_t		i_cowextsize;	/* basic cow extent size */
> -	uint16_t		i_flushiter;	/* incremented on flush */
> +	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
> +	union {
> +		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
> +		uint16_t	i_flushiter;	/* incremented on flush */
> +	};
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a1937900ad84be..60544dd0f875b8 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1108,7 +1108,11 @@ xfs_fill_fsxattr(
>  
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
>  	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
> -	fa->fsx_cowextsize = ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
> +	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) &&
> +	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)) {
> +		fa->fsx_cowextsize =
> +			ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
> +	}
>  	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
> -- 
> 2.26.2
> 
