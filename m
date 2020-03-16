Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B18AC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 20:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0657920674
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 20:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V/uK4T8+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732505AbgCPUd2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 16:33:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53928 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732486AbgCPUd2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 16:33:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKMjTD088885;
        Mon, 16 Mar 2020 20:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LuAy0sj6NlvQUOU5Qyyx+O8SrAchA0zXZoEGW5ts5TY=;
 b=V/uK4T8+lXVVuaOeLWfAlFVeQfWrJTFJSDXvd/RRXkab3bXRCEzqfMItuJXxv2E/ec/q
 dJZAbbSeZ7ezxWzSaq11q/rTLwKQVKC9sWg+c9KOp96hly63LAqYhprKWxq2ZiQuodzJ
 5Di80A0dHtT9jyZNmqprrwd//yvvEii2HbSE/YIAoWxs5lfiw8Og5Dfd4yMDnijswN1e
 jFGkOdJc8eKw2Co5mOwIAa7BxF2IomY2W6/FJkyOtGk0cejd8uWi6VOKwSe0/9EDv+6r
 SIf8NRAIjm3Of521vIFKmZKX8q9o1FkymjQik6s47K8oFfkwhbp/cMcI1Ml5Z6/2Ia7q KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2yrppr17xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 20:33:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKMUZJ010172;
        Mon, 16 Mar 2020 20:33:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ys8tqcxrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 20:33:22 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GKXMse024110;
        Mon, 16 Mar 2020 20:33:22 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 13:33:22 -0700
Date:   Mon, 16 Mar 2020 13:33:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/14] xfs: simplify log shutdown checking in
 xfs_log_release_iclog
Message-ID: <20200316203321.GJ256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160086
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:23PM +0100, Christoph Hellwig wrote:
> There is no need to check for the ioerror state before the lock, as
> the shutdown case is not a fast path.  Also remove the call to force
> shutdown the file system, as it must have been shut down already
> for an iclog to be in the ioerror state.  Also clean up the flow of
> the function a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 17ba92b115ea..7af9c292540b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -602,24 +602,16 @@ xfs_log_release_iclog(
>  	struct xlog_in_core	*iclog)
>  {
>  	struct xlog		*log = iclog->ic_log;
> -	bool			sync;
> -
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> -		goto error;
> +	bool			sync = false;
>  
>  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> -		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> -			spin_unlock(&log->l_icloglock);
> -			goto error;
> -		}
> -		sync = __xlog_state_release_iclog(log, iclog);
> +		if (iclog->ic_state != XLOG_STATE_IOERROR)
> +			sync = __xlog_state_release_iclog(log, iclog);
>  		spin_unlock(&log->l_icloglock);
> -		if (sync)
> -			xlog_sync(log, iclog);
>  	}
> -	return;
> -error:
> -	xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +
> +	if (sync)
> +		xlog_sync(log, iclog);
>  }
>  
>  /*
> -- 
> 2.24.1
> 
