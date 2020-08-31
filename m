Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5167FC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2514A2083E
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:29:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zowKQsbm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgHaQ3P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:29:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41008 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHaQ3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:29:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGNXRh067216;
        Mon, 31 Aug 2020 16:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+hUTnqcm6BlvI6dGlwYBL5Z67EglpN/InTjk+D0dvg0=;
 b=zowKQsbmcsyAyG5xKk0Lm/4X6aW4aaQ6h2Z0DNV4WV5RbqSk3JkpsOJhK7kiuYynJae+
 2l2RxIxwDE59kosEs07jZoCviYe97W7e7umanhtKcx52/OayscY7Ra8ebuU4P72mVWli
 Nb9X3RFRZ0bJ3Dk06zy3WWIGcVq2NMYwCED48G7jHVjYZoxHt4fcm6hb8lo7ESCHO8tA
 FqUfQOgllkkqD7F/F86ZU4RmeXkETkEuFiGAo29RPRra30YoA/xlKDg2RGJwEtC7NvnQ
 54wweqF4y0mnc8HvH2JPxCNsDn3XOBIWESYGhmYayBjrJwkwlKW+kHIvsAXRpecqXi4K Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 337qrhe9t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 16:29:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGOv8I121112;
        Mon, 31 Aug 2020 16:29:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3380sq87e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:29:06 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VGT5dN028627;
        Mon, 31 Aug 2020 16:29:05 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 09:29:04 -0700
Date:   Mon, 31 Aug 2020 09:29:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 08/10] xfs: Check for extent overflow when moving
 extent from cow to data fork
Message-ID: <20200831162908.GK6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
 <20200820054349.5525-9-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820054349.5525-9-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=1 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310098
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 11:13:47AM +0530, Chandan Babu R wrote:
> Moving an extent to data fork can cause a sub-interval of an existing
> extent to be unmapped. This will increase extent count by 1. Mapping in
> the new extent can increase the extent count by 1 again i.e.
>  | Old extent | New extent | Old extent |
> Hence number of extents increases by 2.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.h | 9 ++++++++-
>  fs/xfs/xfs_reflink.c           | 5 +++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index d0e49b015b62..850d53162545 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -78,7 +78,14 @@ struct xfs_ifork {
>   * split into two extents causing extent count to increase by 1.
>   */
>  #define XFS_IEXT_INSERT_HOLE_CNT	(1)
> -
> +/*
> + * Moving an extent to data fork can cause a sub-interval of an existing extent
> + * to be unmapped. This will increase extent count by 1. Mapping in the new
> + * extent can increase the extent count by 1 again i.e.
> + * | Old extent | New extent | Old extent |
> + * Hence number of extents increases by 2.
> + */
> +#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
>  
>  /*
>   * Fork handling.
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index aac83f9d6107..c1d2a741e1af 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -628,6 +628,11 @@ xfs_reflink_end_cow_extent(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_REFLINK_END_COW_CNT);
> +	if (error)
> +		goto out_cancel;

What happens if we fail here?  I think for buffered writes this means
that writeback fails and we store an EIO in the address space for
eventual return via fsync()?   And for a direct write this means that
EIO gets sent back to the caller, right?

Assuming I understood that correctly, I think this is a reasonable
enough place to check for overflows, and hence

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

It would be nicer to check this kind of thing at write() time to put all
the EFBIG errors up front, but I don't think you can do that without
tracking extent count "reservations" incore.

--D

> +
>  	/*
>  	 * In case of racing, overlapping AIO writes no COW extents might be
>  	 * left by the time I/O completes for the loser of the race.  In that
> -- 
> 2.28.0
> 
