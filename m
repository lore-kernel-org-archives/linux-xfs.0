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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49EE7C4363A
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F296B22276
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 20:19:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AxT7HE9L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762265AbgJXUTF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Oct 2020 16:19:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47098 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761257AbgJXUTF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Oct 2020 16:19:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKIrFp102313;
        Sat, 24 Oct 2020 20:18:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QY3s7ZKnH8Rz6u0XxryCrucVWcxCa8o/LAyABlmbQ9U=;
 b=AxT7HE9Li7F+F949RmPOoKJL0jYbVZoCbHXtAIOdp3xtPQNc8lbU1yBv6Z0ejWxxak1S
 bnaaRB7BE/g7EG3aPOc/KM1RQ31duE5Hi3eU3DKPGN+uA4arF10bChtdcT1XhexoqL5Y
 NWyHsbjvoSjzmXGOO0JAp3FaUwqBukqzdJLbnsXCqv4eAh7sAWrLXMQlPTzWfg8T17VJ
 /RMlqKJMKfiAtpQkLsQfLvqu2Jz6xEycLImdjGaZkeQfunj14SuE3GarCoSJQ+vcz0CX
 NL1t9Tzz8LJ04GQv4c/WxTCKePgwu5hLgIHIqXsaFSaIobo2IfQMeVZY18gV/77TQ97T Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34ccwmh2ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Oct 2020 20:18:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09OKFnPu064044;
        Sat, 24 Oct 2020 20:18:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cc2ym2mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 20:18:52 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09OKIpgt021066;
        Sat, 24 Oct 2020 20:18:51 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 24 Oct 2020 13:18:51 -0700
Subject: Re: [PATCH V7 06/14] xfs: Check for extent overflow when writing to
 unwritten extent
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-7-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <7a3778d3-5623-38a7-387b-18e159ad61f1@oracle.com>
Date:   Sat, 24 Oct 2020 13:18:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201019064048.6591-7-chandanrlinux@gmail.com>
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
> A write to a sub-interval of an existing unwritten extent causes
> the original extent to be split into 3 extents
> i.e. | Unwritten | Real | Unwritten |
> Hence extent count can increase by 2.
> 
Looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>   fs/xfs/libxfs/xfs_inode_fork.h | 8 ++++++++
>   fs/xfs/xfs_iomap.c             | 5 +++++
>   2 files changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index fd93fdc67ee4..afb647e1e3fa 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -70,6 +70,14 @@ struct xfs_ifork {
>   #define XFS_IEXT_DIR_MANIP_CNT(mp) \
>   	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
>   
> +/*
> + * A write to a sub-interval of an existing unwritten extent causes the original
> + * extent to be split into 3 extents
> + * i.e. | Unwritten | Real | Unwritten |
> + * Hence extent count can increase by 2.
> + */
> +#define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
> +
>   /*
>    * Fork handling.
>    */
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index a302a96823b8..2aa788379611 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -566,6 +566,11 @@ xfs_iomap_write_unwritten(
>   		if (error)
>   			goto error_on_bmapi_transaction;
>   
> +		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +				XFS_IEXT_WRITE_UNWRITTEN_CNT);
> +		if (error)
> +			goto error_on_bmapi_transaction;
> +
>   		/*
>   		 * Modify the unwritten extent state of the buffer.
>   		 */
> 
