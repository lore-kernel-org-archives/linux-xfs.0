Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724C3C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 497742075E
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BW+nsaWn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgHRWDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:03:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgHRWDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:03:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07ILwJgd108014;
        Tue, 18 Aug 2020 22:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IwZ6sCnIFD7acCC9mIGDjHATf4FUvTIuA1ekT5mXcjU=;
 b=BW+nsaWnZfE780P8lZffpR7tqNGjs8jVyI8FKwk+r4Uur5Z6Er4byX+UpzFYXBzkqKdZ
 aPMOz6lI//P5fxvFl/025PVmssOJiNzWcaEhHxMh6jsDrQFE9ncv3fPPt4jTKqCz6nHX
 zwkwSwjKzEnIRL4XBWero2r5GbiUXxZhsMcZ/nz9YZ15K/gOp9cG+M3FdBDvLlm658Q5
 9cKVk7CRRGpNgfr+o2NvqYyCd0o1YgaYwehxFpL8pBJGQvFOYiNIhFRz3OAh9LMAoAMR
 aF0rPYzE7Xst+FnlXnexJTQi7EqmHjDeBssjvEsmjMj8BdA5lzQ9aNj+BeBuwPBEku5T rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74r7hr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:03:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IM2vRK170950;
        Tue, 18 Aug 2020 22:03:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32xsmxs2c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:03:11 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IM39ui030536;
        Tue, 18 Aug 2020 22:03:09 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:03:09 -0700
Date:   Tue, 18 Aug 2020 15:03:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V2 08/10] xfs: Check for extent overflow when moving
 extent from cow to data fork
Message-ID: <20200818220307.GA6096@magnolia>
References: <20200814080833.84760-1-chandanrlinux@gmail.com>
 <20200814080833.84760-9-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814080833.84760-9-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 14, 2020 at 01:38:31PM +0530, Chandan Babu R wrote:
> Moving an extent to data fork can cause a sub-interval of an existing
> extent to be unmapped. This will increase extent count by 1. Mapping in
> the new extent can increase the extent count by 1 again i.e.
>  | Old extent | New extent | Old extent |
> Hence number of extents increases by 2.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.h | 10 +++++++++-
>  fs/xfs/xfs_reflink.c           |  6 ++++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 63f83a13e0a8..d750bdff17c9 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -76,7 +76,15 @@ struct xfs_ifork {
>   * increase by 1.
>   */
>  #define XFS_IEXT_INSERT_HOLE_CNT 1
> -
> +/*
> + * Moving an extent to data fork can cause a sub-interval of an
> + * existing extent to be unmapped. This will increase extent count by
> + * 1. Mapping in the new extent can increase the extent count by 1
> + * again i.e.
> + * | Old extent | New extent | Old extent |

This comment is a little oddly formatted, mostly because my brain
thought that the line starting with "1. Mapping" was a numbered bullet
list.  If you reflow the comment further outward, you can get it to look
like this:

/*
 * Moving an extent to data fork can cause a sub-interval of an existing
 * extent to be unmapped, increasing extent count by 1. Mapping in the
 * new extent can also increase the extent count by 1:
 * | Old extent | New extent | Old extent |
 * Hence number of extents increases by 2.
 */
#define XFS_IEXT_REFLINK_END_COW_CNT 2

--D

> + * Hence number of extents increases by 2.
> + */
> +#define XFS_IEXT_REFLINK_END_COW_CNT 2
>  /*
>   * Fork handling.
>   */
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index aac83f9d6107..04a7754ee681 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -29,6 +29,7 @@
>  #include "xfs_iomap.h"
>  #include "xfs_sb.h"
>  #include "xfs_ag_resv.h"
> +#include "xfs_trans_resv.h"
>  
>  /*
>   * Copy on Write of Shared Blocks
> @@ -628,6 +629,11 @@ xfs_reflink_end_cow_extent(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_REFLINK_END_COW_CNT);
> +	if (error)
> +		goto out_cancel;
> +
>  	/*
>  	 * In case of racing, overlapping AIO writes no COW extents might be
>  	 * left by the time I/O completes for the loser of the race.  In that
> -- 
> 2.28.0
> 
