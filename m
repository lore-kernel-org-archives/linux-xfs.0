Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C833C4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4E3121D94
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 19:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731826AbgLCTFH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:05:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49730 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731824AbgLCTFH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 14:05:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3Iwe00022010;
        Thu, 3 Dec 2020 19:04:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=V0vMoytc2XjKCTYIgHkUarcliP+P9nXbLccn+1z1MoM=;
 b=o/BDEUo2FUPr+T8IjHvTaTLTZ/CZCQ0Y8fWpV4BOPEMyOBMF8AMspg+fMlv1DH0ItCV1
 guG2FdxXgu7uFwF4i5LtKUOlueU5SqblioPRUlFSkQC59TNs6xTSOR7ALD8oEzAWrsN8
 vNzR5pBBs8P1Kys3vW6h1dsItfhbT5M0ZpaKu8AM66tc9100GOP8ZmJJchEfd7P3KSc2
 qFT8Ts1lKbbwKMM7+cFHqVqgxMj7xd+YpHELzm/VzS+119avh11gG09dhp/hSBMfaExt
 e6ciSX7pXxBUF9cBXGA8aluIXGLLgz0pGwnbny1a2RYZJ3MEPODTsSoFL03f6ND8jrvB Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkypst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 19:04:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3IuOta067387;
        Thu, 3 Dec 2020 19:04:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3540awn226-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 19:04:24 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3J4NwM017355;
        Thu, 3 Dec 2020 19:04:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 11:04:23 -0800
Date:   Thu, 3 Dec 2020 11:04:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V11 05/14] xfs: Check for extent overflow when
 adding/removing dir entries
Message-ID: <20201203190422.GB106271@magnolia>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
 <20201117134416.207945-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117134416.207945-6-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=5
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=5
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 17, 2020 at 07:14:07PM +0530, Chandan Babu R wrote:
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
> To be able to always remove an existing directory entry, when adding a
> new directory entry we make sure to reserve inode fork extent count
> required for removing a directory entry in addition to that required for
> the directory entry add operation.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.h | 13 +++++++++++++
>  fs/xfs/xfs_inode.c             | 27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_symlink.c           |  5 +++++
>  3 files changed, 45 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 5de2f07d0dd5..fd93fdc67ee4 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -57,6 +57,19 @@ struct xfs_ifork {
>  #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
>  	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
>  
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
> +
>  /*
>   * Fork handling.
>   */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2bfbcf28b1bd..f7b0b7fce940 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1177,6 +1177,11 @@ xfs_create(
>  	if (error)
>  		goto out_trans_cancel;
>  
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);

Er, why did these double since V10?  We're only adding one entry, right?

> +	if (error)
> +		goto out_trans_cancel;
> +
>  	/*
>  	 * A newly created regular or special file just has one directory
>  	 * entry pointing to them, but a directory also the "." entry
> @@ -1393,6 +1398,11 @@ xfs_link(
>  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
>  
> +	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);

Same question here.

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
> +				XFS_IEXT_DIR_MANIP_CNT(mp) << 1);

Why did this change to "<< 1" since V10?

I'm sorry, but I've lost my recollection on how the accounting works
here.  This seems (to me anyway ;)) a good candidate for a comment:

For a rename within the same dir where target_name doesn't yet exist, we
are removing a name and then adding a name.  We therefore check for iext
overflow with (DIR_MANIP_CNT * 2), right?  And I think that "target name
does not exist" is synonymous with target_ip == NULL?

For a rename between dirs where the target name doesn't exist, we're
removing src_name from src_dp and adding target_name to target_dp.
Therefore we have to check for DIR_MANIP_CNT overflow on each of src_dp
and target_dp, right?

For a rename where target_name /does/ exist, we're only removing the
src_name, so we have to check for DIR_MANIP_CNT on src_dp, right?

For a RENAME_EXCHANGE we're not removing either name, so we don't need
to check for iext overflow of src_dp or target_dp, right?

> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>  	/*
>  	 * If we are using project inheritance, we only allow renames
>  	 * into our tree when the project IDs are the same; else the
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 8e88a7ca387e..08aa808fe290 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -220,6 +220,11 @@ xfs_symlink(
>  	if (error)
>  		goto out_trans_cancel;
>  
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp) << 1);

Same question as xfs_create.

--D

> +	if (error)
> +		goto out_trans_cancel;
> +
>  	/*
>  	 * Allocate an inode for the symlink.
>  	 */
> -- 
> 2.28.0
> 
