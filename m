Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D3E33F8AD;
	Tue,  6 Oct 2026 05:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791264700; cv=none; b=PGQbweVMNtI7PYHnu5/Cwo97nlUv2d9zt3JkSUq5zU2Wk+lMPtWI0LQeF0Rh1GVXuhHE5KU26g6qDKkWaSeuAMrgXPnEd0RMIhVVg8fv+hN57Phah5aTal0GOl67VbK9IOn5HO5T0+AJ/nYZmMoMNgasSWDlkj/O9bOj9eSaMmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791264700; c=relaxed/simple;
	bh=koaFvjGZpdNqtj+pdwDbj90dDiJYwX4ewBy4L6uyIzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=srCvZ6PrnVDf/2alaQmI+maixKnAcdYZqRs1kHmfOBBjI1w5GQgrMRVFOllf3zv9vrusQjgetNmwmKNJfWsN+GuVPQavx0hzULSM5STFP++YrOtW0LtgxSQN1AVZW+1fbMlAKuRSCNFuCioPijwa+mD7uKNSJOmBnlCDYzyr0ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K+o1h0Nm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K+o1h0Nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D791F00893;
	Tue,  6 Oct 2026 05:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791264698;
	bh=+YlwBv+7J2bX1F2CsKaIlbF9d53qUgGdtN8fBDwlG/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K+o1h0NmKxByBG0IT+inL09EjqnrCwRIdV73yhL8LEbj7/yUTr1+3ds3mnwJ8uMCx
	 0RwOjnDQsT5Li0UH17H0G7Td4k1tKcltFi6jC/MWdMDUyAt+UbvrHFh1VS52wLu2Mr
	 jfvLxhAzcCk7pZHsoaUGD+GpwcURqiJOwD8PdVOXf6TJXb7fOQEWif/mFT3TtAqsd5
	 TxEa4vQbWMDigaHVKiW01FsqlPrYk/9LBP0KjpNnZHyuQNSGb0BUSdPSNvcYd5MBzA
	 V0Px/wPAfsbiE4YuacSU0VWe+se09T0dwPMRpUgwbHD2SWV2+w009rNSHO6ASGXEOB
	 4VtUFSsZGgP3w==
Date: Tue, 6 Oct 2026 16:31:29 +1100
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: support for RT data checksums
Message-ID: <asSHsVAYevL_VzdF@dread>
References: <20260924100032.2733101-1-hch@lst.de>
 <arWpyhFyV3ouYAEx@dread>
 <20260925062710.GA3798@lst.de>
 <armf05yfzhSBUsUh@dread>
 <20260928052436.GA18925@lst.de>
 <arvHFOjF-CD5Vd3g@dread>
 <ary2PpSp1xTgrd3k@dread>
 <20261005135320.GA29829@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005135320.GA29829@lst.de>

On Mon, Oct 05, 2026 at 03:53:20PM +0200, Christoph Hellwig wrote:
> On Wed, Sep 30, 2026 at 05:11:58PM +1000, Dave Chinner wrote:
> > My initial thought was that on disk format structures shouldn't be
> > defined by the limitations of the OS memory allocation, but <shrug>.
> > It kept nagging at me, though.
> 
> Well, it would be nice to be able to design without all the real-life
> constraints around us, wouldn't it?  I'm trying to strike a balance
> between what would be useful (go big) and what is feasible.  If we
> want other values, we can always increase the support range for
> newer kernels and tools.
> 
> > I looked more closely at what XFS_BLI_PREALLOC did to try to
> > understand why it existed.  It triggers a max-sized CIL logvec
> > structure for the buffer object. For a 32kB buffer logged as a
> > single contiguous range, this ends up being about 32kB + a logvec
> > header, plus a log iovec, plus a BLF, plus a couple of ophdrs. So
> > it's about 32kB + 200-250 bytes.
> > 
> > That means the shadow buffer for a csum buffer is always considered
> > a costly allocation by the MM subsystem.
> 
> It ends up using vmalloc exclusively based on tracing for me,
> but that might be different on different systems.

That'll be because the repeated multipage allocations eventually end
up fragmenting memory and so anything over 8-16kB will go straight
to vmalloc.

> > Hence for csum BLI, if a CIL flush happens on a partially filled
> > buffer, a good amount of that shadow buffer will go unused. Then we
> > allocate another (costly) shadow buffer on the next update. If CIL
> > flushes happen frequently enough then we will be repeatedly doing
> > costly allocations for shadow buffers that we don't actually use.
> 
> Yes.  But if we don't do this we realloc for every few blocks
> written, which is a lot more costly.

I'm not sure I understand what you are refering to there. I'm not
talking aobut the 'realloc because logged size grows', I'm talking
aoubt 'realloc because CIL pushes steal the shadow buffer'.

> > Not ideal - I think that means the original "sized for mm fast path"
> > intent is really only valid for the read side of the csum
> > algorithms as implemented by the patchset.
> 
> It is valid for the xfs_buf backing where we actually hit the folio
> allocator.  Which is used both for read and write, but obviously
> most workloads tend to hit reads a lot harder than writes.

Not if the working set fits in cache. A 'read heavy' workload will
often change to 'write heavy' when it fits in cache.....

> > Ok, we have a solution to this problem. I created ordered buffers
> > and one-shot log items to avoid the journalling overhead of static
> > inode buffer initialisation back in 2013. The ICREATE log item is
> > the one-shot log item that records a buffer should be initialised,
> > and the ordered buffer allows the modified buffer to be passed
> > through the journal to metadta writeback without it's contents being
> > logged.
> > 
> > Given that csum updates are a small, known size, non-overlapping
> > one-shot update to a buffer, they fit the same model that
> > ICREAT+ordered implements. Adding a new CSUM log item made up of a
> > format header and varible size csum payload region provides the
> > equivalent of the ICREAT item for journalled inode buffer
> > initialisation.
> 
> I initially looked into intent/done based csums, but we still end
> with an allocation per log operation, and a memcpy both into that
> and into the buffer, while adding a lot of new log items.

I'm not talking about an intent/done based setup - that requires an
intent transaction, then a buffer + done transaction. That's very
different to what I suggested (and what ICREATE implements).

I'm talking about a single one-shot transaction that logs the csums
and that only. The buffer is ordered, so not logged. Single
transaction, generally small in size, never gets relogged, can be
committed asynchronously as long as it is replayed before the file
offset relocation BMBT update in recovery.

The CIL can handle hundreds of thousands of csum objects just fine
(no different to logging hundreds of thousands of inode cores). It
is simpler than intents, too, because they are at checkpoint
completion and never enter the AIL (unlike intents). The only thing
that ends up the AIL is the BLI, and that works like a
INODE_ALLOC_BUF in that it remains at the initial LSN in the AIL
even when it gets updated. i.e. once it is in the AIL, it never gets
moved forward, but it continues to aggregate changes until it gets
written back with the LSN of the latest committed change stamped
into it so recovery does the right thing with it.

So, yeah, I'm definitely not suggesting using intents...

> One thing I played with for a while until I realized that the
> simple buf item actually provides good enough performance is
> special xfs_log_vec that is not included in the main log vec /
> shadow allocation but points to external memory.

That's problematic. The reason delayed logging works is that it
broke the dependency between external memory that log items pointed
at needing to be locked and stable until the external memory was
copied into the iclogs. The disconnection of the objects passed to
xfs_trans_commit() vs xlog_write() whilst keeping the logged data
stable is what allows the CIL to work

The shadow buffer does that decoupling, and it means that there is
no requirement for the original logged item to remain stable, or
even remain in existence whilst the CIL holds onto the infomration
that needs to be journalled. At checkpoint completion, shadow buffer
is also used to do a reverse lookup to the log item to enable
insertion into the AIL.  IOWs, log items are not tracked across
journal checkpoint IO - shadow buffers are, and if you get rid of
shadow buffers for a log item, we have to special case that
everywhere in the LV/checkpoint handling. I dont' think that's a good
idea.

The shadow buffer also avoids the need for the CIL to lock external
objects to copy the data out of them. The lock order is lock external
object -> commit -> read-lock checkpoint - format into CIL -> unlock.
When pushing, the order is write-lock checkpoint -> lock iclog ->
format from CIL into iclog -> unlock iclog -> unlock chkpt. We also
can call xfs_log_force() whilst holding inode locks, putting iclog
locks inside high level object locks.

Hence we really can't lock external objects from the checkpoint side
because of the lock inversion problems they entail. So object
stability is a problem, and ....

> This obviously
> only works for fixed size non-overlapping regions, but then isn't
> too bad. 

"trust me, bro!" is not my idea of maintainable, landmine free
design, especially now with LLMs being able to poke holes in complex
zero-copy/object sharing schemes and exploit them in less than
obvious ways...

> This is the prep work for it, which I recently
> refreshed:
> 
> https://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xlog-ophdr

Not a fan of rewriting xlog_write() -again-, this time to bring back
all the bad old patterns of managing ophdr space itself. We got rid of
that method of managing ophdrs because of all the special accounting
it needs to sprinkle through the logic to get log space consumption
correct. It was complex, difficult to reason about, and a source of
bugs.

Fixing these problems was the one of the main reasons we moved all
the ophdr management and accounting out into the CIL and logvecs to
begin with. Hence I'm not a great fan of going back to the old
way, whatever the reason.

> These can work with the buf_item on-disk format, so I'd rather not
> prematurely optimize it, as the prototype shows that I can go to
> that any time I want.  And eventually I think I'd want to go
> there, as it drastically reduces the memory usage if only the
> format header and two ophrs need to be allocated ontop of the
> backing buffer.  But there's plenty more important things on the
> plate for now.

I'd much prefer we use a method we know works and scales rahter than
create something new that requires punching through abstractions,
can't guarantee stability or lifetime of external objects, and isn't
demonstrated to be necessary to meet performance requirements.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
