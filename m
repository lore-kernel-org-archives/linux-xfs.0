Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AACC43334
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 15:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238405AbiGHPcH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 11:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237833AbiGHPcF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 11:32:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AC95C9FE;
        Fri,  8 Jul 2022 08:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D2E7B828A5;
        Fri,  8 Jul 2022 15:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5DCC341C6;
        Fri,  8 Jul 2022 15:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657294321;
        bh=2gMNkfyYf62t5nnhb2rcw1TZFjxiaH8d8IpE4BKS1BI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j2FXqUGTJ0Kp4d8CJyeP9fRDYS3ncQHDMs+HF8Yi4A3EiqnihIEiBJPGithtBNDFy
         3ng37wsWgvLjBWiag/o7WvukPNeKuKFiHXGBMNEWlfoiGeDzmRRmg2569bPkKtELzk
         zZxhZD/evV/VUTORXm8iqqOmym+sJ+WVbHAwvW7O/kbmJCwE5wIx36kguUCSIfThIF
         CVo0BQMUb612q0S3U7lgxUr25UOXztpnTffoXxfnPrGHxgjSyaXq5VDSKgNwwRqqNH
         6GL2u+4peyJo99BYEFaI2LNhF/aGtugUG5ukiJ/Rn+5Jpuka3/UFVmHHfLa1xLIGV5
         aZVYaPb9/AzEQ==
Date:   Fri, 8 Jul 2022 08:32:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v1.1 1/2] xfs: make sure that we handle empty xattr leaf
 blocks ok
Message-ID: <YshN8cIvhmVRvm/m@magnolia>
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
---
 tests/xfs/845 |  123 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100755 tests/xfs/845

diff --git a/tests/xfs/845 b/tests/xfs/845
new file mode 100755
index 00000000..0b7f4bff
--- /dev/null
+++ b/tests/xfs/845
@@ -0,0 +1,123 @@
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
+	magic=$(_scratch_xfs_get_metadata_field hdr.info.magic "inode $inum" "ablock 0")
+	if [ "$magic" != "0x3bee" ]; then
+		echo "attr block 0 expected magic 0x3bee, got $magic??"
+	fi
+
+	magic=$(_scratch_xfs_get_metadata_field hdr.info.hdr.magic "inode $inum" "ablock 0")
+	if [ "$magic" != "0x3bee" ]; then
+		echo "inode $inum ablock 0 is not a leaf block?"
+		_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" -c print >> $seqres.full
+		return 1
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
