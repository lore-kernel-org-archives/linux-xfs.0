Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F126D2D0C62;
	Mon, 25 May 2026 05:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779686676; cv=none; b=VvnY59T3NNjahaUX7NRmX6/Mr70kHTZj9eWs6O10j3BkxS0+vedOFiOFHl5oM7Li5HrZ/YD2y/6jX/4zXiVbVuM5nj0K8EXoU1kB/mQExEgsrqoDH1CXSJWdCNwGyt/wPsLm8+JYDPaosQp0oemVlsGyWDoalanTZhMOLd5iJBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779686676; c=relaxed/simple;
	bh=GIUseVFs/C0ymsqGSmX5U+3oK8o0nMX1MIGBODuGnM8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=SnrCKCNwMq12nsktH0fD50b8gdcZhmoaYPWfYHq+R1RpmRohJ9f73fqoPrm9fOyvTOR/H5h7O+o/nn7kBeLN+D7CY0mwb+lAK+RO2g5el1T8oqEroKP95CsAqFfg3NZFKybx7Wh2CX4XdCyxPFJ4L3tmN0iy5i8xw7BLjsBLjWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Rt95io/l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rt95io/l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
	:Content-ID:Content-Description:References;
	bh=F+qcx171PO0iY44USb9zp7y86yRvqPfz1FP7DjlNcFg=; b=Rt95io/lcfqcGRpo6czeBwHio9
	pVjQgDqUXSWgaqWn03gbxnKW5IUsmly2MGIC/fJ4G7eulQgYIaBn1xTPRq+W1IjFrgWC7pY+mLsQN
	4Ub3I59Ib67qY30TB1t+q9Rx2D2t9VQTwmz/y6kwJP2aGmlMk4s/aKbESqKYzAM9bDSZO5+8vg6m5
	RKD6guac98ljA4y9c84c5BCt7TTgVEDAY1+F/r1vvoteXW9m5F6qIYTD+/d35A05w4CVQL/DYGMTR
	IRXDvPvHQtfZbcgHko93BD7Gp7NXBY/6Yf0JIFdW/3r/YPPp3l0UlRV4LaPz8v3E9BQFfMZn7aKDC
	JE+JaPEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRNni-0000000GJk7-316n;
	Mon, 25 May 2026 05:24:30 +0000
Date: Sun, 24 May 2026 22:24:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <ahPdDtu3vXfNpb__@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea6fc01f-5cb7-4a04-9f92-bbd2791fea51@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

[adding the PREEMPT-RT maintainers and list for one and a half questions
for them a bit below]

On Fri, May 22, 2026 at 07:09:59PM -0400, Tal Zussman wrote:
> > +		while ((bio = bio_list_pop(&list)))
> > +			bio->bi_end_io(bio);
> 
> Q: "Does this code handle bios that do not have a completion callback?
> If a bio is submitted with the BIO_COMPLETE_IN_TASK flag but has a NULL
> bi_end_io pointer (like some flush or discard bios), executing
> bio->bi_end_io(bio) directly will cause a NULL pointer dereference.
> The synchronous completion path in bio_endio() checks if bio->bi_end_io is
> non-NULL before calling it. Should a similar check be added here?"
> 
> A: Every bio that reaches this point should have bi_end_io set. There's no
> point in deferring a bio without a completion handler.

Yes.  The only bios without bi_end_io that can end up in bio_endio
are those attached to passthrough requests, and deferring them of
course doesn't make sense.

> Q: "Could this loop also monopolize the CPU and cause latency spikes?
> Because the work uses a 1-jiffie delay, tens of thousands of bios might
> accumulate under heavy I/O load. Processing the entire batch sequentially
> without yielding or calling cond_resched() inside the inner loop could
> lead to scheduler latency or watchdog warnings on non-preemptible kernels."
> 
> A: With PREEMPT_LAZY as the default, the worker is preemptible, as per 
> Hillf and Christoph, so this is unnecessary.

Yes.  Sashiko tends to spew this a lot, which is odd as there were clear
recommendations to only do this absolutely if needed even before
PREEMPT_LAZY.

> > +
> > +	local_lock_irqsave(&bio_complete_batch.lock, flags);
> 
> Q: "Is it safe to use local_lock_irqsave() here when called from an atomic
> context?
> On CONFIG_PREEMPT_RT kernels, local_lock_t maps to a per-CPU spinlock_t,
> which is a sleepable rt_mutex. Since __bio_complete_in_task() is specifically
> called when bio_in_atomic() is true (which includes hardware interrupts or
> execution under a raw_spinlock_t), attempting to acquire a sleepable lock
> here would trigger an "Invalid wait context" lockdep warning.
> Would a lockless list (llist) be more appropriate here to avoid sleeping
> in atomic contexts?"
> 
> A: This seems legit, but I'm not super familiar with PREEMPT_RT. I don't want
> to switch to raw_spinlock_t, as it seems like that would add unnecessary
> overhead on non-PREEMPT_RT kernels. I think switching to use local_irq_save()
> (as is done for the per-CPU bio allocation cache) should work.

Adding the PREEMPT_RT maintainers for this as it is above my pay grade.

> Q: "Does creating this workqueue with WQ_MEM_RECLAIM break the local_lock_irq()
> protection in bio_complete_work_fn()?
> When a workqueue has WQ_MEM_RECLAIM, it spawns a global rescuer thread that
> can execute per-CPU work items during worker pool congestion. This rescuer
> thread executes unbound, meaning it could run on CPU B while processing
> CPU A's work item.
> Since local_lock operates strictly on the currently executing CPU, the
> rescuer thread on CPU B would acquire CPU B's lock, while popping elements
> from CPU A's list (derived via container_of()).
> If an interrupt on CPU A concurrently calls __bio_complete_in_task(),
> it will acquire CPU A's lock and modify the same list without mutual
> exclusion, potentially causing list corruption."
> 
> A: The rescuer should run on the same CPU, not unbound, so this is not an
> issue.

This is another area where the PREEMPT_RT/scheduler folks might be able
to help.

> static inline bool bio_complete_in_task(struct bio *bio)
> {
> 	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK))
> 		return false;
> 	if (!bio_in_atomic())
> 		return false;
> 	bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> 	__bio_complete_in_task(bio);
> 	return true;
> }
> 
> We can use the BIO_COMPLETE_IN_TASK flag to indicate that it's already
> been deferred to the workqueue as is safe to run.

Would be nice to avoid this, but yes.

