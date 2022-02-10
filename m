Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71BACC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Feb 2022 19:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344055AbiBJTnb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Feb 2022 14:43:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240254AbiBJTn3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Feb 2022 14:43:29 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 454F4DD1
        for <linux-xfs@vger.kernel.org>; Thu, 10 Feb 2022 11:43:30 -0800 (PST)
Received: by sandeen.net (Postfix, from userid 500)
        id 5DCC788; Thu, 10 Feb 2022 13:42:57 -0600 (CST)
From:   Eric Sandeen <sandeen@redhat.com>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: test xfsdump when an inode < root inode is present
Date:   Thu, 10 Feb 2022 13:42:57 -0600
Message-Id: <1644522177-8908-1-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This tests a longstanding bug where xfsdumps are not properly
created when an inode is present on the filesytsem which has
a lower number than the root inode.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 common/dump       |  1 +
 tests/xfs/543     | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/543.out | 47 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+)
 create mode 100644 tests/xfs/543
 create mode 100644 tests/xfs/543.out

diff --git a/common/dump b/common/dump
index 3c4029f..09a0ebc 100644
--- a/common/dump
+++ b/common/dump
@@ -214,6 +214,7 @@ _require_tape()
 
 _wipe_fs()
 {
+    [[ "$WIPE_FS" = "no" ]] && return
     _require_scratch
 
     _scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
diff --git a/tests/xfs/543 b/tests/xfs/543
new file mode 100644
index 0000000..f75f8da
--- /dev/null
+++ b/tests/xfs/543
@@ -0,0 +1,63 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat, Inc. All Rights Reserved.
+#
+# FS QA Test 543
+#
+# Create a filesystem which contains an inode with a lower number
+# than the root inode. Ensure that xfsdump/xfsrestore handles this.
+#
+. ./common/preamble
+_begin_fstest auto quick dump
+
+# Import common functions.
+. ./common/dump
+
+_supported_fs xfs
+_require_scratch
+
+# A large stripe unit will put the root inode out quite far
+# due to alignment, leaving free blocks ahead of it.
+_scratch_mkfs_xfs -d sunit=1024,swidth=1024 > $seqres.full
+
+# Mounting /without/ a stripe should allow inodes to be allocated
+# in lower free blocks, without the stripe alignment.
+_scratch_mount -o sunit=0,swidth=0
+
+root_inum=$(stat -c %i $SCRATCH_MNT)
+
+# Consume space after the root inode so that the blocks before
+# root look "close" for the next inode chunk allocation
+$XFS_IO_PROG -f -c "falloc 0 16m" $SCRATCH_MNT/fillfile
+
+# And make a bunch of inodes until we (hopefully) get one lower
+# than root, in a new inode chunk.
+echo "root_inum: $root_inum" >> $seqres.full
+for i in $(seq 0 4096) ; do
+	fname=$SCRATCH_MNT/$(printf "FILE_%03d" $i)
+	touch $fname
+	inum=$(stat -c "%i" $fname)
+	[[ $inum -lt $root_inum ]] && break
+done
+
+echo "created: $inum" >> $seqres.full
+
+[[ $inum -lt $root_inum ]] || _notrun "Could not set up test"
+
+# Now try a dump and restore. Cribbed from xfs/068
+WIPE_FS="no"
+_create_dumpdir_stress
+
+echo -n "Before: " >> $seqres.full
+_count_dumpdir_files | tee $tmp.before >> $seqres.full
+
+# filter out the file count, it changes as fsstress adds new operations
+_do_dump_restore | sed -e "/entries processed$/s/[0-9][0-9]*/NUM/g"
+
+echo -n "After: " >> $seqres.full
+_count_restoredir_files | tee $tmp.after >> $seqres.full
+diff -u $tmp.before $tmp.after
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/543.out b/tests/xfs/543.out
new file mode 100644
index 0000000..a5224aa
--- /dev/null
+++ b/tests/xfs/543.out
@@ -0,0 +1,47 @@
+QA output created by 543
+Creating directory system to dump using fsstress.
+
+-----------------------------------------------
+fsstress : -f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10
+-----------------------------------------------
+xfsdump|xfsrestore ...
+xfsdump  -s DUMP_SUBDIR - SCRATCH_MNT | xfsrestore  - RESTORE_DIR
+xfsrestore: using file dump (drive_simple) strategy
+xfsrestore: searching media for dump
+xfsrestore: examining media file 0
+xfsrestore: dump description: 
+xfsrestore: hostname: HOSTNAME
+xfsrestore: mount point: SCRATCH_MNT
+xfsrestore: volume: SCRATCH_DEV
+xfsrestore: session time: TIME
+xfsrestore: level: 0
+xfsrestore: session label: ""
+xfsrestore: media label: ""
+xfsrestore: file system ID: ID
+xfsrestore: session id: ID
+xfsrestore: media ID: ID
+xfsrestore: searching media for directory dump
+xfsrestore: reading directories
+xfsrestore: NUM directories and NUM entries processed
+xfsrestore: directory post-processing
+xfsrestore: restoring non-directory files
+xfsrestore: restore complete: SECS seconds elapsed
+xfsrestore: Restore Status: SUCCESS
+xfsdump: using file dump (drive_simple) strategy
+xfsdump: level 0 dump of HOSTNAME:SCRATCH_MNT
+xfsdump: dump date: DATE
+xfsdump: session id: ID
+xfsdump: session label: ""
+xfsdump: ino map <PHASES>
+xfsdump: ino map construction complete
+xfsdump: estimated dump size: NUM bytes
+xfsdump: /var/xfsdump/inventory created
+xfsdump: creating dump session media file 0 (media 0, file 0)
+xfsdump: dumping ino map
+xfsdump: dumping directories
+xfsdump: dumping non-directory files
+xfsdump: ending media file
+xfsdump: media file size NUM bytes
+xfsdump: dump size (non-dir files) : NUM bytes
+xfsdump: dump complete: SECS seconds elapsed
+xfsdump: Dump Status: SUCCESS
-- 
1.8.3.1

