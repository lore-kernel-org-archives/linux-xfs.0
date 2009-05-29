Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TJRgAb085024 for <xfs@oss.sgi.com>; Fri, 29 May 2009 14:27:42 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55AE9102B4FD
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 12:34:03 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id HT3g09hC4zTVpN3n for <xfs@oss.sgi.com>;
	Fri, 29 May 2009 12:34:03 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4TJRtm4007489
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 15:27:55 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4TJRs6o011369
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 15:27:55 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4TJRs3d029024
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 15:27:54 -0400
Message-ID: <4A20373A.9070403@sandeen.net>
Date: Fri, 29 May 2009 14:27:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: reiserfs, gfs2, btrfs support
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
To: xfs mailing list <xfs@oss.sgi.com>

This patch gets reiserfs, gfs2, and btrfs off the ground.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/common.rc b/common.rc
index 54c36f3..c3e77e9 100644
--- a/common.rc
+++ b/common.rc
@@ -53,6 +53,14 @@ _mount_opts()
 	# acls & xattrs aren't turned on by default on ext$FOO
 	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
 	;;
+    reiserfs)
+	# acls & xattrs aren't turned on by default on reiserfs
+	export MOUNT_OPTIONS="-o acl,user_xattr $REISERFS_MOUNT_OPTIONS"
+	;;
+    gfs2)
+	# acls aren't turned on by default on gfs2
+	export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
+	;;
     *)
 	;;
     esac
@@ -72,6 +80,12 @@ _mkfs_opts()
     nfs)
 	export MKFS_OPTIONS=$NFS_MKFS_OPTIONS
 	;;
+    reiserfs)
+	export MKFS_OPTIONS="$REISERFS_MKFS_OPTIONS -q"
+	;;
+    gfs2)
+	export MKFS_OPTIONS="$GFS2_MKFS_OPTIONS -O -p lock_nolock"
+	;;
     *)
 	;;
     esac
@@ -589,7 +603,7 @@ _require_scratch()
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
 		 ;;
-	nfs*|ext2|ext3|ext4|reiserfs)
+	nfs*|ext2|ext3|ext4|reiserfs|gfs2|btrfs)
 		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
 		 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]
 		 then

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
