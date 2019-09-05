Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03952C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 791932082C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qgUAqXVW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbfIEPs6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 11:48:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46068 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732613AbfIEPs6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 11:48:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85FmguZ124522;
        Thu, 5 Sep 2019 15:48:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=amT0Jt2JCqxxqm85atDf3hiZVz8ZEViE/nc0foNizlc=;
 b=qgUAqXVWC5zM87zE+YrASs70SzOLF5uWz+VWWmJxj+45DD3bYZ1HMf8+GjB2X36KAyDb
 hoJbn5rsKAOmohlRbrlLX+j9PQ62kmYgl0cFQKNUZpSzvqx3Ho/SeAjidZwEyj7VICut
 Oh1ea3JF+NNRfaoPgyEcdD9amo/2r/DpxChgnEfamTUZrQW87xf68Zpb2qjfUIBndEiS
 slzTpsjez2z7cWEgTI5bgfuYlwoG6VFavUK4kUEsI1gtS6yD/yNwnr9185z/Y30nzEka
 Kc3Sb5DQFqpGYwXlsvYXu1sKvbzei+FDjv+R2ba1HKHe8zMqZ0x5E2rMTppwPSc2Upjw kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uu4rgr911-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 15:48:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85FmAmE061322;
        Thu, 5 Sep 2019 15:48:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uu1b8sba1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 15:48:54 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85FmsFa014479;
        Thu, 5 Sep 2019 15:48:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 08:48:54 -0700
Date:   Thu, 5 Sep 2019 08:48:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: push iclog state cleaning into
 xlog_state_clean_log
Message-ID: <20190905154853.GH2229799@magnolia>
References: <20190905084717.30308-1-david@fromorbit.com>
 <20190905084717.30308-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905084717.30308-8-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 06:47:16PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xlog_state_clean_log() is only called from one place, and it occurs
> when an iclog is transitioning back to ACTIVE. Prior to calling
> xlog_state_clean_log, the iclog we are processing has a hard coded
> state check to DIRTY so that xlog_state_clean_log() processes it
> correctly. We also have a hard coded wakeup after
> xlog_state_clean_log() to enfore log force waiters on that iclog
> are woken correctly.
> 
> Both of these things are operations required to finish processing an
> iclog and return it to the ACTIVE state again, so they make little
> sense to be separated from the rest of the clean state transition
> code.
> 
> Hence push these things inside xlog_state_clean_log(), document the
> behaviour and rename it xlog_state_clean_iclog() to indicate that
> it's being driven by an iclog state change and does the iclog state
> change work itself.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 57 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 33 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 356204ddf865..bef314361bc4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2521,21 +2521,35 @@ xlog_write(
>   *****************************************************************************
>   */
>  
> -/* Clean iclogs starting from the head.  This ordering must be
> - * maintained, so an iclog doesn't become ACTIVE beyond one that
> - * is SYNCING.  This is also required to maintain the notion that we use
> - * a ordered wait queue to hold off would be writers to the log when every
> - * iclog is trying to sync to disk.
> +/*
> + * An iclog has just finished it's completion processing, so we need to update

it's -> its, but I can fix that on import.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> + * the iclog state and propagate that up into the overall log state. Hence we
> + * prepare the iclog for cleaning, and then clean all the pending dirty iclogs
> + * starting from the head, and then wake up any threads that are waiting for the
> + * iclog to be marked clean.
> + *
> + * The ordering of marking iclogs ACTIVE must be maintained, so an iclog
> + * doesn't become ACTIVE beyond one that is SYNCING.  This is also required to
> + * maintain the notion that we use a ordered wait queue to hold off would be
> + * writers to the log when every iclog is trying to sync to disk.
> + *
> + * Caller must hold the icloglock before calling us.
>   *
> - * State Change: DIRTY -> ACTIVE
> + * State Change: !IOERROR -> DIRTY -> ACTIVE
>   */
>  STATIC void
> -xlog_state_clean_log(
> -	struct xlog *log)
> +xlog_state_clean_iclog(
> +	struct xlog		*log,
> +	struct xlog_in_core	*dirty_iclog)
>  {
> -	xlog_in_core_t	*iclog;
> -	int changed = 0;
> +	struct xlog_in_core	*iclog;
> +	int			changed = 0;
> +
> +	/* Prepare the completed iclog. */
> +	if (!(dirty_iclog->ic_state & XLOG_STATE_IOERROR))
> +		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
>  
> +	/* Walk all the iclogs to update the ordered active state. */
>  	iclog = log->l_iclog;
>  	do {
>  		if (iclog->ic_state == XLOG_STATE_DIRTY) {
> @@ -2573,7 +2587,13 @@ xlog_state_clean_log(
>  		iclog = iclog->ic_next;
>  	} while (iclog != log->l_iclog);
>  
> -	/* log is locked when we are called */
> +
> +	/*
> +	 * Wake up threads waiting in xfs_log_force() for the dirty iclog
> +	 * to be cleaned.
> +	 */
> +	wake_up_all(&dirty_iclog->ic_force_wait);
> +
>  	/*
>  	 * Change state for the dummy log recording.
>  	 * We usually go to NEED. But we go to NEED2 if the changed indicates
> @@ -2607,7 +2627,7 @@ xlog_state_clean_log(
>  			ASSERT(0);
>  		}
>  	}
> -}	/* xlog_state_clean_log */
> +}
>  
>  STATIC xfs_lsn_t
>  xlog_get_lowest_lsn(
> @@ -2839,18 +2859,7 @@ xlog_state_do_callback(
>  			cycled_icloglock = true;
>  			xlog_state_do_iclog_callbacks(log, iclog, aborted);
>  
> -			if (!(iclog->ic_state & XLOG_STATE_IOERROR))
> -				iclog->ic_state = XLOG_STATE_DIRTY;
> -
> -			/*
> -			 * Transition from DIRTY to ACTIVE if applicable.
> -			 * NOP if STATE_IOERROR.
> -			 */
> -			xlog_state_clean_log(log);
> -
> -			/* wake up threads waiting in xfs_log_force() */
> -			wake_up_all(&iclog->ic_force_wait);
> -
> +			xlog_state_clean_iclog(log, iclog);
>  			iclog = iclog->ic_next;
>  		} while (first_iclog != iclog);
>  
> -- 
> 2.23.0.rc1
> 
