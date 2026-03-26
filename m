Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC8039281E;
	Thu, 26 Mar 2026 03:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774495093; cv=none; b=ODKaMQ69dQFbtrGoWtLhVMsmx2yKCaIg8VgOQJsTEtd6oS/mZhTGRXvOzHnC/xfrs6sTy+EcrdKDjrA/FLuIJnu+DANor/HUt88ehaWczlSt8aNSZn+c26fFuV/5jb34KL5Hj1Rq9/GG7wo/vuq0IvQFkDcqp4LZ9qwxXccL+xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774495093; c=relaxed/simple;
	bh=WB1dI10jKBmYn3rDn1h3wkonawXKDbWE18p8jVvczVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IbNwlUZ6fHru/kt7Qb4KofqCCnIOmpDWLqfTxl7LsQbhRkQFRiGGiQfVgfeG0W47kVw34jWm7Szjt7uilNkK2VdJh2rJ+4giMnogmAbSE3PFH0LNs6bX7BlcUwDSOfMATQramJItim1QNLH7W+YH64ODeOhtm/mezVUzlCzQpjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsdMxFTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsdMxFTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80347C4CEF7;
	Thu, 26 Mar 2026 03:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774495093;
	bh=WB1dI10jKBmYn3rDn1h3wkonawXKDbWE18p8jVvczVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JsdMxFTuyR2lT4rcDXcNZW9FLxM7pHrU6gBo1CtKgQJvtK1s9rnz7cqTOQZ9f1Zt/
	 12kcNrKOSMaeY9nz3X3YpCOuPSQw9BhaFklX65OxtQtbMRsAgZrgMfSn261MgkUcfD
	 06eztHg4egcVcSbjJW6KW7wHF0oWkEDZnhP1aZAIIywrYzCB/73xwbcVbtzV767nl5
	 hp2eUodcSUNk5RQloSsvev7zGqkOHFnYvddGvm5i5eqyaR+O84biq0Tv2B0eO22QSo
	 nD5JdU7vsNnrs1L9T2wkjXozBAiFIJGNxc4DE07NrG6EHd5r69iwU+BeqCCkz2bVHZ
	 cReUmAvGwwgGw==
Date: Thu, 26 Mar 2026 14:18:06 +1100
From: Dave Chinner <dgc@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Message-ID: <acSlbnQ23x224IGx@dread>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
 <8f554173-4864-46fc-85e0-0a7f3ca70210@acm.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f554173-4864-46fc-85e0-0a7f3ca70210@acm.org>

On Wed, Mar 25, 2026 at 02:03:40PM -0700, Bart Van Assche wrote:
> On 3/25/26 11:43 AM, Tal Zussman wrote:
> > +	schedule_work_on(smp_processor_id(), &batch->work);
> 
> Since schedule_work_on() queues work on system_percpu_wq the above call
> has the same effect as schedule_work(&batch->work), isn't it?

No. Two words: Task preemption.

And in saying this, I realise the originally proposed code is dodgy.
It might work look ok because the common cases is that interrupt
context processing can't be preempted. However, I don't think that
is true for PREEMPT_RT kernels (IIRC interrupt processing runs as a
task that can be preempted). Also, bio completion can naturally run
from task context because the submitter can hold the last reference
to the bio.

Hence the queueing function can be preempted and scheduled to a
different CPU like so:

lock_lock_irq()
queue on CPU 0
local_lock_irq()
<preempt>
<run on CPU 1>
schedule_work_on(smp_processor_id())

That results in bio completion being queued on CPU 0, but the
processing work is scheduled for CPU 1. Oops.

> From the
> workqueue implementation:
> 
> 	system_percpu_wq = alloc_workqueue("events", WQ_PERCPU, 0);
> 
> [ ... ]
> 	if (req_cpu == WORK_CPU_UNBOUND) {
> 		if (wq->flags & WQ_UNBOUND)
> 			cpu = wq_select_unbound_cpu(raw_smp_processor_id());
> 		else
> 			cpu = raw_smp_processor_id();

Same preemption problem as above.


-Dave.
-- 
Dave Chinner
dgc@kernel.org
