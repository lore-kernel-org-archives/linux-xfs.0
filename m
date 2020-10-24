Return-Path: <SRS0=Od9L=D7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC3F1C2D0A3
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 19:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89C5A22276
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 19:29:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="czPcH9MR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764035AbgJXT27 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 15:28:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51080 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764034AbgJXT27 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 15:28:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OJP2mZ086025;
        Sat, 24 Oct 2020 19:28:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GEblNUvfzpUqxtTRo1A++e9RyH0wWVmRUR4uyqk1r6Q=;
 b=czPcH9MRLylJ7mlXzMkY4lOsDUZYMnFtm3a0sYbPjjbvdq6bacEHEp+InmpAg8CTiLol
 kU/SPu2A0WlH6YlvNfL+sAUdeUyrHGsiD3gprUCSD/9CaBtMzgWbxVV8CbIPSVa65b33
 VbK5mleZQMvJQrt98WIhOFGQgZYewQ2EzryAfCyIqbP76ePzKnMeO499GCx7pqODzSmu
 z0u9wWbEIs95qdeEVs61QNJhoi5HVKnD3kkGapAr41NxIUbKj84kxLACusW3PC8hRJOg
 8+rvZMdGhuQ61y/tzL3yD2XHwMYtDLKhHKGkIieJ4p2FYc3wcX1IcSDPIsjnkMVhix5X cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7kh23f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 19:28:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OJK5qO052226;
        Sat, 24 Oct 2020 19:28:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cbkhn74m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 19:28:43 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09OJSgYx027434;
        Sat, 24 Oct 2020 19:28:43 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 12:28:42 -0700
Subject: Re: [PATCH V7 02/14] xfs: Check for extent overflow when trivally
 adding a new extent
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-3-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <d342d680-472f-53db-04ee-44c25d7b7cc2@oracle.com>
Date:   Sat, 24 Oct 2020 12:28:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-3-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1011 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> When adding a new data extent (without modifying an inode's existing
> extents) the extent count increases only by 1. This commit checks for
> extent count overflow in such cases.

Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_bmap.c       | 6 ++++++
>   fs/xfs/libxfs/xfs_inode_fork.h | 6 ++++++
>   fs/xfs/xfs_bmap_item.c         | 7 +++++++
>   fs/xfs/xfs_bmap_util.c         | 5 +++++
>   fs/xfs/xfs_dquot.c             | 8 +++++++-
>   fs/xfs/xfs_iomap.c             | 5 +++++
>   fs/xfs/xfs_rtalloc.c           | 5 +++++
>   7 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d9a692484eae..505358839d2f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4527,6 +4527,12 @@ xfs_bmapi_convert_delalloc(
>   		return error;
>   
>   	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
> +	error = xfs_iext_count_may_overflow(ip, whichfork,
> +			XFS_IEXT_ADD_NOSPLIT_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>   	xfs_trans_ijoin(tp, ip, 0);
>   
>   	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 0beb8e2a00be..7fc2b129a2e7 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -34,6 +34,12 @@ struct xfs_ifork {
>   #define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
>   #define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
>   
> +/*
> + * Worst-case increase in the fork extent count when we're adding a single
> + * extent to a fork and there's no possibility of splitting an existing mapping.
> + */
> +#define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
> +
>   /*
>    * Fork handling.
>    */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 9e16a4d0f97c..1610d6ad089b 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -497,6 +497,13 @@ xfs_bui_item_recover(
>   	xfs_ilock(ip, XFS_ILOCK_EXCL);
>   	xfs_trans_ijoin(tp, ip, 0);
>   
> +	if (bui_type == XFS_BMAP_MAP) {
> +		error = xfs_iext_count_may_overflow(ip, whichfork,
> +				XFS_IEXT_ADD_NOSPLIT_CNT);
> +		if (error)
> +			goto err_cancel;
> +	}
> +
>   	count = bmap->me_len;
>   	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
>   			whichfork, bmap->me_startoff, bmap->me_startblock,
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index f2a8a0e75e1f..dcd6e61df711 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -822,6 +822,11 @@ xfs_alloc_file_space(
>   		if (error)
>   			goto error1;
>   
> +		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +				XFS_IEXT_ADD_NOSPLIT_CNT);
> +		if (error)
> +			goto error0;
> +
>   		xfs_trans_ijoin(tp, ip, 0);
>   
>   		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 1d95ed387d66..175f544f7c45 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -314,8 +314,14 @@ xfs_dquot_disk_alloc(
>   		return -ESRCH;
>   	}
>   
> -	/* Create the block mapping. */
>   	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
> +
> +	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
> +			XFS_IEXT_ADD_NOSPLIT_CNT);
> +	if (error)
> +		return error;
> +
> +	/* Create the block mapping. */
>   	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
>   			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
>   			&nmaps);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 3abb8b9d6f4c..a302a96823b8 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -250,6 +250,11 @@ xfs_iomap_write_direct(
>   	if (error)
>   		goto out_trans_cancel;
>   
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_ADD_NOSPLIT_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>   	xfs_trans_ijoin(tp, ip, 0);
>   
>   	/*
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 9d4e33d70d2a..3e841a75f272 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -804,6 +804,11 @@ xfs_growfs_rt_alloc(
>   		xfs_ilock(ip, XFS_ILOCK_EXCL);
>   		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>   
> +		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +				XFS_IEXT_ADD_NOSPLIT_CNT);
> +		if (error)
> +			goto out_trans_cancel;
> +
>   		/*
>   		 * Allocate blocks to the bitmap file.
>   		 */
> 
