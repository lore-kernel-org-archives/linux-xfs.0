Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8C1C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ACBB20738
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:33:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h04UepOA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgFCAdL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 20:33:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52880 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFCAdL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 20:33:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0530Ml8Z005199;
        Wed, 3 Jun 2020 00:33:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=QID2azdx6pZFJy6mq+wDhI23j7s5G3jraZ5w34TqjQg=;
 b=h04UepOAiU11/Zg2SwjjVEzSK9p0NJSeY0pWWoGCh7H4fPXbRCoj9wqzh+CQ8IGjJSfV
 6kwWCk0tTFeyCp5aF1h8zpErzdT5vgnL37fwiiLg6i8TcMUT9AJAtY/o30/tYAAV8d1y
 /ud6bVmwueTXnrRjM3Lbf3dQ6nrgd9FCGKBUsp/S2Ub9v/OE7jbXUmGUZn6gBvaKKekb
 M8gsbdtR5B27+3MvhJPa5AvnH+uJnWRWS4SR1zCyA14M/bmvOYXHTpBa9Rz4WFBjf2fs
 0lWx5tQIE0+0N+b+lMzVnFdJXYvW1ku6OwExQJACtiqsDxD0ltORZCdovtU6sRWR1NRI Ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31bfem6hu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 00:33:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0530JH5T092040;
        Wed, 3 Jun 2020 00:33:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31c1dy4c6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 00:33:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0530X6Dd004399;
        Wed, 3 Jun 2020 00:33:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 17:33:05 -0700
Date:   Tue, 2 Jun 2020 17:33:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/14] xfs: use a union for i_cowextsize and i_flushiter
Message-ID: <20200603003305.GW8230@magnolia>
References: <20200524091757.128995-1-hch@lst.de>
 <20200524091757.128995-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524091757.128995-9-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=1 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 24, 2020 at 11:17:51AM +0200, Christoph Hellwig wrote:
> The i_cowextsize field is only used for v3 inodes, and the i_flushiter
> field is only used for v1/v2 inodes.  Use a union to pack the inode a
> littler better after adding a few missing guards around their usage.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 3 ++-
>  fs/xfs/xfs_inode.c            | 6 ++++--
>  fs/xfs/xfs_inode.h            | 7 +++++--
>  fs/xfs/xfs_ioctl.c            | 6 +++++-
>  4 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 03bd7cdd0ddc8..8c4b7bd69285f 100644
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
> index 805f63fb3c8b4..dff853a7ed0c3 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3792,8 +3792,10 @@ xfs_iflush_int(
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
> index 91259403ba741..59f7341ece285 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -58,8 +58,11 @@ typedef struct xfs_inode {
>  	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
>  	uint32_t		i_projid;	/* owner's project id */
>  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
> -	uint32_t		i_cowextsize;	/* basic cow extent size */
> -	uint16_t		i_flushiter;	/* incremented on flush */
> +	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
> +	union {
> +		uint32_t	i_cowextsize;	/* basic cow extent size */
> +		uint16_t	i_flushiter;	/* incremented on flush */
> +	};
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a9b31ae3c28c0..18ea8b76c7d53 100644
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

Could you turn these into XFS_FSB_TO_B() while you're at it?

--D

> +	}
>  	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
> -- 
> 2.26.2
> 
