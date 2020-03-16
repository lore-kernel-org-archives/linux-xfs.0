Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8585C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1BF6205ED
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nkTKT82s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732607AbgCPVK4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:10:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732567AbgCPVK4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 17:10:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GL9usj003061;
        Mon, 16 Mar 2020 21:10:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5NmTdcdtdNf86mF/D6hFR28Y6FzW8qG9REKFtjYSMus=;
 b=nkTKT82s+2ip8K4oi1AAqhnBtTW2j+shqCh5eOKbsvgL42T0ZHspfyYZVs0HsbLCh9WB
 pusiSuh2LR8gV2eDcJOnCH9nZv70pgmN3q5Ipn1rVz1qQ836Z5uZZb6gARCmM+xZpAAB
 FFuZChaECNKJpAZ+iSHIhfDB+bkBa0OYXn5dwLUOa8gy402Fkz1JFa3iW2ZT+Rj1RpHl
 UfjMh+zHkqsWJvtvoB3xgK4P9en4bJtGT2SNNDrJbQm1DrKRI4DoxRgQ32zwC+Fp/mNl
 sOzH5YsWi2jONINwoooM843zSw3Lp3PwL5oOQRlm7gSwARj2m2/O8llDkvDAvTVpFua9 QA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yrqwn182k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:10:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GL8c5o148743;
        Mon, 16 Mar 2020 21:10:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ys8ywkjg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:10:51 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GLAoUM030615;
        Mon, 16 Mar 2020 21:10:50 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 14:10:50 -0700
Date:   Mon, 16 Mar 2020 14:10:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/14] xfs: merge xlog_state_set_callback into
 xlog_state_iodone_process_iclog
Message-ID: <20200316211049.GQ256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-13-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160088
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:31PM +0100, Christoph Hellwig wrote:
> Merge xlog_state_set_callback into its only caller, which makes the iclog
> I/O completion handling a little easier to follow.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 74 +++++++++++++++++++++---------------------------
>  1 file changed, 33 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 899c324d07e2..865dd1e08679 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2645,46 +2645,6 @@ xlog_get_lowest_lsn(
>  	return lowest_lsn;
>  }
>  
> -/*
> - * Completion of a iclog IO does not imply that a transaction has completed, as
> - * transactions can be large enough to span many iclogs. We cannot change the
> - * tail of the log half way through a transaction as this may be the only
> - * transaction in the log and moving the tail to point to the middle of it
> - * will prevent recovery from finding the start of the transaction. Hence we
> - * should only update the last_sync_lsn if this iclog contains transaction
> - * completion callbacks on it.
> - *
> - * We have to do this before we drop the icloglock to ensure we are the only one
> - * that can update it.
> - *
> - * If we are moving the last_sync_lsn forwards, we also need to ensure we kick
> - * the reservation grant head pushing. This is due to the fact that the push
> - * target is bound by the current last_sync_lsn value. Hence if we have a large
> - * amount of log space bound up in this committing transaction then the
> - * last_sync_lsn value may be the limiting factor preventing tail pushing from
> - * freeing space in the log. Hence once we've updated the last_sync_lsn we
> - * should push the AIL to ensure the push target (and hence the grant head) is
> - * no longer bound by the old log head location and can move forwards and make
> - * progress again.
> - */
> -static void
> -xlog_state_set_callback(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog,
> -	xfs_lsn_t		header_lsn)
> -{
> -	iclog->ic_state = XLOG_STATE_CALLBACK;
> -
> -	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> -			   header_lsn) <= 0);
> -
> -	if (list_empty_careful(&iclog->ic_callbacks))
> -		return;
> -
> -	atomic64_set(&log->l_last_sync_lsn, header_lsn);
> -	xlog_grant_push_ail(log, 0);
> -}
> -
>  /*
>   * Keep processing entries in the iclog callback list until we come around and
>   * it is empty.  We need to atomically see that the list is empty and change the
> @@ -2741,7 +2701,39 @@ xlog_state_iodone_process_iclog(
>  	if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
>  		return false;
>  
> -	xlog_state_set_callback(log, iclog, header_lsn);
> +	iclog->ic_state = XLOG_STATE_CALLBACK;
> +
> +	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> +			   header_lsn) <= 0);
> +
> +	/*
> +	 * Completion of an iclog I/O does not imply that a transaction has
> +	 * completed, as transactions can be large enough to span multiple
> +	 * iclogs.  We cannot change the tail of the log half way through a
> +	 * transaction as this may be the only transaction in the log and moving
> +	 * the tail to point to the middle of it will prevent recovery from
> +	 * finding the start of the transaction. Hence we should only update
> +	 * the last_sync_lsn if this iclog contains transaction completion
> +	 * callbacks on it.
> +	 *
> +	 * We have to do this before we drop the icloglock to ensure we are the
> +	 * only one that can update it.
> +	 *
> +	 * If we are moving last_sync_lsn forwards, we also need to ensure we
> +	 * kick the reservation grant head pushing. This is due to the fact that
> +	 * the push target is bound by the current last_sync_lsn value.  If we
> +	 * have a large amount of log space bound up in this committing
> +	 * transaction then the last_sync_lsn value may be the limiting factor
> +	 * preventing tail pushing from freeing space in the log.  Hence once
> +	 * we've updated the last_sync_lsn we should push the AIL to ensure the
> +	 * push target (and hence the grant head) is no longer bound by the old
> +	 * log head location and can move forwards and make progress again.
> +	 */
> +	if (!list_empty_careful(&iclog->ic_callbacks)) {
> +		atomic64_set(&log->l_last_sync_lsn, header_lsn);
> +		xlog_grant_push_ail(log, 0);
> +	}
> +
>  	xlog_state_do_iclog_callbacks(log, iclog);
>  
>  	iclog->ic_state = XLOG_STATE_DIRTY;
> -- 
> 2.24.1
> 
