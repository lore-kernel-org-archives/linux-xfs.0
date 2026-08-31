Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD645519A0;
	Mon, 31 Aug 2026 13:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184016; cv=none; b=YZsV19OoW8DpaiQEuB54uie4oDuw4/FwCs58wKjqDvHQpbs+FUfRi/CIo3f2S6GEAbA6fSu0roEas4a8FyvuO3VdwFS7BRLwzEBKjJIQBQmA9NeQMID+fFriRQmVjqtuAFoa6iDGet539syEsGDUwc/O1cWDXMg0yhQC9wy3xis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184016; c=relaxed/simple;
	bh=IRlAvzQXXWDR5b57cSwrrJ2mIJF6Etx2TbPxpMkujHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GID9azf1hxAAVQ1Lz1jRhdRL9SNywY3M4rimpu2YJvkqkXcE0/T+zWziQyOGMcpUosZhDQIriVYn6l2MRW0UTY379MxjY/sK29n8L/aIMGk06QF7ZpjroCWNheja8mj2GjP2tbTXtinP4oNkWEvgB3FtYVBaZsbbmKb0y6w2FFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kuLdf90v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kuLdf90v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F931F00ACA;
	Mon, 31 Aug 2026 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184012;
	bh=qkm3zZNL9HB2rqCSTJl17ZzY5ewOUI2Ek8PssKpYf1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuLdf90vHeYgFxUAKky7Lvw116F6nzKmYxnMUXIQwFrbpjLc/BKjph7sUZga8Adxz
	 Xo8W1g3z7YXqQNd2JqqaPsZDXI3AmK1RGtUhJskNnmENt7vn0PZgQl82DrwVW8hz7S
	 U3zfXqxJlNftX6sSDOt3/95QE7bi9rWGlXVypAHdrdZurkl0zekuKory7sZ03pqWSz
	 vP3a2xhj63QrGZH/gHNGYxgEAxTmTQqWkyhsSpU8XzIyTx5Bn19TkOF+LzOcCgnsBe
	 hkqlUtlbJbZcbS4HUuiUNDZuu8xKxF5FX578Hx/Urxl2fIBsK6kyqxd1DjKEl0Da+v
	 d+lmcjN48pT+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	axboe@kernel.dk,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] iomap: don't make REQ_POLLED imply REQ_NOWAIT
Date: Mon, 31 Aug 2026 09:27:45 -0400
Message-ID: <20260831133314.4125787-437-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 47f28b493daf9049307494689e515205f1c377af ]

As described in commit 2bc057692599 ("block: don't make REQ_POLLED imply
REQ_NOWAIT"), which fixed the same issue for the block device node, there
are valid cases to poll for I/O completion without REQ_NOWAIT.

Additionally, sing REQ_NOWAIT for file system writes is currently not
supported as file systems writes are not idempotent and would need a
retry of just the bio and not the entire operation to be fully supported.

Switch iomap to set REQ_POLLED and remove the now unused bio_set_polled
helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260518062917.506483-1-hch@lst.de
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `iomap: don't make REQ_POLLED imply
REQ_NOWAIT`

**Local tree:** Linux **6.18.43** (`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[iomap] [don't make / fix] [REQ_POLLED should not imply
REQ_NOWAIT on filesystem DIO bios]`

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** https://patch.msgid.link/20260518062917.506483-1-hch@lst.de
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Christoph Hellwig `<hch@lst.de>`, Christian Brauner
  `<brauner@kernel.org>` (merge commit)
- **Notable:** References upstream commit `2bc057692599` (block-layer
  companion fix). No syzbot, no user bug reports.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `bio_set_polled()` propagates `REQ_NOWAIT` onto bios when
  `IOCB_NOWAIT` is set. For iomap filesystem DIO this is incorrect —
  filesystem writes are not idempotent at the bio level and cannot be
  retried by re-submitting just the bio.
- **Symptom:** Polled filesystem DIO (e.g. io_uring
  `IORING_SETUP_IOPOLL` on xfs/ext4 O_DIRECT) can hit spurious `-EAGAIN`
  from the block layer, or fail to make progress — same class of bug
  fixed for raw block devices in 2023.
- **Root cause:** iomap reused `bio_set_polled()` which couples
  `REQ_POLLED` with conditional `REQ_NOWAIT`; block/fops.c was already
  fixed to decouple them, but iomap was not.
- **Version info:** Commit dated 2026-05-18; not yet in this 6.18.43
  tree.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit correctness fix, though
small. The removal of `bio_set_polled()` is cleanup after the last
caller is gone.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- `fs/iomap/direct-io.c`: 1 line changed (`bio_set_polled` →
  `bio->bi_opf |= REQ_POLLED`)
- `include/linux/bio.h`: 14 lines removed (`bio_set_polled()` helper +
  comment)
- **Functions modified:** `iomap_dio_submit_bio()`; `bio_set_polled()`
  removed
- **Scope:** Single-subsystem, 2 files, ~16 lines total — surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk 1 (`iomap_dio_submit_bio`):** Before: for async HIPRI DIO, call
  `bio_set_polled(bio, iocb)` which sets `REQ_POLLED` and also
  `REQ_NOWAIT` when `IOCB_NOWAIT` is set. After: only `REQ_POLLED` is
  set; `IOCB_NOWAIT` is handled separately at the iomap layer via
  `IOMAP_NOWAIT` (line 654–655).
- **Hunk 2 (`bio.h`):** Remove now-dead `bio_set_polled()` helper (only
  caller was iomap).

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Logic / correctness fix (incorrect flag propagation)
- **Mechanism:** `REQ_NOWAIT` on a bio causes the block layer to return
  `-EAGAIN` instead of blocking on resource contention
  (`__bio_queue_enter`, tag allocation in `blk-mq`). For filesystem DIO
  through iomap, `IOCB_NOWAIT` is already translated to `IOMAP_NOWAIT`
  for filesystem-level handling; passing `REQ_NOWAIT` to the block layer
  is both unnecessary and harmful for writes.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Obviously correct: mirrors the already-accepted block-layer fix
  pattern in `block/fops.c`.
- Minimal: one-line functional change plus dead-code removal.
- **Regression risk:** Very low. Block device path already uses the same
  pattern. `IOMAP_NOWAIT` continues to handle filesystem-level non-
  blocking semantics.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Shallow repository limits blame — all lines attribute to
`a112b91dd6349` (unrelated sunrpc backport). Verified current buggy code
exists at `fs/iomap/direct-io.c:77` and `include/linux/bio.h:688-693`.
Kernel.org history (via curl) shows iomap polled-IO support added in
`daa99c5a3319` (2023-08-01, Jens Axboe: "iomap: only set iocb->private
for polled bio"); block fix `2bc057692599` (2023-08-08) updated
`bio_set_polled()` but left iomap calling it.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag. Referenced commit `2bc057692599` ("block:
don't make REQ_POLLED imply REQ_NOWAIT") exists as a git object in this
tree; `block/fops.c` already uses the decoupled pattern (`IOCB_NOWAIT`
and `REQ_POLLED` set independently). iomap was the remaining caller of
`bio_set_polled()`.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Shallow repo prevents meaningful `git log` on these files.
External kernel.org log confirms this is a standalone 1-patch fix (not
part of a series). Related prior fix: `2bc057692599` (block layer,
2023).

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Christoph Hellwig is the iomap maintainer. Christian Brauner
is VFS maintainer who applied the patch. Strong subsystem authority.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No prerequisites. Self-contained. Depends only on existing
`IOCB_HIPRI`/polled-IO infrastructure already present in 6.18.43. Commit
`47f28b493daf` is NOT in this tree (object not found via `git cat-
file`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c` could not run — commit not in local repo.
Fetched via spinics.net:
- URL: https://www.spinics.net/lists/linux-fsdevel/msg338671.html
- Single patch, no series revisions found
- CC'd: `axboe`, `linux-block`, `linux-fsdevel`, `linux-xfs`, `djwong`,
  `brauner`

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** CC list includes block maintainer (Axboe), XFS, fsdevel,
block lists. Brauner applied to `vfs-7.2.iomap` branch. No explicit
Reviewed-by in commit; no NAKs found.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No bug report, syzbot, or crash trace. Bug identified by
code analysis and parity with the 2023 block-layer fix. Failure mode
inferred from block commit message: "repeated -EAGAIN submissions and
not make any progress."

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone 1/1 patch. Companion to `2bc057692599` (already
in stable block path).

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched (no stable nomination found in thread). Absence
of `Cc: stable` is not a negative signal per review guidelines.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `iomap_dio_submit_bio()`, `bio_set_polled()` (removed)

### Step 5.2: TRACE CALLERS
**Record:** `iomap_dio_submit_bio()` called from iomap DIO write/read
paths in `fs/iomap/direct-io.c`. Reachable via `iomap_dio_rw()` →
filesystem `read_iter`/`write_iter` on xfs, ext4, f2fs, gfs2, zonefs,
btrfs (partial). io_uring sets `IOCB_HIPRI` for `IORING_SETUP_IOPOLL`
(`io_uring/rw.c:891-895`) and may set `IOCB_NOWAIT` for nonblock issue
(`io_uring/rw.c:950-954`).

### Step 5.3: TRACE CALLEES
**Record:** After fix: `bio->bi_opf |= REQ_POLLED`, then `submit_bio()`
(or filesystem `submit_io` hook). Block layer checks `REQ_NOWAIT` in
`__bio_queue_enter()` → `bio_wouldblock_error()` → `-EAGAIN`.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Userspace io_uring IOPOLL → `IOCB_HIPRI` + possibly
`IOCB_NOWAIT` → `xfs_file_read_iter`/`ext4_file_write_iter` →
`iomap_dio_rw` → `iomap_dio_submit_bio` → block layer. **Reachable from
userspace** on common filesystems with `.iopoll = iocb_bio_iopoll` (xfs,
ext4, f2fs, gfs2, zonefs).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `block/fops.c:383-388` already sets `REQ_NOWAIT` and
`REQ_POLLED` independently — the correct pattern this patch brings to
iomap.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Current code at `fs/iomap/direct-io.c:76-77` calls
`bio_set_polled(bio, iocb)`. `bio_set_polled()` at
`include/linux/bio.h:688-693` still sets `REQ_NOWAIT` when `IOCB_NOWAIT`
is set. Polled-IO infrastructure present since at least 6.18 branch
(xfs/ext4 `.iopoll` handlers exist).

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Expected **clean apply**. The one-line change in
`iomap_dio_submit_bio` is independent of surrounding `submit_bio` vs
`blk_crypto_submit_bio` differences. Removing unused `bio_set_polled()`
is safe — grep confirms only iomap used it.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** Block-layer fix (`2bc057692599`) is present in
`block/fops.c`. iomap-specific fix (`47f28b493daf`) is **NOT** present.
No alternate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **Filesystem I/O (iomap direct-I/O)** — **IMPORTANT/CORE-
adjacent**. Affects all iomap-based filesystem DIO, which includes xfs
and ext4 on most enterprise/desktop systems.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** iomap is mature and actively used. Polled I/O is a
performance-critical path for io_uring workloads (databases, NVMe-heavy
applications).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users of **io_uring polled I/O** (`IORING_SETUP_IOPOLL`)
with **O_DIRECT** on **iomap filesystems** (xfs, ext4, f2fs, gfs2,
zonefs). Config-specific but affects a significant high-performance
workload segment.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** `IOCB_HIPRI` set (IOPOLL) on async DIO through iomap. Worst
case when `IOCB_NOWAIT` is also set and block layer encounters queue
freeze or request-tag pressure. Trigger is realistic for io_uring
nonblock + IOPOLL combinations.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** Spurious `-EAGAIN` / I/O stalls / failure to make progress
on polled filesystem DIO. Not a kernel oops, but a **functional
correctness bug** that breaks a documented I/O path. Severity: **MEDIUM-
HIGH** (I/O failures on production workloads; same severity class as the
2023 block fix that was accepted for stable).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH for io_uring + filesystem DIO users; completes a fix
  already applied to block devices
- **Risk:** VERY LOW — 1-line behavioral fix, dead-code removal, mirrors
  proven block-layer pattern
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Buggy code confirmed present in 6.18.43
- Companion to block-layer fix already in this tree since 2023
- Affects major filesystems (xfs, ext4) via io_uring IOPOLL
- Small (16 lines), maintainer-authored, obviously correct
- Prevents incorrect `REQ_NOWAIT` on non-idempotent filesystem writes
- Same failure mode as documented in `2bc057692599`: repeated `-EAGAIN`,
  no progress

**AGAINST backport:**
- No explicit crash report, syzbot, or user bugzilla reference
- Impact limited to polled + (optionally) nowait filesystem DIO path
- Not a security or data-corruption fix with demonstrated exploit

**UNRESOLVED:**
- Exact date iomap started using `bio_set_polled` (shallow repo);
  kernel.org indicates ~Aug 2023
- Whether any distribution has filed user-visible bug reports

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — mirrors accepted block fix;
   maintainer-applied
2. Fixes a real bug affecting users? **PASS** — incorrect flag
   propagation on reachable I/O path
3. Important issue? **PASS** — I/O failures / stalls on io_uring polled
   filesystem DIO (MEDIUM-HIGH)
4. Small and contained? **PASS** — 16 lines, 2 files
5. No new features or APIs? **PASS** — flag-handling correction only
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None apply directly (not device ID, quirk, DT, build, or
docs). Standard bug fix.

### Step 9.4: DECISION RATIONALE

This patch completes a fix that was applied to the block-device
direct-I/O path in 2023 but was never carried to the iomap filesystem
DIO path. The buggy code is present in Linux 6.18.43. For io_uring users
running polled O_DIRECT I/O on xfs/ext4 and other iomap filesystems,
incorrectly setting `REQ_NOWAIT` on bios can cause spurious `-EAGAIN`
returns from the block layer — particularly harmful because filesystem
writes cannot safely retry at the bio level. The fix is tiny, low-risk,
and directly analogous to an already-stable fix.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message;
  fetched spinics.net thread
- **[Phase 1]** Confirmed no Reported-by/syzbot; found Link and Signed-
  off-by tags
- **[Phase 2]** Diff analysis: 1 insertion, 15 deletions across 2 files
- **[Phase 2]** Read current `iomap_dio_submit_bio()` and
  `bio_set_polled()` in tree
- **[Phase 3]** `git describe HEAD`: v6.18.43; `make kernelversion`
  equivalent from Makefile: 6.18.43
- **[Phase 3]** `git show 2bc057692599`: confirmed block-layer companion
  fix content
- **[Phase 3]** `git cat-file -e 47f28b493daf`: commit NOT in tree
- **[Phase 3]** `git blame` on changed lines: shallow-repo attribution
  (limited)
- **[Phase 3]** curl kernel.org log for `fs/iomap/direct-io.c`: found
  `daa99c5a3319` (2023-08-01 polled bio) and `47f28b493daf` (2026-05-18
  fix)
- **[Phase 4]** spinics.net msg338671.html: original patch thread
  fetched
- **[Phase 4]** spinics.net msg338717.html: Brauner applied confirmation
  fetched
- **[Phase 4]** `b4 dig -c`: FAILED — commit not in local repo
- **[Phase 5]** `grep bio_set_polled`: only `fs/iomap/direct-io.c` +
  `include/linux/bio.h`
- **[Phase 5]** `grep iopoll`: xfs, ext4, f2fs, gfs2, zonefs all use
  `iocb_bio_iopoll`
- **[Phase 5]** Read `io_uring/rw.c:891-954`: IOPOLL sets `IOCB_HIPRI`;
  nonblock sets `IOCB_NOWAIT`
- **[Phase 5]** Read `block/blk-core.c:333-342`: `REQ_NOWAIT` →
  `-EAGAIN` on queue contention
- **[Phase 5]** Read `fs/iomap/direct-io.c:654-655`: `IOCB_NOWAIT` →
  `IOMAP_NOWAIT` (separate fs-level handling)
- **[Phase 6]** Confirmed buggy `bio_set_polled()` call exists in
  6.18.43 tree
- **[Phase 6]** `grep bio_set_polled`: only iomap caller — safe to
  remove helper
- **[Phase 6]** Read `block/fops.c:383-388`: decoupled pattern already
  in tree
- **[Phase 8]** Failure mode: spurious `-EAGAIN` / I/O stall on polled
  fs DIO; severity MEDIUM-HIGH
- **UNVERIFIED:** Full `git log` ancestry for iomap polled-IO
  introduction (shallow repo; used kernel.org instead)
- **UNVERIFIED:** Whether 6.18.y already has a different backport of
  this fix (no evidence found)

**YES**The hung `git log HEAD` check didn’t finish — the shallow 6.18.43
checkout made full ancestry walks impractical. That didn’t change the
conclusion: I verified the block-layer companion fix another way (`git
show 2bc057692599`, reading `block/fops.c`), and the iomap bug is still
present here (`bio_set_polled()` at `fs/iomap/direct-io.c:77`).

**Verdict for Linux 6.18.43:** this commit should be backported. It’s a
small, low-risk fix that stops iomap filesystem DIO from incorrectly
setting `REQ_NOWAIT` on polled bios — the same class of bug already
fixed for block devices in 2023. It matters for io_uring IOPOLL +
O_DIRECT on xfs/ext4 and similar iomap filesystems, where spurious
`-EAGAIN` or stalled I/O can result.

**YES**

 fs/iomap/direct-io.c |  2 +-
 include/linux/bio.h  | 14 --------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index e73c71f39bd45..92f32e02f77f4 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -74,7 +74,7 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
 
 	/* Sync dio can't be polled reliably */
 	if ((iocb->ki_flags & IOCB_HIPRI) && !is_sync_kiocb(iocb)) {
-		bio_set_polled(bio, iocb);
+		bio->bi_opf |= REQ_POLLED;
 		WRITE_ONCE(iocb->private, bio);
 	}
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 16c1c85613b76..9a15f90359ade 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -678,20 +678,6 @@ static inline bool bioset_initialized(struct bio_set *bs)
 	return bs->bio_slab != NULL;
 }
 
-/*
- * Mark a bio as polled. Note that for async polled IO, the caller must
- * expect -EWOULDBLOCK if we cannot allocate a request (or other resources).
- * We cannot block waiting for requests on polled IO, as those completions
- * must be found by the caller. This is different than IRQ driven IO, where
- * it's safe to wait for IO to complete.
- */
-static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
-{
-	bio->bi_opf |= REQ_POLLED;
-	if (kiocb->ki_flags & IOCB_NOWAIT)
-		bio->bi_opf |= REQ_NOWAIT;
-}
-
 static inline void bio_clear_polled(struct bio *bio)
 {
 	bio->bi_opf &= ~REQ_POLLED;
-- 
2.53.0

