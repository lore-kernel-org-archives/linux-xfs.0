Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E1B5829E0A
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 08:02:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D22B4304066
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 06:02:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GZXyZC1HFUjKWUdB for
	<xfs@oss.sgi.com>; Tue, 17 Dec 2013 06:02:37 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rBHE2aur018431
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 09:02:36 -0500
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/3] xfstests 322: use _filter_scratch()
Date: Tue, 17 Dec 2013 15:02:26 +0100
Message-Id: <1387288947-12650-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1387288947-12650-1-git-send-email-lczerner@redhat.com>
References: <1387288947-12650-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 tests/generic/322     | 8 ++++----
 tests/generic/322.out | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tests/generic/322 b/tests/generic/322
index 1cea133..94f8f68 100644
--- a/tests/generic/322
+++ b/tests/generic/322
@@ -65,12 +65,12 @@ _rename_test()
 	mv $SCRATCH_MNT/foo $SCRATCH_MNT/bar
 	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
 	_load_flakey_table $FLAKEY_DROP_WRITES
-	md5sum $SCRATCH_MNT/bar
+	md5sum $SCRATCH_MNT/bar | _filter_scratch
 	_unmount_flakey
 
 	_load_flakey_table $FLAKEY_ALLOW_WRITES
 	_mount_flakey
-	md5sum $SCRATCH_MNT/bar
+	md5sum $SCRATCH_MNT/bar | _filter_scratch
 	_unmount_flakey
 	_check_scratch_fs $FLAKEY_DEV
 	[ $? -ne 0 ] && _fatal "fsck failed"
@@ -87,12 +87,12 @@ _write_after_fsync_rename_test()
 	mv $SCRATCH_MNT/foo $SCRATCH_MNT/bar
 	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
 	_load_flakey_table $FLAKEY_DROP_WRITES
-	md5sum $SCRATCH_MNT/bar
+	md5sum $SCRATCH_MNT/bar | _filter_scratch
 	_unmount_flakey
 
 	_load_flakey_table $FLAKEY_ALLOW_WRITES
 	_mount_flakey
-	md5sum $SCRATCH_MNT/bar
+	md5sum $SCRATCH_MNT/bar | _filter_scratch
 	_unmount_flakey
 	_check_scratch_fs $FLAKEY_DEV
 	[ $? -ne 0 ] && _fatal "fsck failed"
diff --git a/tests/generic/322.out b/tests/generic/322.out
index 0d9f274..a23f890 100644
--- a/tests/generic/322.out
+++ b/tests/generic/322.out
@@ -1,7 +1,7 @@
 QA output created by 322
 fsync rename test
-ca539970d4b1fa1f34213ba675007381  /mnt/scratch/bar
-ca539970d4b1fa1f34213ba675007381  /mnt/scratch/bar
+ca539970d4b1fa1f34213ba675007381  SCRATCH_MNT/bar
+ca539970d4b1fa1f34213ba675007381  SCRATCH_MNT/bar
 fsync rename test
-d34ff04c17ef7068d78d0c4be49cfe57  /mnt/scratch/bar
-d34ff04c17ef7068d78d0c4be49cfe57  /mnt/scratch/bar
+d34ff04c17ef7068d78d0c4be49cfe57  SCRATCH_MNT/bar
+d34ff04c17ef7068d78d0c4be49cfe57  SCRATCH_MNT/bar
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
