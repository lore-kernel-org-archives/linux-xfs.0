Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7C23EDE7E;
	Tue,  6 Oct 2026 08:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277015; cv=none; b=GvKxfd3ExzJ7RfFPlZH6gWZz7k1HP1f02HCKWngybLTNmu386AQ90pRZ7lYT8nBswiSbjaedzaMhu04Tx2ezpRUsyXgG/+TAWRXp4igpNw2hYuu6iDY0ArCAk26Dyp9PxAYzWrRh+d2rmBxR05rRGE2kgtgUTgWNek/8ZNX+wVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277015; c=relaxed/simple;
	bh=91o7JeTm7yDozoM2tEYxr+FMfvh277hCoxc5+bn+dyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vohhz1Ls5i/KbTeavmefVS7nhSt7gYGB2ErqxSmdrmNY5AYdZ0IR1Ao68mc0FHZ2OSqTIe+MNtJI1zyQ6p9vCs2/RPLIE9CQseqwDB95f1lAroctFfL60JAOIExLZDzEnmkMY7sZlrHqGylqClpWMMzCRYRuKIcNETUGggp3Z+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sy+mIFxG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sy+mIFxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120771F000FF;
	Tue,  6 Oct 2026 08:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791277014;
	bh=s6TOi4hloUS6fWBXA3KoXCNe28odAO0qsI89LPeuYF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sy+mIFxGm13eA1H/WQ2KdX6NCOD8jVFbUHew2ENO3s8p89XZeGeh8Ca+nurQ8GchM
	 0fus/I1JZ+urMmdF4fBBQTIEU4Q6ixc3YMwgxpJj2ZpyMRLBZgjubtywiR3g0azEk0
	 1lNXN2qbzONmF/z0rnaH7snRD8uVwGWlYqz+N9F6rmScN07FxeicIQ4XnLO+3g1vLd
	 Ak0dxQemRO7mV7VWcfnmcDz4xz5QUwRe6qpqFXrp33nTc8VTgKH0WNaXI3FL0PydxR
	 +UvVKmUT1swVlpP/3IYPMyeHwnd6PomSVn7pqSNd7YuaUW8pnak1KPllf3YHAQWHiL
	 8jF+GIkSPKmVw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 20/21] fstests: generic/744: migrate to _create_cloned_loop_devs()
Date: Tue,  6 Oct 2026 16:55:46 +0800
Message-ID: <2d0903ee55156a1a384f95b6e54ce2bacf0c9a77.1791272793.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791272793.git.asj@kernel.org>
References: <cover.1791272793.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch generic/744 to use the common _create_cloned_loop_devs() helper
to format, modify, and clone the underlying loop devices, avoiding
open-coded clone setup and teardown logic.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 tests/generic/744 | 70 ++++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 43 deletions(-)

diff --git a/tests/generic/744 b/tests/generic/744
index 330d86ce826a..c522d6f46713 100755
--- a/tests/generic/744
+++ b/tests/generic/744
@@ -10,71 +10,55 @@
 . ./common/preamble
 _begin_fstest auto clone volume tempfsid
 
-_cleanup()
-{
-	cd /
-	rm -r -f $tmp.*
-
-	_unmount $mnt2 &> /dev/null
-	_unmount $mnt1 &> /dev/null
-	[ -b "$loop_dev2" ] && _destroy_loop_device $loop_dev2
-	[ -b "$loop_dev1" ] && _destroy_loop_device $loop_dev1
-	[ -n "$seq" ] && rm -rf $TEST_DIR/$seq
-}
-
 . ./common/filter
 . ./common/reflink
 
-_require_clone_mount
 _require_test
 _require_block_device $TEST_DEV
 _require_test_reflink
 _require_cp_reflink
 _require_loop
 
-clone_filesystem()
+_cleanup()
 {
-	local dev1=$1
-	local dev2=$2
-
-	_mkfs_dev $dev1
-
-	_mount $dev1 $mnt1
-	$XFS_IO_PROG -fc 'pwrite -S 0x61 0 9000' $mnt1/foo >> $seqres.full
-	_unmount $mnt1
+	cd /
+	rm -r -f $tmp.*
 
-	# device dump of $dev1 to $dev2
-	dd if=$dev1 of=$dev2 conv=fsync status=none || _fail "dd failed: $?"
+	_unmount $mnt2 &> /dev/null
+	_unmount $mnt1 &> /dev/null
+	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
 }
 
-[ -n "$seq" ] && rm -rf $TEST_DIR/$seq
-mkdir $TEST_DIR/$seq
+add_foo()
+{
+	local orig_dev="$1"
+	local temp_mnt="$TEST_DIR/$seq/temp_mnt"
+
+	mkdir -p $temp_mnt
+	_mount $(_common_dev_mount_options) $(_clone_mount_options) $orig_dev $temp_mnt
+	$XFS_IO_PROG -fc 'pwrite -S 0x61 0 9000' $temp_mnt/foo >> $seqres.full
+	$XFS_IO_PROG -c 'fsync' $temp_mnt/foo
+	_unmount $temp_mnt
+}
 
+rm -rf $TEST_DIR/$seq 2>/dev/null
+mkdir -p $TEST_DIR/$seq
+# Setup base loop device and its clone
+devs=()
+_create_cloned_loop_devs devs add_foo
 mnt1=$TEST_DIR/$seq/mnt1
 mnt2=$TEST_DIR/$seq/mnt2
-mkdir -p $mnt1 $mnt2
-
-loop_file1="$TEST_DIR/$seq/image1"
-truncate -s 300m "$loop_file1"
-loop_dev1=$(_create_loop_device "$loop_file1")
-
-loop_file2="$TEST_DIR/$seq/image2"
-truncate -s 300m "$loop_file2"
-loop_dev2=$(_create_loop_device "$loop_file2")
-
-clone_filesystem ${loop_dev1} ${loop_dev2}
+mkdir -p $mnt1
+mkdir -p $mnt2
 
 # Mounting original device
-_mount $(_common_dev_mount_options) $(_clone_mount_options) $loop_dev1 $mnt1
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1
 $XFS_IO_PROG -fc 'pwrite -S 0x61 0 9000' $mnt1/foo | _filter_xfs_io
-
 # Mounting cloned device
-_mount $(_common_dev_mount_options) $(_clone_mount_options) $loop_dev2 $mnt2 \
+_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 \
 					|| _fail "mount of cloned device failed"
 
 # cp reflink across two different filesystems must fail
 _cp_reflink $mnt1/foo $mnt2/bar 2>&1 | _filter_test_dir
 
-# success, all done
-status=0
-exit
+_exit 0
-- 
2.43.0

