Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867506A005;
	Thu, 25 Jan 2024 19:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706209564; cv=none; b=t6Rpq5klaAEWxpfA/XW2pNBoiqX1Hd3hmiwZL623fQuEGci8C08G+j17D8702zfx0iKqYV8omkLYpHp7f3JnPqopW8hRRXWRQEEc6L1YrHH2qGJ3k3sDFPZ0IX5ZhcU8zBAzE7xxVh/frD6SOn6qGhLGQlaFTws2DbXCG24CQMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706209564; c=relaxed/simple;
	bh=1Zri91UrAXgUr22zpBTj1DjMFMXJP3oYQ3aTzoErS3E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FMWPtwF0FY3Y/boEkcF6w3Y6Lk11i580GbrAktIaluYa00fF4sNtE0jPzC5/3qWJM5go/ibLqz9VJwlh0j+ii8jdEvlIJ/NApvhL/fM+OrPOxd5NfaIFbDaYQtSc9HiXCJnjWt5lCL5mHaz2ffRmHQ3/k7DLqcfOv7xm/HuroBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1kKQM+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1kKQM+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF4FC433C7;
	Thu, 25 Jan 2024 19:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706209564;
	bh=1Zri91UrAXgUr22zpBTj1DjMFMXJP3oYQ3aTzoErS3E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Y1kKQM+i9IcQ6BaN64cib2MbAxA//1D6uVD2c7TDUbxRUxaReAtoOVu+9frHbtuMW
	 GntJ+gQcuyTjd4rktr5r6rVaAELfl+KzBLlh5+FDvPUHQnCEmgrwKa81BQf9xsrtb8
	 nRqB6ewIOMOPQODzZsjf5oceQFK0hU2FXbO4rVfWPcgtaeH2o/QEo0OrlxWlyZe6I3
	 0PP/cXSioDnTQwWDbUiawluw9wgeDolcoeVjWynAceBywl/UGdPiYQ/dJdxdW2J+9n
	 JLbURqknYhXmwVIdR+kRuUYoWkWWiYlE4753Ri6aB7cQF/k5q07dJV0v7By2q6mSn6
	 WQHD1rrzcIx5w==
Date: Thu, 25 Jan 2024 11:06:03 -0800
Subject: [PATCH 08/10] xfs/503: split copy and metadump into two tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170620924478.3283496.11965906815443674241.stgit@frogsfrogsfrogs>
In-Reply-To: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This test examines the behavior of xfs_copy and xfs_metadump.  Metadump
now supports capturing external log contents, but copy does not.  Split
the test into two to improve coverage on multidevice filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1876     |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1876.out |    4 ++++
 tests/xfs/503      |   17 +++-------------
 tests/xfs/503.out  |    2 --
 4 files changed, 61 insertions(+), 16 deletions(-)
 create mode 100755 tests/xfs/1876
 create mode 100755 tests/xfs/1876.out


diff --git a/tests/xfs/1876 b/tests/xfs/1876
new file mode 100755
index 0000000000..feeb82fca0
--- /dev/null
+++ b/tests/xfs/1876
@@ -0,0 +1,54 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1876
+#
+# Populate a XFS filesystem and ensure that xfs_copy works properly.
+#
+. ./common/preamble
+_begin_fstest auto copy
+
+_register_cleanup "_cleanup" BUS
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.* $testdir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+
+testdir=$TEST_DIR/test-$seq
+
+# real QA test starts here
+_supported_fs xfs
+
+_require_xfs_copy
+_require_scratch_nocheck
+_require_populate_commands
+_xfs_skip_online_rebuild
+_xfs_skip_offline_rebuild
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+mkdir -p $testdir
+copy_file=$testdir/copy.img
+
+echo copy
+$XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full
+_check_scratch_fs $copy_file
+
+echo recopy
+$XFS_COPY_PROG $copy_file $SCRATCH_DEV >> $seqres.full
+_scratch_mount
+_check_scratch_fs
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1876.out b/tests/xfs/1876.out
new file mode 100755
index 0000000000..0bf8e156c0
--- /dev/null
+++ b/tests/xfs/1876.out
@@ -0,0 +1,4 @@
+QA output created by 1876
+Format and populate
+copy
+recopy
diff --git a/tests/xfs/503 b/tests/xfs/503
index 79bbbdd26d..606fcbdcc4 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -4,11 +4,11 @@
 #
 # FS QA Test No. 503
 #
-# Populate a XFS filesystem and ensure that metadump, mdrestore, and copy
-# all work properly.
+# Populate a XFS filesystem and ensure that metadump and mdrestore all work
+# properly.
 #
 . ./common/preamble
-_begin_fstest auto copy metadump
+_begin_fstest auto metadump
 
 _register_cleanup "_cleanup" BUS
 
@@ -32,7 +32,6 @@ _supported_fs xfs
 
 _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_loop
-_require_xfs_copy
 _require_scratch_nocheck
 _require_populate_commands
 _xfs_skip_online_rebuild
@@ -58,16 +57,6 @@ _verify_metadumps '-o'
 echo "metadump ao and mdrestore"
 _verify_metadumps '-a -o'
 
-echo copy
-$XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full
-_check_scratch_fs $copy_file
-
-echo recopy
-$XFS_COPY_PROG $copy_file $SCRATCH_DEV >> $seqres.full
-_scratch_mount
-_check_scratch_fs
-_scratch_unmount
-
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/503.out b/tests/xfs/503.out
index 5e7488456d..7f3d3a5f24 100644
--- a/tests/xfs/503.out
+++ b/tests/xfs/503.out
@@ -4,5 +4,3 @@ metadump and mdrestore
 metadump a and mdrestore
 metadump o and mdrestore
 metadump ao and mdrestore
-copy
-recopy

