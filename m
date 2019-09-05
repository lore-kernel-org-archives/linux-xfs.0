Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754D6C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D345D2082C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="liClpZ/R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732723AbfIEPcL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 11:32:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51884 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732512AbfIEPcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 11:32:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85FStMu105167;
        Thu, 5 Sep 2019 15:32:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=SZrIZNd6doqX0WagxSXtJV5cWGdNbblq0o6T1h6aQz4=;
 b=liClpZ/R0wr5mjeSZiB2MJKV0DOySy+sAK5hqOwNArtG1bwzfNQC48LAS3yUijDwO04q
 9bljMAZ/aZ3LCyegzTR9z4oP11JSgmkmghtFkPi1/+XPet+RKLVZWCv2x/lM2R1RRYW5
 2PGXvT17BQworermLE34vbJWD2yGEX4MTRJPUpX3fdL5B6szz6050SahmosHRrQfcT0c
 zeZJH6zk4empfzUsyKLddEZwDUfRlZuzOX82JLgVU3rKrrySugju8PoMiylcfUv86u91
 8IpIFZ3mRFI9PbqhxM6mRL5vgSuR6CR9gr8ep5sFYbR7QRimmJEEYD6Sa2KUCxQCfqdI IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uu4rxg4v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 15:32:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85FSYUR019479;
        Thu, 5 Sep 2019 15:30:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2utpmbd2f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 15:30:08 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85FU7LV011098;
        Thu, 5 Sep 2019 15:30:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 08:30:07 -0700
Date:   Thu, 5 Sep 2019 08:30:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: factor debug code out of
 xlog_state_do_callback()
Message-ID: <20190905153006.GE2229799@magnolia>
References: <20190905084717.30308-1-david@fromorbit.com>
 <20190905084717.30308-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905084717.30308-5-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 06:47:13PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Start making this function readable by lifting the debug code into
> a conditional function.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 79 +++++++++++++++++++++++++++---------------------
>  1 file changed, 44 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 8380ed065608..2904bf0d17f3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2628,6 +2628,48 @@ xlog_get_lowest_lsn(
>  	return lowest_lsn;
>  }
>  
> +#ifdef DEBUG
> +/*
> + * Make one last gasp attempt to see if iclogs are being left in limbo.  If the
> + * above loop finds an iclog earlier than the current iclog and in one of the
> + * syncing states, the current iclog is put into DO_CALLBACK and the callbacks
> + * are deferred to the completion of the earlier iclog. Walk the iclogs in order
> + * and make sure that no iclog is in DO_CALLBACK unless an earlier iclog is in
> + * one of the syncing states.
> + *
> + * Note that SYNCING|IOERROR is a valid state so we cannot just check for
> + * ic_state == SYNCING.
> + */
> +static void
> +xlog_state_callback_check_state(
> +	struct xlog		*log)
> +{
> +	struct xlog_in_core	*first_iclog = log->l_iclog;
> +	struct xlog_in_core	*iclog = first_iclog;
> +
> +	do {
> +		ASSERT(iclog->ic_state != XLOG_STATE_DO_CALLBACK);
> +		/*
> +		 * Terminate the loop if iclogs are found in states
> +		 * which will cause other threads to clean up iclogs.
> +		 *
> +		 * SYNCING - i/o completion will go through logs
> +		 * DONE_SYNC - interrupt thread should be waiting for
> +		 *              l_icloglock
> +		 * IOERROR - give up hope all ye who enter here
> +		 */
> +		if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> +		    iclog->ic_state & XLOG_STATE_SYNCING ||

Code like this make my eyes twitch (Does ic_state track mutually
exclusive state?  Or is it state flags?  I think it's the second!),
but as this is simply refactoring debugging code...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +		    iclog->ic_state == XLOG_STATE_DONE_SYNC ||
> +		    iclog->ic_state == XLOG_STATE_IOERROR )
> +			break;
> +		iclog = iclog->ic_next;
> +	} while (first_iclog != iclog);
> +}
> +#else
> +#define xlog_state_callback_check_state(l)	((void)0)
> +#endif
> +
>  STATIC void
>  xlog_state_do_callback(
>  	struct xlog		*log,
> @@ -2802,41 +2844,8 @@ xlog_state_do_callback(
>  		}
>  	} while (!ioerrors && loopdidcallbacks);
>  
> -#ifdef DEBUG
> -	/*
> -	 * Make one last gasp attempt to see if iclogs are being left in limbo.
> -	 * If the above loop finds an iclog earlier than the current iclog and
> -	 * in one of the syncing states, the current iclog is put into
> -	 * DO_CALLBACK and the callbacks are deferred to the completion of the
> -	 * earlier iclog. Walk the iclogs in order and make sure that no iclog
> -	 * is in DO_CALLBACK unless an earlier iclog is in one of the syncing
> -	 * states.
> -	 *
> -	 * Note that SYNCING|IOABORT is a valid state so we cannot just check
> -	 * for ic_state == SYNCING.
> -	 */
> -	if (funcdidcallbacks) {
> -		first_iclog = iclog = log->l_iclog;
> -		do {
> -			ASSERT(iclog->ic_state != XLOG_STATE_DO_CALLBACK);
> -			/*
> -			 * Terminate the loop if iclogs are found in states
> -			 * which will cause other threads to clean up iclogs.
> -			 *
> -			 * SYNCING - i/o completion will go through logs
> -			 * DONE_SYNC - interrupt thread should be waiting for
> -			 *              l_icloglock
> -			 * IOERROR - give up hope all ye who enter here
> -			 */
> -			if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -			    iclog->ic_state & XLOG_STATE_SYNCING ||
> -			    iclog->ic_state == XLOG_STATE_DONE_SYNC ||
> -			    iclog->ic_state == XLOG_STATE_IOERROR )
> -				break;
> -			iclog = iclog->ic_next;
> -		} while (first_iclog != iclog);
> -	}
> -#endif
> +	if (funcdidcallbacks)
> +		xlog_state_callback_check_state(log);
>  
>  	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR))
>  		wake_up_all(&log->l_flush_wait);
> -- 
> 2.23.0.rc1
> 
