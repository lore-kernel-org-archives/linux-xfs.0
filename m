Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50698C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbiLaDaT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbiLaD3o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:29:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864D71704C;
        Fri, 30 Dec 2022 19:29:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11FAB612E3;
        Sat, 31 Dec 2022 03:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73571C433EF;
        Sat, 31 Dec 2022 03:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457382;
        bh=1hgt7bZaH9dBlTm7iMCXYvUaOeS4c+IYMXfqBCoum/I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YDABoz6ho6d8eG35ryXresZSv8h0zmFsI+IutJfEZQ0mXvA+62WpvEkUq47RrHheo
         wb6Hkzxmdc7ytEi2sXKSaSERDmzJPscYRUAle8N89kYwVO/xkJbB9LJnv3d0nlpWG5
         1+46qR+XWEMCxYiFd2wALEGKBNUo7w7MPz5mfxg/m2qqdLsRSmSA3zA/LS+HaUXQiG
         z2Xlm56MhwmGas6DG/i0T0uLHuDit5bAIBSZ97YU9clrLmnj+6G7Gev4N0IU8PsPAq
         KB0jXor3gSyZXIIWiA7DMdXmTMtj8x1Td92WSusOrjkyiS92fWiWS7vNipg9Auq1MD
         wqUod4h7Bi4OA==
Subject: [PATCH 1/1] xfs: test output of new FSREFCOUNTS ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:21:14 -0800
Message-ID: <167243887496.742012.13989453986321624787.stgit@magnolia>
In-Reply-To: <167243887484.742012.14569558642146398379.stgit@magnolia>
References: <167243887484.742012.14569558642146398379.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure the cursors work properly and that refcounts are correct.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc           |    4 +
 doc/group-names.txt |    1 
 tests/xfs/921       |  168 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/921.out   |    4 +
 4 files changed, 175 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/921
 create mode 100644 tests/xfs/921.out


diff --git a/common/rc b/common/rc
index 3c30a444fe..20fe51f502 100644
--- a/common/rc
+++ b/common/rc
@@ -2543,8 +2543,8 @@ _require_xfs_io_command()
 		echo $testio | grep -q "Operation not supported" && \
 			_notrun "O_TMPFILE is not supported"
 		;;
-	"fsmap")
-		testio=`$XFS_IO_PROG -f -c "fsmap" $testfile 2>&1`
+	"fsmap"|"fsrefcounts")
+		testio=`$XFS_IO_PROG -f -c "$command" $testfile 2>&1`
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
 		;;
diff --git a/doc/group-names.txt b/doc/group-names.txt
index e88dcc0fdd..8bcf21919b 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -56,6 +56,7 @@ freeze			filesystem freeze tests
 fsck			general fsck tests
 fsmap			FS_IOC_GETFSMAP ioctl
 fsr			XFS free space reorganizer
+fsrefcounts		FS_IOC_GETFSREFCOUNTS ioctl
 fuzzers			filesystem fuzz tests
 growfs			increasing the size of a filesystem
 hardlink		hardlinks
diff --git a/tests/xfs/921 b/tests/xfs/921
new file mode 100755
index 0000000000..bc9894b1d7
--- /dev/null
+++ b/tests/xfs/921
@@ -0,0 +1,168 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 921
+#
+# Populate filesystem, check that fsrefcounts -n10000 matches fsrefcounts -n1,
+# then verify that the refcount information is consistent with the fsmap info.
+#
+. ./common/preamble
+_begin_fstest auto clone fsrefcounts fsmap
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.* $TEST_DIR/a $TEST_DIR/b
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_io_command "fsmap"
+_require_xfs_io_command "fsrefcounts"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+cpus=$(( $(src/feature -o) * 4))
+
+# Use fsstress to create a directory tree with some variability
+FSSTRESS_ARGS=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 4000 $FSSTRESS_AVOID)
+$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full
+
+echo "Compare fsrefcounts" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsrefcounts -m -n 65536' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/a
+$XFS_IO_PROG -c 'fsrefcounts -m -n 1' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/b
+cat $TEST_DIR/a $TEST_DIR/b >> $seqres.full
+
+diff -uw $TEST_DIR/a $TEST_DIR/b
+
+echo "Compare fsrefcounts to fsmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsmap -m -n 65536' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/b
+cat $TEST_DIR/b >> $seqres.full
+
+while IFS=',' read ext major minor pstart pend owners length crap; do
+	test "$ext" = "EXT" && continue
+
+	awk_args=(-'F' ',' '-v' "major=$major" '-v' "minor=$minor" \
+		  '-v' "pstart=$pstart" '-v' "pend=$pend" '-v' "owners=$owners")
+
+	if [ "$owners" -eq 1 ]; then
+		$AWK_PROG "${awk_args[@]}" \
+'
+BEGIN {
+	printf("Q:%s:%s:%s:%s:%s:\n", major, minor, pstart, pend, owners) > "/dev/stderr";
+	next_map = -1;
+}
+{
+	if ($2 != major || $3 != minor) {
+		next;
+	}
+	if ($5 <= pstart) {
+		next;
+	}
+
+	printf(" A:%s:%s:%s:%s\n", $2, $3, $4, $5) > "/dev/stderr";
+	if (next_map < 0) {
+		if ($4 > pstart) {
+			exit 1
+		}
+		next_map = $5 + 1;
+	} else {
+		if ($4 != next_map) {
+			exit 1
+		}
+		next_map = $5 + 1;
+	}
+	if (next_map >= pend) {
+		nextfile;
+	}
+}
+END {
+	exit 0;
+}
+' $TEST_DIR/b 2> $tmp.debug
+		res=$?
+	else
+		$AWK_PROG "${awk_args[@]}" \
+'
+function max(a, b) {
+	return a > b ? a : b;
+}
+function min(a, b) {
+	return a < b ? a : b;
+}
+BEGIN {
+	printf("Q:%s:%s:%s:%s:%s:\n", major, minor, pstart, pend, owners) > "/dev/stderr";
+	refcount_whole = 0;
+	aborted = 0;
+}
+{
+	if ($2 != major || $3 != minor) {
+		next;
+	}
+	if ($4 >= pend) {
+		nextfile;
+	}
+	if ($5 <= pstart) {
+		next;
+	}
+	if ($6 == "special_0:2") {
+		/* unknown owner means we cannot distinguish separate owners */
+		aborted = 1;
+		exit 0;
+	}
+
+	printf(" A:%s:%s:%s:%s -> %d\n", $2, $3, $4, $5, refcount_whole) > "/dev/stderr";
+	if ($4 <= pstart && $5 >= pend) {
+		/* Account for extents that span the whole range */
+		refcount_whole++;
+	} else {
+		/* Otherwise track refcounts per-block as we find them */
+		for (block = max($4, pstart); block <= min($5, pend); block++) {
+			refcounts[block]++;
+		}
+	}
+}
+END {
+	if (aborted) {
+		exit 0;
+	}
+	deficit = owners - refcount_whole;
+	printf(" W:%d:%d\n", owners, refcount_whole, deficit) > "/dev/stderr";
+	if (deficit == 0) {
+		exit 0;
+	}
+
+	refcount_slivers = 0;
+	for (block in refcounts) {
+		printf(" X:%s:%d\n", block, refcounts[block]) > "/dev/stderr";
+		if (refcounts[block] == deficit) {
+			refcount_slivers = deficit;
+		} else {
+			exit 1;
+		}
+	}
+
+	refcount_whole += refcount_slivers;
+	exit owners == refcount_whole ? 0 : 1;
+}
+' $TEST_DIR/b 2> $tmp.debug
+		res=$?
+	fi
+	if [ $res -ne 0 ]; then
+		echo "$major,$minor,$pstart,$pend,$owners not found in fsmap"
+		cat $tmp.debug >> $seqres.full
+		break
+	fi
+done < $TEST_DIR/a
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/921.out b/tests/xfs/921.out
new file mode 100644
index 0000000000..a181d357cd
--- /dev/null
+++ b/tests/xfs/921.out
@@ -0,0 +1,4 @@
+QA output created by 921
+Format and mount
+Compare fsrefcounts
+Compare fsrefcounts to fsmap

