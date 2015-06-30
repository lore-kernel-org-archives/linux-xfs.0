Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C1A07F85
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 23:15:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 426BA304048
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 21:15:50 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id jgrtomexcu1WiimZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 21:15:48 -0700 (PDT)
Subject: [PATCH 03/11] generic/32[6-8]: support xfs in addition to btrfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 21:15:41 -0700
Message-ID: <20150630041541.2476.49356.stgit@birch.djwong.org>
In-Reply-To: <20150630041519.2476.23059.stgit@birch.djwong.org>
References: <20150630041519.2476.23059.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Modify the reflink tests to support xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc         |   37 +++++++++++++++++++++++++++++++++++++
 tests/generic/800 |    2 +-
 tests/generic/801 |    2 +-
 tests/generic/802 |    2 +-
 4 files changed, 40 insertions(+), 3 deletions(-)


diff --git a/common/rc b/common/rc
index 51d2fcb..8f20dc8 100644
--- a/common/rc
+++ b/common/rc
@@ -1397,6 +1397,43 @@ _require_xfs_crc()
 	umount $SCRATCH_MNT
 }
 
+# this test requires the test fs support reflink...
+#
+_require_test_reflink()
+{
+    case $FSTYP in
+    xfs)
+	xfs_info "${TEST_DIR}" | grep reflink=1 -c -q || _notrun "Reflink not supported by this filesystem type: $FSTYP"
+	;;
+    btrfs)
+        true
+        ;;
+    *)
+        _notrun "Reflink not supported by this filesystem type: $FSTYP"
+        ;;
+    esac
+}
+
+# this test requires the scratch fs support reflink...
+#
+_require_scratch_reflink()
+{
+    case $FSTYP in
+    xfs)
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+	xfs_info "${TEST_DIR}" | grep reflink=1 -c -q || _notrun "$FSTYP does not support reflink"
+	_scratch_unmount
+	;;
+    btrfs)
+        true
+        ;;
+    *)
+        _notrun "Reflink not supported by this filesystem type: $FSTYP"
+        ;;
+    esac
+}
+
 # this test requires the bigalloc feature to be available in mkfs.ext4
 #
 _require_ext4_mkfs_bigalloc()
diff --git a/tests/generic/800 b/tests/generic/800
index a71f11a..954f39d 100755
--- a/tests/generic/800
+++ b/tests/generic/800
@@ -45,7 +45,7 @@ _cleanup()
 . common/filter
 
 # real QA test starts here
-_supported_fs btrfs
+_require_test_reflink
 _supported_os Linux
 
 _require_xfs_io_command "fiemap"
diff --git a/tests/generic/801 b/tests/generic/801
index b21c44b..aedb6e9 100755
--- a/tests/generic/801
+++ b/tests/generic/801
@@ -45,7 +45,7 @@ _cleanup()
 . common/filter
 
 # real QA test starts here
-_supported_fs btrfs
+_require_test_reflink
 _supported_os Linux
 
 _require_xfs_io_command "fiemap"
diff --git a/tests/generic/802 b/tests/generic/802
index afd8513..51d3414 100755
--- a/tests/generic/802
+++ b/tests/generic/802
@@ -43,7 +43,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_supported_fs btrfs
+_require_test_reflink
 _supported_os Linux
 
 _require_xfs_io_command "fiemap"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
