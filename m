Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767AAC43465
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 15:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8ADF208DB
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 15:44:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VigVLv6a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgIRPow (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 11:44:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41352 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgIRPow (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 11:44:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IFinvb003934;
        Fri, 18 Sep 2020 15:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xzrMWDdiePVH5jfuXWPULSNARa1ApRol9TgWRbaGvOY=;
 b=VigVLv6a0pAaalLXt7cUABHlETG14qum+gF0kG5NSWcraOkvKPivgdGcxIgJiW2DNPgK
 U/AFWGQLzsM5CFf/ZMsLdT/uy2HV8dkVuUwFwkkbgDl/n3rApPGGMj6tVt+ktwljhKA9
 k6G1xMdV1g13tc1DKCAXAFQ1GGsjNG6Dr4e1UikHcMJdtNrynGCRKb2HeTKnz+xmQ6MU
 d1pjbqldGM1+HjcOwZ7A/C+j2fcLYttsVldPiHDEvYbB1xQCA90eN7qsesvQhhRwTFXS
 lM3LmWdj8dftY+mCVqC3aensmJysc6gkMqO5hV5MLWKjb2UQ+dqz/6xZN8fgbrMrRIA8 kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91e1kdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 15:44:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IFPbV4126230;
        Fri, 18 Sep 2020 15:44:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33h88eueah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 15:44:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08IFikO3020318;
        Fri, 18 Sep 2020 15:44:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 15:44:46 +0000
Date:   Fri, 18 Sep 2020 08:44:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 09/10] xfs: Check for extent overflow when swapping
 extents
Message-ID: <20200918154445.GY7955@magnolia>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
 <20200918094759.2727564-10-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918094759.2727564-10-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9748 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9748 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 18, 2020 at 03:17:58PM +0530, Chandan Babu R wrote:
> Removing an initial range of source/donor file's extent and adding a new
> extent (from donor/source file) in its place will cause extent count to
> increase by 1.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 18 +++++++++---------
>  fs/xfs/libxfs/xfs_bmap.h       |  1 +
>  fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
>  fs/xfs/xfs_bmap_util.c         | 17 +++++++++++++++++
>  4 files changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 51c2d2690f05..9c665e379dfc 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6104,15 +6104,6 @@ xfs_bmap_split_extent(
>  	return error;
>  }
>  
> -/* Deferred mapping is only for real extents in the data fork. */
> -static bool
> -xfs_bmap_is_update_needed(
> -	struct xfs_bmbt_irec	*bmap)
> -{
> -	return  bmap->br_startblock != HOLESTARTBLOCK &&
> -		bmap->br_startblock != DELAYSTARTBLOCK;
> -}
> -
>  /* Record a bmap intent. */
>  static int
>  __xfs_bmap_add(
> @@ -6144,6 +6135,15 @@ __xfs_bmap_add(
>  	return 0;
>  }
>  
> +/* Deferred mapping is only for real extents in the data fork. */
> +bool
> +xfs_bmap_is_update_needed(
> +	struct xfs_bmbt_irec	*bmap)
> +{
> +	return  bmap->br_startblock != HOLESTARTBLOCK &&
> +		bmap->br_startblock != DELAYSTARTBLOCK;
> +}

I think the predicate you want below is xfs_bmap_is_real_extent().

(I think that mostly because I'm going to kill this predicate entirely
in a patch for the next cycle, because it is redundant and
_is_real_extent is a better name.)

--D

> +
>  /* Map an extent into a file. */
>  void
>  xfs_bmap_map_extent(
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index e1bd484e5548..60fbe184d5f4 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -263,6 +263,7 @@ struct xfs_bmap_intent {
>  	struct xfs_bmbt_irec			bi_bmap;
>  };
>  
> +bool	xfs_bmap_is_update_needed(struct xfs_bmbt_irec *bmap);
>  int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_inode *ip,
>  		enum xfs_bmap_intent_type type, int whichfork,
>  		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
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
> index 0776abd0103c..542f990247c4 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -28,6 +28,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_iomap.h"
>  #include "xfs_reflink.h"
> +#include "xfs_bmap.h"
>  
>  /* Kernel only BMAP related definitions and functions */
>  
> @@ -1407,6 +1408,22 @@ xfs_swap_extent_rmap(
>  					irec.br_blockcount);
>  			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
>  
> +			if (xfs_bmap_is_update_needed(&uirec)) {
> +				error = xfs_iext_count_may_overflow(ip,
> +						XFS_DATA_FORK,
> +						XFS_IEXT_SWAP_RMAP_CNT);
> +				if (error)
> +					goto out;
> +			}
> +
> +			if (xfs_bmap_is_update_needed(&irec)) {
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
