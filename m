Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0SNR3jS060041 for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 17:27:03 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 766EC1C87C97
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 15:28:09 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id UvQLhQ9Z5bGxhVxf for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2010 15:28:09 -0800 (PST)
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id B8AC59E7255
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 17:28:08 -0600 (CST)
Message-ID: <4B621D89.8070800@sandeen.net>
Date: Thu, 28 Jan 2010 17:28:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: routine to create scratch of certain size
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
To: xfs-oss <xfs@oss.sgi.com>

This is needed for later enospc tests to be generic

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/common.rc b/common.rc
index 97513cc..cf2662a 100644
--- a/common.rc
+++ b/common.rc
@@ -237,6 +237,27 @@ _scratch_mkfs_options()
     echo $SCRATCH_OPTIONS $MKFS_OPTIONS $* $SCRATCH_DEV
 }
 
+# arg 1 is size in bytes, arg 2 is (optional) blocksize
+_scratch_mkfs_sized()
+{
+    fssz=$1
+    bsz=$2
+    [ -z "$bsz" ] && bsz=4096
+    let blocks=$fssz/$bsz
+
+    case $FSTYP in
+    xfs)
+        _scratch_mkfs_xfs -d size=$fssz -b size=$bsz 2>&1 >>$here/$seq.full
+    ;;
+    ext2|ext3|ext4)
+        /sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS -b $bsz $SCRATCH_DEV $blocks  2>&1>>$here/$seq.full
+    ;;
+    *)
+    _notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
+    ;;
+    esac
+}
+
 _scratch_mkfs_xfs()
 {
     # extra mkfs options can be added by tests

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
