Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19C7221DB6
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098491; cv=none; b=Ez7lJTbEKk5QdmjSgeC3n77WFiSZ3yHFtkXe3Wcv8EoebGII6e7rpx0U868NFFo/diO2kZVyVRcI81fm6mRum/9peoN5XLpDeJMRGWF6ry6+A/lKvyq4DzK5/FZA2H+XrL6FKxfmfao5yxycqR6HOYwtHJ0PS/JYZFLJubSjRak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098491; c=relaxed/simple;
	bh=Y9TZi6usNabfsqc50miu0urWhSDCNjUBNCXQ02kgzpI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZZJZP84TUW9NG2jppGPxtbsSnG5ALWFc0zgYg0V8OTWmljsSXcVMLFlFtniMT5jGnbPs33OCTuk4+9/dw4+qNuH1q9XcyA6ggS5yiVTyG82QQv+B4CemNlEuP5s8+9CPl53a8qlvS8otoPNRbKPXp5gIKmjhRVHLBImFS+5vn1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=deW5hmJ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="deW5hmJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF38E1F000E9;
	Wed, 19 Aug 2026 00:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098487;
	bh=RL3KMdF0dXm+0h0y3W20zpvPUBVzGOazPZOlpWY4eQE=;
	h=From:To:Cc:Subject:Date;
	b=deW5hmJ9Pmm7Obk97/sNf8M/AAullYMdgKt4sRmxUImpaQn0zSspZZmnE4izNF7kJ
	 YjU+BbPjePF7GC5rSqHNN0KcFekSd+jQ95cOhRJMKNOII49JI8v3qjsTd0sfxcRQ8X
	 lxY6TnyGVyh96cZv0a9BoncVDyG4qkRFq9hESf7jgLznYbIO84EOufSjmPwFRGjfjo
	 eIb6caVGKendVQkoQ6+jvZUlIhbMNM1Dt5tjVb1zedb6tvs+KJHqR6X1BpoRRXKyPE
	 PfscGxXZbVPNLlvsg6kYIP5VZZkL6koODbfyEOJg72jz4INpxYWSbjxW4q/kigUdj5
	 6b9zbsAids6BA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH V2 00/38] XFS: Atomic multi-extent operations via rolling transactions
Date: Wed, 19 Aug 2026 10:12:03 +1000
Message-ID: <20260819001442.1451892-1-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This is the second version of the patchset intended to address
long-standing races in extent manipulation operations throughput the
IO path. This series addresses the underlying cause of the problem
Darrick recently fixed in commit 2f4acd0fcd86 ("xfs: resample the
data fork mapping after cycling ILOCK") - that extent manipulations
are not atomic w.r.t.  each other and so can race in unexpected and
unpredictable ways.

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
both patterns.  There are other code paths that have similar
patterns that could be converted, but it's not immediately clear
that any of them matter in any material way. If there are such
instances, they can be addressed in future series.

The patchset is made up entirely of LLM predicted code. I review it
all and correct any errors, issues, concerns, etc immediately as
each new hunk of code is predicted by the LLM to prevent errors from
compounding and multiplying. Thus the code ends up the way I'd write
it manually, not the way an unchecked LLM would vibe code it.
Mistakes in the code are mine, not a result of an LLM being used to
write the code.

The series passed many iterations of the fstests auto group without
regressions using a v6.19 XFS userspace, and it has survived several
hundred iterations of the recoveryloop group without an unexpected
failure.

Feedback, comments and thoughts are welcome.

-Dave.

----

Version 2:

- Fixed zoned gc remap reservation - needs two extent add
  reservations because a remap involves two independent extent map
  modifications.
- Factored transaction block reservation code to minimise duplicate
  accounting code.
- reworked XFS_TRANS_RENEW_BLKRES implementation on top of this
  factoring
- New async blockgc flushing infrastructure to allow blockgc to be
  triggered in ENOSPC/EDQUOT situations where waiting is not
  possible (e.g. in transaction context).
- Fix ILOCK leaks on the internal error paths in various
transitionary state patches.

Version 1:
- https://lore.kernel.org/linux-xfs/20260729100629.1943710-1-dgc@kernel.org/

----

LLM generated summary of the series:

This series of 38 patches fixes several race conditions and bugs in the XFS
extent manipulation code, then reworks the transaction handling to make
multi-extent operations atomic with respect to the ILOCK.

Bug fixes (patches 1-4):

Four pre-existing bugs are fixed.

A dirty transaction cancellation in xfs_bmapi_convert_one_delalloc() where
xfs_iext_count_extend() could dirty a transaction before discovering there was
nothing to convert, leading to a filesystem shutdown on the -EAGAIN cancel path.

The same dirty transaction cancellation pattern in xfs_attr_set() is fixed by
moving the attr lookup ahead of xfs_iext_count_extend() so the transaction is
only dirtied once the operation is known to proceed.

An isize update bug in xfs_iomap_write_unwritten() where i_disk_size was set to
the end of the entire write range rather than the end of the actually converted
extent, potentially exposing zeroes after a crash.

A block reservation bug in xfs_zoned_end_io() where the reservation only covered
bmbt splits but not the deferred rmap and refcount btree operations, papered
over by the fragile XFS_TRANS_RES_FDBLKS workaround.

Transaction reservation and async blockgc infrastructure (patches 5-8):

The block reservation accounting in xfs_trans_reserve() is factored into
reusable xfs_trans_reserve_blocks()/xfs_trans_unreserve_blocks() helpers to
avoid duplicating the accounting code needed by the later regrant mechanism.
New asynchronous blockgc flushing infrastructure is added so that blockgc can be
kicked without waiting in contexts where blocking is not possible - in
particular from within a transaction context holding the ILOCK, where a
synchronous flush would deadlock against the blockgc workers.
xfs_trans_reserve_more_inode() gains a retry loop that kicks async block and
quota blockgc on ENOSPC/EDQUOT and retries after a short io_schedule_timeout()
rather than failing immediately.

COW direct write atomicity (patches 9-19):

The COW extent allocation path in xfs_direct_write_iomap_begin() is restructured
so that the extent lookup and COW allocation are performed atomically under a
single ILOCK hold. Previously, the ILOCK was cycled between the extent lookup
and the allocation, leaving a window where racing DIO writes could modify the
extent tree and cause stale state bugs. Transaction allocation is lifted to the
caller with a -EAGAIN retry mechanism, and xfs_reflink_fill_cow_hole() and
xfs_reflink_fill_delalloc() are converted to use rolling transactions via
xfs_defer_finish() to keep the ILOCK held across their entire operation.

Delalloc conversion atomicity (patches 20-22):

The xfs_bmapi_convert_delalloc() loop, which converts delalloc extents to real
allocations, is converted from per-iteration transaction allocation to a single
rolling transaction using xfs_defer_finish(). This makes multi-extent delalloc
conversion atomic with respect to other concurrent extent operations.

Block reservation renewal infrastructure (patch 23):

New XFS_TRANS_RENEW_BLKRES transaction flag and xfs_trans_regrant_blkres()
mechanism that automatically restores the block reservation to its original
level after xfs_defer_finish() processes deferred operations. This is needed for
rolling transaction loops where each iteration requires a block reservation for
btree splits.

Unwritten extent conversion atomicity (patches 24-25):

The xfs_iomap_write_unwritten() loop, used for buffered writeback and DIO
completion, is converted from per-iteration transaction allocation to a single
rolling transaction with XFS_TRANS_RENEW_BLKRES for automatic block reservation
renewal.

COW IO completion atomicity (patches 26-28):

The xfs_reflink_end_cow() loop is converted to a rolling transaction, making COW
extent remapping atomic. The xfs_reflink_end_cow_extent() wrapper is removed and
the locked variant renamed since there is no longer an unlocked path.

Zoned IO completion atomicity (patch 29):

The xfs_zoned_end_io() loop is converted to a rolling transaction with the
corrected XFS_RTEXTENTADD_SPACE_RES() block reservation.

Direct write iomap restructure (patches 30-38):

The xfs_direct_write_iomap_begin() function is restructured with a unified
do/while retry loop that handles both COW and non-COW allocation paths
atomically. A new xfs_direct_write_args struct replaces the long parameter lists
throughout the call chain. The pNFS block allocation path is reworked to perform
extent allocation and inode update in a single synchronous transaction. Dead
internal transaction paths are removed from xfs_iomap_write_direct() and
xfs_direct_write_cow_iomap_begin() now that all callers supply transactions.

----

Diffstat:

 fs/xfs/libxfs/xfs_attr.c        |  70 ++---
 fs/xfs/libxfs/xfs_bmap.c        |  80 +++---
 fs/xfs/libxfs/xfs_defer.c       |  38 ++-
 fs/xfs/libxfs/xfs_shared.h      |   3 +
 fs/xfs/libxfs/xfs_trans_space.h |  12 +
 fs/xfs/scrub/cow_repair.c       |   4 +-
 fs/xfs/scrub/quota_repair.c     |   2 +-
 fs/xfs/scrub/rtbitmap_repair.c  |   2 +-
 fs/xfs/scrub/tempfile.c         |   2 +-
 fs/xfs/xfs_icache.c             | 172 ++++++++++---
 fs/xfs/xfs_icache.h             |   2 +
 fs/xfs/xfs_iomap.c              | 548 +++++++++++++++++++++++-----------------
 fs/xfs/xfs_iomap.h              |  23 +-
 fs/xfs/xfs_pnfs.c               | 117 +++++----
 fs/xfs/xfs_reflink.c            | 313 +++++++++--------------
 fs/xfs/xfs_reflink.h            |   6 +-
 fs/xfs/xfs_trans.c              | 227 ++++++++++-------
 fs/xfs/xfs_trans.h              |   7 +-
 fs/xfs/xfs_zone_alloc.c         |  47 ++--
 19 files changed, 957 insertions(+), 718 deletions(-)
