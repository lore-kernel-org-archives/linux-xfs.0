Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB91C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 16:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C1552082E
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 16:00:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ekappq9P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732028AbfIEQAN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 12:00:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59140 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732011AbfIEQAN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 12:00:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85FxkZB134567;
        Thu, 5 Sep 2019 16:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=elII75Cb2lL4fs6q/z30EX5M8CGPmSZGirHD+tMcjpY=;
 b=Ekappq9PSbb9IVXr50Ypyxum/QpUztLDkaSA8KW3dNQYcDtQ1gkeBcayDTaVY1VPDiNy
 WwhzHluCPHJF8UKDt9izg8t26jTc3kEmkKr4rUuVugpNhLQubj2ZdyIyUo7Uw1DJ8S8Y
 ub8LOzYBfyVF1NV93CdN87Q2CJfwLM7BpBTw4Vki4LqzoMClIaVcIetJvfNsdj1llLNx
 IdpkuGLwHJt7AaOvFtyWpKEyrXgJ6K8TBOIhLEZGxuuPFiCZUXWYCIW+RmGo9ppDATdI
 Mz0cjWTOLw0jSbnuIPpzteSXgbVhjyCUeXfKb6ZkeqKlPDanJoKhEWgsPjqg2eN7ONOZ Ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uu5g6007q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 16:00:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85Fwin4126400;
        Thu, 5 Sep 2019 16:00:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2utpmbe7qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 16:00:09 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x85G086M024282;
        Thu, 5 Sep 2019 16:00:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 09:00:08 -0700
Date:   Thu, 5 Sep 2019 09:00:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: push the grant head when the log head moves
 forward
Message-ID: <20190905160007.GI2229799@magnolia>
References: <20190905084717.30308-1-david@fromorbit.com>
 <20190905084717.30308-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905084717.30308-9-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 06:47:17PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When the log fills up, we can get into the state where the
> outstanding items in the CIL being committed and aggregated are
> larger than the range that the reservation grant head tail pushing
> will attempt to clean. This can result in the tail pushing range
> being trimmed back to the the log head (l_last_sync_lsn) and so
> may not actually move the push target at all.
> 
> When the iclogs associated with the CIL commit finally land, the
> log head moves forward, and this removes the restriction on the AIL
> push target. However, if we already have transactions sleeping on
> the grant head, and there's nothing in the AIL still to flush from
> the current push target, then nothing will move the tail of the log
> and trigger a log reservation wakeup.
> 
> Hence the there is nothing that will trigger xlog_grant_push_ail()
> to recalculate the AIL push target and start pushing on the AIL
> again to write back the metadata objects that pin the tail of the
> log and hence free up space and allow the transaction reservations
> to be woken and make progress.
> 
> Hence we need to push on the grant head when we move the log head
> forward, as this may be the only trigger we have that can move the
> AIL push target forwards in this situation.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Seems reasonable to me.

There's two unfortunate twists for applying this series -- there won't be
any new for-next trees from Stephen Rothwell until Sept. 30th, which
means we (XFS developers) are all pretty much on our own for testing
this in the xfs for-next branch.

The second twist of course is that I'm leaving Friday afternoon for a
vacation.  That means either (a) everything passes muster, I fix the
comment nits, and push this into xfs for-next before I go; (b) there are
deeper review comments and so this waits until I return on the 16th; or
(c) I guess Dave could tack it on for-next himself when the patches are
ready since he still has commit access. ;)

Either way this probably means a separate pull request for the log fixes
during the second week of the merge window.  Thoughts/flames?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 72 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 47 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index bef314361bc4..f90765af6916 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2648,6 +2648,46 @@ xlog_get_lowest_lsn(
>  	return lowest_lsn;
>  }
>  
> +/*
> + * Completion of a iclog IO does not imply that a transaction has completed, as
> + * transactions can be large enough to span many iclogs. We cannot change the
> + * tail of the log half way through a transaction as this may be the only
> + * transaction in the log and moving the tail to point to the middle of it
> + * will prevent recovery from finding the start of the transaction. Hence we
> + * should only update the last_sync_lsn if this iclog contains transaction
> + * completion callbacks on it.
> + *
> + * We have to do this before we drop the icloglock to ensure we are the only one
> + * that can update it.
> + *
> + * If we are moving the last_sync_lsn forwards, we also need to ensure we kick
> + * the reservation grant head pushing. This is due to the fact that the push
> + * target is bound by the current last_sync_lsn value. Hence if we have a large
> + * amount of log space bound up in this committing transaction then the
> + * last_sync_lsn value may be the limiting factor preventing tail pushing from
> + * freeing space in the log. Hence once we've updated the last_sync_lsn we
> + * should push the AIL to ensure the push target (and hence the grant head) is
> + * no longer bound by the old log head location and can move forwards and make
> + * progress again.
> + */
> +static void
> +xlog_state_set_callback(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog,
> +	xfs_lsn_t		header_lsn)
> +{
> +	iclog->ic_state = XLOG_STATE_CALLBACK;
> +
> +	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> +			   header_lsn) <= 0);
> +
> +	if (list_empty_careful(&iclog->ic_callbacks))
> +		return;
> +
> +	atomic64_set(&log->l_last_sync_lsn, header_lsn);
> +	xlog_grant_push_ail(log, 0);
> +}
> +
>  /*
>   * Return true if we need to stop processing, false to continue to the next
>   * iclog. The caller will need to run callbacks if the iclog is returned in the
> @@ -2661,6 +2701,7 @@ xlog_state_iodone_process_iclog(
>  	bool			*ioerror)
>  {
>  	xfs_lsn_t		lowest_lsn;
> +	xfs_lsn_t		header_lsn;
>  
>  	/* Skip all iclogs in the ACTIVE & DIRTY states */
>  	if (iclog->ic_state & (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY))
> @@ -2700,34 +2741,15 @@ xlog_state_iodone_process_iclog(
>  	 * callbacks) see the above if.
>  	 *
>  	 * We will do one more check here to see if we have chased our tail
> -	 * around.
> +	 * around. If this is not the lowest lsn iclog, then we will leave it
> +	 * for another completion to process.
>  	 */
> +	header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  	lowest_lsn = xlog_get_lowest_lsn(log);
> -	if (lowest_lsn &&
> -	    XFS_LSN_CMP(lowest_lsn, be64_to_cpu(iclog->ic_header.h_lsn)) < 0)
> -		return false; /* Leave this iclog for another thread */
> -
> -	iclog->ic_state = XLOG_STATE_CALLBACK;
> -
> -	/*
> -	 * Completion of a iclog IO does not imply that a transaction has
> -	 * completed, as transactions can be large enough to span many iclogs.
> -	 * We cannot change the tail of the log half way through a transaction
> -	 * as this may be the only transaction in the log and moving th etail to
> -	 * point to the middle of it will prevent recovery from finding the
> -	 * start of the transaction.  Hence we should only update the
> -	 * last_sync_lsn if this iclog contains transaction completion callbacks
> -	 * on it.
> -	 *
> -	 * We have to do this before we drop the icloglock to ensure we are the
> -	 * only one that can update it.
> -	 */
> -	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> -			be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
> -	if (!list_empty_careful(&iclog->ic_callbacks))
> -		atomic64_set(&log->l_last_sync_lsn,
> -			be64_to_cpu(iclog->ic_header.h_lsn));
> +	if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
> +		return false;
>  
> +	xlog_state_set_callback(log, iclog, header_lsn);
>  	return false;
>  
>  }
> -- 
> 2.23.0.rc1
> 
