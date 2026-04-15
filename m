Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430773016F7;
	Wed, 15 Apr 2026 05:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776232558; cv=none; b=JNImpd4QsUriyziWL5rLZkRHp6u2QKZa7SRWz+k6m3hfdfD+ev988JiniiYOKdUzQYqOOuq4D8kHqSgTv6udgUxVM2ucjulfXXPDv7tmssBbRIqspW1Z84D9cgptCz/svXLaLSeSfx1rmc7Sp340/138eMg81EXOcQeSas69ii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776232558; c=relaxed/simple;
	bh=jJ06Qr9PZTdYxGHH4AdFUydk+z3O9xo1Jo8slIVdB5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dARRt3jOx32U4FctikeUYCeIvuBNrOi0kAxJH2G1F0DyEfU4Q2kRsc947pgj26nseYF4x49p/EzOSUrbMstnC1MO7zYiWmidmXr17QTY1IzVhGR3FeOPbEWWocstHTuLquZXvR/XRDvDSuBDFDpxmsmNEkdgeOPbbq7zchvER5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A55CA68BFE; Wed, 15 Apr 2026 07:55:52 +0200 (CEST)
Date: Wed, 15 Apr 2026 07:55:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@lst.de>,
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
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <20260415055552.GD26893@lst.de>
References: <20260409160243.1008358-1-hch@lst.de> <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread> <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com> <ad2RKNo2FGhpzJQp@dread> <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 14, 2026 at 10:23:13AM +0800, Gao Xiang wrote:
> All softirq IO completion already works like this although
> softirq tasks are not strictly called "RT tasks" (i.e. a non-RT
> task issues the IO, and the softirq IO completion will interrupt
> all ongoing tasks).
>
> Basically what we want is to get a non-atomic context instead of
> using the current softirq context for read post-processing and
> switch to the task context immediately as you said, because:
>
>  - Our post-processing needs to work in task contexts since
>    advanced features like compression deduplication need it;
>
>  - Even regardless of our specific requirement needing task
>    contexts, using a dedicated task context for read
>    post-processing is much better than run in the original
>    softirq context:
>
>    - Algorithmic work could take extra time (especially slow
>      LZMA algorithm could take milliseconds on low devices
>      (however, we need a common workflow for all algorithms,
>      including fast algorithms like lz4) and verify work for
>      example); and long processing time will interfere with
>      other remaining softirq tasks like sound-playback
>      / network softirqs;
>
>    - If it is then deferred to softirqd, it just makes this
>      latency issue _worse_.

Yes, and the same applies to a lot of other things.  A very similar
algorithmic issue is the checksum validation, be that T10-PI or
file system native checksums.  We don't want to run them from
soft/hardirq context obviously, but we really need them to preempt
other work on the cpu, and avoid scheduling latency.  The case
that started this is a bit different - folio invalidation mostly
needs user context to take sleeping locks, but those are usually
uncontented.  Again, getting this work done ASAP as readers
are synchronously waiting is important.

>> Tejun asked Sandeep if setting the workqueue thread priority to
>> -19 through sysfs (i.e. making them higher priority than normal
>> kernel threads) had the same effect on latency as using a dedicated
>> per-cpu RT task thread. THere was no followup.
>
> I think the issue is that people are not already working on the
> same topic:
>
>  - Unlike large subsystems like XFS, people don't already work on
>    EROFS unless they have new requirements or urgent production
>    issues;
>
>  - The original latency issue was already considered as "done" in
>    2023, and I'm not sure if Sandeep could have the bandwidth to
>    pause his current work and test more setups according to this
>    ongoing discussion in 2026.

Which unfortunately might explain the sad state of Android.  You
really need dedicated people around and help to improve core
infrastructure, instead of adding random Kconfig choices.

