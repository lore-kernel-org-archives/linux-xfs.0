Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157F544605C;
	Tue, 11 Aug 2026 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465676; cv=none; b=U8jqy0aicQqFNxkBMn2DUv1S8Hnu6YYmHnlY4+LtGFjyfsKmm5YU0dZn7a5WV+zwL580eLEqcD9k2osxov3CL11sEjFG/6WKcEIVxfA6m5hRgfN4IqEhJxjitDG5iWef1KP+y50CJmad8NUcNWFIXeoiY343SW7v43qbgRQdS0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465676; c=relaxed/simple;
	bh=4xXabv1chuTXTAN1AMmq3oshU4iTDxCrn8r3/fZemO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UsNRIF0mVQO2aHYWhM6vPImwbqPRznOODAe/5a6/qNSQbw+5Gwr2OmH/e6KRIGGGbSuoTyIFTE5qgO2yEm0xTslKSO2hCN3I9ln+CT7jjuZyqlxQvHVCWipozw/d17iAf8zEHdTw4az/YirR4fZNxyK4ZNCzl5Xtirp9gASW1Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FEq5PvBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FEq5PvBP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9AA3D1F000E9;
	Tue, 11 Aug 2026 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465674;
	bh=0HT7nnyd1ROfP8kuWkkUxa4tQRnmsDBKiYTj/znzMUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FEq5PvBP0/RbQKQdLsY1JI5GwDcae2GPqztcaFOZLijud1bFAmVn+gP+n+x0JUODM
	 TR1cptEhwYE1bW63mEm6QV2ZMViBiFH1LEq9JubaNyxn3JNtPKgV8SlQLd+uIxYiGr
	 dH2EfxZBLkrtrEGDkqo9hzDOF2pvmgW+x6sMaDY3Optb3GfuYAx0K6qc6F0iW+yLxM
	 u47V/uV5k8CT2JIerLQYYdeso5+Lr8/MtRqI5l/OVmOffJUc2OfG2lTbNlCmih+XGS
	 SvMdy1FbEBQeSJA558/xNqIYlBw5b+yYBvN4sc5ViynTM6aV/A4Frt+SdFfwiBOlP+
	 NjbOo4uadXbhg==
Date: Tue, 11 Aug 2026 09:27:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Javier Tia <javier@peridio.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <achender@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/6] xfs: report the error that made deferred work
 shut down the fs
Message-ID: <20260811162754.GB3556460@frogsfrogsfrogs>
References: <20260810230611.2859909-8-floss@jetm.me>
 <20260810230611.2859909-11-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810230611.2859909-11-floss@jetm.me>

On Mon, Aug 10, 2026 at 05:06:15PM -0600, Javier Tia wrote:
> When a deferred operation fails and shuts the filesystem down,
> xfs_defer_finish_noroll() reports neither the errno nor which operation
> originated it, so the log cannot tell a transient -ENOSPC from real
> corruption.  Report the operation type, errno and remaining reservation.
> 
> trace_xfs_defer_finish_error() runs after xfs_force_shutdown(), which
> BUGs under fs.xfs.panic_mask and so never fires for the first failure;
> move it ahead of the shutdown and mirror it to xfs_alert() for systems
> without tracing armed.  Capture the op name while the item is live (dfp
> is freed once its work list drains) and suppress the alert once the fs is
> already down.
> 
> Signed-off-by: Javier Tia <floss@jetm.me>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 75f0d37914d5..3152acdc335d 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -656,6 +656,7 @@ xfs_defer_finish_noroll(
>  	struct xfs_trans		**tp)
>  {
>  	struct xfs_defer_pending	*dfp = NULL;
> +	const char			*what = "chain";
>  	int				error = 0;
>  	LIST_HEAD(dop_pending);
>  	LIST_HEAD(dop_paused);
> @@ -705,9 +706,17 @@ xfs_defer_finish_noroll(
>  				struct xfs_defer_pending, dfp_list);
>  		if (!dfp)
>  			break;
> +		what = dfp->dfp_ops->name;
>  		error = xfs_defer_finish_one(*tp, dfp);
>  		if (error && error != -EAGAIN)
>  			goto out_shutdown;
> +		/*
> +		 * A finished item is no longer a candidate for a later
> +		 * failure.  An -EAGAIN one is not finished, so it keeps the
> +		 * attribution across the roll that completes it.
> +		 */
> +		if (!error)
> +			what = "chain";
>  	}
>  
>  	/* Requeue the paused items in the outgoing transaction. */
> @@ -719,8 +728,12 @@ xfs_defer_finish_noroll(
>  out_shutdown:
>  	list_splice_tail_init(&dop_paused, &dop_pending);
>  	xfs_defer_trans_abort(*tp, &dop_pending);
> -	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
>  	trace_xfs_defer_finish_error(*tp, error);
> +	if (!xfs_is_shutdown((*tp)->t_mountp))
> +		xfs_alert((*tp)->t_mountp,
> +			  "deferred %s work failed, error %d, %u blocks reserved",
> +			  what, error, (*tp)->t_blk_res);

Excellent!  A new logging artifact that (might) tell us *which* deferred
operation produced an error. :)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
>  	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
>  	xfs_defer_cancel(*tp);
>  	return error;
> -- 
> Javier Tia
> 
> 
