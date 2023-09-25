Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F73CE79A7
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbjIYVnW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjIYVnV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:43:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BFF10C;
        Mon, 25 Sep 2023 14:43:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD252C433C8;
        Mon, 25 Sep 2023 21:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695678194;
        bh=IOW/GSv4wHG69tfUanWcuI1ZPzmdrC+oXYsV8igykkc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rQvBEps2QRISeGhzInvEMTD+o0Gi1k7zH8LXze0X4ZTVzb4d4tCWyUTXx+KYWGxqS
         iLTQIREdKTjecgN9QJ/nN4WKcZhg/+iu08Bz51uezkWTVnDpTmid/8aVF7sa1TkD2w
         rO8+JJrb0kpvo7IAG2kk1eDTxI7I4q8BxXWN5L8ikhFlCoQvo+m0CB0aLV7D8SDL/T
         z7VhDa/l9iEyLdgQfLOC61J9ZP7qcY+yvueGDNcDgmeDtYZ4LWqsxNhWvXOKLnwSre
         bvw4FJ0u3He0fWYlX9NOXyJkGrde1ucqSigHBVds7WyLMuk/opQvXURcMJhjU5nlWQ
         4JIkMNDN8flKw==
Subject: [PATCH 1/1] generic: test FALLOC_FL_UNSHARE when pagecache is not
 loaded
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        ritesh.list@gmail.com, willy@infradead.org
Date:   Mon, 25 Sep 2023 14:43:14 -0700
Message-ID: <169567819441.2270025.10851897053852323695.stgit@frogsfrogsfrogs>
In-Reply-To: <169567818883.2270025.5159423425609776304.stgit@frogsfrogsfrogs>
References: <169567818883.2270025.5159423425609776304.stgit@frogsfrogsfrogs>
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
---
 tests/xfs/1936     |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1936.out |    4 ++
 2 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/1936
 create mode 100644 tests/xfs/1936.out


diff --git a/tests/xfs/1936 b/tests/xfs/1936
new file mode 100755
index 0000000000..e07b8f4796
--- /dev/null
+++ b/tests/xfs/1936
@@ -0,0 +1,88 @@
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
+. ./common/attr
+. ./common/reflink
+
+_fixed_by_git_commit kernel XXXXXXXXXXXXX \
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

