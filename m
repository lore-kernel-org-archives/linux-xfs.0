Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8BECCA483
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 00:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiGMA47 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 20:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiGMA46 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 20:56:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC13C0519;
        Tue, 12 Jul 2022 17:56:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1026618AF;
        Wed, 13 Jul 2022 00:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E82CC3411E;
        Wed, 13 Jul 2022 00:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657673817;
        bh=B3klj5s2G38OP3A28fEXSIL/9iqBE6ukOP7T7dYS+AI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GcrRpm3sjOrHAwyOKiCEzpWmxy4K6dPhfFYGUZAcG+BKGEZMD3/IeYHXCebzB9+km
         TiyjB2giQfo7ZJUoVBMzpNB9WIfuBwbhdRdQQvLXVkdTUAFVaLx5TQK7Dmwr9eDD9b
         eVDLZBJL4Nl+qnkRxf3mMQCj/fKiumI9wJPLUMtLtKosZeOVQGXN9Vl6SBUklvIcRr
         MdCvmVVtS8j0THt7laKAq7yEBbO7zN/1GR6h7SGtG+6x/WaLMa7C22JuhoxuQq3Fac
         mm4RckVWNis52zk3Na5uGWUbpUzWpr87ID0sG0MvKsdNOSGl8V+UUzZvMGX4Oncxgm
         jfdpj8p7uQNsw==
Subject: [PATCH 4/8] misc: avoid tests encoding FIEMAP/BMAP golden output with
 weird file blocksizes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 12 Jul 2022 17:56:56 -0700
Message-ID: <165767381664.869123.9367666114806642722.stgit@magnolia>
In-Reply-To: <165767379401.869123.10167117467658302048.stgit@magnolia>
References: <165767379401.869123.10167117467658302048.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Some tests encode FIEMAP/XFS_IOC_BMAP results in the golden output.
Typically these tests cannot handle a filesystem that chooses to
allocate extents that are much larger than the filesystem block size
(aka XFS rt extents and ext4 bigalloc).  Since these tests are /never/
going to pass, disable them when these configurations are detected.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/483 |    4 ++++
 tests/generic/677 |    4 ++++
 tests/xfs/166     |    4 ++++
 tests/xfs/203     |    4 ++++
 4 files changed, 16 insertions(+)


diff --git a/tests/generic/483 b/tests/generic/483
index e7120362..39129542 100755
--- a/tests/generic/483
+++ b/tests/generic/483
@@ -35,6 +35,10 @@ _require_metadata_journaling $SCRATCH_DEV
 _init_flakey
 _mount_flakey
 
+# The fiemap results in the golden output requires file allocations to align to
+# 256K boundaries.
+_require_congruent_file_oplen $SCRATCH_MNT 262144
+
 # Create our test files.
 $XFS_IO_PROG -f -c "pwrite -S 0xea 0 256K" $SCRATCH_MNT/foo >/dev/null
 
diff --git a/tests/generic/677 b/tests/generic/677
index 39af90a9..4dbfed7d 100755
--- a/tests/generic/677
+++ b/tests/generic/677
@@ -38,6 +38,10 @@ _require_metadata_journaling $SCRATCH_DEV
 _init_flakey
 _mount_flakey
 
+# The fiemap results in the golden output requires file allocations to align to
+# 1MB boundaries.
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
+
 # Create our test file with many extents.
 # On btrfs this results in having multiple leaves of metadata full of file
 # extent items, a condition necessary to trigger the original bug.
diff --git a/tests/xfs/166 b/tests/xfs/166
index d45dc5e8..9e082152 100755
--- a/tests/xfs/166
+++ b/tests/xfs/166
@@ -71,6 +71,10 @@ TEST_PROG=$here/src/unwritten_mmap
 # we need to set the file size to (6 * 2MB == 12MB) to cover all cases.
 FILE_SIZE=$((12 * 1048576))
 
+# The xfs_bmap results in the golden output requires file allocations to align
+# to 1M boundaries.
+_require_congruent_file_oplen $SCRATCH_MNT $FILE_SIZE
+
 rm -f $TEST_FILE
 $TEST_PROG $FILE_SIZE $TEST_FILE
 
diff --git a/tests/xfs/203 b/tests/xfs/203
index a12ae7c3..9a4a4564 100755
--- a/tests/xfs/203
+++ b/tests/xfs/203
@@ -51,6 +51,10 @@ _require_scratch
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount > /dev/null 2>&1
 
+# The xfs_bmap results in the golden output requires file allocations to align
+# to 64k boundaries.
+_require_congruent_file_oplen $SCRATCH_MNT 65536
+
 for i in 10 14 15 16 17 28 29 30 31; do
         rm -f $SCRATCH_MNT/hole_file
 	_write_holes $SCRATCH_MNT/hole_file${i} ${i}

