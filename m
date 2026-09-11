Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A07532C8B;
	Fri, 11 Sep 2026 00:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789086393; cv=none; b=V+08ZH23sfHPth/1jMSAdaSMeH3rmQm57yAX97hn4/+nGm0evwFkFpn9sw/oHpR06QCWTgUYQ5wpVbKq8CVDGYY/Kcy1nYHAXg4CeU95DmXeFAPh8WqMjjv93EZP7n/+iI/NYX8H+khW9sWIwPXYMmRorojz7UZWmb12Jme8RBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789086393; c=relaxed/simple;
	bh=es2soI+mOEzUo/G11w/uP/P6lfSU4QqqbP0Im6vSpxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJjnyAFIsPRMDQJdDJ04ydXSghP+l8Ho6WmiEnnHIEqCv9xV6aNHiwxFKxh/Bo2qTbIlwr9eyKtZFNlmcLn3/6Qq6MoLRdOg81HHsIyvqnuF8odia0KJXKQQUrpqjARv1vChA23rz4PhIgXR+b4xsMq72R+TYdBsklk/crk07cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hzMfGuGG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzMfGuGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086261F00899;
	Fri, 11 Sep 2026 00:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789086389;
	bh=1qRG86mRgcoD2BzsSo3aBqL/WLsCbYbKeXYjJSrVfcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hzMfGuGGNy3GdavFn0g4Y7B1roYfjZ14NuC4mXQrE/YCTL00KffOPISNjX43YrpGH
	 2Td8creMpCHp4XDRs0cNkv5sEcgPdB45p2um51+kqrBTDbra6z2s3B+jGUTG/AjQjV
	 mODPbmKrwYuvSqhRmS1I30XNIgLAhH67dpRlW70aNCjfQFpZgV4RsIj0b+a1I1wAW8
	 wjpDhmOBdWXB2VSCVmREBL8zZpPOMHzGCkULU5du4zZMi3Eqj0Z/hMF+ycpSCFWpQJ
	 MI5DMdn+lRwpjqBHekmlLK91eXs7ulGu8/+OGV3J/rkl/lHD7syRmQVB4PVaUhKQBZ
	 6XPdHYqRpyf0Q==
Date: Fri, 11 Sep 2026 10:26:20 +1000
From: Dave Chinner <dgc@kernel.org>
To: Jeffin Philip <jeffinphilip14@gmail.com>
Cc: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzbot+a4fde844548510369112@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] KASAN: slab-use-after-free Write in
 xlog_cil_ail_insert
Message-ID: <aqNKrCgDQD9nZ5sm@dread>
References: <aqI6v-_dc2DDSbgB@dread>
 <20260910154725.18960-1-jeffinphilip14@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260910154725.18960-1-jeffinphilip14@gmail.com>

On Thu, Sep 10, 2026 at 09:17:25PM +0530, Jeffin Philip wrote:
> On Wed, Sep 09, 2026, Dave Chinner wrote:
> 
> >The short term fix is to slap a bandaid on xfs_buf_submit() to wait
> >for unpin before erroring out a pinned buffer on shutdown. That,
> >however, doesn't fix the underlying lack of full lifecycle reference
> >counts for log items.
> >
> >The long term fix is have the AIL require a reference count to be
> >held on log items it tracks, and only have that refcount removed
> >when the item is removed from the AIL. That's a much bigger rework
> >of the code. 
> >
> >FYI, I've attached two document below - the design for
> >generic full lifecycle log item reference counting, and the design
> >for converting the inode log item to be dynamic similar to the buf
> >log item so we don't end up with millions of ILIs that are never
> >used left sitting around in memory until it's owner inode is
> >reclaimed.
> 
> I read the documents and have started writing the wrappers. Is anyone
> else working on it?

Go ahead, but I wouldn't get too deep into it before any level of
design review has been performed.

FWIW, I've attached below the BLI lifecycle analysis I performed and
documented for the last one of these BLI UAF syzbot reports. If
should help give some background knowledge and insight into how
complex the log item interactions with the rest of the code are and
help people understand why I'm proposing we move to a generic log
item reference counting model.

It will also show that my previous analysis (which was trying to
work out how the READ IO completion path ran a write IO completion)
missed the xfs_buf_submit -> shutdown -> run completion on pinned
buffer code -> UAF in CIL shutdown processing path noted by this
syzbot report.

i.e. I analysed the AIL writeback path through
xfs_buf_delwri_submit(), but that doesn't allow pinned buffers into
the delwri buffer list. It didn't occur to me at the time there were
other paths to xfs_buf_delwri_submit() that could contain dirty
pinned buffers in the buffer list....

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org

============================================
XFS Buffer Log Item (BLI) Lifecycle Analysis
============================================

This documents the lifecycle of a buffer log item (xfs_buf_log_item)
from transaction acquisition through CIL commit, AIL management, and
writeback IO completion.


Reference Counting Model
========================

The BLI uses an atomic refcount (bli_refcount) with the following
unusual properties:

1. The BLI can exist with bli_refcount == 0 when it is resident in
   the AIL. The AIL does not hold a BLI reference — it tracks the
   item via the li_ail list linkage, and the buffer's b_log_item
   pointer keeps the BLI accessible.

2. The pin operation (iop_pin) takes a BLI reference plus a buffer
   hold and a buffer pin. The unpin operation (iop_unpin) drops all
   three. This means the BLI is guaranteed to exist while pinned,
   but once unpinned and inserted into the AIL, only the AIL linkage
   and b_log_item pointer keep it alive.

3. The BLI is freed in xfs_buf_item_relse(), which asserts refcount
   == 0 and the item is NOT in the AIL before detaching from the
   buffer and freeing the structure.

4. A BLI can be simultaneously resident in the AIL and the CIL.
   This happens when a buffer is dirtied by a new transaction while
   a prior checkpoint's version of the BLI is still in the AIL
   awaiting writeback. The new transaction re-pins the BLI into
   the current CIL context while the AIL still tracks it from the
   previous checkpoint.

5. Multiple active CIL references can exist at the same time. Each
   CIL context that the BLI is first inserted into takes a pin
   reference (bli_refcount + 1). If a buffer is dirtied across
   multiple CIL checkpoints before any of them complete, the BLI
   will have a pin reference from each outstanding checkpoint plus
   the current transaction's reference. The refcount only reaches
   0 when all checkpoints have completed and all transactions have
   committed.


Phase 1: Transaction Acquisition
================================

Entry: xfs_trans_get_buf_map() or xfs_trans_read_buf_map():

1. Look up buffer in the buffer cache (xfs_buf_get_map / xfs_buf_read).

2. Check if the buffer is already joined to this transaction via
   xfs_trans_buf_item_match(). If found, increment bli_recur and
   return the buffer — the existing BLI and its transaction reference
   are reused.

3. For a new buffer, call ``_xfs_trans_bjoin()``, which calls
   ``xfs_buf_item_init()`` followed by taking a transaction reference.

``xfs_buf_item_init()`` has two cases:

- No existing BLI (``bp->b_log_item == NULL``):

  - Allocate a new BLI via kmem_cache_zalloc (bli_refcount initialised to 0),
  - initialise the log item, attach to ``bp->b_log_item``
  - take a buffer hold (``xfs_buf_hold``).

- Existing BLI (``bp->b_log_item != NULL``):

  - The BLI is reused.
  - This occurs when a prior transaction dirtied the buffer and the BLI is still
    tracking it.
  - The existing BLI's refcount depends on its current state:

    - refcount == 0: the BLI is only resident in the AIL. All prior CIL
      checkpoints that pinned it have completed and unpinned it. The BLI
      is awaiting writeback.
    - refcount > 0: the BLI is resident in the CIL (pinned by one or more
      checkpoints that have not yet completed). It may also simultaneously
      be in the AIL from an earlier checkpoint.

In both cases, ``xfs_buf_item_init()`` returns immediately without
modifying the BLI or its refcount.

After ``xfs_buf_item_init()`` returns, ``_xfs_trans_bjoin()`` then:

- ``atomic_inc(&bip->bli_refcount)`` — takes the transaction's reference.
  For a newly allocated BLI this is 0 → 1. For a reused BLI this
  increments whatever the current refcount is.
- Adds the BLI to the transaction's item list.
- Sets ``bp->b_transp = tp``.

State after acquisition:

- bli_refcount >= 1 (transaction reference)
- Buffer is locked and held
- BLI may or may not be in the AIL (from prior transaction)
- bli_recur tracks recursive gets within the same transaction


Phase 2: Transaction Modifications
==================================

``xfs_trans_log_buf(tp, bp, first, last)``:

- Calls ``xfs_trans_dirty_buf()`` which sets:

  - XFS_BLI_DIRTY and XFS_BLI_LOGGED on bli_flags
  - XFS_LI_DIRTY on the log item

- Marks the specific byte range dirty in the BLI's bitmap

``xfs_trans_dirty_buf(tp, bp)``:

- Sets XBF_DONE on the buffer
- Sets XFS_BLI_DIRTY | XFS_BLI_LOGGED
- If buffer was previously stale, clears stale state

``xfs_trans_binval(tp, bp)``:

- Sets XFS_BLI_STALE on the BLI
- Sets XBF_STALE on the buffer
- Sets XFS_BLF_CANCEL in the on-disk format
- Clears the dirty bitmap (the buffer content won't be logged)
- Marks as dirty/logged in the transaction (so it flows through CIL)

``xfs_trans_bhold(tp, bp)``:

- Sets XFS_BLI_HOLD — prevents buffer unlock at transaction commit
- Used when the caller needs the buffer to remain locked across
  transaction boundaries (e.g. btree cursor holding a buffer while
  rolling a transaction)


Phase 3: Transaction Commit — CIL Insertion
===========================================

``xfs_trans_commit()`` calls ``xlog_cil_commit()`` which:

#. For each dirty log item (including dirty BLIs):

   - Calls ``iop_size()`` and ``iop_format()`` to prepare log vectors
   - Inserts the formatted log vector into the CIL context

#. Pin (``xfs_buf_item_pin``) called the FIRST time an item enters a
   CIL context (``li_lv == NULL``):

   - ``xfs_buf_hold(bp)`` — take a buffer reference for the pin
   - ``atomic_inc(&bli_refcount)`` — take the pin's BLI reference
   - ``atomic_inc(&bp->b_pin_count)`` — pin the buffer against writeback

   State: bli_refcount >= 2 (transaction + pin)

#. iop_committing (xfs_buf_item_committing) — called for every item
   after CIL insertion, while still holding cil->xc_ctx_lock:

   - Calls ``xfs_buf_item_release()`` which:

     - Clears ``bp->b_transp = NULL``
     - Clears ``XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED``
     - ``atomic_dec(&bli_refcount)`` — drops the transaction's reference
     - If refcount reaches 0:

       - Stale: calls ``xfs_buf_item_finish_stale()`` (see stale handling)
       - Aborted/shutdown: calls ``xfs_buf_item_done()`` to remove from AIL
       - Clean (not dirty): calls ``xfs_buf_item_relse()`` to free BLI
       - Dirty: asserts BLI is in AIL (normal case after checkpoint
         completion has already run — see race discussion)

     - If not HOLD and not stale: ``xfs_buf_relse()`` (unlock + release)

   Normal case after commit: ``bli_refcount == 1`` (pin reference only),
   buffer is unlocked and released (but still held by pin reference).

   CRITICAL: The iop_committing callback runs AFTER CIL insertion
   and pin, but the CIL checkpoint can start (and complete!) before
   iop_committing runs. This means:

   - The item may have already been unpinned (refcount dropped by
     unpin) before iop_committing drops the transaction reference
   - The item may have already been inserted into the AIL and be
     at refcount 0 (AIL-resident, no active references) before
     iop_committing runs
   - For stale buffers, this race is particularly important because
     the last reference drop must perform completion processing


Phase 4: CIL Checkpoint — Journal Write
=======================================

When the CIL is pushed (xlog_cil_push_work):

#. The CIL context is switched and items are collected.

#. The checkpoint is written to the journal.

#. On journal IO completion (xlog_cil_committed):

   - For each item in the checkpoint:

     - Insert into the AIL via xfs_trans_ail_update_bulk()
     - Call iop_unpin(lip, 0) — normal unpin

#. Unpin (xfs_buf_item_unpin, remove=0):

   - freed = atomic_dec_and_test(&bli_refcount) — drops pin reference
   - atomic_dec(&bp->b_pin_count) — unpin buffer, wake waiters
   - If refcount > 0 (transaction reference still held — race case):

     - Just drop the buffer reference (xfs_buf_rele) and return

   - If refcount == 0 (normal case — transaction already committed):

     - Non-stale: drop the buffer pin reference (xfs_buf_rele)
       The BLI is now in the AIL with refcount == 0.
     - Stale: drop extra buf ref, call xfs_buf_item_finish_stale(),
       then xfs_buf_relse() the buffer

   State after unpin (normal): bli_refcount == 0, item in AIL,
   buffer unpinned and available for writeback.

   CRITICAL: The BLI now exists with refcount == 0. The only things
   keeping it alive are:

   - bp->b_log_item pointer
   - AIL list linkage (li_ail)

   Any code that accesses the BLI must either hold the buffer lock
   or the AIL lock to prevent the BLI from being freed underneath it.


Phase 5: AIL Writeback
======================

The AIL periodically pushes items toward the log tail. For BLIs, it calls
``xfs_buf_item_push()``:

- Called with AIL lock held
- Checks if buffer is pinned — returns XFS_ITEM_PINNED if so
- Tries to lock the buffer (trylock) — returns XFS_ITEM_LOCKED if it can't
- If buffer is locked:

  - Adds buffer to the delwri queue (xfs_buf_delwri_queue)
  - Unlocks the buffer
  - Returns XFS_ITEM_FLUSHING

The buffer then sits on the delwri queue unlocked until the AIL
submits the queue. At submission time, the buffer is relocked and
rechecked — if it has been repinned (by a new transaction dirtying
it between push and submission) or otherwise cannot be written, the
IO is skipped. If the checks pass, the IO is submitted.

There is a significant window between iop_push() and actual IO
submission where the buffer is unlocked but the item is in the
ITEM_FLUSHING state. During this window:

- bli_refcount == 0 (assuming no active CIL pins)
- The buffer is unlocked and accessible to new transactions
- A new transaction can lock the buffer, find the existing BLI,
  join it (incrementing refcount 0 → 1), dirty it, and commit —
  which re-pins the BLI into the CIL
- The delwri submission will detect the re-pin and skip the IO

No BLI reference is taken for writeback. The BLI's existence is
guaranteed because:

- It's in the AIL (xfs_buf_item_relse asserts not-in-AIL)
- xfs_buf_item_done() is only called from IO completion, which
  only occurs after IO has been successfully submitted


Phase 6: IO Completion
======================

xfs_buf_ioend() — called when buffer IO completes. The buffer is
locked for the entire duration of IO completion processing — it was
locked at IO submission time and remains locked until xfs_buf_ioend()
completes and the buffer is unlocked/released. This means
xfs_buf_item_done() and xfs_buf_item_relse() always run under the
buffer lock, which serialises BLI freeing against any other code that
holds the buffer lock and accesses the BLI.

#. For write completions:

   - If error: calls error handler (xfs_buf_ioend_handle_error)
   - If success:

     - Clears retry state
     - If bp->b_log_item exists: calls xfs_buf_item_done(bp)

#. xfs_buf_item_done():

   - xfs_trans_ail_delete() — removes BLI from AIL
   - xfs_buf_item_relse() — frees the BLI:

     - Asserts bli_refcount == 0
     - Asserts not in AIL (just removed)
     - Clears bp->b_log_item = NULL
     - xfs_buf_rele(bp) — drops the BLI's buffer hold (from init)
     - Frees the BLI structure

State after IO completion: BLI is freed. Buffer's b_log_item is NULL. Buffer may
still exist in the cache for future use.


Stale Buffer Lifecycle
======================

Stale buffers (xfs_trans_binval) have a special lifecycle because the
buffer must remain locked from the time it's marked stale until all
completion processing is done. This prevents the stale buffer from
being found in the cache and used by another thread.

The stale path:

#. xfs_trans_binval() marks BLI stale, sets XFS_BLF_CANCEL

#. At CIL insertion (Phase 3b), the BLI is pinned normally.

#. At iop_committing (Phase 3c, xfs_buf_item_release):

   - The transaction drops its reference
   - If this was the last reference (refcount → 0):

     - Calls xfs_buf_item_finish_stale() — removes from AIL, frees BLI
     - Calls xfs_buf_relse(bp) — unlocks and releases the buffer
     - Returns immediately — no further processing

   - If pin reference still exists (normal case):

     - Does NOT unlock the buffer (stale flag prevents unlock)
     - Returns with buffer still locked — the pin/unpin path owns it

#. At checkpoint completion (Phase 4d, xfs_buf_item_unpin):

   - Drops pin reference
   - If this was the last reference (refcount → 0):

     - Drops extra buffer ref
     - Calls xfs_buf_item_finish_stale() — removes from AIL, frees BLI
     - Calls xfs_buf_relse(bp) — unlocks and releases the buffer

#. Race between committing and completing:
   Either iop_committing or iop_unpin can be the last reference
   holder. Whichever drops refcount to 0 performs the stale
   completion. The buffer remains locked until that point.

   The race exists because the CIL checkpoint can complete (triggering
   unpin) before the transaction commit finishes calling iop_committing.
   The stale buffer protocol handles this by:

   - Never unlocking the buffer at iop_committing if stale and
     the pin reference still exists
   - Having the last reference dropper always perform completion
   - Completion always unlocks the buffer as its final step


Race Windows and Invariants
===========================

R1. CIL checkpoint completion vs. iop_committing race:

    The CIL checkpoint can complete (calling iop_unpin) before the
    committing transaction finishes calling iop_committing. When this
    happens:

    For normal (non-stale) buffers:
      - iop_unpin drops pin reference: refcount → 1 (transaction ref)
      - iop_unpin sees refcount > 0, just drops buffer ref and returns
      - BLI is now in the AIL with refcount 1
      - iop_committing later runs xfs_buf_item_release:

        - Drops transaction ref: refcount → 0
        - BLI is dirty and in AIL: leaves it alone (line 748-749)
        - Unlocks buffer (normal release path)

    For stale buffers:
      - iop_unpin drops pin reference: refcount → 1
      - iop_unpin sees refcount > 0, drops buffer ref and returns
      - Buffer is still locked (stale protocol)
      - iop_committing runs xfs_buf_item_release:

        - Drops transaction ref: refcount → 0
        - Stale: calls xfs_buf_item_finish_stale()
        - xfs_buf_relse() unlocks and releases buffer

    OR (opposite ordering):
      - iop_committing drops transaction ref: refcount → 1 (pin ref)
      - Buffer is NOT unlocked (stale flag prevents it at line 757)
      - iop_unpin drops pin ref: refcount → 0
      - Stale: calls xfs_buf_item_finish_stale()
      - xfs_buf_relse() unlocks and releases buffer

R2. AIL push vs. IO completion race:

    The AIL pushes a buffer for writeback via iop_push, which adds
    it to the delwri queue and unlocks it. Later the delwri submission
    relocks the buffer, rechecks state, and submits IO. The buffer
    remains locked from IO submission through IO completion and
    xfs_buf_item_done(). This means:

    - A subsequent AIL push (iop_push) will trylock the buffer and
      fail with XFS_ITEM_LOCKED while IO is in flight
    - xfs_buf_item_done() runs under the buffer lock, so it cannot
      race with any code that also holds the buffer lock
    - Between iop_push unlock and delwri relock, the buffer is
      accessible — but xfs_buf_item_done() cannot run during this
      window because IO has not been submitted yet

R3. xfs_buf_item_put() with zero refcount and AIL residency:

    When xfs_buf_item_put() drops refcount to 0, it checks whether
    the BLI is in the AIL (line 622). If it is, the BLI remains alive
    with refcount 0 — the AIL residency keeps it logically active even
    though no code holds a counted reference.

    This is the most unusual aspect of the model. The BLI at refcount
    0 in the AIL is only protected by:

    - The buffer lock (must be held for IO completion to free it)
    - The AIL lock (protects the AIL list)

    Any code accessing a BLI must ensure one of these locks is held.

R4. Transaction re-acquisition of an AIL-resident BLI:

    When a new transaction gets a buffer that already has a BLI in the
    AIL (refcount 0), xfs_buf_item_init() finds the existing BLI and
    returns early. _xfs_trans_bjoin() then increments bli_refcount
    from 0 → 1. This is safe because the buffer is locked at this
    point, preventing concurrent IO completion from freeing the BLI.


BLI Reference Count Summary
===========================

Event                           bli_refcount change
-----                           ----------------------
_xfs_trans_bjoin()              +1 (transaction reference)
xfs_buf_item_pin()              +1 (CIL pin reference)
xfs_buf_item_release()          -1 (transaction reference dropped)
xfs_buf_item_unpin()            -1 (CIL pin reference dropped)
xfs_buf_item_done()             asserts == 0, then frees

Normal lifecycle refcount trace:
    0 → 1 (trans join) → 2 (CIL pin) → 1 (trans commit/release) →
    0 (CIL unpin, AIL insert) → freed (IO completion)

The BLI exists at refcount 0 between CIL unpin and IO completion.
During this window, the BLI is in the AIL and the buffer is
available for writeback. Only the buffer lock protects the BLI
from being freed by IO completion while other code accesses it.


Buffer Reference Summary
========================

Event                           bp reference change
-----                           ----------------------
xfs_buf_item_init()             +1 hold (BLI's reference to buffer)
xfs_buf_item_pin()              +1 hold (pin's reference)
xfs_buf_item_unpin()            -1 rele (pin's reference)
xfs_buf_item_relse()            -1 rele (BLI's reference, at free)
xfs_buf_item_release()          -1 relse (unlock+rele, if not hold/stale)

The buffer always has at least one reference from the BLI (taken
at init, released at relse) ensuring the buffer cannot be freed
while the BLI exists. Additional references from pins and
transaction holds ensure the buffer survives through the pipeline.


Inode Buffer Interactions
=========================

Inode buffers have several special properties that make their BLI
lifecycle more complex than regular metadata buffers.


Inode Buffer Types
------------------

There are three distinct buffer marking functions used during
different stages of inode buffer lifecycle:

xfs_trans_inode_buf(tp, bp):
  Marks the buffer as an inode buffer (XFS_BLI_INODE_BUF). This
  tells recovery to only replay the di_next_unlinked fields from
  the buffer, not the full inode contents. This is set when logging
  unlinked list modifications to an inode cluster buffer. Also sets
  bp->b_iodone = xfs_buf_inode_iodone.

xfs_trans_inode_alloc_buf(tp, bp):
  Marks the buffer as containing newly allocated inodes
  (XFS_BLI_INODE_ALLOC_BUF). This flag has special AIL insertion
  behaviour — see xfs_buf_item_committed() below. Also sets
  bp->b_iodone = xfs_buf_inode_iodone.

xfs_trans_stale_inode_buf(tp, bp):
  Marks the buffer as a stale inode buffer (XFS_BLI_STALE_INODE).
  Used during xfs_ifree_cluster() when freeing an entire inode
  cluster. Also sets bp->b_iodone = xfs_buf_inode_iodone.


Inode Allocation Buffer AIL Pinning
-----------------------------------

xfs_buf_item_committed() returns a special LSN for inode allocation
buffers. When a buffer with XFS_BLI_INODE_ALLOC_BUF is subsequently
relogged as an XFS_BLI_INODE_BUF (i.e. only the di_next_unlinked
fields are logged), the iop_committed callback returns the original
LSN rather than the new checkpoint's LSN. This keeps the buffer
pinned at its original position in the AIL.

This is necessary because:

- The original allocation log entry contains the full inode images
- The relog only contains di_next_unlinked updates
- If the buffer were moved forward in the AIL to the relog's LSN,
  the original allocation record could be overwritten in the log
- Recovery needs the full inode images from the allocation to
  initialise the inode cluster; without them, recovery fails


Inode Item Push Through Inode Cluster Buffer
--------------------------------------------

When the AIL pushes an inode item (xfs_inode_item_push), it does NOT
write the inode directly. Instead:

1. It locks the inode's cluster buffer (lip->li_buf, set during
   xfs_inode_item_precommit)
2. Takes a buffer hold (xfs_buf_hold) for the flush operation
3. Calls xfs_iflush_cluster(bp) to flush all dirty inodes in the
   cluster into the buffer
4. Queues the buffer for delwri writeback (xfs_buf_delwri_queue)
5. Releases the buffer (xfs_buf_relse)

xfs_iflush_cluster() iterates all inode items on bp->b_li_list,
flushing each dirty inode into the buffer via xfs_iflush(). The
b_li_list tracks inode log items attached to the buffer, not buffer
log items — this is separate from the BLI tracked via b_log_item.

The cluster buffer may also have a BLI (b_log_item) if the buffer
was logged for unlinked list updates. In this case, both the BLI and
multiple inode items are tracked on the same buffer, but through
different mechanisms:

- BLI: bp->b_log_item (single BLI for buffer-level changes)
- Inode items: bp->b_li_list (list of inode items for inode-level
  changes flushed into the buffer)


IO Completion for Inode Buffers
-------------------------------

When IO completes on an inode buffer, xfs_buf_ioend() runs:

1. If bp->b_log_item exists: calls xfs_buf_item_done() to handle
   the BLI (removes from AIL, frees BLI — standard Phase 6)
2. If bp->b_iodone is set (xfs_buf_inode_iodone): calls it to
   handle all inode items on bp->b_li_list

xfs_buf_inode_iodone() processes each inode item:

- Stale inodes (XFS_ISTALE): calls xfs_iflush_abort() to clean up
- Flushed inodes: updates AIL position, clears flush state

The BLI completion (step 1) and inode item completion (step 2) both
run under the buffer lock during IO completion. They do not race with
each other.


xfs_iflush_cluster() Failure and xfs_buf_fail() Race
----------------------------------------------------

When xfs_iflush_cluster() encounters an error (e.g. corruption
detected during inode flush), it:

1. Calls xfs_force_shutdown() to shut down the filesystem
2. Calls xfs_buf_fail(bp) to simulate IO completion with -EIO

xfs_buf_fail() is called with the buffer locked. It marks the buffer
stale, sets -EIO, and calls xfs_buf_ioend(). This runs the full IO
completion path including xfs_buf_item_done() (for the BLI) and
xfs_buf_inode_iodone() (for attached inode items).

Race with BLI push: xfs_iflush_cluster() is called from
xfs_inode_item_push(), which is the inode item's AIL push callback.
This runs with the buffer locked and the AIL lock dropped. The
buffer's BLI may have already been pushed for writeback by a prior
AIL push (xfs_buf_item_push). Consider:

1. AIL pushes the BLI via xfs_buf_item_push():

   - Locks buffer, queues to delwri list, unlocks buffer
   - Returns XFS_ITEM_FLUSHING

2. AIL pushes an inode item on the same buffer via
   xfs_inode_item_push():

   - Locks buffer (succeeds because BLI push unlocked it)
   - Calls xfs_iflush_cluster() which fails
   - Calls xfs_buf_fail(bp)
   - xfs_buf_ioend() runs xfs_buf_item_done() — frees the BLI

3. Meanwhile the delwri queue still references this buffer. When
   delwri submission relocks the buffer, the BLI has already been
   freed by the xfs_buf_fail() path. The buffer is now stale so
   delwri submission should detect this and skip it.

The reverse is also possible:

1. AIL pushes an inode item, xfs_iflush_cluster() succeeds
2. Buffer queued to delwri, unlocked
3. AIL pushes the BLI on the same buffer

   - BLI's iop_push locks the buffer, queues to delwri (or finds
     it already queued), unlocks

4. Both pushes want the same buffer written back — the delwri queue
   handles this because xfs_buf_delwri_queue() is idempotent for
   buffers already on the queue.


Inode Cluster Freeing (xfs_ifree_cluster)
-----------------------------------------

When an entire inode cluster is freed, xfs_ifree_cluster():

1. Gets the cluster buffer into the transaction (xfs_trans_get_buf)
2. Marks all cached inodes as XFS_ISTALE
3. Calls xfs_trans_stale_inode_buf() — sets XFS_BLI_STALE_INODE
4. Calls xfs_trans_binval() — marks buffer and BLI stale

The XFS_BLI_STALE_INODE flag causes special handling in
xfs_buf_item_finish_stale(). Instead of the normal stale BLI
cleanup, it:

- Calls xfs_buf_item_done() — removes BLI from AIL, frees it
- Calls xfs_buf_inode_iodone() — processes stale inode items,
  calling xfs_iflush_abort() for each to clean up their AIL state
- Asserts bp->b_li_list is empty after processing

This is necessary because stale inode buffers have inode items
attached that must also be cleaned up when the buffer is invalidated.
Normal stale buffer processing (xfs_buf_item_finish_stale without
STALE_INODE) only handles the BLI itself.


Shutdown Impact on Inode Buffer Processing
------------------------------------------

During shutdown, xfs_iflush_cluster() detects the shutdown state
(xlog_is_shutdown) for each inode it processes:

- Waits for the inode to be unpinned (xfs_iunpin_wait)
- Calls xfs_iflush_abort() to clean up the inode's AIL state
- Sets error = -EIO but continues processing remaining inodes
- After the loop, calls xfs_force_shutdown() + xfs_buf_fail()

The shutdown sequence in xfs_iflush_cluster is ordered deliberately:

1. xfs_force_shutdown() first — kills the log
2. xfs_buf_fail() second — fails the buffer

This ordering matters for INODE_ALLOC buffers because if the buffer
is failed before the log is shut down, the buffer unpin could allow
the ICREATE intent to be removed from the log. If the system crashes
after that but before the inode cluster is initialised on disk,
recovery would fail because the ICREATE intent is gone but the inode
cluster buffer was never written.


Shutdown Impact on BLI Lifecycle
================================

A filesystem shutdown (triggered by xfs_force_shutdown()) can occur at
any point during the BLI lifecycle. Shutdown is detected by testing
xlog_is_shutdown(log). Once set, shutdown state is permanent — it
never clears. The shutdown changes how BLIs are processed at every
stage of the lifecycle, introducing additional race windows between
normal completion paths and the shutdown-triggered abort paths.


Shutdown and Transaction Commit (Phase 3)
-----------------------------------------

xfs_buf_item_release() (called via iop_committing) checks for both
XFS_LI_ABORTED and xlog_is_shutdown(). If either is true and the
refcount drops to zero, it calls xfs_buf_item_done() to remove the
BLI from the AIL and free it, rather than leaving it in the AIL for
writeback.

This handles the case where a shutdown occurs after the BLI has been
inserted into the AIL by a prior checkpoint but before the current
transaction's commit completes. The BLI may be dirty and in the AIL,
but because we're shut down there's no point leaving it for writeback.

For stale buffers during shutdown, xfs_buf_item_release() can be
the last reference holder if the checkpoint aborted before unpinning.
In this case it calls xfs_buf_item_finish_stale() which removes from
the AIL and frees the BLI, then unlocks the buffer. This is the
same completion path as the normal stale case but triggered from
transaction commit rather than checkpoint completion.


Shutdown and CIL Checkpoint Completion (Phase 4)
------------------------------------------------

When a CIL checkpoint fails (journal IO error) or the log is already
shut down when xlog_cil_committed() runs, it sets abort = true.

xlog_cil_ail_insert() with abort:

- Sets XFS_LI_ABORTED on every log item in the checkpoint
- Does NOT insert items into the AIL
- Calls iop_unpin(lip, 1) with remove=true for each item

xfs_buf_item_unpin() with remove=true:

- Drops the BLI refcount and buffer pin count as normal
- If refcount > 0 (transaction ref still held): drops buffer ref
  and returns. The abort flag is set on the item for
  xfs_buf_item_release() to handle later.
- If refcount == 0 (transaction already committed):

  - For stale buffers: drops extra ref, calls finish_stale, unlocks
  - For non-stale: calls xfs_buf_fail(bp) which:

    - Locks the buffer
    - Marks it stale, sets -EIO
    - Calls xfs_buf_ioend() which runs xfs_buf_item_done()
    - This removes from AIL (or handles not-in-AIL) and frees BLI
    - The buffer is then released (async flag set by xfs_buf_fail)


Shutdown and IO Completion (Phase 6)
------------------------------------

xfs_buf_ioend_handle_error() checks xlog_is_shutdown() first. If the
log is shut down:

- Skips all retry logic
- Marks the buffer stale
- Returns false, allowing xfs_buf_ioend() to continue
- xfs_buf_ioend() then calls xfs_buf_item_done() which removes the
  BLI from the AIL and frees it

If a permanent IO error triggers a shutdown (xfs_force_shutdown in
xfs_buf_ioend_handle_error), subsequent error handling takes the
shutdown path.

For transient errors (not yet permanent, not yet shutdown):

- Sets XFS_LI_FAILED on the BLI's log item
- Clears XFS_LI_FLUSHING
- Releases the buffer (unlock + rele)
- The buffer is NOT freed — the BLI remains in the AIL
- The AIL will re-push the item later for retry


Shutdown and xfs_buf_item_put()
-------------------------------

xfs_buf_item_put() handles the case where a dirty BLI has refcount
dropping to 0 but is NOT in the AIL. This can happen when:

- A checkpoint aborted, setting XFS_LI_ABORTED on the BLI
- The BLI was never inserted into the AIL (abort skips AIL insert)
- A subsequent xfs_trans_brelse() releases a clean reference to the
  same buffer, calling xfs_buf_item_put()
- The refcount reaches 0 with a dirty, aborted BLI not in the AIL

In this case, xfs_buf_item_put() frees the BLI via
xfs_buf_item_relse(). It asserts that a dirty BLI not in the AIL
must have XFS_LI_ABORTED set.


Three-Way Shutdown Race: Stale Buffers
--------------------------------------

The most complex shutdown race involves stale buffers where three
events can race:

1. Transaction commit (iop_committing → xfs_buf_item_release)
2. Checkpoint completion (xlog_cil_ail_insert → iop_unpin)
3. Shutdown occurring concurrently

Scenario A — Shutdown during normal stale processing:

- Transaction commits, iop_committing drops refcount → 1 (pin ref)
- Buffer stays locked (stale protocol)
- Shutdown occurs
- Checkpoint completion runs with abort=true
- iop_unpin(remove=true) drops refcount → 0
- Stale path: drops extra ref, calls finish_stale, unlocks buffer

Result: Handled correctly — unpin is the last ref, does completion.

Scenario B — Shutdown before checkpoint completion:

- Checkpoint is written, but journal IO hasn't completed
- Shutdown occurs
- Transaction commit runs iop_committing:

  - Sees aborted or xlog_is_shutdown()
  - Drops refcount → 1 (pin ref still held)
  - Stale: does NOT unlock buffer (line 757)
  - Returns without doing completion

- Later, checkpoint abort runs iop_unpin(remove=true):

  - Drops refcount → 0
  - Stale: finish_stale, unlock buffer

Result: Handled correctly — unpin does completion.

Scenario C — Shutdown causes iop_committing to be last ref:

- Checkpoint completes BEFORE transaction finishes commit
- iop_unpin drops refcount → 1 (transaction ref)
- Buffer ref dropped, returns
- Shutdown occurs
- Transaction commit runs iop_committing:

  - Drops refcount → 0 (last ref)
  - Stale: calls xfs_buf_item_finish_stale()
  - xfs_buf_relse() unlocks and releases buffer

Result: Handled correctly — committing does completion.

Scenario D — Shutdown with already-aborted checkpoint:

- CIL push fails before journal IO starts
- Checkpoint runs xlog_cil_committed with abort=true
- XFS_LI_ABORTED set on BLI
- iop_unpin(remove=true) called:

  - If refcount → 0: stale finish or xfs_buf_fail()
  - If refcount > 0: drops ref, returns. Transaction commit
    will find LI_ABORTED and handle via xfs_buf_item_done()

Result: Handled correctly — either unpin or committing cleans up.

Key invariant: For stale buffers, exactly one of iop_committing or
iop_unpin will be the last reference holder. Whichever it is performs
completion processing. The buffer remains locked until that point,
preventing any other access. The shutdown state does not change this
fundamental invariant — it only determines which path runs last and
whether the XFS_LI_ABORTED flag is set.


Shutdown and AIL Writeback (Phase 5)
------------------------------------

When the filesystem is shut down, the AIL may still contain dirty
BLIs. The AIL push will still attempt to process them:

- xfs_buf_item_push() checks if the buffer is pinned. During
  shutdown, buffers may be unpinned by abort processing, making
  them eligible for push.
- The buffer is added to the delwri queue and unlocked.
- At delwri submission, xfs_buf_delwri_submit() relocks the buffer.
  If the filesystem is shut down, the IO submission will fail and
  xfs_buf_ioend_handle_error() takes the shutdown path, which
  marks the buffer stale and allows xfs_buf_item_done() to clean up.

Alternatively, the AIL can be emptied directly during shutdown via
the abort path in xlog_cil_ail_insert() which calls
iop_unpin(remove=true) → xfs_buf_fail() → xfs_buf_ioend() →
xfs_buf_item_done(). This removes BLIs from the AIL without
requiring actual writeback.


UAF Scenario Analysis: Syzbot BLI free during read IO
=====================================================

Observed scenario (syzbot, v7.1-rc3, 5 hits in 12 hours):

- Single-threaded application reads a buffer, BLI is created
- Later the same buffer is "read again", IO submitted, and
  xfs_buf_ioend for the read IO frees the BLI
- CIL push trips over the freed BLI → use-after-free
- Corruption detected at xfs_btree_lookup_get_block (xfs_bnobt
  block 0x8) shortly before
- KASAN "freed by" stack:
  kmem_cache_free ← __xfs_buf_ioend ← xfs_buf_iowait ←
  xfs_buf_read_map ← xfs_trans_read_buf_map ←
  xfs_btree_read_buf_block ← xfs_btree_lookup_get_block ←
  xfs_btree_lookup ← xfs_alloc_fixup_trees

Note: __xfs_buf_ioend is an older name for xfs_buf_ioend; there is
no difference in logic or lifecycle handling between versions.

Analysis of code paths:

1. Read IO completion cannot free a BLI.

   xfs_buf_ioend() branches on XBF_READ (line 1114). The read path
   (lines 1114-1123) runs the verifier and sets XBF_DONE on success.
   It does NOT call xfs_buf_item_done() or interact with the BLI in
   any way. Only the write/else path (lines 1124-1149) calls
   xfs_buf_item_done() at line 1145-1146.

   Therefore, for a read IO to free the BLI, xfs_buf_ioend() must
   take the write/else branch. This requires XBF_READ to NOT be set
   in b_flags when the check at line 1114 runs.

2. _xfs_buf_read() correctly sets XBF_READ.

   _xfs_buf_read() (line 618) does:

   .. code-block:: c

        bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
        bp->b_flags |= XBF_READ;

   This clears any write flags and sets XBF_READ before submitting
   the IO. For synchronous reads, XBF_ASYNC is cleared, so
   xfs_buf_iowait() runs xfs_buf_ioend() in the caller's context.

3. xfs_buf_submit() shutdown path preserves XBF_READ.

   If the log is shut down when xfs_buf_submit() runs (line 1379),
   it takes the ioerror path which clears XBF_DONE and stales the
   buffer (lines 1407-1408), but does NOT clear XBF_READ. For sync
   IO, it signals b_iowait completion (line 1413). xfs_buf_iowait
   then calls xfs_buf_ioend which still sees XBF_READ and takes the
   read path. No BLI freeing.

4. xfs_buf_fail() takes the write path.

   xfs_buf_fail() (line 1194) does NOT set XBF_READ. When it calls
   xfs_buf_ioend(), the write/else branch is taken, which calls
   xfs_buf_item_done() and frees the BLI. But xfs_buf_fail() is
   only called from shutdown/abort paths, not from the synchronous
   read chain shown in the KASAN stack.

5. xfs_buf_find_lock() resets stale buffers but preserves b_log_item.

   When a stale buffer is found in the cache (line 424), all flags
   except _XBF_KMEM are cleared and b_ops is set to NULL (lines
   430-431). But b_log_item is NOT cleared. This is correct — the
   BLI intentionally survives across stale events because:

   - The BLI tracks the buffer through its entire log lifecycle
   - The CIL always relogs the full dirty state on relog
   - The BLI pins the buffer in memory preventing reclaim
   - A stale+reinit+relog sequence produces the correct journal
     contents because the relog captures the new buffer contents

   After xfs_buf_find_lock clears XBF_STALE and XBF_DONE, a
   subsequent xfs_buf_read_map() will re-read the buffer from disk.
   This is expected — the buffer is being reinitialised with fresh
   on-disk contents. The BLI remains attached and will track any
   new modifications made by the transaction that reads it.

6. xfs_buf_reverify() cannot clear XBF_DONE on buffers with b_ops.

   xfs_buf_reverify() (line 649) returns immediately without doing
   anything if bp->b_ops is already set:

   .. code-block:: c

        if (!ops || bp->b_ops)
                return 0;

   A buffer that was previously read and dirtied through a
   transaction always has b_ops set from the original read. So
   reverify cannot be the mechanism that clears XBF_DONE on a
   dirty cached buffer. This eliminates reverify failure as a
   possible cause.

7. Readahead cannot clear XBF_DONE on a DONE buffer.

   xfs_buf_readahead_map() (line 757) checks XBF_DONE first. If
   set, it calls xfs_buf_reverify (which returns immediately if
   b_ops is set), then releases the buffer. The flag-clearing code
   at line 764 only runs for !DONE buffers. So readahead cannot
   modify a DONE buffer's state.


Exhaustive search for XBF_DONE clearing paths:

  XBF_DONE is cleared by:

  a. _xfs_buf_read() — line 618. This is the re-read itself.
  b. xfs_buf_submit() ioerror path — line 1407.
  c. xfs_buf_read_map() error path — line 718.
  d. xfs_buf_readahead_map() — line 764 (only for !DONE buffers).
  e. xfs_buf_reverify() — line 655 (only when b_ops was NULL and
     verifier fails; cannot occur on normally-used buffers).
  f. xfs_buf_find_lock() — line 430 (clears all flags on stale
     buffers; this is the normal reinitialisation path).
  g. xfs_buf_fail() — line 1200 (shutdown/abort path only).

  Of these, only (f) can clear XBF_DONE on a buffer with an active
  BLI during normal operation. This is expected behaviour — the stale
  buffer is being reinitialised, and the BLI correctly survives.


Conclusion:

No code path exists in the current kernel where read IO completion
in xfs_buf_ioend() can free a BLI. The read branch (XBF_READ set)
has no BLI interaction. The write/else branch (XBF_READ not set)
calls xfs_buf_item_done() which frees the BLI, but this branch
cannot be reached during a properly-flagged read IO.

The buffer is locked during the entire synchronous read path (from
_xfs_buf_read through xfs_buf_iowait and xfs_buf_ioend), preventing
concurrent modification of b_flags. No code within the locked read
path clears XBF_READ between _xfs_buf_read setting it (line 619)
and xfs_buf_ioend checking it (line 1114).

Given:

- Exhaustive code analysis shows no legitimate path for read IO
  to free a BLI
- The buffer lock prevents concurrent b_flags modification during
  synchronous read IO
- The bug was seen only 5 times in 12 hours on v7.1-rc3, never
  on any other kernel version
- The system was running syzbot with many concurrent tests

The most likely explanation is external memory corruption from an
unrelated kernel bug that stomped on the buffer's b_flags field,
clearing XBF_READ between _xfs_buf_read setting it and
xfs_buf_ioend checking it. With XBF_READ cleared, xfs_buf_ioend
takes the write/else branch, calls xfs_buf_item_done(), frees the
BLI, and the subsequent CIL access to the freed BLI triggers the
KASAN use-after-free report.

The corruption detection at xfs_btree_lookup_get_block ("xfs_bnobt
block 0x8") is likely a real error from the underlying filesystem
image having been intentionally corrupted as part of the syzbot
test, not related to the memory corruption that caused the UAF.

