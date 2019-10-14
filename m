Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BE8ECE587
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 18:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73F5720873
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 18:12:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SrahFjda"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbfJNSMS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 14:12:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40938 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732647AbfJNSMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 14:12:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EHww08079750;
        Mon, 14 Oct 2019 18:12:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=hpRaPoAQgHULEcD9W5GngB90RWtrq1vKq9tv0Nj4LPA=;
 b=SrahFjda5M1cKuQ9RSaGvisjoDMfQSKMAZ2Rp7v2sm0NU3F4c6Lg+k1U+Mw5RjnXLnO4
 YGtpFVqEBdHc11lsZ1mbMqz0qlkCiGqdbw38Q8rSlgtKLSIT6znGuKJ7a9cstPFbtQjJ
 eXDsuFmO7KeIz6s4vcxMRXfIZMyYjCrOfCmox6kITLpE/zX/A0BO0gwdCCRTcxawutTv
 zcqbyYlI3b7UT75SKo5GhKxSYT8ldOb9En1nWBrZVuO/s0yDNPjFJIpzTPjt16paoesb
 87j3t/RYiVX8TupxagUykyoI/0oEWlW7qZndG0TFS0G0x8s5DqRPwGWkKjYsQkPVy0Yc bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vk7fr2h7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 18:12:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9EHwEB7171704;
        Mon, 14 Oct 2019 18:12:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vks078rae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 18:12:12 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9EICBYh024628;
        Mon, 14 Oct 2019 18:12:11 GMT
Received: from localhost (/10.159.144.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Oct 2019 18:12:10 +0000
Date:   Mon, 14 Oct 2019 11:12:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: call xlog_state_release_iclog with l_icloglock
 held
Message-ID: <20191014181209.GZ13108@magnolia>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910140149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:44PM +0200, Christoph Hellwig wrote:
> All but one caller of xlog_state_release_iclog hold l_icloglock and need
> to drop and reacquire it to call xlog_state_release_iclog.  Switch the
> xlog_state_release_iclog calling conventions to expect the lock to be
> held, and open code the logic (using a shared helper) in the only
> remaining caller that does not have the lock (and where not holding it
> is a nice performance optimization).  Also move the refactored code to
> require the least amount of forward declarations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 188 +++++++++++++++++++++++------------------------
>  1 file changed, 90 insertions(+), 98 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 860a555772fe..67a767d90ebf 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -57,10 +57,6 @@ xlog_state_get_iclog_space(
>  	struct xlog_ticket	*ticket,
>  	int			*continued_write,
>  	int			*logoffsetp);
> -STATIC int
> -xlog_state_release_iclog(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog);
>  STATIC void
>  xlog_state_switch_iclogs(
>  	struct xlog		*log,
> @@ -83,7 +79,10 @@ STATIC void
>  xlog_ungrant_log_space(
>  	struct xlog		*log,
>  	struct xlog_ticket	*ticket);
> -
> +STATIC void
> +xlog_sync(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog);
>  #if defined(DEBUG)
>  STATIC void
>  xlog_verify_dest_ptr(
> @@ -552,16 +551,71 @@ xfs_log_done(
>  	return lsn;
>  }
>  
> +static bool
> +__xlog_state_release_iclog(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog)
> +{
> +	lockdep_assert_held(&log->l_icloglock);
> +
> +	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
> +		/* update tail before writing to iclog */
> +		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);
> +
> +		iclog->ic_state = XLOG_STATE_SYNCING;
> +		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> +		xlog_verify_tail_lsn(log, iclog, tail_lsn);
> +		/* cycle incremented when incrementing curr_block */
> +		return true;
> +	}
> +
> +	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
> +	return false;
> +}
> +
> +/*
> + * Flush iclog to disk if this is the last reference to the given iclog and the
> + * it is in the WANT_SYNC state.
> + */
> +static int
> +xlog_state_release_iclog(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog)
> +{
> +	lockdep_assert_held(&log->l_icloglock);
> +
> +	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +		return -EIO;
> +
> +	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
> +	    __xlog_state_release_iclog(log, iclog)) {
> +		spin_unlock(&log->l_icloglock);
> +		xlog_sync(log, iclog);
> +		spin_lock(&log->l_icloglock);
> +	}
> +
> +	return 0;
> +}
> +
>  int
>  xfs_log_release_iclog(
> -	struct xfs_mount	*mp,
> +	struct xfs_mount        *mp,
>  	struct xlog_in_core	*iclog)
>  {
> -	if (xlog_state_release_iclog(mp->m_log, iclog)) {
> +	struct xlog		*log = mp->m_log;
> +	bool			sync;
> +
> +	if (iclog->ic_state & XLOG_STATE_IOERROR) {
>  		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
>  		return -EIO;
>  	}
>  
> +	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> +		sync = __xlog_state_release_iclog(log, iclog);
> +		spin_unlock(&log->l_icloglock);
> +		if (sync)
> +			xlog_sync(log, iclog);
> +	}
>  	return 0;
>  }
>  
> @@ -866,10 +920,7 @@ xfs_log_write_unmount_record(
>  	iclog = log->l_iclog;
>  	atomic_inc(&iclog->ic_refcnt);
>  	xlog_state_want_sync(log, iclog);
> -	spin_unlock(&log->l_icloglock);
>  	error = xlog_state_release_iclog(log, iclog);
> -
> -	spin_lock(&log->l_icloglock);
>  	switch (iclog->ic_state) {
>  	default:
>  		if (!XLOG_FORCED_SHUTDOWN(log)) {
> @@ -950,13 +1001,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  		spin_lock(&log->l_icloglock);
>  		iclog = log->l_iclog;
>  		atomic_inc(&iclog->ic_refcnt);
> -
>  		xlog_state_want_sync(log, iclog);
> -		spin_unlock(&log->l_icloglock);
>  		error =  xlog_state_release_iclog(log, iclog);
>  
> -		spin_lock(&log->l_icloglock);
> -
>  		if ( ! (   iclog->ic_state == XLOG_STATE_ACTIVE
>  			|| iclog->ic_state == XLOG_STATE_DIRTY
>  			|| iclog->ic_state == XLOG_STATE_IOERROR) ) {
> @@ -2255,6 +2302,8 @@ xlog_write_copy_finish(
>  	int			log_offset,
>  	struct xlog_in_core	**commit_iclog)
>  {
> +	int			error;
> +
>  	if (*partial_copy) {
>  		/*
>  		 * This iclog has already been marked WANT_SYNC by
> @@ -2262,10 +2311,9 @@ xlog_write_copy_finish(
>  		 */
>  		spin_lock(&log->l_icloglock);
>  		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> -		spin_unlock(&log->l_icloglock);
>  		*record_cnt = 0;
>  		*data_cnt = 0;
> -		return xlog_state_release_iclog(log, iclog);
> +		goto release_iclog;
>  	}
>  
>  	*partial_copy = 0;
> @@ -2279,15 +2327,19 @@ xlog_write_copy_finish(
>  		*data_cnt = 0;
>  
>  		xlog_state_want_sync(log, iclog);
> -		spin_unlock(&log->l_icloglock);
> -
>  		if (!commit_iclog)
> -			return xlog_state_release_iclog(log, iclog);
> +			goto release_iclog;
> +		spin_unlock(&log->l_icloglock);
>  		ASSERT(flags & XLOG_COMMIT_TRANS);
>  		*commit_iclog = iclog;
>  	}
>  
>  	return 0;
> +
> +release_iclog:
> +	error = xlog_state_release_iclog(log, iclog);
> +	spin_unlock(&log->l_icloglock);
> +	return error;
>  }
>  
>  /*
> @@ -2349,7 +2401,7 @@ xlog_write(
>  	int			contwr = 0;
>  	int			record_cnt = 0;
>  	int			data_cnt = 0;
> -	int			error;
> +	int			error = 0;
>  
>  	*start_lsn = 0;
>  
> @@ -2502,13 +2554,15 @@ xlog_write(
>  
>  	spin_lock(&log->l_icloglock);
>  	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
> +	if (commit_iclog) {
> +		ASSERT(flags & XLOG_COMMIT_TRANS);
> +		*commit_iclog = iclog;
> +	} else {
> +		error = xlog_state_release_iclog(log, iclog);
> +	}
>  	spin_unlock(&log->l_icloglock);
> -	if (!commit_iclog)
> -		return xlog_state_release_iclog(log, iclog);
>  
> -	ASSERT(flags & XLOG_COMMIT_TRANS);
> -	*commit_iclog = iclog;
> -	return 0;
> +	return error;
>  }
>  
>  
> @@ -2979,7 +3033,6 @@ xlog_state_get_iclog_space(
>  	int		  log_offset;
>  	xlog_rec_header_t *head;
>  	xlog_in_core_t	  *iclog;
> -	int		  error;
>  
>  restart:
>  	spin_lock(&log->l_icloglock);
> @@ -3028,24 +3081,22 @@ xlog_state_get_iclog_space(
>  	 * can fit into remaining data section.
>  	 */
>  	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
> +		int		error = 0;
> +
>  		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
>  
>  		/*
> -		 * If I'm the only one writing to this iclog, sync it to disk.
> -		 * We need to do an atomic compare and decrement here to avoid
> -		 * racing with concurrent atomic_dec_and_lock() calls in
> +		 * If we are the only one writing to this iclog, sync it to
> +		 * disk.  We need to do an atomic compare and decrement here to
> +		 * avoid racing with concurrent atomic_dec_and_lock() calls in
>  		 * xlog_state_release_iclog() when there is more than one
>  		 * reference to the iclog.
>  		 */
> -		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
> -			/* we are the only one */
> -			spin_unlock(&log->l_icloglock);
> +		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
>  			error = xlog_state_release_iclog(log, iclog);
> -			if (error)
> -				return error;
> -		} else {
> -			spin_unlock(&log->l_icloglock);
> -		}
> +		spin_unlock(&log->l_icloglock);
> +		if (error)
> +			return error;
>  		goto restart;
>  	}
>  
> @@ -3156,60 +3207,6 @@ xlog_ungrant_log_space(
>  	xfs_log_space_wake(log->l_mp);
>  }
>  
> -/*
> - * Flush iclog to disk if this is the last reference to the given iclog and
> - * the WANT_SYNC bit is set.
> - *
> - * When this function is entered, the iclog is not necessarily in the
> - * WANT_SYNC state.  It may be sitting around waiting to get filled.
> - *
> - *
> - */
> -STATIC int
> -xlog_state_release_iclog(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog)
> -{
> -	int		sync = 0;	/* do we sync? */
> -
> -	if (iclog->ic_state & XLOG_STATE_IOERROR)
> -		return -EIO;
> -
> -	ASSERT(atomic_read(&iclog->ic_refcnt) > 0);
> -	if (!atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock))
> -		return 0;
> -
> -	if (iclog->ic_state & XLOG_STATE_IOERROR) {
> -		spin_unlock(&log->l_icloglock);
> -		return -EIO;
> -	}
> -	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE ||
> -	       iclog->ic_state == XLOG_STATE_WANT_SYNC);
> -
> -	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
> -		/* update tail before writing to iclog */
> -		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);
> -		sync++;
> -		iclog->ic_state = XLOG_STATE_SYNCING;
> -		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> -		xlog_verify_tail_lsn(log, iclog, tail_lsn);
> -		/* cycle incremented when incrementing curr_block */
> -	}
> -	spin_unlock(&log->l_icloglock);
> -
> -	/*
> -	 * We let the log lock go, so it's possible that we hit a log I/O
> -	 * error or some other SHUTDOWN condition that marks the iclog
> -	 * as XLOG_STATE_IOERROR before the bwrite. However, we know that
> -	 * this iclog has consistent data, so we ignore IOERROR
> -	 * flags after this point.
> -	 */
> -	if (sync)
> -		xlog_sync(log, iclog);
> -	return 0;
> -}	/* xlog_state_release_iclog */
> -
> -
>  /*
>   * This routine will mark the current iclog in the ring as WANT_SYNC
>   * and move the current iclog pointer to the next iclog in the ring.
> @@ -3333,12 +3330,9 @@ xfs_log_force(
>  			atomic_inc(&iclog->ic_refcnt);
>  			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  			xlog_state_switch_iclogs(log, iclog, 0);
> -			spin_unlock(&log->l_icloglock);
> -
>  			if (xlog_state_release_iclog(log, iclog))
> -				return -EIO;
> +				goto out_error;	

Extra whitespace here                          ^

I kinda wish the relocation and refactoring of xlog_state_release_iclog
had happened as separate patches so that the redistribution of locking
responsibilities in this patch would be more straightforward, but oh
well, I got through it.

With the whitespace nit fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
> -			spin_lock(&log->l_icloglock);
>  			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn ||
>  			    iclog->ic_state == XLOG_STATE_DIRTY)
>  				goto out_unlock;
> @@ -3433,12 +3427,10 @@ __xfs_log_force_lsn(
>  		}
>  		atomic_inc(&iclog->ic_refcnt);
>  		xlog_state_switch_iclogs(log, iclog, 0);
> -		spin_unlock(&log->l_icloglock);
>  		if (xlog_state_release_iclog(log, iclog))
> -			return -EIO;
> +			goto out_error;
>  		if (log_flushed)
>  			*log_flushed = 1;
> -		spin_lock(&log->l_icloglock);
>  	}
>  
>  	if (!(flags & XFS_LOG_SYNC) ||
> -- 
> 2.20.1
> 
