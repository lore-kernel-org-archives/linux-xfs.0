Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECAD5616C0;
	Tue, 22 Sep 2026 22:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790115193; cv=none; b=a6UA/alCL56bc/bOKvPOaJmERfbatX1Olfi85R5jNW2qxbKQNn+CcZgz6lh3l5ufhP+buVv5bj0HoItG5nnRpTOM1wLUtmLqpV6YyAtQ6q4QK1/+9y5Jcp+tZwlThUHEt/1IOMOeIdqFQuoD9P4p4B0vys0uuAgWsiCwVMW8Rx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790115193; c=relaxed/simple;
	bh=i5QH9OtSe6Mko3XfT6VsMrUIuOag608CTs7juOYk2x0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fBOWsfJQTAf0up7ZgV+VR6qF/mQkkRpvd5YV24WlK21clEBpg7Uq9g9RYouHWhwnYbplQ5aSnKUhjWxcFig+Til//D9S+9rbSHDDm/gQdm9Hby5vo8ImFp8sh8Lzx/74arXC8fcU97l0z2u4jVIi3BYNVQH6032ZYscXgGm0Zuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/oEr1hD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/oEr1hD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D257E1F000FF;
	Tue, 22 Sep 2026 22:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790115175;
	bh=hOhEGXrCm5RukHPz+l9coDc0fzxvUt1JOQ5e3Wz87fw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h/oEr1hDSb1mAHEjy4u94E7otCerB91QM1iBzCWksRAZBl+L9Mmd7Z9HdhqMSHenP
	 gq2EDNXyAV6Mj+hwHR3ucLLg6HPSIAny23UeIcYAYop5+q/jyjNOVmpri+PqQtcmXZ
	 Y/aTFryO8bBfKMJEIxA2o7zmWogRX4fbcneIk3KU6foS7PVVLmPwoD5D3gJ3VBa5CA
	 wCn/8dDfjsfviCjegkLZq7BHx/dJCoArtbKsDRxkJNEC2CiykJrIgWbSpgEVOjYO0S
	 74J+/0SoqldJDYFLVgI26GOTBIbuI2NmHeg1mI3HFIm5YN7JicZFPENiu2YzbARMU+
	 qlcWf5U1t8FDA==
Date: Wed, 23 Sep 2026 08:12:46 +1000
From: Dave Chinner <dgc@kernel.org>
To: MingTao Huang <1037827920@qq.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	MingTao Huang <mintaohuang@tencent.com>
Subject: Re: [PATCH] xfs: fix skipped flushing items not counted in
 xfsaild_push()
Message-ID: <arL9Xrmf5Q7wd3T4@dread>
References: <tencent_F801A9436DFB447AAFEC63D3E615B8052405@qq.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_F801A9436DFB447AAFEC63D3E615B8052405@qq.com>

On Tue, Sep 22, 2026 at 04:14:29PM +0800, MingTao Huang wrote:
> From: MingTao Huang <mintaohuang@tencent.com>
> 
> Commit f3f7ae68a4ea ("xfs: skip flushing log items during push")
> introduced a fast path in xfsaild_push() that uses
> test_bit(XFS_LI_FLUSHING) to skip log items already being
> flushed.  However, the fast path jumps directly to the
> next_item label, bypassing flushing++, count++, and the
> ail_last_pushed_lsn update.  This causes three problems:

Right, they get skipped because they are already flushing and we are
not doing anything with them. i.e. they've already been accounted as
flushing (e.g. inodes that were gathered into a single buffer flush
by xfs_iflush_cluster()) and the buffer is already either on the
delwri list for submission or under IO.

> 
> 1. The loop exit condition "count > 1000" becomes much harder to
>    trigger.  count was meant to track every item visited, but now it

No it isn't.

As the author of this code, I can say for certain that the intent of
'count' is to count the number of items we made pushing decisions
about, not count the number of items we have iterated. 

The purpose of 'flushing' is to account for the number of buffers we
accumulate on the delwri list before we submit it. As count is
incremented whenever flushing is incremented, it currently forms
an upper bound to the number of buffers that can be queued on the
delwri list in a single push iteration.

The purpose of 'stuck' is to account for items that could not be
placed on the delwri list because they were locked, pinned or
otherwise unavailable for flushing.

'success' is not directly counted, because there is no further
action that needs to be taken for them; they are simply counted,
and hence contribute to the flush/stuck ratio decisions later.

IOWs, every 'push decision' that could add a buffer to the delwri
list is accounted by 'count', and flushing/stuck indicate what
decision was made.

The point of LI_FLUSHING was simply to skip over all the items that
would not change either count, flushing or stuck because they have
already been accounted to 'count' and 'flushing' by a prior push
decision.

>    only increments for non-flushing items that enter
>    xfsaild_push_item().

Exactly - count is the number of items we made new pushing decsions
about.

>    Each such item typically triggers an inode
>    cluster flush that marks dozens of neighbouring inodes as flushing,
>    so count effectively counts cluster flushes rather than individual
>    items. 

Yes, that is exactly the intent - a single cluster buffer on the
delwri list covers up to 32 inode items on the AIL. That is -one IO-
for up to 32 items on the AIL, and it is -IO- that we are trying to
account for and optimise here, not log items.

>    The threshold shifts from 1000 items to ~1000 clusters,

No, the count has always been '1000 new buffer IO decisions made',
not '1000 items processed'.

>    letting the loop scan an order of magnitude more items per round.
>    Each cluster flush adds a buffer to ail_buf_list, and the resulting
>    oversized list causes xfs_buf_delwri_submit_nowait() -- which runs
>    list_sort() plus per-buffer trylock and IO submission -- to take so
>    long that the watchdog fires.

How? count bounds the delwri list to 1000 buffers at most. That's
very intentional, and the number is based on benchmarking results.

i.e.  A thousand items on a list takes a couple of milliseconds to
sort. I/O submission of that list takes a couple of milliseconds if
it doesn't block (i.e. the IO subsystem has to be faster than the
CPU IO submission loop to avoid block on a full queue), and if it
does block, we want all the IO submission to merge as effectively as
possible in the queue so that we use as few IO slots in the queue as
possible.

Hence the submission code should not be running around in a hard
loop for 22s because of a list that is too long. The buffer list
length is -bounded- by count, and that should prevent these sorts of
issues.

> 2. The timeout decision "(stuck + flushing) * 100 / count > 90" is
>    computed without the fast-path flushing items, so the flushing ratio
>    is severely under-reported.

No, the accounting this check is acting on is correct. The action we
take is based on the all the items we tried to push this iteration,
not the indirect LI_FLUSHING items that we didn't make a decision
about or are still in progress from the previous iteration.

>    When most of the AIL is flushing, the
>    ratio appears near 0%.

How did you get into a state where most of the AIL is flushing and
no progress is being made transitioning items out of flushing state?

i.e. if delwri submission is not making progress, then the ail push
will keep appending to the delwri list (by design, so we retry
flushing items until submission succeeds). This will result in
transitioning most of the AIL to flushing state and queued on the
delwri list. This is a symptom of the delwri submission not
making progress and rather than a problem with AIL flushing
accounting.

i.e. we need to know why delwri submission is not making progress,
as that is likely the real cause of the problem. i.e. it is unlikely
that this has anythign to do with how we account for item push
decisions, and it is likely your changes just slow down or change
the timing of item pushing sufficiently to avoid whatever issue is
occuring in delwri submission.

>    xfsaild therefore selects
>    "tout = 0" when it should select "tout = 20" (20 ms
>    back-off to let IO complete).  The zero-backoff tight loop compounds
>    the ail_buf_list accumulation across rounds.
> 
> 3. ail_last_pushed_lsn is not advanced past flushing items, so the
>    next push round restarts scanning from the same position, repeatedly
>    traversing items that are still in-flight.

This is why we do not account for flushing items that we skip. It will
walk over them as fast as possible until it reaches items that it
can push. Those items will then be accounted as
flushing/stuck/count. This will then move the last_lsn forwards
appropriately or trigger a log force or backoff sleep and so it
should not get stuck spinning for 22s in that case, either.

> We hit this as a soft lockup during stress testing on an internal
> kernel that includes commit f3f7ae68a4ea ("xfs: skip flushing log
> items during push").  The xfsaild kthread was stuck for
> 22 seconds inside xfs_buf_delwri_submit_nowait(), called from
> xfsaild_push(), processing an excessively large ail_buf_list:

Tell me how the delwri list got so long that it gets stuck inside
xfs_buf_delwri_submit_nowait(). Whatever caused that is the bug that
we need to understand and fix - changing accounting to make gross
behavioural changes that result in exceedingly inefficient CPU usage
and break IO optimisations is not the way to address a list length
that has apparently excceeded the bounds built into the code...

-Dave.


-- 
Dave Chinner
dgc@kernel.org
