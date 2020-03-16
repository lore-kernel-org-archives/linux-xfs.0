Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7044CC18E5B
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 20:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F83520719
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 20:59:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S4VHMavC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732629AbgCPU7c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 16:59:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50388 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732625AbgCPU7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 16:59:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKqxxi126181;
        Mon, 16 Mar 2020 20:59:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=T21tBxLbNctAvbjUYoiytbU0xjlRBRr9ciJ0dwItqYo=;
 b=S4VHMavC0/MvWOBXKcAhGD8ujQtUFgLTFkqUbCpoM5oPGV8OUxFVB47ChP4ZSCtnQu8z
 2g7ebJdN/RTWwc5U6EENhf1iPupuBccKi5rft4l2xQuLoknJBWgKUk/BgLmFnKlM2QB5
 eLi26O1P2MlD0TrlsAEJUiD15mzfoSirOfupKor4ByPYS5Buv1wuV+R/etgXdu72+t2f
 KKyCpe7mQjnHhskkruWpAcXJW6VLBW9rNDfaBMRRzbUdmQo2jjA513RZY4REgxdqGqf9
 jh8O6j6WOQXsZ2TkmSfta80rrkxqRe2DAkZdyCQzCdYvoQibCBTbYzz/TkEzf0ktXHcV rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yrppr1bmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 20:59:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKrjkh136481;
        Mon, 16 Mar 2020 20:59:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ys92aqer8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 20:59:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02GKxPK5025706;
        Mon, 16 Mar 2020 20:59:26 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 13:59:25 -0700
Date:   Mon, 16 Mar 2020 13:59:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/14] xfs: refactor xlog_state_clean_iclog
Message-ID: <20200316205924.GA256713@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-7-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160087
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:25PM +0100, Christoph Hellwig wrote:
> Factor out a few self-container helper from xlog_state_clean_iclog, and

"self-contained" ?

> update the documentation so it primarily documents why things happens
> instead of how.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok otherwise, I think I saw where all the pieces landed :)
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 180 +++++++++++++++++++++++------------------------
>  1 file changed, 87 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 8ede2852f104..23979d08a2a3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2540,112 +2540,106 @@ xlog_write(
>   *****************************************************************************
>   */
>  
> +static void
> +xlog_state_activate_iclog(
> +	struct xlog_in_core	*iclog,
> +	int			*iclogs_changed)
> +{
> +	ASSERT(list_empty_careful(&iclog->ic_callbacks));
> +
> +	/*
> +	 * If the number of ops in this iclog indicate it just contains the
> +	 * dummy transaction, we can change state into IDLE (the second time
> +	 * around). Otherwise we should change the state into NEED a dummy.
> +	 * We don't need to cover the dummy.
> +	 */
> +	if (*iclogs_changed == 0 &&
> +	    iclog->ic_header.h_num_logops == cpu_to_be32(XLOG_COVER_OPS)) {
> +		*iclogs_changed = 1;
> +	} else {
> +		/*
> +		 * We have two dirty iclogs so start over.  This could also be
> +		 * num of ops indicating this is not the dummy going out.
> +		 */
> +		*iclogs_changed = 2;
> +	}
> +
> +	iclog->ic_state	= XLOG_STATE_ACTIVE;
> +	iclog->ic_offset = 0;
> +	iclog->ic_header.h_num_logops = 0;
> +	memset(iclog->ic_header.h_cycle_data, 0,
> +		sizeof(iclog->ic_header.h_cycle_data));
> +	iclog->ic_header.h_lsn = 0;
> +}
> +
>  /*
> - * An iclog has just finished IO completion processing, so we need to update
> - * the iclog state and propagate that up into the overall log state. Hence we
> - * prepare the iclog for cleaning, and then clean all the pending dirty iclogs
> - * starting from the head, and then wake up any threads that are waiting for the
> - * iclog to be marked clean.
> - *
> - * The ordering of marking iclogs ACTIVE must be maintained, so an iclog
> - * doesn't become ACTIVE beyond one that is SYNCING.  This is also required to
> - * maintain the notion that we use a ordered wait queue to hold off would be
> - * writers to the log when every iclog is trying to sync to disk.
> - *
> - * Caller must hold the icloglock before calling us.
> - *
> - * State Change: !IOERROR -> DIRTY -> ACTIVE
> + * Loop through all iclogs and mark all iclogs currently marked DIRTY as
> + * ACTIVE after iclog I/O has completed.
>   */
> -STATIC void
> -xlog_state_clean_iclog(
> +static void
> +xlog_state_activate_iclogs(
>  	struct xlog		*log,
> -	struct xlog_in_core	*dirty_iclog)
> +	int			*iclogs_changed)
>  {
> -	struct xlog_in_core	*iclog;
> -	int			changed = 0;
> -
> -	/* Prepare the completed iclog. */
> -	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
> -		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
> +	struct xlog_in_core	*iclog = log->l_iclog;
>  
> -	/* Walk all the iclogs to update the ordered active state. */
> -	iclog = log->l_iclog;
>  	do {
> -		if (iclog->ic_state == XLOG_STATE_DIRTY) {
> -			iclog->ic_state	= XLOG_STATE_ACTIVE;
> -			iclog->ic_offset       = 0;
> -			ASSERT(list_empty_careful(&iclog->ic_callbacks));
> -			/*
> -			 * If the number of ops in this iclog indicate it just
> -			 * contains the dummy transaction, we can
> -			 * change state into IDLE (the second time around).
> -			 * Otherwise we should change the state into
> -			 * NEED a dummy.
> -			 * We don't need to cover the dummy.
> -			 */
> -			if (!changed &&
> -			   (be32_to_cpu(iclog->ic_header.h_num_logops) ==
> -			   		XLOG_COVER_OPS)) {
> -				changed = 1;
> -			} else {
> -				/*
> -				 * We have two dirty iclogs so start over
> -				 * This could also be num of ops indicates
> -				 * this is not the dummy going out.
> -				 */
> -				changed = 2;
> -			}
> -			iclog->ic_header.h_num_logops = 0;
> -			memset(iclog->ic_header.h_cycle_data, 0,
> -			      sizeof(iclog->ic_header.h_cycle_data));
> -			iclog->ic_header.h_lsn = 0;
> -		} else if (iclog->ic_state == XLOG_STATE_ACTIVE)
> -			/* do nothing */;
> -		else
> -			break;	/* stop cleaning */
> -		iclog = iclog->ic_next;
> -	} while (iclog != log->l_iclog);
> -
> +		if (iclog->ic_state == XLOG_STATE_DIRTY)
> +			xlog_state_activate_iclog(iclog, iclogs_changed);
> +		/*
> +		 * The ordering of marking iclogs ACTIVE must be maintained, so
> +		 * an iclog doesn't become ACTIVE beyond one that is SYNCING.
> +		 */
> +		else if (iclog->ic_state != XLOG_STATE_ACTIVE)
> +			break;
> +	} while ((iclog = iclog->ic_next) != log->l_iclog);
> +}
>  
> +static int
> +xlog_covered_state(
> +	struct xlog		*log,
> +	int			iclogs_changed)
> +{
>  	/*
> -	 * Wake up threads waiting in xfs_log_force() for the dirty iclog
> -	 * to be cleaned.
> +	 * We usually go to NEED. But we go to NEED2 if the changed indicates we
> +	 * are done writing the dummy record.  If we are done with the second
> +	 * dummy recored (DONE2), then we go to IDLE.
>  	 */
> -	wake_up_all(&dirty_iclog->ic_force_wait);
> +	switch (log->l_covered_state) {
> +	case XLOG_STATE_COVER_IDLE:
> +	case XLOG_STATE_COVER_NEED:
> +	case XLOG_STATE_COVER_NEED2:
> +		break;
> +	case XLOG_STATE_COVER_DONE:
> +		if (iclogs_changed == 1)
> +			return XLOG_STATE_COVER_NEED2;
> +		break;
> +	case XLOG_STATE_COVER_DONE2:
> +		if (iclogs_changed == 1)
> +			return XLOG_STATE_COVER_IDLE;
> +		break;
> +	default:
> +		ASSERT(0);
> +	}
>  
> -	/*
> -	 * Change state for the dummy log recording.
> -	 * We usually go to NEED. But we go to NEED2 if the changed indicates
> -	 * we are done writing the dummy record.
> -	 * If we are done with the second dummy recored (DONE2), then
> -	 * we go to IDLE.
> -	 */
> -	if (changed) {
> -		switch (log->l_covered_state) {
> -		case XLOG_STATE_COVER_IDLE:
> -		case XLOG_STATE_COVER_NEED:
> -		case XLOG_STATE_COVER_NEED2:
> -			log->l_covered_state = XLOG_STATE_COVER_NEED;
> -			break;
> +	return XLOG_STATE_COVER_NEED;
> +}
>  
> -		case XLOG_STATE_COVER_DONE:
> -			if (changed == 1)
> -				log->l_covered_state = XLOG_STATE_COVER_NEED2;
> -			else
> -				log->l_covered_state = XLOG_STATE_COVER_NEED;
> -			break;
> +STATIC void
> +xlog_state_clean_iclog(
> +	struct xlog		*log,
> +	struct xlog_in_core	*dirty_iclog)
> +{
> +	int			iclogs_changed = 0;
>  
> -		case XLOG_STATE_COVER_DONE2:
> -			if (changed == 1)
> -				log->l_covered_state = XLOG_STATE_COVER_IDLE;
> -			else
> -				log->l_covered_state = XLOG_STATE_COVER_NEED;
> -			break;
> +	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
> +		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
>  
> -		default:
> -			ASSERT(0);
> -		}
> -	}
> +	xlog_state_activate_iclogs(log, &iclogs_changed);
> +	wake_up_all(&dirty_iclog->ic_force_wait);
> +
> +	if (iclogs_changed)
> +		log->l_covered_state = xlog_covered_state(log, iclogs_changed);
>  }
>  
>  STATIC xfs_lsn_t
> -- 
> 2.24.1
> 
