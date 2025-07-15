Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968DB1E531
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 14:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752591545; cv=none; b=Z6R21/jEXAV3FDCAosqF+I6D5ssNHBem3rGFfaG8WzRBgHdNNvIFY2tO4gHXeZ+UPz/aIoFplSivw759Bf2lzMcHvoIZrUHaRzrt67BxQOO0PakemdSgXukcFHvRm6gDWp1fqH1psa3KrSgQf1r8SiRd6O8bhuluaxdQ4HmnXi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752591545; c=relaxed/simple;
	bh=DJGyKJKWJ1aBNTx20fiBCdm+zk0WqHrXLr7fAqsIjmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdZ/WTeTHtz9SoKz6Eyx2PZUH1QiOLFNuoPLPqSRaWoYUms8zheaDVy9nk3OUp3V0c9JfJ0RkOy2mBlp8LMu15RqQT7kBafVRqecQH3xI/LDH0IIn2TC+2dr5xR3cvqBs95Csdy4FobWWe63sRI4Zke/GEJtmD2wdH+qn38MtpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cmKG2TN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cmKG2TN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE59C4CEE3;
	Tue, 15 Jul 2025 14:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752591545;
	bh=DJGyKJKWJ1aBNTx20fiBCdm+zk0WqHrXLr7fAqsIjmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cmKG2TN4voHgc3m/XSbKyT6X2+EQIbRl6Pz5sOQTOp23d/gjWlsr1Z44//WvBpium
	 nt+xznjF9cjU/njUE/zUY779P00p2QPvAk5r0tDRdUSm+7t+POSoj3ByKHepYhD8WM
	 6pgTlfgJJ4vXTAqbLEE0ddr3o+cW10qqG2NKpqKn+tqq5+AUrlYjl2QbJTYHrO/AL4
	 fdcDymruyG43SHpXkTyUaMD8d0upcIQNkulZf+qnEPutPaeDYk6+NzFcQQjqYgo0vK
	 CMpshvpBWX4mhQqgUvbnV5Za16YLnwLhz5+fiZmd2XTqtdp9Y5O+ogZvR8iqpUEPGH
	 f6i605U5m4aTw==
Date: Tue, 15 Jul 2025 07:59:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: don't use xfs_trans_reserve in xfs_trans_roll
Message-ID: <20250715145904.GW2672049@frogsfrogsfrogs>
References: <20250715122544.1943403-1-hch@lst.de>
 <20250715122544.1943403-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715122544.1943403-5-hch@lst.de>

On Tue, Jul 15, 2025 at 02:25:37PM +0200, Christoph Hellwig wrote:
> xfs_trans_roll uses xfs_trans_reserve to basically just call into
> xfs_log_regrant while bypassing the reset of xfs_trans_reserve.
> 
> Open code the call to xfs_log_regrant in xfs_trans_roll and simplify
> xfs_trans_reserve now that it never regrants and always asks for a log
> reservation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_trans.c | 122 +++++++++++++++++++--------------------------
>  1 file changed, 51 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index e43f44f62c5f..553128b7f86a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -134,18 +134,14 @@ xfs_trans_dup(
>  }
>  
>  /*
> - * This is called to reserve free disk blocks and log space for the
> - * given transaction.  This must be done before allocating any resources
> - * within the transaction.
> + * This is called to reserve free disk blocks and log space for the given
> + * transaction before allocating any resources within the transaction.
>   *
>   * This will return ENOSPC if there are not enough blocks available.
>   * It will sleep waiting for available log space.
> - * The only valid value for the flags parameter is XFS_RES_LOG_PERM, which
> - * is used by long running transactions.  If any one of the reservations
> - * fails then they will all be backed out.
>   *
> - * This does not do quota reservations. That typically is done by the
> - * caller afterwards.
> + * This does not do quota reservations. That typically is done by the caller
> + * afterwards.
>   */
>  static int
>  xfs_trans_reserve(
> @@ -158,10 +154,12 @@ xfs_trans_reserve(
>  	int			error = 0;
>  	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
>  
> +	ASSERT(resp->tr_logres > 0);
> +
>  	/*
> -	 * Attempt to reserve the needed disk blocks by decrementing
> -	 * the number needed from the number available.  This will
> -	 * fail if the count would go below zero.
> +	 * Attempt to reserve the needed disk blocks by decrementing the number
> +	 * needed from the number available.  This will fail if the count would
> +	 * go below zero.
>  	 */
>  	if (blocks > 0) {
>  		error = xfs_dec_fdblocks(mp, blocks, rsvd);
> @@ -173,42 +171,20 @@ xfs_trans_reserve(
>  	/*
>  	 * Reserve the log space needed for this transaction.
>  	 */
> -	if (resp->tr_logres > 0) {
> -		bool	permanent = false;
> -
> -		ASSERT(tp->t_log_res == 0 ||
> -		       tp->t_log_res == resp->tr_logres);
> -		ASSERT(tp->t_log_count == 0 ||
> -		       tp->t_log_count == resp->tr_logcount);
> -
> -		if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES) {
> -			tp->t_flags |= XFS_TRANS_PERM_LOG_RES;
> -			permanent = true;
> -		} else {
> -			ASSERT(tp->t_ticket == NULL);
> -			ASSERT(!(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
> -		}
> -
> -		if (tp->t_ticket != NULL) {
> -			ASSERT(resp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
> -			error = xfs_log_regrant(mp, tp->t_ticket);
> -		} else {
> -			error = xfs_log_reserve(mp, resp->tr_logres,
> -						resp->tr_logcount,
> -						&tp->t_ticket, permanent);
> -		}
> -
> -		if (error)
> -			goto undo_blocks;
> +	if (resp->tr_logflags & XFS_TRANS_PERM_LOG_RES)
> +		tp->t_flags |= XFS_TRANS_PERM_LOG_RES;
> +	error = xfs_log_reserve(mp, resp->tr_logres, resp->tr_logcount,
> +			&tp->t_ticket, (tp->t_flags & XFS_TRANS_PERM_LOG_RES));
> +	if (error)
> +		goto undo_blocks;
>  
> -		tp->t_log_res = resp->tr_logres;
> -		tp->t_log_count = resp->tr_logcount;
> -	}
> +	tp->t_log_res = resp->tr_logres;
> +	tp->t_log_count = resp->tr_logcount;
>  
>  	/*
> -	 * Attempt to reserve the needed realtime extents by decrementing
> -	 * the number needed from the number available.  This will
> -	 * fail if the count would go below zero.
> +	 * Attempt to reserve the needed realtime extents by decrementing the
> +	 * number needed from the number available.  This will fail if the
> +	 * count would go below zero.
>  	 */
>  	if (rtextents > 0) {
>  		error = xfs_dec_frextents(mp, rtextents);
> @@ -221,18 +197,11 @@ xfs_trans_reserve(
>  
>  	return 0;
>  
> -	/*
> -	 * Error cases jump to one of these labels to undo any
> -	 * reservations which have already been performed.
> -	 */
>  undo_log:
> -	if (resp->tr_logres > 0) {
> -		xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
> -		tp->t_ticket = NULL;
> -		tp->t_log_res = 0;
> -		tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
> -	}
> -
> +	xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
> +	tp->t_ticket = NULL;
> +	tp->t_log_res = 0;
> +	tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
>  undo_blocks:
>  	if (blocks > 0) {
>  		xfs_add_fdblocks(mp, blocks);
> @@ -1030,36 +999,41 @@ xfs_trans_cancel(
>  }
>  
>  /*
> - * Roll from one trans in the sequence of PERMANENT transactions to
> - * the next: permanent transactions are only flushed out when
> - * committed with xfs_trans_commit(), but we still want as soon
> - * as possible to let chunks of it go to the log. So we commit the
> - * chunk we've been working on and get a new transaction to continue.
> + * Roll from one trans in the sequence of PERMANENT transactions to the next:
> + * permanent transactions are only flushed out when committed with
> + * xfs_trans_commit(), but we still want as soon as possible to let chunks of it
> + * go to the log.  So we commit the chunk we've been working on and get a new
> + * transaction to continue.
>   */
>  int
>  xfs_trans_roll(
>  	struct xfs_trans	**tpp)
>  {
>  	struct xfs_trans	*trans = *tpp;
> +	struct xfs_mount	*mp = trans->t_mountp;
>  	struct xfs_trans_res	tres;
>  	int			error;
>  
>  	trace_xfs_trans_roll(trans, _RET_IP_);
>  
> +	ASSERT(trans->t_log_res > 0);
> +
>  	/*
>  	 * Copy the critical parameters from one trans to the next.
>  	 */
>  	tres.tr_logres = trans->t_log_res;
>  	tres.tr_logcount = trans->t_log_count;
> +	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;

As a dumb optimization, you could initialize tres at declaration time
instead of down here.

Other than that minor nitpicking, this does make it easier for me to
figure out what xfs_trans_roll does because now I don't have to go
picking through the _reserve logic so on those grounds

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  
>  	*tpp = xfs_trans_dup(trans);
>  
>  	/*
>  	 * Commit the current transaction.
> -	 * If this commit failed, then it'd just unlock those items that
> -	 * are not marked ihold. That also means that a filesystem shutdown
> -	 * is in progress. The caller takes the responsibility to cancel
> -	 * the duplicate transaction that gets returned.
> +	 *
> +	 * If this commit failed, then it'd just unlock those items that are not
> +	 * marked ihold. That also means that a filesystem shutdown is in
> +	 * progress.  The caller takes the responsibility to cancel the
> +	 * duplicate transaction that gets returned.
>  	 */
>  	error = __xfs_trans_commit(trans, true);
>  	if (error)
> @@ -1067,14 +1041,20 @@ xfs_trans_roll(
>  
>  	/*
>  	 * Reserve space in the log for the next transaction.
> -	 * This also pushes items in the "AIL", the list of logged items,
> -	 * out to disk if they are taking up space at the tail of the log
> -	 * that we want to use.  This requires that either nothing be locked
> -	 * across this call, or that anything that is locked be logged in
> -	 * the prior and the next transactions.
> +	 *
> +	 * This also pushes items in the AIL out to disk if they are taking up
> +	 * space at the tail of the log that we want to use.  This requires that
> +	 * either nothing be locked across this call, or that anything that is
> +	 * locked be logged in the prior and the next transactions.
>  	 */
> -	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> -	return xfs_trans_reserve(*tpp, &tres, 0, 0);
> +	trans = *tpp;
> +	trans->t_flags |= XFS_TRANS_PERM_LOG_RES;
> +	error = xfs_log_regrant(mp, trans->t_ticket);
> +	if (error)
> +		return error;
> +	trans->t_log_res = tres.tr_logres;
> +	trans->t_log_count = tres.tr_logcount;
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.47.2
> 
> 
