Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B391D29DF8
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 16:18:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E9FB304059
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:54 -0800 (PST)
Received: from mail-pa0-f74.google.com (mail-pa0-f74.google.com
	[209.85.220.74]) by cuda.sgi.com with ESMTP id kO9bfAa0cAXbW4Th
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:53 -0800 (PST)
Received: by mail-pa0-f74.google.com with SMTP id fa1so595027pad.3
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 14:18:52 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH v2 01/12] xfstests: use mount point instead of device name
Date: Tue, 17 Dec 2013 14:18:31 -0800
Message-Id: <1387318722-3050-1-git-send-email-jayr@google.com>
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
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

From: Hugh Dickins <hughd@google.com>

A tmpfs mount does not involve any block device, its $SCRATCH_DEV is
nothing but a place-holder, so apply 'df' or 'stat' to its mount point
$SCRATCH_MNT instead of to $SCRATCH_DEV.

It also fixes a bug in generic/256: "stat -f $SCRATCH_DEV" returning the
block size of the root file system, but not the test file system.

$ df | grep sda
/dev/sda1    233191    62959    157791    29%    /boot

$ sudo dumpe2fs -h /dev/sda1 | grep "Block size"
Block size:               1024

$ stat -f /dev/sda1 | grep "Block size"
Block size: 4096       Fundamental block size: 4096

$ stat -f /boot | grep "Block size"
Block size: 1024       Fundamental block size: 1024

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Junho Ryu <jayr@google.com>
---

v2: same as v1

 tests/generic/256 | 2 +-
 tests/generic/273 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/256 b/tests/generic/256
index cfe7237..c6c8f2f 100755
--- a/tests/generic/256
+++ b/tests/generic/256
@@ -170,7 +170,7 @@ _scratch_mount
 # Test must be able to write files with non-root permissions
 chmod 777 $SCRATCH_MNT
 
-block_size=`stat -f $SCRATCH_DEV | grep "Block size" | cut -d " " -f3`
+block_size=`stat -f $SCRATCH_MNT | grep "Block size" | cut -d " " -f3`
 _test_full_fs_punch $(( $block_size * 2 )) $block_size 500 $SCRATCH_MNT/252.$$ $block_size
 
 status=0 ; exit
diff --git a/tests/generic/273 b/tests/generic/273
index 8e121a2..dc87a92 100755
--- a/tests/generic/273
+++ b/tests/generic/273
@@ -68,7 +68,7 @@ _file_create()
 
 	cd $SCRATCH_MNT/origin
 
-	_disksize=`$DF_PROG --block-size=1 $SCRATCH_DEV | tail -1 | awk '{ print $5 }'`
+	_disksize=`$DF_PROG --block-size=1 $SCRATCH_MNT | tail -1 | awk '{ print $5 }'`
 	_disksize=$(($_disksize / 3))
 	_num=$(($_disksize / $count / $threads / 4096))
 	_count=$count
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
