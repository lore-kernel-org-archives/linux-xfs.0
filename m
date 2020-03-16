Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9C6C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9809C20674
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:25:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lA8G5JjM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732634AbgCPVZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:25:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732621AbgCPVZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 17:25:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GL8lSs051082;
        Mon, 16 Mar 2020 21:25:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VbJJRx1Shzy1NzOVeoKqRvYk0AsKYn114pDbMxysNL4=;
 b=lA8G5JjMyKLBKmvnsWbALZaidbo1UilvglAq60QoCmwh9vMu3j1tQvFDxA4SjmT7kGoC
 B2ro2+Vabxfm/7Z640rDrvlY2kKs9LejxsC5e6JaLo0PS5eKxr1TRszX5MyW10kGdQf3
 cJRJSPB0jopXKfzU9f1Qre6XDUEkma1sJ1RK0hSF82xn3xVRaHsTs5DWeM3EI1Ac7xDo
 quhDYDgZmlC+IUv2sPtrhwr2u2++A3BNhGBAxofRIPKTmcS9NNaGMLph54+ykYd1XBqq
 ePZLAKTf5dZD3d1l36UAIszVua1VR4Rk4+GP2Iqgy9a5GnDcjaGwl5eXIJJzZTJGmmol HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yrq7ksc9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:25:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GLKWn9050186;
        Mon, 16 Mar 2020 21:25:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ys8ywme4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:25:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02GLPfqC013520;
        Mon, 16 Mar 2020 21:25:42 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 14:25:40 -0700
Date:   Mon, 16 Mar 2020 14:25:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/14] xfs: remove XLOG_STATE_IOERROR
Message-ID: <20200316212539.GS256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-15-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160088
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:33PM +0100, Christoph Hellwig wrote:
> Just check the shutdown flag in struct xlog, instead of replicating the
> information into each iclog and checking it there.
> 
> As the iclog state is now not overload with the shut down information
> various places that check for a specific state now don't need to account
> for the fake IOERROR state.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 68 +++++++++++--------------------------------
>  fs/xfs/xfs_log_cil.c  |  2 +-
>  fs/xfs/xfs_log_priv.h |  1 -
>  3 files changed, 18 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 761b138d97ec..07023372ccbd 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -578,7 +578,7 @@ xlog_state_release_iclog(
>  {
>  	lockdep_assert_held(&log->l_icloglock);
>  
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (XLOG_FORCED_SHUTDOWN(log))
>  		return -EIO;
>  
>  	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
> @@ -599,7 +599,7 @@ xfs_log_release_iclog(
>  	bool			sync = false;
>  
>  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> -		if (iclog->ic_state != XLOG_STATE_IOERROR)
> +		if (!XLOG_FORCED_SHUTDOWN(log))
>  			sync = __xlog_state_release_iclog(log, iclog);
>  		spin_unlock(&log->l_icloglock);
>  	}
> @@ -924,7 +924,7 @@ xfs_log_write_unmount_record(
>  	error = xlog_write(log, &vec, tic, &lsn, NULL, flags);
>  	/*
>  	 * At this point, we're umounting anyway, so there's no point in
> -	 * transitioning log state to IOERROR. Just continue...
> +	 * transitioning log state to IO_ERROR. Just continue...

"...so there's no point in marking the log as shut down."?

There's no IOERROR state anymore, right?

--D

>  	 */
>  out_err:
>  	if (error)
> @@ -936,8 +936,7 @@ xfs_log_write_unmount_record(
>  	if (iclog->ic_state == XLOG_STATE_ACTIVE)
>  		xlog_state_switch_iclogs(log, iclog, 0);
>  	else
> -		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -		       iclog->ic_state == XLOG_STATE_IOERROR);
> +		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);
>  	error = xlog_state_release_iclog(log, iclog);
>  	xlog_wait_on_iclog(iclog);
>  
> @@ -1740,7 +1739,7 @@ xlog_write_iclog(
>  	 * across the log IO to archieve that.
>  	 */
>  	down(&iclog->ic_sema);
> -	if (unlikely(iclog->ic_state == XLOG_STATE_IOERROR)) {
> +	if (XLOG_FORCED_SHUTDOWN(log)) {
>  		/*
>  		 * It would seem logical to return EIO here, but we rely on
>  		 * the log state machine to propagate I/O errors instead of
> @@ -2295,8 +2294,7 @@ xlog_write_copy_finish(
>  		if (iclog->ic_state == XLOG_STATE_ACTIVE)
>  			xlog_state_switch_iclogs(log, iclog, 0);
>  		else
> -			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -			       iclog->ic_state == XLOG_STATE_IOERROR);
> +			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);
>  		if (!commit_iclog)
>  			goto release_iclog;
>  		spin_unlock(&log->l_icloglock);
> @@ -2817,8 +2815,7 @@ xlog_state_do_callback(
>  		}
>  	} while (cycled_icloglock);
>  
> -	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
> -	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE)
>  		wake_up_all(&log->l_flush_wait);
>  
>  	spin_unlock(&log->l_icloglock);
> @@ -3167,7 +3164,7 @@ xfs_log_force(
>  
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (XLOG_FORCED_SHUTDOWN(log))
>  		goto out_error;
>  
>  	if (iclog->ic_state == XLOG_STATE_DIRTY ||
> @@ -3240,7 +3237,7 @@ __xfs_log_force_lsn(
>  
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> +	if (XLOG_FORCED_SHUTDOWN(log))
>  		goto out_error;
>  
>  	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
> @@ -3691,34 +3688,6 @@ xlog_verify_iclog(
>  }	/* xlog_verify_iclog */
>  #endif
>  
> -/*
> - * Mark all iclogs IOERROR. l_icloglock is held by the caller.
> - */
> -STATIC int
> -xlog_state_ioerror(
> -	struct xlog	*log)
> -{
> -	xlog_in_core_t	*iclog, *ic;
> -
> -	iclog = log->l_iclog;
> -	if (iclog->ic_state != XLOG_STATE_IOERROR) {
> -		/*
> -		 * Mark all the incore logs IOERROR.
> -		 * From now on, no log flushes will result.
> -		 */
> -		ic = iclog;
> -		do {
> -			ic->ic_state = XLOG_STATE_IOERROR;
> -			ic = ic->ic_next;
> -		} while (ic != iclog);
> -		return 0;
> -	}
> -	/*
> -	 * Return non-zero, if state transition has already happened.
> -	 */
> -	return 1;
> -}
> -
>  /*
>   * This is called from xfs_force_shutdown, when we're forcibly
>   * shutting down the filesystem, typically because of an IO error.
> @@ -3740,10 +3709,8 @@ xfs_log_force_umount(
>  	struct xfs_mount	*mp,
>  	int			logerror)
>  {
> -	struct xlog	*log;
> -	int		retval;
> -
> -	log = mp->m_log;
> +	struct xlog		*log = mp->m_log;
> +	int			retval = 0;
>  
>  	/*
>  	 * If this happens during log recovery, don't worry about
> @@ -3761,10 +3728,8 @@ xfs_log_force_umount(
>  	 * Somebody could've already done the hard work for us.
>  	 * No need to get locks for this.
>  	 */
> -	if (logerror && log->l_iclog->ic_state == XLOG_STATE_IOERROR) {
> -		ASSERT(XLOG_FORCED_SHUTDOWN(log));
> +	if (logerror && XLOG_FORCED_SHUTDOWN(log))
>  		return 1;
> -	}
>  
>  	/*
>  	 * Flush all the completed transactions to disk before marking the log
> @@ -3786,11 +3751,13 @@ xfs_log_force_umount(
>  		mp->m_sb_bp->b_flags |= XBF_DONE;
>  
>  	/*
> -	 * Mark the log and the iclogs with IO error flags to prevent any
> -	 * further log IO from being issued or completed.
> +	 * Mark the log as shut down to prevent any further log IO from being
> +	 * issued or completed.  Return non-zero if log IO_ERROR transition had
> +	 * already happened so that the caller can skip further processing.
>  	 */
> +	if (XLOG_FORCED_SHUTDOWN(log))
> +		retval = 1;
>  	log->l_flags |= XLOG_IO_ERROR;
> -	retval = xlog_state_ioerror(log);
>  	spin_unlock(&log->l_icloglock);
>  
>  	/*
> @@ -3814,7 +3781,6 @@ xfs_log_force_umount(
>  	spin_unlock(&log->l_cilp->xc_push_lock);
>  	xlog_state_do_callback(log);
>  
> -	/* return non-zero if log IOERROR transition had already happened */
>  	return retval;
>  }
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index adc4af336c97..a93097cf0990 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -845,7 +845,7 @@ xlog_cil_push_work(
>  		goto out_abort;
>  
>  	spin_lock(&commit_iclog->ic_callback_lock);
> -	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
> +	if (XLOG_FORCED_SHUTDOWN(log)) {
>  		spin_unlock(&commit_iclog->ic_callback_lock);
>  		goto out_abort;
>  	}
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 2b0aec37e73e..f3f4a35ce153 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -47,7 +47,6 @@ enum xlog_iclog_state {
>  	XLOG_STATE_DONE_SYNC,	/* Done syncing to disk */
>  	XLOG_STATE_CALLBACK,	/* Callback functions now */
>  	XLOG_STATE_DIRTY,	/* Dirty IC log, not ready for ACTIVE status */
> -	XLOG_STATE_IOERROR,	/* IO error happened in sync'ing log */
>  };
>  
>  /*
> -- 
> 2.24.1
> 
