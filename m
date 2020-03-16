Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148B6C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D26EA20658
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jG9GycKY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732638AbgCPVIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:08:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57532 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732624AbgCPVIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 17:08:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKqqnG132266;
        Mon, 16 Mar 2020 21:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=SFbcM3y+z+5JOEeZhtSn9oK5nHgTcpg0fLM8mdyLMPI=;
 b=jG9GycKYemUsR6o8oMGbZCN1oFs7TtabUzicUXFdCV1bBljLqEfsoZDL4tnu4XQ+QeiI
 6Pe10IujtKEBPWoPxw0oM+SZnNq+XkWnUGSjoYFfbFVCWnHhPuh2nSuEBRq6Ea7YMoNK
 OgfmPAmEY7KLkA77JR8Ow1/XIxT5cianTHC6OchkOCF3QxBWMy4S+7mWYP1jsZVBl0NP
 Z8Zl0wsihBCGVm01iJgcKUpM1qaxrCmEP8HfttOAeHo+tLBu+9JaKoh2BGdvekxoc0X7
 EIA0k3+klP+1reZh61tZZxshOMPXacw2RIDrNn94ZtMcJ/wns81rlt0n2SJyQdIBh0Gy fQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yrq7ksaaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:07:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GL7Uoq039097;
        Mon, 16 Mar 2020 21:07:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ys92ar3s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:07:55 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GL7s3v032260;
        Mon, 16 Mar 2020 21:07:54 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 14:07:54 -0700
Date:   Mon, 16 Mar 2020 14:07:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/14] xfs: refactor xlog_state_iodone_process_iclog
Message-ID: <20200316210753.GO256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-11-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160087
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:29PM +0100, Christoph Hellwig wrote:
> Move all state checks into the caller to make the loop flow more clear,
> and instead move the callback processing together with marking the iclog
> for callbacks.
> 
> This also allows to easily indicate when we actually dropped the
> icloglock instead of assuming we do so for any iclog processed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ok, I think this is a pretty straightfoward hoisting of the the state
checksk, as promised...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 82 ++++++++++++++++++++++--------------------------
>  1 file changed, 37 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4efaa248a03d..a38d495b6e81 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2738,47 +2738,28 @@ xlog_state_do_iclog_callbacks(
>  	spin_unlock(&iclog->ic_callback_lock);
>  }
>  
> -/*
> - * Return true if we need to stop processing, false to continue to the next
> - * iclog. The caller will need to run callbacks if the iclog is returned in the
> - * XLOG_STATE_CALLBACK state.
> - */
>  static bool
>  xlog_state_iodone_process_iclog(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog)
>  {
> -	xfs_lsn_t		lowest_lsn;
> -	xfs_lsn_t		header_lsn;
> +	xfs_lsn_t		header_lsn, lowest_lsn;
>  
> -	switch (iclog->ic_state) {
> -	case XLOG_STATE_ACTIVE:
> -	case XLOG_STATE_DIRTY:
> -		/*
> -		 * Skip all iclogs in the ACTIVE & DIRTY states:
> -		 */
> -		return false;
> -	case XLOG_STATE_DONE_SYNC:
> -		/*
> -		 * Now that we have an iclog that is in the DONE_SYNC state, do
> -		 * one more check here to see if we have chased our tail around.
> -		 * If this is not the lowest lsn iclog, then we will leave it
> -		 * for another completion to process.
> -		 */
> -		header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> -		lowest_lsn = xlog_get_lowest_lsn(log);
> -		if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
> -			return false;
> -		xlog_state_set_callback(log, iclog, header_lsn);
> +	/*
> +	 * Now that we have an iclog that is in the DONE_SYNC state, do one more
> +	 * check here to see if we have chased our tail around.  If this is not
> +	 * the lowest lsn iclog, then we will leave it for another completion to
> +	 * process.
> +	 */
> +	header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +	lowest_lsn = xlog_get_lowest_lsn(log);
> +	if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
>  		return false;
> -	default:
> -		/*
> -		 * Can only perform callbacks in order.  Since this iclog is not
> -		 * in the DONE_SYNC state, we skip the rest and just try to
> -		 * clean up.
> -		 */
> -		return true;
> -	}
> +
> +	xlog_state_set_callback(log, iclog, header_lsn);
> +	xlog_state_do_iclog_callbacks(log, iclog);
> +	xlog_state_clean_iclog(log, iclog);
> +	return true;
>  }
>  
>  STATIC void
> @@ -2795,10 +2776,6 @@ xlog_state_do_callback(
>  	 *
>  	 * Keep looping through iclogs until one full pass is made without
>  	 * running any callbacks.
> -	 *
> -	 * If the log has been shut down, still perform the callbacks once per
> -	 * iclog to abort all log items, but don't bother to restart the loop
> -	 * after dropping the log as no new callbacks can show up.
>  	 */
>  	spin_lock(&log->l_icloglock);
>  	do {
> @@ -2809,25 +2786,40 @@ xlog_state_do_callback(
>  		repeats++;
>  
>  		do {
> +			/*
> +			 * If the log has been shut down, still perform the
> +			 * callbacks to abort all log items to clean up any
> +			 * allocate resource, but don't bother to restart the
> +			 * loop after dropping the log as no new callbacks can
> +			 * be attached now.
> +			 */
>  			if (XLOG_FORCED_SHUTDOWN(log)) {
>  				xlog_state_do_iclog_callbacks(log, iclog);
>  				wake_up_all(&iclog->ic_force_wait);
>  				continue;
>  			}
>  
> -			if (xlog_state_iodone_process_iclog(log, iclog))
> -				break;
> -
> -			if (iclog->ic_state != XLOG_STATE_CALLBACK)
> +			/*
> +			 * Skip all iclogs in the ACTIVE & DIRTY states:
> +			 */
> +			if (iclog->ic_state == XLOG_STATE_ACTIVE ||
> +			    iclog->ic_state == XLOG_STATE_DIRTY)
>  				continue;
>  
> +			/*
> +			 * We can only perform callbacks in order.  If this
> +			 * iclog is not in the DONE_SYNC state, we skip the rest
> +			 * and just try to clean up.
> +			 */
> +			if (iclog->ic_state != XLOG_STATE_DONE_SYNC)
> +				break;
> +
>  			/*
>  			 * Running callbacks will drop the icloglock which means
>  			 * we'll have to run at least one more complete loop.
>  			 */
> -			cycled_icloglock = true;
> -			xlog_state_do_iclog_callbacks(log, iclog);
> -			xlog_state_clean_iclog(log, iclog);
> +			if (xlog_state_iodone_process_iclog(log, iclog))
> +				cycled_icloglock = true;
>  		} while ((iclog = iclog->ic_next) != first_iclog);
>  
>  		if (repeats > 5000) {
> -- 
> 2.24.1
> 
