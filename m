Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1C6C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 20:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E0A20866
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 20:27:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gg7FWyuO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgHaU1E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 16:27:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39430 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgHaU1D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 16:27:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VKOHNp033630;
        Mon, 31 Aug 2020 20:26:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=irpaklGGtTP13x7ibnWoEpa7qrAtfjx1jC9v37AOysE=;
 b=gg7FWyuOH4skIxYb1w50HSgMgqrqlBV8xizgPmbA9bCdFLLAFpdyBHuLz20AS5yIGTsb
 /IzAHTuT6PTRa2WMWJTFZ59l9nkCS5jdbDIkMQh4gEMDjPSqWDp401CA1Q4JK0oZpO0E
 EMHI+mSf+erUXSdkuV2a7J9xEX9vtKL7jsL0Sn+BwpxpoTJ+argEfGK8DArjvm5bRaZ7
 ZnMUJQ1PanC5AI7n0LezhwUJ26nGtjkLmuodBx1dj9ukDr0h+HJRY/bjlGUl//Lmz3vP
 kNEa8f6PNbyD2TJ69z8TGXH+HlQQZexk/YfaYPx8rCxIefb/1/54R32LaSjNyoEqf7As mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 337eym0cuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 20:26:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VKKYJ2119243;
        Mon, 31 Aug 2020 20:26:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3380x1866j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 20:26:57 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VKQqkt022649;
        Mon, 31 Aug 2020 20:26:52 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 13:26:52 -0700
Date:   Mon, 31 Aug 2020 13:26:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs: simplify the xfs_buf_ioend_disposition
 calling convention
Message-ID: <20200831202656.GU6107@magnolia>
References: <20200830061512.1148591-1-hch@lst.de>
 <20200830061512.1148591-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200830061512.1148591-10-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 08:15:08AM +0200, Christoph Hellwig wrote:
> Now that all the actual error handling is in a single place,
> xfs_buf_ioend_disposition just needs to return true if took ownership of
> the buffer, or false if not instead of the tristate.  Also move the
> error check back in the caller to optimize for the fast path, and give
> the function a better fitting name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 36 +++++++++---------------------------
>  1 file changed, 9 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 951d9c35b3170c..13435cce2699e4 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1223,29 +1223,17 @@ xfs_buf_ioerror_permanent(
>   * If we get repeated async write failures, then we take action according to the
>   * error configuration we have been set up to use.
>   *
> - * Multi-state return value:
> - *
> - * XBF_IOEND_FINISH: run callback completions
> - * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
> - * XBF_IOEND_FAIL: transient error, run failure callback completions and then
> - *    release the buffer
> + * Returns true if this function took care of error handling and the caller must
> + * not touch the buffer again.  Return false if the caller should proceed with
> + * normal I/O completion handling.
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
> @@ -1291,18 +1279,18 @@ xfs_buf_ioend_disposition(
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
> @@ -1340,14 +1328,8 @@ xfs_buf_ioend(
>  			bp->b_flags |= XBF_DONE;
>  		}
>  
> -		switch (xfs_buf_ioend_disposition(bp)) {
> -		case XBF_IOEND_DONE:
> -			return;
> -		case XBF_IOEND_FAIL:
> +		if (unlikely(bp->b_error) && xfs_buf_ioend_handle_error(bp))
>  			return;
> -		default:
> -			break;
> -		}
>  
>  		/* clear the retry state */
>  		bp->b_last_error = 0;
> -- 
> 2.28.0
> 
