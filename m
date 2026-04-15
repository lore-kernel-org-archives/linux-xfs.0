Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD6F390205;
	Wed, 15 Apr 2026 06:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776234658; cv=none; b=ngWkPwe8T55nLG7l05VCypAlH+ADtURbNa8md5F2f//q9xoNDt9J4R/nCBqQxKJomLX+RxnjczcFoVHMcyc9pG4b9USbeydHQ6pSHl+17JenJBi75sgIUbbeJsj3K9Osp3uhwQ/dZLf48hMMlFRFgBGS8BpYaouvTOtDLsoW5jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776234658; c=relaxed/simple;
	bh=tMiOBW919soQI8pq4nCFQj0lOFJlXnp3eUD8EkTIm4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTucDUDrAHmHJVIFY2RaWOTeMUWsjLPQuH+7+z4juuFESh3ftaGxYQWK8OP4zvInoC66NDISRNJnDLWJ8i30DyZWjGP3U7PBAodkzKAH7D9rH4U0pMJ8upEqcWODbUPDST9HLalaY4o4uLdP1spbelVEo/iaw0qBGmG3DCkq190=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=VE7mAYeP; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=sGHXEiBr; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="VE7mAYeP";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="sGHXEiBr"
Date: Wed, 15 Apr 2026 08:30:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1776234653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VdAKD36E8rLdN/EhiUpV79Bm4JP9i6LgdGtBCZLwAhI=;
	b=VE7mAYePSJuw8rYF2IEg8Uj5hjEni6px0w3pSuYBi6Zr4//Fs4BFaYhs6s3LLD0zT16FQZ
	+p/SbZIr3b4N3YaRnHlraP39iqn35JLtKphSUWJ6UUmZc/1vJbISKv73yu8bqwBbYRQqt2
	xzA8CzYm5G8MzbwIcTYdCFzt4oPe86BCZDLDCmEGueK109llRwV8U2KYJg24CG4SssKbrG
	ofkl2ebupTRXI7ey9j1UjryAlI1hKsNHDB93aSopTB1+h6fSATl1MDrQcP3YuvPV1mD+5U
	Ux5DD2DWvt4/bFtCDZjEIRNX61X/bfoy68PYrxABvZqiw4fFtZQKJiV/Q3Yoiw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1776234653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VdAKD36E8rLdN/EhiUpV79Bm4JP9i6LgdGtBCZLwAhI=;
	b=sGHXEiBrPEae0nW+Z4/Iz9is3KfRzvNPPszk5NeI4llau3YrME7LKceUTvCHIrpg1GtRK2
	3dTRgU45mNFgUBCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, Dave Chinner <dgc@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Sandeep Dhavale <dhavale@google.com>,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <20260415063051.H3zA99Qh@linutronix.de>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de>
 <adl1iqhldFvJwSw-@dread>
 <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
 <ad2RKNo2FGhpzJQp@dread>
 <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
 <20260415055552.GD26893@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260415055552.GD26893@lst.de>

On 2026-04-15 07:55:52 [+0200], Christoph Hellwig wrote:
> On Tue, Apr 14, 2026 at 10:23:13AM +0800, Gao Xiang wrote:
> > All softirq IO completion already works like this although
> > softirq tasks are not strictly called "RT tasks" (i.e. a non-RT
> > task issues the IO, and the softirq IO completion will interrupt
> > all ongoing tasks).
> >
> > Basically what we want is to get a non-atomic context instead of
> > using the current softirq context for read post-processing and
> > switch to the task context immediately as you said, because:
> >
> >  - Our post-processing needs to work in task contexts since
> >    advanced features like compression deduplication need it;
> >
> >  - Even regardless of our specific requirement needing task
> >    contexts, using a dedicated task context for read
> >    post-processing is much better than run in the original
> >    softirq context:
> >
> >    - Algorithmic work could take extra time (especially slow
> >      LZMA algorithm could take milliseconds on low devices
> >      (however, we need a common workflow for all algorithms,
> >      including fast algorithms like lz4) and verify work for
> >      example); and long processing time will interfere with
> >      other remaining softirq tasks like sound-playback
> >      / network softirqs;
> >
> >    - If it is then deferred to softirqd, it just makes this
> >      latency issue _worse_.
> 
> Yes, and the same applies to a lot of other things.  A very similar
> algorithmic issue is the checksum validation, be that T10-PI or
> file system native checksums.  We don't want to run them from
> soft/hardirq context obviously, but we really need them to preempt
> other work on the cpu, and avoid scheduling latency.  The case
> that started this is a bit different - folio invalidation mostly
> needs user context to take sleeping locks, but those are usually
> uncontented.  Again, getting this work done ASAP as readers
> are synchronously waiting is important.

Not sure why I ended up here but looking at the patch I don't see how is
different to the kworker solution that is removed. Unless you fiddle
with the thread priority in userland.
The get_cpu() + spin_lock usage breaks on PREEMPT_RT.
The NOHZ_FULL camp might not be happy about putting load on isolated
CPUs. I remember there was some effort to avoid those CPUs.

Sebastian
