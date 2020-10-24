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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001E1C4363A
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 19:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B270E22276
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 19:31:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="su6v1Wsg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764055AbgJXTbH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 15:31:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44652 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760388AbgJXTbH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 15:31:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OJUg4C028447;
        Sat, 24 Oct 2020 19:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OTSgEnbYdSh59WR0AKbYrIsgihsJeU27CNMQpb58E8Q=;
 b=su6v1WsgVb2/4pW2GuzPt18QT7lGxx7t/nEqB5eN7XMnQJv3Byt73vrKSvIsKIjFa6WE
 vD2iquz/1CK7N70X9mehDC6Koc5VLe8Xg5j1RAJ2z/g6Vmbm+QapIwgXhGE+M2H6ibgX
 vU07fYQa61itX1cayC/AYh5yOSG/Oi7qRsutAKtwP04VV6UHY5ysobNC47hwwUWGOPPb
 tmzQ2Jg24E+H3+0wtUiQwoHOY+aqIOroSeFF9zeJ4lEmSB6vQrQmkU7r3pHpwKG0NyXx
 bCUKrHEx57G3i9rpYZjZjQ51oH5kzX3AXmvXBbQFvw8U7NMf8Jafxd5XdpsWn6Ye4FBj YA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34ccwmh1f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 19:30:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OJK5xV052248;
        Sat, 24 Oct 2020 19:28:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cbkhn76a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 19:28:58 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09OJSveY027551;
        Sat, 24 Oct 2020 19:28:57 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 12:28:57 -0700
Subject: Re: [PATCH V7 03/14] xfs: Check for extent overflow when punching a
 hole
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-4-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <0800d156-8b76-d659-5523-373f5f2b78ce@oracle.com>
Date:   Sat, 24 Oct 2020 12:28:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-4-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9784 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 malwarescore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010240149
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/18/20 11:40 PM, Chandan Babu R wrote:
> The extent mapping the file offset at which a hole has to be
> inserted will be split into two extents causing extent count to
> increase by 1.
> 
Looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
>   fs/xfs/xfs_bmap_item.c         | 15 +++++++++------
>   fs/xfs/xfs_bmap_util.c         | 10 ++++++++++
>   3 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 7fc2b129a2e7..bcac769a7df6 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -40,6 +40,13 @@ struct xfs_ifork {
>    */
>   #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
>   
> +/*
> + * Punching out an extent from the middle of an existing extent can cause the
> + * extent count to increase by 1.
> + * i.e. | Old extent | Hole | Old extent |
> + */
> +#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
> +
>   /*
>    * Fork handling.
>    */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 1610d6ad089b..80d828394158 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -439,6 +439,7 @@ xfs_bui_item_recover(
>   	xfs_exntst_t			state;
>   	unsigned int			bui_type;
>   	int				whichfork;
> +	int				iext_delta;
>   	int				error = 0;
>   
>   	/* Only one mapping operation per BUI... */
> @@ -497,12 +498,14 @@ xfs_bui_item_recover(
>   	xfs_ilock(ip, XFS_ILOCK_EXCL);
>   	xfs_trans_ijoin(tp, ip, 0);
>   
> -	if (bui_type == XFS_BMAP_MAP) {
> -		error = xfs_iext_count_may_overflow(ip, whichfork,
> -				XFS_IEXT_ADD_NOSPLIT_CNT);
> -		if (error)
> -			goto err_cancel;
> -	}
> +	if (bui_type == XFS_BMAP_MAP)
> +		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
> +	else
> +		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
> +
> +	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
> +	if (error)
> +		goto err_cancel;
>   
>   	count = bmap->me_len;
>   	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index dcd6e61df711..0776abd0103c 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -891,6 +891,11 @@ xfs_unmap_extent(
>   
>   	xfs_trans_ijoin(tp, ip, 0);
>   
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_PUNCH_HOLE_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>   	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
>   	if (error)
>   		goto out_trans_cancel;
> @@ -1176,6 +1181,11 @@ xfs_insert_file_space(
>   	xfs_ilock(ip, XFS_ILOCK_EXCL);
>   	xfs_trans_ijoin(tp, ip, 0);
>   
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +			XFS_IEXT_PUNCH_HOLE_CNT);
> +	if (error)
> +		goto out_trans_cancel;
> +
>   	/*
>   	 * The extent shifting code works on extent granularity. So, if stop_fsb
>   	 * is not the starting block of extent, we need to split the extent at
> 
