Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E60C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAF71208DB
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:10:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K6Q8Vc4N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgHaQK2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:10:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38496 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgHaQK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:10:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VG95Lg127460;
        Mon, 31 Aug 2020 16:10:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hsJu86EX4gAQYrs8KNtNZDAaLhT/ez8s4LZGNo8Ixgk=;
 b=K6Q8Vc4N27yetx4dknOxKrFpPIOzicaNxSUUS8lTIz8PPL01lmLYSa3yfJ8lqsJxiFyl
 fg0TDTjomO/SebcJxyLqCX/2iEx0CgzdN7dXyv2anbiKtbnAFa2bcrL/xzQmGyyjkTcm
 VeRlFJbRSkK5EqM3a1zXaJh16zytfg0QVZqu04dbY6PdA52yMMp0Q/YIkaNIRqilcHX5
 xvjgQs6XLLoc2Hhyq+qCYWkE1biBpMSQGPFz3ze7wllfYixE8YP8pmrWMCJNa1H665pR
 a1tIchOFuoeQtk8eKCQhi+oUnIcj30MqNrhats5kjcP/hehaIVUMKLLQY5ysN4XltAfz /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 337eeqq61y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 16:10:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VG0bNb157807;
        Mon, 31 Aug 2020 16:08:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3380x0mbvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:08:21 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VG8Jhj030326;
        Mon, 31 Aug 2020 16:08:19 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 09:08:19 -0700
Date:   Mon, 31 Aug 2020 09:08:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 01/10] xfs: Add helper for checking per-inode extent
 count overflow
Message-ID: <20200831160823.GG6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
 <20200820054349.5525-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820054349.5525-2-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310095
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310096
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 11:13:40AM +0530, Chandan Babu R wrote:
> XFS does not check for possible overflow of per-inode extent counter
> fields when adding extents to either data or attr fork.
> 
> For e.g.
> 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
>    then delete 50% of them in an alternating manner.
> 
> 2. On a 4k block sized XFS filesystem instance, the above causes 98511
>    extents to be created in the attr fork of the inode.
> 
>    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
> 
> 3. The incore inode fork extent counter is a signed 32-bit
>    quantity. However the on-disk extent counter is an unsigned 16-bit
>    quantity and hence cannot hold 98511 extents.
> 
> 4. The following incorrect value is stored in the attr extent counter,
>    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
>    core.naextents = -32561
> 
> This commit adds a new helper function (i.e.
> xfs_iext_count_may_overflow()) to check for overflow of the per-inode
> data and xattr extent counters. Future patches will use this function to
> make sure that an FS operation won't cause the extent counter to
> overflow.
> 
> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Seems reasonable so far...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.c | 23 +++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 0cf853d42d62..3a084aea8f85 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -23,6 +23,7 @@
>  #include "xfs_da_btree.h"
>  #include "xfs_dir2_priv.h"
>  #include "xfs_attr_leaf.h"
> +#include "xfs_types.h"
>  
>  kmem_zone_t *xfs_ifork_zone;
>  
> @@ -728,3 +729,25 @@ xfs_ifork_verify_local_attr(
>  
>  	return 0;
>  }
> +
> +int
> +xfs_iext_count_may_overflow(
> +	struct xfs_inode	*ip,
> +	int			whichfork,
> +	int			nr_to_add)
> +{
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	uint64_t		max_exts;
> +	uint64_t		nr_exts;
> +
> +	if (whichfork == XFS_COW_FORK)
> +		return 0;
> +
> +	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
> +
> +	nr_exts = ifp->if_nextents + nr_to_add;
> +	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
> +		return -EFBIG;
> +
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index a4953e95c4f3..0beb8e2a00be 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -172,5 +172,7 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
>  
>  int xfs_ifork_verify_local_data(struct xfs_inode *ip);
>  int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
> +int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
> +		int nr_to_add);
>  
>  #endif	/* __XFS_INODE_FORK_H__ */
> -- 
> 2.28.0
> 
