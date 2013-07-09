Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D35FC7F51
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 06:05:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B35D9304043
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 04:05:37 -0700 (PDT)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id EideixQWlbk4h3rG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 04:05:36 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/4] large-fs: fix ext4 defragmentation tests
Date: Tue,  9 Jul 2013 15:05:18 +0400
Message-Id: <1373367918-7516-4-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
References: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, dchinner@redhat.com

Initially work space size calculation was based on size of blkdev which
obviously wrong for large-fs case. This patch calculate work space based
on `df` cmd.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/ext4/301 |   20 +++++++++++---------
 tests/ext4/302 |   15 ++++++++-------
 tests/ext4/303 |   15 ++++++++-------
 tests/ext4/304 |   15 ++++++++-------
 4 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/tests/ext4/301 b/tests/ext4/301
index 30e4273..8c698b5 100755
--- a/tests/ext4/301
+++ b/tests/ext4/301
@@ -45,18 +45,13 @@ _require_scratch
 _require_defrag
 
 NUM_JOBS=$((4*LOAD_FACTOR))
-BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-# We need space for 2 files (test file, and donor one)
-# reserve 30% in order to avoid ENOSPC
-FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
-
 cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
 iodepth=1
 directory=${SCRATCH_MNT}
-filesize=${FILE_SIZE}
+filesize=\${FIO_FILE_SIZE}
 size=999G
 buffered=0
 fadvise_hint=0
@@ -105,11 +100,18 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
+	free_space=`df -klP /mnt_scratch | grep -v Filesystem | awk '{print $2 - $3 }'`
+	# We need space for 2 files (test file and donor)
+	# reserve 20% in order to avoid ENOSPC (1024*0.80 == 816)
+	export FIO_FILE_SIZE=$((($free_space * 816) / 2))
+	echo "FIO_FILE_SIZE=$FIO_FILE_SIZE" >> $seqres.full
 	cat $fio_config >>  $seqres.full
-	run_check $FIO_PROG $fio_config
-}
+	run_check $FIO_PROG  $fio_config 
 
-_require_fio $fio_config
+}
+# Temproraly export FIO_FILE_SIZE which is required for fio's job validation
+export FIO_FILE_SIZE=16384
+_require_fio  $fio_config
 
 _scratch_mkfs  >> $seqres.full 2>&1
 _scratch_mount
diff --git a/tests/ext4/302 b/tests/ext4/302
index 5ce007b..e525977 100755
--- a/tests/ext4/302
+++ b/tests/ext4/302
@@ -45,18 +45,13 @@ _need_to_be_root
 _require_scratch
 _require_defrag
 
-BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-# We need space for 2 files (test file, and donor one)
-# reserve 30% in order to avoid ENOSPC
-FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
-
 cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
 iodepth=1
 directory=${SCRATCH_MNT}
-filesize=${FILE_SIZE}
+filesize=\${FIO_FILE_SIZE}
 size=999G
 buffered=0
 fadvise_hint=0
@@ -121,10 +116,16 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
+	free_space=`df -klP /mnt_scratch | grep -v Filesystem | awk '{print $2 - $3 }'`
+	# We need space for 2 files (test file, and donor one)
+	# reserve 20% in order to avoid ENOSPC (1024*0.80 == 816)
+	export FIO_FILE_SIZE=$((($free_space * 816) / 2))
+	echo "FIO_FILE_SIZE=$FIO_FILE_SIZE" >> $seqres.full
 	cat $fio_config >>  $seqres.full
 	run_check $FIO_PROG $fio_config
 }
-
+# Temproraly export FIO_FILE_SIZE which is required for fio's job validation
+export FIO_FILE_SIZE=16384
 _require_fio $fio_config
 
 _scratch_mkfs  >> $seqres.full 2>&1
diff --git a/tests/ext4/303 b/tests/ext4/303
index f96264e..6fb6357 100755
--- a/tests/ext4/303
+++ b/tests/ext4/303
@@ -45,18 +45,13 @@ _need_to_be_root
 _require_scratch
 _require_defrag
 
-BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-# We need space for 3 files (one donor file and two test files)
-# Reserve space for 4 files in order to avoid ENOSPC
-FILE_SIZE=$((BLK_DEV_SIZE * (512 / (3+1))))
-
 cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
 iodepth=1
 directory=${SCRATCH_MNT}
-filesize=${FILE_SIZE}
+filesize=\${FIO_FILE_SIZE}
 size=999G
 buffered=0
 fadvise_hint=0
@@ -134,10 +129,16 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
+	free_space=`df -klP /mnt_scratch | grep -v Filesystem | awk '{print $2 - $3 }'`
+	# We need space for 3 files (test file and donor)
+	# reserve 20% in order to avoid ENOSPC (1024*0.80 == 816)
+	export FIO_FILE_SIZE=$((($free_space * 816) / 3))
+	echo "FIO_FILE_SIZE=$FIO_FILE_SIZE" >> $seqres.full
 	cat $fio_config >>  $seqres.full
 	run_check $FIO_PROG $fio_config
 }
-
+# Temproraly export FIO_FILE_SIZE which is required for fio's job validation
+export FIO_FILE_SIZE=16384
 _require_fio $fio_config
 
 _scratch_mkfs  >> $seqres.full 2>&1
diff --git a/tests/ext4/304 b/tests/ext4/304
index 5e03d4a..7cbf1dd 100755
--- a/tests/ext4/304
+++ b/tests/ext4/304
@@ -46,18 +46,13 @@ _need_to_be_root
 _require_scratch
 _require_defrag
 
-BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-# We need space for 2 files (test file, and donor one)
-# reserve 30% in order to avoid ENOSPC
-FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
-
 cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
 iodepth=1
 directory=${SCRATCH_MNT}
-filesize=${FILE_SIZE}
+filesize=\${FIO_FILE_SIZE}
 size=999G
 buffered=0
 fadvise_hint=0
@@ -108,10 +103,16 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
+	free_space=`df -klP /mnt_scratch | grep -v Filesystem | awk '{print $2 - $3 }'`
+	# We need space for test file only
+	# reserve 20% in order to avoid ENOSPC (1024*0.80 == 816)
+	export FIO_FILE_SIZE=$((($free_space * 816) / 1))
+	echo "FIO_FILE_SIZE=$FIO_FILE_SIZE" >> $seqres.full
 	cat $fio_config >>  $seqres.full
 	run_check $FIO_PROG $fio_config
 }
-
+# Temproraly export FIO_FILE_SIZE which is required for fio's job validation
+export FIO_FILE_SIZE=16384
 _require_fio $fio_config
 
 _scratch_mkfs  >> $seqres.full 2>&1
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
