Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA77C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56CE02083E
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:41:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wll/+Lgk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgHaQlb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:41:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49938 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgHaQla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:41:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGdfRP092984;
        Mon, 31 Aug 2020 16:41:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=v2J09Y1bcgv04zdLwb8SgB3VgZgNWPXFhhjfga4/Jr0=;
 b=Wll/+LgkKQpvXXCDJCKEkksLw7nrl1p8WEag4QPSI0OxwsmgftsYmksIgcw28IgEDZIS
 exsNGBwA0SNGo199B2lemZUVq01bUc0u7KsC9bBnbiYcY43For4sJzsIUksltUuj4b16
 GAnthxhTA1OQXvU2Dg4W9P3EybzeyiOoPCeYHV7tOC9DlptBcw3kkY3JW+s7SoiMOCXE
 oMmvqr1UyJ07RfKgEoaGqe4s1EdbIhSdrOLvIO1M4WJ6gCUN0iQj8bzXX+A5xAV9Y13y
 b5mjBd2Bld/fkirSXPylQWvTlvkpknA/6i7AU/Ep2G+lILJPgSz5OD1xLMeaeWFKpMgl 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 337qrhebp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 16:41:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGevPe183475;
        Mon, 31 Aug 2020 16:41:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3380sq8v20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:41:25 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VGfOjq009463;
        Mon, 31 Aug 2020 16:41:25 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 09:41:23 -0700
Date:   Mon, 31 Aug 2020 09:41:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 05/10] xfs: Check for extent overflow when
 adding/removing dir entries
Message-ID: <20200831164126.GN6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
 <20200820054349.5525-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820054349.5525-6-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=5 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310100
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 11:13:44AM +0530, Chandan Babu R wrote:
> Directory entry addition/removal can cause the following,
> 1. Data block can be added/removed.
>    A new extent can cause extent count to increase by 1.
> 2. Free disk block can be added/removed.
>    Same behaviour as described above for Data block.
> 3. Dabtree blocks.
>    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
>    can be new extents. Hence extent count can increase by
>    XFS_DA_NODE_MAXDEPTH.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

I wonder how long until someone's going to ask us to make
XFS_IEXT_DIR_MANIP_CNT return a number that's more tightly tied to the
actual directory inode in question, but 4 billion extents would already
be pretty egregious, so maybe we don't care...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.h | 12 ++++++++++++
>  fs/xfs/xfs_inode.c             | 27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_symlink.c           |  5 +++++
>  3 files changed, 44 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index aae8e6e80b71..f686c7418d2b 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -54,6 +54,18 @@ struct xfs_ifork {
>   */
>  #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
>  	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
> +/*
> + * Directory entry addition/removal can cause the following,
> + * 1. Data block can be added/removed.
> + *    A new extent can cause extent count to increase by 1.
> + * 2. Free disk block can be added/removed.
> + *    Same behaviour as described above for Data block.
> + * 3. Dabtree blocks.
> + *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
> + *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
> + */
> +#define XFS_IEXT_DIR_MANIP_CNT(mp) \
> +	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
>  
>  /*
>   * Fork handling.
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 407d6299606d..8d195b6ef326 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1175,6 +1175,11 @@ xfs_create(
>  	if (error)
>  		goto out_trans_cancel;
>  
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	/*
>  	 * A newly created regular or special file just has one directory
>  	 * entry pointing to them, but a directory also the "." entry
> @@ -1391,6 +1396,11 @@ xfs_link(
>  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
>  
> +	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto error_return;
> +
>  	/*
>  	 * If we are using project inheritance, we only allow hard link
>  	 * creation in our tree when the project IDs are the same; else
> @@ -2861,6 +2871,11 @@ xfs_remove(
>  	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	/*
>  	 * If we're removing a directory perform some additional validation.
>  	 */
> @@ -3221,6 +3236,18 @@ xfs_rename(
>  	if (wip)
>  		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
>  
> +	error = xfs_iext_count_may_overflow(src_dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto out_trans_cancel;
> +
> +	if (target_ip == NULL) {
> +		error = xfs_iext_count_may_overflow(target_dp, XFS_DATA_FORK,
> +				XFS_IEXT_DIR_MANIP_CNT(mp));
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>  	/*
>  	 * If we are using project inheritance, we only allow renames
>  	 * into our tree when the project IDs are the same; else the
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 8e88a7ca387e..581a4032a817 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -220,6 +220,11 @@ xfs_symlink(
>  	if (error)
>  		goto out_trans_cancel;
>  
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto out_trans_cancel;
> +
>  	/*
>  	 * Allocate an inode for the symlink.
>  	 */
> -- 
> 2.28.0
> 
