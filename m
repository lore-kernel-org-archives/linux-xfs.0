Return-Path: <SRS0=Od9L=D7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C89C2D0A3
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 303C52225F
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:41:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kKOy96TO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764002AbgJXUlw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 16:41:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44678 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762827AbgJXUlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 16:41:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKecQh018102;
        Sat, 24 Oct 2020 20:41:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6k96MRBZ41GjwTb9Zj7Ja722FGaBfZTqD+NNFq9Qc9g=;
 b=kKOy96TOoUtCM7VG8RIXOdQvlQ8C30SBM1F2LQYknwspQWYmfauZSyhNDT5GXjFjaScj
 gieP3+8DL6kO5lB0gNCfvQrt20nVo3Lnj0VQVwwzGXATAObphH4wMxVZNmwmfTTVIqK0
 pajelsvR5vqrz8AuKHKxsjSVU/0CjN8Z8lXtZ60OpopOkjT/LyZmjrE5ZB5+UrR5m0yN
 fP+dZ2v2hcHYYccJieqil0nbGA2OBpYWCrVCzSY6MFhiOoGLMNOb5ctcfu4QWYMHhkRm
 JINTluDDcqAXu4TDXjkGETbHycqCg8vwUGnagwvnQzBy3+WJVGy1cgDShUa23amS+dXW Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kh39m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 20:41:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKZAch019331;
        Sat, 24 Oct 2020 20:41:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34c9cr8vx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 20:41:46 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09OKfjLC007930;
        Sat, 24 Oct 2020 20:41:45 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 13:41:45 -0700
Subject: Re: [PATCH V7 09/14] xfs: Check for extent overflow when swapping
 extents
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-10-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <82b3d06e-3708-5f22-ef3c-4b5dfc3cb55c@oracle.com>
Date:   Sat, 24 Oct 2020 13:41:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-10-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010240159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240159
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> Removing an initial range of source/donor file's extent and adding a new
> extent (from donor/source file) in its place will cause extent count to
> increase by 1.
> 
Looks ok to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
>   fs/xfs/xfs_bmap_util.c         | 16 ++++++++++++++++
>   2 files changed, 23 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index b99e67e7b59b..969b06160d44 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -87,6 +87,13 @@ struct xfs_ifork {
>    */
>   #define XFS_IEXT_REFLINK_END_COW_CNT	(2)
>   
> +/*
> + * Removing an initial range of source/donor file's extent and adding a new
> + * extent (from donor/source file) in its place will cause extent count to
> + * increase by 1.
> + */
> +#define XFS_IEXT_SWAP_RMAP_CNT		(1)
> +
>   /*
>    * Fork handling.
>    */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0776abd0103c..b6728fdf50ae 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1407,6 +1407,22 @@ xfs_swap_extent_rmap(
>   					irec.br_blockcount);
>   			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
>   
> +			if (xfs_bmap_is_real_extent(&uirec)) {
> +				error = xfs_iext_count_may_overflow(ip,
> +						XFS_DATA_FORK,
> +						XFS_IEXT_SWAP_RMAP_CNT);
> +				if (error)
> +					goto out;
> +			}
> +
> +			if (xfs_bmap_is_real_extent(&irec)) {
> +				error = xfs_iext_count_may_overflow(tip,
> +						XFS_DATA_FORK,
> +						XFS_IEXT_SWAP_RMAP_CNT);
> +				if (error)
> +					goto out;
> +			}
> +
>   			/* Remove the mapping from the donor file. */
>   			xfs_bmap_unmap_extent(tp, tip, &uirec);
>   
> 
