Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A4B384CF5;
	Thu, 10 Sep 2026 05:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789016780; cv=none; b=R2bWdHmer9Yf9Qo7IbvrZQjDGQXf3Y5PLMvSE1BCk9LMZFpMq3jAG5jMyz7LBcYIpQnUmMfvM+gXOWzukqJ+uaDAT6BU510CeSEEEM/PiT/LjJS3z3TS9Kj57fBXvIwEKE4x02K+X8xZjsKPajkbCMD9PUToxvuhKi9y68Jzp1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789016780; c=relaxed/simple;
	bh=SDO6oRezXkdSXnQK9aDfrf4+BuOhd/5TCufZAB9AHp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZkOcEM9O1CDB3YkXMlvLPUWAS9EyMzCakizso4egioWVDSNuIRZc4eupRWS2UhLB02vcCmLt6+JGIgfO+97X3CnKZCTblOxSBnRTVlThCPEl3kr63ZCv3v5G8P6xjsmtvdfnj3acokcqpK1g0hivQSnzTCxF2TMwEnuPr+kDJFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSH+kaqa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSH+kaqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F99B1F000FF;
	Thu, 10 Sep 2026 05:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789016776;
	bh=rrFOmgO0jmh4XZX2GUo0PTRCfUL18S1K818pYOxx6RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bSH+kaqaKOCqF31UvaLEwp6vSjtOnPOM3EWLm739N5At+u0gyRbVMrkevFrSUgOIW
	 sKAdPbCA/okvDwsW2CBQhN/rY6JSWLiLP1h7lwbryJ7N4T9P9o2BEskhxZYKNq3Lve
	 ZChMMeOKkluqMxelPscgkrIgisLlMGjEDZxarfP7O7krPlhzaTTYY7QPN3m+MVle/U
	 LrCdScfluUKkY4qEmhPaz/X0OjYLsp42gT8vyeuONk8eftxWn5s/jK7f5VtNd8MW4Z
	 G7GICk9fV6k+hrR0b9TzYmiOok8Us7WJkgs3yLIbcIsVsuDWlLwk49/oM4Fo9OSrye
	 vzk4z0goMfYJQ==
Date: Thu, 10 Sep 2026 15:06:07 +1000
From: Dave Chinner <dgc@kernel.org>
To: syzbot <syzbot+a4fde844548510369112@syzkaller.appspotmail.com>
Cc: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Write in
 xlog_cil_ail_insert
Message-ID: <aqI6v-_dc2DDSbgB@dread>
References: <6aa1f6d7.f2639fcc.29487d.0010.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6aa1f6d7.f2639fcc.29487d.0010.GAE@google.com>

On Wed, Sep 09, 2026 at 05:16:23PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    654ae5d73c05 Merge tag 'drm-fixes-2026-09-05' of https://g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16691125580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=19560cab9a915237
> dashboard link: https://syzkaller.appspot.com/bug?extid=a4fde844548510369112
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/bb30b9c473e7/disk-654ae5d7.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/fcb222028f47/vmlinux-654ae5d7.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/5cfc3b5a7eef/bzImage-654ae5d7.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a4fde844548510369112@syzkaller.appspotmail.com
> 
> XFS (loop0): Please unmount the filesystem and rectify the problem(s).
> ==================================================================
> BUG: KASAN: slab-use-after-free in instrument_atomic_write include/linux/instrumented.h:97 [inline]
> BUG: KASAN: slab-use-after-free in set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
> BUG: KASAN: slab-use-after-free in xlog_cil_ail_insert+0x55b/0xd00 fs/xfs/xfs_log_cil.c:889
> Write of size 8 at addr ffff888028e06d60 by task kworker/1:1H/1998
> 
> CPU: 1 UID: 0 PID: 1998 Comm: kworker/1:1H Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
> Workqueue: xfs-log/loop0 xlog_ioend_work
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0x13d/0x4b0 mm/kasan/report.c:482
>  kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:186 [inline]
>  kasan_check_range+0x10f/0x1e0 mm/kasan/generic.c:200
>  instrument_atomic_write include/linux/instrumented.h:97 [inline]
>  set_bit include/asm-generic/bitops/instrumented-atomic.h:28 [inline]
>  xlog_cil_ail_insert+0x55b/0xd00 fs/xfs/xfs_log_cil.c:889
>  xlog_cil_committed+0xd7/0x6f0 fs/xfs/xfs_log_cil.c:995
>  xlog_cil_process_committed+0x123/0x1f0 fs/xfs/xfs_log_cil.c:1025
>  xlog_state_shutdown_callbacks+0x1ef/0x3a0 fs/xfs/xfs_log.c:438
>  xlog_force_shutdown+0x21b/0x490 fs/xfs/xfs_log.c:3408
>  xlog_ioend_work+0xec/0x110 fs/xfs/xfs_log.c:1205

Buffer is pinned, so the CIL hold a reference to the BLI that
guarantees the existence of both the BLI and the underlying buffer.

However, there is a shutdown in progress....

> Allocated by task 9369:
>  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>  __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:366
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4683 [inline]
>  slab_alloc_node mm/slub.c:4996 [inline]
>  kmem_cache_alloc_noprof+0x269/0x6a0 mm/slub.c:5010
>  xfs_buf_item_init+0x8a/0x660 fs/xfs/xfs_buf_item.c:872
>  _xfs_trans_bjoin+0x3f/0x140 fs/xfs/xfs_trans_buf.c:75
>  xfs_trans_get_buf_map+0x2be/0x750 fs/xfs/xfs_trans_buf.c:162
>  xfs_trans_get_buf fs/xfs/xfs_trans.h:189 [inline]
>  xfs_dquot_disk_alloc+0x62a/0xbc0 fs/xfs/xfs_dquot.c:397
>  xfs_qm_dqread+0x4e7/0x5d0 fs/xfs/xfs_dquot.c:720
>  xfs_qm_dqget+0xee/0x3c0 fs/xfs/xfs_dquot.c:923
>  xfs_qm_quotacheck_dqadjust+0xae/0x5a0 fs/xfs/xfs_qm.c:1260

Buffer allocated and logged from quotacheck.

> Freed by task 13586:
>  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
>  kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2748 [inline]
>  slab_free mm/slub.c:6499 [inline]
>  kmem_cache_free+0x127/0x6c0 mm/slub.c:6626
>  xfs_buf_ioend+0x351/0x1aa0 fs/xfs/xfs_buf.c:1167
>  xfs_buf_iowait+0xfa/0x470 fs/xfs/xfs_buf.c:1336
>  xfs_buf_delwri_submit+0x3f8/0x600 fs/xfs/xfs_buf.c:2051
>  xfs_qm_quotacheck+0x2f9/0x880 fs/xfs/xfs_qm.c:1536

And shutdown has occurred during dirty buffer writeback from
quotacheck.

This -normally- blocks on pinned buffers, allowing the buffer to
move from the CIL to the AIL, releasing it's reference to the BLI
and leaving it to be release by IO completion.

However, the shutdown path through xfs_buf_submit() on shutdown does
not wait on pinned buffers - it simply errors them out, resulting
in xfs_buf_ioend() being called on a buffer with an attached BLI.
This then frees the BLI despite it still having an active reference
(xfs_buf_item_done -> xfs_buf_item_relse -> xfs_buf_item_free)
because it assumes buffers running IO completion have no references
to the BLI.

This is yet another manifestation of the the "AIL doesn't hold a
log item reference" problem; xfs_buf_item_done() assumes there are
no references because the buffer is locked, has no pins and so it
owns the attached BLI and can free it.

Hence when the CIL (correctly!) tries to access the BLI it still
holds a reference to, it finds that it has been freed and triggers
the UAF.

The short term fix is to slap a bandaid on xfs_buf_submit() to wait
for unpin before erroring out a pinned buffer on shutdown. That,
however, doesn't fix the underlying lack of full lifecycle reference
counts for log items.

The long term fix is have the AIL require a reference count to be
held on log items it tracks, and only have that refcount removed
when the item is removed from the AIL. That's a much bigger rework
of the code. 

FYI, I've attached two document below - the design for
generic full lifecycle log item reference counting, and the design
for converting the inode log item to be dynamic similar to the buf
log item so we don't end up with millions of ILIs that are never
used left sitting around in memory until it's owner inode is
reclaimed.

-Dave.
-- 
Dave Chinner
dgc@kernel.org

$ cat log-item-recount.rst
.. SPDX-License-Identifier: GPL-2.0

======================================
XFS Log Item Reference Counting Design
======================================

Goal: Eliminate the "zero refcount but in AIL means alive" state by
adding an AIL reference to log items. Lift the refcount from the
type-specific level (bli_refcount, efi_refcount, etc.) to the generic
xfs_log_item level using a lockref. This allows the AIL to take and
drop log item references directly without needing type-specific
methods, and provides lock-free log item lifecycle management via
lockref_get_not_dead() and cmpxchg-based owner detachment.


Current State: Type-Specific Refcounts
======================================

Every log item type that persists in the AIL has its own refcount:

  - BLI:   bli_refcount  (atomic_t in xfs_buf_log_item)
  - EFI:   efi_refcount  (atomic_t in xfs_efi_log_item)
  - RUI:   rui_refcount  (atomic_t in xfs_rui_log_item)
  - CUI:   cui_refcount  (atomic_t in xfs_cui_log_item)
  - BUI:   bui_refcount  (atomic_t in xfs_bui_log_item)
  - ATTRI: attri_refcount (atomic_t in xfs_attri_log_item)
  - XMI:   xmi_refcount  (atomic_t in xfs_xmi_log_item)

All use the same pattern: atomic_dec_and_test to detect the last
reference, then remove from AIL and free. The intent items initialise
to 2 (AIL + done item), the BLI increments/decrements dynamically
(transaction + CIL pin).

Lifting the refcount to xfs_log_item unifies this, eliminates
per-type boilerplate, and enables the AIL to manage references
generically.

AIL removal is always performed by type-specific code (never by
generic AIL infrastructure), and the AIL lock is always dropped
before the type-specific caller frees the item. This means the type-
specific code can drop the AIL reference after AIL removal and handle
freeing without holding the AIL lock.


Generic Infrastructure: lockref on xfs_log_item
===============================================

Add a struct lockref li_ref to struct xfs_log_item.

Using lockref gives us:

  lockref_get_not_dead():
    Atomic "get if alive" that returns false if the item is dead
    (count < 0). Replaces the current assumption that an existing
    log item pointer always means the item is usable.

  lockref_mark_dead():
    Marks the item dead so no further gets succeed. Called when the
    last reference is dropped and the item is about to be freed.

  lockref_put_or_lock():
    Drops the reference; if it was the last one, returns with the
    embedded spinlock held. The caller can then perform final cleanup
    (detach from owner, mark dead) atomically under that lock before
    freeing.

  Embedded spinlock:
    Serialises the final teardown against concurrent lookups without
    needing external per-object locks.

Generic helpers:

  xfs_log_item_get(lip):
    lockref_get — caller knows the item is alive.

  xfs_log_item_put(lip):
    lockref_put_or_lock — returns true if last ref. Caller holds the
    lockref spinlock on true return and must mark dead + free.

  xfs_log_item_get_safe(lip):
    lockref_get_not_dead — returns bool. Used for lookups where the
    item may be dying.

These do NOT free the item — freeing is type-specific.


xfs_trans_ail_delete() Return Value
===================================

xfs_trans_ail_delete() currently returns void. Change it to return
bool: true if the item was removed from the AIL, false if it was not
in the AIL (shutdown case).

Callers use this to decide whether to drop the AIL reference:

.. code-block:: c

  bool removed = xfs_trans_ail_delete(lip, shutdown_type);
  if (removed && xfs_log_item_put(lip)) {
      lockref_mark_dead(...)
      type_specific_detach_and_free(item);
  }

For callers that use xfs_ail_delete_one() directly (batch operations
under the AIL lock), the AIL reference drop must be deferred until
after the AIL lock is released. These callers already collect items
and process them after the lock is dropped (e.g. xfs_iflush_ail_updates
collects into a list, then xfs_iflush_finish processes after the lock).
The ref drop and potential free can be added to the post-lock
processing.


Log Item Lookup and Detachment via lockref + cmpxchg
====================================================

For log items attached to owner objects (BLI → buffer, inode item →
inode), the lockref enables lock-free lifecycle management:

Lookup (joining an existing item to a transaction):

.. code-block:: c

  item = READ_ONCE(owner->item_pointer);
  if (item && lockref_get_not_dead(&item->li_ref))
      return item;    /* existing item is alive, reuse it */

  /* No item or item is dead — allocate a new one */

The load of the owner's item pointer must use ``READ_ONCE()`` to
ensure the pointer is loaded exactly once. The lookup can race
with a concurrent teardown that clears the pointer via ``cmpxchg``.
Without ``READ_ONCE()``, the compiler may reload the pointer after
the NULL check, potentially reading NULL on the second load and
passing it to ``lockref_get_not_dead()``. All type-specific get
wrappers (``xfs_inode_item_get()``, ``xfs_buf_item_get()``, etc.)
must use ``READ_ONCE()`` for the initial pointer load.

If lockref_get_not_dead returns false, the existing item is dead
(being torn down). We allocate a new item and attach it, knowing the
dead one is about to be freed.

Memory ordering consideration: further investigation is needed
into whether ``smp_load_acquire()`` / ``smp_store_release()`` is
required for the owner pointer load in ``_get()`` and the owner
pointer store during attachment. An unlocked lookup that races
with a concurrent ``xfs_trans_ijoin()`` creating and attaching a
new log item could potentially see the new pointer but read
incompletely initialised structure fields if the stores that
initialise the log item are reordered past the store that
publishes the pointer. ``smp_store_release()`` on the attachment
side and ``smp_load_acquire()`` on the lookup side would ensure
that all initialisation is visible before the pointer becomes
visible. Whether this is actually necessary depends on whether
all lookup callers hold locks that provide the needed barriers,
or whether truly unlocked lookups (e.g. ``xfs_inode_clean()``)
can race with initial attachment.

Attachment (new item to owner):

.. code-block:: c

  cmpxchg(&owner->item_pointer, old_item, new_item)

where old_item is the dead item (or NULL). If the cmpxchg fails,
another thread already attached a new item — retry the lookup.

Detachment (dying item from owner):

When the last reference is dropped via lockref_put_or_lock(), it
returns with the lockref spinlock held. Under that lock:

a. lockref_mark_dead() — prevents any new gets
b. cmpxchg(&owner->item_pointer, item, NULL)
   If the cmpxchg fails, a concurrent join already replaced the
   pointer with a new item — the dead item is effectively detached.
c. Drop the lockref spinlock
d. Free the item

The mark_dead + cmpxchg under the lockref spinlock ensures that once
an item is being torn down, no concurrent lookup can get a reference
to it.

Brief coexistence of old and new items:

There is a brief window where a dead item and a new item both exist
for the same owner. This is safe because:

- The dead item is no longer reachable via the owner pointer
- The dead item's remaining teardown operates on the item itself
- The CIL/AIL track items by direct pointer, not via owner lookups
- The new item has its own independent lifecycle

Not all item types have owner objects with pointer-based attachment.
Inode items and dquot items are embedded in their owner structures
rather than being separately allocated and pointer-linked. These
types need different detachment strategies — see their individual
sections below.


AIL Reference Management
========================

The AIL takes a log item reference when an item is first inserted
(XFS_LI_IN_AIL transitions 0 → 1, detected by test_and_set_bit
returning 0 in xfs_trans_ail_update_bulk). Moving an item within
the AIL does not change the refcount.

The AIL reference is dropped by type-specific code after removing
the item from the AIL. The AIL removal (xfs_ail_delete_one /
xfs_trans_ail_delete) clears XFS_LI_IN_AIL but does not drop the
reference — the caller does that after the AIL lock is released.

The AIL cannot take references until the corresponding item type
supports dropping them. During the conversion, temporary scaffolding
in the AIL insert path conditionally takes references only for item
types that have been converted. Once all types are converted, the
scaffolding is replaced with an unconditional reference on insert.


Buffer Log Item (BLI) Modifications
===================================

See bli-lifecycle-analysis.rst for the full BLI lifecycle analysis.

Owner object: struct xfs_buf, via bp->b_log_item pointer.

Current refcount semantics:
  - bli_refcount initialised to 0 at allocation
  - Transaction join: +1
  - CIL pin: +1
  - Transaction release (iop_committing): -1
  - CIL unpin: -1
  - Refcount 0 + IN_AIL = alive (unusual state)
  - IO completion frees at refcount 0

Changes needed:

  a. Replace bli_refcount with li_ref (lockref).

  b. xfs_buf_item_init(): use lockref_get_not_dead() to test whether
     an existing bp->b_log_item is still alive. If dead, allocate a
     new BLI and attach via cmpxchg.

  c. xfs_buf_item_relse(): use lockref_put_or_lock, mark_dead, and
     cmpxchg to detach from bp->b_log_item atomically. Remove the
     ASSERT(xfs_buf_islocked) — buffer lock no longer needed for BLI
     lifecycle.

  d. xfs_buf_item_put(): remove the IN_AIL check at refcount 0.
     With AIL reference, refcount cannot be 0 while IN_AIL.

  e. xfs_buf_item_release() (iop_committing): the dirty+IN_AIL case
     at refcount 0 can no longer occur. Simplify accordingly.

  f. xfs_buf_item_done(): after xfs_trans_ail_delete, drop the AIL
     ref via xfs_log_item_put. If last ref, mark dead + detach + free.

  g. xfs_buf_item_finish_stale(): same restructuring as done().

  h. xfs_buf_item_unpin(): after dropping pin ref, BLI has refcount
     >= 1 if in AIL (AIL ref). Update comments.

Updated BLI refcount trace:
  0 → 1 (trans join) → 2 (CIL pin) → 3 (AIL insert) →
  2 (trans commit) → 1 (CIL unpin) → 0 (AIL remove at IO completion)
  → mark dead → detach from buffer → free


Inode Log Item Modifications
============================

See (future) inode-item-lifecycle-analysis.rst for detailed analysis.

Owner object: struct xfs_inode, via ip->i_itemp pointer. The inode
item is separately allocated but has complex interactions:

- Push model flushes inode to cluster buffer, not direct IO
- Batch AIL delete in xfs_iflush_ail_updates under AIL lock
- IO completion handling via xfs_buf_inode_iodone and b_li_list

Needs its own detailed lifecycle analysis and modification plan
similar to the BLI analysis.


Dquot Log Item Modifications
============================

See (future) dquot-item-lifecycle-analysis.rst for detailed analysis.

Owner object: struct xfs_dquot, with qli_item embedded (not a pointer).
Embedded items cannot use cmpxchg-based detachment — need different
strategy.

Needs its own detailed lifecycle analysis and modification plan
similar to the BLI analysis.


Intent Item Modifications (EFI, RUI, CUI, BUI, ATTRI, XMI)
==========================================================

See intent-item-lifecycle-analysis.rst for the detailed lifecycle
analysis of intent items, including the intent/done item pairing,
the implicit CIL reference model, and ordering considerations.

RT variants (RTEFI, RTRUI, RTCUI) follow the same pattern as their
non-RT counterparts.

This section describes how to convert intent and intent done items
to use the same generic reference counting model as all other log
item types: explicit references taken and dropped at well-defined
lifecycle points via the standard iop callbacks.


Intent Item References
----------------------

The intent item is created with a single reference: the transaction
reference. It then follows the standard log item lifecycle:

**Creation:**
refcount = 1 (transaction reference)

**Transaction commit into CIL:**
iop_pin: +1 (CIL pin reference), refcount becomes 2.
iop_committing: -1 (transaction reference), refcount becomes 1.

**Transaction abort (before CIL insertion):**
iop_release: -1 (transaction reference), refcount becomes 0. Item freed.

**CIL checkpoint completion (normal):**
AIL insert: +1 (AIL reference), refcount becomes 2.
iop_unpin: -1 (CIL pin reference), refcount becomes 1.
Intent item is now in the AIL with refcount 1 (AIL ref only),
awaiting the done item to remove it.

**CIL checkpoint abort:**
iop_unpin(abort): -1 (CIL pin reference), refcount becomes 0. Item freed.
Item was never inserted into AIL, no AIL ref exists.


Hold Reference for the Intent Done Item
---------------------------------------

Between committing the intent and creating the done item, there is
a window where a shutdown could race and free the intent (via CIL
abort → iop_unpin dropping to 0). The caller must hold a reference
to the intent across this window to ensure it remains alive until
the done item is created.

The sequence is:

1. Caller creates the intent item (refcount 1, transaction ref).

2. Caller takes a "hold" reference on the intent before committing
   the transaction via ``xfs_log_item_get(intent)``, bringing the
   refcount to 2.

3. Transaction commits. The standard CIL path runs:
   ``iop_pin: +1`` brings refcount to 3, then
   ``iop_committing: -1`` brings refcount to 2.
   The intent now has: hold ref + CIL pin ref.

4. Caller creates the done item in a new transaction, gifting the
   hold reference to the done item. The caller no longer owns that
   reference — the done item is now responsible for it.

5. If an error occurs between step 2 and step 4 (e.g. shutdown),
   the caller still holds the hold reference and must drop it.
   The CIL abort will drop the pin ref via iop_unpin(abort). The
   caller's drop of the hold ref will then free the intent (or
   vice versa — the refcount handles either ordering).


Intent Done Item References
---------------------------

The done item follows the same standard lifecycle as any other log
item, plus it holds the gifted reference to the paired intent item.

**Creation:**
refcount = 1 (transaction reference).
The done item holds the gifted reference to the intent item.

**Transaction commit into CIL:**
iop_pin: +1 (CIL pin reference), refcount becomes 2.
iop_committing: -1 (transaction reference), refcount becomes 1.

**Transaction abort (before CIL insertion):**
iop_release: -1 (transaction reference), refcount becomes 0.
On last ref, the done item must: remove the intent item from the AIL
(if present), drop the gifted reference to the intent item, and free
itself.

**CIL checkpoint completion (normal):**
Done items have XFS_ITEM_RELEASE_WHEN_COMMITTED, so they are NOT
inserted into the AIL. Instead, iop_unpin: -1 (CIL pin reference),
refcount becomes 0. On last ref, the done item must: remove the intent
item from the AIL, drop the gifted reference to the intent item, and
free itself. The intent item's refcount after the done item completes:
before it was 1 (AIL ref only, CIL pin already dropped), the done item
removes from AIL dropping the AIL ref to 0 and freeing the intent.

**CIL checkpoint abort:**
iop_unpin(abort): -1 (CIL pin reference), refcount becomes 0.
Same cleanup as normal completion — remove intent from AIL, drop
gifted ref, free self. The intent may or may not be in the AIL
depending on whether its own checkpoint completed before the abort.


Normal Operation Refcount Trace
-------------------------------

Intent item:
  1 (create) → 2 (hold ref) → 3 (CIL pin) → 2 (committing drops
  trans ref) → 3 (AIL insert) → 2 (CIL unpin) → 1 (done item
  removes from AIL, drops AIL ref) → 0 (done item drops hold ref)
  → free

Done item:
  1 (create) → 2 (CIL pin) → 1 (committing drops trans ref) →
  0 (CIL unpin, last ref) → cleanup intent → free self


Shutdown Race Refcount Traces
-----------------------------

Shutdown before done item is created:

  Intent: 1 (create) → 2 (hold ref) → 3 (CIL pin) → 2 (committing)
  Shutdown occurs. CIL abort: iop_unpin(abort) → 1 (hold ref).
  Caller drops hold ref → 0 → free.
  (Intent was never in AIL — no AIL ref to drop.)

Shutdown after done item is created, intent in AIL:

  Intent in AIL with refcount 1 (AIL ref). Done item committed.
  Shutdown aborts done item's CIL context.
  Done item iop_unpin(abort) drops CIL pin → refcount 0.
  Done item cleanup: removes intent from AIL, drops AIL ref on
  intent → intent refcount 0 → intent freed.
  Done item freed.

Shutdown after done item committed, before intent checkpoint completes:

  Intent: CIL pin ref + hold ref (gifted to done) = refcount 2.
  Done item committed, its checkpoint completes (or is aborted).
  Done item cleanup: intent not yet in AIL (no AIL ref), drops
  hold ref → intent refcount 1 (CIL pin only).
  Intent's CIL abort: iop_unpin(abort) → refcount 0 → free.


Whiteout Refcount Trace
-----------------------

When the whiteout optimisation fires, the reconciled refcount model
handles it cleanly with no special cases:

**Intent item committed into CIL:**
1 (create) then 2 (hold ref for done) then 3 (iop_pin) then
2 (iop_committing drops trans ref).
Intent is in CIL with: CIL pin ref + hold ref.

**Done item committed into same checkpoint:**
xlog_cil_process_intents detects the pairing, marks the intent as a
whiteout, and calls the done item's iop_release which drops the hold
ref on the intent bringing its refcount to 1 (CIL pin ref only). The
done item is freed.

**Checkpoint push:**
The whiteout intent is moved to the whiteout list (not written to the
journal). After the commit record is written, xlog_cil_cleanup_whiteouts
calls iop_unpin(abort) which drops the CIL pin ref, bringing refcount
to 0 and freeing the intent.

No AIL reference is involved because the intent is never inserted
into the AIL. The entire lifecycle stays within the CIL scope, using
only the CIL pin reference and the hold reference (gifted to and
consumed by the done item).


Comparison with Current Model
-----------------------------

  Current:
    - Intent created with refcount 2 (implicit CIL + done refs)
    - No iop_pin, no iop_committing, no iop_release
    - Release function combines ref drop + AIL removal
    - Implicit reference passing

  Reconciled:
    - Intent created with refcount 1 (transaction ref)
    - Explicit hold ref taken before commit for done item
    - Standard iop_pin/iop_unpin for CIL references
    - Standard iop_committing/iop_release for transaction references
    - AIL ref taken on insert, dropped on removal
    - Done item explicitly removes intent from AIL and drops refs
    - All references explicitly taken and dropped at defined points
    - No implicit reference passing


ICREATE Item Modifications
==========================

Simple single-use items with no refcount. Freed by iop_release at
commit time (XFS_ITEM_RELEASE_WHEN_COMMITTED). May not need lockref
complexity — assess whether a simple refcount or even no refcount is
sufficient.


Quotaoff Item Modifications
===========================

Simple single-use items. Similar to ICREATE — assess whether lockref
is needed or if a simpler approach suffices.


Implementation Ordering
=======================

The implementation is ordered so that generic infrastructure is added
first, each item type is converted independently, and the AIL
behaviour change is the final step.

Generic infrastructure:
  1. Add li_ref (lockref) to xfs_log_item, add helpers, init in
     xfs_log_item_init(). No behaviour change.
  2. Change xfs_trans_ail_delete() to return bool. No behaviour change.

Per-type conversion (order does not matter):
  3. BLI: replace bli_refcount with li_ref, convert init/get/put/
     relse, add get-not-dead lookup, add cmpxchg detachment.
  4. Intent items: replace type-specific refcounts with li_ref.
  5. Inode items: full analysis needed, then convert.
  6. Dquot items: full analysis needed, then convert.
  7. ICREATE/Quotaoff: assess and convert if needed.

AIL reference (requires all types converted):
  8. For each converted type: add AIL ref drop to removal path, then
     add conditional ref-get on AIL insert (type-checked scaffolding).
  9. Once all types done: replace scaffolding with unconditional
     ref-get on AIL insert.
  10. Remove dead code: "refcount 0 + IN_AIL" checks, related asserts
      and comments.

EOF



$ cat ili-dynamic-lifecycle-model.rst
.. SPDX-License-Identifier: GPL-2.0

==============================================
XFS Inode Log Item Dynamic Lifecycle Model
==============================================

This document describes the conversion of the inode log item (ILI)
from the current "allocate once, use forever" model to a dynamic
reference-counted lifecycle using the lockref on ``xfs_log_item``.
The key insight is that the ``ili_lock`` spinlock currently protecting
flush/dirty state interactions can be replaced by the lockref's
embedded spinlock, unifying state serialisation with reference
counting.

See ``inode-item-lifecycle-analysis.rst`` for the complete analysis
of the current ILI access patterns that this design must support.


Design Principles
=================

1. **Replace ili_lock with the lockref spinlock.** The lockref
   embedded in ``li_ref`` contains a spinlock that serialises
   reference count changes. All state changes currently protected
   by ``ili_lock`` (fields, flush_lsn, commit_seq, datasync_seq)
   will be serialised by the lockref's spinlock instead. This
   means state changes are inherently atomic with respect to
   reference count transitions — particularly the critical case
   where IO completion drops the last reference while also clearing
   flush state.

2. **Every accessor must hold a reference or prove liveness.** The
   current code assumes ``ip->i_itemp`` is stable once set. With
   dynamic lifecycle, every context that uses the ILI must either
   hold a reference (guaranteeing the ILI stays alive) or use
   ``lockref_get_not_dead()`` to conditionally acquire one.

   A context that already holds a reference does not need to prove
   liveness — the reference IS the proof. For example, a
   transaction context that has joined the inode holds a transaction
   reference to the ILI, so all subsequent accesses within that
   transaction (``xfs_trans_log_inode()``, ``iop_precommit``, etc.)
   can use the ILI directly without ``get_not_dead()`` checks.

   Contexts that do NOT hold a reference — such as
   ``xfs_iflush_cluster()`` iterating inodes under ILOCK — must
   use ``lockref_get_not_dead()`` after taking the ILOCK. The
   ILOCK serialises against concurrent ILI creation (a new
   transaction dirtying the inode) and concurrent ILI teardown
   (IO completion marking the inode clean and dropping the last
   reference). But ILOCK alone does not guarantee the ILI is
   alive — a racing IO completion on a different CPU can drop
   the last reference without holding ILOCK. The
   ``lockref_get_not_dead()`` call resolves the race: it either
   acquires a reference (ILI is alive, safe to use) or returns
   false (ILI is dying/dead, skip this inode).

3. **CIL and AIL residency hold references.** The CIL pin takes a
   reference (via ``iop_pin``) and drops it (via ``iop_unpin``).
   The AIL takes a reference on first insertion and drops it on
   removal. These replace the implicit lifetime guarantees
   currently provided by ``i_pincount`` (for CIL) and the
   "IN_AIL prevents reclaim" assert (for AIL).

   The AIL reference is particularly important for writeback. The
   inode must be in the AIL for the entire duration of IO — from
   the point ``iop_push`` triggers writeback through to IO
   completion removing it from the AIL. The AIL reference
   guarantees the ILI remains alive across this entire window.
   This means IO completion code (``xfs_buf_inode_iodone()``,
   ``xfs_iflush_ail_updates()``, ``xfs_iflush_finish()``) can
   directly access the ILI without needing to prove liveness —
   being under IO is proof that the AIL holds a reference. The
   AIL reference is only dropped by IO completion itself, after
   it has finished accessing the ILI and removed it from the AIL.

4. **Buffer attachment is NOT a reference.** The ILI holds a
   reference to the cluster buffer (``li_buf``, ``xfs_buf_hold``),
   not the other way around. The ILI's presence on ``b_li_list``
   does not require a separate reference because the entire time
   the ILI is attached to a buffer, it is already covered by one
   of the "inode is dirty" keep-alive references:

   - Precommit attaches the ILI to the buffer. At this point the
     transaction reference is held.
   - The transaction commits, taking a CIL pin reference before
     dropping the transaction reference.
   - CIL checkpoint completion inserts into the AIL (taking an AIL
     reference) before dropping the CIL pin reference.
   - The AIL pushes the inode, triggering writeback. The AIL
     reference is held for the entire duration of IO.
   - IO completion removes the ILI from the AIL and detaches it
     from the buffer — both in the same ``xfs_buf_inode_iodone()``
     call. The AIL reference is dropped after all ILI access is
     complete, including the buffer detach in ``xfs_iflush_finish()``.

   There is no window where the ILI is on the buffer list but not
   covered by at least one of the transaction, CIL pin, or AIL
   references. The AIL reference in particular spans the entire
   writeback IO, and IO completion performs AIL removal and buffer
   detach sequentially — the AIL reference is not dropped until
   after ``xfs_iflush_finish()`` has finished accessing the ILI.

   If the inode is re-dirtied during writeback, a new transaction
   reference and CIL pin reference are added. When the original IO
   completes, the inode is still dirty (``ili_fields != 0``), so
   ``xfs_iflush_finish()`` does NOT detach from the buffer. The
   AIL entry is not removed either (``flush_lsn != li_lsn`` because
   the inode was relogged). The ILI stays on the buffer list,
   covered by the new AIL reference from the relog.

5. **The inode ``i_itemp`` pointer is the owner attachment.**
   Attachment and detachment use atomic ``cmpxchg`` operations on
   ``ip->i_itemp`` and can safely run concurrently without any
   external serialisation. See the "Log Item Lookup and Detachment
   via lockref + cmpxchg" section in ``log-item-refcount-design.rst``
   for the full model.


Long-Term Reference Holders
===========================

The ILI has three types of long-term reference holders. Each
reference has a well-defined acquisition and release point, and
the references chain together so the ILI always has at least one
reference from the time it is first dirtied until it is fully
clean and removed from the AIL.

Transaction reference
  Acquired: ``xfs_trans_ijoin()`` — either by creating a new ILI
  (born with refcount 1) or by ``lockref_get()`` on an existing one.
  Released: ``iop_committing`` (dirty items) or ``iop_release``
  (clean items / abort). The transaction reference is always the
  first reference acquired and one of the first released.

CIL pin reference
  Acquired: ``iop_pin`` — ``lockref_get()``.
  Released: ``iop_unpin`` — ``lockref_put_or_lock()``.
  The CIL pin reference replaces the current ``i_pincount`` for
  ILI lifetime purposes. ``i_pincount`` remains for preventing
  inode writeback while pinned, but is no longer load-bearing for
  ILI liveness.

AIL reference
  Acquired: on first AIL insertion (``test_and_set_bit(IN_AIL)``
  returns 0 → ``lockref_get()``). Moving within AIL does not
  change the refcount.
  Released: after AIL removal — the caller drops via
  ``lockref_put_or_lock()`` after the AIL lock is released.

Note: there is no buffer attachment reference. As described in
design principle #4, the ILI's presence on the buffer's
``b_li_list`` is always covered by one of the above three
references. The ILI holds a reference to the buffer (via
``xfs_buf_hold``), not the reverse.

Note: the transaction reference and CIL pin reference overlap
briefly during commit. The sequence is: ``iop_pin`` (+1) then
``iop_committing`` (-1), so the total refcount does not drop
during the commit window.


Reference Continuity Across Transaction Rolls
----------------------------------------------

When a transaction is rolled (via ``xfs_trans_roll_inode()`` or
``xfs_defer_trans_roll()``), the old transaction is committed
and the inode is re-joined to a new transaction. The commit
drops the old transaction reference (via ``iop_committing``),
and the re-join must acquire a new one. There is a window
between these two events where the ILI must remain alive.

The current code implicitly relies on the CIL pin reference
(taken by ``iop_pin`` before ``iop_committing`` runs) to keep
the ILI alive across this window. However, depending on an
implicit side-effect of CIL pinning for ILI liveness is fragile
— it couples the reference model to CIL implementation details
and makes the lifecycle harder to reason about.

Instead, we make the reference handoff explicit by taking a
"hold" reference before the roll and transferring it to the new
transaction context via a new ``xfs_trans_irejoin()`` helper.

``xfs_defer_save_resources()`` and ``xfs_trans_roll_inode()``
currently log the inode (ensuring it is dirty) before committing.
At this save point, we take an explicit hold reference:

.. code-block:: c

  /* In xfs_defer_save_resources, for each held inode: */
  xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
  xfs_log_item_get(&ili->ili_item);     /* hold ref for rejoin */
  dres->dr_ip[dres->dr_inos++] = ip;

  /* In xfs_trans_roll_inode: */
  xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
  xfs_log_item_get(&ip->i_itemp->ili_item);  /* hold ref for rejoin */

The hold reference keeps the ILI alive across the commit. The
commit sequence is:

1. ``iop_pin``: +1 (CIL pin ref)
2. ``iop_committing``: -1 (drops trans ref)
3. Refcount = hold ref + CIL pin ref (at minimum)

After the commit, the inode is re-joined to the new transaction
using ``xfs_trans_irejoin()`` instead of ``xfs_trans_ijoin()``:

.. code-block:: c

  /*
   * Re-join an inode to a new transaction after a roll. The caller
   * holds a reference to the ILI that is transferred to the new
   * transaction as its transaction reference. Unlike xfs_trans_ijoin(),
   * this does not need to look up or allocate the ILI — it is known
   * to exist and be alive because the caller holds a reference.
   */
  void
  xfs_trans_irejoin(
      struct xfs_trans    *tp,
      struct xfs_inode    *ip)
  {
      struct xfs_inode_log_item *iip = ip->i_itemp;

      xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
      ASSERT(iip != NULL);
      ASSERT(iip->ili_lock_flags == 0);

      /* Caller's hold reference becomes the transaction reference */
      iip->ili_dirty_flags = 0;
      xfs_trans_add_item(tp, &iip->ili_item);
  }

``xfs_trans_irejoin()`` does not call ``lockref_get()`` — the
caller's hold reference IS the new transaction reference. This
makes the reference transfer explicit and avoids any dependency
on CIL pin timing.

The rejoin is done unconditionally, regardless of whether the
roll succeeded or failed. ``xfs_trans_roll()`` always returns a
new transaction even on failure, and the caller cancels that
transaction on error. The cancel calls ``iop_release`` on all
joined items, which drops the transaction reference (i.e. the
transferred hold reference). This means no special error
handling is needed for the hold reference — it is always
consumed by either a successful commit or an error cancel of
the new transaction.

``xfs_defer_restore_resources()`` already re-joins
unconditionally (regardless of roll error). It calls
``xfs_trans_irejoin()`` instead of ``xfs_trans_ijoin()`` for
saved inodes:

.. code-block:: c

  /* In xfs_defer_restore_resources: */
  for (i = 0; i < dres->dr_inos; i++)
      xfs_trans_irejoin(tp, dres->dr_ip[i]);

``xfs_trans_roll_inode()`` is updated to also rejoin
unconditionally, matching the ``xfs_defer_trans_roll()`` pattern:

.. code-block:: c

  int
  xfs_trans_roll_inode(
      struct xfs_trans    **tpp,
      struct xfs_inode    *ip)
  {
      int     error;

      xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
      xfs_log_item_get(&ip->i_itemp->ili_item);
      error = xfs_trans_roll(tpp);
      xfs_trans_irejoin(*tpp, ip);
      return error;
  }

On success, the caller continues using the new transaction with
the inode joined. On failure, the caller cancels the new
transaction, which releases all items including the re-joined
inode — the hold reference is dropped by ``iop_release`` during
the cancel.


ILI Get/Put Wrappers
====================

The ILI needs type-specific get/put wrappers that follow the
generic log item lookup model described in the "Log Item Lookup
and Detachment via lockref + cmpxchg" section of
``log-item-refcount-design.rst``.

``xfs_inode_item_get(ip)`` loads ``ip->i_itemp``, checks it for
NULL, and if non-NULL calls ``lockref_get_not_dead()`` to
conditionally acquire a reference. It returns the ILI pointer on
success or NULL if there is no ILI or the ILI is dying. The
caller must ensure the inode itself remains valid (VFS ref, ILOCK,
or other structural guarantee).

``xfs_inode_item_put(iip)`` drops a reference via
``xfs_log_item_put()``. If this is the last reference, the
lockref spinlock is held on return and the caller must detach
from the inode, mark dead, and free.


Access Pattern Classification
=============================

Every current access to the ILI falls into one of these categories,
each with a different reference management strategy:

1. Existence check optimisation (NULL check, no dereference)
2. State read under lockref spinlock
3. Context-guaranteed stable access (caller prevents races)
4. Transaction-based modification (holds ILOCK)
5. IO completion state modification (no ILOCK)
6. Flush state modification (holds ILOCK + IFLUSHING)
7. Abort/shutdown state modification
8. Structural queries (AIL ordering)

The following sections describe each pattern and how it maps to
the new lifecycle model.


Pattern 1: Existence Check Optimisation
---------------------------------------

These contexts check ``ip->i_itemp != NULL`` to determine whether
a more expensive operation is needed. They do not dereference the
ILI pointer — they use the NULL/non-NULL result purely as a
fast-path filter to avoid unnecessary work on clean inodes.

Current callers:

- ``xfs_file_fsync()``: checks ``ip->i_itemp`` then calls
  ``xfs_fsync_flush_log()``
- ``xfs_log_force_inode()``: checks ``ip->i_itemp`` then reads
  ``ili_commit_seq``

These checks do not need a reference. The ``ip->i_itemp`` NULL
check is exactly the same situation as the initial pointer load
in the ``_get()`` wrapper — we do not call
``lockref_get_not_dead()`` if the pointer is NULL. The check is
a valid existence optimisation and can be left unchanged.

It is only once the caller proceeds to dereference the ILI
pointer (e.g. to read ``ili_commit_seq``) that an existence
guarantee is needed. That happens inside the called function
(e.g. ``xfs_fsync_flush_log()``), which must use the ``_get()``
wrapper to acquire a reference before accessing ILI fields.
See Pattern 2.


Pattern 2: State Read Under Lockref Spinlock
--------------------------------------------

These contexts read multiple related fields that must be
consistent with each other, currently using ``ili_lock`` to
serialise.

Current callers:

- ``xfs_fsync_flush_log()``: reads either ``ili_datasync_seq`` or
  ``ili_commit_seq`` under ``ili_lock``
- ``xfs_bmbt_to_iomap()``: reads ``ili_datasync_seq`` under
  ``ili_lock`` to set IOMAP_F_DIRTY
- ``xfs_iunpin()``: reads ``ili_commit_seq`` under ``ili_lock``

Converted pattern:

.. code-block:: c

  /* xfs_bmbt_to_iomap example */
  iip = xfs_inode_item_get(ip);
  if (iip) {
      spin_lock(&iip->ili_item.li_ref.lock);
      if (iip->ili_datasync_seq)
          iomap->flags |= IOMAP_F_DIRTY;
      spin_unlock(&iip->ili_item.li_ref.lock);
      xfs_inode_item_put(iip);
  }

Note: ``xfs_iunpin()`` is called with ILOCK held and the inode is
dirty (it was just logged in a transaction), so the ILI is
guaranteed to be alive. It can use ``lockref_get()`` (unconditional)
rather than ``lockref_get_not_dead()``. However, using the wrapper
is still correct and clearer.


Pattern 3: Context-Guaranteed Stable Access
-------------------------------------------

These contexts access ``ip->i_itemp`` and dereference it to read
ILI state, but do so in a context where the caller has guaranteed
that ``ip->i_itemp`` cannot change during the access. No reference
is needed because the caller's context prevents both concurrent
creation and concurrent removal of the ILI.

The key example is ``xfs_inode_clean()``, which checks
``!ip->i_itemp || !(ip->i_itemp->ili_fields & XFS_ILOG_ALL)``.
This dereferences ``ip->i_itemp`` to read ``ili_fields`` without
taking a lock or reference. This is safe because every caller
provides two guarantees:

a. **No concurrent creation.** The caller holds ILOCK (shared or
   exclusive), which prevents any new ``xfs_trans_ijoin()`` from
   allocating and attaching a new ILI. If ``ip->i_itemp`` is NULL,
   it will remain NULL for the duration of the access.

b. **No concurrent removal.** The caller holds ``XFS_IFLUSHING``
   on the inode, which prevents IO completion from running
   ``xfs_iflush_finish()`` and tearing down the ILI. If
   ``ip->i_itemp`` is non-NULL, it will remain valid for the
   duration of the access.

Together, these two guarantees ensure ``ip->i_itemp`` is stable:
it is either NULL (and stays NULL) or points to a valid, live ILI
(and stays that way). No ``_get()`` wrapper or lockref operation
is needed.

Current callers and their guarantees:

``xfs_iflush_cluster()`` (``xfs_inode.c``):
  Holds ILOCK_SHARED on each inode in the cluster. Sets
  ``XFS_IFLUSHING`` on each inode before checking
  ``xfs_inode_clean()``. ILOCK prevents new modifications from
  creating an ILI, and IFLUSHING prevents IO completion from
  removing one.

``xfs_reclaim_inode()`` (``xfs_icache.c``):
  Holds ILOCK_EXCL and has set ``XFS_IFLUSHING``. At this point
  the inode has been checked for pincount == 0 (so no CIL
  activity), and IFLUSHING prevents writeback races. If the
  inode is clean, reclaim proceeds; if dirty, reclaim is
  deferred.

``xfs_reclaim_inode()`` assert (``xfs_icache.c``):
  The ``ASSERT(xfs_inode_clean(ip))`` after reclaim processing
  runs when the inode is being freed — no concurrent access is
  possible.

This pattern can remain unchanged with dynamic ILI lifecycle.
The ILOCK + IFLUSHING combination that callers already provide
is exactly the guarantee needed to ensure ``ip->i_itemp``
stability without reference counting.


Pattern 4: Transaction-Based Modification
-----------------------------------------

Transaction operations hold ILOCK_EXCL on the inode, providing
structural serialisation against other transactions and against
inode reclaim. The ILI is either created or referenced at
``xfs_trans_ijoin()`` time and released at commit/abort.

Current callers:

- ``xfs_trans_ijoin()``: lazy-allocates ILI, sets lock_flags
- ``xfs_trans_log_inode()``: accumulates dirty_flags
- ``xfs_inode_item_precommit()``: merges dirty state under ili_lock,
  attaches cluster buffer
- ``xfs_inode_item_committing()``: sets commit_seq under ili_lock,
  releases ILOCK
- ``xfs_inode_item_release()``: releases ILOCK (clean item / abort)
- ``xfs_ifree()``: clears owner change flags under ili_lock

Converted pattern for ``xfs_trans_ijoin()``:

.. code-block:: c

  iip = xfs_inode_item_get(ip);    /* try existing */
  if (!iip) {
      xfs_inode_item_init(ip, mp); /* allocates with refcount 1 */
      iip = ip->i_itemp;
  }
  /* iip now has transaction reference */

The transaction reference is acquired in ``xfs_trans_ijoin()`` (either
via the new allocation giving refcount 1, or via
``lockref_get_not_dead()`` on the existing ILI). It is released by
``iop_committing`` or ``iop_release``.

For ``xfs_inode_item_precommit()``, the lockref spinlock replaces
``ili_lock`` directly:

.. code-block:: c

  spin_lock(&iip->ili_item.li_ref.lock);
  if (!iip->ili_item.li_buf) {
      spin_unlock(&iip->ili_item.li_ref.lock);
      /* read cluster buffer */
      spin_lock(&iip->ili_item.li_ref.lock);
      iip->ili_item.li_buf = bp;
      ...
  }
  iip->ili_fields |= (flags | iip->ili_last_fields);
  spin_unlock(&iip->ili_item.li_ref.lock);

No additional reference is taken when attaching the buffer.
The buffer attachment is covered by the transaction reference
(currently held) which chains into the CIL pin and AIL
references. See design principle #4.

For ``xfs_inode_item_committing()``:

.. code-block:: c

  spin_lock(&iip->ili_item.li_ref.lock);
  iip->ili_commit_seq = seq;
  if (iip->ili_dirty_flags & ...)
      iip->ili_datasync_seq = seq;
  spin_unlock(&iip->ili_item.li_ref.lock);
  iip->ili_dirty_flags = 0;
  xfs_inode_item_release(lip);
  /* drop transaction reference */
  if (xfs_inode_item_put(iip))
      xfs_inode_item_teardown(iip);

For ``xfs_ifree()``:

.. code-block:: c

  /* ILOCK_EXCL held, ILI guaranteed alive */
  spin_lock(&iip->ili_item.li_ref.lock);
  iip->ili_fields &= ~(XFS_ILOG_AOWNER | XFS_ILOG_DOWNER);
  spin_unlock(&iip->ili_item.li_ref.lock);


Pattern 5: IO Completion State Modification
-------------------------------------------

IO completion runs in softirq context without ILOCK. This is the
critical path where the lockref unification pays off: the state
cleanup and potential last-reference drop are atomic.

Current callers:

- ``xfs_iflush_finish()``: under ili_lock, checks ili_fields,
  detaches from buffer if clean, clears last_fields/flush_lsn/
  FLUSHING
- ``xfs_iflush_ail_updates()``: batch AIL delete under AIL lock
- ``xfs_buf_inode_iodone()``: orchestrates the above

The IO completion path in ``xfs_iflush_finish()`` currently does:

1. Lock ili_lock
2. Check if inode is clean (ili_fields == 0)
3. If clean: detach from buffer (li_buf = NULL, list_del)
4. Clear ili_last_fields, ili_flush_lsn, LI_FLUSHING
5. Unlock ili_lock
6. Clear XFS_IFLUSHING on inode
7. If detached: drop ILI's buffer reference

Converted pattern:

.. code-block:: c

  spin_lock(&iip->ili_item.li_ref.lock);
  ASSERT(iip->ili_item.li_buf == bp);
  if (!iip->ili_fields) {
      iip->ili_item.li_buf = NULL;
      list_del_init(&iip->ili_item.li_bio_list);
      drop_buffer = true;
  }
  iip->ili_last_fields = 0;
  iip->ili_flush_lsn = 0;
  clear_bit(XFS_LI_FLUSHING, &iip->ili_item.li_flags);
  spin_unlock(&iip->ili_item.li_ref.lock);
  xfs_iflags_clear(iip->ili_inode, XFS_IFLUSHING);
  if (drop_buffer)
      xfs_buf_rele(bp);

No ILI reference is dropped here — the buffer detach only drops
the ILI's reference to the buffer, not a reference to the ILI.
The ILI's liveness during ``xfs_iflush_finish()`` is guaranteed
by the AIL reference (see design principle #3).

AIL reference handling in ``xfs_iflush_ail_updates()``:

This is a batch operation under the AIL lock. The AIL reference
is the last reference to the ILI in the normal clean-inode case
(transaction ref and CIL pin ref have long since been released).
Dropping it is the point where the ILI may reach refcount 0 and
be torn down.

However, ``xfs_iflush_ail_updates()`` runs BEFORE
``xfs_iflush_finish()`` in ``xfs_buf_inode_iodone()``. If the
AIL ref drop triggers teardown, ``xfs_iflush_finish()`` would
access freed memory when it iterates the same list.

Resolution: the AIL reference drop must be deferred until after
``xfs_iflush_finish()`` has completed all ILI access. The
sequence in ``xfs_buf_inode_iodone()`` becomes:

1. ``xfs_iflush_ail_updates()``: remove items from AIL, but do
   NOT drop the AIL reference yet. Items that were removed are
   flagged (e.g. via a bit or a separate list).
2. ``xfs_iflush_finish()``: detach clean inodes from buffer,
   clear flush state. All ILI access is now complete.
3. Drop AIL references for items removed in step 1. This is where
   the last reference may drop and teardown occurs.

.. code-block:: c

  /* In xfs_buf_inode_iodone: */
  xfs_iflush_ail_updates(ailp, &ail_updates);
  /* items removed from AIL but AIL refs not yet dropped */

  list_splice_tail(&ail_updates, &flushed_inodes);
  xfs_iflush_finish(bp, &flushed_inodes);
  /* all ILI state access complete */

  /* now safe to drop AIL references */
  list_for_each_entry_safe(lip, n, &ail_updates, li_bio_list) {
      if (was_removed_from_ail(lip)) {
          if (xfs_log_item_put(lip))
              xfs_inode_item_teardown(INODE_ITEM(lip));
      }
  }

If the inode was re-dirtied during writeback, the inode will have
been relogged: ``flush_lsn != li_lsn``, so it is NOT removed from
the AIL. ``xfs_iflush_finish()`` sees ``ili_fields != 0`` and does
NOT detach from the buffer. The ILI remains alive with the AIL
reference from the relog. No ref drop occurs.

If the inode is clean but was NOT removed from the AIL (e.g.
``flush_lsn != li_lsn`` due to a concurrent AIL move), the AIL
ref is still held. ``xfs_iflush_finish()`` detaches from buffer
and drops the ILI's buffer reference, but the ILI stays alive
via the AIL ref until a subsequent IO completion removes it.


Pattern 6: Flush State Modification
------------------------------------

The flush path (``xfs_iflush()``) runs with ILOCK_EXCL or
ILOCK_SHARED + IFLUSHING. It copies inode data to the buffer and
then atomically moves ``ili_fields → ili_last_fields``.

Current code:

.. code-block:: c

  spin_lock(&iip->ili_lock);
  iip->ili_last_fields = iip->ili_fields;
  iip->ili_fields = 0;
  set_bit(XFS_LI_FLUSHING, &iip->ili_item.li_flags);
  spin_unlock(&iip->ili_lock);
  xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
                          &iip->ili_item.li_lsn);

Converted: direct spinlock substitution:

.. code-block:: c

  spin_lock(&iip->ili_item.li_ref.lock);
  iip->ili_last_fields = iip->ili_fields;
  iip->ili_fields = 0;
  set_bit(XFS_LI_FLUSHING, &iip->ili_item.li_flags);
  spin_unlock(&iip->ili_item.li_ref.lock);
  xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
                          &iip->ili_item.li_lsn);

No refcount changes here — the ILI is alive because the
transaction that dirtied it took a reference, and the CIL pin
also holds one. The flush path runs between CIL pin and IO
completion.

``xfs_ifree_mark_inode_stale()`` also modifies fields under
``ili_lock`` (moving ``ili_fields → ili_last_fields`` for dirty
non-flushing inodes). Same direct substitution with the lockref
spinlock.


Pattern 7: Abort/Shutdown State Modification
--------------------------------------------

Abort paths clear all ILI state and remove from AIL. They occur
during shutdown, stale inode handling, or IO error processing.

``xfs_iflush_abort()``:

Current:

1. ``xfs_trans_ail_delete()`` — remove from AIL
2. ``spin_lock(&iip->ili_lock)``
3. Read ``li_buf``, call ``xfs_iflush_abort_clean()``
4. ``spin_unlock(&iip->ili_lock)``
5. Clear IFLUSHING, release buffer

Converted:

.. code-block:: c

  bool removed = xfs_trans_ail_delete(&iip->ili_item, 0);

  spin_lock(&iip->ili_item.li_ref.lock);
  bp = iip->ili_item.li_buf;
  xfs_iflush_abort_clean(iip);
  spin_unlock(&iip->ili_item.li_ref.lock);

  xfs_iflags_clear(ip, XFS_IFLUSHING);

  /* drop ILI's buffer reference */
  if (bp)
      xfs_buf_rele(bp);

  /* drop AIL ref — may be the last reference */
  if (removed) {
      if (xfs_inode_item_put(iip))
          xfs_inode_item_teardown(iip);
  }

The only ILI reference dropped here is the AIL reference (if the
item was in the AIL). There is no buffer attachment reference —
the ILI holds a reference to the buffer, not the reverse. The
state cleanup under the lockref spinlock (``xfs_iflush_abort_clean``)
must be done before the AIL ref drop, because after the AIL ref
drop the ILI may be freed.

``xfs_iflush_shutdown_abort()``:

This function has a complex lock dance: take ili_lock, read li_buf,
take buf reference, drop ili_lock, lock buffer, retake ili_lock.
With lockref:

.. code-block:: c

  spin_lock(&iip->ili_item.li_ref.lock);
  bp = iip->ili_item.li_buf;
  if (!bp) {
      spin_unlock(&iip->ili_item.li_ref.lock);
      xfs_iflush_abort(ip);
      return;
  }
  xfs_buf_hold(bp);
  spin_unlock(&iip->ili_item.li_ref.lock);
  xfs_buf_lock(bp);

  spin_lock(&iip->ili_item.li_ref.lock);
  if (!iip->ili_item.li_buf) {
      /* raced with another removal */
      xfs_iflush_abort_clean(iip);
      spin_unlock(&iip->ili_item.li_ref.lock);
      xfs_iflags_clear(ip, XFS_IFLUSHING);
      xfs_buf_relse(bp);
      return;
  }
  spin_unlock(&iip->ili_item.li_ref.lock);
  xfs_iflush_abort(ip);
  xfs_buf_relse(bp);

The caller of ``xfs_iflush_shutdown_abort()`` holds a VFS
reference to the inode (it's accessed via the inode cache during
shutdown), which prevents the inode from being freed. The ILI
may be freed during the abort, but that's fine — we don't access
it after the abort returns.


Pattern 8: Structural Queries (AIL Ordering)
--------------------------------------------

``xfs_lock_inodes()`` / ``xfs_lock_two_inodes()``:

These read ``ip->i_itemp->ili_item.li_flags`` (XFS_LI_IN_AIL) for
lock ordering. Currently they dereference ``ip->i_itemp`` without
any NULL check, which is a latent bug — the ILI is only guaranteed
to exist if the inode has been dirtied in a transaction. In
practice, these are called during operations where all inodes have
been joined to a transaction, so ``i_itemp`` is non-NULL.

With dynamic lifecycle, these callers hold the ILOCK on the inode
they're checking. A dirty ILI with a transaction reference cannot
be torn down while the ILOCK is held (the transaction reference
is dropped by ``iop_committing`` which also unlocks the ILOCK).
So the dereference is safe and no get/put is needed.

However, ``xfs_lock_inodes()`` checks previously-locked inodes'
``i_itemp`` to decide whether to trylock subsequent inodes. The
previously-locked inodes may not have been joined to a transaction
yet (they're locked for a rename, for example), but they do hold
ILOCK. If the inode has never been dirtied, ``i_itemp`` is NULL,
and the ``lp && test_bit(...)`` check handles that correctly —
it is the same existence check optimisation as Pattern 1.


i_pincount Interaction
======================

The current ``i_pincount`` serves dual duty:

1. Prevents inode writeback while modifications are pinned in the
   CIL (checked in ``xfs_inode_item_push`` and ``xfs_iflush_cluster``)
2. Implicitly prevents inode reclaim while the ILI is in the CIL
   (reclaim asserts ``i_pincount == 0``)

With explicit ILI references, the CIL pin reference on the ILI
handles #2 directly. ``i_pincount`` remains for #1 — it is the
mechanism that prevents the AIL push from triggering writeback
while the inode's modifications are still in the CIL.

The ``atomic_dec_and_lock`` in ``xfs_inode_item_unpin()`` currently
atomically drops pincount and takes ``ili_lock`` to clear the
commit sequence numbers. With lockref:

.. code-block:: c

  if (atomic_dec_and_lock(&ip->i_pincount,
                          &iip->ili_item.li_ref.lock)) {
      iip->ili_commit_seq = 0;
      iip->ili_datasync_seq = 0;
      spin_unlock(&iip->ili_item.li_ref.lock);
      wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
  }
  /* then drop CIL pin reference */
  if (xfs_inode_item_put(iip))
      xfs_inode_item_teardown(iip);

The ``atomic_dec_and_lock`` uses the lockref spinlock, so the
commit_seq clearing is still serialised. The CIL pin reference
drop is separate — it may or may not be the last reference.


Refcount Lifecycle Traces
=========================

Normal transaction → flush → IO completion (inode stays clean):

::

  xfs_trans_ijoin:    alloc ILI, refcount = 1 (trans ref)
  iop_precommit:      attach buffer (no ref change)
  iop_pin:            refcount = 2 (+ CIL pin ref)
  iop_committing:     refcount = 1 (- trans ref)
  AIL insert:         refcount = 2 (+ AIL ref)
  iop_unpin:          refcount = 1 (- CIL pin ref)
  --- inode is in AIL with refcount 1 (AIL ref only) ---
  xfs_iflush:         no refcount change (just moves field state)
  IO completion:
    iflush_finish:    detach from buffer (no ref change, just drops
                      ILI's buffer reference via xfs_buf_rele)
    drop AIL ref:     refcount = 0 → teardown → free

Note: the AIL ref drop is deferred until after ``xfs_iflush_finish()``
completes all ILI access, so the ILI is alive for the entire IO
completion sequence.

Re-dirtied during writeback:

::

  --- ILI has refcount 1 (AIL ref), first flush in progress ---
  xfs_trans_ijoin:    get existing ILI, refcount = 2 (+ trans ref)
  iop_precommit:      buffer already attached (no ref change)
  iop_pin:            refcount = 3 (+ CIL pin ref)
  iop_committing:     refcount = 2 (- trans ref)
  AIL insert (move):  no refcount change (already in AIL)
  iop_unpin:          refcount = 1 (- CIL pin ref)
  --- original IO completes ---
  iflush_finish:      ili_fields != 0 (re-dirtied), buffer NOT detached
  ail_updates:        flush_lsn != li_lsn (relogged), NOT removed from AIL
                      no AIL ref dropped, refcount stays 1
  --- subsequent flush + IO for the new dirty state ---
  iflush_finish:      ili_fields == 0, detach from buffer
  drop AIL ref:       refcount = 0 → teardown → free

Multiple rapid re-dirties:

::

  Initial: alloc, trans, pin, commit, AIL, unpin → refcount 1 (AIL ref)

  Re-dirty #1: trans_ijoin +1 (2), pin +1 (3), committing -1 (2),
               AIL move +0, unpin -1 (1)
  IO complete: no AIL removal (relogged) → still 1

  Re-dirty #2: trans_ijoin +1 (2), pin +1 (3), committing -1 (2),
               AIL move +0, unpin -1 (1)
  IO complete: AIL remove, deferred ref drop → 0 → teardown

Shutdown while in CIL:

::

  After commit: refs = CIL pin (1). AIL ref not yet taken.
  CIL abort: iop_unpin drops CIL pin ref → refcount 0 → teardown
  (Item was never in AIL, no AIL ref to drop. Buffer attachment
  is cleaned up as part of teardown — ILI drops its buffer ref.)

Shutdown after AIL insertion:

::

  After CIL checkpoint: refs = AIL ref (1). CIL pin already dropped.
  xfs_iflush_abort: removes from AIL, cleans state, drops ILI's
                    buffer reference.
  Drop AIL ref: refcount = 0 → teardown → free

Stale inode (cluster freed):

::

  iop_committed returns -1 → not inserted into AIL (no AIL ref)
  iop_committed calls iop_unpin → drops CIL pin ref → refcount 0
  → teardown → free
  (Buffer attachment is cleaned up as part of teardown.)

Note: the stale case is straightforward because the CIL pin ref is
the only reference at the point ``iop_committed`` runs (the
transaction ref was already dropped by ``iop_committing``, and no
AIL ref was taken because ``iop_committed`` returned -1 to prevent
AIL insertion).


Teardown Sequence
=================

When ``xfs_inode_item_put()`` returns true (last reference), the
caller holds the lockref spinlock. Teardown must:

1. ``lockref_mark_dead()`` — prevents any new ``get_not_dead()``
2. ``cmpxchg(&ip->i_itemp, iip, NULL)`` — detach from inode.
   If cmpxchg fails, a concurrent ``xfs_trans_ijoin()`` already
   allocated and attached a new ILI (this can happen if the dying
   ILI's last ref was the CIL unpin, and a new transaction on the
   same inode raced). The old ILI is effectively detached.
3. Drop the lockref spinlock
4. ``kvfree(iip->ili_item.li_lv_shadow)``
5. ``kmem_cache_free(xfs_ili_cache, iip)``

.. code-block:: c

  static void
  xfs_inode_item_teardown(
      struct xfs_inode_log_item *iip)
  {
      struct xfs_inode *ip = iip->ili_inode;

      /* lockref spinlock held on entry (from put_or_lock) */
      ASSERT(!iip->ili_fields);
      ASSERT(!iip->ili_last_fields);
      lockref_mark_dead(&iip->ili_item.li_ref);
      cmpxchg(&ip->i_itemp, iip, NULL);
      spin_unlock(&iip->ili_item.li_ref.lock);

      kvfree(iip->ili_item.li_lv_shadow);
      kmem_cache_free(xfs_ili_cache, iip);
  }

The asserts verify that the ILI is fully quiesced before teardown:
no dirty fields, no pending flush state. These are invariants — if
any context still has work to do with the ILI, it would hold a
reference and we would not reach teardown. The buffer detach
(``li_buf = NULL``, list removal) and the ILI's buffer reference
drop (``xfs_buf_rele``) must be done by the caller before reaching
teardown, since the teardown path does not handle buffer cleanup.


xfs_trans_ijoin() Allocation Race
=================================

With dynamic ILI lifecycle, two threads can race:

Thread A: IO completion drops last ref → teardown begins
Thread B: ``xfs_trans_ijoin()`` → ``xfs_inode_item_get()``

Scenario 1: Thread B calls ``lockref_get_not_dead()`` BEFORE
Thread A calls ``lockref_mark_dead()``:
  - Thread B gets a reference (success). Thread A's
    ``lockref_put_or_lock()`` returned false (not last ref).
  - No race. Thread B reuses the existing ILI.

Scenario 2: Thread B calls ``lockref_get_not_dead()`` AFTER
Thread A calls ``lockref_mark_dead()``:
  - Thread B's ``lockref_get_not_dead()`` returns false.
  - Thread B allocates a new ILI.
  - Thread B attaches via ``cmpxchg(&ip->i_itemp, old, new)``.
    If ``old == dying_iip``, cmpxchg succeeds (Thread A's cmpxchg
    in teardown will see the new value and know it was superseded).
    If ``old == NULL`` (Thread A already detached), cmpxchg
    succeeds trivially.
  - If ``old`` is something else (another thread already attached a
    new ILI), Thread B's cmpxchg fails. Thread B frees its new ILI
    and retries ``xfs_inode_item_get()``.

Scenario 3: Thread A and Thread B both in teardown (impossible):
  - Only one thread can be "the last ref" via lockref_put_or_lock().

This ensures lock-free, race-free ILI lifecycle management.


Inode Reclaim Interaction
=========================

Current reclaim (``xfs_inode_free_callback()``) asserts the ILI
is not in the AIL, then calls ``xfs_inode_item_destroy()``. With
dynamic lifecycle:

- If the inode is clean at reclaim time, the ILI has already been
  freed by the IO completion teardown. ``ip->i_itemp`` is NULL.
  No action needed.

- If ``ip->i_itemp`` is non-NULL at reclaim, it means the ILI is
  still alive. This should only happen if the inode was never
  flushed (e.g. it was dirtied but then the filesystem shut down
  before flush). The existing assertions (not in AIL, pincount 0)
  still apply. The reclaim path drops the inode's implicit "owner"
  reference — but with the new model, there IS no owner reference
  per se. The inode pointer is just a lookup path, not a reference.

  Resolution: at reclaim time, if ``ip->i_itemp`` is non-NULL, the
  ILI must have refcount 0 or be dead (all references were dropped
  during shutdown cleanup). We can assert this and then free
  directly, or just check for NULL and skip if already freed:

.. code-block:: c

  if (ip->i_itemp) {
      ASSERT(!test_bit(XFS_LI_IN_AIL,
                       &ip->i_itemp->ili_item.li_flags));
      /* ILI should have been freed by teardown, but shutdown may
       * leave it stranded. Force-free it here. */
      xfs_inode_item_destroy(ip);
  }

In the shutdown case, the ILI may still be attached because the
shutdown abort path cleared its state but other references (from
the CIL abort) may have been the ones to actually drop the last
ref. Need to verify the shutdown teardown ordering ensures the
ILI is freed before reclaim runs. The RCU callback delay for
reclaim provides a grace period.

Actually, reclaim is ordered: IRECLAIM is set under i_flags_lock,
then the inode is removed from the radix tree, then
``call_rcu()`` defers ``xfs_inode_free_callback()``. All
active references (CIL, AIL, transactions) must have completed
before the inode reaches the reclaim path. So if the ILI is still
attached at ``xfs_inode_free_callback()`` time, it must be a
stranded item from shutdown. The existing ``xfs_inode_item_destroy()``
is the correct cleanup.


Summary of ili_lock → lockref Spinlock Mapping
===============================================

Every current use of ``spin_lock(&iip->ili_lock)`` maps directly
to ``spin_lock(&iip->ili_item.li_ref.lock)``:

==================================  ======================================
Current ili_lock use                 Notes on conversion
==================================  ======================================
precommit: merge dirty state         Direct substitution.
committing: set commit_seq           Direct substitution. Transaction ref
                                     dropped after unlock.
unpin: clear commit_seq              ``atomic_dec_and_lock`` with lockref
                                     spinlock. CIL pin ref dropped after.
iflush: move fields                  Direct substitution.
iflush_finish: check/clear fields    Direct substitution. ILI's buffer ref
                                     (xfs_buf_rele) dropped after unlock.
iflush_abort: clean state            Direct substitution. AIL ref dropped
                                     after unlock and buffer cleanup.
iflush_shutdown_abort: lock dance    Direct substitution (same dance with
                                     lockref spinlock).
ifree_mark_inode_stale: move fields  Direct substitution.
ifree: clear owner fields            Direct substitution.
xfs_iunpin: read commit_seq          Direct substitution.
xfs_fsync_flush_log: read seq        Direct substitution.
xfs_bmbt_to_iomap: read seq          Direct substitution.
xfs_log_force_inode: read seq        Direct substitution.
==================================  ======================================


Implementation Steps
====================

1. **Add li_ref lockref to xfs_log_item** (generic infrastructure,
   shared with BLI/intent item conversions). Init in
   ``xfs_log_item_init()``. No behaviour change.

2. **Add xfs_inode_item_get/put wrappers.** Initially they just
   wrap the raw pointer access with lockref_get_not_dead. No
   callers changed yet.

3. **Replace ili_lock with lockref spinlock in all accessors.**
   Mechanical substitution — change ``&iip->ili_lock`` to
   ``&iip->ili_item.li_ref.lock`` in all 14 call sites. Remove
   ``spin_lock_init(&iip->ili_lock)`` from ``xfs_inode_item_init``
   (lockref init handles it). Remove ``ili_lock`` from the struct.
   No behaviour change beyond which lock is acquired.

4. **Add CIL pin reference.** In ``iop_pin``, add ``lockref_get()``.
   In ``iop_unpin``, add ``lockref_put_or_lock()`` after the
   ``i_pincount`` handling. If last ref, call teardown.

5. **Add AIL reference.** In the AIL insertion path, add
   ``lockref_get()`` when ``test_and_set_bit(IN_AIL)`` transitions
   0→1. In ``xfs_iflush_ail_updates()`` and ``xfs_iflush_abort()``,
   drop the AIL ref after AIL removal. If last ref, call teardown.
   Note: in ``xfs_buf_inode_iodone()``, the AIL ref drop must be
   deferred until after ``xfs_iflush_finish()`` completes.

6. **Add transaction reference management.** In ``xfs_trans_ijoin``,
   use ``xfs_inode_item_get()`` instead of raw ``ip->i_itemp``
   access. New ILI allocation starts with refcount 1. In
   ``iop_committing`` and ``iop_release``, add ref drop. If last
   ref, call teardown.

7. **Add xfs_inode_item_teardown.** Implements mark_dead + cmpxchg
   detachment + free. Called from any put that returns true (last
   ref).

8. **Convert read-only accessors.** ``xfs_fsync_flush_log``,
   ``xfs_bmbt_to_iomap``, ``xfs_log_force_inode``: use get/put
   wrapper around ILI access. ``xfs_inode_clean``: keep lockless
   (safe per analysis above).

9. **Remove xfs_inode_item_destroy.** It is replaced by teardown.
   Keep a stripped version for the reclaim-time stranded ILI
   cleanup (shutdown case only).

10. **Remove ili_lock field from struct.** Already removed in step 3.

11. **Update assertions.** Remove ``ASSERT(ip->i_itemp != NULL)``
    in paths that now use the get wrapper. Keep assertions in paths
    where liveness is structurally guaranteed (e.g. transaction
    context that has joined the inode).


Open Questions
==============

1. **xfs_inode_item_precommit buffer read lock drop.** The current
   code drops ``ili_lock``, reads the cluster buffer, reacquires
   ``ili_lock``. With lockref, dropping the spinlock is fine — the
   transaction reference prevents teardown. But is the lockref
   ``lock`` field safe to drop and reacquire while the refcount is
   > 0? Yes — the lockref spinlock is just a spinlock; the special
   lockref semantics only apply to the ``lockref_*`` functions.
   Holding the spinlock directly is the same as any spinlock.

2. **Performance of get/put on hot paths.** The lockref fast path
   uses ``cmpxchg`` for get/put, avoiding the spinlock in the
   common case. This should be comparable to the current
   ``atomic_inc``/``atomic_dec`` on ``i_pincount``. Measure on
   real workloads.

3. **Inode reclaim ordering.** Need to verify that all ILI
   references are guaranteed to be dropped before the RCU callback
   runs ``xfs_inode_free_callback()``. The current model guarantees
   this via IRECLAIM + pincount == 0 + not-in-AIL. With refcounting,
   the guarantee is: all holders of ILI references observe the inode
   state changes (IRECLAIM, etc.) and drop their references before
   the RCU grace period expires.

4. **xfs_lock_inodes i_itemp dereference.** Should add a NULL check
   for robustness, even though current callers guarantee non-NULL.
   This is a pre-existing issue, not specific to this conversion.
