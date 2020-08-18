Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A4AC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F7CA20786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:55:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iG789MJN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgHRWz2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:55:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57652 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgHRWz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:55:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMpU6N096018;
        Tue, 18 Aug 2020 22:55:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AXzq4GHlluzvH5Y547szygUNW7ksVsPZlLlPitiKdaQ=;
 b=iG789MJN+s0qwXmh/3xU5oqQXSddg99vqNgBDPiRJYWtSaHnnK7EfKdtv90dm0jnZ7hf
 XpORLDT+wKZlQfG+CUN7MWBlPk98LRGVM5U2owE/2hVPvtLrb4hwB13llbbtx+Mv/ERA
 wGKXmHOxyW0cvOmGVJOHc0hVMPaxzOZf22HeVVJONxQBp5ynILkHN/EH1qDcne43V7st
 hWgbN6M54SpZye/TLm+esP3bmvN3QCW+VPMSV6rIIRgo1NpTj+nLe+kHo6+++GHJ54ak
 GyxrJpM9kOlInAjGPtTli/EmjaoT+Q/XLdli9AZS2FSp6XFAhqkmBfzTlpb0ZMb2z8to tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32x7nmfnbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:55:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMsE0w130371;
        Tue, 18 Aug 2020 22:55:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32xs9ng8hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:55:23 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IMtMvo022180;
        Tue, 18 Aug 2020 22:55:22 GMT
Received: from localhost (/10.159.129.94) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Tue, 18 Aug 2020 15:54:06 -0700
MIME-Version: 1.0
Message-ID: <20200818225405.GL6096@magnolia>
Date:   Tue, 18 Aug 2020 15:54:05 -0700 (PDT)
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/13] xfs: clear the read/write flags later in
 xfs_buf_ioend
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-12-hch@lst.de>
In-Reply-To: <20200709150453.109230-12-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180161
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

On Thu, Jul 09, 2020 at 05:04:51PM +0200, Christoph Hellwig wrote:
> Clear the flags at the end of xfs_buf_ioend so that they can be used
> during the completion.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fairly straightforward...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 4a9034a9175504..8bbd28f39a927b 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1281,12 +1281,13 @@ xfs_buf_ioend_handle_error(
>  
>  resubmit:
>  	xfs_buf_ioerror(bp, 0);
> -	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
> +	bp->b_flags |= (XBF_DONE | XBF_WRITE_FAIL);
>  	xfs_buf_submit(bp);
>  	return true;
>  out_stale:
>  	xfs_buf_stale(bp);
>  	bp->b_flags |= XBF_DONE;
> +	bp->b_flags &= ~XBF_WRITE;
>  	trace_xfs_buf_error_relse(bp, _RET_IP_);
>  	return false;
>  }
> @@ -1295,12 +1296,8 @@ static void
>  xfs_buf_ioend(
>  	struct xfs_buf	*bp)
>  {
> -	bool		read = bp->b_flags & XBF_READ;
> -
>  	trace_xfs_buf_iodone(bp, _RET_IP_);
>  
> -	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
> -
>  	/*
>  	 * Pull in IO completion errors now. We are guaranteed to be running
>  	 * single threaded, so we don't need the lock to read b_io_error.
> @@ -1308,7 +1305,7 @@ xfs_buf_ioend(
>  	if (!bp->b_error && bp->b_io_error)
>  		xfs_buf_ioerror(bp, bp->b_io_error);
>  
> -	if (read) {
> +	if (bp->b_flags & XBF_READ) {
>  		if (!bp->b_error && bp->b_ops)
>  			bp->b_ops->verify_read(bp);
>  		if (!bp->b_error)
> @@ -1348,6 +1345,8 @@ xfs_buf_ioend(
>  			xfs_buf_dquot_iodone(bp);
>  	}
>  
> +	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
> +
>  	if (bp->b_flags & XBF_ASYNC)
>  		xfs_buf_relse(bp);
>  	else
> -- 
> 2.26.2
> 
