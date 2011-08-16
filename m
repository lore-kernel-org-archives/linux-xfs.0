Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7GGoYBg220836 for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 11:50:34 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 695381376C0C
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 09:52:35 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id dJsFtrLrXpjJgehg for <xfs@oss.sgi.com>;
	Tue, 16 Aug 2011 09:52:35 -0700 (PDT)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 61D288891E
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 18:50:31 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] xfstests: setup and run non-generic mkfs for btrfs
Date: Tue, 16 Aug 2011 18:50:23 +0200
Message-Id: <1313513423-7888-1-git-send-email-dsterba@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: David Sterba <dsterba@suse.cz>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 common        |    3 +++
 common.config |    1 +
 common.rc     |    5 ++++-
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/common b/common
index 817c003..0723224 100644
--- a/common
+++ b/common
@@ -306,6 +306,9 @@ case "$FSTYP" in
     udf)
 	 [ "$MKFS_UDF_PROG" = "" ] && _fatal "mkfs_udf/mkudffs not found"
 	 ;;
+    btrfs)
+	 [ "$MKFS_BTRFS_PROG" = "" ] && _fatal "mkfs.btrfs not found"
+	 ;;
     nfs)
 	 ;;
 esac
diff --git a/common.config b/common.config
index 3642139..e94624e 100644
--- a/common.config
+++ b/common.config
@@ -184,6 +184,7 @@ case "$HOSTOS" in
     Linux)
         export MKFS_XFS_PROG="`set_prog_path mkfs.xfs`"
         export MKFS_UDF_PROG="`set_prog_path mkudffs`"
+        export MKFS_BTRFS_PROG="`set_prog_path mkfs.btrfs`"
         export XFS_FSR_PROG="`set_prog_path xfs_fsr`"
         export MKFS_NFS_PROG="false"
         ;;
diff --git a/common.rc b/common.rc
index 2cbcb73..35f782b 100644
--- a/common.rc
+++ b/common.rc
@@ -310,6 +310,9 @@ _scratch_mkfs()
     udf)
         $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
 	;;
+    btrfs)
+        $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
+	;;
     *)
 	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
 	;;
@@ -333,7 +336,7 @@ _scratch_mkfs_sized()
 	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
     btrfs)
-	/sbin/mkfs.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV -b $fssize
+	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
 	;;
     *)
 	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
-- 
1.7.6.233.gd79bc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
