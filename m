Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74387C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 17:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbiGHRo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 13:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239045AbiGHRo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 13:44:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DDC6D55A;
        Fri,  8 Jul 2022 10:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 549D162478;
        Fri,  8 Jul 2022 17:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD326C341C0;
        Fri,  8 Jul 2022 17:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657302263;
        bh=YujimOPalUOJxH21y640RyMY+NzmC3EOWz5j12vQjK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o5oSnaGcRU636IBdAxyaNkqruxb/FEAzwV6OG4WbBvmhgLSBmmwdOU9mIET1eArYk
         LMOyWLMTcWiIsSWrsXEsXBwePi7pz2JTQ0dR/Od7YXLhRHXHQpCrd+qNMgBJB6E3Rp
         17bG13xMOmOtXr8dkau5KmMg1HWAwdxn/D4RXEVCRQs5hFoB7sbN0ONFATOob10/lE
         z61AAM8XaUy7rw+0TSdBc5Z3I9xs62oV/fzlwYUiPYgHe7XWRRyHCFTSysyUR3iiJA
         pFVxZ1eC8xAnisehel+kXYkiL53L1XWlBzK5gHAAPeH1JImt50t8Lxv92oFOn1ya6k
         BSN9QojzM/TDg==
Date:   Fri, 8 Jul 2022 10:44:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v1.3 1/2] xfs: make sure that we handle empty xattr leaf
 blocks ok
Message-ID: <Yshs92tcVVVEJDRf@magnolia>
References: <165705854325.2821854.10317059026052442189.stgit@magnolia>
 <165705854877.2821854.7070105861462675249.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165705854877.2821854.7070105861462675249.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that the kernel can handle empty xattr leaf blocks properly,
since we've screwed this up enough times.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: adopt maintainer's refactoring suggestions, skip v4 filesystems
from the start, and check that we really get an attr leaf block.
v1.2: eliminate dead code
v1.3: actually add golden output
---
 tests/xfs/845     |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/845.out |    7 +++
 2 files changed, 124 insertions(+)
 create mode 100755 tests/xfs/845
 create mode 100644 tests/xfs/845.out

diff --git a/tests/xfs/845 b/tests/xfs/845
new file mode 100755
index 00000000..c142fba1
--- /dev/null
+++ b/tests/xfs/845
@@ -0,0 +1,117 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 845
+#
+# Make sure that XFS can handle empty leaf xattr blocks correctly.  These
+# blocks can appear in files as a result of system crashes in the middle of
+# xattr operations, which means that we /must/ handle them gracefully.
+# Check that read and write verifiers won't trip, that the get/list/setxattr
+# operations don't stumble over them, and that xfs_repair will offer to remove
+# the entire xattr fork if the root xattr leaf block is empty.
+#
+# Regression test for kernel commit:
+#
+# af866926d865 ("xfs: empty xattr leaf header blocks are not corruption")
+#
+. ./common/preamble
+_begin_fstest auto quick attr
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_scratch_xfs_crc # V4 is deprecated
+_fixed_by_kernel_commit af866926d865 "xfs: empty xattr leaf header blocks are not corruption"
+
+_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
+cat $tmp.mkfs >> $seqres.full
+source $tmp.mkfs
+_scratch_mount
+
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 64k' $SCRATCH_MNT/largefile >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $isize" $SCRATCH_MNT/smallfile >> $seqres.full
+
+smallfile_md5=$(_md5_checksum $SCRATCH_MNT/smallfile)
+largefile_md5=$(_md5_checksum $SCRATCH_MNT/largefile)
+
+# Try to force the creation of a single leaf block in each of three files.
+# The first one gets a local attr, the second a remote attr, and the third
+# is left for scrub and repair to find.
+touch $SCRATCH_MNT/e0
+touch $SCRATCH_MNT/e1
+touch $SCRATCH_MNT/e2
+
+$ATTR_PROG -s x $SCRATCH_MNT/e0 < $SCRATCH_MNT/smallfile >> $seqres.full
+$ATTR_PROG -s x $SCRATCH_MNT/e1 < $SCRATCH_MNT/smallfile >> $seqres.full
+$ATTR_PROG -s x $SCRATCH_MNT/e2 < $SCRATCH_MNT/smallfile >> $seqres.full
+
+e0_ino=$(stat -c '%i' $SCRATCH_MNT/e0)
+e1_ino=$(stat -c '%i' $SCRATCH_MNT/e1)
+e2_ino=$(stat -c '%i' $SCRATCH_MNT/e2)
+
+_scratch_unmount
+
+# We used to think that it wasn't possible for empty xattr leaf blocks to
+# exist, but it turns out that setting a large xattr on a file that has no
+# xattrs can race with a log flush and crash, which results in an empty
+# leaf block being logged and recovered.  This is rather hard to trip, so we
+# use xfs_db to turn a regular leaf block into an empty one.
+make_empty_leaf() {
+	local inum="$1"
+
+	echo "editing inode $inum" >> $seqres.full
+
+	magic=$(_scratch_xfs_get_metadata_field hdr.info.hdr.magic "inode $inum" "ablock 0")
+	if [ "$magic" != "0x3bee" ]; then
+		_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" -c print >> $seqres.full
+		_fail "inode $inum ablock 0 is not a leaf block?"
+	fi
+
+	base=$(_scratch_xfs_get_metadata_field "hdr.freemap[0].base" "inode $inum" "ablock 0")
+
+	_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" \
+		-c "write -d hdr.count 0" \
+		-c "write -d hdr.usedbytes 0" \
+		-c "write -d hdr.firstused $dbsize" \
+		-c "write -d hdr.freemap[0].size $((dbsize - base))" \
+		-c print >> $seqres.full
+}
+
+make_empty_leaf $e0_ino
+make_empty_leaf $e1_ino
+make_empty_leaf $e2_ino
+
+_scratch_mount
+
+# Check that listxattr/getxattr/removexattr do nothing.
+$ATTR_PROG -l $SCRATCH_MNT/e0 2>&1 | _filter_scratch
+$ATTR_PROG -g x $SCRATCH_MNT/e0 2>&1 | _filter_scratch
+$ATTR_PROG -r x $SCRATCH_MNT/e0 2>&1 | _filter_scratch
+
+# Add a small attr to e0
+$ATTR_PROG -s x $SCRATCH_MNT/e0 < $SCRATCH_MNT/smallfile > /dev/null
+$ATTR_PROG -l $SCRATCH_MNT/e0 2>&1 | sed -e 's/\([0-9]*\) byte/XXX byte/g' | _filter_scratch
+small_md5="$($GETFATTR_PROG -n user.x --absolute-names --only-values $SCRATCH_MNT/e0 | _md5_checksum)"
+test "$small_md5" = "$smallfile_md5" || \
+	echo "smallfile $smallfile_md5 does not match small attr $small_md5"
+
+# Add a large attr to e1
+$ATTR_PROG -s x $SCRATCH_MNT/e1 < $SCRATCH_MNT/largefile > /dev/null
+$ATTR_PROG -l $SCRATCH_MNT/e1 2>&1 | _filter_scratch
+large_md5="$($GETFATTR_PROG -n user.x --absolute-names --only-values $SCRATCH_MNT/e1 | _md5_checksum)"
+test "$large_md5" = "$largefile_md5" || \
+	echo "largefile $largefile_md5 does not match large attr $large_md5"
+
+
+# Leave e2 to try to trip the repair tools, since xfs_repair used to flag
+# empty leaf blocks incorrectly too.
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/845.out b/tests/xfs/845.out
new file mode 100644
index 00000000..be4e5b7c
--- /dev/null
+++ b/tests/xfs/845.out
@@ -0,0 +1,7 @@
+QA output created by 845
+attr_get: No data available
+Could not get "x" for SCRATCH_MNT/e0
+attr_remove: No data available
+Could not remove "x" for SCRATCH_MNT/e0
+Attribute "x" has a XXX byte value for SCRATCH_MNT/e0
+Attribute "x" has a 65536 byte value for SCRATCH_MNT/e1
