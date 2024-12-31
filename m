Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D05A29415;
	Tue, 31 Dec 2024 23:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689442; cv=none; b=gnAyadmx3xvuOB+dOb9C9qcWfi0++DqcPO5lDz/vZH5MX6F9s7fuwskira/KSDU1tOfRT+zs2VJ/LciF2cId4xFX0gCc004swkaMpducA/6nICCwJU6lJ85kg5PABDpi3FAET4qjYhJPN8niEMljhcFx7Zs1TGKLAkCqOL0hCRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689442; c=relaxed/simple;
	bh=Wh1bMrJw13Du5l8QrWc9RVf/5ly2T0iJStv8WGr6ILA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PgiM/EK0dy07GFd+0osvRdmFSLgCgiLL/q0vHko2xTQjSZbjhF2cDudmHNe9CYvnWqUrnfJlp7HCkwpnJP7HlAFBO8+GS2WYC5VWf3FnBWOg5JbnvQiy1rfT1ubYN0h1Iy5IkOJAfP8G+bQyOXjSk8InaarwjcAbK41T3PiPYao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sM0MHnY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sM0MHnY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50E2C4CED2;
	Tue, 31 Dec 2024 23:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689442;
	bh=Wh1bMrJw13Du5l8QrWc9RVf/5ly2T0iJStv8WGr6ILA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sM0MHnY/wRkN1PA10e9aDricJhGCOS7NaSK6F6w3qRXLB0sVqNU2Zv0d1/XUROFrQ
	 wuaqmB6CNoADe05kdi3kNzrVXy/gk7UrB91/TBsdMeQ5xkoG80L1fR1GWM0BhUZymT
	 619E+5wyaKDU+pF/vo/zZaR8g+pFhBYBcnWNQYiOyAsiQlx6yrl/e4l0MpUjDS8FiW
	 +T03KQM8n/y2UNQchPIsv75s791aiv6HqWL5+tfkkWF8AvCSMR0nImgZMa7LAvqrvj
	 KLmrlwS12R1iMNJosPrSXlVDOwPWuYWZhuZTq8c3f+RawRmPO7t68ulKKYoeMpJ//8
	 TRVJD8fcXiFYg==
Date: Tue, 31 Dec 2024 15:57:21 -0800
Subject: [PATCH 2/6] misc: convert all umount(1) invocations to _umount
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568783162.2712254.8115752233414587395.stgit@frogsfrogsfrogs>
In-Reply-To: <173568783121.2712254.10238353363026075180.stgit@frogsfrogsfrogs>
References: <173568783121.2712254.10238353363026075180.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Find all the places where we call umount(1) directly and convert all of
those to _umount calls as well.

sed \
 -e 's/\([[:space:]]\)umount\([[:space:]]*"\$\)/\1_umount\2/g' \
 -e 's/\([[:space:]]\)umount\([[:space:]]*\$\)/\1_umount\2/g' \
 -e 's/^umount\([[:space:]]*"\$\)/_umount\1/g' \
 -e 's/^umount\([[:space:]]*\$\)/_umount\1/g' \
 -i $(git ls-files tests common check)

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/dmerror    |    2 +-
 common/populate   |    8 ++++----
 common/quota      |    2 +-
 common/rc         |    4 ++--
 common/xfs        |    2 +-
 tests/btrfs/012   |    2 +-
 tests/btrfs/199   |    2 +-
 tests/btrfs/291   |    2 +-
 tests/btrfs/298   |    4 ++--
 tests/ext4/006    |    4 ++--
 tests/ext4/007    |    4 ++--
 tests/ext4/008    |    4 ++--
 tests/ext4/009    |    8 ++++----
 tests/ext4/010    |    6 +++---
 tests/ext4/011    |    2 +-
 tests/ext4/012    |    2 +-
 tests/ext4/013    |    6 +++---
 tests/ext4/014    |    6 +++---
 tests/ext4/015    |    6 +++---
 tests/ext4/016    |    6 +++---
 tests/ext4/017    |    6 +++---
 tests/ext4/018    |    6 +++---
 tests/ext4/019    |    6 +++---
 tests/ext4/033    |    2 +-
 tests/generic/171 |    2 +-
 tests/generic/172 |    2 +-
 tests/generic/173 |    2 +-
 tests/generic/174 |    2 +-
 tests/generic/306 |    2 +-
 tests/generic/330 |    2 +-
 tests/generic/332 |    2 +-
 tests/generic/395 |    2 +-
 tests/generic/563 |    4 ++--
 tests/generic/631 |    2 +-
 tests/generic/717 |    2 +-
 tests/xfs/014     |    4 ++--
 tests/xfs/049     |    8 ++++----
 tests/xfs/073     |    8 ++++----
 tests/xfs/074     |    4 ++--
 tests/xfs/083     |    6 +++---
 tests/xfs/085     |    4 ++--
 tests/xfs/086     |    8 ++++----
 tests/xfs/087     |    6 +++---
 tests/xfs/088     |    8 ++++----
 tests/xfs/089     |    8 ++++----
 tests/xfs/091     |    8 ++++----
 tests/xfs/093     |    6 +++---
 tests/xfs/097     |    6 +++---
 tests/xfs/098     |    4 ++--
 tests/xfs/099     |    6 +++---
 tests/xfs/100     |    6 +++---
 tests/xfs/101     |    6 +++---
 tests/xfs/102     |    6 +++---
 tests/xfs/105     |    6 +++---
 tests/xfs/112     |    8 ++++----
 tests/xfs/113     |    6 +++---
 tests/xfs/117     |    6 +++---
 tests/xfs/120     |    6 +++---
 tests/xfs/123     |    6 +++---
 tests/xfs/124     |    6 +++---
 tests/xfs/125     |    6 +++---
 tests/xfs/126     |    6 +++---
 tests/xfs/130     |    2 +-
 tests/xfs/152     |    2 +-
 tests/xfs/169     |    6 +++---
 tests/xfs/206     |    2 +-
 tests/xfs/216     |    2 +-
 tests/xfs/217     |    2 +-
 tests/xfs/235     |    6 +++---
 tests/xfs/236     |    6 +++---
 tests/xfs/239     |    2 +-
 tests/xfs/241     |    2 +-
 tests/xfs/250     |    4 ++--
 tests/xfs/265     |    6 +++---
 tests/xfs/310     |    4 ++--
 tests/xfs/716     |    4 ++--
 76 files changed, 172 insertions(+), 172 deletions(-)


diff --git a/common/dmerror b/common/dmerror
index 1e6a35230f3ccb..2b6f001b8427f6 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -97,7 +97,7 @@ _dmerror_mount()
 
 _dmerror_unmount()
 {
-	umount $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 }
 
 _dmerror_cleanup()
diff --git a/common/populate b/common/populate
index 96e6a0f0572f12..e6bcdf346ac4ff 100644
--- a/common/populate
+++ b/common/populate
@@ -540,7 +540,7 @@ _scratch_xfs_populate() {
 	__populate_fragment_file "${SCRATCH_MNT}/REFCOUNTBT"
 	__populate_fragment_file "${SCRATCH_MNT}/RTREFCOUNTBT"
 
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 }
 
 # Populate an ext4 on the scratch device with (we hope) all known
@@ -642,7 +642,7 @@ _scratch_ext4_populate() {
 	# Make sure we get all the fragmentation we asked for
 	__populate_fragment_file "${SCRATCH_MNT}/S_IFREG.FMT_ETREE"
 
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 }
 
 # Find the inode number of a file
@@ -831,7 +831,7 @@ _scratch_xfs_populate_check() {
 	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
 	leaf_lblk="$((32 * 1073741824 / blksz))"
 	node_lblk="$((64 * 1073741824 / blksz))"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 
 	__populate_check_xfs_dformat "${extents_file}" "extents"
 	__populate_check_xfs_dformat "${btree_file}" "btree"
@@ -948,7 +948,7 @@ _scratch_ext4_populate_check() {
 	extents_slink="$(__populate_find_inode "${SCRATCH_MNT}/S_IFLNK.FMT_EXTENTS")"
 	local_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_LOCAL")"
 	block_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_BLOCK")"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 
 	__populate_check_ext4_dformat "${extents_file}" "extents"
 	__populate_check_ext4_dformat "${etree_file}" "etree"
diff --git a/common/quota b/common/quota
index 344c942045e5f2..7399819bb2579b 100644
--- a/common/quota
+++ b/common/quota
@@ -92,7 +92,7 @@ _require_xfs_quota_acct_enabled()
 	if [ -z "$umount" ] && [ "$dev" = "$SCRATCH_DEV" ]; then
 		umount="-u"
 	fi
-	test "$umount" = "-u" && umount "$dev" &>/dev/null
+	test "$umount" = "-u" && _umount "$dev" &>/dev/null
 
 	case "$dev" in
 	"$TEST_DEV")	fsname="test";;
diff --git a/common/rc b/common/rc
index d3ee76e01db892..0d5c785cecc017 100644
--- a/common/rc
+++ b/common/rc
@@ -1348,7 +1348,7 @@ _repair_scratch_fs()
 			_scratch_xfs_repair -L 2>&1
 			echo "log zap returns $?"
 		else
-			umount "$SCRATCH_MNT"
+			_umount "$SCRATCH_MNT"
 		fi
 		_scratch_xfs_repair "$@" 2>&1
 		res=$?
@@ -1413,7 +1413,7 @@ _repair_test_fs()
 				_test_xfs_repair -L >>$tmp.repair 2>&1
 				echo "log zap returns $?" >> $tmp.repair
 			else
-				umount "$TEST_DEV"
+				_umount "$TEST_DEV"
 			fi
 			_test_xfs_repair "$@" >>$tmp.repair 2>&1
 			res=$?
diff --git a/common/xfs b/common/xfs
index 86654a9379cf89..b9e897e0e8839a 100644
--- a/common/xfs
+++ b/common/xfs
@@ -466,7 +466,7 @@ _require_xfs_has_feature()
 
 	_xfs_has_feature "$1" "$2" && return 0
 
-	test "$umount" = "-u" && umount "$fs" &>/dev/null
+	test "$umount" = "-u" && _umount "$fs" &>/dev/null
 
 	test -n "$message" && _notrun "$message"
 
diff --git a/tests/btrfs/012 b/tests/btrfs/012
index 5811b3b339cb3e..7bb075dc2d0e93 100755
--- a/tests/btrfs/012
+++ b/tests/btrfs/012
@@ -70,7 +70,7 @@ mount -o loop $SCRATCH_MNT/ext2_saved/image $SCRATCH_MNT/mnt || \
 
 echo "Checking saved ext2 image against the original one:"
 $FSSUM_PROG -r $tmp.original $SCRATCH_MNT/mnt/$BASENAME
-umount $SCRATCH_MNT/mnt
+_umount $SCRATCH_MNT/mnt
 
 echo "Generating new data on the converted btrfs" >> $seqres.full
 mkdir -p $SCRATCH_MNT/new 
diff --git a/tests/btrfs/199 b/tests/btrfs/199
index f161e55057ff27..bdad1cb934c91f 100755
--- a/tests/btrfs/199
+++ b/tests/btrfs/199
@@ -19,7 +19,7 @@ _begin_fstest auto quick trim fiemap
 _cleanup()
 {
 	cd /
-	umount $loop_mnt &> /dev/null
+	_umount $loop_mnt &> /dev/null
 	_destroy_loop_device $loop_dev &> /dev/null
 	rm -rf $tmp.*
 }
diff --git a/tests/btrfs/291 b/tests/btrfs/291
index c31de3a96ef1f5..f69b65114ed696 100755
--- a/tests/btrfs/291
+++ b/tests/btrfs/291
@@ -134,7 +134,7 @@ do
 	_mount $snap_dev $SCRATCH_MNT || _fail "mount failed at entry $cur"
 	fsverity measure $SCRATCH_MNT/fsv >>$seqres.full 2>&1
 	measured=$?
-	umount $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 	[ $state -eq 1 ] && [ $measured -eq 0 ] && state=2
 	[ $state -eq 2 ] && ([ $measured -eq 0 ] || _fail "verity done, but measurement failed at entry $cur")
 	post_mount=$(count_merkle_items $snap_dev)
diff --git a/tests/btrfs/298 b/tests/btrfs/298
index d4aee55e785a94..c5b65772d428b1 100755
--- a/tests/btrfs/298
+++ b/tests/btrfs/298
@@ -31,11 +31,11 @@ $BTRFS_UTIL_PROG device scan --forget
 echo "#Scan seed device and check using mount" >> $seqres.full
 $BTRFS_UTIL_PROG device scan $SCRATCH_DEV >> $seqres.full
 _mount $SPARE_DEV $SCRATCH_MNT
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 echo "#check again, ensures seed device still in kernel" >> $seqres.full
 _mount $SPARE_DEV $SCRATCH_MNT
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 echo "#Now scan of non-seed device makes kernel forget" >> $seqres.full
 $BTRFS_TUNE_PROG -f -S 0 $SCRATCH_DEV >> $seqres.full 2>&1
diff --git a/tests/ext4/006 b/tests/ext4/006
index d7862073114872..579eab55b32d26 100755
--- a/tests/ext4/006
+++ b/tests/ext4/006
@@ -97,7 +97,7 @@ echo "++ modify scratch" >> $seqres.full
 _scratch_fuzz_modify >> $seqres.full 2>&1
 
 echo "++ unmount" >> $seqres.full
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 # repair in a loop...
 for p in $(seq 1 "${FSCK_PASSES}"); do
@@ -122,7 +122,7 @@ echo "++ modify scratch" >> $ROUND2_LOG
 _scratch_fuzz_modify >> $ROUND2_LOG 2>&1
 
 echo "++ unmount" >> $ROUND2_LOG
-umount "${SCRATCH_MNT}" >> $ROUND2_LOG 2>&1
+_umount "${SCRATCH_MNT}" >> $ROUND2_LOG 2>&1
 
 cat "$ROUND2_LOG" >> $seqres.full
 
diff --git a/tests/ext4/007 b/tests/ext4/007
index deedbd9e8fb3d8..24cc2290f79a29 100755
--- a/tests/ext4/007
+++ b/tests/ext4/007
@@ -54,7 +54,7 @@ done
 for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
@@ -89,7 +89,7 @@ for x in `seq 1 64`; do
 	test $? -ne 0 && broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/008 b/tests/ext4/008
index b4b20ac10d6d2a..a586bf681dfd34 100755
--- a/tests/ext4/008
+++ b/tests/ext4/008
@@ -50,7 +50,7 @@ done
 for x in `seq 2 64`; do
 	echo moo >> "${TESTFILE}.${x}"
 done
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
@@ -70,7 +70,7 @@ e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
 echo "+ mount image (2)"
 _scratch_mount
 
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/009 b/tests/ext4/009
index 06a42fd77ffa0c..f6fe1e5f0d8d2a 100755
--- a/tests/ext4/009
+++ b/tests/ext4/009
@@ -45,13 +45,13 @@ done
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 freeblks="$(stat -f -c '%a' "${SCRATCH_MNT}")"
 $XFS_IO_PROG -f -c "falloc 0 $((blksz * freeblks))" "${SCRATCH_MNT}/bigfile2" >> $seqres.full
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ make some files"
 _scratch_mount
 rm -rf "${SCRATCH_MNT}/bigfile2"
 touch "${SCRATCH_MNT}/bigfile"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
@@ -70,7 +70,7 @@ $XFS_IO_PROG -f -c "falloc 0 $((blksz * freeblks))" "${SCRATCH_MNT}/bigfile" >>
 after="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
 echo "$((after * b_bytes))" lt "$((blksz * freeblks / 4))" >> $seqres.full
 test "$((after * b_bytes))" -lt "$((blksz * freeblks / 4))" || _fail "falloc should fail"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
@@ -80,7 +80,7 @@ _scratch_mount
 
 echo "+ modify files (2)"
 $XFS_IO_PROG -f -c "falloc 0 $((blksz * freeblks))" "${SCRATCH_MNT}/bigfile" >> $seqres.full
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/010 b/tests/ext4/010
index 1139c79e80d538..27ce20f822256f 100755
--- a/tests/ext4/010
+++ b/tests/ext4/010
@@ -46,7 +46,7 @@ echo "+ make some files"
 for i in `seq 1 $((nr_groups * 8))`; do
 	mkdir -p "${SCRATCH_MNT}/d_${i}"
 done
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
@@ -61,7 +61,7 @@ _scratch_mount
 
 echo "+ modify files"
 touch "${SCRATCH_MNT}/file0" > /dev/null 2>&1 && _fail "touch should fail"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
@@ -71,7 +71,7 @@ _scratch_mount
 
 echo "+ modify files (2)"
 touch "${SCRATCH_MNT}/file1"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/011 b/tests/ext4/011
index cae4fb6b84768b..cb085c95596de1 100755
--- a/tests/ext4/011
+++ b/tests/ext4/011
@@ -39,7 +39,7 @@ blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 
 echo "+ make some files"
 echo moo > "${SCRATCH_MNT}/file0"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/012 b/tests/ext4/012
index f7f2b0fb455762..e7adc617c4db17 100755
--- a/tests/ext4/012
+++ b/tests/ext4/012
@@ -39,7 +39,7 @@ blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 
 echo "+ make some files"
 echo moo > "${SCRATCH_MNT}/file0"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/013 b/tests/ext4/013
index 7d2a9154a66936..4363e3d104b716 100755
--- a/tests/ext4/013
+++ b/tests/ext4/013
@@ -50,7 +50,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
@@ -72,7 +72,7 @@ for x in `seq 1 64`; do
 	test $? -ne 0 && broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
@@ -93,7 +93,7 @@ for x in `seq 1 64`; do
 	test $? -ne 0 && broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/014 b/tests/ext4/014
index ffed795ad4e93c..c874a62335d1f3 100755
--- a/tests/ext4/014
+++ b/tests/ext4/014
@@ -49,7 +49,7 @@ done
 for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
@@ -70,7 +70,7 @@ for x in `seq 1 64`; do
 	test $? -ne 0 && broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1 && _fail "e2fsck should not succeed"
@@ -91,7 +91,7 @@ for x in `seq 1 64`; do
 	test $? -ne 0 && broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/015 b/tests/ext4/015
index 81feda5c9423fb..32b3884de32035 100755
--- a/tests/ext4/015
+++ b/tests/ext4/015
@@ -45,7 +45,7 @@ $XFS_IO_PROG -f -c "falloc 0 $((blksz * freeblks))" "${SCRATCH_MNT}/bigfile" >>
 seq 1 2 ${freeblks} | while read lblk; do
 	$XFS_IO_PROG -f -c "fpunch $((lblk * blksz)) ${blksz}" "${SCRATCH_MNT}/bigfile" >> $seqres.full
 done
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
@@ -60,7 +60,7 @@ _scratch_mount
 
 echo "+ modify files"
 echo moo >> "${SCRATCH_MNT}/bigfile" 2> /dev/null && _fail "extent tree should be corrupt"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
@@ -70,7 +70,7 @@ _scratch_mount
 
 echo "+ modify files (2)"
 $XFS_IO_PROG -f -c "pwrite ${blksz} ${blksz}" "${SCRATCH_MNT}/bigfile" >> $seqres.full
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/016 b/tests/ext4/016
index b7db4cfda649ef..f0f1709b6c208a 100755
--- a/tests/ext4/016
+++ b/tests/ext4/016
@@ -40,7 +40,7 @@ echo "+ make some files"
 for x in `seq 1 15`; do
 	mkdir -p "${SCRATCH_MNT}/test/d_${x}"
 done
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
@@ -53,7 +53,7 @@ _scratch_mount
 
 echo "+ modify dirs"
 mkdir -p "${SCRATCH_MNT}/test/newdir" 2> /dev/null && _fail "directory should be corrupt"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
@@ -63,7 +63,7 @@ _scratch_mount
 
 echo "+ modify dirs (2)"
 mkdir -p "${SCRATCH_MNT}/test/newdir" || _fail "directory should be corrupt"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/017 b/tests/ext4/017
index fc867442c3da3a..7fa563106d676c 100755
--- a/tests/ext4/017
+++ b/tests/ext4/017
@@ -43,7 +43,7 @@ for x in `seq 1 $((blksz * 4 / 256))`; do
 	fname="$(printf "%.255s\n" "$(perl -e "print \"${x}_\" x 500;")")"
 	touch "${SCRATCH_MNT}/test/${fname}"
 done
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
@@ -56,7 +56,7 @@ _scratch_mount
 
 echo "+ modify dirs"
 mkdir -p "${SCRATCH_MNT}/test/newdir" 2> /dev/null && _fail "htree should be corrupt"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
@@ -66,7 +66,7 @@ _scratch_mount
 
 echo "+ modify dirs (2)"
 mkdir -p "${SCRATCH_MNT}/test/newdir" || _fail "htree should not be corrupt"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/018 b/tests/ext4/018
index f7377f059fb826..2e24fe2e82918d 100755
--- a/tests/ext4/018
+++ b/tests/ext4/018
@@ -40,7 +40,7 @@ blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 echo "+ make some files"
 $XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${SCRATCH_MNT}/attrfile" >> $seqres.full
 setfattr -n user.key -v "$(perl -e 'print "v" x 300;')" "${SCRATCH_MNT}/attrfile"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
@@ -54,7 +54,7 @@ _scratch_mount
 
 echo "+ modify attrs"
 setfattr -n user.newkey -v "$(perl -e 'print "v" x 300;')" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "xattr should be corrupt"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
@@ -64,7 +64,7 @@ _scratch_mount
 
 echo "+ modify attrs (2)"
 setfattr -n user.newkey -v "$(perl -e 'print "v" x 300;')" "${SCRATCH_MNT}/attrfile" || _fail "xattr should not be corrupt"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/019 b/tests/ext4/019
index 987972a80a3704..7df7ccbed5e50d 100755
--- a/tests/ext4/019
+++ b/tests/ext4/019
@@ -43,7 +43,7 @@ echo "file contents: moo" > "${SCRATCH_MNT}/x"
 str="$(perl -e "print './' x $(( (blksz / 2) - 16));")x"
 (cd $SCRATCH_MNT; ln -s "${str}" "long_symlink")
 cat "${SCRATCH_MNT}/long_symlink"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
@@ -54,7 +54,7 @@ debugfs -w -R 'zap -f /long_symlink -p 0x62 0' "${SCRATCH_DEV}" 2> /dev/null
 echo "+ mount image"
 _scratch_mount 2> /dev/null
 cat "${SCRATCH_MNT}/long_symlink" 2>/dev/null && _fail "symlink should be broken"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
@@ -62,7 +62,7 @@ e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
 echo "+ mount image (2)"
 _scratch_mount
 cat "${SCRATCH_MNT}/long_symlink" 2>/dev/null && _fail "symlink should be broken"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
diff --git a/tests/ext4/033 b/tests/ext4/033
index 53f7106e2c6ba4..19cd1fb6f20d4c 100755
--- a/tests/ext4/033
+++ b/tests/ext4/033
@@ -14,7 +14,7 @@ _begin_fstest auto ioctl resize
 # Override the default cleanup function.
 _cleanup()
 {
-	umount $SCRATCH_MNT >/dev/null 2>&1
+	_umount $SCRATCH_MNT >/dev/null 2>&1
 	_dmhugedisk_cleanup
 	cd /
 	rm -f $tmp.*
diff --git a/tests/generic/171 b/tests/generic/171
index dd56aa792afbd5..f51f58e9495f8e 100755
--- a/tests/generic/171
+++ b/tests/generic/171
@@ -36,7 +36,7 @@ mkdir $testdir
 echo "Reformat with appropriate size"
 blksz="$(_get_block_size $testdir)"
 nr_blks=10240
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
 if [ $sz_bytes -lt $((32 * 1048576)) ]; then
 	sz_bytes=$((32 * 1048576))
diff --git a/tests/generic/172 b/tests/generic/172
index c23a1228455464..8d32f0288b1556 100755
--- a/tests/generic/172
+++ b/tests/generic/172
@@ -35,7 +35,7 @@ mkdir $testdir
 
 echo "Reformat with appropriate size"
 blksz="$(_get_block_size $testdir)"
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 file_size=$((768 * 1024 * 1024))
 fs_size=$((1024 * 1024 * 1024))
diff --git a/tests/generic/173 b/tests/generic/173
index 8df3c6df21b29c..2f1ea96ef6238e 100755
--- a/tests/generic/173
+++ b/tests/generic/173
@@ -36,7 +36,7 @@ mkdir $testdir
 echo "Reformat with appropriate size"
 blksz="$(_get_block_size $testdir)"
 nr_blks=10240
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
 if [ $sz_bytes -lt $((32 * 1048576)) ]; then
 	sz_bytes=$((32 * 1048576))
diff --git a/tests/generic/174 b/tests/generic/174
index b9c292071445fe..d93546eeb35581 100755
--- a/tests/generic/174
+++ b/tests/generic/174
@@ -37,7 +37,7 @@ mkdir $testdir
 echo "Reformat with appropriate size"
 blksz="$(_get_block_size $testdir)"
 nr_blks=10240
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
 if [ $sz_bytes -lt $((32 * 1048576)) ]; then
 	sz_bytes=$((32 * 1048576))
diff --git a/tests/generic/306 b/tests/generic/306
index a6ea654b67d179..e6502cb881e21e 100755
--- a/tests/generic/306
+++ b/tests/generic/306
@@ -12,7 +12,7 @@ _begin_fstest auto quick rw
 # Override the default cleanup function.
 _cleanup()
 {
-    umount $BINDFILE
+    _umount $BINDFILE
     cd /
     rm -f $tmp.*
 }
diff --git a/tests/generic/330 b/tests/generic/330
index 4fa81f9913ee7e..ab9af84611d725 100755
--- a/tests/generic/330
+++ b/tests/generic/330
@@ -61,7 +61,7 @@ md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 
 echo "Check for damage"
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 _repair_scratch_fs >> $seqres.full
 
 # success, all done
diff --git a/tests/generic/332 b/tests/generic/332
index 4a61e4a02a7cdc..b15546d66a41e0 100755
--- a/tests/generic/332
+++ b/tests/generic/332
@@ -61,7 +61,7 @@ md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 
 echo "Check for damage"
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 _repair_scratch_fs >> $seqres.full
 
 # success, all done
diff --git a/tests/generic/395 b/tests/generic/395
index 45787fff06be1d..d0600d0282c6a4 100755
--- a/tests/generic/395
+++ b/tests/generic/395
@@ -75,7 +75,7 @@ mount --bind $SCRATCH_MNT $SCRATCH_MNT/ro_bind_mnt
 mount -o remount,ro,bind $SCRATCH_MNT/ro_bind_mnt
 _set_encpolicy $SCRATCH_MNT/ro_bind_mnt/ro_dir |& _filter_scratch
 _get_encpolicy $SCRATCH_MNT/ro_bind_mnt/ro_dir |& _filter_scratch
-umount $SCRATCH_MNT/ro_bind_mnt
+_umount $SCRATCH_MNT/ro_bind_mnt
 
 # success, all done
 status=0
diff --git a/tests/generic/563 b/tests/generic/563
index ade66f93fbf30b..166774653a66d6 100755
--- a/tests/generic/563
+++ b/tests/generic/563
@@ -21,7 +21,7 @@ _cleanup()
 
 	echo $$ > $cgdir/cgroup.procs
 	rmdir $cgdir/$seq-cg* > /dev/null 2>&1
-	umount $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 	_destroy_loop_device $LOOP_DEV > /dev/null 2>&1
 }
 
@@ -80,7 +80,7 @@ reset()
 	rmdir $cgdir/$seq-cg* > /dev/null 2>&1
 	$XFS_IO_PROG -fc "pwrite 0 $iosize" $SCRATCH_MNT/file \
 		>> $seqres.full 2>&1
-	umount $SCRATCH_MNT || _fail "umount failed"
+	_umount $SCRATCH_MNT || _fail "umount failed"
 	_mount $LOOP_DEV $SCRATCH_MNT || _fail "mount failed"
 	stat $SCRATCH_MNT/file > /dev/null
 }
diff --git a/tests/generic/631 b/tests/generic/631
index c7c95e5608b760..c9f8299c948f83 100755
--- a/tests/generic/631
+++ b/tests/generic/631
@@ -84,7 +84,7 @@ worker() {
 		touch $mergedir/etc/access.conf
 		mv $mergedir/etc/access.conf $mergedir/etc/access.conf.bak
 		touch $mergedir/etc/access.conf
-		umount $mergedir
+		_umount $mergedir
 	done
 	rm -f $SCRATCH_MNT/workers/$tag
 }
diff --git a/tests/generic/717 b/tests/generic/717
index 4378e964ab8597..7ff356e255b3d1 100755
--- a/tests/generic/717
+++ b/tests/generic/717
@@ -85,7 +85,7 @@ mkdir -p $SCRATCH_MNT/xyz
 mount --bind $dir $SCRATCH_MNT/xyz --bind
 _pwrite_byte 0x60 0 $((blksz * (nrblks + 2))) $dir/c >> $seqres.full
 $XFS_IO_PROG -c "exchangerange $SCRATCH_MNT/xyz/c" $dir/a
-umount $SCRATCH_MNT/xyz
+_umount $SCRATCH_MNT/xyz
 
 echo Swapping a file with itself
 $XFS_IO_PROG -c "exchangerange $dir/a" $dir/a
diff --git a/tests/xfs/014 b/tests/xfs/014
index 098f64186e1134..efae4efa5138f5 100755
--- a/tests/xfs/014
+++ b/tests/xfs/014
@@ -22,7 +22,7 @@ _begin_fstest auto enospc quick quota prealloc
 _cleanup()
 {
 	cd /
-	umount $LOOP_MNT 2>/dev/null
+	_umount $LOOP_MNT 2>/dev/null
 	_scratch_unmount 2>/dev/null
 	rm -f $tmp.*
 }
@@ -174,7 +174,7 @@ mount -t xfs -o loop,uquota,gquota $LOOP_FILE $LOOP_MNT || \
 _test_enospc $LOOP_MNT
 _test_edquot $LOOP_MNT
 
-umount $LOOP_MNT
+_umount $LOOP_MNT
 
 echo $orig_sp_time > /proc/sys/fs/xfs/speculative_prealloc_lifetime
 
diff --git a/tests/xfs/049 b/tests/xfs/049
index 668ac374576a69..89ee1dbdff4f10 100755
--- a/tests/xfs/049
+++ b/tests/xfs/049
@@ -13,8 +13,8 @@ _begin_fstest rw auto quick
 _cleanup()
 {
     cd /
-    umount $SCRATCH_MNT/test2 > /dev/null 2>&1
-    umount $SCRATCH_MNT/test > /dev/null 2>&1
+    _umount $SCRATCH_MNT/test2 > /dev/null 2>&1
+    _umount $SCRATCH_MNT/test > /dev/null 2>&1
     rm -f $tmp.*
 
     if [ -w $seqres.full ]
@@ -96,11 +96,11 @@ rm -rf $SCRATCH_MNT/test/* >> $seqres.full 2>&1 \
     || _fail "!!! clean failed"
 
 _log "umount ext2 on xfs"
-umount $SCRATCH_MNT/test2 >> $seqres.full 2>&1 \
+_umount $SCRATCH_MNT/test2 >> $seqres.full 2>&1 \
     || _fail "!!! umount ext2 failed"
 
 _log "umount xfs"
-umount $SCRATCH_MNT/test >> $seqres.full 2>&1 \
+_umount $SCRATCH_MNT/test >> $seqres.full 2>&1 \
     || _fail "!!! umount xfs failed"
 
 echo "--- mounts at end (before cleanup)" >> $seqres.full
diff --git a/tests/xfs/073 b/tests/xfs/073
index 28f1fad08b8c96..7d99179b7bc974 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -21,9 +21,9 @@ _cleanup()
 {
 	cd /
 	_scratch_unmount 2>/dev/null
-	umount $imgs.loop 2>/dev/null
+	_umount $imgs.loop 2>/dev/null
 	[ -d $imgs.loop ] && rmdir $imgs.loop
-	umount $imgs.source_dir 2>/dev/null
+	_umount $imgs.source_dir 2>/dev/null
 	[ -d $imgs.source_dir ] && rm -rf $imgs.source_dir
 	rm -f $imgs.* $tmp.* /var/tmp/xfs_copy.log.*
 }
@@ -98,8 +98,8 @@ _verify_copy()
 	diff -u $tmp.geometry1 $tmp.geometry2
 
 	echo unmounting and removing new image
-	umount $source_dir
-	umount $target_dir > /dev/null 2>&1
+	_umount $source_dir
+	_umount $target_dir > /dev/null 2>&1
 	rm -f $target
 }
 
diff --git a/tests/xfs/074 b/tests/xfs/074
index 278f0ade694d22..282642a8674557 100755
--- a/tests/xfs/074
+++ b/tests/xfs/074
@@ -59,7 +59,7 @@ $XFS_IO_PROG -ft \
 	-c "falloc 0 $(($BLOCK_SIZE * 2097152))" \
 	$LOOP_MNT/foo >> $seqres.full
 
-umount $LOOP_MNT
+_umount $LOOP_MNT
 _check_xfs_filesystem $LOOP_DEV none none
 
 _mkfs_dev -f $LOOP_DEV
@@ -72,7 +72,7 @@ $XFS_IO_PROG -ft \
 	-c "falloc 1023m 2g" \
 	$LOOP_MNT/foo >> $seqres.full
 
-umount $LOOP_MNT
+_umount $LOOP_MNT
 _check_xfs_filesystem $LOOP_DEV none none
 
 # success, all done
diff --git a/tests/xfs/083 b/tests/xfs/083
index 9291c8c0382489..875937e6ffe3b3 100755
--- a/tests/xfs/083
+++ b/tests/xfs/083
@@ -57,7 +57,7 @@ scratch_repair() {
 			_scratch_xfs_repair -L >> "${FSCK_LOG}" 2>&1
 			echo "+++ returns $?" >> "${FSCK_LOG}"
 		else
-			umount "${SCRATCH_MNT}" >> "${FSCK_LOG}" 2>&1
+			_umount "${SCRATCH_MNT}" >> "${FSCK_LOG}" 2>&1
 		fi
 	elif [ "${fsck_pass}" -eq "${FSCK_PASSES}" ]; then
 		echo "++ fsck did not fix in ${FSCK_PASSES} passes." >> "${FSCK_LOG}"
@@ -109,7 +109,7 @@ echo "+++ modify scratch" >> $seqres.full
 _scratch_fuzz_modify >> $seqres.full 2>&1
 
 echo "++ umount" >> $seqres.full
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 # repair in a loop...
 for p in $(seq 1 "${FSCK_PASSES}"); do
@@ -134,7 +134,7 @@ echo "+++ modify scratch" >> $ROUND2_LOG
 _scratch_fuzz_modify >> $ROUND2_LOG 2>&1
 
 echo "++ umount" >> $ROUND2_LOG
-umount "${SCRATCH_MNT}" >> $ROUND2_LOG 2>&1
+_umount "${SCRATCH_MNT}" >> $ROUND2_LOG 2>&1
 
 cat "$ROUND2_LOG" >> $seqres.full
 
diff --git a/tests/xfs/085 b/tests/xfs/085
index d33dd199e6f9c1..9faf16fde5cdab 100755
--- a/tests/xfs/085
+++ b/tests/xfs/085
@@ -54,7 +54,7 @@ for x in `seq 2 64`; do
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
 agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -82,7 +82,7 @@ for x in `seq 1 64`; do
 	test $? -ne 0 && broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/086 b/tests/xfs/086
index 44985f3913254d..03327cdeaf3f08 100755
--- a/tests/xfs/086
+++ b/tests/xfs/086
@@ -56,7 +56,7 @@ done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
 agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 test "${agcount}" -gt 1 || _notrun "Single-AG XFS not supported"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -73,7 +73,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 	for x in `seq 1 64`; do
 		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
 	done
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -97,7 +97,7 @@ echo "+ modify files (2)"
 for x in `seq 1 64`; do
 	$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
 done
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 _repair_scratch_fs >> $seqres.full 2>&1
@@ -114,7 +114,7 @@ for x in `seq 1 64`; do
 	test -s "${TESTFILE}.${x}" || broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/087 b/tests/xfs/087
index 3cca105685fc6a..aeef30657b9491 100755
--- a/tests/xfs/087
+++ b/tests/xfs/087
@@ -55,7 +55,7 @@ for x in `seq 2 64`; do
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
 agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -72,7 +72,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 	for x in `seq 65 70`; do
 		touch "${TESTFILE}.${x}" 2> /dev/null && broken=0
 	done
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 echo "broken: ${broken}"
 
@@ -91,7 +91,7 @@ for x in `seq 65 70`; do
 	touch "${TESTFILE}.${x}" || broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/088 b/tests/xfs/088
index b54a1ab7d00342..de100136014ba7 100755
--- a/tests/xfs/088
+++ b/tests/xfs/088
@@ -56,7 +56,7 @@ for x in `seq 2 64`; do
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
 agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -73,7 +73,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 	for x in `seq 1 64`; do
 		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full 2>> $seqres.full
 	done
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -97,7 +97,7 @@ echo "+ modify files (2)"
 for x in `seq 1 64`; do
 	$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
 done
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 _repair_scratch_fs >> $seqres.full 2>&1
@@ -114,7 +114,7 @@ for x in `seq 1 64`; do
 	test -s "${TESTFILE}.${x}" || broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/089 b/tests/xfs/089
index ff3ae719326eca..f5640a46177578 100755
--- a/tests/xfs/089
+++ b/tests/xfs/089
@@ -56,7 +56,7 @@ for x in `seq 2 64`; do
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
 agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -73,7 +73,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 	for x in `seq 1 64`; do
 		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full 2>> $seqres.full
 	done
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -98,7 +98,7 @@ echo "+ modify files (2)"
 for x in `seq 1 64`; do
 	$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
 done
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 _repair_scratch_fs >> $seqres.full 2>&1
@@ -115,7 +115,7 @@ for x in `seq 1 64`; do
 	test -s "${TESTFILE}.${x}" || broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/091 b/tests/xfs/091
index 3f606f8845797d..c7857cdf1b690b 100755
--- a/tests/xfs/091
+++ b/tests/xfs/091
@@ -56,7 +56,7 @@ for x in `seq 2 64`; do
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
 agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -73,7 +73,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 	for x in `seq 1 64`; do
 		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full 2>> $seqres.full
 	done
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -98,7 +98,7 @@ echo "+ modify files (2)"
 for x in `seq 1 64`; do
 	$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
 done
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ repair fs"
 _repair_scratch_fs >> $seqres.full 2>&1
@@ -115,7 +115,7 @@ for x in `seq 1 64`; do
 	test -s "${TESTFILE}.${x}" || broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/093 b/tests/xfs/093
index c4e8006063e121..cfb2a8c80c1770 100755
--- a/tests/xfs/093
+++ b/tests/xfs/093
@@ -55,7 +55,7 @@ for x in `seq 2 64`; do
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
 agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -72,7 +72,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 	for x in `seq 65 70`; do
 		touch "${TESTFILE}.${x}" 2> /dev/null && broken=0
 	done
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 echo "broken: ${broken}"
 
@@ -94,7 +94,7 @@ for x in `seq 65 70`; do
 	touch "${TESTFILE}.${x}" || broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/097 b/tests/xfs/097
index 384c76080ddcf4..0fcf65a2a8f65a 100755
--- a/tests/xfs/097
+++ b/tests/xfs/097
@@ -58,7 +58,7 @@ for x in `seq 2 64`; do
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
 agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -74,7 +74,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 	for x in `seq 65 70`; do
 		touch "${TESTFILE}.${x}" 2> /dev/null && broken=0
 	done
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 echo "broken: ${broken}"
 
@@ -93,7 +93,7 @@ for x in `seq 65 70`; do
 	touch "${TESTFILE}.${x}" || broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/098 b/tests/xfs/098
index a47cda67e14e29..48eb3fa2b3a753 100755
--- a/tests/xfs/098
+++ b/tests/xfs/098
@@ -56,7 +56,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -98,7 +98,7 @@ for x in `seq 1 64`; do
 	test $? -ne 0 && broken=1
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/099 b/tests/xfs/099
index f5321fe3d20b1c..17e1e8df7bf751 100755
--- a/tests/xfs/099
+++ b/tests/xfs/099
@@ -44,7 +44,7 @@ node_lblk="$((64 * 1073741824 / blksz))"
 echo "+ make some files"
 __populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}"
 inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -60,7 +60,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
 	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -77,7 +77,7 @@ echo "+ modify dir (2)"
 mkdir -p "${SCRATCH_MNT}/blockdir"
 rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
 mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/100 b/tests/xfs/100
index 6f465a79c926d2..dd50d984800335 100755
--- a/tests/xfs/100
+++ b/tests/xfs/100
@@ -44,7 +44,7 @@ node_lblk="$((64 * 1073741824 / blksz))"
 echo "+ make some files"
 __populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}"
 inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -65,7 +65,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
 	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -82,7 +82,7 @@ echo "+ modify dir (2)"
 mkdir -p "${SCRATCH_MNT}/blockdir"
 rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
 mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/101 b/tests/xfs/101
index a926acb0bc6735..2abcd711b18703 100755
--- a/tests/xfs/101
+++ b/tests/xfs/101
@@ -44,7 +44,7 @@ node_lblk="$((64 * 1073741824 / blksz))"
 echo "+ make some files"
 __populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}"
 inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -60,7 +60,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
 	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -77,7 +77,7 @@ echo "+ modify dir (2)"
 mkdir -p "${SCRATCH_MNT}/blockdir"
 rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
 mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/102 b/tests/xfs/102
index c3ddec5e432dc5..5a7c036ce55751 100755
--- a/tests/xfs/102
+++ b/tests/xfs/102
@@ -44,7 +44,7 @@ node_lblk="$((64 * 1073741824 / blksz))"
 echo "+ make some files"
 __populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}" true
 inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -65,7 +65,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
 	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -82,7 +82,7 @@ echo "+ modify dir (2)"
 mkdir -p "${SCRATCH_MNT}/blockdir"
 rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
 mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/105 b/tests/xfs/105
index 132aa07f8300ef..30d4dc47ec1fed 100755
--- a/tests/xfs/105
+++ b/tests/xfs/105
@@ -44,7 +44,7 @@ node_lblk="$((64 * 1073741824 / blksz))"
 echo "+ make some files"
 __populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}" true
 inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -65,7 +65,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
 	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -82,7 +82,7 @@ echo "+ modify dir (2)"
 mkdir -p "${SCRATCH_MNT}/blockdir"
 rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
 mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/112 b/tests/xfs/112
index f0e717cf26d8c9..267432a863a92d 100755
--- a/tests/xfs/112
+++ b/tests/xfs/112
@@ -44,7 +44,7 @@ node_lblk="$((64 * 1073741824 / blksz))"
 echo "+ make some files"
 __populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}" true
 inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -65,14 +65,14 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
 	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
 _repair_scratch_fs >> $seqres.full 2>&1
 if [ $? -eq 2 ]; then
 	_scratch_mount
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 	_repair_scratch_fs >> $seqres.full 2>&1
 fi
 
@@ -86,7 +86,7 @@ echo "+ modify dir (2)"
 mkdir -p "${SCRATCH_MNT}/blockdir"
 rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
 mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/113 b/tests/xfs/113
index 22ac8c3fd51b80..2f19346aa74b3d 100755
--- a/tests/xfs/113
+++ b/tests/xfs/113
@@ -44,7 +44,7 @@ node_lblk="$((64 * 1073741824 / blksz))"
 echo "+ make some files"
 __populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}" true
 inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -86,7 +86,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
 	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -103,7 +103,7 @@ echo "+ modify dir (2)"
 mkdir -p "${SCRATCH_MNT}/blockdir"
 rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
 mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/117 b/tests/xfs/117
index 0ca8f1b96ddfd9..ae73ddbebfd53b 100755
--- a/tests/xfs/117
+++ b/tests/xfs/117
@@ -65,7 +65,7 @@ for ((i = 0; i < 64; i++)); do
 done
 echo "First victim inode is: " >> $seqres.full
 stat -c '%i' "$fname" >> $seqres.full
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -85,7 +85,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 		touch "$fname" &>> $seqres.full
 		test $? -eq 0 && broken=0
 	done
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 echo "broken: ${broken}"
 
@@ -110,7 +110,7 @@ for x in `seq 1 64`; do
 	echo "${x}: broken=${broken}" >> $seqres.full
 done
 echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/120 b/tests/xfs/120
index f1f047f53a351b..9d0cc12a3e8b8d 100755
--- a/tests/xfs/120
+++ b/tests/xfs/120
@@ -45,7 +45,7 @@ for i in $(seq 1 2 ${nr}); do
 	$XFS_IO_PROG -f -c "fpunch $((i * blksz)) ${blksz}" "${SCRATCH_MNT}/bigfile" >> $seqres.full
 done
 inode="$(stat -c '%i' "${SCRATCH_MNT}/bigfile")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -60,7 +60,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 	$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" -c 'fsync' "${SCRATCH_MNT}/bigfile" >> $seqres.full 2> /dev/null
 	after="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
 	test "${before}" -eq "${after}" || _fail "pwrite should fail on corrupt bmbt"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -78,7 +78,7 @@ before="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
 $XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" -c 'fsync' "${SCRATCH_MNT}/bigfile" >> $seqres.full 2> /dev/null
 after="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
 test "${before}" -ne "${after}" || _fail "pwrite failed after fixing corrupt bmbt"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/123 b/tests/xfs/123
index 6b56551374cd8f..5bd3c86372058e 100755
--- a/tests/xfs/123
+++ b/tests/xfs/123
@@ -44,7 +44,7 @@ str="$(perl -e "print './' x $reps;")x"
 (cd $SCRATCH_MNT; ln -s "${str}" "long_symlink")
 cat "${SCRATCH_MNT}/long_symlink"
 inode="$(stat -c '%i' "${SCRATCH_MNT}/long_symlink")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -55,7 +55,7 @@ _scratch_xfs_db -x -c "inode ${inode}" -c "dblock 0" -c "stack" -c "blocktrash -
 echo "+ mount image"
 if _try_scratch_mount >> $seqres.full 2>&1; then
 	cat "${SCRATCH_MNT}/long_symlink" 2>/dev/null && _fail "symlink should be broken"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -64,7 +64,7 @@ _repair_scratch_fs >> $seqres.full 2>&1
 echo "+ mount image (2)"
 _scratch_mount
 cat "${SCRATCH_MNT}/long_symlink" 2>/dev/null && _fail "symlink should be broken"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/124 b/tests/xfs/124
index fe870dc96cc783..7890434b397262 100755
--- a/tests/xfs/124
+++ b/tests/xfs/124
@@ -46,7 +46,7 @@ seq 0 "${nr}" | while read d; do
 	setfattr -n "user.x$(printf "%.08d" "$d")" -v "0000000000000000" "${SCRATCH_MNT}/attrfile"
 done
 inode="$(stat -c '%i' "${SCRATCH_MNT}/attrfile")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -64,7 +64,7 @@ echo "+ mount image && modify xattr"
 if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -80,7 +80,7 @@ $CHATTR_PROG -R -f -i "${SCRATCH_MNT}/"
 echo "+ modify xattr (2)"
 getfattr "${SCRATCH_MNT}/attrfile" -n "user.x00000000" > /dev/null 2>&1 && (setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" || _fail "remove corrupt xattr")
 setfattr -n "user.x00000000" -v 'x0x0x0x0' "${SCRATCH_MNT}/attrfile" || _fail "add corrupt xattr"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/125 b/tests/xfs/125
index 89e93650556e40..c3770c185b4063 100755
--- a/tests/xfs/125
+++ b/tests/xfs/125
@@ -47,7 +47,7 @@ seq 1 2 "${nr}" | while read d; do
 	setfattr -x "user.x$(printf "%.08d" "$d")" "${SCRATCH_MNT}/attrfile"
 done
 inode="$(stat -c '%i' "${SCRATCH_MNT}/attrfile")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -64,7 +64,7 @@ echo "+ mount image && modify xattr"
 if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -80,7 +80,7 @@ $CHATTR_PROG -R -f -i "${SCRATCH_MNT}/"
 echo "+ modify xattr (2)"
 setfattr -n "user.x00000000" -v "1111111111111111" "${SCRATCH_MNT}/attrfile" || _fail "modified corrupt xattr"
 setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" || _fail "delete corrupt xattr"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/126 b/tests/xfs/126
index 5614ea398c0142..14eb2a6157e141 100755
--- a/tests/xfs/126
+++ b/tests/xfs/126
@@ -47,7 +47,7 @@ seq 1 2 "${nr}" | while read d; do
 	setfattr -x "user.x$(printf "%.08d" "$d")" "${SCRATCH_MNT}/attrfile"
 done
 inode="$(stat -c '%i' "${SCRATCH_MNT}/attrfile")"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
@@ -69,7 +69,7 @@ echo "+ mount image && modify xattr"
 if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
-	umount "${SCRATCH_MNT}"
+	_umount "${SCRATCH_MNT}"
 fi
 
 echo "+ repair fs"
@@ -84,7 +84,7 @@ $CHATTR_PROG -R -f -i "${SCRATCH_MNT}/"
 
 echo "+ modify xattr (2)"
 getfattr "${SCRATCH_MNT}/attrfile" -n "user.x00000000" 2> /dev/null && (setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" || _fail "modified corrupt xattr")
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
diff --git a/tests/xfs/130 b/tests/xfs/130
index 3e6dd861c47851..b1792a98e57db6 100755
--- a/tests/xfs/130
+++ b/tests/xfs/130
@@ -78,7 +78,7 @@ $CHATTR_PROG -R -f -i "${SCRATCH_MNT}/"
 echo "+ reflink more (2)"
 _cp_reflink "${SCRATCH_MNT}/file1" "${SCRATCH_MNT}/file5" || \
 	_fail "modified refcount tree"
-umount "${SCRATCH_MNT}"
+_umount "${SCRATCH_MNT}"
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> "$seqres.full" 2>&1 || \
diff --git a/tests/xfs/152 b/tests/xfs/152
index 7ba00c4bfac9ff..66577cfb4617fc 100755
--- a/tests/xfs/152
+++ b/tests/xfs/152
@@ -15,7 +15,7 @@ _begin_fstest auto quick quota idmapped
 
 wipe_mounts()
 {
-	umount "${SCRATCH_MNT}/idmapped" >/dev/null 2>&1
+	_umount "${SCRATCH_MNT}/idmapped" >/dev/null 2>&1
 	_scratch_unmount >/dev/null 2>&1
 }
 
diff --git a/tests/xfs/169 b/tests/xfs/169
index 6400fd9e6bdc8b..16c5385cf4815a 100755
--- a/tests/xfs/169
+++ b/tests/xfs/169
@@ -15,7 +15,7 @@ _begin_fstest auto clone
 _cleanup()
 {
     cd /
-    umount $SCRATCH_MNT > /dev/null 2>&1
+    _umount $SCRATCH_MNT > /dev/null 2>&1
     rm -rf $tmp.*
 }
 
@@ -43,7 +43,7 @@ for i in 1 2 x; do
 		_reflink_range  $testdir/file1 $((nr * blksz)) \
 				$testdir/file2 $((nr * blksz)) $blksz >> $seqres.full
 	done
-	umount $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 	_check_scratch_fs
 	_scratch_mount
 
@@ -51,7 +51,7 @@ for i in 1 2 x; do
 
 	echo "$i: Delete both files"
 	rm -rf $testdir/file1 $testdir/file2
-	umount $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 	_check_scratch_fs
 	_scratch_mount
 done
diff --git a/tests/xfs/206 b/tests/xfs/206
index bfd2dee939ddd7..16a734c3751194 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -18,7 +18,7 @@ _begin_fstest growfs auto quick
 # Override the default cleanup function.
 _cleanup()
 {
-    umount $tmpdir
+    _umount $tmpdir
     rmdir $tmpdir
     rm -f $tmp
     rm -f $tmpfile
diff --git a/tests/xfs/216 b/tests/xfs/216
index 680239b4ef788d..149c8fdfec887d 100755
--- a/tests/xfs/216
+++ b/tests/xfs/216
@@ -52,7 +52,7 @@ _do_mkfs()
 			-d name=$LOOP_DEV,size=${i}g $loop_mkfs_opts |grep log
 		mount -o loop -t xfs $LOOP_DEV $LOOP_MNT
 		echo "test write" > $LOOP_MNT/test
-		umount $LOOP_MNT > /dev/null 2>&1
+		_umount $LOOP_MNT > /dev/null 2>&1
 	done
 }
 # make large holey file
diff --git a/tests/xfs/217 b/tests/xfs/217
index 41caaf738267d4..30a186d7294940 100755
--- a/tests/xfs/217
+++ b/tests/xfs/217
@@ -31,7 +31,7 @@ _do_mkfs()
 			-d name=$LOOP_DEV,size=${i}g |grep log
 		mount -o loop -t xfs $LOOP_DEV $LOOP_MNT
 		echo "test write" > $LOOP_MNT/test
-		umount $LOOP_MNT > /dev/null 2>&1
+		_umount $LOOP_MNT > /dev/null 2>&1
 
 		# punch out the previous blocks so that we keep the amount of
 		# disk space the test requires down to a minimum.
diff --git a/tests/xfs/235 b/tests/xfs/235
index 5b201d93076952..0184ff71f2878c 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -31,7 +31,7 @@ _pwrite_byte 0x62 0 $((blksz * 64)) ${SCRATCH_MNT}/file0 >> $seqres.full
 _pwrite_byte 0x61 0 $((blksz * 64)) ${SCRATCH_MNT}/file1 >> $seqres.full
 cp -p ${SCRATCH_MNT}/file0 ${SCRATCH_MNT}/file2
 cp -p ${SCRATCH_MNT}/file1 ${SCRATCH_MNT}/file3
-umount ${SCRATCH_MNT}
+_umount ${SCRATCH_MNT}
 
 echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || \
@@ -49,7 +49,7 @@ if _try_scratch_mount >> $seqres.full 2>&1; then
 
 	$XFS_IO_PROG -f -c "pwrite -S 0x63 0 $((blksz * 64))" -c "fsync" ${SCRATCH_MNT}/file4 >> $seqres.full 2>&1
 	test -s ${SCRATCH_MNT}/file4 && _fail "should not be able to copy with busted rmap btree"
-	umount ${SCRATCH_MNT}
+	_umount ${SCRATCH_MNT}
 fi
 
 echo "+ repair fs"
@@ -66,7 +66,7 @@ $CHATTR_PROG -R -f -i ${SCRATCH_MNT}/
 echo "+ copy more (2)"
 cp -p ${SCRATCH_MNT}/file1 ${SCRATCH_MNT}/file5 || \
 	_fail "modified rmap tree"
-umount ${SCRATCH_MNT}
+_umount ${SCRATCH_MNT}
 
 echo "+ check fs (2)"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || \
diff --git a/tests/xfs/236 b/tests/xfs/236
index a374a300d1905a..277a9a402e2e05 100755
--- a/tests/xfs/236
+++ b/tests/xfs/236
@@ -15,7 +15,7 @@ _begin_fstest auto rmap punch
 _cleanup()
 {
     cd /
-    umount $SCRATCH_MNT > /dev/null 2>&1
+    _umount $SCRATCH_MNT > /dev/null 2>&1
     rm -rf $tmp.*
 }
 
@@ -44,7 +44,7 @@ for i in 1 2 x; do
 	seq 1 2 $((nr_blks - 1)) | while read nr; do
 		$XFS_IO_PROG -c "fpunch $((nr * blksz)) $blksz" $testdir/file2 >> $seqres.full
 	done
-	umount $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 	_check_scratch_fs
 	_scratch_mount
 
@@ -52,7 +52,7 @@ for i in 1 2 x; do
 
 	echo "$i: Delete both files"
 	rm -rf $testdir/file1 $testdir/file2
-	umount $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 	_check_scratch_fs
 	_scratch_mount
 done
diff --git a/tests/xfs/239 b/tests/xfs/239
index bfe722c0add020..7dc9be7d2edfe0 100755
--- a/tests/xfs/239
+++ b/tests/xfs/239
@@ -66,7 +66,7 @@ md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 
 echo "Check for damage"
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 _repair_scratch_fs >> $seqres.full
 
 # success, all done
diff --git a/tests/xfs/241 b/tests/xfs/241
index 1532493979ffa7..a779e321417520 100755
--- a/tests/xfs/241
+++ b/tests/xfs/241
@@ -66,7 +66,7 @@ md5sum $testdir/file1 | _filter_scratch
 md5sum $testdir/file2 | _filter_scratch
 
 echo "Check for damage"
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 _repair_scratch_fs >> $seqres.full
 
 # success, all done
diff --git a/tests/xfs/250 b/tests/xfs/250
index f8846be6e197aa..82ab08d65192e7 100755
--- a/tests/xfs/250
+++ b/tests/xfs/250
@@ -13,7 +13,7 @@ _begin_fstest auto quick rw prealloc metadata
 _cleanup()
 {
 	cd /
-	umount $LOOP_MNT 2>/dev/null
+	_umount $LOOP_MNT 2>/dev/null
 	rm -f $LOOP_DEV
 	rmdir $LOOP_MNT
 }
@@ -60,7 +60,7 @@ _test_loop()
 	$XFS_IO_PROG -f -c "resvsp 0 $fsize" $LOOP_MNT/foo | _filter_io
 
 	echo "*** unmount loop filesystem"
-	umount $LOOP_MNT > /dev/null 2>&1
+	_umount $LOOP_MNT > /dev/null 2>&1
 
 	echo "*** check loop filesystem"
 	 _check_xfs_filesystem $LOOP_DEV none none
diff --git a/tests/xfs/265 b/tests/xfs/265
index 21de4c054a573f..2ba7342d066bb6 100755
--- a/tests/xfs/265
+++ b/tests/xfs/265
@@ -16,7 +16,7 @@ _begin_fstest auto clone
 _cleanup()
 {
     cd /
-    umount $SCRATCH_MNT > /dev/null 2>&1
+    _umount $SCRATCH_MNT > /dev/null 2>&1
     rm -rf $tmp.*
 }
 
@@ -51,7 +51,7 @@ for i in 1 2 x; do
 		truncate -s $((blksz * (nr_blks - nr))) $testdir/file1.$nr >> $seqres.full
 	done
 
-	umount $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 	_check_scratch_fs
 	_scratch_mount
 
@@ -60,7 +60,7 @@ for i in 1 2 x; do
 	echo "$i: Delete both files"
 	rm -rf $testdir
 	mkdir -p $testdir
-	umount $SCRATCH_MNT
+	_umount $SCRATCH_MNT
 	_check_scratch_fs
 	_scratch_mount
 done
diff --git a/tests/xfs/310 b/tests/xfs/310
index 34d17be97f36dd..f2a7ca50f67199 100755
--- a/tests/xfs/310
+++ b/tests/xfs/310
@@ -13,7 +13,7 @@ _begin_fstest auto clone rmap prealloc
 _cleanup()
 {
 	cd /
-	umount $SCRATCH_MNT > /dev/null 2>&1
+	_umount $SCRATCH_MNT > /dev/null 2>&1
 	_dmhugedisk_cleanup
 	rm -rf $tmp.*
 }
@@ -53,7 +53,7 @@ $XFS_IO_PROG -f -c "falloc 0 $((nr_blks * blksz))" $testdir/file1 >> $seqres.ful
 echo "Check extent count"
 xfs_bmap -l -p -v $testdir/file1 | grep '^[[:space:]]*2:' -q && xfs_bmap -l -p -v $testdir/file1
 inum=$(stat -c '%i' $testdir/file1)
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 
 echo "Check bmap count"
 nr_bmaps=$(xfs_db -c "inode $inum" -c "bmap" $DMHUGEDISK_DEV | grep 'data offset' | wc -l)
diff --git a/tests/xfs/716 b/tests/xfs/716
index cd4fffef298d31..55c66d1cf8bb19 100755
--- a/tests/xfs/716
+++ b/tests/xfs/716
@@ -49,7 +49,7 @@ ino=$(stat -c '%i' $file)
 
 # Figure out how many extents we need to have to create a data fork that's in
 # btree format.
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 di_forkoff=$(_scratch_xfs_db -c "inode $ino" -c "p core.forkoff" | \
 	awk '{print $3}')
 _scratch_xfs_db -c "inode $ino" -c "p" >> $seqres.full
@@ -61,7 +61,7 @@ $XFS_IO_PROG -c "falloc 0 $(( (min_ext_for_btree + 1) * 2 * blksz))" $file
 $here/src/punch-alternating $file
 
 # Make sure the data fork is in btree format.
-umount $SCRATCH_MNT
+_umount $SCRATCH_MNT
 _scratch_xfs_db -c "inode $ino" -c "p core.format" | grep -q "btree" || \
 	echo "data fork not in btree format?"
 echo "about to start test" >> $seqres.full

