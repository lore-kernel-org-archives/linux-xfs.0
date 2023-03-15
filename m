Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF99BC6FD1F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjCOA6X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjCOA6W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:58:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F00126C0C;
        Tue, 14 Mar 2023 17:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E77EBB81C20;
        Wed, 15 Mar 2023 00:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A7FC433EF;
        Wed, 15 Mar 2023 00:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841897;
        bh=jNHo5S+D7q0cAHPJ/X0B3Ojk5kWA9mvCyQlbk5AWi8Y=;
        h=Date:From:To:Cc:Subject:From;
        b=fnf80Pqtz707u+IPuPjdSSR0TDbnamXB/t2uXajJn3M/Rti9+b05+9WJOp72PSLWO
         FLPxIE7mErILdJFAiRBAOxMlKl98/NNaFSM9YGYM4pZKN01qSFVVVIBLdPIf139MB6
         y6+Zvo6TmYtw2/OiKHyUvqdIOUCCJUNUOyZZoOLrxjpTqBs1DWWPUpCf/2bmHjEapB
         XP2Iv6pQJAkmG/Y//UfC+rLlolHmy361Veso3I5/erJbVA8JgZD02B0SjePceG1F6b
         CBm7tjaUN5B4g5Ezf28X1dmVE8o79d2iUoO94OXGYn9noxfLb+Ob+Nfs+PgDXm87RE
         kE+3y1/Hi6DWw==
Date:   Tue, 14 Mar 2023 17:58:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] xfs: stress test cycling parent pointers with online repair
Message-ID: <20230315005817.GA11360@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a couple of new tests to exercise directory and parent pointer
repair against rename() calls moving child subdirectories from one
parent to another.  This is a useful test because it turns out that the
VFS doesn't lock the child subdirectory (it does lock the parents), so
repair must be more careful.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy      |   15 +++++++++++++++
 tests/xfs/854     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/854.out |    2 ++
 tests/xfs/855     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/855.out |    2 ++
 5 files changed, 95 insertions(+)
 create mode 100755 tests/xfs/854
 create mode 100644 tests/xfs/854.out
 create mode 100755 tests/xfs/855
 create mode 100644 tests/xfs/855.out

diff --git a/common/fuzzy b/common/fuzzy
index 4609df4434..744d9ed65d 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -995,6 +995,20 @@ __stress_scrub_fsstress_loop() {
 	local focus=()
 
 	case "$stress_tgt" in
+	"parent")
+		focus+=('-z')
+
+		# Create a directory tree very gradually
+		for op in creat link mkdir; do
+			focus+=('-f' "${op}=2")
+		done
+		focus+=('-f' 'unlink=1' '-f' 'rmdir=1')
+
+		# But do a lot of renames to cycle parent pointers
+		for op in rename rnoreplace rexchange; do
+			focus+=('-f' "${op}=40")
+		done
+		;;
 	"dir")
 		focus+=('-z')
 
@@ -1285,6 +1299,7 @@ __stress_scrub_check_commands() {
 #       'writeonly': Only perform fs updates, no reads.
 #       'symlink': Only create symbolic links.
 #       'mknod': Only create special files.
+#       'parent': Focus on updating parent pointers
 #
 #       The default is 'default' unless XFS_SCRUB_STRESS_TARGET is set.
 # -X	Run this program to exercise the filesystem.  Currently supported
diff --git a/tests/xfs/854 b/tests/xfs/854
new file mode 100755
index 0000000000..0aa2c2ee4f
--- /dev/null
+++ b/tests/xfs/854
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 854
+#
+# Race fsstress doing mostly renames and xfs_scrub in force-repair mode for a
+# while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	cd /
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -S '-k' -x 'parent'
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/854.out b/tests/xfs/854.out
new file mode 100644
index 0000000000..f8d9e27958
--- /dev/null
+++ b/tests/xfs/854.out
@@ -0,0 +1,2 @@
+QA output created by 854
+Silence is golden
diff --git a/tests/xfs/855 b/tests/xfs/855
new file mode 100755
index 0000000000..6daff05995
--- /dev/null
+++ b/tests/xfs/855
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 855
+#
+# Race fsstress doing mostly renames and xfs_scrub in read-only mode for a
+# while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	cd /
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -S '-n' -x 'parent'
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/855.out b/tests/xfs/855.out
new file mode 100644
index 0000000000..fa60f65432
--- /dev/null
+++ b/tests/xfs/855.out
@@ -0,0 +1,2 @@
+QA output created by 855
+Silence is golden
