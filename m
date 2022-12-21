Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C99C3DA6E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 00:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbiLUAWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 19:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiLUAWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 19:22:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F26D1D0F9;
        Tue, 20 Dec 2022 16:22:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE9A7B81AC3;
        Wed, 21 Dec 2022 00:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE8DC433F0;
        Wed, 21 Dec 2022 00:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671582122;
        bh=KYiX3pm4ohlM5vP001K74vZ2DZyQNZx8aZDkffrHxlM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fad8nInShhFLpRV57de7t+ikKjHykBfAbRlxpYxAEEwpdjdfut6YdJulxuTv+p7vx
         SjEACbfDogc00ks0aD7tPAIH6zadNi40/QjSI8URDk6uypryr19D9AC08Ric8oinAn
         01Hy4ITBCNO2Ucsy0zTEB+KFsJOp/af6SNql4D4+ig4Zq6RGuyfYHeMYb0NSVdxu9C
         bAH6tB4qQTqlA/IpoEr5GtbM8SDxiRDKGadBCcucpKT7ZVEKx22hOMD7n9kGxUHUzX
         GQG9dVHbFQQRi4kQOKGAhjlKFC1vd04foHC0L3TMdJytRCOS6MDml7VU9ujyrCxkkl
         rJmH5xlMYj0Pg==
Subject: [PATCH 3/3] xfs/179: modify test to trigger refcount update bugs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Dec 2022 16:22:02 -0800
Message-ID: <167158212200.235429.7810725831092358840.stgit@magnolia>
In-Reply-To: <167158210534.235429.10062024114428012379.stgit@magnolia>
References: <167158210534.235429.10062024114428012379.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Upon enabling fsdax + reflink for XFS, this test began to report
refcount metadata corruptions after being run.  Specifically, xfs_repair
noticed single-block refcount records that could be combined but had not
been.

The root cause of this is improper MAXREFCOUNT edge case handling in
xfs_refcount_merge_extents.  When we're trying to find candidates for a
record merge, we compute the refcount of the merged record, but without
accounting for the fact that once a record hits rc_refcount ==
MAXREFCOUNT, it is pinned that way forever.

Adjust this test to use a sub-filesize write for one of the COW writes,
because this is how we force the extent merge code to run.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/179 |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/179 b/tests/xfs/179
index ec0cb7e5b4..98b01476c9 100755
--- a/tests/xfs/179
+++ b/tests/xfs/179
@@ -21,17 +21,29 @@ _require_scratch_nocheck
 _require_cp_reflink
 _require_test_program "punch-alternating"
 
+_fixed_by_kernel_commit b25d1984aa88 \
+	"xfs: estimate post-merge refcounts correctly"
+
 echo "Format and mount"
 _scratch_mkfs -d agcount=1 > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
+# This test modifies the refcount btree on the data device, so we must force
+# rtinherit off so that the test files are created there.
+_xfs_force_bdev data $SCRATCH_MNT
+
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
+# Set the file size to 10x the block size to guarantee that the COW writes will
+# touch multiple blocks and exercise the refcount extent merging code.  This is
+# necessary to catch a bug in the refcount extent merging code that handles
+# MAXREFCOUNT edge cases.
 blksz=65536
+filesz=$((blksz * 10))
 
 echo "Create original files"
-_pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $filesz $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 
 echo "Change reference count"
@@ -56,9 +68,23 @@ _scratch_xfs_db -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' >> $seqres.full
 _scratch_mount >> $seqres.full
 
 echo "CoW a couple files"
-_pwrite_byte 0x62 0 $blksz $testdir/file3 >> $seqres.full
-_pwrite_byte 0x62 0 $blksz $testdir/file5 >> $seqres.full
+_pwrite_byte 0x62 0 $filesz $testdir/file3 >> $seqres.full
+_pwrite_byte 0x62 0 $filesz $testdir/file5 >> $seqres.full
+
+# For the last COW test, write single blocks at the start, middle, and end of
+# the shared file to exercise a refcount btree update that targets a single
+# block of the multiblock refcount record that we just modified.
+#
+# This trips a bug where XFS didn't correctly identify refcount record merge
+# candidates when any of the records are pinned at MAXREFCOUNT.  The bug was
+# originally discovered by enabling fsdax + reflink, but the bug can be
+# triggered by any COW that doesn't target the entire extent.
+#
+# The bug was fixed by kernel commit b25d1984aa88 ("xfs: estimate post-merge
+# refcounts correctly")
 _pwrite_byte 0x62 0 $blksz $testdir/file7 >> $seqres.full
+_pwrite_byte 0x62 $((blksz * 4)) $blksz $testdir/file7 >> $seqres.full
+_pwrite_byte 0x62 $((filesz - blksz)) $blksz $testdir/file7 >> $seqres.full
 
 echo "Check scratch fs"
 _scratch_unmount

