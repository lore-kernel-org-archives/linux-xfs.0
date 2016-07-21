Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A38B67CA1
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:47:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28411AC006
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:47:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 3ghu5SABDMwjUYgP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:47:30 -0700 (PDT)
Subject: [PATCH 11/17] xfs/234: use scratch device helpers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:47:26 -0700
Message-ID: <146914484608.11762.11733588115406137276.stgit@birch.djwong.org>
In-Reply-To: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Use the helper functions for scratch devices.  This fixes a problem
where xfs/234 fails when there's a realtime device.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/234 |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/234 b/tests/xfs/234
index 2bbf295..8dadc34 100755
--- a/tests/xfs/234
+++ b/tests/xfs/234
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    umount $SCRATCH_MNT > /dev/null 2>&1
+    _scratch_unmount > /dev/null 2>&1
     rm -rf $tmp.* $metadump_file $TEST_DIR/image
 }
 
@@ -76,8 +76,8 @@ _scratch_metadump $metadump_file
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
 xfs_mdrestore $metadump_file $TEST_DIR/image
-_mount -t $FSTYP $TEST_DIR/image $SCRATCH_MNT
-umount $SCRATCH_MNT
+SCRATCH_DEV=$TEST_DIR/image _scratch_mount
+SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
 
 echo "Check restored fs"
 _check_generic_filesystem $metadump_file

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
