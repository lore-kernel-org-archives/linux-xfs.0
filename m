Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1BKHS7B209348 for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 14:17:28 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C05CE15605D4
	for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 12:20:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P8AmOFnSmD2eBzDQ for
	<xfs@oss.sgi.com>; Fri, 11 Feb 2011 12:20:03 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1BKK3vM014620
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 15:20:03 -0500
Received: from segfault.boston.devel.redhat.com
	(segfault.boston.devel.redhat.com [10.16.60.26])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p1BKK270009766
	for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 15:20:02 -0500
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch][xfstests] 240: only run when the file system block size is
	larger than the disk sector size
Date: Fri, 11 Feb 2011 15:20:02 -0500
Message-ID: <x49tyga8gst.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

This test really wants to test partial file-system block I/Os.  Thus, if
the device has a 4K sector size, and the file system has a 4K block
size, there's really no point in running the test.  In the attached
patch, I check that the fs block size is larger than the device's
logical block size, which should cover a 4k device block size with a 16k
fs block size.

I verified that the patched test does not run on my 4k sector device
with a 4k file system.  I also verified that it continues to run on a
512 byte logical sector device with a 4k file system block size.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/240 b/240
index 0548536..563449e 100755
--- a/240
+++ b/240
@@ -7,6 +7,9 @@
 # QEMU IO to a file-backed device with misaligned partitions
 # can send this sort of IO
 #
+# This test need only be run in the case where the logical block size
+# of the device can be smaller than the file system block size.
+#
 #-----------------------------------------------------------------------
 # Copyright (c) 2010 Red Hat, Inc.  All Rights Reserved.
 #
@@ -57,8 +60,16 @@ rm -f $seq.full
 
 rm -f $TEST_DIR/aiodio_sparse
 
-# 2 threads, 4k writes, 16k filesize, stride throug file by 4k, start at 512 offset
-$here/src/aio-dio-regress/aiodio_sparse2 -i 2 -w 4k -s 16k -n 4k -o 512 "$TEST_DIR/aiodio_sparse"
+logical_block_size=`blockdev --getss $TEST_DEV`
+fs_block_size=`stat -f $TEST_DIR | grep "Block size:" | awk '{print $3}'`
+
+if [ $fs_block_size -le $logical_block_size ]; then
+	_notrun "fs block size must be larger than the device block size.  fs block size: $fs_block_size, device block size: $logical_block_size"
+fi
+
+# 2 threads, fs block sized writes, 64k filesize, stride through file by
+# fs block size, start at logical block size offset
+$here/src/aio-dio-regress/aiodio_sparse2 -i 2 -w $fs_block_size -s 64k -n $fs_block_size -o $logical_block_size "$TEST_DIR/aiodio_sparse"
 
 status=$?
 exit

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
