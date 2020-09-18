Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203FAC43463
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 15:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3412388B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 15:55:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NIajs0h8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgIRPzK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 11:55:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52668 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgIRPzK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 11:55:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IFsKBF012411;
        Fri, 18 Sep 2020 15:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=H4c2ap8u+Q5rCQu+2pg/ZddtF88mGQ4ierfbnnOTw04=;
 b=NIajs0h8IDk9ZV9EqgtaPJEY83287/p/ffwl35rIe7WVzcaVodgTZ/UsaIrdnJegkHpt
 IcRshcjDAurwPszKA4uGl8EitjmgNbrj5fUL/wXYccHmDnOocH/VvmT6N0bWZVxOBRe6
 aMFg900sdd8FA+2BmYByoRgo187cOsixJupYmqZ/aEW3X8Zt3TRgyJTupZ7JucIBmKYY
 eCY5h9ebpTVnOh/P4IQAZnKsdXp0r+CM95M/9vNBlj/jMHD+a5a6CbZlyxFayiw/5I6S
 W6ImPRFuXp4BokOcVbvMZj1EOBlWkRSKIYlLnqZ2FToBXhgWH427l1S3rt8M+CPVhfyo wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91e1myf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 15:55:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IFt60L038765;
        Fri, 18 Sep 2020 15:55:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33megbnyj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 15:55:06 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08IFsr0D031096;
        Fri, 18 Sep 2020 15:54:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 15:54:53 +0000
Date:   Fri, 18 Sep 2020 08:54:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 03/10] xfs: Check for extent overflow when punching a
 hole
Message-ID: <20200918155452.GA7955@magnolia>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
 <20200918094759.2727564-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918094759.2727564-4-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9748 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9748 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 18, 2020 at 03:17:52PM +0530, Chandan Babu R wrote:
> The extent mapping the file offset at which a hole has to be
> inserted will be split into two extents causing extent count to
> increase by 1.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
>  fs/xfs/xfs_bmap_item.c         |  5 +++++
>  fs/xfs/xfs_bmap_util.c         | 10 ++++++++++
>  3 files changed, 22 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 7fc2b129a2e7..bcac769a7df6 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -40,6 +40,13 @@ struct xfs_ifork {
>   */
>  #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
>  
> +/*
> + * Punching out an extent from the middle of an existing extent can cause the
> + * extent count to increase by 1.
> + * i.e. | Old extent | Hole | Old extent |
> + */
> +#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
> +
>  /*
>   * Fork handling.
>   */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ec3691372e7c..5c7d08da8ff1 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -519,6 +519,11 @@ xfs_bui_item_recover(
>  	}
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	error = xfs_iext_count_may_overflow(ip, whichfork,
> +			XFS_IEXT_PUNCH_HOLE_CNT);

I think this ought to be XFS_IEXT_ADD_NOSPLIT_CNT if bui_type is
XFS_BMAP_MAP and XFS_IEXT_PUNCH_HOLE_CNT if XFS_BMAP_UNMAP.

Whoever created the BUI should have called xfs_iext_count_may_overflow
before logging the BUI (and hence this should never occur) but it does
pay to be careful. :)

The rest of the logic in the patch looks ok.

--D

> +	if (error)
> +		goto err_inode;
> +
>  	count = bmap->me_len;
>  	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
>  			bmap->me_startoff, bmap->me_startblock, &count, state);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index dcd6e61df711..0776abd0103c 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -891,6 +891,11 @@ xfs_unmap_extent(
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_PUNCH_HOLE_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
>  	if (error)
>  		goto out_trans_cancel;
> @@ -1176,6 +1181,11 @@ xfs_insert_file_space(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_PUNCH_HOLE_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	/*
>  	 * The extent shifting code works on extent granularity. So, if stop_fsb
>  	 * is not the starting block of extent, we need to split the extent at
> -- 
> 2.28.0
> 
