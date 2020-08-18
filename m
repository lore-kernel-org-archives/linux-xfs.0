Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA54C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B1F20674
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:42:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P4x0WBwn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHRWmz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:42:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59372 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgHRWmx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:42:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMGuLM111879;
        Tue, 18 Aug 2020 22:42:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=V9ho2t1TlpdQGhf21oW6M79N0+4PM7xNC3c+A2nQAbk=;
 b=P4x0WBwne5WQnUeeb+jiF0gH7J4mPfAhEdCPDlj7S5fsIKIEldJR+EBBpsOTq9zhI0SD
 qVLqmknai4EPkrM4TVFqJYgYfRXP0k/W4orOzwD0ehDvQirzEVkOg2/BUMODFYpxc0z8
 4frXr2svuNxK1t7RfrbYdR4kh8CUYG7nRickAWykFipne+0MVjo5fZn0nbPlpq6qWJiI
 9++vZK5fYoJA/KcrHGuVi7ah1CH4rmLsLQKnAmw9NwPmReqkeI/vd7Eh5ntgtKCXV400
 cu6w8EA54D5euCm0hl2vw6al/zRyFjSfUFxMEiVDahAE/N0l1KXsQ+xxB/pzTAsU0HUs Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32x8bn7ht6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:42:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMIwrm012757;
        Tue, 18 Aug 2020 22:42:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32xsmxsvsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:42:49 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IMgnPU027980;
        Tue, 18 Aug 2020 22:42:49 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:42:48 -0700
Date:   Tue, 18 Aug 2020 15:42:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/13] xfs: remove xfs_buf_ioerror_retry
Message-ID: <20200818224247.GH6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-8-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180160
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 05:04:47PM +0200, Christoph Hellwig wrote:
> Merge xfs_buf_ioerror_retry into its only caller to make the resubmission
> flow a little more obvious.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Not sure about obvious, but at least it's all together again... :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 33 ++++++++++++---------------------
>  1 file changed, 12 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 2f2ce3faab0826..e5592563dda6a1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1187,23 +1187,6 @@ xfs_buf_ioerror_alert_ratelimited(
>  	lasttarg = bp->b_target;
>  }
>  
> -static bool
> -xfs_buf_ioerror_retry(
> -	struct xfs_buf		*bp,
> -	struct xfs_error_cfg	*cfg)
> -{
> -	if ((bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) &&
> -	    bp->b_last_error == bp->b_error)
> -		return false;
> -
> -	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
> -	bp->b_last_error = bp->b_error;
> -	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
> -	    !bp->b_first_retry_time)
> -		bp->b_first_retry_time = jiffies;
> -	return true;
> -}
> -
>  /*
>   * Account for this latest trip around the retry handler, and decide if
>   * we've failed enough times to constitute a permanent failure.
> @@ -1283,10 +1266,13 @@ xfs_buf_ioend_disposition(
>  	trace_xfs_buf_iodone_async(bp, _RET_IP_);
>  
>  	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
> -	if (xfs_buf_ioerror_retry(bp, cfg)) {
> -		xfs_buf_ioerror(bp, 0);
> -		xfs_buf_submit(bp);
> -		return XBF_IOEND_DONE;
> +	if (bp->b_last_error != bp->b_error ||
> +	    !(bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL))) {
> +		bp->b_last_error = bp->b_error;
> +		if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
> +		    !bp->b_first_retry_time)
> +			bp->b_first_retry_time = jiffies;
> +		goto resubmit;
>  	}
>  
>  	/*
> @@ -1301,6 +1287,11 @@ xfs_buf_ioend_disposition(
>  	/* Still considered a transient error. Caller will schedule retries. */
>  	return XBF_IOEND_FAIL;
>  
> +resubmit:
> +	xfs_buf_ioerror(bp, 0);
> +	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
> +	xfs_buf_submit(bp);
> +	return XBF_IOEND_DONE;
>  out_stale:
>  	xfs_buf_stale(bp);
>  	bp->b_flags |= XBF_DONE;
> -- 
> 2.26.2
> 
