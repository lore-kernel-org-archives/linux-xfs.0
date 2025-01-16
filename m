Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA8E242D7C;
	Thu, 16 Jan 2025 23:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070818; cv=none; b=aeqxHmnOqLxWIdqgdQrKj/LAFBbvKudfRXXipjsTGQcG4/JJWmEsJhlT3L5krk8OPKN19V1Y0vNzWa9z0kYe6IltVXVhD1K8vOvIx3bW/JddcGjEWO4p98Xs3bD0MvZb9apjv2Eo2UfGm2ZbQffhXyw1XcmEuNmlgOOp2F9H8eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070818; c=relaxed/simple;
	bh=bMyvuCE2rUNgfxw1RFb7l6EqSxFLI2Rp3rkOWkZYiGY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=chncYH5A/xEZzLYTjVlGEui47Zj/YhlT5iYCJrhX0MiOzKRslgaDP0HzIsDaomxX/mSh7kn2lqruxfBFxClppa5sNNQ4teEDofVKtqgEndCnUILy7eljxIV+U3D4347tfRrI/Gs2oTO1JUvpkh59DTc9SHdY6dkaXDHpxOiTGi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AeeDaEsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeeDaEsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2872C4CEDD;
	Thu, 16 Jan 2025 23:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070817;
	bh=bMyvuCE2rUNgfxw1RFb7l6EqSxFLI2Rp3rkOWkZYiGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AeeDaEsiw3N5+JmyLxU5txI6QpknZzujC26you+eg60+Ad1r96YQ8sw1yrvfn/oB+
	 cAdzRU8XA3KnQiMCDcoKUiFUIP34bzAgm1Gc4Seyrc4sKsc/khB2rLZ1oOBkkMbWQA
	 0YOgfkA6ZmEc4UVYpl8RsIG+ZjYL8R03JF8VXva1US7H2mSernZCs2Epdi40tc43e9
	 5UFAVCxAjHWDIIiIOBVzkkZ6oP5sTbtlK8bfsew5l7k82LZcrxrc5biVGtTajHfakJ
	 QjFW3mH8JpOp20sX4kENEufghnL6Lw7AgU1WQekW3E+17EgOTE2cuiWjHjV43OiCp7
	 zr0DbepqLE1xw==
Date: Thu, 16 Jan 2025 15:40:17 -0800
Subject: [PATCH 2/3] xfs: fix quota tests to adapt to realtime quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706977090.1931302.13303306359967049893.stgit@frogsfrogsfrogs>
In-Reply-To: <173706977056.1931302.2974286403286751639.stgit@frogsfrogsfrogs>
References: <173706977056.1931302.2974286403286751639.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix or limit the scope of tests so that we can turn on testing for
realtime quotas.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/quota      |   25 +++++++++++++++++++++++++
 tests/generic/219 |    1 +
 tests/generic/230 |    1 +
 tests/generic/305 |    1 +
 tests/generic/326 |    1 +
 tests/generic/327 |    1 +
 tests/generic/328 |    1 +
 tests/generic/566 |    4 +++-
 tests/generic/587 |    1 +
 tests/generic/603 |    1 +
 tests/generic/691 |    2 ++
 tests/generic/710 |    4 +++-
 tests/xfs/050     |    2 ++
 tests/xfs/096     |    4 ++++
 tests/xfs/106     |    1 +
 tests/xfs/108     |    2 ++
 tests/xfs/152     |    1 +
 tests/xfs/153     |    2 ++
 tests/xfs/161     |    1 +
 tests/xfs/213     |    1 +
 tests/xfs/214     |    1 +
 tests/xfs/220     |    2 ++
 tests/xfs/299     |    2 ++
 tests/xfs/330     |    1 +
 tests/xfs/434     |    1 +
 tests/xfs/435     |    1 +
 tests/xfs/440     |    3 +++
 tests/xfs/441     |    1 +
 tests/xfs/442     |    1 +
 tests/xfs/508     |    2 ++
 tests/xfs/511     |   10 +++++++++-
 tests/xfs/720     |    5 +++++
 32 files changed, 84 insertions(+), 3 deletions(-)


diff --git a/common/quota b/common/quota
index 6735d0fec48991..2f5ccd2fa17363 100644
--- a/common/quota
+++ b/common/quota
@@ -436,5 +436,30 @@ _restore_project_quota()
 	sed -i "/:$id$/d" /etc/projid
 }
 
+# Reconfigure the mounted fs as needed so that we can test the VFS quota
+# utilities.  They do not support realtime block limits or reporting, so
+# we forcibly inhibit rtinherit on XFS filesystems.
+_force_vfs_quota_testing()
+{
+	local mount="${1:-$TEST_DIR}"
+
+	test "$FSTYP" = "xfs" && _xfs_force_bdev data "$mount"
+}
+
+# Does the mounted scratch filesystem have a realtime volume where quota works?
+# Returns nonzero if any of the above are false.
+_scratch_supports_rtquota()
+{
+	case "$FSTYP" in
+	"xfs")
+		if [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ]; then
+			_xfs_scratch_supports_rtquota
+			return
+		fi
+	esac
+
+	return 1
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/219 b/tests/generic/219
index d72aa745fdfcf1..cc2ec119eb4298 100755
--- a/tests/generic/219
+++ b/tests/generic/219
@@ -92,6 +92,7 @@ test_accounting()
 _scratch_unmount 2>/dev/null
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount "-o usrquota,grpquota"
+_force_vfs_quota_testing $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2>/dev/null
 quotaon $SCRATCH_MNT 2>/dev/null
 _scratch_unmount
diff --git a/tests/generic/230 b/tests/generic/230
index 18e20f4b2e9439..a8caf5a808c3c7 100755
--- a/tests/generic/230
+++ b/tests/generic/230
@@ -100,6 +100,7 @@ _qmount_option 'defaults'
 
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount "-o usrquota,grpquota"
+_force_vfs_quota_testing $SCRATCH_MNT
 BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
 quotacheck -u -g $SCRATCH_MNT 2>/dev/null
 quotaon $SCRATCH_MNT 2>/dev/null
diff --git a/tests/generic/305 b/tests/generic/305
index 6ccbb3d07c70c2..373abf57037ed6 100755
--- a/tests/generic/305
+++ b/tests/generic/305
@@ -26,6 +26,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/generic/326 b/tests/generic/326
index 321e7dc6a8e54c..d16e95aabaecd5 100755
--- a/tests/generic/326
+++ b/tests/generic/326
@@ -27,6 +27,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/generic/327 b/tests/generic/327
index 18cfcd1f655bd7..9102cbd6841072 100755
--- a/tests/generic/327
+++ b/tests/generic/327
@@ -25,6 +25,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/generic/328 b/tests/generic/328
index fa33bdb78dba12..db785475db87d6 100755
--- a/tests/generic/328
+++ b/tests/generic/328
@@ -26,6 +26,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/generic/566 b/tests/generic/566
index a41e04852ed88c..a6ec82fd36d8bb 100755
--- a/tests/generic/566
+++ b/tests/generic/566
@@ -35,7 +35,9 @@ _qmount
 dir="$SCRATCH_MNT/dummy"
 mkdir -p $dir
 chown $qa_user $dir
-$XFS_QUOTA_PROG -x -c "limit -g bsoft=100k bhard=100k $qa_user" $SCRATCH_MNT
+_scratch_supports_rtquota && \
+	extra_limits="rtbsoft=100k rtbhard=100k"
+$XFS_QUOTA_PROG -x -c "limit -g bsoft=100k bhard=100k $extra_limits $qa_user" $SCRATCH_MNT
 
 $XFS_IO_PROG -f -c 'pwrite -S 0x58 0 1m' $dir/foo >> $seqres.full
 chown $qa_user "${dir}/foo"
diff --git a/tests/generic/587 b/tests/generic/587
index 466596799431f7..49fcade72790d6 100755
--- a/tests/generic/587
+++ b/tests/generic/587
@@ -56,6 +56,7 @@ _scratch_mkfs > $seqres.full
 # This test must have user quota enabled
 _qmount_option usrquota
 _qmount >> $seqres.full
+_force_vfs_quota_testing $SCRATCH_MNT
 
 testfile=$SCRATCH_MNT/test-$seq
 touch $testfile
diff --git a/tests/generic/603 b/tests/generic/603
index b199f801a8f03f..9b5e824577b382 100755
--- a/tests/generic/603
+++ b/tests/generic/603
@@ -120,6 +120,7 @@ _scratch_mkfs >$seqres.full 2>&1
 _scratch_enable_pquota
 _qmount_option "usrquota,grpquota,prjquota"
 _qmount
+_force_vfs_quota_testing $SCRATCH_MNT
 _require_prjquota $SCRATCH_DEV
 BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
 rm -rf $SCRATCH_MNT/t
diff --git a/tests/generic/691 b/tests/generic/691
index 30ae4a1e384a05..fa682fb73b0417 100755
--- a/tests/generic/691
+++ b/tests/generic/691
@@ -39,6 +39,7 @@ _scratch_mkfs >$seqres.full 2>&1
 _scratch_enable_pquota
 _qmount_option "prjquota"
 _qmount
+_force_vfs_quota_testing $SCRATCH_MNT
 _require_prjquota $SCRATCH_DEV
 
 filter_quota()
@@ -66,6 +67,7 @@ exercise()
 		_scratch_enable_pquota
 	fi
 	_qmount
+	_force_vfs_quota_testing $SCRATCH_MNT
 	if [ "$type" = "P" ];then
 		_create_project_quota $SCRATCH_MNT/t $projid $qa_user
 		file=$SCRATCH_MNT/t/testfile
diff --git a/tests/generic/710 b/tests/generic/710
index 072cddf570f444..16f7276d3d4b04 100755
--- a/tests/generic/710
+++ b/tests/generic/710
@@ -32,7 +32,9 @@ $XFS_IO_PROG -f -c 'pwrite -S 0x59 0 64k -b 64k' -c 'truncate 256k' $SCRATCH_MNT
 chown nobody $SCRATCH_MNT/b
 
 # Set up a quota limit
-$XFS_QUOTA_PROG -x -c "limit -u bhard=70k nobody" $SCRATCH_MNT
+_scratch_supports_rtquota && \
+	extra_limits="rtbhard=70k"
+$XFS_QUOTA_PROG -x -c "limit -u bhard=70k $extra_limits nobody" $SCRATCH_MNT
 
 echo before exchangerange >> $seqres.full
 $XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
diff --git a/tests/xfs/050 b/tests/xfs/050
index 1e40ab90a843e8..46c60a4bdd6b66 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -33,6 +33,7 @@ _scratch_mkfs >/dev/null 2>&1
 orig_mntopts="$MOUNT_OPTIONS"
 _qmount_option "uquota"
 _scratch_mount
+_force_vfs_quota_testing $SCRATCH_MNT   # golden output encodes block usage
 bsize=$(_get_file_block_size $SCRATCH_MNT)
 # needs quota enabled to compute the number of metadata dir files
 HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
@@ -75,6 +76,7 @@ _exercise()
 	. $tmp.mkfs
 
 	_qmount
+	_force_vfs_quota_testing $SCRATCH_MNT   # golden output encodes block usage
 
 	# Figure out whether we're doing large allocations
 	# (bail out if they're so large they stuff the test up)
diff --git a/tests/xfs/096 b/tests/xfs/096
index f1f5d562d4fa18..4c4fdfa12ef840 100755
--- a/tests/xfs/096
+++ b/tests/xfs/096
@@ -20,6 +20,10 @@ _require_scratch
 _require_xfs_quota
 _require_xfs_nocrc
 
+if [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ]; then
+	_notrun "Realtime quotas not supported on V4 filesystems"
+fi
+
 function option_string()
 {
 	VAL=$1
diff --git a/tests/xfs/106 b/tests/xfs/106
index 10cbd1052bbc89..108cd0b8c3061a 100755
--- a/tests/xfs/106
+++ b/tests/xfs/106
@@ -195,6 +195,7 @@ test_xfs_quota()
 {
 	_qmount_option $1
 	_qmount
+	_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 	if [ $type == "p" ]; then
 		_require_prjquota $SCRATCH_DEV
diff --git a/tests/xfs/108 b/tests/xfs/108
index 149d76eeb17a42..8adc63d4e56e4f 100755
--- a/tests/xfs/108
+++ b/tests/xfs/108
@@ -63,6 +63,7 @@ test_accounting()
 export MOUNT_OPTIONS="-opquota"
 _scratch_mkfs_xfs >> $seqres.full
 _qmount
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 _require_prjquota $SCRATCH_DEV
 
 rm -f $tmp.projects $seqres.full
@@ -70,6 +71,7 @@ _scratch_unmount 2>/dev/null
 _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
 cat $tmp.mkfs >>$seqres.full
 _scratch_mount
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 uid=1
 gid=2
diff --git a/tests/xfs/152 b/tests/xfs/152
index 94428b35d22a87..7ba00c4bfac9ff 100755
--- a/tests/xfs/152
+++ b/tests/xfs/152
@@ -240,6 +240,7 @@ qmount_idmapped()
 {
 	wipe_mounts
 	_try_scratch_mount || _fail "qmount failed"
+	_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 	mkdir -p "${SCRATCH_MNT}/unmapped"
 	mkdir -p "${SCRATCH_MNT}/idmapped"
diff --git a/tests/xfs/153 b/tests/xfs/153
index 2ce22b8c44b298..27db71e7738d08 100755
--- a/tests/xfs/153
+++ b/tests/xfs/153
@@ -38,6 +38,7 @@ _scratch_mkfs >/dev/null 2>&1
 orig_mntopts="$MOUNT_OPTIONS"
 _qmount_option "uquota"
 _scratch_mount
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 bsize=$(_get_file_block_size $SCRATCH_MNT)
 # needs quota enabled to compute the number of metadata dir files
 HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
@@ -80,6 +81,7 @@ run_tests()
 	. $tmp.mkfs
 
 	_qmount
+	_force_vfs_quota_testing $SCRATCH_MNT   # golden output encodes block usage
 
 	# Figure out whether we're doing large allocations
 	# (bail out if they're so large they stuff the test up)
diff --git a/tests/xfs/161 b/tests/xfs/161
index e13a646a5053bd..c35bcabb5eda90 100755
--- a/tests/xfs/161
+++ b/tests/xfs/161
@@ -36,6 +36,7 @@ _qmount_option "usrquota"
 _scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
 _scratch_mount >> $seqres.full
 
+_xfs_force_bdev data $SCRATCH_MNT
 
 min_blksz=65536
 file_blksz=$(_get_file_block_size "$SCRATCH_MNT")
diff --git a/tests/xfs/213 b/tests/xfs/213
index 7b27e3c09a815a..a9e97ee01cabce 100755
--- a/tests/xfs/213
+++ b/tests/xfs/213
@@ -28,6 +28,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT	# repquota
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/xfs/214 b/tests/xfs/214
index f2f23b3fb33f5d..c316a92baa4404 100755
--- a/tests/xfs/214
+++ b/tests/xfs/214
@@ -29,6 +29,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT	# repquota
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/xfs/220 b/tests/xfs/220
index f89c976fb850af..d34764301b9e06 100755
--- a/tests/xfs/220
+++ b/tests/xfs/220
@@ -37,6 +37,7 @@ _scratch_mkfs_xfs >/dev/null 2>&1
 
 # mount  with quotas enabled
 _scratch_mount -o uquota
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 # turn off quota
 $XFS_QUOTA_PROG -x -c off $SCRATCH_DEV
@@ -49,6 +50,7 @@ _scratch_mkfs_xfs >/dev/null 2>&1
 
 # mount  with quotas enabled
 _scratch_mount -o uquota
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 # turn off quota accounting...
 $XFS_QUOTA_PROG -x -c off $SCRATCH_DEV
diff --git a/tests/xfs/299 b/tests/xfs/299
index 3986f8fb904e5d..9f8b6631ccabfb 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -153,6 +153,7 @@ projid_file="$tmp.projid"
 echo "*** user, group, and project"
 _qmount_option "uquota,gquota,pquota"
 _qmount
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 bsize=$(_get_file_block_size $SCRATCH_MNT)
 HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
@@ -180,6 +181,7 @@ cat $tmp.mkfs >>$seqres.full
 echo "*** uqnoenforce, gqnoenforce, and pqnoenforce"
 _qmount_option "uqnoenforce,gqnoenforce,pqnoenforce"
 _qmount
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 _exercise uno
 _exercise gno
 _exercise pno
diff --git a/tests/xfs/330 b/tests/xfs/330
index 30c09ff5906e12..ca74929b1d26fc 100755
--- a/tests/xfs/330
+++ b/tests/xfs/330
@@ -36,6 +36,7 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> "$seqres.full" 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
diff --git a/tests/xfs/434 b/tests/xfs/434
index fe609b138d732b..2dec1b084e0801 100755
--- a/tests/xfs/434
+++ b/tests/xfs/434
@@ -44,6 +44,7 @@ _scratch_mount -o noquota >> "$seqres.full" 2>&1
 
 testdir="$SCRATCH_MNT/test-$seq"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 blks=3
 mkdir "$testdir"
 
diff --git a/tests/xfs/435 b/tests/xfs/435
index 22c02fbd1289bb..c1d6a40e00fc1f 100755
--- a/tests/xfs/435
+++ b/tests/xfs/435
@@ -35,6 +35,7 @@ _scratch_mount -o quota >> "$seqres.full" 2>&1
 
 testdir="$SCRATCH_MNT/test-$seq"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 blks=3
 mkdir "$testdir"
 
diff --git a/tests/xfs/440 b/tests/xfs/440
index c0b6756ba97665..8c283fd28bbf9e 100755
--- a/tests/xfs/440
+++ b/tests/xfs/440
@@ -32,6 +32,9 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount "-o usrquota,grpquota" >> "$seqres.full" 2>&1
 
+# Make sure all our files are on the data device
+_xfs_force_bdev data $SCRATCH_MNT
+
 echo "Create files"
 $XFS_IO_PROG -c "cowextsize 1m" $SCRATCH_MNT
 touch $SCRATCH_MNT/a $SCRATCH_MNT/force_fsgqa
diff --git a/tests/xfs/441 b/tests/xfs/441
index ca3c576ad9cc66..a64da1d815047b 100755
--- a/tests/xfs/441
+++ b/tests/xfs/441
@@ -31,6 +31,7 @@ check_quota() {
 echo "Format and mount (noquota)"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount "-o noquota" >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT	 # _check_quota_usage uses repquota
 
 echo "Create files"
 _pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
diff --git a/tests/xfs/442 b/tests/xfs/442
index 08f0aac40433ee..9bb055ce4d02de 100755
--- a/tests/xfs/442
+++ b/tests/xfs/442
@@ -60,6 +60,7 @@ _qmount_option "usrquota,grpquota,prjquota"
 # tests now have separate faster-running regression tests.
 _scratch_mkfs_sized $((1600 * 1048576)) > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT	 # _check_quota_usage uses repquota
 
 nr_cpus=$((LOAD_FACTOR * 4))
 nr_ops=$((25000 * TIME_FACTOR))
diff --git a/tests/xfs/508 b/tests/xfs/508
index 1bd13e98c9f641..df38dd3fbd50e4 100755
--- a/tests/xfs/508
+++ b/tests/xfs/508
@@ -57,6 +57,8 @@ _require_prjquota $SCRATCH_DEV
 mkdir $SCRATCH_MNT/dir
 $QUOTA_CMD -x -c 'project -s test' $SCRATCH_MNT >>$seqres.full 2>&1
 $QUOTA_CMD -x -c 'limit -p bsoft=10m bhard=20m test' $SCRATCH_MNT
+_scratch_supports_rtquota && \
+	$QUOTA_CMD -x -c 'limit -p rtbsoft=10m rtbhard=20m test' $SCRATCH_MNT
 
 # test the Project inheritance bit is a directory only flag, and it's set on
 # directory by default. Expect no complain about "project inheritance flag is
diff --git a/tests/xfs/511 b/tests/xfs/511
index a942e92e3af32d..0c7e137203ddb7 100755
--- a/tests/xfs/511
+++ b/tests/xfs/511
@@ -38,11 +38,19 @@ $XFS_IO_PROG -f -c "pwrite 0 65536" -c syncfs $SCRATCH_MNT/t/file >>$seqres.full
 quota_cmd="$XFS_QUOTA_PROG -x"
 $quota_cmd -c "project -s -p $SCRATCH_MNT/t 42" $SCRATCH_MNT >/dev/null 2>&1
 $quota_cmd -c 'limit -p isoft=53 bsoft=100m 42' $SCRATCH_MNT
+_scratch_supports_rtquota && \
+	$quota_cmd -c 'limit -p rtbsoft=100m 42' $SCRATCH_MNT
+
+# The golden output for this test was written with the assumption that the file
+# allocation unit divides 64k evenly, so the file block usage would be exactly
+# 64k.  On realtime filesystems this isn't always true (e.g. -rextsize=28k) so
+# we'll accept the space usage being the same as what du reports for the file.
+file_nblocks=$(du -B 1024 $SCRATCH_MNT/t/file | awk '{print $1}')
 
 # The itotal and size should be 53 and 102400(k), as above project quota limit.
 # The isued and used should be 2 and 64(k), as this case takes.
 df -k --output=file,itotal,iused,size,used $SCRATCH_MNT/t | \
-	_filter_scratch | _filter_spaces
+	_filter_scratch | _filter_spaces | sed -e "s|$file_nblocks$|64|"
 
 # success, all done
 status=0
diff --git a/tests/xfs/720 b/tests/xfs/720
index 97b3d2579cbd7f..565373bef71e88 100755
--- a/tests/xfs/720
+++ b/tests/xfs/720
@@ -30,6 +30,11 @@ _scratch_mkfs > "$seqres.full" 2>&1
 _qmount_option usrquota
 _qmount
 
+# This test tries to exceed quota limits by creating an N>2 block bmbt, setting
+# the block limit to 2N, and rebuilding the bmbt.  Hence we must force the
+# files to be created on the data device.
+_xfs_force_bdev data $SCRATCH_MNT
+
 blocksize=$(_get_block_size $SCRATCH_MNT)
 alloc_unit=$(_get_file_block_size $SCRATCH_MNT)
 

