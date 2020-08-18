Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C71C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 967E0207BB
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c8GAtxJv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHRWkh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60450 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgHRWkd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:40:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMGFH7135019;
        Tue, 18 Aug 2020 22:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=WEMPeX7g+KPNqPz94D4r0ADlZqc2tpcepGujO27ORQg=;
 b=c8GAtxJvjXA8ztHeGHIv+UlBLcSX3w0yMuG+GDm2O2oybXgrHONaruADg3cntfQDQYDP
 PNNGD6DFtnq5XafYBXRTrmZd0zqziisDY32t/ZWvW7Vgfcs9CnFFedPwI3AWJXPqU8FR
 69isW3J1PvXWeJOowHl4owvwNUj2cpKvxwegpuomAbIuj34VzlsX57LiXitGGrE7+bhI
 fiZkNHSSeq/Nkedias7YvrZzUgImVmv+EmxghCrMnTS7j1AEl8bpyIe59ugFcgf8Kio3
 HSlg0f1jIvNBcZJvE88aGV2Z3pYpX5eT4qgyKjrkVkPxla/oK2I9UCGlD3Humct/fdjh 5w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32x74r7n4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:40:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMHj8G056175;
        Tue, 18 Aug 2020 22:40:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 330pvhm8ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:40:27 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IMeQKq026909;
        Tue, 18 Aug 2020 22:40:26 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:40:26 -0700
Date:   Tue, 18 Aug 2020 15:40:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: fold xfs_buf_ioend_finish into xfs_ioend
Message-ID: <20200818224024.GF6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-6-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180160
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 05:04:45PM +0200, Christoph Hellwig wrote:
> No need to keep a separate helper for this logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c         | 8 +++++---
>  fs/xfs/xfs_buf.h         | 7 -------
>  fs/xfs/xfs_log_recover.c | 1 -
>  3 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 443d11bdfcf502..e6a73e455caa1a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1335,7 +1335,6 @@ xfs_buf_ioend(
>  			bp->b_ops->verify_read(bp);
>  		if (!bp->b_error)
>  			bp->b_flags |= XBF_DONE;
> -		xfs_buf_ioend_finish(bp);
>  	} else if (bp->b_flags & _XBF_LOGRECOVERY) {
>  		/*
>  		 * If this is a log recovery buffer, we aren't doing
> @@ -1383,9 +1382,12 @@ xfs_buf_ioend(
>  			xfs_buf_inode_iodone(bp);
>  		else if (bp->b_flags & _XBF_DQUOTS)
>  			xfs_buf_dquot_iodone(bp);
> -
> -		xfs_buf_ioend_finish(bp);
>  	}
> +
> +	if (bp->b_flags & XBF_ASYNC)
> +		xfs_buf_relse(bp);
> +	else
> +		complete(&bp->b_iowait);
>  }
>  
>  static void
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index bea20d43a38191..9eb4044597c985 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -269,13 +269,6 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
>  
>  /* Buffer Read and Write Routines */
>  extern int xfs_bwrite(struct xfs_buf *bp);
> -static inline void xfs_buf_ioend_finish(struct xfs_buf *bp)
> -{
> -	if (bp->b_flags & XBF_ASYNC)
> -		xfs_buf_relse(bp);
> -	else
> -		complete(&bp->b_iowait);
> -}
>  
>  extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
>  		xfs_failaddr_t failaddr);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index cf6dabb98f2327..741a2c247bc585 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -288,7 +288,6 @@ xlog_recover_iodone(
>  		xfs_buf_item_relse(bp);
>  	ASSERT(bp->b_log_item == NULL);
>  	bp->b_flags &= ~_XBF_LOGRECOVERY;
> -	xfs_buf_ioend_finish(bp);
>  }
>  
>  /*
> -- 
> 2.26.2
> 
