Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E6BC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 19:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F84A60C41
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 19:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhGVSdL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhGVSdK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 14:33:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54EB260E74;
        Thu, 22 Jul 2021 19:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626981225;
        bh=dtx4IE0gxNmX7dWuN6jFvhSHcApbBWxBBRvex58elnk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aaCsGOxR778X0TbqOCASa03NXIeSfybKbX6lQ70jFs6CgGZd2f4bgZZmsNpcaVnz7
         CnIRFLkJtmQ8IZdViD/VHdZUZ1Ap2Eu8j+eNMTAKnHK+xU6tg1to/fzgbhfNnwXj8Y
         Aq+d38cApYst1/S+zuABzvOoEgfDu4o/yYsReHiTc/XIftlO/QzsRRzFXR10C3iRhA
         WVNgxgkkqloEz+Os6VAClsWVn1+1vDlFJDpSpx5iNrzIG22uIfcqWpJ84WkVYdsWYx
         NfJvX8wiRUEHi/4m96zTzuG3nxhIw5KEHh5XVw5WhWXNyJ4rn/thWL9JlpzZh0BzA+
         7eas+/O53hCEw==
Date:   Thu, 22 Jul 2021 12:13:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: avoid unnecessary waits in xfs_log_force_lsn()
Message-ID: <20210722191345.GK559212@magnolia>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722015335.3063274-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 11:53:35AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Before waiting on a iclog in xfs_log_force_lsn(), we don't check to
> see if the iclog has already been completed and the contents on
> stable storage. We check for completed iclogs in xfs_log_force(), so
> we should do the same thing for xfs_log_force_lsn().
> 
> This fixed some random up-to-30s pauses seen in unmounting
> filesystems in some tests. A log force ends up waiting on completed
> iclog, and that doesn't then get flushed (and hence the log force
> get completed) until the background log worker issues a log force
> that flushes the iclog in question. Then the unmount unblocks and
> continues.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Heh.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 47 +++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 37 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 7da42c0656e3..baee9871cd65 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3147,6 +3147,35 @@ xlog_state_switch_iclogs(
>  	log->l_iclog = iclog->ic_next;
>  }
>  
> +/*
> + * Force the iclog to disk and check if the iclog has been completed before
> + * xlog_force_iclog() returns. This can happen on synchronous (e.g.
> + * pmem) or fast async storage because we drop the icloglock to issue the IO.
> + * If completion has already occurred, tell the caller so that it can avoid an
> + * unnecessary wait on the iclog.
> + */
> +static int
> +xlog_force_and_check_iclog(
> +	struct xlog_in_core	*iclog,
> +	bool			*completed)
> +{
> +	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +	int			error;
> +
> +	*completed = false;
> +	error = xlog_force_iclog(iclog);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * If the iclog has already been completed and reused the header LSN
> +	 * will have been rewritten by completion
> +	 */
> +	if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
> +		*completed = true;
> +	return 0;
> +}
> +
>  /*
>   * Write out all data in the in-core log as of this exact moment in time.
>   *
> @@ -3181,7 +3210,6 @@ xfs_log_force(
>  {
>  	struct xlog		*log = mp->m_log;
>  	struct xlog_in_core	*iclog;
> -	xfs_lsn_t		lsn;
>  
>  	XFS_STATS_INC(mp, xs_log_force);
>  	trace_xfs_log_force(mp, 0, _RET_IP_);
> @@ -3210,15 +3238,11 @@ xfs_log_force(
>  	} else if (iclog->ic_state == XLOG_STATE_ACTIVE) {
>  		if (atomic_read(&iclog->ic_refcnt) == 0) {
>  			/* We have exclusive access to this iclog. */
> -			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> -			if (xlog_force_iclog(iclog))
> +			bool	completed;
> +
> +			if (xlog_force_and_check_iclog(iclog, &completed))
>  				goto out_error;
> -			/*
> -			 * If the iclog has already been completed and reused
> -			 * the header LSN will have been rewritten. Don't wait
> -			 * on these iclogs that contain future modifications.
> -			 */
> -			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
> +			if (completed)
>  				goto out_unlock;
>  		} else {
>  			/*
> @@ -3258,6 +3282,7 @@ xlog_force_lsn(
>  	bool			already_slept)
>  {
>  	struct xlog_in_core	*iclog;
> +	bool			completed;
>  
>  	spin_lock(&log->l_icloglock);
>  	iclog = log->l_iclog;
> @@ -3295,10 +3320,12 @@ xlog_force_lsn(
>  					&log->l_icloglock);
>  			return -EAGAIN;
>  		}
> -		if (xlog_force_iclog(iclog))
> +		if (xlog_force_and_check_iclog(iclog, &completed))
>  			goto out_error;
>  		if (log_flushed)
>  			*log_flushed = 1;
> +		if (completed)
> +			goto out_unlock;
>  		break;
>  	case XLOG_STATE_WANT_SYNC:
>  		/*
> -- 
> 2.31.1
> 
