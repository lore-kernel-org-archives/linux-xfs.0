Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A527314B63
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 03:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791946872; cv=none; b=N5yU+Nt/FU+hTXuygTRhrna1DIJfvWBFUif4cF3F6UgjMTukfonSkFZqkbfwTMldnrhDpIuCuEfqBd5mtSsQTOaZtOPgMvN8RkvHAsFS3N+mdt6cD6UiZP4yr4NscqXL9Cj1sb1vCSHRHRUYkSbHd/EF+c8YXvzjsiwSVd4MO4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791946872; c=relaxed/simple;
	bh=nyDQjOQWBhlbhg2qgTUMe2Lc8SXFVY7Z02epNjmL1vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OGzh+aljxCivaVE2jrV6r1Pu1B1aDVSqUvB5eeJfkqd7CHnpv4qEeEuzWvwExkZjddP1tHQko/81tgAKlF1Jn+7j1jCMWObjM81ycTTwRqbke6rhrKQhvLCtQPp08A6u8s1l9JfnuLxFDKhZLEdGU6UciWa9Y6C9Cu8y6PEm0vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVCvA5Nf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVCvA5Nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6766D1F000FF;
	Wed, 14 Oct 2026 03:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791946871;
	bh=Wnk8nDXe4VsP56xgplRnwj7JpZtFN6zFSTbC6bLpYEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LVCvA5Nf4+7d3E+gFZrh3KLj6Dc3FpNelaKJCAiiKs9iP9F4vTohEVLN4KfWMzZ/l
	 RDfaZkjsc+DJOE8SOg4Oh5uGobae1chvQq/NoJUnsXoKkBR3rbtbjYpHhqc36OGb7h
	 mbb1kHjpik3Y4B9/1rsZQsYB/ycDthee/nmnusPI9VHziIefbnmYuBU3UCLk3xAa9k
	 lu81bQkxPoF7K2kEWnsp7KbO45Q4fLxOichlBSgdO1wf9LEuK5ROzcXDhOavsuLuc+
	 Sp/qV1KZMZnKUX69QlRQu6CHrY867DDgWnQTpRqmyd+LlZn+C8cOcZIssSx/m2AEqw
	 4T19L3oV86CPw==
Date: Wed, 14 Oct 2026 14:01:03 +1100
From: Dave Chinner <dgc@kernel.org>
To: Vitali Lovich <vlovich@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Really bad I/O lock contention between non-overlapping reader
 and writer
Message-ID: <as7wb-bdykxSKenP@dread>
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
 <as1HVVUXdMlpXQGT@dread>
 <CAF8PYMiMZ5uFGsLnms4pNtMHc=TKgzcKvoLtydGXEFS7KM_r5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF8PYMiMZ5uFGsLnms4pNtMHc=TKgzcKvoLtydGXEFS7KM_r5g@mail.gmail.com>

On Tue, Oct 13, 2026 at 04:49:53PM -0700, Vitali Lovich wrote:
> On Mon, Oct 12, 2026 at 1:47 PM Dave Chinner <dgc@kernel.org> wrote:
> >
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
> >
> > Appending DIO writes are basically a fast combined 'truncate up,
> > write' operation, and so has the same initial serialisation
> > constraints as 'truncate up' (i.e. exclusive locking).
> I think that's true if the write continues at the last byte of the
> previous one. If the write leaves a gap for whatever reason (e.g.
> writes are 4kib aligned but we only had 3.5kib of data before the file
> end) the fast-path isn't taken and you do have to wait for a full
> flush because XFS doesn't realize there's nothing overlapping. This
> scenario isn't present in the test case I published but I think it
> acts very similarly to hole punching.

What happens when there are blocked beyond EOF that the file
extension exposes?

> > > a separate writer punching holes in
> > > unrelated ranges,
> >
> > fallocate() is like truncate - it also needs exclusive locking and
> > no IO in flight to avoid a UAF of the data extent being punched out.
> It needs exclusive locking and draining around the range in flight,
> not necessarily the entire i_node.

You don't need to explain how range locking works to me. If you
think that you need to explain basic stuff like this to me, then you
likely haven't understood what I've said.

> > > and an O_DIRECT reader that's reading data.
> >
> > Shared locking only.
> If I wasn't clear, the problem is that the shared lock has a head of
> line blocking behind the exclusive lock that's draining the I/O even
> though userspace knows it's never touching that range.

As I said above: competing shared vs exclusive locking implies head
of line blocking that causes latency issues. You don't need to
explain basic stuff to me.

> > > Reads
> > > are doing random 4kib I/O in [0, 64MiB), hole punching is punching
> > > 4kib holes in [64MiB, 576Mib] and writing is always appending after
> > > 577MiB of the file.
> >
> > Educate me: what application workload has this IO pattern? Is this a
> > real world problem. i.e. why should we care about this contrived
> > scenario?
> I'm trying to implement an LSM database that stores everything in one
> file instead of taking the RocksDB approach of 1 file per SST. One
> file per SST has scaling problems of its own in other ways, but for
> concurrent reads and writes they acquire locks on different inodes
> (file and directory, respectively), which is why RocksDB doesn't have
> the problem highlighted in this test-case - it always reads and writes
> to separate i_nodes with the downside being that it ends up having to
> open an insane amount of files on startup and juggle them if there's
> more than the kernel limit allows.

XFS can handle access to millions of files iat a time efficiently.
It's designed to work with massive data sets and lots of files.
You're having problems because you're trying to optimise everything
into a single file, hence hitting largely unfixable single file
scalability issues.

> > Also, have you tried to implement highly concurrent range locks that
> > don't have far worse contention on the range lock tracking
> > structures themselves than a simple rwsem? Some of us here have
> > actually tried to do this, and the fact that we still use rwsems
> > should tell you a lot...
> 
> I'm not pretending it's an easy problem to solve. I've come up with a
> few approaches and would love your feedback on what's the best path:
> 
> 1. DIO tracking so that the inode keeps track of all outstanding
> DIO's. Rather than the barrier, we scan the list to find if there's
> any conflicts.

Yup, that's a range lock.

> I've prototyped this and it clearly solves the false
> synchronization barrier from this in my database (unrelated writes
> prolonging reads). This has a negative impact on normal workloads so I
> imagine this would be hidden behind an explicit ioctl if acceptable.

No, "optional" locking models are a non-starter. It either works for
everything or it is a non-starter.

> 2. Introduce generational barriers where hole punching / writing past
> the end of the file still waits for DIOs but outside the exclusive
> lock.

The exclusive lock forms an IO submission barrier allowing in-flight
DIOs to drain and hence the extending write/fallocate operation to
start.

Without that submission barrier, how do you prevent incoming DIOs
(read and write within EOF) from preventing the in flight counter
from ever reaching zero?

i.e. a submission barrier is needed to avoid moving unbound
latencies to the extending write/fallocate operations...

> Inside the exclusive lock all it does is register that the range
> that it's doing the operation on and the wait happens outside the
> exclusive lock. Operations that overlap will either wait for all

Now we're back to range tracking....

> outstanding DIO or perhaps satisfy if they can (e.g. a read of an
> fallocate technically could just supply the 0s without waiting for
> DIO).

No, we can't return zeros to userspace until after the fallocate
operation completes successfully. If the operation has not started,
we have to return the data as it currently exists on disk - that is
a fundamental data integrity requirement.

> Is either or both of these a non-starter idea in terms of acceptance
> (assuming I can actually make it safe)?

If you come up with something that works in the general case, and it
scales out to millions of concurrent random 4kB DIO read/write IOPS
on a single file across dozens of processes submitting IO, then I'll
take what you are proposing seriously.

But until I see code that is provably correct with benchmarks that
show IO similar performance to rwsem shared locking, I'll remain
skeptical that this can be done.

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
