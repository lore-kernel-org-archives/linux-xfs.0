Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8B677F91
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 09:53:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 94622304032
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 07:53:36 -0800 (PST)
Received: from mail-qc0-f174.google.com (mail-qc0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	IIdKBMNLfwXvdE3J (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jan 2014 07:53:35 -0800 (PST)
Received: by mail-qc0-f174.google.com with SMTP id x13so7290417qcv.33
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 07:53:35 -0800 (PST)
Date: Fri, 31 Jan 2014 10:53:32 -0500
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH v2] xfstests: avoid ext4/306 failures caused by incompatible
	mount options
Message-ID: <20140131155332.GB2385@wallace>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org

ext4/306 will fail when mounting the ext3 file system it creates if an
ext3-incompatible mount option is applied by _scratch_mount.  This can
happen if EXT_MOUNT_OPTIONS is defined appropriately in the test
environment.  For example, the block_validity option is commonly used
to enhance ext4 testing, and it is not supported by ext3.

Fix this by instead creating an ext4 file system without extents as a
functionally equivalent substitute.  This will also eliminate a
dependency for ext3 support on the test system.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/ext4/306 | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/tests/ext4/306 b/tests/ext4/306
index 398c4c0..9559cf2 100755
--- a/tests/ext4/306
+++ b/tests/ext4/306
@@ -45,29 +45,22 @@ _supported_os Linux
 
 _require_scratch
 
-# This needs to mount ext3; might require ext3 driver, or ext4
-# might handle it itself.  Find out if we have it one way or another.
-modprobe ext3 > /dev/null 2>&1
-grep -q ext3 /proc/filesystems || _notrun "This test requires ext3 support"
-
 rm -f $seqres.full
 
-# Make a small ext3 fs, (extents disabled) & mount it
-yes | mkfs.ext3 $SCRATCH_DEV 512m >> $seqres.full 2>&1
-_scratch_mount -t ext3 || _fail "couldn't mount fs as ext3"
+# Make a small ext4 fs with extents disabled & mount it
+yes | mkfs.ext4 -O ^extents $SCRATCH_DEV 512m >> $seqres.full 2>&1
+_scratch_mount || _fail "couldn't mount fs"
+
 # Create a small non-extent-based file
 echo "Create 1m testfile1"
 $XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 0 1m" | _filter_xfs_io
+
+# Create a large non-extent-based file filling the fs; this will run out & fail
 echo "Create testfile2 to fill the fs"
-# A large non-extent-based file filling the fs; this will run out & fail
 $XFS_IO_PROG -f $SCRATCH_MNT/testfile2 -c "pwrite 0 512m" | _filter_xfs_io
-
-# Remount as ext4
-_scratch_unmount
-_scratch_mount -t ext4 || _fail "couldn't remount fs as ext4"
 df -h $SCRATCH_MNT >> $seqres.full
 
-# Grow it by 512m
+# Grow fs by 512m
 echo "Resize to 1g"
 resize2fs $SCRATCH_DEV 1g >> $seqres.full 2>&1 || _fail "Could not resize to 1g"
 df -h $SCRATCH_MNT >> $seqres.full
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
