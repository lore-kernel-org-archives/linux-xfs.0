Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456073451C8;
	Mon, 20 Apr 2026 23:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776729588; cv=none; b=IFtIjH9FB2YvZMybkiMpPuiCSrwLmMaxwwrDITT9mfgXOr0TViwcUJU26EbrOnmADaqC8NIS1xs3HZD7VG9IUzWJqeGAUjl9OcLVkIyV+NaJ+OVvmvxN2t5URJeAQq2Fo/hAjAgRMyH3feF1qSzpL9UdURn/YD4PwBbXphkb0qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776729588; c=relaxed/simple;
	bh=MMIK8ekJu08qDIh4FXjwAkAb5gYATo0TZerNr1wZ41Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewdG4XjLH/87GqDqAwFcVccSGBzrhyEa0iMmqafPAtw/YO4YSd+rTGnpb/7/JUOHVinGjH6nTMX9bBinKbEkIC4jQZPcruUHt0oRukeaRJ3jLTEUoObpZAbVStLv1BovjAhTNE4/SFOZEUXHRWFswkD6gNNK6Z0vroDl/TpRRjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKRq7WL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKRq7WL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A904FC19425;
	Mon, 20 Apr 2026 23:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776729588;
	bh=MMIK8ekJu08qDIh4FXjwAkAb5gYATo0TZerNr1wZ41Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eKRq7WL6E2lHWHXTDDFXRJHQUpYIfYpHwv9urqmsWJllcxQVz0Mj8kAenpKZlE60Z
	 m53+Hsf7domFWiIN9JrHk9eu7P849uctSkbOPqhI/D9M8aV/kh/oegnJoSdwq4DLD/
	 Y7uWy+wrZ4SF6DJ0gTyFdIJSZ8afJ9f4FCOrKCB2TC+rB14SAhIhu3suotjANQEokk
	 c5rh+lVatIXlrOcnQLLw4775gr0CLRjzqZrexkxsnRJlSAgjQOgIWj0HQVupGkino3
	 lWge1tbjjR+ZU50HwTrVVzxqWSts5s44aha7ifq7tUczGgpLESA+jXT6NxNZ3I5Uye
	 KPJm0lDLMxukQ==
Date: Tue, 21 Apr 2026 09:59:37 +1000
From: Dave Chinner <dgc@kernel.org>
To: changfengnan <changfengnan@bytedance.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Fengnan Chang <fengnanchang@gmail.com>, brauner@kernel.org,
	djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	lidiangang@bytedance.com
Subject: Re: [RFC PATCH] iomap: add fast read path for small direct I/O
Message-ID: <aea96YRt2aHJsM96@dread>
References: <20260414122647.15686-1-changfengnan@bytedance.com>
 <ad_h0JMX2Jo-QODG@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.bd12b07f.c444.4fe0.8460.b6fed4af7332@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.bd12b07f.c444.4fe0.8460.b6fed4af7332@bytedance.com>

On Thu, Apr 16, 2026 at 11:22:08AM +0800, changfengnan wrote:
> This is test 4k randread with QD 512 in io_uring poll mode. 
> If you use fio, almost like this, but ./t/io_uring  can get higher IOPS.
> fio \
>   --name=io_uring_test \
>   --ioengine=io_uring \
>   --filename=/mnt/testfile \
>   --direct=1 \
>   --rw=randread \
>   --bs=4096 \
>   --iodepth=512 \
>   --iodepth_batch_submit=32 \
>   --iodepth_batch_complete_min=32 \
>   --hipri=1 \
>   --fixedbufs=1 \
>   --registerfiles=1 \
>   --nonvectored=1 \
>   --sqthread_poll=1

Ok, given the way fio works, the iodepth batching will result in in
the code submitting repeated batches of 32 read Io submissions in a
single 'syscall'.

If you change the size of this batch, how does it change the
performance of both vanilla and patched IO paths? i.e. does this
optimisation provide a benefit over a range of IO submission
patterns, or is it only evident when the CPU is running a IO-uring
microbenchmark and userspace is doing no real work on the IO buffers
being submitted?

Also, 'fixedbufs=1' leads me to beleive that this is using the same
set of buffer memory for all IOs, and hence we've probably got a
cache-hot data set here. Hence: is userspace reading the buffers at
IO completion (i.e. emulating the application actually consuming the
data that is being read from the disk), or are they remaining
untouched by userspace and immediately reused for the next IO
submission batch?

> > > Profiling the ext4 workload reveals that a significant portion of CPU
> > > time is spent on memory allocation and the iomap state machine
> > > iteration:
> > >   5.33%  [kernel]  [k] __iomap_dio_rw
> > >   3.26%  [kernel]  [k] iomap_iter
> > >   2.37%  [kernel]  [k] iomap_dio_bio_iter
> > >   2.35%  [kernel]  [k] kfree
> > >   1.33%  [kernel]  [k] iomap_dio_complete
> > 
> > Hmm read is usually under a shared lock for inode as well as extent
> > lookup so we should ideally not be blocking too much there. Can you
> > share a bit more detailed perf report. I'd be interested to see where
> > in iomap_iter() are you seeing the regression?
> Are there enough images of the flame diagram? I’ve attached them.
> ext4_poll_7.svg is without this patch, iomap_fast.svg is with this patch.

I've had a look at them, and the biggest change in CPU usage is that
bio_alloc_bioset() disappears from the graph. In the vanilla kernel,
that accounts for 6.05% of the cpu samples.

Let's put this in a table:

function		vanilla		patched		saved
----------		-------		-------		-----
ext4_file_read_iter	54.75		46.85		-7.90
iomap_dio_rw		49.21		40.69		-8.52
----
bio_alloc_bioset	 6.05		1.77		-4.28
iomap_dio_bio_iter	25.44
iomap_iter		15.02
iomap_dio_fast_read_async		39.82

(subtotals)		46.51		41.59		-4.99
----
bio_alloc_bioset	 6.05		1.77		-4.28
bio_init		 4.52		0.00		-4.52

More than 50% of the difference in CPU usage between the two code
paths is entirely from bio_init() overhead.

That makes no sense to me. The fast path still requires bios to be
allocated and have bio_init() called on them, and we are doing many
more of those calls every second. Why is this overhead not showing
up in the fast path profile -at all-?

> > > I attempted several incremental optimizations in the __iomap_dio_rw()
> > > path to close the gap:
> > > 1. Allocating the `bio` and `struct iomap_dio` together to avoid a
> > >    separate kmalloc. However, because `struct iomap_dio` is relatively
> > >    large and the main path is complex, this yielded almost no
> > >    performance improvement.

Yet this is exactly what you do in the fast path. Why did it not
provide any improvement for the existing code when it is an implied
beneficial optimisation for the new fast path?

I'm clearly missing something here. I'm trying to work out why the
profiles show what they do, but there's differences between them
that do make obvious sense to me.

It would also be useful to have XFS profiles, because it has a
larger CPU cache footprint than ext4. If what the profiles are
showing is a result of CPU cache residency artifacts, then we'll see
different profile (and, potentially, performance) artifacts with
XFS...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
