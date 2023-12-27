Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAE31C01;
	Mon,  1 Jan 2024 01:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jA5H16/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD91C433C8;
	Mon,  1 Jan 2024 01:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071149;
	bh=D5x0sIj9yFkc/DEcY75b3vkIb+/2I7Zqk9MQ2jQUKF4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jA5H16/RofI+WuyhJbJJG33HHEVlLlFVdX1nWTY685AtISOmURm4/5dl8yeRkmt6u
	 l0mg+yNXzF/oIK5s5tLdiPIpE3n9YwIL/lRhvDQFmXvcUypKNzQYKY5QXNqzrXguL5
	 DmGZL29ka1Po/jDzqJycYljj+uhIC0BHB6IAQj25/UFKvpY4O8KLtBz3X38WAxNbGj
	 FUgb1xxmtsIT3jZ9hgg+FxX4VuftjNPzMmIDq1Y/p9hgOxYp1NbLJmefdeSfT1JX4f
	 RZ0BkAAOMqLb2Nebie2QXIotN06Hchbey4k+dU+/5HhpLg9BXaQ7KtHBl/cwTL6Dmp
	 07oWHHoA4v6DQ==
Date: Sun, 31 Dec 2023 17:05:49 +9900
Subject: [PATCH 2/3] xfs: fix quota tests to adapt to realtime quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405033144.1827880.13287566217666431895.stgit@frogsfrogsfrogs>
In-Reply-To: <170405033118.1827880.4279631111094836504.stgit@frogsfrogsfrogs>
References: <170405033118.1827880.4279631111094836504.stgit@frogsfrogsfrogs>
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

Fix or limit the scope of tests so that we can turn on testing for
realtime quotas.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/quota      |   22 ++++++++++++++++++++++
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
 tests/xfs/106     |    1 +
 tests/xfs/108     |    2 ++
 tests/xfs/152     |    1 +
 tests/xfs/153     |    2 ++
 tests/xfs/161     |    2 ++
 tests/xfs/213     |    1 +
 tests/xfs/214     |    1 +
 tests/xfs/220     |    2 ++
 tests/xfs/299     |    2 ++
 tests/xfs/330     |    1 +
 tests/xfs/434     |    1 +
 tests/xfs/435     |    1 +
 tests/xfs/441     |    1 +
 tests/xfs/442     |    1 +
 tests/xfs/508     |    2 ++
 tests/xfs/511     |   10 +++++++++-
 tests/xfs/720     |    5 +++++
 30 files changed, 75 insertions(+), 3 deletions(-)


diff --git a/common/quota b/common/quota
index 565057d932..06179eb8c8 100644
--- a/common/quota
+++ b/common/quota
@@ -467,5 +467,27 @@ _restore_project_quota()
 	fi
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
+# Does the scratch filesystem have a realtime volume wherein quota works?
+_scratch_supports_rtquota()
+{
+	if [ "$FSTYP" = "xfs" ]; then
+		test "$USE_EXTERNAL" = yes && \
+		test -n "$SCRATCH_RTDEV" && \
+		_xfs_supports_rtquota
+	else
+		return 1
+	fi
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/219 b/tests/generic/219
index 71da25e352..a38dc7d84a 100755
--- a/tests/generic/219
+++ b/tests/generic/219
@@ -83,6 +83,7 @@ test_accounting()
 _scratch_unmount 2>/dev/null
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount "-o usrquota,grpquota"
+_force_vfs_quota_testing $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2>/dev/null
 quotaon $SCRATCH_MNT 2>/dev/null
 _scratch_unmount
diff --git a/tests/generic/230 b/tests/generic/230
index e49e0da25c..8a0aac1e7b 100755
--- a/tests/generic/230
+++ b/tests/generic/230
@@ -103,6 +103,7 @@ _qmount_option 'defaults'
 
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount "-o usrquota,grpquota"
+_force_vfs_quota_testing $SCRATCH_MNT
 BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
 quotacheck -u -g $SCRATCH_MNT 2>/dev/null
 quotaon $SCRATCH_MNT 2>/dev/null
diff --git a/tests/generic/305 b/tests/generic/305
index b46d512742..7c8f7692c1 100755
--- a/tests/generic/305
+++ b/tests/generic/305
@@ -27,6 +27,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/generic/326 b/tests/generic/326
index f5c557b3a0..b5e4100f4a 100755
--- a/tests/generic/326
+++ b/tests/generic/326
@@ -28,6 +28,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/generic/327 b/tests/generic/327
index 92540b19dd..dcdf2b3130 100755
--- a/tests/generic/327
+++ b/tests/generic/327
@@ -26,6 +26,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/generic/328 b/tests/generic/328
index db7fd3db41..26c89fff62 100755
--- a/tests/generic/328
+++ b/tests/generic/328
@@ -27,6 +27,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/generic/566 b/tests/generic/566
index 52b01f6d9e..052fabeb0e 100755
--- a/tests/generic/566
+++ b/tests/generic/566
@@ -37,7 +37,9 @@ _qmount
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
index ebfeea1d17..183ec1cad7 100755
--- a/tests/generic/587
+++ b/tests/generic/587
@@ -58,6 +58,7 @@ _scratch_mkfs > $seqres.full
 # This test must have user quota enabled
 _qmount_option usrquota
 _qmount >> $seqres.full
+_force_vfs_quota_testing $SCRATCH_MNT
 
 testfile=$SCRATCH_MNT/test-$seq
 touch $testfile
diff --git a/tests/generic/603 b/tests/generic/603
index 08ddcbf2ec..15dc2293a1 100755
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
index 6432834f9f..3d43ea5b04 100755
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
 		_create_project_quota $SCRATCH_MNT/t 100 $qa_user
 		file=$SCRATCH_MNT/t/testfile
diff --git a/tests/generic/710 b/tests/generic/710
index c7fca05d4c..2f793e03fb 100755
--- a/tests/generic/710
+++ b/tests/generic/710
@@ -33,7 +33,9 @@ $XFS_IO_PROG -f -c 'pwrite -S 0x59 0 64k -b 64k' -c 'truncate 256k' $SCRATCH_MNT
 chown nobody $SCRATCH_MNT/b
 
 # Set up a quota limit
-$XFS_QUOTA_PROG -x -c "limit -u bhard=70k nobody" $SCRATCH_MNT
+_scratch_supports_rtquota && \
+	extra_limits="rtbhard=70k"
+$XFS_QUOTA_PROG -x -c "limit -u bhard=70k $extra_limits nobody" $SCRATCH_MNT
 
 echo before swapext >> $seqres.full
 $XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
diff --git a/tests/xfs/050 b/tests/xfs/050
index 10294e3f6d..03cc534bc7 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -35,6 +35,7 @@ _scratch_mkfs >/dev/null 2>&1
 orig_mntopts="$MOUNT_OPTIONS"
 _qmount_option "uquota"
 _scratch_mount
+_force_vfs_quota_testing $SCRATCH_MNT   # golden output encodes block usage
 bsize=$(_get_file_block_size $SCRATCH_MNT)
 # needs quota enabled to compute the number of metadata dir files
 HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
@@ -77,6 +78,7 @@ _exercise()
 	. $tmp.mkfs
 
 	_qmount
+	_force_vfs_quota_testing $SCRATCH_MNT   # golden output encodes block usage
 
 	# Figure out whether we're doing large allocations
 	# (bail out if they're so large they stuff the test up)
diff --git a/tests/xfs/106 b/tests/xfs/106
index 388873bdee..9f00b3adb5 100755
--- a/tests/xfs/106
+++ b/tests/xfs/106
@@ -197,6 +197,7 @@ test_xfs_quota()
 {
 	_qmount_option $1
 	_qmount
+	_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 	if [ $type == "p" ]; then
 		_require_prjquota $SCRATCH_DEV
diff --git a/tests/xfs/108 b/tests/xfs/108
index 8593edbdd2..7f2578aa28 100755
--- a/tests/xfs/108
+++ b/tests/xfs/108
@@ -65,6 +65,7 @@ test_accounting()
 export MOUNT_OPTIONS="-opquota"
 _scratch_mkfs_xfs >> $seqres.full
 _qmount
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 _require_prjquota $SCRATCH_DEV
 
 # real QA test starts here
@@ -73,6 +74,7 @@ _scratch_unmount 2>/dev/null
 _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
 cat $tmp.mkfs >>$seqres.full
 _scratch_mount
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 uid=1
 gid=2
diff --git a/tests/xfs/152 b/tests/xfs/152
index 325a05c141..f9a0bee12f 100755
--- a/tests/xfs/152
+++ b/tests/xfs/152
@@ -242,6 +242,7 @@ qmount_idmapped()
 {
 	wipe_mounts
 	_try_scratch_mount || _fail "qmount failed"
+	_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 	mkdir -p "${SCRATCH_MNT}/unmapped"
 	mkdir -p "${SCRATCH_MNT}/idmapped"
diff --git a/tests/xfs/153 b/tests/xfs/153
index 9def579bba..304e0f11cc 100755
--- a/tests/xfs/153
+++ b/tests/xfs/153
@@ -40,6 +40,7 @@ _scratch_mkfs >/dev/null 2>&1
 orig_mntopts="$MOUNT_OPTIONS"
 _qmount_option "uquota"
 _scratch_mount
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 bsize=$(_get_file_block_size $SCRATCH_MNT)
 # needs quota enabled to compute the number of metadata dir files
 HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
@@ -82,6 +83,7 @@ run_tests()
 	. $tmp.mkfs
 
 	_qmount
+	_force_vfs_quota_testing $SCRATCH_MNT   # golden output encodes block usage
 
 	# Figure out whether we're doing large allocations
 	# (bail out if they're so large they stuff the test up)
diff --git a/tests/xfs/161 b/tests/xfs/161
index 486fa6ca0e..57cfe5b003 100755
--- a/tests/xfs/161
+++ b/tests/xfs/161
@@ -38,6 +38,8 @@ _qmount_option "usrquota"
 _scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
 _scratch_mount >> $seqres.full
 
+_xfs_force_bdev data $SCRATCH_MNT
+
 # Force the block counters for uid 1 and 2 above zero
 _pwrite_byte 0x61 0 64k $SCRATCH_MNT/a >> $seqres.full
 _pwrite_byte 0x61 0 64k $SCRATCH_MNT/b >> $seqres.full
diff --git a/tests/xfs/213 b/tests/xfs/213
index e184962452..7f3b1b4f4a 100755
--- a/tests/xfs/213
+++ b/tests/xfs/213
@@ -30,6 +30,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT	# repquota
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/xfs/214 b/tests/xfs/214
index 84ba838f3a..858ac7ea4b 100755
--- a/tests/xfs/214
+++ b/tests/xfs/214
@@ -31,6 +31,7 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT	# repquota
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 
diff --git a/tests/xfs/220 b/tests/xfs/220
index 88eedf5161..77008bf80b 100755
--- a/tests/xfs/220
+++ b/tests/xfs/220
@@ -39,6 +39,7 @@ _scratch_mkfs_xfs >/dev/null 2>&1
 
 # mount  with quotas enabled
 _scratch_mount -o uquota
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 # turn off quota
 $XFS_QUOTA_PROG -x -c off $SCRATCH_DEV
@@ -51,6 +52,7 @@ _scratch_mkfs_xfs >/dev/null 2>&1
 
 # mount  with quotas enabled
 _scratch_mount -o uquota
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 # turn off quota accounting...
 $XFS_QUOTA_PROG -x -c off $SCRATCH_DEV
diff --git a/tests/xfs/299 b/tests/xfs/299
index 49a6527255..84fb76120d 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -157,6 +157,7 @@ projid_file="$tmp.projid"
 echo "*** user, group, and project"
 _qmount_option "uquota,gquota,pquota"
 _qmount
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 
 bsize=$(_get_file_block_size $SCRATCH_MNT)
 HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
@@ -184,6 +185,7 @@ cat $tmp.mkfs >>$seqres.full
 echo "*** uqnoenforce, gqnoenforce, and pqnoenforce"
 _qmount_option "uqnoenforce,gqnoenforce,pqnoenforce"
 _qmount
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 _exercise uno
 _exercise gno
 _exercise pno
diff --git a/tests/xfs/330 b/tests/xfs/330
index 7ebbffff2a..7c18514923 100755
--- a/tests/xfs/330
+++ b/tests/xfs/330
@@ -38,6 +38,7 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> "$seqres.full" 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT	 # golden output encodes block usage
 HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
diff --git a/tests/xfs/434 b/tests/xfs/434
index 12d1a0c9da..ef7652f7f3 100755
--- a/tests/xfs/434
+++ b/tests/xfs/434
@@ -47,6 +47,7 @@ _scratch_mount -o noquota >> "$seqres.full" 2>&1
 
 testdir="$SCRATCH_MNT/test-$seq"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 blks=3
 mkdir "$testdir"
 
diff --git a/tests/xfs/435 b/tests/xfs/435
index 44135c7653..c68d7a126a 100755
--- a/tests/xfs/435
+++ b/tests/xfs/435
@@ -38,6 +38,7 @@ _scratch_mount -o quota >> "$seqres.full" 2>&1
 
 testdir="$SCRATCH_MNT/test-$seq"
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 blks=3
 mkdir "$testdir"
 
diff --git a/tests/xfs/441 b/tests/xfs/441
index 82654bf332..04682796b5 100755
--- a/tests/xfs/441
+++ b/tests/xfs/441
@@ -32,6 +32,7 @@ check_quota() {
 echo "Format and mount (noquota)"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount "-o noquota" >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT	 # _check_quota_usage uses repquota
 
 echo "Create files"
 _pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
diff --git a/tests/xfs/442 b/tests/xfs/442
index b04b1c8349..4a0608a095 100755
--- a/tests/xfs/442
+++ b/tests/xfs/442
@@ -70,6 +70,7 @@ _qmount_option "usrquota,grpquota,prjquota"
 # tests now have separate faster-running regression tests.
 _scratch_mkfs_sized $((1600 * 1048576)) > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
+_force_vfs_quota_testing $SCRATCH_MNT	 # _check_quota_usage uses repquota
 
 nr_cpus=$((LOAD_FACTOR * 4))
 nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
diff --git a/tests/xfs/508 b/tests/xfs/508
index 47c04f89de..28d5be484c 100755
--- a/tests/xfs/508
+++ b/tests/xfs/508
@@ -59,6 +59,8 @@ _require_prjquota $SCRATCH_DEV
 mkdir $SCRATCH_MNT/dir
 $QUOTA_CMD -x -c 'project -s test' $SCRATCH_MNT >>$seqres.full 2>&1
 $QUOTA_CMD -x -c 'limit -p bsoft=1m bhard=2m test' $SCRATCH_MNT
+_scratch_supports_rtquota && \
+	$QUOTA_CMD -x -c 'limit -p rtbsoft=1m rtbhard=2m test' $SCRATCH_MNT
 
 # test the Project inheritance bit is a directory only flag, and it's set on
 # directory by default. Expect no complain about "project inheritance flag is
diff --git a/tests/xfs/511 b/tests/xfs/511
index d2550404b0..ce7d40300c 100755
--- a/tests/xfs/511
+++ b/tests/xfs/511
@@ -40,11 +40,19 @@ $XFS_IO_PROG -f -c "pwrite 0 65536" -c sync $SCRATCH_MNT/t/file >>$seqres.full
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
index 3242a19b02..e36dc23948 100755
--- a/tests/xfs/720
+++ b/tests/xfs/720
@@ -32,6 +32,11 @@ _scratch_mkfs > "$seqres.full" 2>&1
 _qmount_option usrquota
 _qmount
 
+# This test tries to exceed quota limits by creating an N>2 block bmbt, setting
+# the block limit to 2N, and rebuilding the bmbt.  Hence we must force the
+# files to be created on the data device.
+_xfs_force_bdev data $SCRATCH_MNT
+
 blocksize=$(_get_block_size $SCRATCH_MNT)
 alloc_unit=$(_get_file_block_size $SCRATCH_MNT)
 

