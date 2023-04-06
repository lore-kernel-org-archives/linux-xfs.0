Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB327C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbjDFToh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjDFTog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:44:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FECFF;
        Thu,  6 Apr 2023 12:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22F2560FA9;
        Thu,  6 Apr 2023 19:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BC4C433D2;
        Thu,  6 Apr 2023 19:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810274;
        bh=sUnxusCjM7KbBV1sOapwU/pO0WMHXTiwdOMaQy9glDE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=V0zmeZLEDe3u3+xFAXWXaSb70UZKxQWY6K9aWNPvzK8lJGu2mBRul7FOdRBFJhm6J
         +CFflVSyxgOHNRRYwEhF97gDOjfSIYLMzn5D3YD/2qVtJrEAlK2inrTp4G06tUSW7/
         /r6CFTbm35dhsEGNZPH4FtW7n5CtEeM7i6JMa9YgUiFQstywhuM0jcsgObFr6gi2/k
         rgcM4bJEHONoPQOFvuXm79NRJD14sxWkO+7vEtu7BHJWiNApTR8o5+G5MwZCo2bBHr
         f9h+Ltk58mIJE/NtUGQEW2+Gd3VCDqhkYW9WKEaV3F1Tjk5X7cjkBVRSAUVViaiXB7
         BJC3nkXTjBaKw==
Date:   Thu, 06 Apr 2023 12:44:34 -0700
Subject: [PATCH 11/11] xfs: add parent pointer inject test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <168080829152.618488.13192901728535024449.stgit@frogsfrogsfrogs>
In-Reply-To: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
References: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
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

