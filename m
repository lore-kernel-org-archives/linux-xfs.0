Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D4F747CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 14:28:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE93630407A
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 12:28:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KaBki7jRV8KgB0wD for
	<xfs@oss.sgi.com>; Fri, 26 Apr 2013 12:28:35 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3QJSZFA031906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 15:28:35 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r3QJSYgg002277
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 15:28:35 -0400
Message-ID: <517AD562.3060208@redhat.com>
Date: Fri, 26 Apr 2013 14:28:34 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests generic/306 fixes
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
To: xfs-oss <xfs@oss.sgi.com>

older xfs_io refused to write to /dev/null because it's
not a file on an xfs filesystem.  So add -F.

While we're at it, add another testcase, symlink
on a RO device pointing to a file on a RW device.
That should pass too (and burned me as well).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/generic/306 b/tests/generic/306
index 35fb5ef..b990e38 100755
--- a/tests/generic/306
+++ b/tests/generic/306
@@ -49,6 +49,8 @@ _require_scratch
 
 DEVNULL=$SCRATCH_MNT/devnull
 DEVZERO=$SCRATCH_MNT/devzero
+SYMLINK=$SCRATCH_MNT/symlink
+TARGET=$TEST_DIR/target
 
 rm -f $seqres.full
 _scratch_mkfs > $seqres.full 2>&1
@@ -58,6 +60,8 @@ rm -f $DEVNULL $DEVZERO
 
 mknod $DEVNULL c 1 3 || _fail "Could not create devnull device"
 mknod $DEVZERO c 1 5 || _fail "Could not create devzero device"
+touch $TARGET || _fail "Could not create symlink target"
+ln -s $TARGET $SYMLINK
 
 _scratch_unmount || _fail "Could not unmount scratch device"
 _scratch_mount -o ro || _fail "Could notemount scratch readonly"
@@ -66,15 +70,18 @@ _scratch_mount -o ro || _fail "Could notemount scratch readonly"
 echo "== try to create new file"
 touch $SCRATCH_MNT/this_should_fail 2>&1 | _filter_scratch
 echo "== pwrite to null device"
-$XFS_IO_PROG -c "pwrite 0 512" /dev/null | _filter_xfs_io
+$XFS_IO_PROG -F -c "pwrite 0 512" /dev/null | _filter_xfs_io
 echo "== pread from zero device"
-$XFS_IO_PROG -c "pread 0 512" /dev/zero | _filter_xfs_io
+$XFS_IO_PROG -F -c "pread 0 512" /dev/zero | _filter_xfs_io
 
 echo "== truncating write to null device"
 echo foo > $DEVNULL 2>&1 | _filter_scratch
 echo "== appending write to null device"
 echo foo >> $DEVNULL 2>&1 | _filter_scratch
 
+echo "== writing to symlink from ro dev to rw dev"
+$XFS_IO_PROG -F -c "pwrite 0 512" $SYMLINK | _filter_xfs_io
+
 # success, all done
 status=0
 exit
diff --git a/tests/generic/306.out b/tests/generic/306.out
index 8644f38..3fd5f63 100644
--- a/tests/generic/306.out
+++ b/tests/generic/306.out
@@ -9,3 +9,6 @@ read 512/512 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 == truncating write to null device
 == appending write to null device
+== writing to symlink from ro dev to rw dev
+wrote 512/512 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
