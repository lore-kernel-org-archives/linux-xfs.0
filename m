Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA84C433EA
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88F3C619DB
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhCaBIv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 21:08:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232401AbhCaBIg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:08:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A3AC619C1;
        Wed, 31 Mar 2021 01:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152916;
        bh=tNKYNINkwBQFb6YnVmhPWA6Rf7IrRz3Xtm4x7yTZahQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iWrwpxKyacFtq7fm9ZM357HaJrZW8bEg0W0DZ5AxuNWxD08kGWfdkyc88yIM0IdOM
         OyRD7tzUbhzkVvNDabAWtvqKPCbR0DHDtVE27gsQnp6/48asaE706D8ELr6Br6noi3
         WDH8I4bZhUUeB6yNByasNNaxQ5qSd/FrtdVJSzzrWY+Up1KKFRniTVm/horihnlL95
         bykFO+j1BmyVu5tIObKFm//bFhOkWyrwpwxwqZWAIQ5u3cAYn3DcwPyZ9TzL+HWfoQ
         y/owidmmgJb4X2w7z0zrEe4SAMu83FpY82Idb/owH0FNJnxnWsIBLYyyFVwBMLMiZQ
         X/SEOX4Kji4cQ==
Subject: [PATCH 2/2] xfs: test inobtcount upgrade
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 30 Mar 2021 18:08:34 -0700
Message-ID: <161715291407.2703879.12588572306371939752.stgit@magnolia>
In-Reply-To: <161715290311.2703879.6182444659830603450.stgit@magnolia>
References: <161715290311.2703879.6182444659830603450.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure we can actually upgrade filesystems to support inode btree
counters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/910     |  112 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/910.out |   23 +++++++++++
 tests/xfs/group   |    1 
 3 files changed, 136 insertions(+)
 create mode 100755 tests/xfs/910
 create mode 100644 tests/xfs/910.out


diff --git a/tests/xfs/910 b/tests/xfs/910
new file mode 100755
index 00000000..5f095324
--- /dev/null
+++ b/tests/xfs/910
@@ -0,0 +1,112 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 910
+#
+# Check that we can upgrade a filesystem to support inobtcount and that
+# everything works properly after the upgrade.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_scratch_inobtcount
+_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+_require_xfs_repair_upgrade inobtcount
+
+rm -f $seqres.full
+
+# Make sure we can't format a filesystem with inobtcount and not finobt.
+_scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
+	echo "Should not be able to format with inobtcount but not finobt."
+
+# Make sure we can't upgrade a V4 filesystem
+_scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
+_check_scratch_xfs_features INOBTCNT
+
+# Make sure we can't upgrade a filesystem to inobtcount without finobt.
+_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
+_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
+_check_scratch_xfs_features INOBTCNT
+
+# Format V5 filesystem without inode btree counter support and upgrade it.
+# Inject failure into repair and make sure that the only path forward is
+# to re-run repair on the filesystem.
+_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+echo "Fail partway through upgrading"
+XFS_REPAIR_FAIL_AFTER_PHASE=2 _scratch_xfs_repair -c inobtcount=1 2>> $seqres.full
+test $? -eq 137 || echo "repair should have been killed??"
+_check_scratch_xfs_features NEEDSREPAIR INOBTCNT
+_try_scratch_mount &> $tmp.mount
+res=$?
+_filter_scratch < $tmp.mount
+if [ $res -eq 0 ]; then
+	echo "needsrepair should have prevented mount"
+	_scratch_unmount
+fi
+
+echo "Re-run repair to finish upgrade"
+_scratch_xfs_repair 2>> $seqres.full
+_check_scratch_xfs_features NEEDSREPAIR INOBTCNT
+
+echo "Filesystem should be usable again"
+_try_scratch_mount &> $tmp.mount
+res=$?
+_filter_scratch < $tmp.mount
+if [ $res -eq 0 ]; then
+	_scratch_unmount
+else
+	echo "mount should succeed after second repair"
+fi
+_check_scratch_xfs_features NEEDSREPAIR INOBTCNT
+
+# Format V5 filesystem without inode btree counter support and upgrade it.
+_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+_scratch_mount >> $seqres.full
+
+echo moo > $SCRATCH_MNT/urk
+
+_scratch_unmount
+_check_scratch_fs
+
+# Now upgrade to inobtcount support
+_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
+_check_scratch_xfs_features INOBTCNT
+_check_scratch_fs
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' -c 'agi 0' -c 'p' >> $seqres.full
+
+# Make sure we have nonzero counters
+_scratch_xfs_db -c 'agi 0' -c 'print ino_blocks fino_blocks' | \
+	sed -e 's/= [1-9]*/= NONZERO/g'
+
+# Mount again, look at our files
+_scratch_mount >> $seqres.full
+cat $SCRATCH_MNT/urk
+
+# Make sure we can't re-add inobtcount
+_scratch_unmount
+_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
+_scratch_mount >> $seqres.full
+
+status=0
+exit
diff --git a/tests/xfs/910.out b/tests/xfs/910.out
new file mode 100644
index 00000000..ed78d88f
--- /dev/null
+++ b/tests/xfs/910.out
@@ -0,0 +1,23 @@
+QA output created by 910
+Running xfs_repair to upgrade filesystem.
+Inode btree count feature only supported on V5 filesystems.
+FEATURES: INOBTCNT:NO
+Running xfs_repair to upgrade filesystem.
+Inode btree count feature requires free inode btree.
+FEATURES: INOBTCNT:NO
+Fail partway through upgrading
+Adding inode btree counts to filesystem.
+FEATURES: NEEDSREPAIR:YES INOBTCNT:YES
+mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
+Re-run repair to finish upgrade
+FEATURES: NEEDSREPAIR:NO INOBTCNT:YES
+Filesystem should be usable again
+FEATURES: NEEDSREPAIR:NO INOBTCNT:YES
+Running xfs_repair to upgrade filesystem.
+Adding inode btree counts to filesystem.
+FEATURES: INOBTCNT:YES
+ino_blocks = NONZERO
+fino_blocks = NONZERO
+moo
+Running xfs_repair to upgrade filesystem.
+Filesystem already has inode btree counts.
diff --git a/tests/xfs/group b/tests/xfs/group
index 5801471b..0dc8038a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -524,3 +524,4 @@
 768 auto quick repair
 770 auto repair
 773 auto quick repair
+910 auto quick inobtcount

