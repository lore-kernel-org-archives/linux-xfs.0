Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C846C7ED;
	Mon,  1 Jan 2024 00:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZM1q0Rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0ACC433C7;
	Mon,  1 Jan 2024 00:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070116;
	bh=oDYRjPULvAUVBH18acev/5lsyqXVzNrXp6N7V+QR0Xs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jZM1q0RzIUvNC6FKKgwysCt9Jyat6dRagA7GFmdd2TUGA+TLlByAg6T70+j7Y0H6X
	 aN8JbkTkb2f+ocIWeOU3Ku1sucekcyTGORXfW/IKeACyBhgwkXdoeA9oe0/KjZ0l9K
	 y0Y6cwjA6XHJcB6TlY2JSGVUfm/QA/fJJX6UbHxIiXspSQNZqwlRbtmfADGL0UHPhB
	 L0lza002tQBoAGJgiTI9Nsp82zXCMAdSWPKP4pUG8UOy1VfWRFLXLs5TecgSE4Jh4v
	 2s2zC2HvgKj8M+RianKi2XJsJXrYJop+33aQJREpr0U7/l+14yjZbUz4VU/Tart2c1
	 G5zuqFMPEZXcA==
Date: Sun, 31 Dec 2023 16:48:35 +9900
Subject: [PATCH 09/11] xfs: add parent pointer test
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, fstests@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com, guan@eryu.me,
 linux-xfs@vger.kernel.org
Message-ID: <170405028546.1824869.14814463737616268265.stgit@frogsfrogsfrogs>
In-Reply-To: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
References: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
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
---
 doc/group-names.txt |    1 
 tests/xfs/1851      |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1851.out  |   69 ++++++++++++++++++++++++++++++
 3 files changed, 186 insertions(+)
 create mode 100755 tests/xfs/1851
 create mode 100644 tests/xfs/1851.out


diff --git a/doc/group-names.txt b/doc/group-names.txt
index fec6bf71ab..4676825faf 100644
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
index 0000000000..6cfc7cce79
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

