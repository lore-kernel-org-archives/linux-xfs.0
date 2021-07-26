Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AC3C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 684F560F5D
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 17:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242001AbhGZQkv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 12:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236470AbhGZQkE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 12:40:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D1B560F44;
        Mon, 26 Jul 2021 17:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627320032;
        bh=NuTrTbFS2hVyqfAF/YtmJUevMcB0NyHph1/fA3v45hY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZMReg00iS6wlA7BshBzWDG65jI+Czcf3TWYIZ6UbSdtTnc7uWSC+WsBt74WBVoE21
         ldjfCEB4UJTpMsY5UVxyIVkQnx+7WaRiRMsJUrmQ9hDxmIn0m64NCa5OTK/HRrXMq3
         6I4rmzaG3NNAfERJ31ZYYsG5Zrfs/H6wbvxJuMnzc0GNHMfIxKupBoxNDBDGJuGoOu
         /pAGo/RcjXIUf4OPlxu7Nud8JIgLxFmssYrV7o16QNXDIB2m02GksTe62YLrtRglyB
         MsVwPtqsZ7puZ+g+3LE4/L8mHsQRPJzCIUEq3M02E6uIMwuVjSIsSWTVdncnzIF/Zr
         i1qozvw/639tQ==
Date:   Mon, 26 Jul 2021 10:20:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: fold __xlog_state_release_iclog into
 xlog_state_release_iclog
Message-ID: <20210726172032.GW559212@magnolia>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726060716.3295008-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 04:07:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Fold __xlog_state_release_iclog intos it's only caller to prepare

s/it's/its/

> make an upcomding fix easier.

s/upcomding/upcoming/

With those fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [hch: split from a larger patch]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 45 +++++++++++++++++----------------------------
>  1 file changed, 17 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a3c4d48195d9..82f5996d3889 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -487,29 +487,6 @@ xfs_log_reserve(
>  	return error;
>  }
>  
> -static bool
> -__xlog_state_release_iclog(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog)
> -{
> -	lockdep_assert_held(&log->l_icloglock);
> -
> -	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
> -		/* update tail before writing to iclog */
> -		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);
> -
> -		iclog->ic_state = XLOG_STATE_SYNCING;
> -		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> -		xlog_verify_tail_lsn(log, iclog, tail_lsn);
> -		/* cycle incremented when incrementing curr_block */
> -		trace_xlog_iclog_syncing(iclog, _RET_IP_);
> -		return true;
> -	}
> -
> -	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
> -	return false;
> -}
> -
>  /*
>   * Flush iclog to disk if this is the last reference to the given iclog and the
>   * it is in the WANT_SYNC state.
> @@ -519,19 +496,31 @@ xlog_state_release_iclog(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog)
>  {
> +	xfs_lsn_t		tail_lsn;
>  	lockdep_assert_held(&log->l_icloglock);
>  
>  	trace_xlog_iclog_release(iclog, _RET_IP_);
>  	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		return -EIO;
>  
> -	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
> -	    __xlog_state_release_iclog(log, iclog)) {
> -		spin_unlock(&log->l_icloglock);
> -		xlog_sync(log, iclog);
> -		spin_lock(&log->l_icloglock);
> +	if (!atomic_dec_and_test(&iclog->ic_refcnt))
> +		return 0;
> +
> +	if (iclog->ic_state != XLOG_STATE_WANT_SYNC) {
> +		ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
> +		return 0;
>  	}
>  
> +	/* update tail before writing to iclog */
> +	tail_lsn = xlog_assign_tail_lsn(log->l_mp);
> +	iclog->ic_state = XLOG_STATE_SYNCING;
> +	iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> +	xlog_verify_tail_lsn(log, iclog, tail_lsn);
> +	trace_xlog_iclog_syncing(iclog, _RET_IP_);
> +
> +	spin_unlock(&log->l_icloglock);
> +	xlog_sync(log, iclog);
> +	spin_lock(&log->l_icloglock);
>  	return 0;
>  }
>  
> -- 
> 2.31.1
> 
