Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0FDC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbiLaAu0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiLaAu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:50:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508521C90A;
        Fri, 30 Dec 2022 16:50:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCE9EB81DF1;
        Sat, 31 Dec 2022 00:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8705FC433EF;
        Sat, 31 Dec 2022 00:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447821;
        bh=7qF8prR8cdmJPChy8VnI2i2RPMsH7gWhmnpQjimVnAc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HVwz79V59fld7R3oh8bteazVWjwssvm3PU3QDYy5ePwUNqRtPyCf4BQy4bYjytVJ8
         36K8t+RHDk0F1Z+odbAdfBCBEF8Z85rF0rDSlkeI3cPBNt53DncdiJgH4YKNb+k3AQ
         0hDK8qpFuaL9M7LMpVqDyvzZm92Jtq1StGIb+qG/pnoNss/GSHPDVhFdhZVe273kl6
         vH03HC8oOzq/TF11jTO5aCf/e0jsaK/kGgkNxRUqOuFfHlFxrx5dd+fOVFmGJolLj4
         8pXiC9gMjtbHbXFCMmHxp4AJbvnTWkJ3kqlLxMRL3IvfQDA+rDanJZrmFt7qYweWFy
         fSZoHBDrgqgWA==
Subject: [PATCH 24/24] fuzzy: for fuzzing ag btrees,
 find the path to the AG header
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:42 -0800
Message-ID: <167243878211.730387.7658682202200874885.stgit@magnolia>
In-Reply-To: <167243877899.730387.9276624623424433346.stgit@magnolia>
References: <167243877899.730387.9276624623424433346.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The fs population code creates various btrees in /some/ allocation group
with at least two levels.  These btrees aren't necessarily created in
agno 0, so we need to find it programmatically.  While we're at it, fix
a few of the comments that failed to mention when we're fuzzing interior
nodes and not leaves.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs    |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/358 |    5 ++++-
 tests/xfs/359 |    5 ++++-
 tests/xfs/360 |    5 ++++-
 tests/xfs/361 |    5 ++++-
 tests/xfs/362 |    5 ++++-
 tests/xfs/363 |    5 ++++-
 tests/xfs/364 |    5 ++++-
 tests/xfs/365 |    5 ++++-
 tests/xfs/366 |    5 ++++-
 tests/xfs/367 |    5 ++++-
 tests/xfs/368 |    5 ++++-
 tests/xfs/369 |    5 ++++-
 tests/xfs/370 |    5 ++++-
 tests/xfs/371 |    5 ++++-
 tests/xfs/372 |    5 ++++-
 tests/xfs/373 |    7 +++++--
 tests/xfs/410 |    5 ++++-
 tests/xfs/411 |    5 ++++-
 tests/xfs/457 |    5 ++++-
 tests/xfs/458 |    5 ++++-
 tests/xfs/459 |    5 ++++-
 tests/xfs/460 |    5 ++++-
 tests/xfs/461 |    5 ++++-
 tests/xfs/462 |    5 ++++-
 tests/xfs/463 |    5 ++++-
 tests/xfs/464 |    7 +++++--
 tests/xfs/483 |    5 ++++-
 28 files changed, 147 insertions(+), 29 deletions(-)


diff --git a/common/xfs b/common/xfs
index 371618dc7b..610730e5ef 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1686,3 +1686,40 @@ _xfs_get_inode_core_bytes()
 		echo 96
 	fi
 }
+
+# Find us the path to the AG header containing a per-AG btree with a specific
+# height.
+_scratch_xfs_find_agbtree_height() {
+	local bt_type="$1"
+	local bt_height="$2"
+	local agcount=$(_xfs_mount_agcount $SCRATCH_DEV)
+
+	case "${bt_type}" in
+	"bno"|"cnt"|"rmap"|"refcnt")
+		hdr="agf"
+		bt_prefix="${bt_type}"
+		;;
+	"ino")
+		hdr="agi"
+		bt_prefix=""
+		;;
+	"fino")
+		hdr="agi"
+		bt_prefix="free_"
+		;;
+	*)
+		_fail "Don't know about AG btree ${bt_type}"
+		;;
+	esac
+
+	for ((agno = 0; agno < agcount; agno++)); do
+		bt_level=$(_scratch_xfs_db -c "${hdr} ${agno}" -c "p ${bt_prefix}level" | awk '{print $3}')
+		# "level" is really the btree height
+		if [ "${bt_level}" -eq "${bt_height}" ]; then
+			echo "${hdr} ${agno}"
+			return 0
+		fi
+	done
+
+	return 1
+}
diff --git a/tests/xfs/358 b/tests/xfs/358
index a00eb6f9cb..92180e5196 100755
--- a/tests/xfs/358
+++ b/tests/xfs/358
@@ -24,8 +24,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'bno' 2)" || \
+	_fail "could not find two-level bnobt"
+
 echo "Fuzz bnobt recs"
-_scratch_xfs_fuzz_metadata '' 'offline'  'agf 0' 'addr bnoroot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'offline'  "$path" 'addr bnoroot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing bnobt recs"
 
 # success, all done
diff --git a/tests/xfs/359 b/tests/xfs/359
index f0a82db4b8..0498aaccf5 100755
--- a/tests/xfs/359
+++ b/tests/xfs/359
@@ -24,8 +24,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'bno' 2)" || \
+	_fail "could not find two-level bnobt"
+
 echo "Fuzz bnobt recs"
-_scratch_xfs_fuzz_metadata '' 'online'  'agf 0' 'addr bnoroot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online'  "$path" 'addr bnoroot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing bnobt recs"
 
 # success, all done
diff --git a/tests/xfs/360 b/tests/xfs/360
index 3942ffd1b2..c34f455403 100755
--- a/tests/xfs/360
+++ b/tests/xfs/360
@@ -24,8 +24,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'bno' 2)" || \
+	_fail "could not find two-level bnobt"
+
 echo "Fuzz bnobt keyptr"
-_scratch_xfs_fuzz_metadata '' 'offline'  'agf 0' 'addr bnoroot' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'offline'  "$path" 'addr bnoroot' >> $seqres.full
 echo "Done fuzzing bnobt keyptr"
 
 # success, all done
diff --git a/tests/xfs/361 b/tests/xfs/361
index b7ee0f6f94..22b1af4ea3 100755
--- a/tests/xfs/361
+++ b/tests/xfs/361
@@ -24,8 +24,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'bno' 2)" || \
+	_fail "could not find two-level bnobt"
+
 echo "Fuzz bnobt keyptr"
-_scratch_xfs_fuzz_metadata '' 'online'  'agf 0' 'addr bnoroot' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online'  "$path" 'addr bnoroot' >> $seqres.full
 echo "Done fuzzing bnobt keyptr"
 
 # success, all done
diff --git a/tests/xfs/362 b/tests/xfs/362
index f711661b02..51727edc06 100755
--- a/tests/xfs/362
+++ b/tests/xfs/362
@@ -24,8 +24,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'cnt' 2)" || \
+	_fail "could not find two-level cntbt"
+
 echo "Fuzz cntbt"
-_scratch_xfs_fuzz_metadata '' 'offline'  'agf 0' 'addr cntroot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'offline'  "$path" 'addr cntroot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing cntbt"
 
 # success, all done
diff --git a/tests/xfs/363 b/tests/xfs/363
index 6be9109eca..8a62c1c821 100755
--- a/tests/xfs/363
+++ b/tests/xfs/363
@@ -24,8 +24,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'cnt' 2)" || \
+	_fail "could not find two-level cntbt"
+
 echo "Fuzz cntbt"
-_scratch_xfs_fuzz_metadata '' 'online'  'agf 0' 'addr cntroot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online'  "$path" 'addr cntroot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing cntbt"
 
 # success, all done
diff --git a/tests/xfs/364 b/tests/xfs/364
index fcd18fe686..984ecdafed 100755
--- a/tests/xfs/364
+++ b/tests/xfs/364
@@ -24,8 +24,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'ino' 2)" || \
+	_fail "could not find two-level inobt"
+
 echo "Fuzz inobt"
-_scratch_xfs_fuzz_metadata '' 'offline'  'agi 0' 'addr root' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'offline'  "$path" 'addr root' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing inobt"
 
 # success, all done
diff --git a/tests/xfs/365 b/tests/xfs/365
index 6f116f9b9c..e4325c35d1 100755
--- a/tests/xfs/365
+++ b/tests/xfs/365
@@ -24,8 +24,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'ino' 2)" || \
+	_fail "could not find two-level inobt"
+
 echo "Fuzz inobt"
-_scratch_xfs_fuzz_metadata '' 'online'  'agi 1' 'addr root' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online'  "$path" 'addr root' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing inobt"
 
 # success, all done
diff --git a/tests/xfs/366 b/tests/xfs/366
index 4c651288c0..8a52d21a0f 100755
--- a/tests/xfs/366
+++ b/tests/xfs/366
@@ -25,8 +25,11 @@ _require_xfs_finobt
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'fino' 2)" || \
+	_fail "could not find two-level finobt"
+
 echo "Fuzz finobt"
-_scratch_xfs_fuzz_metadata '' 'offline'  'agi 0' 'addr free_root' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'offline'  "$path" 'addr free_root' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing finobt"
 
 # success, all done
diff --git a/tests/xfs/367 b/tests/xfs/367
index c474a9e7d8..d9d07faab2 100755
--- a/tests/xfs/367
+++ b/tests/xfs/367
@@ -25,8 +25,11 @@ _require_xfs_finobt
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'fino' 2)" || \
+	_fail "could not find two-level finobt"
+
 echo "Fuzz finobt"
-_scratch_xfs_fuzz_metadata '' 'online'  'agi 0' 'addr free_root' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online'  "$path" 'addr free_root' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing finobt"
 
 # success, all done
diff --git a/tests/xfs/368 b/tests/xfs/368
index b1c1f97664..83499827c9 100755
--- a/tests/xfs/368
+++ b/tests/xfs/368
@@ -25,8 +25,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rmapbt"
+
 echo "Fuzz rmapbt recs"
-_scratch_xfs_fuzz_metadata '' 'offline' 'agf 0' 'addr rmaproot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'offline' "$path" 'addr rmaproot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing rmapbt recs"
 
 # success, all done
diff --git a/tests/xfs/369 b/tests/xfs/369
index 5e6d8d9be0..3236b50e00 100755
--- a/tests/xfs/369
+++ b/tests/xfs/369
@@ -25,8 +25,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rmapbt"
+
 echo "Fuzz rmapbt recs"
-_scratch_xfs_fuzz_metadata '' 'online' 'agf 0' 'addr rmaproot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online' "$path" 'addr rmaproot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing rmapbt recs"
 
 # success, all done
diff --git a/tests/xfs/370 b/tests/xfs/370
index 0a916242e2..891d5e2572 100755
--- a/tests/xfs/370
+++ b/tests/xfs/370
@@ -26,8 +26,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rmapbt"
+
 echo "Fuzz rmapbt keyptr"
-_scratch_xfs_fuzz_metadata '' 'offline' 'agf 0' 'addr rmaproot' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'offline' "$path" 'addr rmaproot' >> $seqres.full
 echo "Done fuzzing rmapbt keyptr"
 
 # success, all done
diff --git a/tests/xfs/371 b/tests/xfs/371
index a9b914d9f5..f7a336b170 100755
--- a/tests/xfs/371
+++ b/tests/xfs/371
@@ -26,8 +26,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rmapbt"
+
 echo "Fuzz rmapbt keyptr"
-_scratch_xfs_fuzz_metadata '' 'online' 'agf 0' 'addr rmaproot' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online' "$path" 'addr rmaproot' >> $seqres.full
 echo "Done fuzzing rmapbt keyptr"
 
 # success, all done
diff --git a/tests/xfs/372 b/tests/xfs/372
index c39a917500..2250322527 100755
--- a/tests/xfs/372
+++ b/tests/xfs/372
@@ -26,8 +26,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level refcountbt"
+
 echo "Fuzz refcountbt"
-_scratch_xfs_fuzz_metadata '' 'offline'  'agf 0' 'addr refcntroot' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'offline'  "$path" 'addr refcntroot' >> $seqres.full
 echo "Done fuzzing refcountbt"
 
 # success, all done
diff --git a/tests/xfs/373 b/tests/xfs/373
index 324aa9fe7d..e0c20044ec 100755
--- a/tests/xfs/373
+++ b/tests/xfs/373
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 373
 #
-# Populate a XFS filesystem and fuzz every refcountbt field.
+# Populate a XFS filesystem and fuzz every refcountbt key/pointer field.
 # Use xfs_scrub to fix the corruption.
 #
 . ./common/preamble
@@ -26,8 +26,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level refcountbt"
+
 echo "Fuzz refcountbt"
-_scratch_xfs_fuzz_metadata '' 'online'  'agf 0' 'addr refcntroot' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online'  "$path" 'addr refcntroot' >> $seqres.full
 echo "Done fuzzing refcountbt"
 
 # success, all done
diff --git a/tests/xfs/410 b/tests/xfs/410
index e98a63ebf5..388ed7d190 100755
--- a/tests/xfs/410
+++ b/tests/xfs/410
@@ -26,8 +26,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level refcountbt"
+
 echo "Fuzz refcountbt"
-_scratch_xfs_fuzz_metadata '' 'offline'  'agf 0' 'addr refcntroot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'offline'  "$path" 'addr refcntroot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing refcountbt"
 
 # success, all done
diff --git a/tests/xfs/411 b/tests/xfs/411
index cfe7796102..a9fc25ce7d 100755
--- a/tests/xfs/411
+++ b/tests/xfs/411
@@ -26,8 +26,11 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level refcountbt"
+
 echo "Fuzz refcountbt"
-_scratch_xfs_fuzz_metadata '' 'online'  'agf 0' 'addr refcntroot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'online'  "$path" 'addr refcntroot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing refcountbt"
 
 # success, all done
diff --git a/tests/xfs/457 b/tests/xfs/457
index 332eeb9837..64cd6b4b82 100755
--- a/tests/xfs/457
+++ b/tests/xfs/457
@@ -25,8 +25,11 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'bno' 2)" || \
+	_fail "could not find two-level bnobt"
+
 echo "Fuzz bnobt recs"
-_scratch_xfs_fuzz_metadata '' 'none'  'agf 0' 'addr bnoroot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'none'  "$path" 'addr bnoroot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing bnobt recs"
 
 # success, all done
diff --git a/tests/xfs/458 b/tests/xfs/458
index ce03d687ab..8d87ec569f 100755
--- a/tests/xfs/458
+++ b/tests/xfs/458
@@ -25,8 +25,11 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'bno' 2)" || \
+	_fail "could not find two-level bnobt"
+
 echo "Fuzz bnobt keyptr"
-_scratch_xfs_fuzz_metadata '' 'none'  'agf 0' 'addr bnoroot' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'none'  "$path" 'addr bnoroot' >> $seqres.full
 echo "Done fuzzing bnobt keyptr"
 
 # success, all done
diff --git a/tests/xfs/459 b/tests/xfs/459
index d166160f87..5989bc1e6e 100755
--- a/tests/xfs/459
+++ b/tests/xfs/459
@@ -25,8 +25,11 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'cnt' 2)" || \
+	_fail "could not find two-level cntbt"
+
 echo "Fuzz cntbt"
-_scratch_xfs_fuzz_metadata '' 'none'  'agf 0' 'addr cntroot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'none'  "$path" 'addr cntroot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing cntbt"
 
 # success, all done
diff --git a/tests/xfs/460 b/tests/xfs/460
index 0daafa3066..7117477011 100755
--- a/tests/xfs/460
+++ b/tests/xfs/460
@@ -25,8 +25,11 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'ino' 2)" || \
+	_fail "could not find two-level inobt"
+
 echo "Fuzz inobt"
-_scratch_xfs_fuzz_metadata '' 'none'  'agi 1' 'addr root' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'none'  "$path" 'addr root' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing inobt"
 
 # success, all done
diff --git a/tests/xfs/461 b/tests/xfs/461
index 2d20c69d87..7c1327b052 100755
--- a/tests/xfs/461
+++ b/tests/xfs/461
@@ -26,8 +26,11 @@ _require_xfs_finobt
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'fino' 2)" || \
+	_fail "could not find two-level finobt"
+
 echo "Fuzz finobt"
-_scratch_xfs_fuzz_metadata '' 'none'  'agi 0' 'addr free_root' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'none'  "$path" 'addr free_root' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing finobt"
 
 # success, all done
diff --git a/tests/xfs/462 b/tests/xfs/462
index 587facc03c..1ee4d27e92 100755
--- a/tests/xfs/462
+++ b/tests/xfs/462
@@ -26,8 +26,11 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rmapbt"
+
 echo "Fuzz rmapbt recs"
-_scratch_xfs_fuzz_metadata '' 'none' 'agf 0' 'addr rmaproot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'none' "$path" 'addr rmaproot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing rmapbt recs"
 
 # success, all done
diff --git a/tests/xfs/463 b/tests/xfs/463
index 7270f7017a..7dd2d37dea 100755
--- a/tests/xfs/463
+++ b/tests/xfs/463
@@ -26,8 +26,11 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rmapbt"
+
 echo "Fuzz rmapbt keyptr"
-_scratch_xfs_fuzz_metadata '' 'none' 'agf 0' 'addr rmaproot' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'none' "$path" 'addr rmaproot' >> $seqres.full
 echo "Done fuzzing rmapbt keyptr"
 
 # success, all done
diff --git a/tests/xfs/464 b/tests/xfs/464
index 59d25ae1c0..719901e66d 100755
--- a/tests/xfs/464
+++ b/tests/xfs/464
@@ -4,7 +4,7 @@
 #
 # FS QA Test No. 464
 #
-# Populate a XFS filesystem and fuzz every refcountbt field.
+# Populate a XFS filesystem and fuzz every refcountbt key/pointer field.
 # Do not fix the filesystem, to test metadata verifiers.
 
 . ./common/preamble
@@ -27,8 +27,11 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level refcountbt"
+
 echo "Fuzz refcountbt"
-_scratch_xfs_fuzz_metadata '' 'none'  'agf 0' 'addr refcntroot' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'none'  "$path" 'addr refcntroot' >> $seqres.full
 echo "Done fuzzing refcountbt"
 
 # success, all done
diff --git a/tests/xfs/483 b/tests/xfs/483
index d7b0101a82..56670ba178 100755
--- a/tests/xfs/483
+++ b/tests/xfs/483
@@ -27,8 +27,11 @@ _disable_dmesg_check
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
+path="$(_scratch_xfs_find_agbtree_height 'refcnt' 2)" || \
+	_fail "could not find two-level refcountbt"
+
 echo "Fuzz refcountbt"
-_scratch_xfs_fuzz_metadata '' 'none'  'agf 0' 'addr refcntroot' 'addr ptrs[1]' >> $seqres.full
+_scratch_xfs_fuzz_metadata '' 'none'  "$path" 'addr refcntroot' 'addr ptrs[1]' >> $seqres.full
 echo "Done fuzzing refcountbt"
 
 # success, all done

