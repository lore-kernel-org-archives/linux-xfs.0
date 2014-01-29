Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6F2E37F72
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 14:45:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17D1FAC005
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 12:45:07 -0800 (PST)
Received: from mail-qa0-f42.google.com (mail-qa0-f42.google.com
	[209.85.216.42]) by cuda.sgi.com with ESMTP id rUigcPeKTLFFsaCo
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 29 Jan 2014 12:45:07 -0800 (PST)
Received: by mail-qa0-f42.google.com with SMTP id k4so3263319qaq.1
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 12:45:06 -0800 (PST)
Date: Wed, 29 Jan 2014 15:45:02 -0500
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests: avoid ext4/306 failures caused by incompatible
	mount options
Message-ID: <20140129204502.GC2165@wallace>
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
to enhance ext4 testing, and it is not supported by ext3.  Fix this by
not including any mount options defined by the test environment.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 tests/ext4/306 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/ext4/306 b/tests/ext4/306
index 398c4c0..e59c8ed 100755
--- a/tests/ext4/306
+++ b/tests/ext4/306
@@ -52,9 +52,10 @@ grep -q ext3 /proc/filesystems || _notrun "This test requires ext3 support"
 
 rm -f $seqres.full
 
-# Make a small ext3 fs, (extents disabled) & mount it
+# Make a small ext3 fs, (extents disabled)
 yes | mkfs.ext3 $SCRATCH_DEV 512m >> $seqres.full 2>&1
-_scratch_mount -t ext3 || _fail "couldn't mount fs as ext3"
+# Mount it without _scratch_mount to avoid any ext3-incompatible mount options
+_mount -t ext3 $SCRATCH_DEV $SCRATCH_MNT || _fail "couldn't mount fs as ext3"
 # Create a small non-extent-based file
 echo "Create 1m testfile1"
 $XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 0 1m" | _filter_xfs_io
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
