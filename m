Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23158C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFADB20707
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:48:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="s2QvquEq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgHaQsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:48:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55436 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbgHaQsn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:48:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGdtO1093079;
        Mon, 31 Aug 2020 16:48:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AdKD9wj4GiZDb6foYzCcCe55i5bAcW4aiNPFmxa9BpE=;
 b=s2QvquEqgOAz9q11CGkbVbDfzRPxeQ1UmFM7ldtA8umXilSGJ+XeP9kVz1YYGIY4fzM8
 xTbNwRnqVVM95OsmDWhna4r/0fTBD8pW1Jj7/Vl0N2+R3ovJSSkZhnA0os1Lh7j1UBDR
 HaqprIBLJP8AP+TdqZqOxqTfdVVxdk+osjxpLqHrKgfiR43ka3TOHZMknFRH9qVheEbk
 VmYgUaTahwwZfTuwr+zg5jgbcCtMBgaSHAUcHwqm5Scn+4VICTKhk8yupEmOqjWqT6Lq
 179gCMK1BC4cRyLOx30IciQu7BL4qIbULrHaLz67O1Q8fxldPGsS3x406Cik6fL5v5vw YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 337qrhecth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 16:48:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGf9t3042407;
        Mon, 31 Aug 2020 16:46:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3380kkw2vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:46:37 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VGkb2b004734;
        Mon, 31 Aug 2020 16:46:37 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 09:46:36 -0700
Date:   Mon, 31 Aug 2020 09:46:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 07/10] xfs: Check for extent overflow when inserting a
 hole
Message-ID: <20200831164635.GQ6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
 <20200820054349.5525-8-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820054349.5525-8-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=1 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310100
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 11:13:46AM +0530, Chandan Babu R wrote:
> The extent mapping the file offset at which a hole has to be
> inserted will be split into two extents causing extent count to
> increase by 1.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
>  fs/xfs/xfs_bmap_util.c         | 9 +++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 83ff90e2a5fe..d0e49b015b62 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -73,6 +73,12 @@ struct xfs_ifork {
>   * Hence extent count can increase by 2.
>   */
>  #define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
> +/*
> + * The extent mapping the file offset at which a hole has to be inserted will be
> + * split into two extents causing extent count to increase by 1.
> + */
> +#define XFS_IEXT_INSERT_HOLE_CNT	(1)

Given my earlier comments about how patch 3 is really only testing the
hole punching case, maybe it should be folded into this one?  They're
both inserting holes in the extent map.

Otherwise this patch looks good to me.

--D

> +
>  
>  /*
>   * Fork handling.
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 59d4da38aadf..e682eecebb1f 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1165,6 +1165,15 @@ xfs_insert_file_space(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	/*
> +	 * Splitting the extent mapping containing stop_fsb will cause
> +	 * extent count to increase by 1.
> +	 */
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_INSERT_HOLE_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	/*
>  	 * The extent shifting code works on extent granularity. So, if stop_fsb
>  	 * is not the starting block of extent, we need to split the extent at
> -- 
> 2.28.0
> 
