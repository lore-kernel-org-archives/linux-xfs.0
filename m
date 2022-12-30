Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF9BC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235765AbiLaAlT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiLaAlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:41:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97541D0C8;
        Fri, 30 Dec 2022 16:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8461D61D52;
        Sat, 31 Dec 2022 00:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB737C433EF;
        Sat, 31 Dec 2022 00:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447276;
        bh=yLjJKAEJUiu3N1MjaYqZHEqzaeNJVvJT7ZO3+YlYZTI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jhbUcWGTPa+naUSFBHtE15Z5S+sDTQtzJva0iwUvNI+SYbFH2053XKuzWBTeFejaK
         PPJpHxox7KhW8wQzeeSpM5nTAZ6c7Olo/OT4FI4j+6oQ9ZlSv/HuI/PKcH6ZJZr2MZ
         7yVxvEBGvCvyCZ1xQdW6vVnwiVBaJbTO7CaBxvwkkOEZci88viVaK8HfQycBMj36su
         3KvMqNF0Yhr2tS+/qcl8OS9/rPams8RVavdI8RIHJip2q6l1kV2W5wKUWlqtkKSVOV
         nE+cnGV/dEeL4hfdan/vWVAVSLDNVxzMJKEX+AxngFJvAfHeG7ZgxZSzv138KnJuqo
         NR8my0nZ0DEbw==
Subject: [PATCH 1/4] xfs: test rebuilding xattrs when the data fork is btree
 format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:18 -0800
Message-ID: <167243875848.725760.14160153508359415137.stgit@magnolia>
In-Reply-To: <167243875835.725760.8458608166534095780.stgit@magnolia>
References: <167243875835.725760.8458608166534095780.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure we handle the case of rebuilding extended attributes properly
when the data fork is in btree format and we therefore cannot zap the
attr fork.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/746     |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/746.out |    2 +
 2 files changed, 87 insertions(+)
 create mode 100755 tests/xfs/746
 create mode 100644 tests/xfs/746.out


diff --git a/tests/xfs/746 b/tests/xfs/746
new file mode 100755
index 0000000000..5853259e84
--- /dev/null
+++ b/tests/xfs/746
@@ -0,0 +1,85 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 746
+#
+# Make sure online repair can handle rebuilding xattrs when the data fork is
+# in btree format and we cannot just zap the attr fork.
+
+. ./common/preamble
+_begin_fstest auto quick online_repair
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+}
+
+# Import common functions.
+. ./common/inject
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_io_error_injection "force_repair"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "repair"
+_require_test_program "punch-alternating"
+
+_scratch_mkfs > $tmp.mkfs
+_scratch_mount
+
+_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
+
+# Force data device extents so that we can create a file with the exact bmbt
+# that we need regardless of rt configuration.
+_xfs_force_bdev data $SCRATCH_MNT
+
+file=$SCRATCH_MNT/moofile
+touch $file
+
+# Create some xattrs so that we have to rebuild them.
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 76' $file.txt >> $seqres.full
+$SETFATTR_PROG -n user.SGI_BCL_FILE -v "$(cat $file.txt)" $file
+
+$SETFATTR_PROG -n user.crtime_usec -v 12345678 $file
+
+blksz=$(_get_file_block_size $SCRATCH_MNT)
+ino=$(stat -c '%i' $file)
+
+# Figure out how many extents we need to have to create a data fork that's in
+# btree format.
+umount $SCRATCH_MNT
+di_forkoff=$(_scratch_xfs_db -c "inode $ino" -c "p core.forkoff" | \
+	awk '{print $3}')
+_scratch_xfs_db -c "inode $ino" -c "p" >> $seqres.full
+_scratch_mount
+
+# Create a data fork in btree format
+min_ext_for_btree=$((di_forkoff * 8 / 16))
+$XFS_IO_PROG -c "falloc 0 $(( (min_ext_for_btree + 1) * 2 * blksz))" $file
+$here/src/punch-alternating $file
+
+# Make sure the data fork is in btree format.
+umount $SCRATCH_MNT
+_scratch_xfs_db -c "inode $ino" -c "p core.format" | grep -q "btree" || \
+	echo "data fork not in btree format?"
+echo "about to start test" >> $seqres.full
+_scratch_xfs_db -c "inode $ino" -c "p" >> $seqres.full
+_scratch_mount
+
+# Force repair the xattr fork
+_scratch_inject_error force_repair
+$XFS_IO_PROG -x -c 'repair xattr' $file 2>&1 | tee $tmp.repair.log
+grep -q 'Operation not supported' $tmp.repair.log && \
+	_notrun "online xattr repair not supported"
+
+# If online repair did it correctly, the filesystem won't be corrupt.  Let the
+# post-test check do its thing.
+
+# success, all done
+echo "Silence is golden."
+status=0
+exit
diff --git a/tests/xfs/746.out b/tests/xfs/746.out
new file mode 100644
index 0000000000..365485b0b3
--- /dev/null
+++ b/tests/xfs/746.out
@@ -0,0 +1,2 @@
+QA output created by 746
+Silence is golden.

