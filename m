Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB654457B0
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319597; cv=none; b=QOztcWUbYCkIACgKbYULMP9aQEMO5daallawI3vjHuH6SnHJK/gBcdmo6xHwhtbxTljxRMgZHynIjClZlummWJQrjFwKpIZfe9HQvJv8Xmpb6kvqli9QUNuHpj3udjqFaVF0IAGZ5pXhBzkoUgw/zMexM/B7+xUcjHPD6JsgVJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319597; c=relaxed/simple;
	bh=RDeoIH3434mX9ZZ+Q+fH0m9eCW8YykLD0k/FCSq8NQc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QyxZsCmHcboPU4pywkzkIkcFXGAlBz28iH0KEndvDvDUsr013MtG2mUpX5067H6N7WMe6rnFPB4OOpq86vHrxUJ1G3OD8nDCAKCAgwuusJGfZT+R2NOURrsP72qhPsBngaocYEcC5igpm+eP0lbZD+/AScp1YJRtH+unXza3oJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+lgOUPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+lgOUPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746AC1F000E9;
	Wed, 29 Jul 2026 10:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319595;
	bh=8zgv5HHWjDN6kWmARgDiKm6KlNIcN8gAgQtDbVH1WPM=;
	h=From:To:Cc:Subject:Date;
	b=k+lgOUPsczImwSnyzCy/Jjp0rWt3uhHjhw2431cfk5JS2nkscl1HO0fhoBgrNwM/n
	 PR24MWfWdtH/exvg3qbUSn9ZPxUT9M9pBR6HTlXj2TjNQVBZ6+QFKkd6UQsIfz+TL4
	 xZEZKd8BicRxOQN4tB/Yr0nom+X74sItENj5SsGyaHbqgVhJh4wROUExhpL70bGEgW
	 J30XkKakAGEKYOfGyaRa7mUgAL70VrEB/Q0tRC2FCaP5rJxRiiJZoMSXf0OX1uxi1f
	 xkfGopKekbciLw9Mqovf6Nz9FA01S+TQq6XzdkSrGQTftxzlU5KQHP43u0AXx/XeP1
	 8FC6FdqGMgu5A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [RFC PATCH 00/33] XFS: Atomic multi-extent operations via rolling transactions
Date: Wed, 29 Jul 2026 20:01:44 +1000
Message-ID: <20260729100629.1943710-1-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This is a patchset intended to address long-standing races in extent
manipulation operations throughput the IO path. This series
addresses the underlying cause of the problem Darrick recently fixed
in commit 2f4acd0fcd86 ("xfs: resample the data fork mapping after
cycling ILOCK") in that extent manipulations are not atomic w.r.t.
each other and so can race in unexpected and unpredictable ways.

This is not a new issue - these code paths have been a source of
data corruption bugs for a long time. We have several outstanding
bug reports for intermittent test failures caused by warnings or
assert failures due to unexpected mismatches in extent state
(delalloc, data/cow fork inconsistencies, state not matching cached
imap state, etc) that have resisted attempts to reproduce reliably
and/or find a root cause.

Hence I decided that it would probably be a good idea to do the work
necessary to try to address the underlying problems to try to get
rid of this entire class of bug from the code.

I haven't been working on XFS for a year now; I've been working a
completely unrelated cloud-based project, and so I haven't written
any kernel code (nor C code!) for some time. Any mistakes I've made
in the code, commit messages, etc are all my own and stem from being
a bit rusty when it comes to writing kernel XFS code. Point them
out, I'll fix them.

I'll also be up front about the fact that this patchset is based
entirely on LLM predicted code. I review it all and correct any
errors, issues, concerns, etc immediately as each new hunk of code
is predicted by the LLM to prevent errors from compounding and
multiplying. Thus the code ends up the way I'd write it manually,
not the way an unchecked LLM would vibe code it. Mistakes in the
code are mine, not a result of an LLM being used to predict the code
I'd write faster than I can write it myself.

The first problematic pattern this patchset addresses is this:

	- lock ILOCK
	- map extent
	- decide what to do
	- unlock ILOCK
	- allocate transaction
	- lock ILOCK
	- do what was decided
	- commit transaction
	- unlock ILOCK

The issue is that the decision on what to do and actually doing it
is occurring in separate ILOCK contexts - the decision and action
are not atomic, leading to incorrect actions being taken.

This is further exacerbated by the second problematic pattern -
extent manipulations being executed in piece-wise manner and hence
not being atomic with respect to the range over which the action is
being performed. And example of this is unwritten IO completion. It
performs a loop like:

	for the range {offset, len} {
		- allocate transaction
		- lock ILOCK
		- convert next extent in range
		- update i_disk_size
		- commit transaction
		- unlock ILOCK
		- move offset forwards for next extent in range
	}

Hence we can have unwritten extent conversion interact with incoming
writes mapping the same range using the first pattern, and they
lock-step through the extents in the range and the extent map within
the range changes with each ILOCK cycle on both sides. The inherent
raciness of these operations means it is difficult to reason about
them and the races have caused data corruption issues in the past.

There are similar (but more complex) interactions with COW
operations as conversion and fork updates are split across incoming
writes, IO submission and IO completion.

What this patch set is doing is making both patterns atomic with
respect to the ILOCK. Code that uses the first pattern is adjusted
to return all the way back to the start if a transaction is
required. We then allocate a transaction and run the entire
map-decision-modify operation under a single ILOCK context.

For the second pattern, these are converted to use a rolling
transaction so the ILOCK is held across the entire set of
modifications whilst still maintaining the "one extent modification
per transaction" structure of the operation. Whilst this was always
possible with some operations, the operations that required a
physical block reservation for every extent modification (e.g. for
BMBT block allocation) require renewing the block reservation and
hence can receive ENOSPC from those reservations.

Historically speaking, handling errors from within rolling
transactions has been problematic and usually results in a
filesystem shutdown as we can't cancel a dirty transaction cleanly.

Hence to turn these into rolling transactions we require the
addition of a new transaction block reservation regrant mechanism
that can safely return ENOSPC from within a rolling transaction
context. This means we can only regrant block reservations when the
transaction is clean.

When we roll a transaction, we have a new transaction that is clean
after commiting the old transaction, and so this provides a location
for regranting block reservations whilst being able to handle an
ENOSPC error safely. However, if we are in the middle of a defer-ops
chain, we cannot safely unwind even though we have a clean
transaction. i.e. the "atomic modification" of the extent
modification has to complete fully before we can regrant block
reservation space and handle ENOSPC.

We only want to do this block reservation regrant when committing
the final transaction that finishes deferops processing - the
original reservation should already be sufficient for the entire
deferops chain, and so by avoiding regrants in the middle of an
intent processing chain we avoid seeing ENOSPC errors that would
cause a shutdown. Hence we only process regrants at the top level
commit in xfs_defer_finish().

With this mechanism, we can convert the individual transactions in a
loop like unwritten conversion to a rolling transaction that handles
ENOSPC in exactly the same way that the individual transaction
method does. This is how the series makes these multi-extent
modifications atomic with respect to the ILOCK and hence other
extent manipulations.

The overall series addresses the most frequently hit instances of
both patterns. There are other code paths that have similar patterns
that could be converted, but it's not immediately clear that any of
them matter in any material way. If there are such instances, they
can be addressed in future series.

The series passed multiple iterations of the fstests auto group over
mulitple fs configurations without regressions, and it has survived
several hundred iterations of the recoveryloop group without an
unexpected failure. Lots more testing is necessary, but given it
appears to be working it is time to get feedback on the approach and
code changes.

Comments and thoughts welcome.

-Dave.

----

LLM generated summary of the series:

This series of 33 patches fixes several race conditions and bugs in the XFS
extent manipulation code, then reworks the transaction handling to make
multi-extent operations atomic with respect to the ILOCK.

Bug fixes (patches 1-3):

Three pre-existing bugs are fixed. A dirty transaction cancellation in
xfs_bmapi_convert_one_delalloc() where xfs_iext_count_extend() could dirty a
transaction before discovering there was nothing to convert, leading to a
filesystem shutdown on the -EAGAIN cancel path. An isize update bug in
xfs_iomap_write_unwritten() where i_disk_size was set to the end of the entire
write range rather than the end of the actually converted extent, potentially
exposing zeroes after a crash. A block reservation bug in xfs_zoned_end_io()
where the reservation only covered bmbt splits but not the deferred rmap and
refcount btree operations, papered over by the fragile XFS_TRANS_RES_FDBLKS
workaround.

COW direct write atomicity (patches 4-14):

The COW extent allocation path in xfs_direct_write_iomap_begin() is restructured
so that the extent lookup and COW allocation are performed atomically under a
single ILOCK hold. Previously, the ILOCK was cycled between the extent lookup
and the allocation, leaving a window where racing DIO writes could modify the
extent tree and cause stale state bugs. Transaction allocation is lifted to the
caller with a -EAGAIN retry mechanism, and xfs_reflink_fill_cow_hole() and
xfs_reflink_fill_delalloc() are converted to use rolling transactions via
xfs_defer_finish() to keep the ILOCK held across their entire operation.

Delalloc conversion atomicity (patches 15-17):

The xfs_bmapi_convert_delalloc() loop, which converts delalloc extents to real
allocations, is converted from per-iteration transaction allocation to a single
rolling transaction using xfs_defer_finish(). This makes multi-extent delalloc
conversion atomic with respect to other concurrent extent operations.

Block reservation renewal infrastructure (patch 18):

New XFS_TRANS_RENEW_BLKRES transaction flag and xfs_trans_regrant_blkres()
mechanism that automatically restores the block reservation to its original
level after xfs_defer_finish() processes deferred operations. This is needed for
rolling transaction loops where each iteration requires a block reservation for
btree splits.

Unwritten extent conversion atomicity (patches 19-20):

The xfs_iomap_write_unwritten() loop, used for buffered writeback and DIO
completion, is converted from per-iteration transaction allocation to a single
rolling transaction with XFS_TRANS_RENEW_BLKRES for automatic block reservation
renewal.

COW IO completion atomicity (patches 21-23):

The xfs_reflink_end_cow() loop is converted to a rolling transaction, making COW
extent remapping atomic. The xfs_reflink_end_cow_extent() wrapper is removed and
the locked variant renamed since there is no longer an unlocked path.

Zoned IO completion atomicity (patch 24):

The xfs_zoned_end_io() loop is converted to a rolling transaction with the
corrected XFS_RTEXTENTADD_SPACE_RES() block reservation.

Direct write iomap restructure (patches 25-33):

The xfs_direct_write_iomap_begin() function is restructured with a unified
do/while retry loop that handles both COW and non-COW allocation paths
atomically. A new xfs_direct_write_args struct replaces the long parameter lists
throughout the call chain. The pNFS block allocation path is reworked to perform
extent allocation and inode update in a single synchronous transaction. Dead
internal transaction paths are removed from xfs_iomap_write_direct() and
xfs_direct_write_cow_iomap_begin() now that all callers supply transactions.

----

 fs/xfs/libxfs/xfs_bmap.c        |  80 ++++++++-------
 fs/xfs/libxfs/xfs_defer.c       |  38 ++++---
 fs/xfs/libxfs/xfs_shared.h      |   3 +
 fs/xfs/libxfs/xfs_trans_space.h |  12 +++
 fs/xfs/xfs_iomap.c              | 548 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------
 fs/xfs/xfs_iomap.h              |  23 ++++-
 fs/xfs/xfs_pnfs.c               | 117 +++++++++++-----------
 fs/xfs/xfs_reflink.c            | 313 +++++++++++++++++++++-------------------------------------
 fs/xfs/xfs_reflink.h            |   6 +-
 fs/xfs/xfs_trans.c              |  40 +++++++-
 fs/xfs/xfs_trans.h              |   3 +
 fs/xfs/xfs_zone_alloc.c         |  43 +++++---
 12 files changed, 675 insertions(+), 551 deletions(-)

