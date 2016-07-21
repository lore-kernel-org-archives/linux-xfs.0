Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C01E07CB1
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:48:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47FDBAC004
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:48:01 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id EiG2TnVBBTflNU3r (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:47:59 -0700 (PDT)
Subject: [PATCH 15/17] xfs: scrub fs (if still mounted) at the end of the test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:47:51 -0700
Message-ID: <146914487167.11762.17599617419019795848.stgit@birch.djwong.org>
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

Teach _check_xfs_filesystem to scrub mounted filesystems before
unmounting and fscking them.  This is mostly to test the online
scrub tool...

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 README        |    3 +++
 common/config |    1 +
 common/rc     |    7 +++++++
 3 files changed, 11 insertions(+)


diff --git a/README b/README
index 4509cc1..c19fcb1 100644
--- a/README
+++ b/README
@@ -84,6 +84,9 @@ Preparing system for tests (IRIX and Linux):
                run xfs_repair -n to check the filesystem; xfs_repair to rebuild
                metadata indexes; and xfs_repair -n (a third time) to check the
                results of the rebuilding.
+	     - set TEST_XFS_SCRUB=1 to have _check_xfs_filesystem run
+	       xfs_scrub -vd to scrub the filesystem metadata online before
+               unmounting to run the offline check.
 
         - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
diff --git a/common/config b/common/config
index 08d5d80..168f46c 100644
--- a/common/config
+++ b/common/config
@@ -163,6 +163,7 @@ export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
 export XFS_DB_PROG="`set_prog_path xfs_db`"
 export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
 export XFS_IO_PROG="`set_prog_path xfs_io`"
+export XFS_SCRUB_PROG="`set_prog_path xfs_scrub`"
 export XFS_PARALLEL_REPAIR_PROG="`set_prog_path xfs_prepair`"
 export XFS_PARALLEL_REPAIR64_PROG="`set_prog_path xfs_prepair64`"
 export __XFSDUMP_PROG="`set_prog_path xfsdump`"
diff --git a/common/rc b/common/rc
index 3b45578..861a721 100644
--- a/common/rc
+++ b/common/rc
@@ -2391,6 +2391,13 @@ _check_xfs_filesystem()
 
     if [ "$type" = "xfs" ]
     then
+        if [ -n "$TEST_XFS_SCRUB" ] && [ -x "$XFS_SCRUB_PROG" ]; then
+            "$XFS_SCRUB_PROG" $scrubflag -vd $device >>$seqres.full
+            if [ $? -ne 0 ]; then
+                echo "filesystem on $device failed scrub (see $seqres.full)"
+                ok=0
+            fi
+        fi
         # mounted ...
         mountpoint=`_umount_or_remount_ro $device`
     fi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
