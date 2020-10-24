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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F39ACC2D0A3
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A962521D41
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:19:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n997mur2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762268AbgJXUTJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 16:19:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47130 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761257AbgJXUTJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 16:19:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKIwDR102347;
        Sat, 24 Oct 2020 20:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aEhB1Iy3YJ7CsM53UPLOW8pAjafaaCRuW/sBU1rSh9M=;
 b=n997mur2DiXaaEI1/KBaXlHy6GiETRyUA9QuU1bhLz7+a4b8phuX+MZ6TrKSW6DBmbNG
 Lhr09Jngp/CAHgv2r6xsU+K8yAgCYDoYAQ84BNqjcHE/WJkL+kJwQONmKl6A8Juj5Epw
 Mgry0UuTDKGBVdsiI++l+vIGU9P5RNhyZhCWK/XRXsHG/XLEStzNX0A524uWwgb3Fz+v
 Z+Z2AGaIPEL8W+1dxkbsY3nza0n8ONoxbT6jcSfJcnFOeqPyaWsQAJAJuBQhB1q7KFFW
 dMjoD7ERUSew4QrjWzsKvqclZqTz/eqiJRfor0XQLBj44m49n1gKgC6BssnDI9USTfCy UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34ccwmh2b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 20:18:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKFo89064071;
        Sat, 24 Oct 2020 20:18:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cc2ym2nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 20:18:57 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09OKIu2I021085;
        Sat, 24 Oct 2020 20:18:56 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 13:18:56 -0700
Subject: Re: [PATCH V7 07/14] xfs: Check for extent overflow when moving
 extent from cow to data fork
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-8-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a508a4c7-a9f4-74c8-7e12-acea0e14c099@oracle.com>
Date:   Sat, 24 Oct 2020 13:18:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-8-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010240156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240155
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> Moving an extent to data fork can cause a sub-interval of an existing
> extent to be unmapped. This will increase extent count by 1. Mapping in
> the new extent can increase the extent count by 1 again i.e.
>   | Old extent | New extent | Old extent |
> Hence number of extents increases by 2.
> 
Looks ok to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
>   fs/xfs/xfs_reflink.c           | 5 +++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index afb647e1e3fa..b99e67e7b59b 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -78,6 +78,15 @@ struct xfs_ifork {
>    */
>   #define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
>   
> +/*
> + * Moving an extent to data fork can cause a sub-interval of an existing extent
> + * to be unmapped. This will increase extent count by 1. Mapping in the new
> + * extent can increase the extent count by 1 again i.e.
> + * | Old extent | New extent | Old extent |
> + * Hence number of extents increases by 2.
> + */
> +#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
> +
>   /*
>    * Fork handling.
>    */
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 16098dc42add..4f0198f636ad 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -628,6 +628,11 @@ xfs_reflink_end_cow_extent(
>   	xfs_ilock(ip, XFS_ILOCK_EXCL);
>   	xfs_trans_ijoin(tp, ip, 0);
>   
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_REFLINK_END_COW_CNT);
> +	if (error)
> +		goto out_cancel;
> +
>   	/*
>   	 * In case of racing, overlapping AIO writes no COW extents might be
>   	 * left by the time I/O completes for the loser of the race.  In that
> 
