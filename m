Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D9C3B47D7;
	Fri, 29 May 2026 08:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780044592; cv=none; b=WgLLEouSoYB8wpaglyD5kjYaHXjn1wlt8FpD6E7EucZ7Z1ThsgTrC9MoW9R+yK3Sgl+/PCxIloXcenfBgZ3XGOY+XcSW5QdsDNW0+BjRzsQJz7QtH3q8MOjBQskgsvwTfA5HfXeHg6gcdzzZt90qlAd36gazsz7/f6FjK7fkxLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780044592; c=relaxed/simple;
	bh=gzi15Ba6ST4F/udZXZcOXKU4Z4iYEVoCn/tiURTKZEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcfnHD9WvjiMjn4RyGSCiYqcwCv+V6dVi7OcY10fTrUsjq7Mon6322SWjduI+IYVRRBk6se6mGHd/5RyVrYQK/86/+z9qQBxuKIk14MI908gUshMsHcXgo/TUSqVkc476QcZT3YttYaNslgMPXqbER5SyAh2hLOk7cP9tnqjVdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=PezPME7C; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=hXpBCHC4; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="PezPME7C";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="hXpBCHC4"
Date: Fri, 29 May 2026 10:49:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1780044582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RIQTzMrAiz60EQXjnvZkMfXRLxi3s6ETa0YnTZQN3V0=;
	b=PezPME7Ck4DYD3pliNLx80vlw7cBwz4loyN4hp4vr99ld5QeCjXUaYDk4HPjJWNIaQnq4f
	0LxxtzVOUWhqIHIH7twCdRAVZ4CLMCdeIYdJe5JdlFewz1xVNoOu78DAFqsfcYlkoIcDT9
	O/XNOzNEuARiVjFPEv7yXpTcaMjFZqQ2LZYMPvDbih3OvYfdJi/vdTvDq7xh8iGIbQTDzW
	yDWvl0x9xn7yNXjZ9k9dcBmv54e/1zv0kJh5cvQZSczWuVAf4haoNjwrQ1mjH9Y00UK3oQ
	6HjviRT4QUJQa+RVtekFJTWsggcUGZeLOBhi2MTnepnzenOqovMnOrV4JCrYfQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1780044582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RIQTzMrAiz60EQXjnvZkMfXRLxi3s6ETa0YnTZQN3V0=;
	b=hXpBCHC4cVaCxy8mohdL9CuJryevkV2GGrSOm/4C3/y0Ka2S2b4kEgKL/boonjNbSwUhFS
	2C4ZWQ/P7coXDPBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <20260529084939.bWkYVTj4@linutronix.de>
References: <ea6fc01f-5cb7-4a04-9f92-bbd2791fea51@columbia.edu>
 <ahPdDtu3vXfNpb__@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ahPdDtu3vXfNpb__@infradead.org>

On 2026-05-24 22:24:30 [-0700], Christoph Hellwig wrote:
> > > +	local_lock_irqsave(&bio_complete_batch.lock, flags);
> > 
> > Q: "Is it safe to use local_lock_irqsave() here when called from an atomic
> > context?
> > On CONFIG_PREEMPT_RT kernels, local_lock_t maps to a per-CPU spinlock_t,
> > which is a sleepable rt_mutex. Since __bio_complete_in_task() is specifically
> > called when bio_in_atomic() is true (which includes hardware interrupts or
> > execution under a raw_spinlock_t), attempting to acquire a sleepable lock
> > here would trigger an "Invalid wait context" lockdep warning.
> > Would a lockless list (llist) be more appropriate here to avoid sleeping
> > in atomic contexts?"
> > 
> > A: This seems legit, but I'm not super familiar with PREEMPT_RT. I don't want
> > to switch to raw_spinlock_t, as it seems like that would add unnecessary
> > overhead on non-PREEMPT_RT kernels. I think switching to use local_irq_save()
> > (as is done for the per-CPU bio allocation cache) should work.
> 
> Adding the PREEMPT_RT maintainers for this as it is above my pay grade.

The local_lock_irqsave() seems to come from __bio_complete_in_task()
which sounds like preemptible context in general. So yes, using so is
safe.
It should be even save with interrupt handlers and so on since they are
threaded in general.
There is this new bio_in_atomic() this looks a bit odd to detect softirq
context as calimed in the comment. Anyway, on PREEMPT_RT
rcu_preempt_depth() will work as intended. The preemptible() shouldn't
get false because softirq handling is not recorded in preempt-counter,
interrupts are forced-threaded so you should never be in hardirq
context and things like spin_lock_irq() don't disable interrupts. So
unless you do local_irq_save(), preempt_disable() you should remain
preemptible (even in softirq). This might or might not do what you want.

> > Q: "Does creating this workqueue with WQ_MEM_RECLAIM break the local_lock_irq()
> > protection in bio_complete_work_fn()?
> > When a workqueue has WQ_MEM_RECLAIM, it spawns a global rescuer thread that
> > can execute per-CPU work items during worker pool congestion. This rescuer
> > thread executes unbound, meaning it could run on CPU B while processing
> > CPU A's work item.
> > Since local_lock operates strictly on the currently executing CPU, the
> > rescuer thread on CPU B would acquire CPU B's lock, while popping elements
> > from CPU A's list (derived via container_of()).
> > If an interrupt on CPU A concurrently calls __bio_complete_in_task(),
> > it will acquire CPU A's lock and modify the same list without mutual
> > exclusion, potentially causing list corruption."
> > 
> > A: The rescuer should run on the same CPU, not unbound, so this is not an
> > issue.
> 
> This is another area where the PREEMPT_RT/scheduler folks might be able
> to help.

Not sure what the question is. WQ_MEM_RECLAIM is one thing WQ_UNBOUND/
WQ_PERCPU another.

bio_complete_wq is WQ_MEM_RECLAIM | WQ_PERCPU. So it will run on the
requested CPU. The container_of() and local_local() looks like it will
access the same thing but having a WARN_ON() if they don't would be a
blessing. Or just use this_cpu in the worker FN to avoid all this.

The need_resched() check in bio_complete_work_fn() is bit odd. So if
need_resched() is true then you want to leave (and you care !PREEMPT
kernels). On PREEMPT_LAZY you could just continue as there would be
preemption sooner or later.
The bio_list_empty() check below is futile. If it is empty then you
leave doing nothing (so you could just leave without the check).
If there is an item, then the enqueue "thread" should have invoked
mod_delayed_work_on(, 1) claiming the work. That means the
mod_delayed_work_on(, 0) in this function should do nothing because the
work is already claimed (so you could just leave skipping the extra
work).

Sebastian
