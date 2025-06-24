Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCC926ACB
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 04:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750740212; cv=none; b=Zw/EoJ8QEfuAlrzJnUPDlSzgYpAUu+RZgYmWD9lWMp+LGQcHvT2LTURJ9tO5fB2Cgrpnhq0NGVi3JY6EAsQU11t6fgho1JIE5PfArTvsfsQTmtOROFFOxRPwaZbJEpYooXYeSk+t26d8FA+hRmrWVYvnkF20G/sBzoVmHkOnit0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750740212; c=relaxed/simple;
	bh=lnSS91PRtJhiapduBahQsvZGEmp5PCql3XBcoUSNGnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oOPbcd2/yPHqLnk7ymVUej8nA4USN9OEr1EqSBDD0yYpaRKLkKuSLVS3Ldx9Pwv05QWFafEG+OVcGkMqBXBhfh97yrfy7c6YFWeurTsLRS5/gk3T4JkguBwS7qUDyhgDrxgPvWJasdxX9qcjZ0S50zZznYT2SiNuMEDFn9hr6Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OVeZyAwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OVeZyAwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36CFC4CEE3;
	Tue, 24 Jun 2025 04:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750740212;
	bh=lnSS91PRtJhiapduBahQsvZGEmp5PCql3XBcoUSNGnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OVeZyAwFAodZNfGhN+ekTVoWopipsDaHKe174oOZE3SlYD6+7G2SiaGHOmddSNwAB
	 00AoCPeA399GNnULLRUPM8vVG/eohd1pOK249j7eRQ6MtdZ4i48GawyjVFy46FVptc
	 75e8jcFfHfLTFuyWgzbyZ3T0LTH/XK2h/WyrnxmUzoIAdoINhDXNk3+tfiJ2AJhkPR
	 7YzbEG25K2yWM4s37caqLJB/v+pqyRiGaQRdxS0BZJMmX/xFGa7j41HBsioQ0hIVXo
	 WEf/z37lTB4DrNdK54GRDIGKdJEmM1qsHGtw3WwkYIv8pOQ6jKSgWW9vTiuaehRpI1
	 9MlC0SAOV4R1A==
Date: Tue, 24 Jun 2025 06:43:27 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org
Subject: Re: [PATCH 1/2] xfs: replace iclogs circular list with a list_head
Message-ID: <lln7n3nc6clwvbnyp6nlfvd233mkx2wll54enordgrc6ycdctd@bivocib627mt>
References: <20250620070813.919516-1-cem@kernel.org>
 <20250620070813.919516-2-cem@kernel.org>
 <3PhJyfh7MtNolvDaUsC9QhFsdQJFl4PmcxsOTNwjyLLszUztrJi2kUNEAQtr8kCyRNnH3c2ORULXY-LWOt_VQw==@protonmail.internalid>
 <aFoKgNq6IuPJAJAv@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFoKgNq6IuPJAJAv@dread.disaster.area>

On Tue, Jun 24, 2025 at 12:16:32PM +1000, Dave Chinner wrote:
> On Fri, Jun 20, 2025 at 09:07:59AM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > Instead of using ic_{next,prev}, replace it with list_head framework
> > to simplify its use.
> >
> > This has a small logic change:
> >
> > So far log->l_iclog holds the current iclog pointer and moves this
> > pointer sequentially to the next iclog in the ring.
> >
> > Instead of keeping a separated iclog pointer as the 'current' one, make
> > the first list element the current iclog.
> > Once we mark the iclog as WANT_SYNC, just move it to the list tail,
> > making the the next iclog as the 'current' one.
> 
> Hmmmm. I don't see a problem with using a list head for the ring,
> But I do see a problem with making the ring mutable.
> 
> The current code sets up the iclog list once and mount, and
> it is read-only from then on. i.e. we never modify the iclog ring
> pointers from then on, and the only thing that changes is the
> pointer to the first iclog.
> 
> This means it is always safe to walk the iclog ring, regardless of
> whether the icloglock is held or not.  I know there are asserts that
> walk the ring without the icloglock held, not sure about the rest of
> the code.

This makes sense, thanks for the explanation, I also had another idea of keeping
a different pointer for the current active iclog, instead of modifying the ring,
i.e. keep the ring immutable, and just update an active pointer to point to the
current iclog. Does it make sense to attempt that or should I just scratch this
idea?

Cheers.
Carlos

> 
> It also means that shared cacheline access is all that is needed to
> walk the ring, and because the ring is not mutable, updating the
> first iclog in the ring (i.e. writing to log->l_iclog) doesn't
> change the shared CPU cache state of the iclog ring pointers.
> 
> Converting it to a list head and making the iclog list mutable by
> moving items from head to tail instead of just changing which item
> log->l_iclog points to means it is no longer safe to walk the iclog
> ring without holding the icloglock.
> 
> Further, the list_move_tail() call to update the first iclog in the
> ring now has to modify the list head cache line (i.e. log->iclog)
> and the list pointers for the iclog we are moving, the second iclog
> in the list that now becomes the head, and the old tail of the list
> we are inserting behind.
> 
> IOWs, every time we switch to a new iclog, we now dirty 4 cachelines
> instead of just 1 (log->l_iclog). When the log is running hard (e.g.
> at 600MB/s on 32kB iclogs) we are switching iclogs around 20,000
> times a second. Hence this change results in a *lot* more cacheline
> dirtying in a fast path than we currently do, and that will likely
> have measurable performance impact.
> 
> Further, we generally touch those cachelines next in interrupt
> context, so now journal IO completion will be having to flush those
> cachelines from the cache of a different CPU so they can be accessed
> whilst walking the iclog ring to complete iclogs in order. This will
> likely also have measurable impact on journal IO completion as well.
> 
> Hence I think that the ring should remain immutable and the
> log->l_iclog pointer retained to index the first object in the ring.
> This means we don't need a list head in the struct xlog for the
> iclog ring, we can have the ring simply contain just the iclogs as
> they currently do.
> 
> 
> > @@ -476,8 +476,7 @@ xlog_state_shutdown_callbacks(
> >  	struct xlog_in_core	*iclog;
> >  	LIST_HEAD(cb_list);
> >
> > -	iclog = log->l_iclog;
> > -	do {
> > +	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
> >  		if (atomic_read(&iclog->ic_refcnt)) {
> >  			/* Reference holder will re-run iclog callbacks. */
> >  			continue;
> > @@ -490,7 +489,7 @@ xlog_state_shutdown_callbacks(
> >  		spin_lock(&log->l_icloglock);
> >  		wake_up_all(&iclog->ic_write_wait);
> >  		wake_up_all(&iclog->ic_force_wait);
> > -	} while ((iclog = iclog->ic_next) != log->l_iclog);
> > +	}
> 
> This is likely broken by the ring being made mutable. The
> l_icloglock is dropped in the middle of the list traversal, meaning
> the ring order can change whilst callbacks are running. It is
> critical that this operation occurs in ascending LSN order.
> 
> This is why the ring is immutable; we can walk around the ring
> multiple times here whilst submission and completion is occurring
> concurrently with callback processing.
> 
> Same goes for xlog_state_do_callback ->
> xlog_state_do_iclog_callbacks(), especially the bit about always
> iterating iclogs in ascending LSN order.
> 
> >  	wake_up_all(&log->l_flush_wait);
> >  }
> > @@ -810,13 +809,11 @@ xlog_force_iclog(
> >  static void
> >  xlog_wait_iclog_completion(struct xlog *log)
> >  {
> > -	int		i;
> > -	struct xlog_in_core	*iclog = log->l_iclog;
> > +	struct xlog_in_core	*iclog;
> >
> > -	for (i = 0; i < log->l_iclog_bufs; i++) {
> > +	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
> >  		down(&iclog->ic_sema);
> >  		up(&iclog->ic_sema);
> > -		iclog = iclog->ic_next;
> >  	}
> >  }
> 
> This is called without the l_icloglock held, so if the list is
> mutable this can go wrong....
> 
> > @@ -2486,19 +2471,17 @@ xlog_state_do_iclog_callbacks(
> >  		__releases(&log->l_icloglock)
> >  		__acquires(&log->l_icloglock)
> >  {
> > -	struct xlog_in_core	*first_iclog = log->l_iclog;
> > -	struct xlog_in_core	*iclog = first_iclog;
> > +	struct xlog_in_core	*iclog;
> >  	bool			ran_callback = false;
> >
> > -	do {
> > +	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
> >  		LIST_HEAD(cb_list);
> >
> >  		if (xlog_state_iodone_process_iclog(log, iclog))
> >  			break;
> > -		if (iclog->ic_state != XLOG_STATE_CALLBACK) {
> > -			iclog = iclog->ic_next;
> > +		if (iclog->ic_state != XLOG_STATE_CALLBACK)
> >  			continue;
> > -		}
> > +
> >  		list_splice_init(&iclog->ic_callbacks, &cb_list);
> >  		spin_unlock(&log->l_icloglock);
> >
> > @@ -2509,8 +2492,7 @@ xlog_state_do_iclog_callbacks(
> >
> >  		spin_lock(&log->l_icloglock);
> >  		xlog_state_clean_iclog(log, iclog);
> > -		iclog = iclog->ic_next;
> > -	} while (iclog != first_iclog);
> > +	}
> 
> As per above, the icloglock is dropped during iteration here...
> 
> > @@ -2913,7 +2898,7 @@ xfs_log_force(
> >  		 * is nothing to sync out. Otherwise, we attach ourselves to the
> >  		 * previous iclog and go to sleep.
> >  		 */
> > -		iclog = iclog->ic_prev;
> > +		iclog = list_prev_entry_circular(iclog, &log->l_iclogs, ic_list);
> 
> That's not really an improvement. :/
> 
> But if we just make the iclogs a circular list without the
> log->l_iclogs head, then it's just list_prev_entry().
> 
> Still not sure this is better than the current code....
> 
> > @@ -3333,12 +3319,8 @@ xlog_verify_iclog(
> >
> >  	/* check validity of iclog pointers */
> >  	spin_lock(&log->l_icloglock);
> > -	icptr = log->l_iclog;
> > -	for (i = 0; i < log->l_iclog_bufs; i++, icptr = icptr->ic_next)
> > +	list_for_each_entry(icptr, &log->l_iclogs, ic_list)
> >  		ASSERT(icptr);
> 
> This needs to count the number of iclogs in the list, check it
> against log->l_iclog_bufs...
> 
> > -
> > -	if (icptr != log->l_iclog)
> > -		xfs_emerg(log->l_mp, "%s: corrupt iclog ring", __func__);
> 
> .... because that is what this checks.
> 
> >  	spin_unlock(&log->l_icloglock);
> >
> >  	/* check log magic numbers */
> > @@ -3531,17 +3513,15 @@ STATIC int
> >  xlog_iclogs_empty(
> >  	struct xlog	*log)
> >  {
> > -	xlog_in_core_t	*iclog;
> > +	struct xlog_in_core	*iclog;
> >
> > -	iclog = log->l_iclog;
> > -	do {
> > +	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
> >  		/* endianness does not matter here, zero is zero in
> >  		 * any language.
> >  		 */
> >  		if (iclog->ic_header.h_num_logops)
> >  			return 0;
> > -		iclog = iclog->ic_next;
> > -	} while (iclog != log->l_iclog);
> > +	}
> >  	return 1;
> 
> Called without icloglock held from debug code.
> 
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
