Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE804C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB9A02073A
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:20:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0J6gn9BN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgHaQUp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:20:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59892 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbgHaQUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:20:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGK4B5021836;
        Mon, 31 Aug 2020 16:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7n6EK5YnJa/U/V04xTmkGKSH1Zcl5dtdfiJTRXgrrrM=;
 b=0J6gn9BNulwFx2NBodE7VSGZFEYqQSlwJsBtGb3Yo6k9eWYxKksJa6vlyuLIyT7VBxR8
 EftjKE05P50IJtniOuhcePHML3rtJfKZMQv9OwvE6jk74pzv2GoYBsH5hrbSCY58TEHs
 YZePBkRnZ6FP4momF+lG5IRQvRlwX1AeDmricelyrfzvrigyRL4iJVZo33GNOh25SuA3
 X/p/KTASj3QPqdY6/W7CMZl/oyg4LpDYS4kzJwtvKQO1X/HatCanmuhckTHXxi80idnE
 WaSrCP8F2NtCI7HAZJLZtAbOXbMJfpnoxPkHojpXlx+bgFkxUGSu1rp0SK25Qw26eJIX ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 337eyky5s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 16:20:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGKaHg048111;
        Mon, 31 Aug 2020 16:20:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3380x0nbq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:20:38 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VGKaJj022006;
        Mon, 31 Aug 2020 16:20:37 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 09:20:36 -0700
Date:   Mon, 31 Aug 2020 09:20:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 10/10] xfs: Check for extent overflow when swapping
 extents
Message-ID: <20200831162039.GI6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
 <20200820054349.5525-11-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820054349.5525-11-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310097
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 11:13:49AM +0530, Chandan Babu R wrote:
> Removing an initial range of source/donor file's extent and adding a new
> extent (from donor/source file) in its place will cause extent count to
> increase by 1.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.h |  6 ++++++
>  fs/xfs/xfs_bmap_util.c         | 11 +++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index d1c675cf803a..4219b01f1034 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -100,6 +100,12 @@ struct xfs_ifork {
>   */
>  #define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
>  	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
> +/*
> + * Removing an initial range of source/donor file's extent and adding a new
> + * extent (from donor/source file) in its place will cause extent count to
> + * increase by 1.
> + */
> +#define XFS_IEXT_SWAP_RMAP_CNT		(1)
>  
>  /*
>   * Fork handling.
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index e682eecebb1f..7105525dadd5 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1375,6 +1375,17 @@ xfs_swap_extent_rmap(
>  		/* Unmap the old blocks in the source file. */
>  		while (tirec.br_blockcount) {
>  			ASSERT(tp->t_firstblock == NULLFSBLOCK);
> +
> +			error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +					XFS_IEXT_SWAP_RMAP_CNT);
> +			if (error)
> +				goto out;
> +
> +			error = xfs_iext_count_may_overflow(tip, XFS_DATA_FORK,
> +					XFS_IEXT_SWAP_RMAP_CNT);

Heh, the old swapext code is very gritty.  Two questions--

If either of irec and uirec describe a hole, why do we need to check for
an extent count overflow?

Second, is the transaction clean at the point where we could goto out?
I'm pretty sure it is, but if there's a chance we could end up bailing
out with a dirty transaction, then we need to do this check elsewhere
such that we don't shut down the filesystem.

(I'm pretty sure the answer to #2 is "yes", but I thought I'd better
ask.)

--D

> +			if (error)
> +				goto out;
> +
>  			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
>  
>  			/* Read extent from the source file */
> -- 
> 2.28.0
> 
