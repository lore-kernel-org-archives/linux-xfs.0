Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C572C43463
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 15:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D99C923888
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 15:51:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ePJJK4qP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIRPvK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 11:51:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48490 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgIRPvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 11:51:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IFp5SV009538;
        Fri, 18 Sep 2020 15:51:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=cV1ZwVX+l8eLEgVdPogcYySiKUnB86XU8B4DkaqTu6E=;
 b=ePJJK4qPu8ZAPp1oX6dL4HCVKKOord2051B/QW40QBk3YQ6YlbLfQIAmP8fA57TywNbV
 2hxVn9mkTQIEob9Xh7d7Qq0ErvkbHdFB+RIgFqRM9FKnlG03/I434Td1nt5CDz8zIUuj
 +osgpv7ELcENumldH/osD7wRlFNDBSTAN5L0kG4faLUwISVbqgs26bFkgwRE0wVB3Xij
 8x+Uw//k4Qnin4E9dSLjKpXWmJy6OnFpCrPPxn8ilGFxmMobXdsSUhkNX0JioT4XKXaM
 BsgxvESGUIC1LIGFbxHT9EdM6OkSJniB/bb3sPb3c3A5aZ1i3DPjmXtSNk24eWEsqzRW yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91e1mcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 15:51:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08IFjEXS011225;
        Fri, 18 Sep 2020 15:49:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33megbnrdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 15:49:04 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08IFn4He023091;
        Fri, 18 Sep 2020 15:49:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 15:49:03 +0000
Date:   Fri, 18 Sep 2020 08:49:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 04/10] xfs: Check for extent overflow when
 adding/removing xattrs
Message-ID: <20200918154902.GZ7955@magnolia>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
 <20200918094759.2727564-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918094759.2727564-5-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9748 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9748 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 18, 2020 at 03:17:53PM +0530, Chandan Babu R wrote:
> Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
> added. One extra extent for dabtree in case a local attr is large enough
> to cause a double split.  It can also cause extent count to increase
> proportional to the size of a remote xattr's value.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good, sorry I forgot to follow up on the V3 series.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c       | 13 +++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.h | 10 ++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fd8e6418a0d3..be51e7068dcd 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -396,6 +396,7 @@ xfs_attr_set(
>  	struct xfs_trans_res	tres;
>  	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
>  	int			error, local;
> +	int			rmt_blks = 0;
>  	unsigned int		total;
>  
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
> @@ -442,11 +443,15 @@ xfs_attr_set(
>  		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>  		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>  		total = args->total;
> +
> +		if (!local)
> +			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
>  	} else {
>  		XFS_STATS_INC(mp, xs_attr_remove);
>  
>  		tres = M_RES(mp)->tr_attrrm;
>  		total = XFS_ATTRRM_SPACE_RES(mp);
> +		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
>  	}
>  
>  	/*
> @@ -460,6 +465,14 @@ xfs_attr_set(
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(args->trans, dp, 0);
> +
> +	if (args->value || xfs_inode_hasattr(dp)) {
> +		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> +				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>  	if (args->value) {
>  		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index bcac769a7df6..5de2f07d0dd5 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -47,6 +47,16 @@ struct xfs_ifork {
>   */
>  #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
>  
> +/*
> + * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
> + * be added. One extra extent for dabtree in case a local attr is
> + * large enough to cause a double split.  It can also cause extent
> + * count to increase proportional to the size of a remote xattr's
> + * value.
> + */
> +#define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
> +	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
> +
>  /*
>   * Fork handling.
>   */
> -- 
> 2.28.0
> 
