Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6AFC4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 18:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D463F207B8
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 18:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729492AbgLCSqo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 13:46:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33704 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbgLCSqo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 13:46:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3IfOOI183551;
        Thu, 3 Dec 2020 18:46:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LsbOFgfc6EiFsAf+OXfLEV8HqM7dLlycupj/vEgWUuo=;
 b=qelF3AqsW3DWOZvNeFqinaTtVnp/P84k4eVOZ7ViDsH1/AMNNBbbvU8+k+iqxf47yxjp
 KZgwfZTFp7hJYwk5xoI6t81CebmBFRbTc/z/ou2TOpyB855xkskON1eZXVWH7IN9eBLP
 UseJ4cAzW75LObusijMW7b8IpKMVfHXU2a362mw1Gu1yetxvyzSgdmXDsl6/4HPz164V
 +NSiOGE+3TuqwejqdUoum0Cc5JkEcpBQ4XxpkA+Gv1X1oOXhJDGiKdacjJrGYBHY8+iF
 uiYiWGP5LGD50bHadyxWA/gQn2gS1AizxmGvkMk1e0bmQjnO8rnAS6hnMRACluRkB0rz RA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egkym0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 18:46:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3IaDw7040017;
        Thu, 3 Dec 2020 18:46:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540f28px7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 18:46:01 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B3Ik0Da009139;
        Thu, 3 Dec 2020 18:46:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 10:45:59 -0800
Date:   Thu, 3 Dec 2020 10:45:59 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V11 04/14] xfs: Check for extent overflow when
 adding/removing xattrs
Message-ID: <20201203184559.GA106271@magnolia>
References: <20201117134416.207945-1-chandanrlinux@gmail.com>
 <20201117134416.207945-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117134416.207945-5-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030109
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 17, 2020 at 07:14:06PM +0530, Chandan Babu R wrote:
> Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
> added. One extra extent for dabtree in case a local attr is large enough
> to cause a double split.  It can also cause extent count to increase
> proportional to the size of a remote xattr's value.
> 
> To be able to always remove an existing xattr, when adding an xattr we
> make sure to reserve inode fork extent count required for removing max
> sized xattr in addition to that required by the xattr add operation.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       | 20 ++++++++++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.h | 10 ++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fd8e6418a0d3..d53b3867b308 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -396,6 +396,8 @@ xfs_attr_set(
>  	struct xfs_trans_res	tres;
>  	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
>  	int			error, local;
> +	int			iext_cnt;
> +	int			rmt_blks;
>  	unsigned int		total;
>  
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
> @@ -416,6 +418,9 @@ xfs_attr_set(
>  	 */
>  	args->op_flags = XFS_DA_OP_OKNOENT;
>  
> +	rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
> +	iext_cnt = XFS_IEXT_ATTR_MANIP_CNT(rmt_blks);

These values are only relevant for the xattr removal case, right?
AFAICT the args->value != NULL case immediately after will set new
values, so why not just move this into...

> +
>  	if (args->value) {
>  		XFS_STATS_INC(mp, xs_attr_set);
>  
> @@ -442,6 +447,13 @@ xfs_attr_set(
>  		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>  		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>  		total = args->total;
> +
> +		if (local)
> +			rmt_blks = 0;
> +		else
> +			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> +
> +		iext_cnt += XFS_IEXT_ATTR_MANIP_CNT(rmt_blks);
>  	} else {
>  		XFS_STATS_INC(mp, xs_attr_remove);

...the bottom of this clause here.

>  
> @@ -460,6 +472,14 @@ xfs_attr_set(
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(args->trans, dp, 0);
> +
> +	if (args->value || xfs_inode_hasattr(dp)) {

Can this simply be "if (iext_cnt != 0)" ?

--D

> +		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> +				iext_cnt);
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
