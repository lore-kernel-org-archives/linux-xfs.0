Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630FC38657E;
	Mon, 10 Aug 2026 18:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786387647; cv=none; b=r4hbMWtojVwHGo6FZFtWviTXp+iOdQjhEXj6GyPtfVPyEpxwRCnjFVJ7s8pvMm1Yn8PRRN3MizMFKbfHBxOKM2YUTsFFqMMJPqqn8dknYMuOk/kjZ9p7ZB8s52dogQbxgDk/6TL/5Kb8017ZsHC/7xzL/De21YJFw1pYpPsvAvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786387647; c=relaxed/simple;
	bh=fHF58cs7gdz/UX2tM0ONL4wpuISwVHw/0jDhbsrDEok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsVbyyQv6mG5TL6No0C3PPXSBW/WJQiP/858y1JRgR1OVHGC7eNKk3V20lkp7b+uuh7gHFMsGwcAua4wNGLsmZzSzmLapKqKL5xdkICSNUolovotv1pb1ZWyh4t/joTGJUp6RoymKwXoOM6sgEO+ALG19e2VUrL5k7hHfZrPluw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAx1ieYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAx1ieYA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0CEE21F000E9;
	Mon, 10 Aug 2026 18:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786387646;
	bh=zI2diU2BQLa9PEqSFLe1mfNIlt8lnb3vf5jqzLbXviM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lAx1ieYAcpFKeJRVobfYoOCrFZ834N3Pdwz47vv98qZQTY+7ic5oWbK6eL/S1wZIW
	 OaRl0UgBy+6RjHRq2Bl6TK1TY9hT0MrQovfcOT2CMB9slgwcoZrAbgrdQcZlmpnhrG
	 /vu51aunnApH4dVjVNFt8kvYtjiLNvYf4XM1YQNgLWrZ8p9dvPdjtkBsu9pT76xeIH
	 etGbMcwzcVTQ1wnz65LGspTV1a0xQf1VQ55Pje62TdROJtVxSw1EgqABdPO+v38YUm
	 7C47t4Y15O+jBfQFz8m5FCRuLefQaKxJNBtCbVwxPAgOcWJ9MXu0KPzREzSSKzj5HY
	 6xevFo4/WnUBw==
Date: Mon, 10 Aug 2026 11:47:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Javier Tia <javier@peridio.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] xfs: report the error that made deferred work
 shut down the fs
Message-ID: <20260810184725.GA3556460@frogsfrogsfrogs>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260810164312.960721-8-floss@jetm.me>
 <20260810164312.960721-11-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810164312.960721-11-floss@jetm.me>

On Mon, Aug 10, 2026 at 10:43:16AM -0600, Javier Tia wrote:
> When xfs_defer_finish_one() fails with anything other than -EAGAIN,
> xfs_defer_finish_noroll() shuts the filesystem down from a generic
> out_shutdown: label.  SHUTDOWN_CORRUPT_INCORE makes that surface as
> "Corruption of in-memory data (0x8) detected at
> xfs_defer_finish_noroll+0x29a/0x4b0 (fs/xfs/libxfs/xfs_defer.c:721)",
> naming neither the errno nor the deferred op that produced it.  Any
> error from any deferred work item lands on that one line, so the report
> is equally consistent with a transient -ENOSPC, an -EIO on a metadata
> buffer, or genuine in-core corruption, and there is no way to tell
> which from the log.

(I think you could have shortened all of this to "When processing of a
deferred operation fails and shuts down the filesystem, try to report
what type of operation originated the failure.")

((We like shorter commit messages than longer ones over here...))

> trace_xfs_defer_finish_error() records the errno, but it is called
> after xfs_force_shutdown().  With fs.xfs.panic_mask carrying
> XFS_PTAG_SHUTDOWN_CORRUPT (16), the first shutdown reaches
> _xfs_alert_tag(), which BUGs, so the tracepoint does not fire for it.
> Later racers do reach it, because xfs_do_force_shutdown() returns early
> once xfs_set_shutdown() has fired, but by then the errno belongs to a
> secondary failure.  The informative one is lost, and that is the
> configuration used to capture a crash dump: recovering the errno from a
> vmcore means an ORC unwind of the xfs_defer_finish_noroll frame to read
> the callee-saved %rbp that happens to still hold the value.
> 
> Move the tracepoint ahead of xfs_force_shutdown() so it is reachable
> for the first failure, and report the same information through the log,
> because the systems that hit this do not have tracing armed in advance.
> Report t_blk_res as well as the errno: how much of the reservation is
> left separates a transaction that ran out of blocks from one that never
> came close, which is the difference between suspecting whichever
> xfs_*_space_res() fed it and moving the search to the allocator or to
> the buffer that returned the error.  It cannot say more than that,
> since xfs_trans_dup() hands each rolled transaction the unused
> remainder, so a small value is also what a correctly sized reservation
> looks like several rolls in.  t_blk_res_used is not worth printing
> beside it: the new transaction starts at zero because xfs_trans_dup()
> allocates it with kmem_cache_zalloc(), so it reads zero on the roll
> paths and counts only the current segment on the others.
> 
> Take the op name in a local read before the call rather than from dfp
> afterwards.  dfp is freed once its work list drains, so the name has to
> be captured while the item is known live, and it has to outlive the
> item to be available at out_shutdown for the paths that do not come
> from xfs_defer_finish_one() at all.  dfp_ops points into a static const
> table, so the string itself outlives everything.
> 
> Clear the attribution once an item finishes.  Three of the four paths to
> out_shutdown - the create_intents failure and both trans_roll failures -
> are reached at the top of a later loop iteration, before any item has
> been picked, so a name left over from an item that already succeeded
> would blame it for a log commit that failed afterwards.  That is worse
> than the generic message this replaces, because it invents a lead where
> there was none.  An -EAGAIN item keeps its name, since the roll that
> follows is part of completing it.
> 
> Skip the alert once the filesystem is already down.  Only the first
> failure is informative; everything after it is a consequence, and
> xfs_do_force_shutdown() suppresses its own message for exactly that
> reason.  Testing xfs_is_shutdown() rather than rate-limiting keeps the
> first report unconditionally and drops the ones that follow, instead of
> a token bucket that could spend itself on another mount's failures and
> discard the one that mattered.
> 
> Signed-off-by: Javier Tia <floss@jetm.me>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 75f0d37914d5..bbf2f4ca3c2e 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -656,6 +656,7 @@ xfs_defer_finish_noroll(
>  	struct xfs_trans		**tp)
>  {
>  	struct xfs_defer_pending	*dfp = NULL;
> +	const char			*what = "deferred";
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
> +			what = "deferred";
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
> +			  "%s work failed, error %d, %u blocks reserved",
> +			  what, error, (*tp)->t_blk_res);

I wonder if the format string should be:

"deferred %s work failed, error..."

and the @what variable is set to either dfp->dfp_ops->name or "chain" so
that the messages come out:

"deferred chain work failed, error X, Y blocks reserved"

or

"deferred agfl_free work failed, error X, Y blocks reserved"

Hm?

Other than that bikeshed, I like the improved logging.

--D

> +	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
>  	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
>  	xfs_defer_cancel(*tp);
>  	return error;
> -- 
> Javier Tia
> 
> 
