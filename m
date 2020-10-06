Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CCEC4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33EA7206F4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:23:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H591bM9p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgJFEXf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:23:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgJFEXf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:23:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964JN0Q052205;
        Tue, 6 Oct 2020 04:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2iDDD3VZaEwSBYUy/M8gnKFpptYwJNgFcTnSq/njZZI=;
 b=H591bM9pNsbzJZy78k8F83ZvujY3acPV1VdXtxut6c9hbMrOlgodl6fEaUGvhHVPk//R
 gZ9BxpIzcSDwsDZmbqrNVX7UOliQconY1TYUb/s23wY2bCv8zvmUQvZ5wR32syJesxfM
 w6GKlCx7yWYr5ps5h4tL5vh6BM4Qgx0PES7KJYPrGAgWMviN6Xmo3SejUWl2XQ20Fl1K
 DYY+mYx02lCXTndTXyZHyOY9oKyhJ3fmWyM/sjBIeQ/lQy0wr0Tg5I69N7OTkjcOZ9tL
 vmRMf3jNw0vfKxbcZHo/oRiQ8vx37RYV1jvf5JKSsjElpLgfn2myBHtz/4lsYfsMZQBr Iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxmspxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:23:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964L7Le182697;
        Tue, 6 Oct 2020 04:23:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33yyjex6ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:23:32 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0964NU9n013292;
        Tue, 6 Oct 2020 04:23:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:23:30 -0700
Date:   Mon, 5 Oct 2020 21:23:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 04/12] xfs: Check for extent overflow when
 adding/removing xattrs
Message-ID: <20201006042329.GN49547@magnolia>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
 <20201003055633.9379-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003055633.9379-5-chandanrlinux@gmail.com>
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

On Sat, Oct 03, 2020 at 11:26:25AM +0530, Chandan Babu R wrote:
> Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
> added. One extra extent for dabtree in case a local attr is large enough
> to cause a double split.  It can also cause extent count to increase
> proportional to the size of a remote xattr's value.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Didn't I already review this?  AFAICT it hasn't changed much, but did
something change enough to warrant dropping the old RVB tag?

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

Hmm.  If you hit this while trying to remove an xattr, what then?
I suppose you really don't want to overflow naextents, but I suppose the
only other option is to delete the file.  Oh well, attr forks with 65533
extents should be vanishingly rare, right?  Right? :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
