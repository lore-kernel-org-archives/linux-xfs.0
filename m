Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 10EE97F52
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 16:28:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8520304039
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 14:28:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wYvcczIvMvluw9If for
	<xfs@oss.sgi.com>; Sun, 06 Oct 2013 14:28:02 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r96LS2uO005616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 6 Oct 2013 17:28:02 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r96LS1t1006684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 6 Oct 2013 17:28:02 -0400
Message-ID: <5251D5E1.3020202@redhat.com>
Date: Sun, 06 Oct 2013 16:28:01 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: add filter to 200 accommodate changed mount output
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

The mount binary changed its output w.r.t. red-only devices, and
stopped referring to a "block device."

This broke at least test xfs/200; add a common filter to remove
the "block device" from older mount binary output, and change
the 200.out file to match.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/filter b/common/filter
index ee738ca..066b353 100644
--- a/common/filter
+++ b/common/filter
@@ -280,5 +280,12 @@ _filter_size_to_bytes()
 	echo $((${size:0:${#size}-1}*$mul))
 }
 
+# Older mount output referred to "block device" when mounting RO devices
+# It's gone in newer versions
+_filter_ro_mount() {
+	sed -e "s/mount: block device//g" \
+	    -e "s/mount: cannot mount block device/mount: cannot mount/g"
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/xfs/200 b/tests/xfs/200
index a3b7274..f573481 100755
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -93,7 +93,7 @@ blockdev --setro $SCRATCH_DEV
 # -o norecovery is used.
 #
 echo "mounting filesystem that needs recovery on a read-only device:"
-_scratch_mount 2>&1 | _filter_scratch
+_scratch_mount 2>&1 | _filter_scratch | _filter_ro_mount
 
 echo "unmounting read-only filesystem"
 umount $SCRATCH_MNT 2>&1 | _filter_scratch
@@ -104,7 +104,7 @@ umount $SCRATCH_MNT 2>&1 | _filter_scratch
 # data recovery hack.
 #
 echo "mounting filesystem with -o norecovery on a read-only device:"
-_scratch_mount -o norecovery 2>&1 | _filter_scratch
+_scratch_mount -o norecovery 2>&1 | _filter_scratch | _filter_ro_mount
 
 echo "unmounting read-only filesystem"
 umount $SCRATCH_MNT 2>&1 | _filter_scratch
@@ -117,7 +117,7 @@ blockdev --setrw $SCRATCH_DEV
 # the underlying device is not write protected.
 #
 echo "mounting filesystem that needs recovery with -o ro:"
-_scratch_mount -o ro 2>&1 | _filter_scratch
+_scratch_mount -o ro 2>&1 | _filter_scratch 
 
 # success, all done
 echo "*** done"
diff --git a/tests/xfs/200.out b/tests/xfs/200.out
index 174838c..40f9163 100644
--- a/tests/xfs/200.out
+++ b/tests/xfs/200.out
@@ -1,7 +1,7 @@
 QA output created by 200
 setting device read-only
 mounting read-only block device:
-mount: block device SCRATCH_DEV is write-protected, mounting read-only
+mount: SCRATCH_DEV is write-protected, mounting read-only
 touching file on read-only filesystem (should fail)
 touch: cannot touch 'SCRATCH_MNT/foo': Read-only file system
 unmounting read-only filesystem
@@ -12,12 +12,12 @@ going down:
 unmounting shutdown filesystem:
 setting device read-only
 mounting filesystem that needs recovery on a read-only device:
-mount: block device SCRATCH_DEV is write-protected, mounting read-only
-mount: cannot mount block device SCRATCH_DEV read-only
+mount: SCRATCH_DEV is write-protected, mounting read-only
+mount: cannot mount SCRATCH_DEV read-only
 unmounting read-only filesystem
 umount: SCRATCH_MNT: not mounted
 mounting filesystem with -o norecovery on a read-only device:
-mount: block device SCRATCH_DEV is write-protected, mounting read-only
+mount: SCRATCH_DEV is write-protected, mounting read-only
 unmounting read-only filesystem
 setting device read-write
 mounting filesystem that needs recovery with -o ro:


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
