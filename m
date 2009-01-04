Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n04HgtCE032384 for <xfs@oss.sgi.com>; Sun, 4 Jan 2009 11:42:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CFEE17A4B92
	for <xfs@oss.sgi.com>; Sun,  4 Jan 2009 09:42:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id elAIFpqEDkTXzB1Y for
	<xfs@oss.sgi.com>; Sun, 04 Jan 2009 09:42:54 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LJWzX-0002dY-VX
	for xfs@oss.sgi.com; Sun, 04 Jan 2009 17:42:23 +0000
Date: Sun, 4 Jan 2009 12:42:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: add test 200, exercise read-only block devices
	and mounts
Message-ID: <20090104174223.GA10050@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Make sure we do the right thing with blockdevices with a hard read-only
flag.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/200
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/200	2009-01-04 17:39:08.000000000 +0000
@@ -0,0 +1,120 @@
+#! /bin/sh
+# FS QA Test No. 200
+#
+# Check out various mount/remount/unmount scenarious on a read-only blockdev.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Christoph Hellwig.
+#-----------------------------------------------------------------------
+#
+# creator
+owner=hch@lst.de
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_filter_scratch()
+{
+	sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" | \
+		sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
+}
+
+_cleanup()
+{
+	cd /
+	blockdev --setrw $SCRATCH_DEV
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+_scratch_mkfs_xfs >/dev/null 2>&1
+
+#
+# Mark the device read-only
+#
+echo "setting device read-only"
+blockdev --setro $SCRATCH_DEV
+
+#
+# Mount it, and make sure we can't write to it, and we can unmount it again
+#
+echo "mounting read-only block device:"
+_scratch_mount 2>&1 | _filter_scratch
+
+echo "touching file on read-only filesystem (should fail)"
+touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
+
+#
+# Apparently this used to be broken at some point:
+#	http://oss.sgi.com/bugzilla/show_bug.cgi?id=807
+#
+echo "unmounting read-only filesystem"
+umount $SCRATCH_MNT 2>&1 | _filter_scratch
+
+echo "setting device read-write"
+blockdev --setrw $SCRATCH_DEV
+
+echo "mounting read-write block device:"
+_scratch_mount 2>&1 | _filter_scratch
+
+echo "touch files"
+touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
+
+echo "going down:"
+src/godown -f $SCRATCH_MNT
+
+echo "unmounting shutdown filesystem:"
+umount $SCRATCH_MNT 2>&1 | _filter_scratch
+
+echo "setting device read-only"
+blockdev --setro $SCRATCH_DEV
+
+#
+# Mounting a filesystem that requires log-recovery fails unless
+# -o norecovery is used.
+#
+echo "mounting filesystem that needs recovery on a read-only device:"
+_scratch_mount 2>&1 | _filter_scratch
+
+echo "unmounting read-only filesystem"
+umount $SCRATCH_MNT 2>&1 | _filter_scratch
+
+#
+# This is the way out if the underlying device really is read-only.
+# Doesn't mean it's a good idea in practive, more a last resort
+# data recovery hack.
+#
+echo "mounting filesystem with -o norecovery on a read-only device:"
+_scratch_mount -o norecovery 2>&1 | _filter_scratch
+
+echo "unmounting read-only filesystem"
+umount $SCRATCH_MNT 2>&1 | _filter_scratch
+
+echo "setting device read-write"
+blockdev --setrw $SCRATCH_DEV
+
+#
+# But log recovery is performed when mount with -o ro as long as
+# the underlying device is not write protected.
+#
+echo "mounting filesystem that needs recovery with -o ro:"
+_scratch_mount -o ro 2>&1 | _filter_scratch
+
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
Index: xfstests-dev/200.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/200.out	2009-01-04 17:39:38.000000000 +0000
@@ -0,0 +1,24 @@
+QA output created by 200
+setting device read-only
+mounting read-only block device:
+mount: block device SCRATCH_DEV is write-protected, mounting read-only
+touching file on read-only filesystem (should fail)
+touch: cannot touch `SCRATCH_MNT/foo': Read-only file system
+unmounting read-only filesystem
+setting device read-write
+mounting read-write block device:
+touch files
+going down:
+unmounting shutdown filesystem:
+setting device read-only
+mounting filesystem that needs recovery on a read-only device:
+mount: block device SCRATCH_DEV is write-protected, mounting read-only
+mount: cannot mount block device SCRATCH_DEV read-only
+unmounting read-only filesystem
+umount: SCRATCH_MNT: not mounted
+mounting filesystem with -o norecovery on a read-only device:
+mount: block device SCRATCH_DEV is write-protected, mounting read-only
+unmounting read-only filesystem
+setting device read-write
+mounting filesystem that needs recovery with -o ro:
+*** done
Index: xfstests-dev/group
===================================================================
--- xfstests-dev.orig/group	2009-01-04 17:14:27.000000000 +0000
+++ xfstests-dev/group	2009-01-04 17:14:36.000000000 +0000
@@ -301,3 +301,4 @@
 196 quota auto
 197 dir auto
 199 mount auto
+200 mount auto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
