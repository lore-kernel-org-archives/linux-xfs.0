Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A14CD611C
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 18:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377544AbjJISTG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 14:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbjJISTF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 14:19:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98207AC;
        Mon,  9 Oct 2023 11:19:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8A3C433CA;
        Mon,  9 Oct 2023 18:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696875544;
        bh=5cWMsie43drUfyI6xaTQky87LERjXeLZ7WB/MR0wzAU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XoX0ybhiLSmhJl34gZhKdni004uYx0L1ex31ieQ1CPz8h3mBtpaj4FkFa7fJNZuTm
         IKpPHMW1KmcRCgzybXgFOeRKpdqF/09qddjSrx7MMjkZHMZgS+9RInD69Kjxj34BzU
         p8tIgYTubkqv+IWUjHZVQeI6yrRNtK+acunDhqTpMataEx3xyHYk/hKlVIywxiUgVR
         k5ns6F9vdAvkBpYN4lrG9yih8zM8G+qbzjod4a76r2nbKwrIYZ8nzxsgbAEElfYQMD
         V/2mAtqFMrGY3H9hfiz/v+/6yvKzjsYDkd4Xf814vPa1PGYMo7qp8mDBjd4y8TZvVu
         Q29QhoYamEjaw==
Subject: [PATCH 1/1] generic: test FALLOC_FL_UNSHARE when pagecache is not
 loaded
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        ritesh.list@gmail.com, willy@infradead.org
Date:   Mon, 09 Oct 2023 11:19:03 -0700
Message-ID: <169687554366.3949152.2864477369744294080.stgit@frogsfrogsfrogs>
In-Reply-To: <169687553806.3949152.10461541168914314461.stgit@frogsfrogsfrogs>
References: <169687553806.3949152.10461541168914314461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a regression test for funsharing uncached files to ensure that we
actually manage the pagecache state correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 tests/xfs/1936     |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1936.out |    4 ++
 2 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/1936
 create mode 100644 tests/xfs/1936.out


diff --git a/tests/xfs/1936 b/tests/xfs/1936
new file mode 100755
index 0000000000..4f183f17d7
--- /dev/null
+++ b/tests/xfs/1936
@@ -0,0 +1,87 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1936
+#
+# This is a regression test for the kernel commit noted below.  The stale
+# memory exposure can be exploited by creating a file with shared blocks,
+# evicting the page cache for that file, and then funshareing at least one
+# memory page's worth of data.  iomap will mark the page uptodate and dirty
+# without ever reading the ondisk contents.
+#
+. ./common/preamble
+_begin_fstest auto quick unshare clone
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $testdir
+}
+
+# real QA test starts here
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+_fixed_by_git_commit kernel 35d30c9cf127 \
+	"iomap: don't skip reading in !uptodate folios when unsharing a range"
+
+# real QA test starts here
+_require_test_reflink
+_require_cp_reflink
+_require_xfs_io_command "funshare"
+
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
+
+# Create a file that is at least four pages in size and aligned to the
+# file allocation unit size so that we don't trigger any unnecessary zeroing.
+pagesz=$(_get_page_size)
+alloc_unit=$(_get_file_block_size $TEST_DIR)
+filesz=$(( ( (4 * pagesz) + alloc_unit - 1) / alloc_unit * alloc_unit))
+
+echo "Create the original file and a clone"
+_pwrite_byte 0x61 0 $filesz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x61 0 $filesz $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file3
+
+_test_cycle_mount
+
+cat $testdir/file3 > /dev/null
+
+echo "Funshare at least one pagecache page"
+$XFS_IO_PROG -c "funshare 0 $filesz" $testdir/file2
+$XFS_IO_PROG -c "funshare 0 $filesz" $testdir/file3
+_pwrite_byte 0x61 0 $filesz $testdir/file2.chk >> $seqres.full
+
+echo "Check contents"
+
+# file2 wasn't cached when it was unshared, but it should match
+if ! cmp -s $testdir/file2.chk $testdir/file2; then
+	echo "file2.chk does not match file2"
+
+	echo "file2.chk contents" >> $seqres.full
+	od -tx1 -Ad -c $testdir/file2.chk >> $seqres.full
+	echo "file2 contents" >> $seqres.full
+	od -tx1 -Ad -c $testdir/file2 >> $seqres.full
+	echo "end bad contents" >> $seqres.full
+fi
+
+# file3 was cached when it was unshared, and it should match
+if ! cmp -s $testdir/file2.chk $testdir/file3; then
+	echo "file2.chk does not match file3"
+
+	echo "file2.chk contents" >> $seqres.full
+	od -tx1 -Ad -c $testdir/file2.chk >> $seqres.full
+	echo "file3 contents" >> $seqres.full
+	od -tx1 -Ad -c $testdir/file3 >> $seqres.full
+	echo "end bad contents" >> $seqres.full
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1936.out b/tests/xfs/1936.out
new file mode 100644
index 0000000000..c7c820ced5
--- /dev/null
+++ b/tests/xfs/1936.out
@@ -0,0 +1,4 @@
+QA output created by 1936
+Create the original file and a clone
+Funshare at least one pagecache page
+Check contents

