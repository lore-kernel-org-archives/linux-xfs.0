Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6469BC7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241924AbjEZCFB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241041AbjEZCFA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:05:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E418A3;
        Thu, 25 May 2023 19:04:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C862364C4C;
        Fri, 26 May 2023 02:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C04C433EF;
        Fri, 26 May 2023 02:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066698;
        bh=sUnxusCjM7KbBV1sOapwU/pO0WMHXTiwdOMaQy9glDE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=gHAZjFjqIU9n03AaaFsfOnx3uSAEckLd384p22BVZHB36vLWj043k9ztO5Zy+Zo2P
         IiCKDePC9oWY70XR91w9g/zTbbZJ2pA3mQuX2jN0nS5p2eMTOTeAFarQHY/39KTPmb
         dlvnLnYH4Zrc3b8T6yy0vPi+sVx20WWIShWSJH0eClUiDz1MqXPZ4uw1Xy7rwcQFNt
         PgvMekjHAa536lpHB9cVnep3c/JQix1gXnDR9WUzndQnhVNjfXCGe/yEjzh7j3O2ha
         5vXm8vdq0JL9khh+2pGfx7eYLHT3uuIKC5QYaMnNlrN26HqkJp3UzL/SOXvR58DXKA
         1wNtZyIgExVYg==
Date:   Thu, 25 May 2023 19:04:57 -0700
Subject: [PATCH 11/11] xfs: add parent pointer inject test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <168506060996.3732476.15225791466368855642.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
References: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add a test to verify parent pointers after an error injection and log
replay.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/853     |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/853.out |   14 +++++++++
 2 files changed, 99 insertions(+)
 create mode 100755 tests/xfs/853
 create mode 100644 tests/xfs/853.out


diff --git a/tests/xfs/853 b/tests/xfs/853
new file mode 100755
index 0000000000..f17f4b7e9e
--- /dev/null
+++ b/tests/xfs/853
@@ -0,0 +1,85 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test 853
+#
+# parent pointer inject test
+#
+. ./common/preamble
+_begin_fstest auto quick parent
+
+# get standard environment, filters and checks
+. ./common/filter
+. ./common/inject
+. ./common/parent
+
+# Modify as appropriate
+_supported_fs xfs
+_require_scratch
+_require_xfs_sysfs debug/larp
+_require_xfs_io_error_injection "larp"
+_require_xfs_parent
+_require_xfs_io_command "parent"
+
+# real QA test starts here
+
+# Create a directory tree using a protofile and
+# make sure all inodes created have parent pointers
+
+protofile=$tmp.proto
+
+cat >$protofile <<EOF
+DUMMY1
+0 0
+: root directory
+d--777 3 1
+: a directory
+testfolder1 d--755 3 1
+$
+: back in the root
+testfolder2 d--755 3 1
+: done
+$
+EOF
+
+_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
+	|| _fail "mkfs failed"
+_check_scratch_fs
+
+_scratch_mount >>$seqres.full 2>&1 \
+	|| _fail "mount failed"
+
+testfolder1="testfolder1"
+testfolder2="testfolder2"
+file4="file4"
+file5="file5"
+
+echo ""
+
+# Create files
+touch $SCRATCH_MNT/$testfolder1/$file4
+_verify_parent "$testfolder1" "$file4" "$testfolder1/$file4"
+
+# Inject error
+_scratch_inject_error "larp"
+
+# Move files
+mv $SCRATCH_MNT/$testfolder1/$file4 $SCRATCH_MNT/$testfolder2/$file5 2>&1 \
+	| _filter_scratch
+
+# FS should be shut down, touch will fail
+touch $SCRATCH_MNT/$testfolder2/$file5 2>&1 | _filter_scratch
+
+# Remount to replay log
+_scratch_remount_dump_log >> $seqres.full
+
+# FS should be online, touch should succeed
+touch $SCRATCH_MNT/$testfolder2/$file5
+
+# Check files again
+_verify_parent "$testfolder2" "$file5" "$testfolder2/$file5"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/853.out b/tests/xfs/853.out
new file mode 100644
index 0000000000..56247c1434
--- /dev/null
+++ b/tests/xfs/853.out
@@ -0,0 +1,14 @@
+QA output created by 853
+
+*** testfolder1 OK
+*** testfolder1/file4 OK
+*** testfolder1/file4 OK
+*** Verified parent pointer: name:file4, namelen:5
+*** Parent pointer OK for child testfolder1/file4
+mv: cannot stat 'SCRATCH_MNT/testfolder1/file4': Input/output error
+touch: cannot touch 'SCRATCH_MNT/testfolder2/file5': Input/output error
+*** testfolder2 OK
+*** testfolder2/file5 OK
+*** testfolder2/file5 OK
+*** Verified parent pointer: name:file5, namelen:5
+*** Parent pointer OK for child testfolder2/file5

