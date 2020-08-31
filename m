Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA59C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F65206CD
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:12:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NgEXCel8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgHaQMd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:12:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53522 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgHaQMc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:12:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGBRCb002020;
        Mon, 31 Aug 2020 16:12:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0jiErmvWoSgrjpTOBFutjQwZBGmCMtApRVECJQBtzaA=;
 b=NgEXCel8mseqXCcuR/HJSpZAVsBmaeXtObS5AivD/8u3rDAK8Kx81x4uci8jwse4y3Iq
 rHhwXhtRZgU03j8JwIb5EeJWR418az1A8q8LuGkRui4sWAPc5abBh7dpzRx00gzmIHSp
 1aSA/7JehzfjTkYkVsbj7FFY/px0JuHR7Ii5Z0p6RtUAbLGoOfNNqOB4BtQDhr6O1S5R
 xppPpfD5qsC6jES73MMNoM6o5AKp7qBJPPYfsxncUd8Gw1g3kYbhKSMpaqFoD9AhQfvw
 HOOnXn3IlDMqcU8V7YDFP2RqZW8Z9biF9fHBiesHab0WsgLVbu2YmmjGwST04ez9q5me tQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eyky4bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 16:12:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VG0vvQ011173;
        Mon, 31 Aug 2020 16:12:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3380sq7f0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:12:26 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VGCPIL018845;
        Mon, 31 Aug 2020 16:12:25 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 09:12:25 -0700
Date:   Mon, 31 Aug 2020 09:12:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 02/10] xfs: Check for extent overflow when trivally
 adding a new extent
Message-ID: <20200831161228.GH6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
 <20200820054349.5525-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820054349.5525-3-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310096
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 11:13:41AM +0530, Chandan Babu R wrote:
> When adding a new data extent (without modifying an inode's existing
> extents) the extent count increases only by 1. This commit checks for
> extent count overflow in such cases.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Seems fine to me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 6 ++++++
>  fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
>  fs/xfs/xfs_bmap_util.c         | 5 +++++
>  fs/xfs/xfs_dquot.c             | 8 +++++++-
>  fs/xfs/xfs_iomap.c             | 5 +++++
>  fs/xfs/xfs_rtalloc.c           | 5 +++++
>  6 files changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9c40d5971035..dcc8eeecd571 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4527,6 +4527,12 @@ xfs_bmapi_convert_delalloc(
>  		return error;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +	error = xfs_iext_count_may_overflow(ip, whichfork,
> +			XFS_IEXT_ADD_NOSPLIT_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	xfs_trans_ijoin(tp, ip, 0);
>  
>  	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 0beb8e2a00be..7fc2b129a2e7 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -34,6 +34,12 @@ struct xfs_ifork {
>  #define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
>  #define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
>  
> +/*
> + * Worst-case increase in the fork extent count when we're adding a single
> + * extent to a fork and there's no possibility of splitting an existing mapping.
> + */
> +#define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
> +
>  /*
>   * Fork handling.
>   */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index afdc7f8e0e70..7b76a48b0885 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -822,6 +822,11 @@ xfs_alloc_file_space(
>  		if (error)
>  			goto error1;
>  
> +		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +				XFS_IEXT_ADD_NOSPLIT_CNT);
> +		if (error)
> +			goto error0;
> +
>  		xfs_trans_ijoin(tp, ip, 0);
>  
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 04dc2be19c3a..59ea9485ebda 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -290,8 +290,14 @@ xfs_dquot_disk_alloc(
>  		return -ESRCH;
>  	}
>  
> -	/* Create the block mapping. */
>  	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
> +
> +	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
> +			XFS_IEXT_ADD_NOSPLIT_CNT);
> +	if (error)
> +		return error;
> +
> +	/* Create the block mapping. */
>  	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
>  			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
>  			&nmaps);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 0e3f62cde375..37b0c743c116 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -250,6 +250,11 @@ xfs_iomap_write_direct(
>  	if (error)
>  		goto out_trans_cancel;
>  
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_ADD_NOSPLIT_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	xfs_trans_ijoin(tp, ip, 0);
>  
>  	/*
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 6209e7b6b895..9508ab00a00b 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -787,6 +787,11 @@ xfs_growfs_rt_alloc(
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> +		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +				XFS_IEXT_ADD_NOSPLIT_CNT);
> +		if (error)
> +			goto out_trans_cancel;
> +
>  		/*
>  		 * Allocate blocks to the bitmap file.
>  		 */
> -- 
> 2.28.0
> 
