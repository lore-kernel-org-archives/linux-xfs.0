Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83E25476D2;
	Mon, 31 Aug 2026 13:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184011; cv=none; b=o2rZhf2POXnA0V6MNtv/UaWBBLcmh9fJszGw/AHqBmTJnBsJrAtgp+0oQ2jQMuw78wKbQfEii6PIYWYe0ueWjyvt1MhDp+pzt1YLN/f1m6e9nO6CDW2UKQ+H7x4BKFXf39Q9x5WK4emTYISxYNoFspv2D+L5cA0rDTy5evpEtF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184011; c=relaxed/simple;
	bh=3iU8+o/dKiI98fssKGUtxOGzI2MdKQLjANy3PJQKy2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dy7zBKyxWdpLK7jIysqIisocHRhp5LZodxMhdE/j48uU5BJc88jr0bNfMoPRPwenY8R6IGkMKsNUm1UP3wZe+ZgFK/LxjBQinrxtKXI+54FLBJ9zTa5XEBWbyeaIyUE2FFnOHF3EQEydUy5mds6jHeFNNJX/yiKmnfM3+NqdyCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HzaMApTG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HzaMApTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595BA1F00A3F;
	Mon, 31 Aug 2026 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184005;
	bh=bVA8K2oEooFlo55mJn3JSpEOJpVxPN88TTHKqRPmoYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzaMApTG3POshJKe6+fl/gwdrfhl2Dxjf91Pr1GJ3YPsGctSynsJ40o92luZ8zeQs
	 nJ7Bexgwkfh/gz5WVo9SvXK1pt2BGmHpKDvhxwhDFe2Ljr8MuHDgGj2Fxohi7qGakN
	 8hT91u5LWfRm+vkS1knXbZbz0OSJMMDgJYKRBfEX3goYp9e7+OHZ5VwuhRCAVccao+
	 N6O1CGgKdE+6j9tv6beMyuQbcE2ORg/7/qI+onoSK9MSI0bU/CWsP842wpjkk4wfLh
	 e0M/FYgllxEgDb4CWBJVXScrLpsPgTz/vc4p8MJoJzD57YsaA+O+Ey2oVIcOzNYwJF
	 Du2nplq+/LuQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Yi <yi.zhang@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] iomap: prevent ioend merge when io_private differs
Date: Mon, 31 Aug 2026 09:27:41 -0400
Message-ID: <20260831133314.4125787-433-sashal@kernel.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit c97cd6f447d8727af3d457bca3a9283a77dd70f8 ]

Different io_private values indicate distinct completion contexts that
must not be merged together, as this could leak or corrupt the private
data associated with each ioend.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260713074206.1768006-1-yi.zhang@huaweicloud.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `iomap: prevent ioend merge when io_private
differs`

**Local tree:** `v6.18.44` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[iomap] [prevent] prevent ioend merge when io_private
differs` — blocks incorrect merging of adjacent `iomap_ioend` structures
when their per-ioend private completion contexts differ.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Zhang Yi `<yi.zhang@huawei.com>` (author) |
| Link | https://patch.msgid.link/20260713074206.1768006-1-
yi.zhang@huaweicloud.com |
| Reviewed-by | Christoph Hellwig `<hch@lst.de>` (iomap/XFS maintainer)
|
| Reviewed-by | Ojaswin Mujoo `<ojaswin@linux.ibm.com>` |
| Signed-off-by | Christian Brauner `<brauner@kernel.org>` (VFS
maintainer) |

**Notable patterns:** Two subsystem maintainers/reviewers (Hellwig,
Brauner). No `Reported-by:`, no syzbot, no `Fixes:` tag (expected for
manual review). No `Cc: stable` in the commit message.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `iomap_ioend_can_merge()` allows merging adjacent ioends even
  when `io_private` differs.
- **Symptom:** Leak or corruption of filesystem-private completion data.
- **Root cause (author):** Different `io_private` values mean distinct
  completion contexts that must stay separate.
- **Version info:** None in the message.
- **Context (from lore):** Patch is part of ext4 iomap conversion work;
  discussion linked to ext4 thread.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit correctness fix. The
"prevent" verb and corruption/leak language indicate a real bug, not
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `fs/iomap/ioend.c` (+2 lines)
- **Function:** `iomap_ioend_can_merge()`
- **Scope:** Single-file, surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Before:** Adjacent ioends merge if status, flags, offsets, and
  sectors match — `io_private` ignored.
- **After:** Merge rejected when `ioend->io_private !=
  next->io_private`.
- **Path:** `iomap_ioend_try_merge()` → called from `xfs_end_io()`
  during write completion processing.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:** **Logic / correctness fix** with **reference-counting** and
**data-corruption** consequences.

When ioends merge in `iomap_ioend_try_merge()`:
```335:348:fs/iomap/ioend.c
void iomap_ioend_try_merge(struct iomap_ioend *ioend,
                struct list_head *more_ioends)
{
        // ...
                if (!iomap_ioend_can_merge(ioend, next))
                        break;
                list_move_tail(&next->io_list, &ioend->io_list);
                ioend->io_size += next->io_size;
```

Only `io_size` is accumulated on the parent; `io_private` from merged
children is not propagated. XFS completion then uses only the parent's
`io_private`:

```153:167:fs/xfs/xfs_aops.c
        if (is_zoned)
                error = xfs_zoned_end_io(ip, offset, size,
ioend->io_sector,
                                ioend->io_private, NULLFSBLOCK);
        // ...
        if (is_zoned)
                xfs_ioend_put_open_zones(ioend);
```

If two adjacent ioends used different `xfs_open_zone` pointers
(`io_private`), merging causes:
1. **Data corruption:** `xfs_zoned_end_io()` maps the full merged byte
   range using only the parent's zone, mis-mapping blocks written under
   a different zone.
2. **Reference imbalance:** `xfs_ioend_put_open_zones()` walks the
   merged chain and puts each child's `io_private` plus the parent's —
   refcount behavior becomes inconsistent with how zones were acquired
   in `xfs_submit_zoned_bio()`.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:** Obviously correct — mirrors existing merge guards (status,
flags, offset, sector). Minimal (2 lines). Very low regression risk:
only prevents merges that should never have happened. No new APIs.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** `iomap_ioend_can_merge()` in this tree comes from commit
`5d324e5159d9e` (2025-11-28, v6.18 era). The missing `io_private` check
has been present since the function was introduced in this tree.
`io_private` exists in `include/linux/iomap.h` since at least tag
`v6.18`.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag present. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Recent `fs/iomap/ioend.c` changes in this tree: split
bio_set, EOF trim guard, delalloc rejection. Standalone fix; not part of
a multi-patch series (b4 shows only v1).

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Zhang Yi is working on ext4 iomap conversion (per lore).
Hellwig and Mujoo reviewed. Author is an active contributor in this
area, not a drive-by.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No prerequisites. The `io_private` field and merge logic
already exist in v6.18.44. Fix is self-contained.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- **URL:** https://patch.msgid.link/20260713074206.1768006-1-
  yi.zhang@huaweicloud.com
- **Series revisions:** v1 only (no v2/v3)
- **Reviewer feedback:** Hellwig: "Looks sensible and fine to queue up
  now"; Mujoo: "Looks good Yi"
- **Stable nominations:** None found in thread
- **NAKs/concerns:** None

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** CC'd: `linux-fsdevel`, `linux-xfs`, `linux-ext4`,
`brauner@kernel.org`, `djwong@kernel.org`, `hch@infradead.org`.
Appropriate maintainers included and reviewed.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No external bug report or syzbot link. Bug identified during
ext4 iomap conversion development. Logical analysis of XFS zoned
completion path confirms real corruption risk.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Related to ext4 iomap conversion (future in this tree). In
v6.18.44, only XFS sets `io_private` on ioends.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched exhaustively; no stable discussion found in the
patch thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `iomap_ioend_can_merge()` (modified),
`iomap_ioend_try_merge()` (caller).

### Step 5.2: TRACE CALLERS
**Record:** `iomap_ioend_try_merge()` called from `xfs_end_io()` in
`fs/xfs/xfs_aops.c` (line 204). Triggered during asynchronous write I/O
completion on XFS inodes — normal write path for buffered/direct I/O.

### Step 5.3: TRACE CALLEES
**Record:** Merge logic chains ioends via `list_move_tail`; completion
calls `xfs_end_ioend()` → `xfs_zoned_end_io()` /
`xfs_ioend_put_open_zones()`.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** `submit_bio` → `xfs_end_bio` → workqueue `xfs_end_io` →
`iomap_ioend_try_merge` → `xfs_end_ioend`. Reachable from normal file
writes on zoned XFS RT volumes. Zone fill in
`xfs_zone_alloc_and_submit()` can produce adjacent ioends with different
`io_private` when `select_zone` picks a new open zone.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Other merge guards already check `bi_status`,
`IOMAP_IOEND_BOUNDARY`, `IOMAP_IOEND_NOMERGE_FLAGS`, offset continuity,
and sector continuity. The `io_private` check fills an obvious gap
consistent with those guards.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **Yes.** `io_private` field exists in
`include/linux/iomap.h` (line 413). XFS sets it in
`xfs_submit_zoned_bio()` (`fs/xfs/xfs_zone_alloc.c:833`).
`iomap_ioend_can_merge()` lacks the guard (lines 307–333). Fix commit
`c97cd6f447d8` is **not** an ancestor of HEAD (`merge-base --is-
ancestor` returned exit 1).

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Upstream patch does not apply verbatim (`git apply --check`
fails at line 385 — local tree has fewer lines in the function, no READ-
op guard). **Minor adjustment needed:** insert the 2 lines after the
`bi_status` check at line 310. Trivial backport.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No duplicate fix found. `git log --grep="io_private"`
returns nothing in this tree's history.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **Filesystem / iomap layer** (shared infrastructure) with
**XFS zoned RT** as the current consumer in this tree. Criticality:
**IMPORTANT** — affects filesystem data integrity for zoned XFS users.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** iomap and XFS zoned code actively developed in the 6.18
cycle. `io_private` and zoned allocation are relatively new, making this
bug relevant to current 6.18.y users.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users of **XFS with zoned realtime volumes**
(`CONFIG_XFS_RT`, `xfs_has_zoned`). Not universal, but any such
deployment doing writes is affected. ext4 does not use `io_private` in
this tree yet.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Adjacent write ioends completing with different `io_private`
(e.g., zone boundary crossing during allocation). Plausible during
normal sequential or concurrent writes when zones fill. Privileged write
access required (not a direct syscall attack vector), but corruption
affects all data on the volume.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **CRITICAL** — incorrect extent mapping via
`xfs_zoned_end_io()` on merged ranges causes **filesystem metadata/data
corruption**. Secondary refcount imbalance can cause leaks or premature
free of `xfs_open_zone` structures.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH for affected XFS zoned users — prevents silent
  corruption
- **Risk:** VERY LOW — 2-line guard, no behavior change for correctly-
  formed ioend chains
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Fixes real data-corruption bug in XFS zoned write completion
- Small, surgical, reviewer-approved (Hellwig, Mujoo, Brauner)
- Buggy code and `io_private` usage both present in v6.18.44
- Fix mirrors existing merge guards — obviously correct
- Prevents refcount corruption on `xfs_open_zone`

**AGAINST backporting:**
- Affects niche config (`CONFIG_XFS_RT` zoned volumes only)
- No user bug report or syzbot reproduction
- Patch needs trivial line-offset adjustment for this tree (not a
  blocker)

**Unresolved:** None that affect the decision.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — logic is clear; reviewed by
   iomap/XFS maintainers
2. Fixes a real bug affecting users? **PASS** — XFS zoned write
   completion corruption
3. Important issue? **PASS** — data corruption (CRITICAL)
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — trivial insertion after
   `bi_status` check (minor offset adjustment)

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None (not a device ID, quirk, DT, build fix, or docs fix).
Qualifies on merit as a correctness/corruption fix.

### Step 9.4: DECISION RATIONALE
For **v6.18.44**, the buggy merge path exists, XFS actively uses
`io_private` for zoned completion contexts, and incorrect merging can
corrupt extent mappings. The fix is minimal, maintainer-reviewed, and
low-risk. The narrow config scope does not outweigh the severity of data
corruption.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; noted Hellwig/Mujoo reviews;
  ext4 conversion context from lore
- **[Phase 2]** Read diff: +2 lines in `iomap_ioend_can_merge()`; traced
  merge → XFS completion path
- **[Phase 3]** `git describe HEAD`: v6.18.44; `git blame` on lines
  307–333: from `5d324e5159d9e`
- **[Phase 3]** `git log --grep="io_private"`: no prior fix in tree
- **[Phase 3]** `git merge-base --is-ancestor c97cd6f447d8 HEAD`: exit 1
  (fix not in HEAD)
- **[Phase 4]** `b4 dig -c fff189121d344`: found lore URL; v1 only;
  Hellwig/Mujoo reviewed; Brauner applied
- **[Phase 4]** `b4 dig -w`: CC list includes fsdevel, xfs, ext4,
  maintainers
- **[Phase 4]** Read `/tmp/iomap_io_private.mbox`: no NAKs, no stable
  nomination
- **[Phase 5]** `grep iomap_ioend_try_merge`: caller is `xfs_end_io()`
  in `fs/xfs/xfs_aops.c`
- **[Phase 5]** Read `xfs_zone_alloc.c`: `io_private` set in
  `xfs_submit_zoned_bio()`; zone refill via `select_zone`
- **[Phase 5]** Read `xfs_aops.c`: `xfs_zoned_end_io()` uses parent
  `io_private` only; `xfs_ioend_put_open_zones()` walks merged chain
- **[Phase 6]** `grep io_private fs/ext4`: no matches (ext4 not affected
  in this tree)
- **[Phase 6]** `git show v6.18:include/linux/iomap.h | grep
  io_private`: field present since v6.18
- **[Phase 6]** `git apply --check` on upstream patch: fails at line 385
  (offset mismatch; trivial manual apply)
- **[Phase 6]** Current `fs/iomap/ioend.c` lacks `io_private` merge
  guard (verified by read)
- **[Phase 8]** Failure mode: extent mapping corruption on zoned XFS
  writes — CRITICAL severity

**YES**The background check finished: `c97cd6f447d8` (the upstream fix)
is **not** in this tree’s HEAD (`v6.18.44`), so the bug is still present
here.

**Summary:** The patch adds a 2-line guard in `iomap_ioend_can_merge()`
so ioends with different `io_private` values are not merged. Without it,
XFS zoned RT write completion can mis-map extents and corrupt metadata.
The change is small, maintainer-reviewed, and should backport cleanly
with a minor line-offset tweak.

**YES**

 fs/iomap/ioend.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 2a86b05c88efc..da174d896abfe 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -309,6 +309,8 @@ static bool iomap_ioend_can_merge(struct iomap_ioend *ioend,
 {
 	if (ioend->io_bio.bi_status != next->io_bio.bi_status)
 		return false;
+	if (ioend->io_private != next->io_private)
+		return false;
 	if (next->io_flags & IOMAP_IOEND_BOUNDARY)
 		return false;
 	if ((ioend->io_flags & IOMAP_IOEND_NOMERGE_FLAGS) !=
-- 
2.53.0

