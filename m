Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEC7C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4903520663
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:56:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bL6vYsX4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgCLO4u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:56:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37258 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgCLO4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:56:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEhhCw110502;
        Thu, 12 Mar 2020 14:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9WcHTGtgj12vivSWZYwUHHBoNGhFIOPmbz4K1aGY3Cw=;
 b=bL6vYsX4Qvdo0N3gryBnP/HJqb3Yk8JlzXA8tD3h/KY5ywTmpsS5SsAd0F7QuOQBcnCP
 Pm2XB5xPZyTFKDXrRK80bp7nq8muXk9ELN1kZI3dAkJImnhVZHdvEHrqUrlf75vjV1Ob
 JlZblfEOP8re5B4QS2ZuT4FOssprOmCLOOsXl2FjkgDzqj8/GIqRNBjZ8qOC7WW+b0w+
 oHO5MlJI9lDAlIY6ZYohmTnHwYlCFm8C15VZpk1sV0kI+T72/Dlw6qcI11krLcGHytw6
 I5q0bMUv8kHicT3bbEjtAZ7LlBA4LkpNai1BI8Oooc2YaBFhn+jTuRnps/BHcsj9f2q8 +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yqkg898sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:56:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEoRp3002885;
        Thu, 12 Mar 2020 14:56:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2yqkvmtjtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:56:45 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02CEuiUC001246;
        Thu, 12 Mar 2020 14:56:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 07:56:44 -0700
Date:   Thu, 12 Mar 2020 07:56:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] libxfs: remove libxfs_iomove
Message-ID: <20200312145643.GO8045@magnolia>
References: <20200312141715.550387-1-hch@lst.de>
 <20200312141715.550387-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312141715.550387-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120080
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:17:15PM +0100, Christoph Hellwig wrote:
> This function has been removed in the kernel already.  Replace the only
> user that want to zero buffers with a straight call to memset.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  libxfs/libxfs_io.h   |  6 ------
>  libxfs/libxfs_priv.h |  5 ++---
>  libxfs/rdwr.c        | 24 ------------------------
>  3 files changed, 2 insertions(+), 33 deletions(-)

woot,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index a0605882..0f682305 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -213,12 +213,6 @@ extern int	libxfs_device_zero(struct xfs_buftarg *, xfs_daddr_t, uint);
>  
>  extern int libxfs_bhash_size;
>  
> -#define LIBXFS_BREAD	0x1
> -#define LIBXFS_BWRITE	0x2
> -#define LIBXFS_BZERO	0x4
> -
> -extern void	libxfs_iomove (xfs_buf_t *, uint, int, void *, int);
> -
>  static inline int
>  xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  {
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index d07d8f32..b5677a22 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -374,9 +374,8 @@ static inline struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
>  	return NULL;
>  }
>  
> -#define XBRW_READ			LIBXFS_BREAD
> -#define XBRW_WRITE			LIBXFS_BWRITE
> -#define xfs_buf_zero(bp,off,len)     libxfs_iomove(bp,off,len,NULL,LIBXFS_BZERO)
> +#define xfs_buf_zero(bp, off, len) \
> +	memset((bp)->b_addr + off, 0, len);
>  
>  /* mount stuff */
>  #define XFS_MOUNT_32BITINODES		LIBXFS_MOUNT_32BITINODES
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 7430ff09..6a9895f1 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1009,30 +1009,6 @@ libxfs_buf_mark_dirty(
>  	bp->b_flags |= LIBXFS_B_DIRTY;
>  }
>  
> -void
> -libxfs_iomove(xfs_buf_t *bp, uint boff, int len, void *data, int flags)
> -{
> -#ifdef IO_DEBUG
> -	if (boff + len > bp->b_bcount) {
> -		printf("Badness, iomove out of range!\n"
> -			"bp=(bno 0x%llx, bytes %u) range=(boff %u, bytes %u)\n",
> -			(long long)bp->b_bn, bp->b_bcount, boff, len);
> -		abort();
> -	}
> -#endif
> -	switch (flags) {
> -	case LIBXFS_BZERO:
> -		memset(bp->b_addr + boff, 0, len);
> -		break;
> -	case LIBXFS_BREAD:
> -		memcpy(data, bp->b_addr + boff, len);
> -		break;
> -	case LIBXFS_BWRITE:
> -		memcpy(bp->b_addr + boff, data, len);
> -		break;
> -	}
> -}
> -
>  /* Complain about (and remember) dropping dirty buffers. */
>  static void
>  libxfs_whine_dirty_buf(
> -- 
> 2.24.1
> 
