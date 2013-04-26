Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14D7F7CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 15:18:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8A645AC005
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 13:18:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KcVKBJyfUn5zCpNn for
	<xfs@oss.sgi.com>; Fri, 26 Apr 2013 13:18:54 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3QKIr8I002377
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 16:18:54 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r3QKIqTv003525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 16:18:53 -0400
Message-ID: <517AE12C.2050902@redhat.com>
Date: Fri, 26 Apr 2013 15:18:52 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests shared/298: various fixes
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

fix shared/298:

* don't include common/config, not needed and breaks
  stuff when $SCRATCH_DEV_POOL is defined:
    Error: $SCRATCH_DEV should be unset when $SCRATCH_DEV_POOL is set
* make sure xfs_io has fiemap, we'll need it
* add -F to the xfs_io invocation, again
* ignore ENOSPC errors from "garbage" loop; the only goal
  is to fill it, ENOSPC doesn't matter.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Wondering if we should just add " -F" to $XFS_IO_PROG . . . 

diff --git a/tests/shared/298 b/tests/shared/298
index f1a3432..e2eddda 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -28,12 +28,12 @@ echo "QA output created by $seq"
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
-. common/config
 . common/rc
 
 _supported_fs ext4 xfs
 _supported_os Linux
 _require_fstrim
+_require_xfs_io_fiemap
 _require_fs_space $TEST_DIR 307200
 [ "$FSTYP" = "ext4" ] && _require_dumpe2fs
 
@@ -49,7 +49,7 @@ _cleanup()
 
 get_holes()
 {
-	$XFS_IO_PROG -c fiemap $1 | grep hole | $SED_PROG 's/.*\[\(.*\)\.\.\(.*\)\].*/\1 \2/'
+	$XFS_IO_PROG -F -c fiemap $1 | grep hole | $SED_PROG 's/.*\[\(.*\)\.\.\(.*\)\].*/\1 \2/'
 }
 
 get_free_sectors()
@@ -136,9 +136,10 @@ $MKFS_PROG -t $FSTYP $MKFS_OPTIONS $loop_dev &> /dev/null
 $MOUNT_PROG $loop_dev $loop_mnt
 
 echo -n "Generating garbage on loop..."
+# Goal is to fill it up, ignore any errors.
 for i in `seq 1 10`; do
-	mkdir $loop_mnt/$i
-	cp -r $here/* $loop_mnt/$i
+	mkdir $loop_mnt/$i &> /dev/null
+	cp -r $here/* $loop_mnt/$i &> /dev/null
 done
 
 # Get reference fiemap, this can contain i.e. uninitialized inode table

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
