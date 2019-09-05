Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9800C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E089207E0
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F3H1lxKn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731865AbfIEPrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 11:47:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40692 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730937AbfIEPrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 11:47:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85FhtlQ120134;
        Thu, 5 Sep 2019 15:47:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=NBK/qN4gYwsYZnX6kbAaA/8Ot17JRzOw35nQr6sx7k8=;
 b=F3H1lxKnWCHKMMq1RdMbi8oRU2iKDks873qTEKRRZw4yoN9xC4gi1AochQQxJsan1T8M
 5DMrHvEAYNBfnStMZ/XcgZSGFn3eklW7P0iox/yTWaK6frahJYnzZx+NlnzJHZKOPfzj
 uOeZdhAKCRTn5wJA3qXHLxhEFeOyQbqYfDaWSo0BuC7ea4ZqqOG6OjCQqhHRGCIzn5vf
 r1Rg+yPQV1BfICHU4ZNyll7bkCiGayCLNFjhu/VswYhLnUBZhm7wSnTsqeK1en3cJlXn
 aQoR56rWuzMyKjyxXJ9UlGVv3MC5sfBNXHjdacQiuGA/uTqCOPd75N9MXwRRNgAU/ek3 mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uu4rxg810-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 15:47:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85FiQIp063457;
        Thu, 5 Sep 2019 15:45:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uthq1vrmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 15:45:07 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x85Fj49M027316;
        Thu, 5 Sep 2019 15:45:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 08:45:04 -0700
Date:   Thu, 5 Sep 2019 08:45:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: factor iclog state processing out of
 xlog_state_do_callback()
Message-ID: <20190905154503.GG2229799@magnolia>
References: <20190905084717.30308-1-david@fromorbit.com>
 <20190905084717.30308-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905084717.30308-7-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 06:47:15PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The iclog IO completion state processing is somewhat complex, and
> because it's inside two nested loops it is highly indented and very
> hard to read. Factor it out, flatten the logic flow and clean up the
> comments so that it much easier to see what the code is doing both
> in processing the individual iclogs and in the over
> xlog_state_do_callback() operation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 195 ++++++++++++++++++++++++-----------------------
>  1 file changed, 98 insertions(+), 97 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 73aa8e152c83..356204ddf865 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2628,6 +2628,90 @@ xlog_get_lowest_lsn(
>  	return lowest_lsn;
>  }
>  
> +/*
> + * Return true if we need to stop processing, false to continue to the next
> + * iclog. The caller will need to run callbacks if the iclog is returned in the
> + * XLOG_STATE_CALLBACK state.
> + */
> +static bool
> +xlog_state_iodone_process_iclog(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog,
> +	struct xlog_in_core	*completed_iclog,
> +	bool			*ioerror)
> +{
> +	xfs_lsn_t		lowest_lsn;
> +
> +	/* Skip all iclogs in the ACTIVE & DIRTY states */
> +	if (iclog->ic_state & (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY))
> +		return false;
> +
> +	/*
> +	 * Between marking a filesystem SHUTDOWN and stopping the log, we do
> +	 * flush all iclogs to disk (if there wasn't a log I/O error). So, we do
> +	 * want things to go smoothly in case of just a SHUTDOWN  w/o a
> +	 * LOG_IO_ERROR.
> +	 */
> +	if (iclog->ic_state & XLOG_STATE_IOERROR) {
> +		*ioerror = true;
> +		return false;
> +	}
> +
> +	/*
> +	 * Can only perform callbacks in order.  Since this iclog is not in the
> +	 * DONE_SYNC/ DO_CALLBACK state, we skip the rest and just try to clean
> +	 * up.  If we set our iclog to DO_CALLBACK, we will not process it when
> +	 * we retry since a previous iclog is in the CALLBACK and the state
> +	 * cannot change since we are holding the l_icloglock.
> +	 */
> +	if (!(iclog->ic_state &
> +			(XLOG_STATE_DONE_SYNC | XLOG_STATE_DO_CALLBACK))) {
> +		if (completed_iclog &&
> +		    (completed_iclog->ic_state == XLOG_STATE_DONE_SYNC)) {
> +			completed_iclog->ic_state = XLOG_STATE_DO_CALLBACK;
> +		}
> +		return true;
> +	}
> +
> +	/*
> +	 * We now have an iclog that is in either the DO_CALLBACK or DONE_SYNC
> +	 * states. The other states (WANT_SYNC, SYNCING, or CALLBACK were caught
> +	 * by the above if and are going to clean (i.e. we aren't doing their
> +	 * callbacks) see the above if.
> +	 *
> +	 * We will do one more check here to see if we have chased our tail
> +	 * around.
> +	 */
> +	lowest_lsn = xlog_get_lowest_lsn(log);
> +	if (lowest_lsn &&
> +	    XFS_LSN_CMP(lowest_lsn, be64_to_cpu(iclog->ic_header.h_lsn)) < 0)
> +		return false; /* Leave this iclog for another thread */
> +
> +	iclog->ic_state = XLOG_STATE_CALLBACK;
> +
> +	/*
> +	 * Completion of a iclog IO does not imply that a transaction has
> +	 * completed, as transactions can be large enough to span many iclogs.
> +	 * We cannot change the tail of the log half way through a transaction
> +	 * as this may be the only transaction in the log and moving th etail to
> +	 * point to the middle of it will prevent recovery from finding the
> +	 * start of the transaction.  Hence we should only update the
> +	 * last_sync_lsn if this iclog contains transaction completion callbacks
> +	 * on it.
> +	 *
> +	 * We have to do this before we drop the icloglock to ensure we are the
> +	 * only one that can update it.
> +	 */
> +	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> +			be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
> +	if (!list_empty_careful(&iclog->ic_callbacks))
> +		atomic64_set(&log->l_last_sync_lsn,
> +			be64_to_cpu(iclog->ic_header.h_lsn));
> +
> +	return false;
> +
> +}
> +
>  /*
>   * Keep processing entries in the iclog callback list until we come around and
>   * it is empty.  We need to atomically see that the list is empty and change the
> @@ -2712,22 +2796,15 @@ xlog_state_do_callback(
>  	bool			aborted,
>  	struct xlog_in_core	*ciclog)
>  {
> -	xlog_in_core_t	   *iclog;
> -	xlog_in_core_t	   *first_iclog;	/* used to know when we've
> -						 * processed all iclogs once */
> -	int		   flushcnt = 0;
> -	xfs_lsn_t	   lowest_lsn;
> -	int		   ioerrors;	/* counter: iclogs with errors */
> -	bool		   cycled_icloglock;
> -	int		   funcdidcallbacks; /* flag: function did callbacks */
> -	int		   repeats;	/* for issuing console warnings if
> -					 * looping too many times */
> +	struct xlog_in_core	*iclog;
> +	struct xlog_in_core	*first_iclog;
> +	int			flushcnt = 0;
> +	int			funcdidcallbacks = 0;
> +	bool			cycled_icloglock;
> +	bool			ioerror;
> +	int			repeats = 0;
>  
>  	spin_lock(&log->l_icloglock);
> -	first_iclog = iclog = log->l_iclog;
> -	ioerrors = 0;
> -	funcdidcallbacks = 0;
> -	repeats = 0;
>  
>  	do {
>  		/*
> @@ -2741,96 +2818,20 @@ xlog_state_do_callback(
>  		first_iclog = log->l_iclog;
>  		iclog = log->l_iclog;
>  		cycled_icloglock = false;
> +		ioerror = false;
>  		repeats++;
>  
>  		do {
> +			if (xlog_state_iodone_process_iclog(log, iclog,
> +							ciclog, &ioerror))
> +				break;
>  
> -			/* skip all iclogs in the ACTIVE & DIRTY states */
> -			if (iclog->ic_state &
> -			    (XLOG_STATE_ACTIVE|XLOG_STATE_DIRTY)) {
> +			if (!(iclog->ic_state &
> +			      (XLOG_STATE_CALLBACK | XLOG_STATE_IOERROR))) {
>  				iclog = iclog->ic_next;
>  				continue;
>  			}
>  
> -			/*
> -			 * Between marking a filesystem SHUTDOWN and stopping
> -			 * the log, we do flush all iclogs to disk (if there
> -			 * wasn't a log I/O error). So, we do want things to
> -			 * go smoothly in case of just a SHUTDOWN  w/o a
> -			 * LOG_IO_ERROR.
> -			 */
> -			if (!(iclog->ic_state & XLOG_STATE_IOERROR)) {
> -				/*
> -				 * Can only perform callbacks in order.  Since
> -				 * this iclog is not in the DONE_SYNC/
> -				 * DO_CALLBACK state, we skip the rest and
> -				 * just try to clean up.  If we set our iclog
> -				 * to DO_CALLBACK, we will not process it when
> -				 * we retry since a previous iclog is in the
> -				 * CALLBACK and the state cannot change since
> -				 * we are holding the l_icloglock.
> -				 */
> -				if (!(iclog->ic_state &
> -					(XLOG_STATE_DONE_SYNC |
> -						 XLOG_STATE_DO_CALLBACK))) {
> -					if (ciclog && (ciclog->ic_state ==
> -							XLOG_STATE_DONE_SYNC)) {
> -						ciclog->ic_state = XLOG_STATE_DO_CALLBACK;
> -					}
> -					break;
> -				}
> -				/*
> -				 * We now have an iclog that is in either the
> -				 * DO_CALLBACK or DONE_SYNC states. The other
> -				 * states (WANT_SYNC, SYNCING, or CALLBACK were
> -				 * caught by the above if and are going to
> -				 * clean (i.e. we aren't doing their callbacks)
> -				 * see the above if.
> -				 */
> -
> -				/*
> -				 * We will do one more check here to see if we
> -				 * have chased our tail around.
> -				 */
> -
> -				lowest_lsn = xlog_get_lowest_lsn(log);
> -				if (lowest_lsn &&
> -				    XFS_LSN_CMP(lowest_lsn,
> -						be64_to_cpu(iclog->ic_header.h_lsn)) < 0) {
> -					iclog = iclog->ic_next;
> -					continue; /* Leave this iclog for
> -						   * another thread */
> -				}
> -
> -				iclog->ic_state = XLOG_STATE_CALLBACK;
> -
> -
> -				/*
> -				 * Completion of a iclog IO does not imply that
> -				 * a transaction has completed, as transactions
> -				 * can be large enough to span many iclogs. We
> -				 * cannot change the tail of the log half way
> -				 * through a transaction as this may be the only
> -				 * transaction in the log and moving th etail to
> -				 * point to the middle of it will prevent
> -				 * recovery from finding the start of the
> -				 * transaction. Hence we should only update the
> -				 * last_sync_lsn if this iclog contains
> -				 * transaction completion callbacks on it.
> -				 *
> -				 * We have to do this before we drop the
> -				 * icloglock to ensure we are the only one that
> -				 * can update it.
> -				 */
> -				ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> -					be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
> -				if (!list_empty_careful(&iclog->ic_callbacks))
> -					atomic64_set(&log->l_last_sync_lsn,
> -						be64_to_cpu(iclog->ic_header.h_lsn));
> -
> -			} else
> -				ioerrors++;
> -
>  			/*
>  			 * Running callbacks will drop the icloglock which means
>  			 * we'll have to run at least one more complete loop.
> @@ -2862,7 +2863,7 @@ xlog_state_do_callback(
>  				"%s: possible infinite loop (%d iterations)",
>  				__func__, flushcnt);
>  		}
> -	} while (!ioerrors && cycled_icloglock);
> +	} while (!ioerror && cycled_icloglock);
>  
>  	if (funcdidcallbacks)
>  		xlog_state_callback_check_state(log);
> -- 
> 2.23.0.rc1
> 
