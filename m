Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p438eNvj007433 for <xfs@oss.sgi.com>; Tue, 3 May 2011 03:40:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59BD4157E79B
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 01:44:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id I7tDjzusF1I04kYW for
	<xfs@oss.sgi.com>; Tue, 03 May 2011 01:44:00 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QHBD5-0005e7-Pa
	for xfs@oss.sgi.com; Tue, 03 May 2011 08:43:59 +0000
Date: Tue, 3 May 2011 04:43:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] xfstests: support post-udev device mapper nodes
Message-ID: <20110503084359.GA21704@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Because of udevs complaining device mapper now creates /dev/dm-N as the real
device nodes, and just symlinks the /dev/mapper/ names to it.  This would be
easy if everything used the /dev/mapper clear names, but most system utilities
translate them back to the /dev/mapper/ names and thus confuse various test
cases.  Add support to _is_block_dev to read symlinks, and add documentation
on how to run xfstests on device mapper volumes.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/common.rc
===================================================================
--- xfstests-dev.orig/common.rc	2011-05-03 08:26:22.000000000 +0000
+++ xfstests-dev/common.rc	2011-05-03 08:28:01.000000000 +0000
@@ -587,7 +587,14 @@ _is_block_dev()
 	exit 1
     fi
 
-    [ -b $1 ] && src/lstat64 $1 | $AWK_PROG '/Device type:/ { print $9 }'
+    _dev=$1
+    if [ -L "${_dev}" ]; then
+        _dev=`readlink -f ${_dev}`
+    fi
+
+    if [ -b "${_dev}" ]; then
+        src/lstat64 ${_dev} | $AWK_PROG '/Device type:/ { print $9 }'
+    fi
 }
 
 # Do a command, log it to $seq.full, optionally test return status
Index: xfstests-dev/README.device-mapper
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/README.device-mapper	2011-05-03 08:27:00.000000000 +0000
@@ -0,0 +1,8 @@
+
+To use xfstests on device mapper always use the /dev/mapper/<name> symlinks,
+not the /dev/dm-* devices, or the symlinks created by LVM.
+
+For example:
+
+TEST_DEV=/dev/mapper/test
+SCRATCH_DEV=/dev/mapper/scratch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
