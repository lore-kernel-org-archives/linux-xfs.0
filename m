Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45092C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CCA5208B6
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:23:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uKqL/70x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgJFEXx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:23:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53742 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgJFEXx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:23:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964JR5Q052362;
        Tue, 6 Oct 2020 04:23:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=z3jFVM7tomRL1DGniQZeyr29IHt5UwE1cS+wgG6lpL0=;
 b=uKqL/70xpZ9qYQLW6f46FZxVDyFAtbOZP2Yfw2jYEY38QFOKw+vXDS+UGd3NX7jVwRPT
 bKdUsmSVlQlqXbkfR5AbOOUHp1Vr25bYu0jED7NN9uWk3vEGKTcHQBzE7ywvYlkQRCKm
 BDkHivI8niXC+AEUPr216pE+aHX6JFDrnaNNvyJD0xINxeWfwduTEZCWdd4SteNOevyZ
 YvOY1amsSZu55QG6LhkRZfTXeIsl/UpKCS33PVgg7yIbjhq5sDbNeTl3PnPECfiYe3Mw
 GntevsnUAjrWhY3dQz0PLGUvWmGPPQ1WdADQPxfKu39vs0JBIxlpp1Ft2fRXRcqL6Ehg fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxmspxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:23:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964L677182628;
        Tue, 6 Oct 2020 04:23:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33yyjex6uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:23:50 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0964NnSg017600;
        Tue, 6 Oct 2020 04:23:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:23:49 -0700
Date:   Mon, 5 Oct 2020 21:23:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 09/12] xfs: Check for extent overflow when swapping
 extents
Message-ID: <20201006042344.GO49547@magnolia>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
 <20201003055633.9379-10-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003055633.9379-10-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060024
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 03, 2020 at 11:26:30AM +0530, Chandan Babu R wrote:
> Removing an initial range of source/donor file's extent and adding a new
> extent (from donor/source file) in its place will cause extent count to
> increase by 1.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
>  fs/xfs/xfs_bmap_util.c         | 16 ++++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index ded3c1b56c94..837c01595439 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -102,6 +102,13 @@ struct xfs_ifork {
>  #define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
>  	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
>  
> +/*
> + * Removing an initial range of source/donor file's extent and adding a new
> + * extent (from donor/source file) in its place will cause extent count to
> + * increase by 1.
> + */
> +#define XFS_IEXT_SWAP_RMAP_CNT		(1)
> +
>  /*
>   * Fork handling.
>   */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0776abd0103c..b6728fdf50ae 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1407,6 +1407,22 @@ xfs_swap_extent_rmap(
>  					irec.br_blockcount);
>  			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
>  
> +			if (xfs_bmap_is_real_extent(&uirec)) {
> +				error = xfs_iext_count_may_overflow(ip,
> +						XFS_DATA_FORK,
> +						XFS_IEXT_SWAP_RMAP_CNT);
> +				if (error)
> +					goto out;
> +			}
> +
> +			if (xfs_bmap_is_real_extent(&irec)) {
> +				error = xfs_iext_count_may_overflow(tip,
> +						XFS_DATA_FORK,
> +						XFS_IEXT_SWAP_RMAP_CNT);
> +				if (error)
> +					goto out;
> +			}
> +
>  			/* Remove the mapping from the donor file. */
>  			xfs_bmap_unmap_extent(tp, tip, &uirec);
>  
> -- 
> 2.28.0
> 
