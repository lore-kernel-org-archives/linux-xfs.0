Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BFB1632DD
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 02:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791945260; cv=none; b=nYohVishz8ZEDJxzbWmOCHzFMe7Qr3DcMMKsuw202L4jjRokr131yvqXKes301hU51ynxy2cyYvl3I/9Hjm3DyW5OyGOEvgmJoGlIH+Uuo3WSzFEkYJlEnrj5StnHJO4oZWfqjb8ESf/lX36D8QJGuZcbCGuItplsyzgtgZos1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791945260; c=relaxed/simple;
	bh=ifEgu9UNTCCGrtlL+O/SOgy2V4Ln+BzZkqHRWWonLZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Viyu9QZCZiZK3mlWtXH++xQ9g1FeTuaJJVYinKbTE87SDBIb/z3SSwga3UZryEfs8DR+j/SPZg3vT1RiV5OKf+id7qHi1b5Zmzw/uG5t8e19HPgPBNWZDJ9q3GmKZUjQt5jkzjhsN20m8ibw49ocaq5dAzKIQXC3PagoIFdLfcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ha4jwXtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ha4jwXtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B0A1F000FF;
	Wed, 14 Oct 2026 02:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791945258;
	bh=iRgWKrzoVfdQzkvxfBQKO8bQRrSkPEuB567/aWWj2RE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ha4jwXtlTjddfmQqJEFDGp3nbETk/tf04YWmIrylsf0+xp0zjb7rNCs9if2+eZusr
	 fjTHNkmxsGouqMFbZALR77GLh9m2qfYmLp0gGbuRbFVek5GmYkgVOOddcuZ2/3c269
	 aIQXyEtb/+c28IR1WgW8TfKJACzojwsGcScpRGsdyVzNxWHgM0BGrhO1FCmZo3B2No
	 2gjjhAuiGZEUktJZQHq2JUdgu5qg0Rn2Cy1YX7vDTkdceD7RsP9Df9cwPPX+KcRTnA
	 6E92vlrdYeMB6ijlRXCxxqEA2mAIzeHBT6G5kGSh0Vi+et+Xbwilh+8RloZoJftS3B
	 qftDFaiT4oIeQ==
Date: Wed, 14 Oct 2026 13:34:10 +1100
From: Dave Chinner <dgc@kernel.org>
To: Vitali Lovich <vlovich@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Really bad I/O lock contention between non-overlapping reader
 and writer
Message-ID: <as7qItXRAvIv5OP9@dread>
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
 <as1HVVUXdMlpXQGT@dread>
 <CAF8PYMi5DX0AkzbSTFnCchHnr3QeB-S7J+2FNMCqB8zrtR9ojA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF8PYMi5DX0AkzbSTFnCchHnr3QeB-S7J+2FNMCqB8zrtR9ojA@mail.gmail.com>

On Mon, Oct 12, 2026 at 01:59:53PM -0700, Vitali Lovich wrote:
> On Mon, Oct 12, 2026 at 1:47 PM Dave Chinner <dgc@kernel.org> wrote:
> 
> > On Mon, Oct 12, 2026 at 10:47:56AM -0700, Vitali Lovich wrote:
> > > I think I encountered suboptimal locking behavior with concurrent
> > > readers and writers on a file, which resulted in huge latency spikes
> > > for the reader even though the writers and readers are touching
> > > unrelated ranges within the file. The writer/hole puncher hold an
> > > exclusive lock on the inode while forcing a flush of outstanding
> > > writes to disk which creates huge latency spikes for reads.
> > >
> > > I've observed read's taking >> 500ms even though none of the writes
> > > could be overlapping and traces seem to indicate it's the shared inode
> > > lock contending with the exclusive inode lock that writes / hole
> > > punching is holding. In my real-world test case traces indicated that
> > > the cause might be inode_dio_wait while holding the exclusive inode
> > > lock.
> > >
> > > I've observed this behavior on XFS, EXT4 and BTRFS so it seems like a
> > > general VFS challenge. Generally, Btrfs seems to have less read
> > > latencies created than Ext4 (~2.5x more at the 0-1ms read than EXT4),
> > > which in turn has smaller and fewer tail latencies than XFS  (~2x more
> > > at 0-1ms and extreme is smaller) although all filesystems exhibit the
> > > issue. Starting with the XFS list in case I'm way off base that this
> > > is a problem.
> > >
> > > Attaching a simplified reproduction of what I'm doing with one writer
> > > appending data to the file,
> >
> > The repro is using DIO writes. Speaking for XFS, these need needs
> > exclusive locking to serialise extending the file without causing
> > data corruption or stale data exposure. Once extended, the locking
> > demotes to shared, so the IO itself runs concurrently with reads.
> 
> 
> I’ll confirm if that’s the case but also it seems strange at a conceptual
> level that you’d need to hold the exclusive lock for such a long period of
> time, especially when there’s only a single thread reading and writing
> independent ranges (that’s not what this reproducer is because I didn’t
> want to complicate it with io_uring but it reproduces there too).

Define "long period". extending the file may require IO to be done
to zero allocated extents that the file extension exposes. Even just
the partial block range beyond EOF needs to be guaranteed to hold
zeros -before- the file size is extended.

Truncate up isn't just "write the new size to the in-memory inode";
both IO and transactions can be necessary, and they havbe to be done
atomically w.r.t. the file size extension. Hence, exclusive locking.

> > > Reads
> > > are doing random 4kib I/O in [0, 64MiB), hole punching is punching
> > > 4kib holes in [64MiB, 576Mib] and writing is always appending after
> > > 577MiB of the file.
> >
> > Educate me: what application workload has this IO pattern? Is this a
> > real world problem. i.e. why should we care about this contrived
> > scenario?
> 
> 
> 100% real scenario. This repro is just a contrived minimal example to try
> to reproduce what I’m seeing. The specific idea is to have an LSM database
> store all LSM tables within 1 file instead of separate files per LSM tables
> like RocksDB does.

The fundamental problem with your model is that it assumes that
single file IO and extent manipulation operations scale without
contention or serialisation. That has never been the case, never will
be the case.

Perhaps there's good reasons for RocksDB using a 'many files' model
for it's back end storage, and only now are you learning why they
used that model....

> It works really well for lots of reasons and generally
> works really really well but I’m running into unexpected P99 latency spikes
> in certain workloads and P100 often goes all the way past 1s.

Yup, and as long as you want to use fallocate or truncate/append
operations, there's very little that can be done about it.

> It really
> looks like it’s this exclusive locking even though the application
> guarantees we never read from any data  that’s not been fsync’ed and I only
> punch holes when I know there’s never going to be any more access for that
> range. And btw in my application everything is happening on one thread.

Tell me: how is the filesystem supposed to know what the application
is doing? They aren't omnicent....

> > Also, have you tried to implement highly concurrent range locks that
> > don't have far worse contention on the range lock tracking
> > structures themselves than a simple rwsem? Some of us here have
> > actually tried to do this, and the fact that we still use rwsems
> > should tell you a lot...
> 
> In case I wasn’t clear I don’t think it’s the lock contention that’s the
> problem.

Yes, but what I'm saying is that moving to range locking creates a
per-inode new lock contention problem that doesn't currently exist,
and that it's a far worse performance issue than what we have
now....

> My real workload (not this contrived one) does all I/O from a
> single thread. The problem is purely doing super expensive I/O (or at least
> waiting for it to complete) while holding an exclusive lock preventing
> other stuff from completing. Keeping the range structure synchronized I
> think would be unlikely to show up in practice

So the theory goes. The reality:

https://lore.kernel.org/linux-xfs/20220919230947.GM3600936@dread.disaster.area/

If it were simple, XFS would have had range locking years ago.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
