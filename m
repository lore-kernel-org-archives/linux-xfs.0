Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E52AC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 783A820828
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q8T9qVEd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388543AbfIEPjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 11:39:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60316 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388553AbfIEPjg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 11:39:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85Fd4r1115411;
        Thu, 5 Sep 2019 15:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=YwYJNtg2leD8tI95Y28FD480+tOX/D1bl9v1S6cFyjo=;
 b=Q8T9qVEdWa1u7ronaxpkXglievqDnSBZQSseBxvUTUycZUcE9URq3TWI7bB8QafzIt8L
 8RytI1aSxxK/cRueNq7Fth2wMW1eSKKpu5F1z6sAIuZbABL6Go6UXc/Ka64d+aC5HQUV
 I0ZS9XB6IXup876Xn0vxQl/TgFke8v1GQJWmR707eO/UMML1EkHEhlQBCpMQUl0bdNxE
 bM2iHwebKZiAE+QLc0YQQdtnSHp6if5rWMvoh4ZOxuLQUzjO0/Rvyxh+P/NGJ4j7GCE3
 T5Q9rHd4YaMms1Eqasy92ZKT+Rk1/TXZP9TYiU8W5ihhOTNYUSlKfa8AiTTVEK6/Qqsc HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uu4rxg6cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 15:39:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85FcRP8136110;
        Thu, 5 Sep 2019 15:39:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2utvr3t4fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 15:39:32 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85Fd8Ea006150;
        Thu, 5 Sep 2019 15:39:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 08:39:08 -0700
Date:   Thu, 5 Sep 2019 08:39:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: factor callbacks out of xlog_state_do_callback()
Message-ID: <20190905153907.GF2229799@magnolia>
References: <20190905084717.30308-1-david@fromorbit.com>
 <20190905084717.30308-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905084717.30308-6-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 06:47:14PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Simplify the code flow by lifting the iclog callback work out of
> the main iclog iteration loop. This isolates the log juggling and
> callbacks from the iclog state change logic in the loop.
> 
> Note that the loopdidcallbacks variable is not actually tracking
> whether callbacks are actually run - it is tracking whether the
> icloglock was dropped during the loop and so determines if we
> completed the entire iclog scan loop atomically. Hence we know for
> certain there are either no more ordered completions to run or
> that the next completion will run the remaining ordered iclog
> completions. Hence rename that variable appropriately for it's
> function.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 70 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 45 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2904bf0d17f3..73aa8e152c83 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2628,6 +2628,42 @@ xlog_get_lowest_lsn(
>  	return lowest_lsn;
>  }
>  
> +/*
> + * Keep processing entries in the iclog callback list until we come around and
> + * it is empty.  We need to atomically see that the list is empty and change the
> + * state to DIRTY so that we don't miss any more callbacks being added.
> + *
> + * This function is called with the icloglock held and returns with it held. We
> + * drop it while running callbacks, however, as holding it over thousands of
> + * callbacks is unnecessary and causes excessive contention if we do.
> + */
> +static void
> +xlog_state_do_iclog_callbacks(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog,
> +	bool			aborted)
> +{
> +	spin_unlock(&log->l_icloglock);
> +	spin_lock(&iclog->ic_callback_lock);
> +	while (!list_empty(&iclog->ic_callbacks)) {
> +		LIST_HEAD(tmp);
> +
> +		list_splice_init(&iclog->ic_callbacks, &tmp);
> +
> +		spin_unlock(&iclog->ic_callback_lock);
> +		xlog_cil_process_committed(&tmp, aborted);
> +		spin_lock(&iclog->ic_callback_lock);
> +	}
> +
> +	/*
> +	 * Pick up the icloglock while still holding the callback lock so we
> +	 * serialise against anyone trying to add more callbacks to this iclog
> +	 * now we've finished processing.
> +	 */
> +	spin_lock(&log->l_icloglock);
> +	spin_unlock(&iclog->ic_callback_lock);
> +}
> +
>  #ifdef DEBUG
>  /*
>   * Make one last gasp attempt to see if iclogs are being left in limbo.  If the
> @@ -2682,7 +2718,7 @@ xlog_state_do_callback(
>  	int		   flushcnt = 0;
>  	xfs_lsn_t	   lowest_lsn;
>  	int		   ioerrors;	/* counter: iclogs with errors */
> -	int		   loopdidcallbacks; /* flag: inner loop did callbacks*/
> +	bool		   cycled_icloglock;
>  	int		   funcdidcallbacks; /* flag: function did callbacks */
>  	int		   repeats;	/* for issuing console warnings if
>  					 * looping too many times */
> @@ -2704,7 +2740,7 @@ xlog_state_do_callback(
>  		 */
>  		first_iclog = log->l_iclog;
>  		iclog = log->l_iclog;
> -		loopdidcallbacks = 0;
> +		cycled_icloglock = false;
>  		repeats++;
>  
>  		do {
> @@ -2795,31 +2831,13 @@ xlog_state_do_callback(
>  			} else
>  				ioerrors++;
>  
> -			spin_unlock(&log->l_icloglock);
> -
>  			/*
> -			 * Keep processing entries in the callback list until
> -			 * we come around and it is empty.  We need to
> -			 * atomically see that the list is empty and change the
> -			 * state to DIRTY so that we don't miss any more
> -			 * callbacks being added.
> +			 * Running callbacks will drop the icloglock which means
> +			 * we'll have to run at least one more complete loop.
>  			 */
> -			spin_lock(&iclog->ic_callback_lock);
> -			while (!list_empty(&iclog->ic_callbacks)) {
> -				LIST_HEAD(tmp);
> +			cycled_icloglock = true;
> +			xlog_state_do_iclog_callbacks(log, iclog, aborted);
>  
> -				list_splice_init(&iclog->ic_callbacks, &tmp);
> -
> -				spin_unlock(&iclog->ic_callback_lock);
> -				xlog_cil_process_committed(&tmp, aborted);
> -				spin_lock(&iclog->ic_callback_lock);
> -			}
> -
> -			loopdidcallbacks++;
> -			funcdidcallbacks++;
> -
> -			spin_lock(&log->l_icloglock);
> -			spin_unlock(&iclog->ic_callback_lock);
>  			if (!(iclog->ic_state & XLOG_STATE_IOERROR))
>  				iclog->ic_state = XLOG_STATE_DIRTY;
>  
> @@ -2835,6 +2853,8 @@ xlog_state_do_callback(
>  			iclog = iclog->ic_next;
>  		} while (first_iclog != iclog);
>  
> +		funcdidcallbacks += cycled_icloglock;

funcdidcallbacks is effectively a yes/no state flag, so maybe it should
be turned into a boolean and this statement becomes:

	funcdidcallbacks |= cycled_icloglock;

Though I guess we're not at huge risk of integer overflow and it
controls whether or not we run a debugging check so maybe we don't care?

--D

> +
>  		if (repeats > 5000) {
>  			flushcnt += repeats;
>  			repeats = 0;
> @@ -2842,7 +2862,7 @@ xlog_state_do_callback(
>  				"%s: possible infinite loop (%d iterations)",
>  				__func__, flushcnt);
>  		}
> -	} while (!ioerrors && loopdidcallbacks);
> +	} while (!ioerrors && cycled_icloglock);
>  
>  	if (funcdidcallbacks)
>  		xlog_state_callback_check_state(log);
> -- 
> 2.23.0.rc1
> 
