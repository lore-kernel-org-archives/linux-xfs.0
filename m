Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1107C4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 16:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbiKDQUx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 12:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiKDQU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 12:20:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB907748F0;
        Fri,  4 Nov 2022 09:20:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6857762272;
        Fri,  4 Nov 2022 16:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F90C433C1;
        Fri,  4 Nov 2022 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667578806;
        bh=Af/zlFdLzOXVN/OYL/6adEaVCAtveIEZHyaTWzci4uU=;
        h=From:To:Cc:Subject:Date:From;
        b=TJp3/BFw0J3NCK6fg8N5uO5UFj5IhO7BFaPpgvYXaqF8j4aNdxv1RQW2OZdVUTgY7
         YH9hSriZ3aBHRstAkr1lNKY3dhPm3hXqNO+Hk7IY0AZcxYKxlbEij/44nszMf7xm6l
         eqqEkGI8hS25lzgjae4nE2Iwda89L8R8nsOuEnNkd7Nry/xAoG5JRhPtxch4PinQut
         /YDSpLUTnzEH1R6kczjvzyOFd7FMaP7CT3XYy+uv0Vzkjq6KrhQNmIM70w7XemPbaE
         d+AwKDK238TuF+gFOXNBF5I1b1o61bNIFtoC6bWEk0NwDpTW1oX7pWvhokW/4YeGwR
         BiYLzKUbLsTMA==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] generic: shutdown might leave NULL files with nonzero di_size
Date:   Sat,  5 Nov 2022 00:20:02 +0800
Message-Id: <20221104162002.1912751-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

An old issue might cause on-disk inode sizes are logged prematurely
via the free eofblocks path on file close. Then fs shutdown might
leave NULL files but their di_size > 0.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

Hi,

There was an very old xfs bug on rhel-6.5, I'd like to share its reproducer to
fstests. I've tried generic/044~049, no one can reproduce this bug, so I
have to write this new one. It fails on rhel-6.5 [1], and test passed on
later kernel.

I hard to say which patch fix this issue exactly, it's fixed by a patchset
which does code improvement/cleanup.

Thanks,
Zorro

[1]
# ./check generic/999
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64
MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/loop1 /mnt/scratch

generic/999 2s ... - output mismatch (see /root/xfstests-dev/results//generic/999.out.bad)
    --- tests/generic/999.out   2022-11-04 00:54:11.123353054 -0400
    +++ /root/xfstests-dev/results//generic/999.out.bad 2022-11-04 04:24:57.861673433 -0400
    @@ -1 +1,3 @@
     QA output created by 999
    + - /mnt/scratch/1 get no extents, but its di_size > 0
    +/mnt/scratch/1:
    ...
    (Run 'diff -u tests/generic/045.out /root/xfstests-dev/results//generic/999.out.bad'  to see the entire diff)
Ran: generic/999
Failures: generic/999
Failed 1 of 1 tests

 tests/generic/999     | 46 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  5 +++++
 2 files changed, 51 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..a2e662fc
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,46 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 999
+#
+# Test an issue in the truncate codepath where on-disk inode sizes are logged
+# prematurely via the free eofblocks path on file close.
+#
+. ./common/preamble
+_begin_fstest auto quick shutdown
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_io_command fiemap
+_require_scratch_shutdown
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount
+
+echo "Create many small files with one extent at least"
+for ((i=0; i<10000; i++));do
+	$XFS_IO_PROG -f -c "pwrite 0 4k" $SCRATCH_MNT/file.$i >/dev/null 2>&1
+done
+
+echo "Shutdown the fs suddently"
+_scratch_shutdown
+
+echo "Cycle mount"
+_scratch_cycle_mount
+
+echo "Check file's (di_size > 0) extents"
+for f in $(find $SCRATCH_MNT -type f -size +0);do
+	$XFS_IO_PROG -c "fiemap" $f > $tmp.fiemap
+	# Check if the file has any extent
+	grep -Eq '^[[:space:]]+[0-9]+:' $tmp.fiemap
+	if [ $? -ne 0 ];then
+		echo " - $f get no extents, but its di_size > 0"
+		cat $tmp.fiemap
+		break
+	fi
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..50008783
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,5 @@
+QA output created by 999
+Create many small files with one extent at least
+Shutdown the fs suddently
+Cycle mount
+Check file's (di_size > 0) extents
-- 
2.31.1

