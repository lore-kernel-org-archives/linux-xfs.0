Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6431C2F39C7;
	Sun,  9 Aug 2026 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786301326; cv=none; b=jvJq1CXP6mpQ903RyoM8XAYC/3LrjJrNvTFzin5z/oPdTcPD9pWO9nf+UJXRLCCNm3VKsnRWpJIGuHXyDxxq4GD5lrndJGEetuSNwKgeTN7gYTshSqhQJS8wOzjcTU8k740vJx4nohWw1Mjfo6um+VRg5E4EARZaZq8Yz4aJMEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786301326; c=relaxed/simple;
	bh=EA6hZezhXT3CahjR4zhippzUlCMTcYcdfWFIk06cPpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTGLVyoknbxf2s5+BGI+BRKri/tdfyEFFt+4uK8fo2B2BTCgRbl2geqtBZ8VW910nRjej56tTVE+va2Wlwt0AUhcuPwvNHL+KTOaH2dzb1MpIEod1/9kGJdfwSXCGND5eU++6Wq8dMXw/lND+JD+gmY+XguSRkExMGoZmlxLUkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ja/jRgRs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ja/jRgRs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C10331F000E9;
	Sun,  9 Aug 2026 18:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786301324;
	bh=ZQJdO1dFA3UjpiPPQQGnAfwilWHe5IrT38BJDU6FTzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ja/jRgRsDeaEiaejaIW43lxiwZXChebRkcEvWy43g9N3zZD8mN1pRBAytW0QnLDG4
	 NiEnqWjTr5dgnQmP1yqYZF0i9eZAgz0fY8+aWDhOPQZ+90Sd20lywkCehIXFGcdCEf
	 NBMNneDPB0HNe016Ks3DjUj9aAEFBTJqhrd++MsnlYB16GSExB8hK3wV0af2px0TX+
	 84oKP2eegrpXf/QLqeuMHd11QWCLTZ7WWVVIrM2e8uMyq10TyviwamuiDSRIRsPAzJ
	 tLR7FqVzrQJZbA1ZzurkWVMxWgzm6qiMRnBkD0HgELiJSSmsC4icRJXNv/XbYKECuy
	 MS7r8u6nvfRLg==
Date: Sun, 9 Aug 2026 11:48:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Javier Tia <javier@peridio.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: initialise error in xfs_defer_finish_one()
Message-ID: <20260809184844.GQ7398@frogsfrogsfrogs>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260808234016.246054-8-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808234016.246054-8-floss@jetm.me>

On Sat, Aug 08, 2026 at 05:40:18PM -0600, Javier Tia wrote:
> xfs_defer_finish_one() declares error without an initialiser and only
> assigns it inside the loop over dfp->dfp_work.  When that list is empty
> the loop body never runs, control falls through to the "Done with the
> dfp, free it" path, and the function returns an indeterminate value.

You could have stopped here with the commit mess.age

> An item-less pending item is not hypothetical.  Of the three
> xfs_defer_alloc() callers, xfs_defer_add() always follows with
> xfs_defer_add_item(), but the other two do not.
> xfs_defer_start_recovery() is harmless because it adds to a
> caller-supplied r_dfops list rather than to tp->t_dfops, so its items
> never enter this path at all, and they are driven by
> xfs_defer_finish_recovery() and ops->recover_work() rather than by
> xfs_defer_finish_one().  xfs_defer_add_barrier() is neither:
> xfs_defer_create_intents() walks tp->t_dfops without filtering
> item-less entries, so a barrier is spliced onto the pending list and is
> eligible to be picked by xfs_defer_finish_noroll().
> xfs_reap_ag_blocks() adds one every other extent, so online repair
> reaches this on any filesystem built with CONFIG_XFS_ONLINE_REPAIR.
> 
> The consequence is a filesystem shutdown that depends on stack
> contents.  xfs_defer_finish_noroll() treats any non--EAGAIN return as
> fatal and calls xfs_force_shutdown(SHUTDOWN_CORRUPT_INCORE), so
> whenever the uninitialised value happens to be non-zero a successful
> barrier is reported as in-core corruption and the filesystem is taken
> down in the middle of a repair.  ops->finish_cleanup() also receives
> the same value where an op type provides one, though no op type that
> can reach the empty-list path defines one.
> 
> Returning zero is the correct result rather than a papered-over error,
> and not only because the barrier type deliberately has no work items:
> reaching the free path at all means the item loop drained without a
> non-zero error, so zero is the truthful value for any op type.
> 
> The uninitialised declaration is older than the Fixes: commit below,
> but that commit is where the bug became reachable - it added
> xfs_defer_add_barrier(), the barrier op type and the only caller of it
> in one go, and before it no item-less pending item could exist.
> 
> Fixes: 3f3cec031099 ("xfs: force small EFIs for reaping btree extents")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Javier Tia <floss@jetm.me>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 89501e8bd2f8..843c33304441 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -583,7 +583,7 @@ xfs_defer_finish_one(
>  	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
>  	struct xfs_btree_cur		*state = NULL;
>  	struct list_head		*li, *n;
> -	int				error;
> +	int				error = 0;

We should really just turn on automatic zeroing of automatic variable.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  
>  	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
>  
> -- 
> Javier Tia
> 
