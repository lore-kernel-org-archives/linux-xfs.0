Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D917C77B6C
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbjDFToX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237926AbjDFToI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:44:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14D49039;
        Thu,  6 Apr 2023 12:44:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 054DC60FA2;
        Thu,  6 Apr 2023 19:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D976C433D2;
        Thu,  6 Apr 2023 19:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810243;
        bh=iZN6774Dlrv8F6kcFR9ZQYFkLH/bHgKJavMyFgQu4wM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rcFbKZywE80D0ub2yfrC0ouKDXJfRoZinA2dv5ApG5I8tqx1IrgHaCfcZWp7ZZ9QI
         OjChPUNyovE0YPNJuknsZklIuyFOrZSsfFXoLshI4IVLtU/dvdPp34ckeyDQAbc16Y
         H5gvXR+UyBaPi6XADsx3ojyM7IXFgKlldhWJ7ip8fE5eHuxsTQEUoxbdVhXT8QyYtE
         QViDA0vKGOJx1uV1ZXRYswq7nAMZqbWQwYYpb/O+SX7JUq1Y3T6TbAwizD4Tsd51y+
         tZLg342ulzkYeyhZi0gzS/qlAb9Zhmn3HKqAWd8Ff1jEmloVd8yf3SnVV8mty9yUDY
         4RRr2PSYtMlbQ==
Date:   Thu, 06 Apr 2023 12:44:02 -0700
Subject: [PATCH 09/11] xfs: add parent pointer test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <168080829125.618488.13205620609289586421.stgit@frogsfrogsfrogs>
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

Add a test to verify basic parent pointers operations (create, move, link,
unlink, rename, overwrite).

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: test the xfs_io parent -p argument too]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 doc/group-names.txt |    1 
 tests/xfs/851       |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/851.out   |   69 ++++++++++++++++++++++++++++++
 3 files changed, 186 insertions(+)
 create mode 100755 tests/xfs/851
 create mode 100644 tests/xfs/851.out


diff --git a/doc/group-names.txt b/doc/group-names.txt
index 88f9b8a0e7..81c7057bf0 100644
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
index 0000000000..8233c1563c
--- /dev/null
+++ b/tests/xfs/851
@@ -0,0 +1,116 @@
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
+. ./common/filter
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
+# Make sure that parent -p filtering works
+mkdir -p $SCRATCH_MNT/dira/ $SCRATCH_MNT/dirb/
+dira_inum=$(stat -c '%i' $SCRATCH_MNT/dira)
+dirb_inum=$(stat -c '%i' $SCRATCH_MNT/dirb)
+touch $SCRATCH_MNT/gorn
+ln $SCRATCH_MNT/gorn $SCRATCH_MNT/dira/file1
+ln $SCRATCH_MNT/gorn $SCRATCH_MNT/dirb/file1
+echo look for both
+$XFS_IO_PROG -c 'parent -p' $SCRATCH_MNT/gorn | _filter_scratch
+echo look for dira
+$XFS_IO_PROG -c 'parent -p -n dira' -c "parent -p -i $dira_inum" $SCRATCH_MNT/gorn | _filter_scratch
+echo look for dirb
+$XFS_IO_PROG -c 'parent -p -n dirb' -c "parent -p -i $dirb_inum" $SCRATCH_MNT/gorn | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/851.out b/tests/xfs/851.out
new file mode 100644
index 0000000000..f44d3e5d4f
--- /dev/null
+++ b/tests/xfs/851.out
@@ -0,0 +1,69 @@
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
+look for both
+SCRATCH_MNT/gorn
+SCRATCH_MNT/dira/file1
+SCRATCH_MNT/dirb/file1
+look for dira
+SCRATCH_MNT/dira/file1
+SCRATCH_MNT/dira/file1
+look for dirb
+SCRATCH_MNT/dirb/file1
+SCRATCH_MNT/dirb/file1

