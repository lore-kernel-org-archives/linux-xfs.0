Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912B3C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B22613AA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 02:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhELCDG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 22:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230216AbhELCDG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 22:03:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ACC5610EA;
        Wed, 12 May 2021 02:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620784919;
        bh=AOi4sVKfMQ9Vkmc3t1BrijdRVluIUpPSUdJ4YRS/oWw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iGS9oC/NtM6MPl/lLL0+5HCONj8zpU8JjmoF+E18R4lSb0E6k4TRW+EFuraDMX0fq
         WQp9ykxdmj4pARSSO2KMNYhDZDSlKWK7DimbH3K/nKtzQTeCvhGXtu9yBoa3b82HZD
         bXbKOeTeKB3Wq/cfY1nKGhNWGvEJBBneup92AuxqqYDfEvUO3VGduF/aruRdvvgRQP
         iQFM6ZxgB8sxrmUQaxChXXmbdNKo2JWBRWCGMJbqaRiTk9GuT4JbjtBzeqjctWe3um
         N97OfwbmV/8UhazoDYmLJ40gRdwcLN5QPP4+rJ6CMM1DO6Co37BxWJX6WEXqumuvuM
         FUoUJgKfmHXnQ==
Subject: [PATCH 3/8] xfs: fix old fuzz test invocations of xfs_repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 May 2021 19:01:56 -0700
Message-ID: <162078491663.3302755.12377341247476799022.stgit@magnolia>
In-Reply-To: <162078489963.3302755.9219127595550889655.stgit@magnolia>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Some of the older blocktrash-based fuzz tests cause the fs to go down
due to the corrupted image and fail to remount.  Offline repair fails
because _repair_scratch_fs is the helper that is smart enough to call
xfs_repair -L, not _scratch_xfs_repair.  Fix these instances.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/083 |    8 ++++----
 tests/xfs/085 |    2 +-
 tests/xfs/086 |    4 ++--
 tests/xfs/087 |    2 +-
 tests/xfs/088 |    4 ++--
 tests/xfs/089 |    4 ++--
 tests/xfs/091 |    4 ++--
 tests/xfs/093 |    2 +-
 tests/xfs/097 |    2 +-
 tests/xfs/099 |    4 ++--
 tests/xfs/100 |    4 ++--
 tests/xfs/101 |    4 ++--
 tests/xfs/102 |    4 ++--
 tests/xfs/105 |    4 ++--
 tests/xfs/112 |    4 ++--
 tests/xfs/113 |    4 ++--
 tests/xfs/117 |    2 +-
 tests/xfs/120 |    2 +-
 tests/xfs/123 |    2 +-
 tests/xfs/124 |    4 ++--
 tests/xfs/125 |    4 ++--
 tests/xfs/126 |    4 ++--
 tests/xfs/130 |    2 +-
 tests/xfs/235 |    2 +-
 24 files changed, 41 insertions(+), 41 deletions(-)


diff --git a/tests/xfs/083 b/tests/xfs/083
index a3f32cb7..14a36416 100755
--- a/tests/xfs/083
+++ b/tests/xfs/083
@@ -44,7 +44,7 @@ scratch_repair() {
 
 	FSCK_LOG="${tmp}-fuzz-${fsck_pass}.log"
 	echo "++ fsck pass ${fsck_pass}" > "${FSCK_LOG}"
-	_scratch_xfs_repair >> "${FSCK_LOG}" 2>&1
+	_repair_scratch_fs >> "${FSCK_LOG}" 2>&1
 	res=$?
 	if [ "${res}" -eq 0 ]; then
 		echo "++ allegedly fixed, reverify" >> "${FSCK_LOG}"
@@ -105,7 +105,7 @@ echo "+ populate fs image" >> $seqres.full
 _scratch_populate >> $seqres.full
 
 echo "+ check fs" >> $seqres.full
-_scratch_xfs_repair >> $seqres.full 2>&1 || _fail "should pass initial fsck"
+_repair_scratch_fs >> $seqres.full 2>&1 || _fail "should pass initial fsck"
 
 echo "++ corrupt image" >> $seqres.full
 _scratch_xfs_db -x -c blockget -c "blocktrash ${FUZZ_ARGS}" >> $seqres.full 2>&1
@@ -129,7 +129,7 @@ done
 echo "+ fsck loop returns ${fsck_loop_ret}" >> $seqres.full
 
 echo "++ check fs for round 2" >> $seqres.full
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 ROUND2_LOG="${tmp}-round2-${fsck_pass}.log"
 echo "++ mount image (2)" >> $ROUND2_LOG
@@ -150,7 +150,7 @@ umount "${SCRATCH_MNT}" >> $ROUND2_LOG 2>&1
 cat "$ROUND2_LOG" >> $seqres.full
 
 echo "++ check fs (2)" >> $seqres.full
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 egrep -q '(did not fix|makes no progress)' $seqres.full && echo "xfs_repair failed" | tee -a $seqres.full
 if [ "$(wc -l < "$ROUND2_LOG")" -ne 8 ]; then
diff --git a/tests/xfs/085 b/tests/xfs/085
index 560b5a24..5d898088 100755
--- a/tests/xfs/085
+++ b/tests/xfs/085
@@ -75,7 +75,7 @@ echo "+ mount image"
 _try_scratch_mount 2>/dev/null && _fail "mount should not succeed"
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/086 b/tests/xfs/086
index f94c26b4..f4cf950d 100755
--- a/tests/xfs/086
+++ b/tests/xfs/086
@@ -86,7 +86,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image"
 _scratch_mount
@@ -109,7 +109,7 @@ done
 umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/087 b/tests/xfs/087
index 967791dd..e7b06e09 100755
--- a/tests/xfs/087
+++ b/tests/xfs/087
@@ -86,7 +86,7 @@ fi
 echo "broken: ${broken}"
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/088 b/tests/xfs/088
index 62360ca8..42a186be 100755
--- a/tests/xfs/088
+++ b/tests/xfs/088
@@ -86,7 +86,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image"
 _scratch_mount
@@ -109,7 +109,7 @@ done
 umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/089 b/tests/xfs/089
index 79167a57..7d8af7ce 100755
--- a/tests/xfs/089
+++ b/tests/xfs/089
@@ -86,7 +86,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image"
 _scratch_mount
@@ -110,7 +110,7 @@ done
 umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/091 b/tests/xfs/091
index db6bb0b2..5fa98328 100755
--- a/tests/xfs/091
+++ b/tests/xfs/091
@@ -86,7 +86,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image"
 _scratch_mount
@@ -110,7 +110,7 @@ done
 umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/093 b/tests/xfs/093
index 3bdbff4d..9a61cc3e 100755
--- a/tests/xfs/093
+++ b/tests/xfs/093
@@ -86,7 +86,7 @@ fi
 echo "broken: ${broken}"
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/097 b/tests/xfs/097
index f8ea4676..98648c9e 100755
--- a/tests/xfs/097
+++ b/tests/xfs/097
@@ -88,7 +88,7 @@ fi
 echo "broken: ${broken}"
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/099 b/tests/xfs/099
index 0cf19682..9a1408b8 100755
--- a/tests/xfs/099
+++ b/tests/xfs/099
@@ -74,8 +74,8 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/100 b/tests/xfs/100
index 44d175cc..277f26ec 100755
--- a/tests/xfs/100
+++ b/tests/xfs/100
@@ -79,8 +79,8 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/101 b/tests/xfs/101
index 023cc349..6eb303ad 100755
--- a/tests/xfs/101
+++ b/tests/xfs/101
@@ -74,8 +74,8 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/102 b/tests/xfs/102
index 907b8592..23326ecf 100755
--- a/tests/xfs/102
+++ b/tests/xfs/102
@@ -79,8 +79,8 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/105 b/tests/xfs/105
index bb7e93e1..7aeee7f0 100755
--- a/tests/xfs/105
+++ b/tests/xfs/105
@@ -79,8 +79,8 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/112 b/tests/xfs/112
index cf0a36d0..085f21ee 100755
--- a/tests/xfs/112
+++ b/tests/xfs/112
@@ -79,11 +79,11 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 if [ $? -eq 2 ]; then
 	_scratch_mount
 	umount "${SCRATCH_MNT}"
-	_scratch_xfs_repair >> $seqres.full 2>&1
+	_repair_scratch_fs >> $seqres.full 2>&1
 fi
 
 echo "+ mount image (2)"
diff --git a/tests/xfs/113 b/tests/xfs/113
index 3ab3cf5e..3dc51381 100755
--- a/tests/xfs/113
+++ b/tests/xfs/113
@@ -79,8 +79,8 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/117 b/tests/xfs/117
index 15765a56..d3f4675f 100755
--- a/tests/xfs/117
+++ b/tests/xfs/117
@@ -88,7 +88,7 @@ fi
 echo "broken: ${broken}"
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/120 b/tests/xfs/120
index 9fcce9ee..1f594ebc 100755
--- a/tests/xfs/120
+++ b/tests/xfs/120
@@ -74,7 +74,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/123 b/tests/xfs/123
index a7fae5f6..ced453bd 100755
--- a/tests/xfs/123
+++ b/tests/xfs/123
@@ -69,7 +69,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/124 b/tests/xfs/124
index f4b24dd6..50faa66b 100755
--- a/tests/xfs/124
+++ b/tests/xfs/124
@@ -78,8 +78,8 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/125 b/tests/xfs/125
index 3bdf73c4..c9ee2cf3 100755
--- a/tests/xfs/125
+++ b/tests/xfs/125
@@ -78,8 +78,8 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/126 b/tests/xfs/126
index 3f069c16..0ca0670c 100755
--- a/tests/xfs/126
+++ b/tests/xfs/126
@@ -83,8 +83,8 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 fi
 
 echo "+ repair fs"
-_scratch_xfs_repair >> $seqres.full 2>&1
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/130 b/tests/xfs/130
index b4404c5d..7ff565c6 100755
--- a/tests/xfs/130
+++ b/tests/xfs/130
@@ -71,7 +71,7 @@ _scratch_unmount >> $seqres.full 2>&1
 echo "+ repair fs"
 _disable_dmesg_check
 _repair_scratch_fs >> "$seqres.full" 2>&1
-_scratch_xfs_repair >> "$seqres.full" 2>&1
+_repair_scratch_fs >> "$seqres.full" 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount
diff --git a/tests/xfs/235 b/tests/xfs/235
index 553a3bc8..fe3a2cd0 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -72,7 +72,7 @@ fi
 echo "+ repair fs"
 _disable_dmesg_check
 _repair_scratch_fs >> "$seqres.full" 2>&1
-_scratch_xfs_repair >> $seqres.full 2>&1
+_repair_scratch_fs >> $seqres.full 2>&1
 
 echo "+ mount image (2)"
 _scratch_mount

