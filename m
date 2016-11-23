Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47907 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755616AbcKWCLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 21:11:05 -0500
Subject: [PATCH 2/3] misc: fix some minor problems testing ocfs2
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 22 Nov 2016 18:11:00 -0800
Message-ID: <147986706035.27133.12508201579910106497.stgit@birch.djwong.org>
In-Reply-To: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
References: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

There are a a few things about ocfs2 tools that need special-casing in
xfstests, so fix them so that we can start testing ocfs2.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/quota |    2 +-
 common/rc    |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)


diff --git a/common/quota b/common/quota
index 678bc43..d9bb8d9 100644
--- a/common/quota
+++ b/common/quota
@@ -34,7 +34,7 @@ _require_quota()
 	    _notrun "Installed kernel does not support quotas"
 	fi
 	;;
-    gfs2)
+    gfs2|ocfs2)
 	;;
     xfs)
 	if [ ! -f /proc/fs/xfs/xqmstat ]; then
diff --git a/common/rc b/common/rc
index 8e078da..c75b614 100644
--- a/common/rc
+++ b/common/rc
@@ -978,7 +978,7 @@ _scratch_mkfs_sized()
     xfs)
 	def_blksz=`echo $MKFS_OPTIONS|sed -rn 's/.*-b ?size= ?+([0-9]+).*/\1/p'`
 	;;
-    ext2|ext3|ext4|ext4dev|udf|btrfs|reiser4)
+    ext2|ext3|ext4|ext4dev|udf|btrfs|reiser4|ocfs2)
 	def_blksz=`echo $MKFS_OPTIONS| sed -rn 's/.*-b ?+([0-9]+).*/\1/p'`
 	;;
     esac
@@ -1015,6 +1015,9 @@ _scratch_mkfs_sized()
     ext2|ext3|ext4|ext4dev)
 	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
+    ocfs2)
+	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+	;;
     udf)
 	$MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
@@ -1087,9 +1090,12 @@ _scratch_mkfs_blocksized()
     xfs)
 	_scratch_mkfs_xfs $MKFS_OPTIONS -b size=$blocksize
 	;;
-    ext2|ext3|ext4|ocfs2)
+    ext2|ext3|ext4)
 	${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
 	;;
+    ocfs2)
+	yes | ${MKFS_PROG}.$FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV
+	;;
     *)
 	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_blocksized"
 	;;

