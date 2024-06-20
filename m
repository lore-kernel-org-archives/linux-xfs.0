Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF11757E3;
	Thu, 20 Jun 2024 20:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917157; cv=none; b=pZgElcrsEzBKswyFuXToe4B41uyGdwzOC3XY3I8Fs0XLXBDCBjJyj7RPuowhEhPCekxJmrfQESgo873V4iukcSZJcxIxTlFjIY9NndpTR0JmeWRxC9hqkBZwCihNd3qSGim9/2D/PWYUFOrQ1Mps8KVwaM3Mjw228ESLO9GZrlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917157; c=relaxed/simple;
	bh=yvKDvIopj58Q5hC05A9T5j5TNZDhWJ6AqKVwdsv4Hf0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OwJHctbjlMt5Je0Hr5Evi8jva9MYP6b9DXvgaYyFiw6/p+jsscYzb1/wVFypJ/AXuL6cmn8miEy0F7sj1QMzjeHcqU/sOIRCaxgYm36Kp+NyIYTEGcDEPylxzwGe2AspSVhZlSEciNxD8+dY4EQe/FeGqyzrPRw8UZwcUrXShUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNCxYfvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNCxYfvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334ACC2BD10;
	Thu, 20 Jun 2024 20:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917157;
	bh=yvKDvIopj58Q5hC05A9T5j5TNZDhWJ6AqKVwdsv4Hf0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KNCxYfvU14bB03C4LiZIBSfrMNRc4i2aid6yeUAhYNZbs0wMMDynOezYbux9xmG+K
	 v680Tblsp/xCfF2XJEhhBdNK4q/t2saelE8drYKRvAtAYPWgVGj0/ugsRDOupVHjtN
	 P1acYgw/Xv8LKowFWOEbELGjNKNxHF6UoEP9/FkeIYlMzKDcExqqcNMBze4jAqZ0GS
	 QA8a+QotUFpuJyzZt0LxSf6hNMgjEL7Wiqw3fu9W4twme5VkF9DETjnMOPpBGyro6V
	 1yr/V64N93f7eiRtp5odwxJ/OYtOyAdfhjt9Cf3+ekGcwujNezFuBnzLIA1DkroUAt
	 BziSc3QxHLK/Q==
Date: Thu, 20 Jun 2024 13:59:16 -0700
Subject: [PATCH 09/11] xfs: add parent pointer test
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, Christoph Hellwig <hch@lst.de>,
 fstests@vger.kernel.org, allison.henderson@oracle.com,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <171891669776.3035255.4714645877031003126.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
References: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Add a test to verify basic parent pointers operations (create, move, link,
unlink, rename, overwrite).

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: test the xfs_io parent -p argument too]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 doc/group-names.txt |    1 
 tests/xfs/1851      |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1851.out  |   69 ++++++++++++++++++++++++++++++
 3 files changed, 186 insertions(+)
 create mode 100755 tests/xfs/1851
 create mode 100644 tests/xfs/1851.out


diff --git a/doc/group-names.txt b/doc/group-names.txt
index 2c4c312700..6cf717969d 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -83,6 +83,7 @@ nfs4_acl		NFSv4 access control lists
 nonsamefs		overlayfs layers on different filesystems
 online_repair		online repair functionality tests
 other			dumping ground, do not add more tests to this group
+parent			Parent pointer tests
 pattern			specific IO pattern tests
 perms			access control and permission checking
 pipe			pipe functionality
diff --git a/tests/xfs/1851 b/tests/xfs/1851
new file mode 100755
index 0000000000..99c1a28a8c
--- /dev/null
+++ b/tests/xfs/1851
@@ -0,0 +1,116 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2024 Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 1851
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
+_xfs_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1"
+
+echo ""
+# Move parent pointer test
+mv $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder2/$file1
+_xfs_verify_parent "$testfolder2" "$file1" "$testfolder2/$file1"
+
+echo ""
+# Hard link parent pointer test
+ln $SCRATCH_MNT/$testfolder2/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln
+_xfs_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
+_xfs_verify_parent "$testfolder1" "$file1_ln" "$testfolder2/$file1"
+_xfs_verify_parent "$testfolder2" "$file1"    "$testfolder1/$file1_ln"
+_xfs_verify_parent "$testfolder2" "$file1"    "$testfolder2/$file1"
+
+echo ""
+# Remove hard link parent pointer test
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file1)"
+rm $SCRATCH_MNT/$testfolder2/$file1
+_xfs_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
+_xfs_verify_no_parent "$file1" "$ino" "$testfolder1/$file1_ln"
+
+echo ""
+# Rename parent pointer test
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln)"
+mv $SCRATCH_MNT/$testfolder1/$file1_ln $SCRATCH_MNT/$testfolder1/$file2
+_xfs_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
+_xfs_verify_no_parent "$file1_ln" "$ino" "$testfolder1/$file2"
+
+echo ""
+# Over write parent pointer test
+touch $SCRATCH_MNT/$testfolder2/$file3
+_xfs_verify_parent "$testfolder2" "$file3" "$testfolder2/$file3"
+ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
+mv -f $SCRATCH_MNT/$testfolder2/$file3 $SCRATCH_MNT/$testfolder1/$file2
+_xfs_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
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
diff --git a/tests/xfs/1851.out b/tests/xfs/1851.out
new file mode 100644
index 0000000000..99a9d42892
--- /dev/null
+++ b/tests/xfs/1851.out
@@ -0,0 +1,69 @@
+QA output created by 1851
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

