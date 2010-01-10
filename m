Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0ALPPq9049564 for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 15:25:26 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9130DEF0A45
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 13:26:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uO2MbiPRRKBaSFjK for
	<xfs@oss.sgi.com>; Sun, 10 Jan 2010 13:26:19 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NU5Ih-00009x-Al
	for xfs@oss.sgi.com; Sun, 10 Jan 2010 21:26:19 +0000
Date: Sun, 10 Jan 2010 16:26:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH, RFC] xfstests: test quota log replay in 087
Message-ID: <20100110212619.GA30907@infradead.org>
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

By mounting the filesystem with quotas enabled in 087 we exercise the
replay of the quota log items in this tests, which we otherwise don't
test in xfstests.  OSS bugzilla #855 is an example of something caught
by this.

Does this look okay, or should I add a duplicate of 
087 with quotas enabled instead?


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/087
===================================================================
--- xfstests-dev.orig/087	2010-01-10 21:14:27.000000000 +0000
+++ xfstests-dev/087	2010-01-10 21:15:45.000000000 +0000
@@ -38,6 +38,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 . ./common.rc
 . ./common.filter
 . ./common.log
+. ./common.quota
 
 _do_meta()
 {
@@ -59,6 +60,7 @@ _supported_os IRIX Linux
 rm -f $seq.full $tmp.*
 _require_scratch
 _require_v2log 
+_require_xfs_quota
 
 echo "*** init FS"
 umount $SCRATCH_DEV >/dev/null 2>&1
@@ -98,7 +100,7 @@ do
 
     # mount the FS
     _echofull "mount"
-    if ! _scratch_mount >>$seq.full 2>&1; then
+    if ! _scratch_mount -o uquota >>$seq.full 2>&1; then
 	_echofull "mount failed: $MOUNT_OPTIONS"
 	continue
     fi
@@ -124,7 +126,7 @@ do
     _scratch_xfs_logprint -n >>$seq.full 2>&1
 
     _echofull "mount with replay"
-    _scratch_mount >>$seq.full 2>&1 \
+    _scratch_mount -o uquota >>$seq.full 2>&1 \
 	|| _fail "mount failed: $MOUNT_OPTIONS"
 
     # check on what FS looks like after log recovery
Index: xfstests-dev/group
===================================================================
--- xfstests-dev.orig/group	2010-01-10 21:21:18.000000000 +0000
+++ xfstests-dev/group	2010-01-10 21:21:24.000000000 +0000
@@ -193,7 +193,7 @@ prealloc
 084 ioctl rw auto
 085 log auto quick
 086 log v2log auto
-087 log v2log auto
+087 log v2log auto quota
 088 perms auto quick
 089 metadata auto
 090 rw auto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
