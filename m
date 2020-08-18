Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68746C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 445F62078D
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:41:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lrxsyoI0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgHRWlL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:41:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60774 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgHRWlL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:41:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMH0ia135301;
        Tue, 18 Aug 2020 22:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5DotZ0Y7PqxftceMUhAMp4KXraJ/1VsOscYDZDu9lM0=;
 b=lrxsyoI0PcCCh3TqLc2rv0r7ydE4VKgK6MIH4QtmW7kWE2J97xrmhDepyzAx9ElygRo3
 Jk6yksNzYEvhDgHeq1uC5uNsIEhjyXpI3U7cVQ/QAMetkIb2+TNF7YSFDD+sAPVtpZRm
 tXw5rO8IAsbVSTohqhlEQu5919rr5waq/kwOL3dEgr5LPwWizJGMJi02AG4va5fQIYWK
 DB07NsCXjM5zgku7WGguVADlVkB5r0uEJ2LwBkEGhjW2WWrUHkmJLckY3x1RIh/4QyVZ
 xXedmy2syLQIeGFQoLnNRmfzveAgDt826t3RQzrtYzyTKovtDAwO6xYCBlx2+O8AsFOA bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74r7n6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:41:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMIwOq012784;
        Tue, 18 Aug 2020 22:41:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32xsmxsud3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:41:07 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IMf6KY030594;
        Tue, 18 Aug 2020 22:41:06 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:41:06 -0700
Date:   Tue, 18 Aug 2020 15:41:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/13] xfs: refactor xfs_buf_ioerror_fail_without_retry
Message-ID: <20200818224104.GG6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-7-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
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

On Thu, Jul 09, 2020 at 05:04:46PM +0200, Christoph Hellwig wrote:
> xfs_buf_ioerror_fail_without_retry is a somewhat weird function in
> that it has two trivial checks that decide the return value, while
> the rest implements a ratelimited warning.  Just lift the two checks
> into the caller, and give the remainder a suitable name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Pretty straightforward,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 35 +++++++++++++++--------------------
>  1 file changed, 15 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index e6a73e455caa1a..2f2ce3faab0826 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1172,36 +1172,19 @@ xfs_buf_wait_unpin(
>  	set_current_state(TASK_RUNNING);
>  }
>  
> -/*
> - * Decide if we're going to retry the write after a failure, and prepare
> - * the buffer for retrying the write.
> - */
> -static bool
> -xfs_buf_ioerror_fail_without_retry(
> +static void
> +xfs_buf_ioerror_alert_ratelimited(
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_mount	*mp = bp->b_mount;
>  	static unsigned long	lasttime;
>  	static struct xfs_buftarg *lasttarg;
>  
> -	/*
> -	 * If we've already decided to shutdown the filesystem because of
> -	 * I/O errors, there's no point in giving this a retry.
> -	 */
> -	if (XFS_FORCED_SHUTDOWN(mp))
> -		return true;
> -
>  	if (bp->b_target != lasttarg ||
>  	    time_after(jiffies, (lasttime + 5*HZ))) {
>  		lasttime = jiffies;
>  		xfs_buf_ioerror_alert(bp, __this_address);
>  	}
>  	lasttarg = bp->b_target;
> -
> -	/* synchronous writes will have callers process the error */
> -	if (!(bp->b_flags & XBF_ASYNC))
> -		return true;
> -	return false;
>  }
>  
>  static bool
> @@ -1282,7 +1265,19 @@ xfs_buf_ioend_disposition(
>  	if (likely(!bp->b_error))
>  		return XBF_IOEND_FINISH;
>  
> -	if (xfs_buf_ioerror_fail_without_retry(bp))
> +	/*
> +	 * If we've already decided to shutdown the filesystem because of I/O
> +	 * errors, there's no point in giving this a retry.
> +	 */
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		goto out_stale;
> +
> +	xfs_buf_ioerror_alert_ratelimited(bp);
> +
> +	/*
> +	 * Synchronous writes will have callers process the error.
> +	 */
> +	if (!(bp->b_flags & XBF_ASYNC))
>  		goto out_stale;
>  
>  	trace_xfs_buf_iodone_async(bp, _RET_IP_);
> -- 
> 2.26.2
> 
