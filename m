Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D47C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 00:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3814206DE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 00:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sPM8JnFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389210AbfIFASt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 20:18:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733029AbfIFASt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 20:18:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8609Q5q127739;
        Fri, 6 Sep 2019 00:18:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=7OCp4a22avcD+33YOlz6gL2UQ0ssE6uAh7EtwcJtqWU=;
 b=sPM8JnFvnAkSMX4GndcWpQhq4r0c9uFEzmzMLsUTvEW/gh81Yb4xGu2BHomSMQXPeklO
 HKjL9h1oYsEk7ZYQzIJL30r0eEQDrGKGx8wnlGzeIwQIqVjbyZLsA62TcYaL6ow2KUzC
 mhyCfvjQNxY7THq2tf7c/nOyAQL6AG4INAaYwzwHNC0LVb9uEjWQpDuwmmsqzo+ikEeR
 ukuxGXVdNOeItRJI8f/nHPuJOGAGkx5VfhnTrM7s1zeYq0l1q0N4a57jljSo54OPHpbk
 +mbQUL3p6i0Q/LXpRwxmd9fN4S6pShggPhTTI+Yq3yrvQAaz0oijfT363rixeDm13B/V AA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uucg2r1p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 00:18:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8608QTC124019;
        Fri, 6 Sep 2019 00:16:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uu1b96f65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 00:16:45 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x860GiXQ026413;
        Fri, 6 Sep 2019 00:16:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 17:16:44 -0700
Date:   Thu, 5 Sep 2019 17:16:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: factor callbacks out of xlog_state_do_callback()
Message-ID: <20190906001642.GN2229799@magnolia>
References: <20190906000553.6740-1-david@fromorbit.com>
 <20190906000553.6740-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906000553.6740-6-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 06, 2019 at 10:05:50AM +1000, Dave Chinner wrote:
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

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 76 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 48 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index ff495c52807b..65088a810ad3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2634,6 +2634,42 @@ xlog_get_lowest_lsn(
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
> @@ -2688,15 +2724,15 @@ xlog_state_do_callback(
>  	int		   flushcnt = 0;
>  	xfs_lsn_t	   lowest_lsn;
>  	int		   ioerrors;	/* counter: iclogs with errors */
> -	int		   loopdidcallbacks; /* flag: inner loop did callbacks*/
> -	int		   funcdidcallbacks; /* flag: function did callbacks */
> +	bool		   cycled_icloglock;
> +	bool		   did_callbacks;
>  	int		   repeats;	/* for issuing console warnings if
>  					 * looping too many times */
>  
>  	spin_lock(&log->l_icloglock);
>  	first_iclog = iclog = log->l_iclog;
>  	ioerrors = 0;
> -	funcdidcallbacks = 0;
> +	did_callbacks = 0;
>  	repeats = 0;
>  
>  	do {
> @@ -2710,7 +2746,7 @@ xlog_state_do_callback(
>  		 */
>  		first_iclog = log->l_iclog;
>  		iclog = log->l_iclog;
> -		loopdidcallbacks = 0;
> +		cycled_icloglock = false;
>  		repeats++;
>  
>  		do {
> @@ -2801,31 +2837,13 @@ xlog_state_do_callback(
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
> @@ -2841,6 +2859,8 @@ xlog_state_do_callback(
>  			iclog = iclog->ic_next;
>  		} while (first_iclog != iclog);
>  
> +		did_callbacks |= cycled_icloglock;
> +
>  		if (repeats > 5000) {
>  			flushcnt += repeats;
>  			repeats = 0;
> @@ -2848,9 +2868,9 @@ xlog_state_do_callback(
>  				"%s: possible infinite loop (%d iterations)",
>  				__func__, flushcnt);
>  		}
> -	} while (!ioerrors && loopdidcallbacks);
> +	} while (!ioerrors && cycled_icloglock);
>  
> -	if (funcdidcallbacks)
> +	if (did_callbacks)
>  		xlog_state_callback_check_state(log);
>  
>  	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR))
> -- 
> 2.23.0.rc1
> 
