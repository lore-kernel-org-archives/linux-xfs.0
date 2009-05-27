Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RIrM5E204148 for <xfs@oss.sgi.com>; Wed, 27 May 2009 13:53:22 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B86492B394B
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:36 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id QXp0brse7VNSeriJ for
	<xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:36 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 7/9] Set default extN mount options
Date: Wed, 27 May 2009 13:53:31 -0500
Message-Id: <1243450413-12681-8-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
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
Cc: Eric Sandeen <sandeen@sandeen.net>

ext2/3/4 don't support acls & attrs w/o specific mount
options, so make those the default whenever we mount
these filesystems.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 common.rc |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/common.rc b/common.rc
index 78514f4..54c36f3 100644
--- a/common.rc
+++ b/common.rc
@@ -49,6 +49,10 @@ _mount_opts()
     nfs)
 	export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
 	;;
+    ext2|ext3|ext4)
+	# acls & xattrs aren't turned on by default on ext$FOO
+	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
+	;;
     *)
 	;;
     esac
@@ -585,7 +589,7 @@ _require_scratch()
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
 		 ;;
-	nfs*|ext2|ext3|reiserfs)
+	nfs*|ext2|ext3|ext4|reiserfs)
 		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
 		 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]
 		 then
-- 
1.5.5.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
