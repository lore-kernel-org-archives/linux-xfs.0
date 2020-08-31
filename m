Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906ACC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D61A2073A
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:25:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o54ck01N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgHaQZi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:25:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728491AbgHaQZh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:25:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGO4Bc025297;
        Mon, 31 Aug 2020 16:25:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9PcggNY6K4D0YCgFAppCpcYLfu8hhSL0nJA2t4pOzNY=;
 b=o54ck01Ne90gFjOmxvrp8SiJPv3CuKsNHHXbVf+HYhP28e0FJdlYskRQUUp2biQu/dou
 DzM5JFpyIErGuTqucw0aTqopucau7hrTTCGzumrahrsIx+S5poiIJbPgR0lCBhpaT347
 0vWRe1rjXBcR25/B2NKamtWVq48PGYtYFDcixkIpJRvQdn//bdCRfCrJRcTV0M4doRO6
 8HKdKGLiYuK4H6xiudOvrksw9C6ejnVj6p9ArUK6hwPIo31Qj4EKhfEwr3WVccbp+9tb
 3MnGhj5XQIfrOaIcfy+4SqpAGzklxiVk7plogbJ3Nlvdm3OtvnOFf5A4hFrsDQ3EYPFS AA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 337eyky6f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 16:25:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGLAQl158553;
        Mon, 31 Aug 2020 16:23:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3380kkv26p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:23:33 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VGNW14023788;
        Mon, 31 Aug 2020 16:23:32 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 09:23:31 -0700
Date:   Mon, 31 Aug 2020 09:23:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 09/10] xfs: Check for extent overflow when remapping
 an extent
Message-ID: <20200831162335.GJ6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
 <20200820054349.5525-10-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820054349.5525-10-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310098
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 11:13:48AM +0530, Chandan Babu R wrote:
> Remapping an extent involves unmapping the existing extent and mapping
> in the new extent. When unmapping, an extent containing the entire unmap
> range can be split into two extents,
> i.e. | Old extent | hole | Old extent |
> Hence extent count increases by 1.
> 
> Mapping in the new extent into the destination file can increase the
> extent count by 1.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.h | 14 ++++++++++++++
>  fs/xfs/xfs_reflink.c           |  5 +++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 850d53162545..d1c675cf803a 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -86,6 +86,20 @@ struct xfs_ifork {
>   * Hence number of extents increases by 2.
>   */
>  #define XFS_IEXT_REFLINK_END_COW_CNT	(2)
> +/*

It's usually considered good style to put a blank line between the
previous definition and the new comment.

With that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> + * Remapping an extent involves unmapping the existing extent and mapping in the
> + * new extent.
> + *
> + * When unmapping, an extent containing the entire unmap range can be split into
> + * two extents,
> + * i.e. | Old extent | hole | Old extent |
> + * Hence extent count increases by 1.
> + *
> + * Mapping in the new extent into the destination file can increase the extent
> + * count by 1.
> + */
> +#define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
> +	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
>  
>  /*
>   * Fork handling.
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index c1d2a741e1af..9884fd51efee 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1099,6 +1099,11 @@ xfs_reflink_remap_extent(
>  			goto out_cancel;
>  	}
>  
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written));
> +	if (error)
> +		goto out_cancel;
> +
>  	if (smap_real) {
>  		/*
>  		 * If the extent we're unmapping is backed by storage (written
> -- 
> 2.28.0
> 
