Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54205C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F321A208C3
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:20:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="z7ZtQVdt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgJFEUW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:20:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48564 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgJFEUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:20:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964KKU8137081;
        Tue, 6 Oct 2020 04:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fhUCc2NtC9srqfJy/fezkhje5QUEpyKhAXDDd+NIP0U=;
 b=z7ZtQVdtMfLZo+Rr467QyFNVPBiMbx6QU+FdghVSHsmPJax9dYdGdTjtJ6ByiIaRGO5p
 ARoXqYNgnt2lM2g5xGttjZyHw8q/+9W2up9P8ymFKmj7pRZLZd9OG4picEk1PCd/PUbb
 MUUInNYEyKwc7QjiE1q4sgo66t2NXELQO+kDjapYJPEWgmjA7vh986Xefs0oKNWUvWsG
 Hl0lWaiYn7XzfzRkeovnuLKawvPHlAV8Qd70GdrwaHm4sx+gOXOOpBGsRwtE/NP7z4wn
 IPliiwkM0WcgUsW254nUqmqAA/YFWoGB3FRf+fwLarM8gZrrH6Y8oIYtpMZy7tO9SMyl 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33ym34euvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:20:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964A7Uc041369;
        Tue, 6 Oct 2020 04:18:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33y37wahdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:18:19 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0964IHj1015172;
        Tue, 6 Oct 2020 04:18:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:18:17 -0700
Date:   Mon, 5 Oct 2020 21:18:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 02/12] xfs: Check for extent overflow when trivally
 adding a new extent
Message-ID: <20201006041815.GL49547@magnolia>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
 <20201003055633.9379-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003055633.9379-3-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=2 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=2 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060024
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 03, 2020 at 11:26:23AM +0530, Chandan Babu R wrote:
> When adding a new data extent (without modifying an inode's existing
> extents) the extent count increases only by 1. This commit checks for
> extent count overflow in such cases.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 6 ++++++
>  fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
>  fs/xfs/xfs_bmap_item.c         | 7 +++++++
>  fs/xfs/xfs_bmap_util.c         | 5 +++++
>  fs/xfs/xfs_dquot.c             | 8 +++++++-
>  fs/xfs/xfs_iomap.c             | 5 +++++
>  fs/xfs/xfs_rtalloc.c           | 5 +++++
>  7 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1b0a01b06a05..51c2d2690f05 100644
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
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ec3691372e7c..6a7dcea4ad40 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -519,6 +519,13 @@ xfs_bui_item_recover(
>  	}
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	if (bui_type == XFS_BMAP_MAP) {
> +		error = xfs_iext_count_may_overflow(ip, whichfork,
> +				XFS_IEXT_ADD_NOSPLIT_CNT);
> +		if (error)
> +			goto err_inode;
> +	}
> +
>  	count = bmap->me_len;
>  	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
>  			bmap->me_startoff, bmap->me_startblock, &count, state);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f2a8a0e75e1f..dcd6e61df711 100644
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
> index 3072814e407d..5bf22d2e50cb 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -314,8 +314,14 @@ xfs_dquot_disk_alloc(
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
> index 3abb8b9d6f4c..a302a96823b8 100644
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
> index 9d4e33d70d2a..3e841a75f272 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -804,6 +804,11 @@ xfs_growfs_rt_alloc(
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
