Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589E0C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31E6B20709
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:31:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j1gl8qij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgHRWba (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:31:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgHRWba (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:31:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMHYDC045819;
        Tue, 18 Aug 2020 22:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Q5u2bk3quenwRdziMDBqOT51fbj9H+3x4Jat7sPfUcY=;
 b=j1gl8qijUgrTjqCbVFNuithZpDhVZj6Rik9E/78UPzuvc/nNw7ThaUt9pA3BNL5Kl7ZJ
 jTms8N9TZFf34jXtJaiQfoGGw9jeBzF/D1nZw72tj3NiQWQYVOGvH9zZbmqw3dYFdoAR
 Do6Vkv0SdocjORl6kbG8ptQ3pelufTXCZ8EKEmB2Sg2hKXPmT9w75ct4jcrHSaWxWh75
 +44WLxx5LsMm5HEXylInCcMEwJ0s86sLkeaxHOUKgkOkCov+TJNiOLpLqNENVWL0Scke
 hxpmmvul/05BfL3uyrBWZNeZsL84W3VlbziOG+p6Jp8NTBffrXVTFe9ISIov7m7EF8h+ bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32x7nmfk9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:31:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMHjjo056131;
        Tue, 18 Aug 2020 22:31:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 330pvhkpu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:31:26 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IMVPDt025386;
        Tue, 18 Aug 2020 22:31:25 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:31:25 -0700
Date:   Tue, 18 Aug 2020 15:31:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs: refactor xfs_buf_ioend
Message-ID: <20200818223123.GD6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-4-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180160
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 05:04:43PM +0200, Christoph Hellwig wrote:
> Refactor the logic for the different I/O completions to prepare for
> more code sharing.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think it's worth mentioning in the commit log that this patch leaves
the log recovery buffer completion code totally in charge of the buffer
state.  Not sure where exactly that part is going, though I guess your
eventual goal is to remove xlog_recover_iodone (and clean up the buffer
log item disposal)...?

If so,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c         | 41 +++++++++++++++++-----------------------
>  fs/xfs/xfs_log_recover.c | 14 +++++++-------
>  2 files changed, 24 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1bce6457a9b943..7c22d63f43f754 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1199,33 +1199,26 @@ xfs_buf_ioend(
>  		if (!bp->b_error)
>  			bp->b_flags |= XBF_DONE;
>  		xfs_buf_ioend_finish(bp);
> -		return;
> -	}
> -
> -	if (!bp->b_error) {
> -		bp->b_flags &= ~XBF_WRITE_FAIL;
> -		bp->b_flags |= XBF_DONE;
> -	}
> -
> -	/*
> -	 * If this is a log recovery buffer, we aren't doing transactional IO
> -	 * yet so we need to let it handle IO completions.
> -	 */
> -	if (bp->b_flags & _XBF_LOGRECOVERY) {
> +	} else if (bp->b_flags & _XBF_LOGRECOVERY) {
> +		/*
> +		 * If this is a log recovery buffer, we aren't doing
> +		 * transactional I/O yet so we need to let the log recovery code
> +		 * handle I/O completions:
> +		 */
>  		xlog_recover_iodone(bp);
> -		return;
> -	}
> -
> -	if (bp->b_flags & _XBF_INODES) {
> -		xfs_buf_inode_iodone(bp);
> -		return;
> -	}
> +	} else {
> +		if (!bp->b_error) {
> +			bp->b_flags &= ~XBF_WRITE_FAIL;
> +			bp->b_flags |= XBF_DONE;
> +		}
>  
> -	if (bp->b_flags & _XBF_DQUOTS) {
> -		xfs_buf_dquot_iodone(bp);
> -		return;
> +		if (bp->b_flags & _XBF_INODES)
> +			xfs_buf_inode_iodone(bp);
> +		else if (bp->b_flags & _XBF_DQUOTS)
> +			xfs_buf_dquot_iodone(bp);
> +		else
> +			xfs_buf_iodone(bp);
>  	}
> -	xfs_buf_iodone(bp);
>  }
>  
>  static void
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 52a65a74208ffe..cf6dabb98f2327 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -269,15 +269,15 @@ void
>  xlog_recover_iodone(
>  	struct xfs_buf	*bp)
>  {
> -	if (bp->b_error) {
> +	if (!bp->b_error) {
> +		bp->b_flags |= XBF_DONE;
> +	} else if (!XFS_FORCED_SHUTDOWN(bp->b_mount)) {
>  		/*
> -		 * We're not going to bother about retrying
> -		 * this during recovery. One strike!
> +		 * We're not going to bother about retrying this during
> +		 * recovery. One strike!
>  		 */
> -		if (!XFS_FORCED_SHUTDOWN(bp->b_mount)) {
> -			xfs_buf_ioerror_alert(bp, __this_address);
> -			xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
> -		}
> +		xfs_buf_ioerror_alert(bp, __this_address);
> +		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
>  	}
>  
>  	/*
> -- 
> 2.26.2
> 
