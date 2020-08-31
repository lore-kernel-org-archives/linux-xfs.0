Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E1FC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8023F20707
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:47:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lG4a0Ve3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgHaQrH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:47:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37242 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgHaQrG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:47:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGcrMw177664;
        Mon, 31 Aug 2020 16:47:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ohz+xeCnR9gAmyMHgNNFCxLPyqRBxEzV53WFVCmDa7c=;
 b=lG4a0Ve3uR0TY8UEGclNvgltzmBTlRdpZl6THRR+1e3gVLt8v5mkbtzqu78SHozAmH4L
 0oF2VymbL8q8kG6ZmzyR06eqVTKyGdTspmHL8V3qXHxz+kO9YsAEjLcqgBy/bo8wIDqC
 v3Ts2UNpIVOC1MwvFi9cyCGqdFAMdJtHc58uWcCrQe9eBINTAzk4TEFfZWiER9hZ/sXp
 ZJWtnQDLry5ekB60nb8MJPzFo8GUV+pVnVNJVqDw8seSED2PPrUZuO3Ik+7zjf7ozE2W
 x48o7WAmflD83SD9IkeuiqxClLu1LkGQ0sElHLEJRSX9zsMUVADummwHLVRDjgRANKyA Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 337eeqqbud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 16:47:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGeaxs129815;
        Mon, 31 Aug 2020 16:45:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3380x0qb9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:45:01 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VGj0Ne004685;
        Mon, 31 Aug 2020 16:45:00 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 09:45:00 -0700
Date:   Mon, 31 Aug 2020 09:45:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 06/10] xfs: Check for extent overflow when writing to
 unwritten extent
Message-ID: <20200831164503.GP6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
 <20200820054349.5525-7-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820054349.5525-7-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310100
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 11:13:45AM +0530, Chandan Babu R wrote:
> A write to a sub-interval of an existing unwritten extent causes
> the original extent to be split into 3 extents
> i.e. | Unwritten | Real | Unwritten |
> Hence extent count can increase by 2.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Seems fine to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_fork.h | 7 +++++++
>  fs/xfs/xfs_iomap.c             | 5 +++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index f686c7418d2b..83ff90e2a5fe 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -66,6 +66,13 @@ struct xfs_ifork {
>   */
>  #define XFS_IEXT_DIR_MANIP_CNT(mp) \
>  	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
> +/*
> + * A write to a sub-interval of an existing unwritten extent causes the original
> + * extent to be split into 3 extents
> + * i.e. | Unwritten | Real | Unwritten |
> + * Hence extent count can increase by 2.
> + */
> +#define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
>  
>  /*
>   * Fork handling.
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 37b0c743c116..694b25fbb4a3 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -566,6 +566,11 @@ xfs_iomap_write_unwritten(
>  		if (error)
>  			goto error_on_bmapi_transaction;
>  
> +		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +				XFS_IEXT_WRITE_UNWRITTEN_CNT);
> +		if (error)
> +			goto error_on_bmapi_transaction;
> +
>  		/*
>  		 * Modify the unwritten extent state of the buffer.
>  		 */
> -- 
> 2.28.0
> 
