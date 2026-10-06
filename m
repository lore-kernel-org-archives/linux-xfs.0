Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F953F1ACE;
	Tue,  6 Oct 2026 08:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277013; cv=none; b=SP5hAjP8ubvCYiYa4RW79h34a18x24yXXrCQO1FzY9Nh3G8hWltRejsNhdIpH1giSqUjrQ5aRTHn4Vw2NNwQuXGFwjgMrIH+n4niYFKHrCKRSKZiU2LrKqa2LwM2prALAu/+Q5T873OMbHO7Gw5ZflpOse01dt5Xylw8rap5sWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277013; c=relaxed/simple;
	bh=83EP7g9lvQOBnrSwrjXZcxitHpSbfsmdFGopTVoF/jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EW4WGqqnHJscGVYQpBF3/o70/qyoOzaK+B8mvGh8m3I5Wa9p7Ug4p45Q8xkcK22Ak8pplDB4O52r5/9Ug0vblpKMq+t7uOEr8qV0flw0lFaV8svRyslJe3U211aRlD35z/YO7h+vvAjzkj1g5cUtNsqqdwaBrSuH8+bnQXKaCk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1PFB9DZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1PFB9DZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9CD1F00893;
	Tue,  6 Oct 2026 08:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791277012;
	bh=KMVJ5/rbPwetobXP5bW8aSzZHunC22MDIMSqptUPW6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1PFB9DZHqDZ4jjZxwsqM3Y7RqUwwYmFuXEH6G1+gkmUvpgTgN450HotgQbz47R9r
	 eZXwhFoLiZQV4mwCbtI2nI7pnJ+hjvG18iKnxr3xg10ONA23GrQXFR+R+CdsHO1cT2
	 l3sV2sqTrbK9L5wJ2rNkiS3iZXLkkeTwxhkcqhXuYMIx4YgUtWpRSIv+QHoeQvJAuR
	 GRNVBdkT6zD6zByBn3zE+kjUOoNc2QAz2w1exnGXSdhUWRSPPNMIsNkrBtL4djJARu
	 frDQv9FF0Av41Cj2teNd0TRIVf2Pgkp+XFiOfX+qMVW5UtWvy2yEnqgdvpFvh1PNiB
	 zG5lPTm4v41dw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: zlang@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 19/21] fstests: generic/744: use new helper _require_clone_mount()
Date: Tue,  6 Oct 2026 16:55:45 +0800
Message-ID: <7c2209a7384968d252763bfd35289f776ebdd1af.1791272793.git.asj@kernel.org>
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

Replace _require_duplicate_fsid() with the newly introduced
_require_clone_mount() helper to verify kernel support for mounting
cloned block devices with duplicate UUIDs.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc         | 14 --------------
 tests/generic/744 |  8 ++++----
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/common/rc b/common/rc
index 7feeec04a500..58e4c234b0f4 100644
--- a/common/rc
+++ b/common/rc
@@ -6235,20 +6235,6 @@ _random_file() {
 	echo "$basedir/$(ls -U $basedir | shuf -n 1)"
 }
 
-_require_duplicate_fsid()
-{
-	case "$FSTYP" in
-	"btrfs")
-		_require_btrfs_fs_feature temp_fsid
-		;;
-	"ext4")
-		;;
-	*)
-		_notrun "$FSTYP does not support duplicate fsid"
-		;;
-	esac
-}
-
 # Can we find a program in the $PATH?
 _have_program() {
 	command -v "$1" &>/dev/null
diff --git a/tests/generic/744 b/tests/generic/744
index cda10e0f66ba..330d86ce826a 100755
--- a/tests/generic/744
+++ b/tests/generic/744
@@ -25,8 +25,7 @@ _cleanup()
 . ./common/filter
 . ./common/reflink
 
-# Modify as appropriate.
-_require_duplicate_fsid
+_require_clone_mount
 _require_test
 _require_block_device $TEST_DEV
 _require_test_reflink
@@ -66,11 +65,12 @@ loop_dev2=$(_create_loop_device "$loop_file2")
 clone_filesystem ${loop_dev1} ${loop_dev2}
 
 # Mounting original device
-_mount $loop_dev1 $mnt1
+_mount $(_common_dev_mount_options) $(_clone_mount_options) $loop_dev1 $mnt1
 $XFS_IO_PROG -fc 'pwrite -S 0x61 0 9000' $mnt1/foo | _filter_xfs_io
 
 # Mounting cloned device
-_mount $loop_dev2 $mnt2 || _fail "mount of cloned device failed"
+_mount $(_common_dev_mount_options) $(_clone_mount_options) $loop_dev2 $mnt2 \
+					|| _fail "mount of cloned device failed"
 
 # cp reflink across two different filesystems must fail
 _cp_reflink $mnt1/foo $mnt2/bar 2>&1 | _filter_test_dir
-- 
2.43.0

