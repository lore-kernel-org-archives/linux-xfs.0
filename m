Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E762045B8;
	Tue,  4 Feb 2025 21:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704421; cv=none; b=b2BJWXeOBHsr16QNp69Dyfi18rpIoCYsKq/qZdo2UfVpyIX4/Nqu8GKxu5Ax1vfgq68W6SHRt4c7C44WFBCdGTLc+Ef/1qF2+S8i69mW0D4gQGlEOKlNhU/B+9fsj0Zr8EZFHFauGZJ9OIv4u+MRachhwKz5D2hBDe+Oq+niYkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704421; c=relaxed/simple;
	bh=VBirxcHVCyNZRmw+c3fqJ5ZHlBn8G4WzpdAFSDi3umY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LO6Dz1qHpg8eWES6NlYwHUaYQkdjfhoq/pwRNOhn7Jx56gTxlS3I7PRA5l8+7TkdeZPMIjTYy76CdbM74bRoQI5Bc4TKz+MIAAq8+Ps11x+yw35oRbAw8hFmBRWBkybVALlHmUdWeS+WahTtgeQNj8l/VRiKGPgBJcb0NwAYT7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMhKe68M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMhKe68M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7419C4CEDF;
	Tue,  4 Feb 2025 21:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704420;
	bh=VBirxcHVCyNZRmw+c3fqJ5ZHlBn8G4WzpdAFSDi3umY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YMhKe68MzQcbavKSuzvcA0Be4PMtHUctBFI20345jBrXiK0YDjeUMajhNh0uuM5zC
	 bSP444OSb5lb/4IQPhzoXhAsnTuHLBcOQY7a+p54dEwukkiMRqafQlBJw6CU8Cu0mo
	 g+JS5WL06wUmeHCwcD1VHR/jV8FI6cgKRjVqZ2QhlxvfeTsgY/NcWDEC3FNRJFzJwM
	 lCI+aJA67zhyTi+8w2RgacQ8GiikV/o18FeVlkjINEF+UsX3d2r+1a3IjMxFsUB63K
	 hoJ7jA8ilVrGuXist+wz2q19+V0wx5XlbWzwz3SNB3ratMm1n1a7lkmpfjVA1UylzI
	 4cM3P9bwH9BNg==
Date: Tue, 04 Feb 2025 13:27:00 -0800
Subject: [PATCH 18/34] unmount: resume logging of stdout and stderr for
 filtering
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406381.546134.15032706609095709426.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

There's a number of places where a test program calls a variant of
_unmount but then pipes the output through a _filter script or
something.  The new _unmount helper redirects stdout and stderr to
seqres.full, which means that those error messages (some of which are
encoded in the golden outputs) are suppressed.  This leads to test
regressions in generic/050 and other places, so let's resume logging.

This also undoes all the changes that removed /dev/null redirection of
unmount calls.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 4c6bc4565105e6 ("fstests: clean up mount and unmount operations")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 check             |   10 ++++++++--
 common/quota      |    2 +-
 common/rc         |   21 +++++++++++++++++++--
 tests/generic/050 |    2 +-
 tests/generic/085 |    2 +-
 tests/generic/361 |    4 ++--
 tests/generic/590 |    2 +-
 tests/generic/746 |    2 +-
 tests/xfs/149     |    2 +-
 tests/xfs/530     |    2 +-
 10 files changed, 36 insertions(+), 13 deletions(-)


diff --git a/check b/check
index 5beb10612b75fb..bc04a50810b9df 100755
--- a/check
+++ b/check
@@ -1048,8 +1048,8 @@ function run_section()
 
 		if [ $sts -ne 0 ]; then
 			_dump_err_cont "[failed, exit status $sts]"
-			_test_unmount 2>> $seqres.full
-			_scratch_unmount 2>> $seqres.full
+			_test_unmount 2> /dev/null
+			_scratch_unmount 2> /dev/null
 			rm -f ${RESULT_DIR}/require_test*
 			rm -f ${RESULT_DIR}/require_scratch*
 			# Even though we failed, there may be something interesting in
@@ -1135,6 +1135,12 @@ function run_section()
 		_stash_test_status "$seqnum" "$tc_status"
 	done
 
+	# Reset these three variables so that unmount output doesn't get
+	# written to $seqres.full of the last test to run.
+	seq="check.$$"
+	check="$RESULT_BASE/check"
+	seqres="$check"
+
 	sect_stop=`_wallclock`
 	interrupt=false
 	_wrapup
diff --git a/common/quota b/common/quota
index 8688116c6547a9..4dad9b79a27a7f 100644
--- a/common/quota
+++ b/common/quota
@@ -274,7 +274,7 @@ _choose_prid()
 
 _qmount()
 {
-    _scratch_unmount
+    _scratch_unmount >/dev/null 2>&1
     _try_scratch_mount || _fail "qmount failed"
     # xfs doesn't need these setups and quotacheck even fails on xfs
     # redirect the output to $seqres.full for debug purpose and ignore results
diff --git a/common/rc b/common/rc
index 6a1d4fd712bb40..b78d903fe34ba3 100644
--- a/common/rc
+++ b/common/rc
@@ -479,11 +479,28 @@ _scratch_mount_idmapped()
 }
 
 # Unmount the filesystem based on the directory or device passed.
+# Log everything that happens to seqres.full, and use BASHPID because
+# background subshells have the same $$ as the parent but not the same
+# $BASHPID.
 _unmount()
 {
-	local args="$*"
+	local outlog="$tmp.$BASHPID.umount"
+	local errlog="$tmp.$BASHPID.umount.err"
 
-	$UMOUNT_PROG $args >> $seqres.full 2>&1
+	rm -f "$outlog" "$errlog"
+	$UMOUNT_PROG "$@" 2> "$errlog" > "$outlog"
+	local res="${PIPESTATUS[0]}"
+
+	if [ -s "$outlog" ]; then
+		cat "$outlog" >> $seqres.full
+		cat "$outlog"
+	fi
+	if [ -s "$errlog" ]; then
+		cat "$errlog" >> $seqres.full
+		>&2 cat "$errlog"
+	fi
+	rm -f "$outlog" "$errlog"
+	return $res
 }
 
 _scratch_unmount()
diff --git a/tests/generic/050 b/tests/generic/050
index 8e9456db279003..affb072df5969f 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -89,7 +89,7 @@ _try_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
 
 # expects an error, so open code the unmount
 echo "unmounting read-only filesystem"
-$UMOUNT_PROG $SCRATCH_DEV 2>&1 | _filter_scratch | _filter_ending_dot
+_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
 
 #
 # This is the way out if the underlying device really is read-only.
diff --git a/tests/generic/085 b/tests/generic/085
index 7671a36ab9524f..d3fa10be9ccace 100755
--- a/tests/generic/085
+++ b/tests/generic/085
@@ -29,7 +29,7 @@ cleanup_dmdev()
 	fi
 	# in case it's still suspended and/or mounted
 	$DMSETUP_PROG resume $lvdev >> $seqres.full 2>&1
-	_unmount -q $SCRATCH_MNT
+	_unmount -q $SCRATCH_MNT >/dev/null 2>&1
 	_dmsetup_remove $node
 }
 
diff --git a/tests/generic/361 b/tests/generic/361
index e2b7984361e87c..b584af47540020 100755
--- a/tests/generic/361
+++ b/tests/generic/361
@@ -16,7 +16,7 @@ _begin_fstest auto quick
 # Override the default cleanup function.
 _cleanup()
 {
-	_unmount $fs_mnt
+	_unmount $fs_mnt &>> /dev/null
 	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
 	cd /
 	rm -f $tmp.*
@@ -54,7 +54,7 @@ $XFS_IO_PROG -fc "pwrite 0 520m" $fs_mnt/testfile >>$seqres.full 2>&1
 # remount should not hang
 $MOUNT_PROG -o remount,ro $fs_mnt >>$seqres.full 2>&1
 
-_unmount $fs_mnt
+_unmount $fs_mnt &>/dev/null
 _destroy_loop_device $loop_dev
 unset loop_dev
 
diff --git a/tests/generic/590 b/tests/generic/590
index 1adeef4c2ad52c..ba1337a856f15d 100755
--- a/tests/generic/590
+++ b/tests/generic/590
@@ -15,7 +15,7 @@ _begin_fstest auto prealloc preallocrw
 # Override the default cleanup function.
 _cleanup()
 {
-	_scratch_unmount
+	_scratch_unmount &>/dev/null
 	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
 	cd /
 	rm -f $tmp.*
diff --git a/tests/generic/746 b/tests/generic/746
index ba8ed25e845776..6f02b1cc354782 100755
--- a/tests/generic/746
+++ b/tests/generic/746
@@ -223,7 +223,7 @@ while read line; do
 done < $fiemap_after
 echo "done."
 
-_unmount $loop_mnt
+_unmount $loop_mnt &>/dev/null
 _destroy_loop_device $loop_dev
 unset loop_dev
 
diff --git a/tests/xfs/149 b/tests/xfs/149
index 9a96f82ede1761..28dfc7f04c1773 100755
--- a/tests/xfs/149
+++ b/tests/xfs/149
@@ -22,7 +22,7 @@ loop_symlink=$TEST_DIR/loop_symlink.$$
 # Override the default cleanup function.
 _cleanup()
 {
-    _unmount $mntdir
+    _unmount $mntdir &>/dev/null
     [ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
     rmdir $mntdir
     rm -f $loop_symlink
diff --git a/tests/xfs/530 b/tests/xfs/530
index d0d0e2665070f8..95ab32f1e1f828 100755
--- a/tests/xfs/530
+++ b/tests/xfs/530
@@ -116,7 +116,7 @@ done
 echo "Check filesystem"
 _check_scratch_fs
 
-_scratch_unmount
+_scratch_unmount &> /dev/null
 _destroy_loop_device $rt_loop_dev
 unset rt_loop_dev
 

