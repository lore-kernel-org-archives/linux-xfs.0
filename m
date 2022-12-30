Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F9DC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbiLaDM4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiLaDMw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:12:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4221104;
        Fri, 30 Dec 2022 19:12:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 390E861C7A;
        Sat, 31 Dec 2022 03:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962C0C433D2;
        Sat, 31 Dec 2022 03:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456370;
        bh=5gb8gOV2WSksboeh00mHimIquLenmLulpvlNM7oPxvU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jAT0zYk3EWddz0GhFLGdPxSyPeqYWaTWMX9Igvlwxg2+LVf7NI/RIlOstiGTBLvy4
         sOAFh2eln+36/a+QtRmWSHq2RqgF/wCK/KDFeORWgGoThFLqajF13jvwV4MwJAaRQx
         wyNNdD0Rte8IEQFoIV5WXq968hlCwPVAFC6bDMQAhWsiEfjpSAZ6REVxEJ7+oNz9QY
         vXrq3Z2bFOu0LcYtW6o5OfJS5UVe11RA+gp14R4BO4t1wMqoujSSAOqKrtYZaTy8/+
         3a4HOH9qG5WJv5s+P/xkk8JaAMDfk1lJkwvSHjXGZRNQH6tXUFD2XvUOK8NHALwTM3
         StPCKwGCGKgbQ==
Subject: [PATCH 01/13] xfs: fix tests that try to access the realtime rmap
 inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:44 -0800
Message-ID: <167243884407.739669.14948742406779742441.stgit@magnolia>
In-Reply-To: <167243884390.739669.13524725872131241203.stgit@magnolia>
References: <167243884390.739669.13524725872131241203.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The realtime rmap tests were added to fstests a long time ago.  Since
they were added, we decided to create a metadata file directory
structure instead of adding more fields to the superblock.  Therefore,
fix all the tests that try to access these paths.

While we're at it, fix xfs/409 to run the *online* scrub program like
it's supposed to.  xfs/408 is the fuzzer for xfs_repair testing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs        |   18 ++++++++++++++++++
 tests/xfs/122.out |    1 -
 tests/xfs/333     |   45 ---------------------------------------------
 tests/xfs/333.out |    6 ------
 tests/xfs/337     |    2 +-
 tests/xfs/338     |   21 ++++++++++++++++-----
 tests/xfs/339     |    5 +++--
 tests/xfs/340     |   15 ++++++++++-----
 tests/xfs/341     |    2 +-
 tests/xfs/342     |    4 ++--
 10 files changed, 51 insertions(+), 68 deletions(-)
 delete mode 100755 tests/xfs/333
 delete mode 100644 tests/xfs/333.out


diff --git a/common/xfs b/common/xfs
index f451dfb8ae..aea2b678c8 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1922,3 +1922,21 @@ _require_xfs_scratch_metadir()
 		_scratch_unmount
 	fi
 }
+
+# Resolve a metadata directory tree path and return the inode number.
+_scratch_metadir_lookup() {
+	local res="$(_scratch_xfs_db -c "ls -i -m $1")"
+	test "${PIPESTATUS[0]}" -eq 0 && echo "$res"
+}
+
+# Figure out which directory entry we have to change to update the rtrmap
+# inode pointer.  Assumes the /realtime directory is a short format dir.
+_scratch_find_rt_metadir_entry() {
+	local sfkey="$(_scratch_xfs_db -c 'path -m /realtime' -c print | \
+		grep "\"$1\"" | \
+		sed -e 's/.name.*$//g' -e 's/\[/\\[/g' -e 's/\]/\\]/g' )"
+	test -n "$sfkey" || return 1
+	_scratch_xfs_db -c 'path -m /realtime' -c print | \
+		grep "${sfkey}.inumber" | awk '{print $1}'
+	return 0
+}
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 1379c7b3b5..53eff0027e 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -48,7 +48,6 @@ offsetof(xfs_sb_t, sb_rgblklog) = 280
 offsetof(xfs_sb_t, sb_rgblocks) = 272
 offsetof(xfs_sb_t, sb_rgcount) = 276
 offsetof(xfs_sb_t, sb_rootino) = 56
-offsetof(xfs_sb_t, sb_rrmapino) = 264
 offsetof(xfs_sb_t, sb_rsumino) = 72
 offsetof(xfs_sb_t, sb_sectlog) = 121
 offsetof(xfs_sb_t, sb_sectsize) = 102
diff --git a/tests/xfs/333 b/tests/xfs/333
deleted file mode 100755
index 728c518402..0000000000
--- a/tests/xfs/333
+++ /dev/null
@@ -1,45 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
-#
-# FS QA Test No. 333
-#
-# Set rrmapino to another inode on an non-rt rmap fs and see if repair fixes it.
-#
-. ./common/preamble
-_begin_fstest auto quick rmap realtime
-
-# Import common functions.
-. ./common/filter
-
-# real QA test starts here
-_supported_fs xfs
-_require_xfs_scratch_rmapbt
-_disable_dmesg_check
-
-rm -f "$seqres.full"
-
-unset SCRATCH_RTDEV
-
-echo "Format and mount"
-_scratch_mkfs > "$seqres.full" 2>&1
-rrmapino="$(_scratch_xfs_db -c 'sb 0' -c 'p rrmapino' 2>&1)"
-test "${rrmapino}" = "field rrmapino not found" && _notrun "realtime rmapbt not supported"
-_scratch_mount
-
-echo "Create some files"
-$XFS_IO_PROG -f -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f1 >> $seqres.full
-$XFS_IO_PROG -f -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f2 >> $seqres.full
-echo garbage > $SCRATCH_MNT/f3
-ino=$(stat -c '%i' $SCRATCH_MNT/f3)
-_scratch_unmount
-
-echo "Corrupt fs"
-_scratch_xfs_db -x -c 'sb 0' -c "write rrmapino $ino" >> $seqres.full
-_try_scratch_mount 2>&1 | _filter_error_mount
-
-echo "Test done, mount should have failed"
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/333.out b/tests/xfs/333.out
deleted file mode 100644
index b3c698750f..0000000000
--- a/tests/xfs/333.out
+++ /dev/null
@@ -1,6 +0,0 @@
-QA output created by 333
-Format and mount
-Create some files
-Corrupt fs
-mount: Structure needs cleaning
-Test done, mount should have failed
diff --git a/tests/xfs/337 b/tests/xfs/337
index f74baae9b0..9ea8587b27 100755
--- a/tests/xfs/337
+++ b/tests/xfs/337
@@ -53,7 +53,7 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || echo "xfs_repair should not fail"
 
 echo "+ corrupt image"
-_scratch_xfs_db -x -c "sb" -c "addr rrmapino" -c "addr u3.rtrmapbt.ptrs[1]" \
+_scratch_xfs_db -x -c "path -m /realtime/0.rmap" -c "addr u3.rtrmapbt.ptrs[1]" \
 	-c "stack" -c "blocktrash -x 4096 -y 4096 -n 8 -3 -z" \
 	>> $seqres.full 2>&1
 
diff --git a/tests/xfs/338 b/tests/xfs/338
index 9f36150c7e..9d41a83ec2 100755
--- a/tests/xfs/338
+++ b/tests/xfs/338
@@ -29,13 +29,24 @@ $XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f2 >> $seqres.full
 _scratch_unmount
 
 echo "Corrupt fs"
-_scratch_xfs_db -x -c 'sb 0' -c 'addr rrmapino' \
-	-c 'write core.nlinkv2 0' -c 'write core.mode 0' -c 'sb 0' \
-	-c 'write rrmapino 0' >> $seqres.full
-_try_scratch_mount >> $seqres.full 2>&1 && echo "mount should have failed"
+rtrmap_sfentry="$(_scratch_find_rt_metadir_entry 0.rmap)"
+test -n "$rtrmap_sfentry" || _fail "Could not find rtrmap metadir entry?"
+_scratch_xfs_db -x -c 'path -m /realtime/0.rmap' \
+	-c 'write core.nlinkv2 0' -c 'write core.mode 0' \
+	-c 'path -m /realtime' \
+	-c "write $rtrmap_sfentry 0" >> $seqres.full
+if _try_scratch_mount >> $seqres.full 2>&1; then
+       echo "mount should have failed"
+       _scratch_unmount
+else
+	# If the verifiers are working properly, the mount will fail because
+	# we fuzzed the metadata root directory.  This causes loud complaints
+	# to dmesg, so we want to ignore those.
+	_disable_dmesg_check
+fi
 
 echo "Repair fs"
-_scratch_unmount 2>&1 | _filter_scratch
+_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 _repair_scratch_fs >> $seqres.full 2>&1
 
 echo "Try to create more files (again)"
diff --git a/tests/xfs/339 b/tests/xfs/339
index 3e0b4d97ab..24a90d0ba3 100755
--- a/tests/xfs/339
+++ b/tests/xfs/339
@@ -31,7 +31,8 @@ ln $SCRATCH_MNT/f3 $SCRATCH_MNT/f4
 _scratch_unmount
 
 echo "Corrupt fs"
-rrmapino=`_scratch_xfs_get_sb_field rrmapino`
+rrmapino=$(_scratch_metadir_lookup /realtime/0.rmap)
+test -n "$rrmapino" || _fail "Could not find rtrmap inode?"
 _scratch_xfs_set_metadata_field "u3.sfdir3.list[3].inumber.i4" $rrmapino \
 	'sb 0' 'addr rootino' >> $seqres.full
 _scratch_mount
@@ -43,7 +44,7 @@ echo "Try to create more files"
 $XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f5 >> $seqres.full 2>&1
 
 echo "Repair fs"
-_scratch_unmount 2>&1 | _filter_scratch
+_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 _repair_scratch_fs >> $seqres.full 2>&1
 
 echo "Try to create more files (again)"
diff --git a/tests/xfs/340 b/tests/xfs/340
index 2c0014513e..1236f6520f 100755
--- a/tests/xfs/340
+++ b/tests/xfs/340
@@ -31,16 +31,21 @@ ino=$(stat -c '%i' $SCRATCH_MNT/f3)
 _scratch_unmount
 
 echo "Corrupt fs"
-rrmapino=$(_scratch_xfs_get_sb_field rrmapino)
-_scratch_xfs_db -x -c "inode $rrmapino" \
+rtrmap_sfentry="$(_scratch_find_rt_metadir_entry 0.rmap)"
+test -n "$rtrmap_sfentry" || _fail "Could not find rtrmap metadir entry?"
+rrmapino=$(_scratch_metadir_lookup /realtime/0.rmap)
+test -n "$rrmapino" || _fail "Could not find rtrmap inode?"
+_scratch_xfs_db -x -c "path -m /realtime/0.rmap" \
 	-c 'write core.format 2' -c 'write core.size 0' \
-	-c 'write core.nblocks 0' -c 'sb 0' -c 'addr rootino' \
+	-c 'write core.nblocks 0' \
+	-c 'sb 0' -c 'addr rootino' \
 	-c "write u3.sfdir3.list[2].inumber.i4 $rrmapino" \
-	-c 'sb 0' -c "write rrmapino $ino" >> $seqres.full
+	-c 'path -m /realtime' \
+	-c "write $rtrmap_sfentry $ino" >> $seqres.full
 _try_scratch_mount >> $seqres.full 2>&1 && echo "mount should have failed"
 
 echo "Repair fs"
-_scratch_unmount 2>&1 | _filter_scratch
+_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 _repair_scratch_fs >> $seqres.full 2>&1
 
 echo "Try to create more files (again)"
diff --git a/tests/xfs/341 b/tests/xfs/341
index 7d2842b579..8861e751a9 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -53,7 +53,7 @@ echo "Corrupt fs"
 fsbno=$(_scratch_xfs_db -c "inode $ino" -c 'bmap' | grep 'flag 0' | head -n 1 | \
 	sed -e 's/^.*startblock \([0-9]*\) .*$/\1/g')
 
-_scratch_xfs_db -x -c 'sb 0' -c 'addr rrmapino' \
+_scratch_xfs_db -x -c 'path -m /realtime/0.rmap' \
 	-c "write u3.rtrmapbt.ptrs[1] $fsbno" -c 'p' >> $seqres.full
 _scratch_mount
 
diff --git a/tests/xfs/342 b/tests/xfs/342
index 538c8987ef..f29bd874e9 100755
--- a/tests/xfs/342
+++ b/tests/xfs/342
@@ -47,9 +47,9 @@ ino=$(stat -c '%i' $SCRATCH_MNT/f3)
 _scratch_unmount
 
 echo "Corrupt fs"
-_scratch_xfs_db -c 'sb 0' -c 'addr rrmapino' -c 'p u3.rtrmapbt.ptrs[1]' >> $seqres.full
+_scratch_xfs_db -c 'path -m /realtime/0.rmap' -c 'p u3.rtrmapbt.ptrs[1]' >> $seqres.full
 
-fsbno=$(_scratch_xfs_db -c 'sb 0' -c 'addr rrmapino' \
+fsbno=$(_scratch_xfs_db -c 'path -m /realtime/0.rmap' \
 	-c 'p u3.rtrmapbt.ptrs[1]' | sed -e 's/^.*://g')
 _scratch_xfs_db -x -c "inode $ino" -c "write u3.bmx[0].startblock $fsbno" >> $seqres.full
 _scratch_mount

