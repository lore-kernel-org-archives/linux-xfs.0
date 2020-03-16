Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4848AC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10D37205ED
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:03:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zmycKbw3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732611AbgCPVDE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:03:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43426 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732567AbgCPVDE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 17:03:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKrm9C084546;
        Mon, 16 Mar 2020 21:02:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HXiz8jFywm8UO2wJhZ8UUtNslnrFiy9/HJH4l/X1AsE=;
 b=zmycKbw36o1YX4VVpEnbPqPIvw4kM4Cd3mKpj3SZUE1qiNYkdYSb85aqfrt3SaWrZ5Cs
 I9+sw+TJyqsLy0jWqriT1DuW3buk1M9zgksmqPw08mw1LuBtEdIeqwkUzn2bHsiZzEGn
 RsN+vtMv43NtT/m5V6PmAK8LMrq/r1tERz+/2xCciewIoM10byGTGYKL1vgrwpLAv4lm
 kYa7go6SxZp1J73prRTOmpcwphm1v6lYkOqnMMsbrz957yfwoKgqcc/A6i6bg5ESMIDM
 xhhAx8huLkAeJtzfVUAP93JXaQx8OfsdCuPj90LEZcFIaG8pza18niMToZ6A8EDR6U0w mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yrqwn1722-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:02:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKqZtT062115;
        Mon, 16 Mar 2020 21:02:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ys8ywk8vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:02:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GL2wtn027243;
        Mon, 16 Mar 2020 21:02:58 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 14:02:58 -0700
Date:   Mon, 16 Mar 2020 14:02:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/14] xfs: move log shut down handling out of
 xlog_state_iodone_process_iclog
Message-ID: <20200316210257.GN256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-10-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160087
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:28PM +0100, Christoph Hellwig wrote:
> Move handling of a shut down log out of xlog_state_iodone_process_iclog
> and into xlog_state_do_callback so that it can be moved into an entirely
> separate branch.  While doing so switch to using XLOG_FORCED_SHUTDOWN to
> check the shutdown condition global to the log instead of the per-iclog
> flag, and make sure the comments match reality.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 64 ++++++++++++++++++++----------------------------
>  1 file changed, 26 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c534d7007aa3..4efaa248a03d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2746,8 +2746,7 @@ xlog_state_do_iclog_callbacks(
>  static bool
>  xlog_state_iodone_process_iclog(
>  	struct xlog		*log,
> -	struct xlog_in_core	*iclog,
> -	bool			*ioerror)
> +	struct xlog_in_core	*iclog)
>  {
>  	xfs_lsn_t		lowest_lsn;
>  	xfs_lsn_t		header_lsn;
> @@ -2759,15 +2758,6 @@ xlog_state_iodone_process_iclog(
>  		 * Skip all iclogs in the ACTIVE & DIRTY states:
>  		 */
>  		return false;
> -	case XLOG_STATE_IOERROR:
> -		/*
> -		 * Between marking a filesystem SHUTDOWN and stopping the log,
> -		 * we do flush all iclogs to disk (if there wasn't a log I/O
> -		 * error). So, we do want things to go smoothly in case of just
> -		 * a SHUTDOWN w/o a LOG_IO_ERROR.
> -		 */
> -		*ioerror = true;
> -		return false;
>  	case XLOG_STATE_DONE_SYNC:
>  		/*
>  		 * Now that we have an iclog that is in the DONE_SYNC state, do
> @@ -2795,39 +2785,41 @@ STATIC void
>  xlog_state_do_callback(
>  	struct xlog		*log)
>  {
> -	struct xlog_in_core	*iclog;
> -	struct xlog_in_core	*first_iclog;
>  	bool			cycled_icloglock;
> -	bool			ioerror;
>  	int			flushcnt = 0;
>  	int			repeats = 0;
>  
> +	/*
> +	 * Scan all iclogs starting with the one pointed to by the log.  Reset
> +	 * this starting point each time the log is unlocked (during callbacks).
> +	 *
> +	 * Keep looping through iclogs until one full pass is made without
> +	 * running any callbacks.
> +	 *
> +	 * If the log has been shut down, still perform the callbacks once per
> +	 * iclog to abort all log items, but don't bother to restart the loop
> +	 * after dropping the log as no new callbacks can show up.
> +	 */
>  	spin_lock(&log->l_icloglock);
>  	do {
> -		/*
> -		 * Scan all iclogs starting with the one pointed to by the
> -		 * log.  Reset this starting point each time the log is
> -		 * unlocked (during callbacks).
> -		 *
> -		 * Keep looping through iclogs until one full pass is made
> -		 * without running any callbacks.
> -		 */
> -		first_iclog = log->l_iclog;
> -		iclog = log->l_iclog;
> +		struct xlog_in_core	*first_iclog = log->l_iclog;
> +		struct xlog_in_core	*iclog = first_iclog;
> +
>  		cycled_icloglock = false;
> -		ioerror = false;
>  		repeats++;
>  
>  		do {
> -			if (xlog_state_iodone_process_iclog(log, iclog,
> -							&ioerror))
> +			if (XLOG_FORCED_SHUTDOWN(log)) {
> +				xlog_state_do_iclog_callbacks(log, iclog);
> +				wake_up_all(&iclog->ic_force_wait);
> +				continue;
> +			}
> +
> +			if (xlog_state_iodone_process_iclog(log, iclog))
>  				break;
>  
> -			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
> -			    iclog->ic_state != XLOG_STATE_IOERROR) {
> -				iclog = iclog->ic_next;
> +			if (iclog->ic_state != XLOG_STATE_CALLBACK)
>  				continue;
> -			}
>  
>  			/*
>  			 * Running callbacks will drop the icloglock which means
> @@ -2835,12 +2827,8 @@ xlog_state_do_callback(
>  			 */
>  			cycled_icloglock = true;
>  			xlog_state_do_iclog_callbacks(log, iclog);
> -			if (XLOG_FORCED_SHUTDOWN(log))
> -				wake_up_all(&iclog->ic_force_wait);
> -			else
> -				xlog_state_clean_iclog(log, iclog);
> -			iclog = iclog->ic_next;
> -		} while (first_iclog != iclog);
> +			xlog_state_clean_iclog(log, iclog);
> +		} while ((iclog = iclog->ic_next) != first_iclog);
>  
>  		if (repeats > 5000) {
>  			flushcnt += repeats;
> @@ -2849,7 +2837,7 @@ xlog_state_do_callback(
>  				"%s: possible infinite loop (%d iterations)",
>  				__func__, flushcnt);
>  		}
> -	} while (!ioerror && cycled_icloglock);
> +	} while (cycled_icloglock);
>  
>  	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
>  	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
> -- 
> 2.24.1
> 
