Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FC1C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71BF420786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:52:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FNp1YXH7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgHRWw0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:52:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56012 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgHRWwZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:52:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMpRlZ095963;
        Tue, 18 Aug 2020 22:52:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+IkZSUGalySRAaMjP2ptMw82JAmCv4/aK8jOJpCJ4cY=;
 b=FNp1YXH7fGqfHghxqlvafx0PD6hdG/YcnQlSrbGLXGz3IaWwaRh3ZgvCUPxw8RzFN9+3
 hnKX0oQz1SGsX4uIsV5r+vqVqmGdMlFhTEZIhQfTjLtel9h7C/kyL0+69eE4EPb/oYeW
 hFdNUs7/HJF9hzcD4qme0GNV7h7GP7P1o25BGowZiRXYXp+X69foM+R0cURyqxi6gYep
 Jj0Vdb9ylkVgPjXZVRdb2/DR22LVKOaq6w5f9Mm5mP51x7Q87by8CKFrjKe3Ldmpfq9J
 RUt0e++Uax9lZnFkER4u7+DCbF2e8dikz7ECzim2kARqlFp9YdiMugh9qPa03LzE5lAc 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32x7nmfn2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:52:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMIFTK006280;
        Tue, 18 Aug 2020 22:52:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32xsfsehx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:52:19 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IMqI9h021149;
        Tue, 18 Aug 2020 22:52:18 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:52:18 -0700
Date:   Tue, 18 Aug 2020 15:52:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: simplify the xfs_buf_ioend_disposition
 calling convention
Message-ID: <20200818225216.GJ6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-10-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 05:04:49PM +0200, Christoph Hellwig wrote:
> Now that all the actual error handling is in a single place,
> xfs_buf_ioend_disposition just needs to return true if took ownership of
> the buffer, or false if not instead of the tristate.  Also move the

Could you capture the meaning of the return values in the comment prior
to xfs_buf_ioend_handle_error, please?  It took me a while to figure out
that "return false" means that the caller owns the buffer and log items
attached to it and needs to clear all the state that we set up for the
buffer write; and that this is true even for buffers that we just
permanent-failed.

Otherwise, this looks fairly straightforward to me.

--D

> error check back in the caller to optimize for the fast path, and give
> the function a better fitting name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 34 ++++++----------------------------
>  1 file changed, 6 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e3e80615c5ed9e..4a9034a9175504 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1224,30 +1224,14 @@ xfs_buf_ioerror_permanent(
>   *
>   * If we get repeated async write failures, then we take action according to the
>   * error configuration we have been set up to use.
> - *
> - * Multi-state return value:
> - *
> - * XBF_IOEND_FINISH: run callback completions
> - * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
> - * XBF_IOEND_FAIL: transient error, run failure callback completions and then
> - *    release the buffer
>   */
> -enum xfs_buf_ioend_disposition {
> -	XBF_IOEND_FINISH,
> -	XBF_IOEND_DONE,
> -	XBF_IOEND_FAIL,
> -};
> -
> -static enum xfs_buf_ioend_disposition
> -xfs_buf_ioend_disposition(
> +static bool
> +xfs_buf_ioend_handle_error(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_error_cfg	*cfg;
>  
> -	if (likely(!bp->b_error))
> -		return XBF_IOEND_FINISH;
> -
>  	/*
>  	 * If we've already decided to shutdown the filesystem because of I/O
>  	 * errors, there's no point in giving this a retry.
> @@ -1293,18 +1277,18 @@ xfs_buf_ioend_disposition(
>  		ASSERT(list_empty(&bp->b_li_list));
>  	xfs_buf_ioerror(bp, 0);
>  	xfs_buf_relse(bp);
> -	return XBF_IOEND_FAIL;
> +	return true;
>  
>  resubmit:
>  	xfs_buf_ioerror(bp, 0);
>  	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
>  	xfs_buf_submit(bp);
> -	return XBF_IOEND_DONE;
> +	return true;
>  out_stale:
>  	xfs_buf_stale(bp);
>  	bp->b_flags |= XBF_DONE;
>  	trace_xfs_buf_error_relse(bp, _RET_IP_);
> -	return XBF_IOEND_FINISH;
> +	return false;
>  }
>  
>  static void
> @@ -1342,14 +1326,8 @@ xfs_buf_ioend(
>  			bp->b_flags |= XBF_DONE;
>  		}
>  
> -		switch (xfs_buf_ioend_disposition(bp)) {
> -		case XBF_IOEND_DONE:
> +		if (unlikely(bp->b_error) && xfs_buf_ioend_handle_error(bp))
>  			return;
> -		case XBF_IOEND_FAIL:
> -			return;
> -		default:
> -			break;
> -		}
>  
>  		/* clear the retry state */
>  		bp->b_last_error = 0;
> -- 
> 2.26.2
> 
