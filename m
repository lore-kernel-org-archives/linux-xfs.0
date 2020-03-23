Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1534C54EEB
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 15:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B643206F9
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 15:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zWt8954e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgCWP1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 11:27:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48368 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbgCWP1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 11:27:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02NF9GFA117918;
        Mon, 23 Mar 2020 15:27:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=moKe7YZksVlxNiTRblrghQvzHI+048HxmC0MbEgpmE8=;
 b=zWt8954eqg9aGhAVSC9Cb1HWH1L5fwz/qrB7Ix+hxoH8C0h8MSHNmfaNnVOeBJjkSjQf
 pH/buUgK2p/71Isk5WrOwUBW2zJmt/wTY1dV368n0AejL/MxQqupWYEaJFyiwR4pJ9kF
 5GslrObWBgglTDSd3u8FRo39WW/Mlula2P+tujah9yrwCMTQB6DsR3+W6kDgYT75b4HY
 ShCaWKDUzm37Y8EvHE1MF2KSru5Y5X3WuAA4DMVK9maz62FjV++guNqqBRS5ffgf13LC
 /m9NlurcVQOd7aoKHi36U6I6HCuYYlNGMufXoHQFOaRwtHt9UXdQM+vki1/pkepF7a/v WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ywavky8g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 15:27:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02NFJnhW068307;
        Mon, 23 Mar 2020 15:27:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yxw7fnmx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 15:27:08 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02NFR8aA004553;
        Mon, 23 Mar 2020 15:27:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Mar 2020 08:27:07 -0700
Date:   Mon, 23 Mar 2020 08:27:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/8] xfs: remove the aborted parameter to
 xlog_state_done_syncing
Message-ID: <20200323152706.GB29339@magnolia>
References: <20200320065311.28134-1-hch@lst.de>
 <20200320065311.28134-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320065311.28134-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 suspectscore=2 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003230086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=2 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003230086
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 20, 2020 at 07:53:08AM +0100, Christoph Hellwig wrote:
> We can just check for a shut down log all the way down in
> xlog_cil_committed instead of passing the parameter.  This means a
> slight behavior change in that we now also abort log items if the
> shutdown came in halfway into the I/O completion processing, which
> actually is the right thing to do.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok now that I've gotten myself straightened out :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c     | 48 +++++++++++++++-----------------------------
>  fs/xfs/xfs_log.h     |  2 +-
>  fs/xfs/xfs_log_cil.c | 12 +++++------
>  3 files changed, 23 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7af9c292540b..4f9303524efb 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -47,8 +47,7 @@ xlog_dealloc_log(
>  
>  /* local state machine functions */
>  STATIC void xlog_state_done_syncing(
> -	struct xlog_in_core	*iclog,
> -	bool			aborted);
> +	struct xlog_in_core	*iclog);
>  STATIC int
>  xlog_state_get_iclog_space(
>  	struct xlog		*log,
> @@ -1254,7 +1253,6 @@ xlog_ioend_work(
>  	struct xlog_in_core     *iclog =
>  		container_of(work, struct xlog_in_core, ic_end_io_work);
>  	struct xlog		*log = iclog->ic_log;
> -	bool			aborted = false;
>  	int			error;
>  
>  	error = blk_status_to_errno(iclog->ic_bio.bi_status);
> @@ -1270,17 +1268,9 @@ xlog_ioend_work(
>  	if (XFS_TEST_ERROR(error, log->l_mp, XFS_ERRTAG_IODONE_IOERR)) {
>  		xfs_alert(log->l_mp, "log I/O error %d", error);
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> -		/*
> -		 * This flag will be propagated to the trans-committed
> -		 * callback routines to let them know that the log-commit
> -		 * didn't succeed.
> -		 */
> -		aborted = true;
> -	} else if (iclog->ic_state == XLOG_STATE_IOERROR) {
> -		aborted = true;
>  	}
>  
> -	xlog_state_done_syncing(iclog, aborted);
> +	xlog_state_done_syncing(iclog);
>  	bio_uninit(&iclog->ic_bio);
>  
>  	/*
> @@ -1759,7 +1749,7 @@ xlog_write_iclog(
>  		 * the buffer manually, the code needs to be kept in sync
>  		 * with the I/O completion path.
>  		 */
> -		xlog_state_done_syncing(iclog, true);
> +		xlog_state_done_syncing(iclog);
>  		up(&iclog->ic_sema);
>  		return;
>  	}
> @@ -2783,8 +2773,7 @@ xlog_state_iodone_process_iclog(
>  static void
>  xlog_state_do_iclog_callbacks(
>  	struct xlog		*log,
> -	struct xlog_in_core	*iclog,
> -	bool			aborted)
> +	struct xlog_in_core	*iclog)
>  		__releases(&log->l_icloglock)
>  		__acquires(&log->l_icloglock)
>  {
> @@ -2796,7 +2785,7 @@ xlog_state_do_iclog_callbacks(
>  		list_splice_init(&iclog->ic_callbacks, &tmp);
>  
>  		spin_unlock(&iclog->ic_callback_lock);
> -		xlog_cil_process_committed(&tmp, aborted);
> +		xlog_cil_process_committed(&tmp);
>  		spin_lock(&iclog->ic_callback_lock);
>  	}
>  
> @@ -2811,8 +2800,7 @@ xlog_state_do_iclog_callbacks(
>  
>  STATIC void
>  xlog_state_do_callback(
> -	struct xlog		*log,
> -	bool			aborted)
> +	struct xlog		*log)
>  {
>  	struct xlog_in_core	*iclog;
>  	struct xlog_in_core	*first_iclog;
> @@ -2853,7 +2841,7 @@ xlog_state_do_callback(
>  			 * we'll have to run at least one more complete loop.
>  			 */
>  			cycled_icloglock = true;
> -			xlog_state_do_iclog_callbacks(log, iclog, aborted);
> +			xlog_state_do_iclog_callbacks(log, iclog);
>  
>  			xlog_state_clean_iclog(log, iclog);
>  			iclog = iclog->ic_next;
> @@ -2891,25 +2879,22 @@ xlog_state_do_callback(
>   */
>  STATIC void
>  xlog_state_done_syncing(
> -	struct xlog_in_core	*iclog,
> -	bool			aborted)
> +	struct xlog_in_core	*iclog)
>  {
>  	struct xlog		*log = iclog->ic_log;
>  
>  	spin_lock(&log->l_icloglock);
> -
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
>  
>  	/*
>  	 * If we got an error, either on the first buffer, or in the case of
> -	 * split log writes, on the second, we mark ALL iclogs STATE_IOERROR,
> -	 * and none should ever be attempted to be written to disk
> -	 * again.
> +	 * split log writes, on the second, we shut down the file system and
> +	 * no iclogs should ever be attempted to be written to disk again.
>  	 */
> -	if (iclog->ic_state == XLOG_STATE_SYNCING)
> +	if (!XLOG_FORCED_SHUTDOWN(log)) {
> +		ASSERT(iclog->ic_state == XLOG_STATE_SYNCING);
>  		iclog->ic_state = XLOG_STATE_DONE_SYNC;
> -	else
> -		ASSERT(iclog->ic_state == XLOG_STATE_IOERROR);
> +	}
>  
>  	/*
>  	 * Someone could be sleeping prior to writing out the next
> @@ -2918,9 +2903,8 @@ xlog_state_done_syncing(
>  	 */
>  	wake_up_all(&iclog->ic_write_wait);
>  	spin_unlock(&log->l_icloglock);
> -	xlog_state_do_callback(log, aborted);	/* also cleans log */
> -}	/* xlog_state_done_syncing */
> -
> +	xlog_state_do_callback(log);	/* also cleans log */
> +}
>  
>  /*
>   * If the head of the in-core log ring is not (ACTIVE or DIRTY), then we must
> @@ -3884,7 +3868,7 @@ xfs_log_force_umount(
>  	spin_lock(&log->l_cilp->xc_push_lock);
>  	wake_up_all(&log->l_cilp->xc_commit_wait);
>  	spin_unlock(&log->l_cilp->xc_push_lock);
> -	xlog_state_do_callback(log, true);
> +	xlog_state_do_callback(log);
>  
>  	/* return non-zero if log IOERROR transition had already happened */
>  	return retval;
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index b38602216c5a..cc77cc36560a 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -137,7 +137,7 @@ void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
>  
>  void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
>  				xfs_lsn_t *commit_lsn, bool regrant);
> -void	xlog_cil_process_committed(struct list_head *list, bool aborted);
> +void	xlog_cil_process_committed(struct list_head *list);
>  bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>  
>  void	xfs_log_work_queue(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 278166811c80..64cc0bf2ab3b 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -574,10 +574,10 @@ xlog_discard_busy_extents(
>   */
>  static void
>  xlog_cil_committed(
> -	struct xfs_cil_ctx	*ctx,
> -	bool			abort)
> +	struct xfs_cil_ctx	*ctx)
>  {
>  	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
> +	bool			abort = XLOG_FORCED_SHUTDOWN(ctx->cil->xc_log);
>  
>  	/*
>  	 * If the I/O failed, we're aborting the commit and already shutdown.
> @@ -613,15 +613,14 @@ xlog_cil_committed(
>  
>  void
>  xlog_cil_process_committed(
> -	struct list_head	*list,
> -	bool			aborted)
> +	struct list_head	*list)
>  {
>  	struct xfs_cil_ctx	*ctx;
>  
>  	while ((ctx = list_first_entry_or_null(list,
>  			struct xfs_cil_ctx, iclog_entry))) {
>  		list_del(&ctx->iclog_entry);
> -		xlog_cil_committed(ctx, aborted);
> +		xlog_cil_committed(ctx);
>  	}
>  }
>  
> @@ -878,7 +877,8 @@ xlog_cil_push_work(
>  out_abort_free_ticket:
>  	xfs_log_ticket_put(tic);
>  out_abort:
> -	xlog_cil_committed(ctx, true);
> +	ASSERT(XLOG_FORCED_SHUTDOWN(log));
> +	xlog_cil_committed(ctx);
>  }
>  
>  /*
> -- 
> 2.25.1
> 
