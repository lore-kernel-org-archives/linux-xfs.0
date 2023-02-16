Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D8CC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBPVPo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjBPVPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:15:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09A53B864;
        Thu, 16 Feb 2023 13:15:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 676EBB828F3;
        Thu, 16 Feb 2023 21:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17777C433D2;
        Thu, 16 Feb 2023 21:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582140;
        bh=oG/f1YZSqCAzAZUDFyY8e2++Y/BLPgZKrrEls47nU2I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=AV0RQLNPzZFtClRlHq8to24AqmnCseFrEsZjc2V3IZx01KmxkL2c0UyovtgTHfs4g
         zTh2IOXqCZyb/2uEmB/CDRfGgelD+ScDgs6ZqAz3fOwWoZnBEcJ1M59bUpwQvLTosW
         YpvXNT59WW54bpVaVDre6CWga7vSyryK4ywc5G1/o833w1Rx+7nK0VeX2TgzvDvUd+
         Tg39i5VTIAy6FVFxinfuuT71LIqmdRtD0W54KqK3jChdGwmihOnXd+VZFxFkR/EMmu
         gyRqh/xn7wndQBEXMmI3m9bvIBMSxYRuym+fuWFH44mSNEhBreat+/nmgBJj/z4dYa
         oRs46yI+IS9HQ==
Date:   Thu, 16 Feb 2023 13:15:39 -0800
Subject: [PATCH 08/14] xfs: add parent pointer test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884593.3481377.2320664505396382774.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add a test to verify basic parent pointers operations (create, move, link,
unlink, rename, overwrite).

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 doc/group-names.txt |    1 +
 tests/xfs/851       |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/851.out   |   59 ++++++++++++++++++++++++++++++
 3 files changed, 161 insertions(+)
 create mode 100755 tests/xfs/851
 create mode 100644 tests/xfs/851.out


diff --git a/doc/group-names.txt b/doc/group-names.txt
index 8bcf21919b..569a32d9bb 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -82,6 +82,7 @@ nfs4_acl		NFSv4 access control lists
 nonsamefs		overlayfs layers on different filesystems
 online_repair		online repair functionality tests
 other			dumping ground, do not add more tests to this group
+parent			Parent pointer tests
 pattern			specific IO pattern tests
 perms			access control and permission checking
 pipe			pipe functionality
diff --git a/tests/xfs/851 b/tests/xfs/851
new file mode 100755
index 0000000000..27870ec05a
--- /dev/null
+++ b/tests/xfs/851
@@ -0,0 +1,101 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test 851
+#
+# simple parent pointer test
+#
+
+. ./common/preamble
+_begin_fstest auto quick parent
+
+# get standard environment, filters and checks
+. ./common/parent
+
+# Modify as appropriate
+_supported_fs xfs
+_require_scratch
+_require_xfs_sysfs debug/larp
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
+file1 ---755 3 1 /dev/null
+$
+: back in the root
+testfolder2 d--755 3 1
+file2 ---755 3 1 /dev/null
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
+file1="file1"
+file2="file2"
+file3="file3"
+file1_ln="file1_link"
+
+echo ""
+# Create parent pointer test
+_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1"
+
+echo ""
+# Move parent pointer test
+mv $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder2/$file1
+_verify_parent "$testfolder2" "$file1" "$testfolder2/$file1"
+
+echo ""
+# Hard link parent pointer test
+ln $SCRATCH_MNT/$testfolder2/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln
+_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
+_verify_parent "$testfolder1" "$file1_ln" "$testfolder2/$file1"
+_verify_parent "$testfolder2" "$file1"    "$testfolder1/$file1_ln"
+_verify_parent "$testfolder2" "$file1"    "$testfolder2/$file1"
+
+echo ""
+# Remove hard link parent pointer test
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file1)"
+rm $SCRATCH_MNT/$testfolder2/$file1
+_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
+_verify_no_parent "$file1" "$ino" "$testfolder1/$file1_ln"
+
+echo ""
+# Rename parent pointer test
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln)"
+mv $SCRATCH_MNT/$testfolder1/$file1_ln $SCRATCH_MNT/$testfolder1/$file2
+_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
+_verify_no_parent "$file1_ln" "$ino" "$testfolder1/$file2"
+
+echo ""
+# Over write parent pointer test
+touch $SCRATCH_MNT/$testfolder2/$file3
+_verify_parent "$testfolder2" "$file3" "$testfolder2/$file3"
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
+mv -f $SCRATCH_MNT/$testfolder2/$file3 $SCRATCH_MNT/$testfolder1/$file2
+_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/851.out b/tests/xfs/851.out
new file mode 100644
index 0000000000..c375ba5f00
--- /dev/null
+++ b/tests/xfs/851.out
@@ -0,0 +1,59 @@
+QA output created by 851
+
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1
+
+*** testfolder2 OK
+*** testfolder2/file1 OK
+*** testfolder2/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder2/file1
+
+*** testfolder1 OK
+*** testfolder1/file1_link OK
+*** testfolder1/file1_link OK
+*** Verified parent pointer: name:file1_link, namelen:10
+*** Parent pointer OK for child testfolder1/file1_link
+*** testfolder1 OK
+*** testfolder2/file1 OK
+*** testfolder1/file1_link OK
+*** Verified parent pointer: name:file1_link, namelen:10
+*** Parent pointer OK for child testfolder2/file1
+*** testfolder2 OK
+*** testfolder1/file1_link OK
+*** testfolder2/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link
+*** testfolder2 OK
+*** testfolder2/file1 OK
+*** testfolder2/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder2/file1
+
+*** testfolder1 OK
+*** testfolder1/file1_link OK
+*** testfolder1/file1_link OK
+*** Verified parent pointer: name:file1_link, namelen:10
+*** Parent pointer OK for child testfolder1/file1_link
+*** testfolder1/file1_link OK
+
+*** testfolder1 OK
+*** testfolder1/file2 OK
+*** testfolder1/file2 OK
+*** Verified parent pointer: name:file2, namelen:5
+*** Parent pointer OK for child testfolder1/file2
+*** testfolder1/file2 OK
+
+*** testfolder2 OK
+*** testfolder2/file3 OK
+*** testfolder2/file3 OK
+*** Verified parent pointer: name:file3, namelen:5
+*** Parent pointer OK for child testfolder2/file3
+*** testfolder1 OK
+*** testfolder1/file2 OK
+*** testfolder1/file2 OK
+*** Verified parent pointer: name:file2, namelen:5
+*** Parent pointer OK for child testfolder1/file2

