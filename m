Return-Path: <SRS0=Od9L=D7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518BAC2D0A3
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1047F222EC
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:20:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cca4Gy2Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764368AbgJXUUv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 16:20:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48202 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764370AbgJXUUu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 16:20:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKKigO103508;
        Sat, 24 Oct 2020 20:20:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6D7ub/guN+Ky3B4Nv6YLQSxBIUg8YmCqlE+kOcoxesE=;
 b=Cca4Gy2Zge4uJM1/1gNtpKuLT0Sx+WGXaoPE6jf07KBditMf4Yrhiuxgz3HZUdJ7Jbw3
 gbXYajxXkoFDj8N/d5ON6NxiVEB9k+STcNKlbtBTBiekeNLvzWeOJsIB0ANQqHQj8a2F
 a7Ch9l7lsVhqS2SLF4k/0zfOjFXFbApfrWVxK5aDHFGlbGczN5cFGNFr2/+DEHKZM3v0
 pSJL4GTgecIjpJqBVVF4U1mxzhIFge0FDj013CP2rXnsnRCH+arOBMJu8sOuOqmZCR1X
 yWCOgSlSaJGNn189cKWnYA4fo9jyUsIFDgQi+wuXI8jV4PAaDA4xKHk2dr8DsK9FoIbt jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34ccwmh2cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 20:20:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKFoCa064104;
        Sat, 24 Oct 2020 20:18:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34cc2ym2kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 20:18:43 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09OKIf8I017399;
        Sat, 24 Oct 2020 20:18:41 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 13:18:41 -0700
Subject: Re: [PATCH V7 05/14] xfs: Check for extent overflow when
 adding/removing dir entries
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-6-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <5943fb31-c3e6-7073-a509-d60bc1938048@oracle.com>
Date:   Sat, 24 Oct 2020 13:18:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-6-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010240156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=2
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240156
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> Directory entry addition/removal can cause the following,
> 1. Data block can be added/removed.
>     A new extent can cause extent count to increase by 1.
> 2. Free disk block can be added/removed.
>     Same behaviour as described above for Data block.
> 3. Dabtree blocks.
>     XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
>     can be new extents. Hence extent count can increase by
>     XFS_DA_NODE_MAXDEPTH.
> 
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_inode_fork.h | 13 +++++++++++++
>   fs/xfs/xfs_inode.c             | 27 +++++++++++++++++++++++++++
>   fs/xfs/xfs_symlink.c           |  5 +++++
>   3 files changed, 45 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 5de2f07d0dd5..fd93fdc67ee4 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -57,6 +57,19 @@ struct xfs_ifork {
>   #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
>   	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
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
>   /*
>    * Fork handling.
>    */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2bfbcf28b1bd..5b41ffaf04d7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1177,6 +1177,11 @@ xfs_create(
>   	if (error)
>   		goto out_trans_cancel;
>   
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto out_trans_cancel;
> +
>   	/*
>   	 * A newly created regular or special file just has one directory
>   	 * entry pointing to them, but a directory also the "." entry
> @@ -1393,6 +1398,11 @@ xfs_link(
>   	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
>   	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
>   
> +	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto error_return;
> +
>   	/*
>   	 * If we are using project inheritance, we only allow hard link
>   	 * creation in our tree when the project IDs are the same; else
> @@ -2861,6 +2871,11 @@ xfs_remove(
>   	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
>   	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>   
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto out_trans_cancel;
> +
>   	/*
>   	 * If we're removing a directory perform some additional validation.
>   	 */
> @@ -3221,6 +3236,18 @@ xfs_rename(
>   	if (wip)
>   		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
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
>   	/*
>   	 * If we are using project inheritance, we only allow renames
>   	 * into our tree when the project IDs are the same; else the
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 8e88a7ca387e..581a4032a817 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -220,6 +220,11 @@ xfs_symlink(
>   	if (error)
>   		goto out_trans_cancel;
>   
> +	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
> +			XFS_IEXT_DIR_MANIP_CNT(mp));
> +	if (error)
> +		goto out_trans_cancel;
> +
>   	/*
>   	 * Allocate an inode for the symlink.
>   	 */
> 
