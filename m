Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE635464E
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 02:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750731398; cv=none; b=C+pMeryDe3NjBU9VtIv2r7I/tCvPmwvYbTcjSk9bHjvgceZCI5gcgSZjhGYmI2BIw/MwUnRkQmeHZiNN20drw1wpNjtLhu2z9Z0S4vmOX8VKmxc8U3L3RENTMYiZ5JbZPMyZusztKU7ctL+S2jq5kHfr8s8+wp92ycxegAIQFH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750731398; c=relaxed/simple;
	bh=VJN8al8cPBJNSAn9dSJiikB1oh3oVLS7PC7CPM8u094=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EYnao8gPlXea/kPhD+tLcaiS2pFQq8fKZLppevooxrW9qYcUInl8dFxE2DmCVLQF6kUT0W708sUJLJE8YUmuB9nBJ+HZmf3frr9SYXUfRPG/Vi6XbVC7VGtqFvhUZXG31ZnVVRZap/VLHgpahbddIsa50ulRiZ+4xO1vjIo+nPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=SnYDdvfS; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="SnYDdvfS"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-234b9dfb842so42880775ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jun 2025 19:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750731396; x=1751336196; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=enBa+3rd39dRH5am74f3zjyyGfyE7gF6/FnQJOGa+as=;
        b=SnYDdvfS7gw49e36yYimXcrs/d3CJJ7H9DRdzua0F8uGkDtswIvzJrJSG/j/cT18Nd
         1dxCBSzChjsJdQIYNoYh/wDMToT7OI+RmDJPUWNAFpp6sTp7ESgOxmfDJnjfrbj9PBlb
         wOj6jlkA2+lgH7NqXvG9zmxp5gKcK2f7EIEid4YQ6VKtg2lFCCmlM6pxWaCjlZORPBWt
         9dh0zzD7Ig8c7CGgM0JaSbMcANqoSMtblKFYEER7HOZeYlIQXYT7YqdmtkJgvL3+8GwN
         gWO4SVtdakf8yzXP7mqN2MCm1I36Qqjb8oH6Qx53xnWzLOGmMjDq4cr2uW8pFJmc9uu9
         5RTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750731396; x=1751336196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=enBa+3rd39dRH5am74f3zjyyGfyE7gF6/FnQJOGa+as=;
        b=A+FLkKxp8dvMGxQgV82YbP5SE5zDCYHp1MNxAXOqgIgiuCzZuF0NQrk8hs+tk7Sqor
         kcku2fHKeam0qWCWqhNzh7tXDJ2rpfWci8CZ/mBIfJZDQHdY3gO+Li1X3d9TOLBUp+Ws
         cQdAYQMSmuteRkbmJWkrMUGll02jd/0EyCO6E3szgjp5DhCYzFEHnk0P4B1Y4d/psqhx
         X/CGcpW9a/dBYdilnvxsD6eHTiWKVOC76YJ+MCVri6tjNve1uniKs4aw+zaBUK5mirY8
         9qVXOWDL1ysBTSy203GEv0x6q+ay3kvm1/BM+YOd/mSch5aL22nj1S32i3MyKUhq5VM5
         XpMg==
X-Gm-Message-State: AOJu0YxqrxQwsvoptlFFdP0I4YMWivmmzzqepFbiWytXU3Q++M01UOH6
	1fsDwfVIm0q6V/eZYFVcLnTk8RiSt2P/vKysG7AHYEFzOvfPEbWlUpvfzlwJifCHC3yTagfZ8EX
	k9QNQ
X-Gm-Gg: ASbGnctVHMeyPg1pvRqk/i30C53jwvBGANFD4x9TO1eYDVfLXVKiFo8KWGoQkHFsnSx
	FXTvOZ/I5f2wIGs9nCvLhI5/5+3mojJ5RHHsq77ajX6Nxvj9WZhfO1la8R2U8RzzwIqCJpH/5m0
	+KSDJxj5ZeZDQk51MYakDatSq3RHUt7SL9UZVyj8fkljfWXHDqgT9M2NLpKub6pGbpMgUkMcvqZ
	knLkXShdcUmVSqrfbVQYgJIvxWh/rtfA8vnDnlxVroPccevBz84SBvDO6XodQa+gwi9WoFP38jx
	GuhcDkfOgp9PAWOdkZBEdV4/LLTkruayNgDubnynka5aSrGy9HGD0XfvezuEw1ngZncMsafyo7z
	0wMWUsRKfRcdzvJo8IXS5C/U8XFmynlcZlhTL1Q==
X-Google-Smtp-Source: AGHT+IHvIsrtrHT5mo4BXpzR4b6lGVnrTX9E68IUDPNlc16P/F1TiA119qciAJZrQOM2oX0+BOFSxg==
X-Received: by 2002:a17:903:2f4b:b0:234:a139:120a with SMTP id d9443c01a7336-237d9a71c4fmr212714115ad.32.1750731396312;
        Mon, 23 Jun 2025 19:16:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d86c49d4sm97173255ad.200.2025.06.23.19.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 19:16:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uTtD6-00000002TtX-3Pb2;
	Tue, 24 Jun 2025 12:16:32 +1000
Date: Tue, 24 Jun 2025 12:16:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org
Subject: Re: [PATCH 1/2] xfs: replace iclogs circular list with a list_head
Message-ID: <aFoKgNq6IuPJAJAv@dread.disaster.area>
References: <20250620070813.919516-1-cem@kernel.org>
 <20250620070813.919516-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620070813.919516-2-cem@kernel.org>

On Fri, Jun 20, 2025 at 09:07:59AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Instead of using ic_{next,prev}, replace it with list_head framework
> to simplify its use.
> 
> This has a small logic change:
> 
> So far log->l_iclog holds the current iclog pointer and moves this
> pointer sequentially to the next iclog in the ring.
> 
> Instead of keeping a separated iclog pointer as the 'current' one, make
> the first list element the current iclog.
> Once we mark the iclog as WANT_SYNC, just move it to the list tail,
> making the the next iclog as the 'current' one.

Hmmmm. I don't see a problem with using a list head for the ring,
But I do see a problem with making the ring mutable.

The current code sets up the iclog list once and mount, and
it is read-only from then on. i.e. we never modify the iclog ring
pointers from then on, and the only thing that changes is the
pointer to the first iclog.

This means it is always safe to walk the iclog ring, regardless of
whether the icloglock is held or not.  I know there are asserts that
walk the ring without the icloglock held, not sure about the rest of
the code.

It also means that shared cacheline access is all that is needed to
walk the ring, and because the ring is not mutable, updating the
first iclog in the ring (i.e. writing to log->l_iclog) doesn't
change the shared CPU cache state of the iclog ring pointers.

Converting it to a list head and making the iclog list mutable by
moving items from head to tail instead of just changing which item
log->l_iclog points to means it is no longer safe to walk the iclog
ring without holding the icloglock.

Further, the list_move_tail() call to update the first iclog in the
ring now has to modify the list head cache line (i.e. log->iclog)
and the list pointers for the iclog we are moving, the second iclog
in the list that now becomes the head, and the old tail of the list
we are inserting behind.

IOWs, every time we switch to a new iclog, we now dirty 4 cachelines
instead of just 1 (log->l_iclog). When the log is running hard (e.g.
at 600MB/s on 32kB iclogs) we are switching iclogs around 20,000
times a second. Hence this change results in a *lot* more cacheline
dirtying in a fast path than we currently do, and that will likely
have measurable performance impact.

Further, we generally touch those cachelines next in interrupt
context, so now journal IO completion will be having to flush those
cachelines from the cache of a different CPU so they can be accessed
whilst walking the iclog ring to complete iclogs in order. This will
likely also have measurable impact on journal IO completion as well.

Hence I think that the ring should remain immutable and the
log->l_iclog pointer retained to index the first object in the ring.
This means we don't need a list head in the struct xlog for the
iclog ring, we can have the ring simply contain just the iclogs as
they currently do.


> @@ -476,8 +476,7 @@ xlog_state_shutdown_callbacks(
>  	struct xlog_in_core	*iclog;
>  	LIST_HEAD(cb_list);
>  
> -	iclog = log->l_iclog;
> -	do {
> +	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
>  		if (atomic_read(&iclog->ic_refcnt)) {
>  			/* Reference holder will re-run iclog callbacks. */
>  			continue;
> @@ -490,7 +489,7 @@ xlog_state_shutdown_callbacks(
>  		spin_lock(&log->l_icloglock);
>  		wake_up_all(&iclog->ic_write_wait);
>  		wake_up_all(&iclog->ic_force_wait);
> -	} while ((iclog = iclog->ic_next) != log->l_iclog);
> +	}

This is likely broken by the ring being made mutable. The
l_icloglock is dropped in the middle of the list traversal, meaning
the ring order can change whilst callbacks are running. It is
critical that this operation occurs in ascending LSN order.

This is why the ring is immutable; we can walk around the ring
multiple times here whilst submission and completion is occurring
concurrently with callback processing.

Same goes for xlog_state_do_callback ->
xlog_state_do_iclog_callbacks(), especially the bit about always
iterating iclogs in ascending LSN order.

>  	wake_up_all(&log->l_flush_wait);
>  }
> @@ -810,13 +809,11 @@ xlog_force_iclog(
>  static void
>  xlog_wait_iclog_completion(struct xlog *log)
>  {
> -	int		i;
> -	struct xlog_in_core	*iclog = log->l_iclog;
> +	struct xlog_in_core	*iclog;
>  
> -	for (i = 0; i < log->l_iclog_bufs; i++) {
> +	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
>  		down(&iclog->ic_sema);
>  		up(&iclog->ic_sema);
> -		iclog = iclog->ic_next;
>  	}
>  }

This is called without the l_icloglock held, so if the list is
mutable this can go wrong....

> @@ -2486,19 +2471,17 @@ xlog_state_do_iclog_callbacks(
>  		__releases(&log->l_icloglock)
>  		__acquires(&log->l_icloglock)
>  {
> -	struct xlog_in_core	*first_iclog = log->l_iclog;
> -	struct xlog_in_core	*iclog = first_iclog;
> +	struct xlog_in_core	*iclog;
>  	bool			ran_callback = false;
>  
> -	do {
> +	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
>  		LIST_HEAD(cb_list);
>  
>  		if (xlog_state_iodone_process_iclog(log, iclog))
>  			break;
> -		if (iclog->ic_state != XLOG_STATE_CALLBACK) {
> -			iclog = iclog->ic_next;
> +		if (iclog->ic_state != XLOG_STATE_CALLBACK)
>  			continue;
> -		}
> +
>  		list_splice_init(&iclog->ic_callbacks, &cb_list);
>  		spin_unlock(&log->l_icloglock);
>  
> @@ -2509,8 +2492,7 @@ xlog_state_do_iclog_callbacks(
>  
>  		spin_lock(&log->l_icloglock);
>  		xlog_state_clean_iclog(log, iclog);
> -		iclog = iclog->ic_next;
> -	} while (iclog != first_iclog);
> +	}

As per above, the icloglock is dropped during iteration here...

> @@ -2913,7 +2898,7 @@ xfs_log_force(
>  		 * is nothing to sync out. Otherwise, we attach ourselves to the
>  		 * previous iclog and go to sleep.
>  		 */
> -		iclog = iclog->ic_prev;
> +		iclog = list_prev_entry_circular(iclog, &log->l_iclogs, ic_list);

That's not really an improvement. :/

But if we just make the iclogs a circular list without the
log->l_iclogs head, then it's just list_prev_entry().

Still not sure this is better than the current code....

> @@ -3333,12 +3319,8 @@ xlog_verify_iclog(
>  
>  	/* check validity of iclog pointers */
>  	spin_lock(&log->l_icloglock);
> -	icptr = log->l_iclog;
> -	for (i = 0; i < log->l_iclog_bufs; i++, icptr = icptr->ic_next)
> +	list_for_each_entry(icptr, &log->l_iclogs, ic_list)
>  		ASSERT(icptr);

This needs to count the number of iclogs in the list, check it
against log->l_iclog_bufs...

> -
> -	if (icptr != log->l_iclog)
> -		xfs_emerg(log->l_mp, "%s: corrupt iclog ring", __func__);

.... because that is what this checks.

>  	spin_unlock(&log->l_icloglock);
>  
>  	/* check log magic numbers */
> @@ -3531,17 +3513,15 @@ STATIC int
>  xlog_iclogs_empty(
>  	struct xlog	*log)
>  {
> -	xlog_in_core_t	*iclog;
> +	struct xlog_in_core	*iclog;
>  
> -	iclog = log->l_iclog;
> -	do {
> +	list_for_each_entry(iclog, &log->l_iclogs, ic_list) {
>  		/* endianness does not matter here, zero is zero in
>  		 * any language.
>  		 */
>  		if (iclog->ic_header.h_num_logops)
>  			return 0;
> -		iclog = iclog->ic_next;
> -	} while (iclog != log->l_iclog);
> +	}
>  	return 1;

Called without icloglock held from debug code.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
