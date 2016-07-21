Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2FE717CA2
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:48:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0471B8F8037
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:48:07 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CBkYLa5HByC0ltXx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:48:06 -0700 (PDT)
Subject: [PATCH 08/17] xfs/129: fix post-metadump remounting idiocy
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:47:07 -0700
Message-ID: <146914482728.11762.13650586482755819412.stgit@birch.djwong.org>
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

Use the standard _scratch_mount to mount the filesystem from the restored
image, instead of trying to call mount directly.  This is needed in case
we had custom mount options (like rtdev).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/129 |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/129 b/tests/xfs/129
index d29f842..17ff238 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    umount $SCRATCH_MNT > /dev/null 2>&1
+    _scratch_unmount > /dev/null 2>&1
     rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/image
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
