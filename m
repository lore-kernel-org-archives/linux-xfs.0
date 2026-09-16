Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F4C4BA1D1
	for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2026 22:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789597457; cv=none; b=L/EEw5U4z1+R83c4uGJW6FCZFadojz8Vm2+xmOAUnt7Tot9QsicAkb/0UqIXmcjL09CGru7Ojbz31joQ6hUyZ6coYhWgc5q+ztJqEqxgbvqc+O/VyTwAYM+MAs4gwUHp/iCwgo+KS0ZFM3JGq0PrCDaoeyBCyODJbJp53YRxedQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789597457; c=relaxed/simple;
	bh=whx8M7kTsA5m7rCTPZZhp7d/pmffM9vGgr0qbKNnPXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZnxYEa7H+WlFSdeytNw3FTgKIuwtqgFxdAk3hT7f05qI6E1VicV2AEw07H6u0ZHVJ0VRMASLq4qaUhEDtAlRxzGKkGctxRfy1x54eZ8aCsH+OZQD9E4GWiVDg/CnVskkdW1Ny833Nw/Jff/kE+WqN+GodFtnzDmJReB+GfMPDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IJzu8e9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IJzu8e9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB81E1F000FF;
	Wed, 16 Sep 2026 22:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789597447;
	bh=Ktv9a5vygZTw+OpWV1HQGqzPZagFxltJ2w3GIHgH+Lo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IJzu8e9XH3d4yag2bNfPNiJziRO1c2ivOdkX6LGE0RRYx+fzsI+jWhDnhDblnfrHy
	 InWrR7rr1s5cYjcUVBNVBGJweU58y5CdeJ4aFTzKpmpSh0caRy131pQuNKU//9gyWQ
	 mbjkJbg2dNstYUW26IGwjiulonCfji7g2IfBRr15ZOJaqemS6R6BUMnm6UjeaGRQE1
	 y1EHIGn8+WdiWdFspXd8vDCq64ui5oUW0wMkpOaH+s1cEgOepySvfdissTafaPRarB
	 re4w+SFCQHc3EG2FrcZOYY/nUWs0oUQ8HYhEoNI0osWDHF64ajKWFp9jDYKs2EAJdv
	 ceh5+qUBO8Oag==
Date: Thu, 17 Sep 2026 08:23:58 +1000
From: Dave Chinner <dgc@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: John Garry <john.garry@linux.dev>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <aqsW_iNwYAjYldVf@dread>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <98190f62-ccc3-49df-934d-f168e293c485@linux.dev>
 <aqkv-2opTlWD6bzU@shinmob>
 <ed224f94-f605-4be0-8a0a-0b3d481e46ae@linux.dev>
 <20260915145046.GC2705364@frogsfrogsfrogs>
 <db4ab609-af16-4c5d-aa98-c0655625a2df@linux.dev>
 <9bf23063-e6e5-4595-8ff9-27383c99e5a6@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9bf23063-e6e5-4595-8ff9-27383c99e5a6@oracle.com>

On Wed, Sep 16, 2026 at 11:23:16AM +0100, John Garry wrote:
> On 15/09/2026 16:41, John Garry wrote:
> > On 9/15/26 15:50, Darrick J. Wong wrote:
> > > > thanks
> > > > 
> > > > About the kernel code, I am wondering if using IOMAP_DIO_FORCE_WAIT for
> > > > CoW-based atomics could help avoid this issue as we seem to be
> > > > bogged down
> > > > in lock contention.
> > > Which lock is being contended, anyway?  It looks like the ILOCK?
> > 
> > Yeah, I think so Re. ilock. I had some perf data illustrating this from
> > last year, which I can't seem to find, so I will re-generate it.
> 
> Here is perf call graph snippet when running fio with 72x threads issuing
> 4KB atomic writes on 1MB file:
> 
> --50.46%--xfs_file_dio_write_atomic
> |
> |--37.19%--iomap_dio_rw
> |          |
> |      --37.14%--__iomap_dio_rw
> |           |
> |       --36.50%--iomap_iter
> |            |
> |             --36.49%--xfs_atomic_write_cow_iomap_next
> |                  |
> |                  |--27.34%--xfs_ilock
> |                  |          |
> |                  |      --27.34%--down_write
> |                  |           |
> |                  |       --27.28%--rwsem_down_write_slowpath
> |                  |            |
> |                  |            |--24.65%--osq_lock
> |                  |            |
> |                  |             --2.35%--rwsem_spin_on_owner
> |                  |
> |                  |--7.62%--xfs_trans_alloc_inode
> |                  |          |
> |                  |      --7.59%--xfs_ilock

Where's the other half of the lock contention?

If this is all there is, it's because of concurrent submission of
serialising IO, and xfs_atomic_write_cow_iomap_begin() is the first
place in the IO submission path that we hit a serialising lock. That
indicates a problem with high level IO serialisation, not a problem
with the ILOCK.

> Notice how much time we spend getting that ilock.
> 
> We could try something like this:
> 
> ----8<------
> 
> [PATCH] xfs: serialize CoW-based atomic writes
> 
> We have had reports of system hangs when testing Cow-based atomic writes
> for large block sizes.
> 
> Analysis has shown large contention on the the per-inode ilock,
> superficially in creating the mapping in
> xfs_atomic_write_cow_iomap_begin().
> 
> Serialize atomic writes to reduce this contention. In some cases this may
> reduce performance, but high performance has not been a requirement so far
> for CoW-based atomic writes.
> 
> Signed-off-by: John Garry <john.garry@linux.dev>
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index d8202da15aca..ff48757cf0f0 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -819,10 +819,12 @@ xfs_file_dio_write_atomic(
>  	 * HW offload should be faster, so try that first if it is already
>  	 * known that the write length is not too large.
>  	 */
> -	if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
> +	if (ocount > xfs_inode_buftarg(ip)->bt_awu_max) {
>  		dops = &xfs_atomic_write_cow_iomap_ops;
> -	else
> +		dio_flags |= IOMAP_DIO_FORCE_WAIT;
> +	} else {
>  		dops = &xfs_direct_write_iomap_ops;
> +	}
> 
>  retry:
>  	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
> @@ -840,6 +842,8 @@ xfs_file_dio_write_atomic(
>  	}
> 
>  	trace_xfs_file_direct_write(iocb, from);
> +	if (dio_flags & IOMAP_DIO_FORCE_WAIT)
> +		inode_dio_wait(VFS_I(ip));

Based on my comment above, this seems like the wrong approach to me.

We serialise concurrent DIO write submission when necessary by
taking the IOLOCK_EXCL instead of IOLOCK_SHARED (e.g. EOF
extension). inode_dio_wait() waits for completion of all DIO (read
and write), but we don't need to wait for completions if all we need
to do is serialise IO submission.

Hence if we know we are going to do a software COW for the write, we
should take IOLOCK_EXCL to serialise submission up high. Waiting
until we are deep into the IO path and serialising on the 
internal metadata ILOCK is much, much harder to do efficiently and
correctly.

i.e. we need to take the ILOCK vs transaction reservation vs unbound
user-controlled concurrency deadlock problem out of
the equation. Using the IOLOCK achieves this because IO submission
blocks on the IOLOCK rather than on the ILOCK whilst holding a
transaction reservation.

> I also notice that in xfs_atomic_write_cow_iomap_next() we drop the ilock
> for calling xfs_trans_alloc_inode() (which immediately grabs the same lock).
> It would seem that could be improved.

Doubt it - holding the ILOCK across transaction reservation
guarantees journal space deadlocks will occur.  That's why the
suboptimal pattern of 'lock - check - unlock - trans_alloc - lock -
check' exists throughout XFS inode modification paths.

FWIW, that's one of the anit-patterns that the patchset I posted
recently begins to address:

https://lore.kernel.org/linux-xfs/20260819001442.1451892-1-dgc@kernel.org/

It creates consistently correct patterns in the IO path by changes all the
individual alloc-lock-check-mod-commit-unlock loops to an "atomic"
alloc-lock, check-mod-roll loop, commit-unlock pattern.

IOWs, multi-part extent modifications are all done under a single
lock/unlock pair, and so appear atomic to all other extent map and
modification operations. This makes many of the nasty IO corner
cases that lead to sub-optimal behaviour (like data corruption or
lock contention in COW workloads due to continual bouncing of the
ILOCK between submission and completion contexts) largely go away...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
