Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 939B7C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 20:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 561BB205ED
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 20:20:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cmbaIxDl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732448AbgCPUUb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 16:20:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36612 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPUUb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 16:20:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKK6Vc154048;
        Mon, 16 Mar 2020 20:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=BHidhRFS4DOP4gxXizMxP4PmsPdT/9PjSnqVbr7K2M4=;
 b=cmbaIxDl+yF8KdsTZ7Xlz1p7tgOBd3exe0olmMfMJkttwf1WpYsIOHSxaRS9Gt7qNMhA
 C+VLTpDgAWCLSp4oKSE5LVjRVdPfP0FZLwXYLno5FNrNMTTZf9uEjMyBB5y44hjRQ8F1
 fD7g3LZsOt76W9G1Ntnu+zJD9oj9MMyxagGniswCZoYsQBtnwBkVbts5hh/aac5+4kvf
 xqwILGKhVYmA7E9jlG2qdu2TUXHs36A9Ou4GuJ74vElHR+PpkXsNUcP9Ok4azicEPRnR
 h8tR3xxJZHsPRXfojQ5S5DTsHM1JpwKxLcT+HtLfTmzlaePMaxVsoRBbXBPm+Sk4IhCf Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yrqwn10xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 20:20:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GKJamS139509;
        Mon, 16 Mar 2020 20:20:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ys92ambfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 20:20:24 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02GKKMH3020239;
        Mon, 16 Mar 2020 20:20:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 13:20:22 -0700
Date:   Mon, 16 Mar 2020 13:20:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/14] xfs: factor out a xlog_wait_on_iclog helper
Message-ID: <20200316202021.GH256767@magnolia>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160085
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:21PM +0100, Christoph Hellwig wrote:
> Factor out the shared code to wait for a log force into a new helper.
> This helper uses the XLOG_FORCED_SHUTDOWN check previous only used
> by the unmount code over the equivalent iclog ioerror state used by
> the other two functions.
> 
> There is a slight behavior change in that the force of the unmount
> record is now accounted in the log force statistics.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, though I reserve the right to become confused later on. :)
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 76 ++++++++++++++++++++----------------------------
>  1 file changed, 31 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0986983ef6b5..955df2902c2c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -859,6 +859,31 @@ xfs_log_mount_cancel(
>  	xfs_log_unmount(mp);
>  }
>  
> +/*
> + * Wait for the iclog to be written disk, or return an error if the log has been
> + * shut down.
> + */
> +static int
> +xlog_wait_on_iclog(
> +	struct xlog_in_core	*iclog)
> +		__releases(iclog->ic_log->l_icloglock)
> +{
> +	struct xlog		*log = iclog->ic_log;
> +
> +	if (!XLOG_FORCED_SHUTDOWN(log) &&
> +	    iclog->ic_state != XLOG_STATE_ACTIVE &&
> +	    iclog->ic_state != XLOG_STATE_DIRTY) {
> +		XFS_STATS_INC(log->l_mp, xs_log_force_sleep);
> +		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> +	} else {
> +		spin_unlock(&log->l_icloglock);
> +	}
> +
> +	if (XLOG_FORCED_SHUTDOWN(log))
> +		return -EIO;
> +	return 0;
> +}
> +
>  /*
>   * Final log writes as part of unmount.
>   *
> @@ -926,18 +951,7 @@ xfs_log_write_unmount_record(
>  	atomic_inc(&iclog->ic_refcnt);
>  	xlog_state_want_sync(log, iclog);
>  	error = xlog_state_release_iclog(log, iclog);
> -	switch (iclog->ic_state) {
> -	default:
> -		if (!XLOG_FORCED_SHUTDOWN(log)) {
> -			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -			break;
> -		}
> -		/* fall through */
> -	case XLOG_STATE_ACTIVE:
> -	case XLOG_STATE_DIRTY:
> -		spin_unlock(&log->l_icloglock);
> -		break;
> -	}
> +	xlog_wait_on_iclog(iclog);
>  
>  	if (tic) {
>  		trace_xfs_log_umount_write(log, tic);
> @@ -3230,9 +3244,6 @@ xfs_log_force(
>  		 * previous iclog and go to sleep.
>  		 */
>  		iclog = iclog->ic_prev;
> -		if (iclog->ic_state == XLOG_STATE_ACTIVE ||
> -		    iclog->ic_state == XLOG_STATE_DIRTY)
> -			goto out_unlock;
>  	} else if (iclog->ic_state == XLOG_STATE_ACTIVE) {
>  		if (atomic_read(&iclog->ic_refcnt) == 0) {
>  			/*
> @@ -3248,8 +3259,7 @@ xfs_log_force(
>  			if (xlog_state_release_iclog(log, iclog))
>  				goto out_error;
>  
> -			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn ||
> -			    iclog->ic_state == XLOG_STATE_DIRTY)
> +			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
>  				goto out_unlock;
>  		} else {
>  			/*
> @@ -3269,17 +3279,8 @@ xfs_log_force(
>  		;
>  	}
>  
> -	if (!(flags & XFS_LOG_SYNC))
> -		goto out_unlock;
> -
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> -		goto out_error;
> -	XFS_STATS_INC(mp, xs_log_force_sleep);
> -	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> -		return -EIO;
> -	return 0;
> -
> +	if (flags & XFS_LOG_SYNC)
> +		return xlog_wait_on_iclog(iclog);
>  out_unlock:
>  	spin_unlock(&log->l_icloglock);
>  	return 0;
> @@ -3310,9 +3311,6 @@ __xfs_log_force_lsn(
>  			goto out_unlock;
>  	}
>  
> -	if (iclog->ic_state == XLOG_STATE_DIRTY)
> -		goto out_unlock;
> -
>  	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
>  		/*
>  		 * We sleep here if we haven't already slept (e.g. this is the
> @@ -3346,20 +3344,8 @@ __xfs_log_force_lsn(
>  			*log_flushed = 1;
>  	}
>  
> -	if (!(flags & XFS_LOG_SYNC) ||
> -	    (iclog->ic_state == XLOG_STATE_ACTIVE ||
> -	     iclog->ic_state == XLOG_STATE_DIRTY))
> -		goto out_unlock;
> -
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> -		goto out_error;
> -
> -	XFS_STATS_INC(mp, xs_log_force_sleep);
> -	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> -		return -EIO;
> -	return 0;
> -
> +	if (flags & XFS_LOG_SYNC)
> +		return xlog_wait_on_iclog(iclog);
>  out_unlock:
>  	spin_unlock(&log->l_icloglock);
>  	return 0;
> -- 
> 2.24.1
> 
