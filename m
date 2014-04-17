Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6DADC7F53
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 05:36:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CD63AAC004
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 03:35:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rtsrkLwjLjjg7735 for
	<xfs@oss.sgi.com>; Thu, 17 Apr 2014 03:35:58 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3HAZw9Z014053
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 06:35:58 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfstests: Remove unused functions
Date: Thu, 17 Apr 2014 12:35:53 +0200
Message-Id: <1397730953-11008-1-git-send-email-lczerner@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Lukas Czerner <lczerner@redhat.com>

Functions like _mount_opts(), _mkfs_opts() and _fsck_opts() are
defined both in common/rc and common/config while used only in
common/config.

Remove those functions from common/rc and update _mount_opts() to match
the superior version of the function.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/config |  4 +++
 common/rc     | 87 -----------------------------------------------------------
 2 files changed, 4 insertions(+), 87 deletions(-)

diff --git a/common/config b/common/config
index 49f34cf..0ff9d14 100644
--- a/common/config
+++ b/common/config
@@ -249,6 +249,10 @@ _mount_opts()
 		# acls aren't turned on by default on gfs2
 		export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
 		;;
+	ttmpfs)
+		# We need to specify the size at mount, use 512 MB by default
+		export MOUNT_OPTIONS="-o size=512M $TMPFS_MOUNT_OPTIONS"
+		;;
 	*)
 		;;
 	esac
diff --git a/common/rc b/common/rc
index acf419b..c78b904 100644
--- a/common/rc
+++ b/common/rc
@@ -81,93 +81,6 @@ _ls_l()
 	ls -l $* | sed "s/\(^[-rwxdlbcpsStT]*\)\. /\1 /" | grep -v 'lost+found'
 }
 
-_mount_opts()
-{
-    # SELinux adds extra xattrs which can mess up our expected output.
-    # So, mount with a context, and they won't be created
-    # nfs_t is a "liberal" context so we can use it.
-    if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
-	SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
-	export SELINUX_MOUNT_OPTIONS
-    fi
-
-    case $FSTYP in
-    xfs)
-	export MOUNT_OPTIONS=$XFS_MOUNT_OPTIONS
-	;;
-    udf)
-	export MOUNT_OPTIONS=$UDF_MOUNT_OPTIONS
-	;;
-    nfs)
-	export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
-	;;
-    ext2|ext3|ext4|ext4dev)
-	# acls & xattrs aren't turned on by default on ext$FOO
-	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
-	;;
-    reiserfs)
-	# acls & xattrs aren't turned on by default on reiserfs
-	export MOUNT_OPTIONS="-o acl,user_xattr $REISERFS_MOUNT_OPTIONS"
-	;;
-    gfs2)
-	# acls aren't turned on by default on gfs2
-	export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
-	;;
-    tmpfs)
-	# We need to specify the size at mount, use 512 MB by default
-	export MOUNT_OPTIONS="-o size=512M $TMPFS_MOUNT_OPTIONS"
-	;;
-    *)
-	;;
-    esac
-}
-
-_mkfs_opts()
-{
-    case $FSTYP in
-    xfs)
-	export MKFS_OPTIONS=$XFS_MKFS_OPTIONS
-	;;
-    udf)
-	[ ! -z "$udf_fsize" ] && \
-	    UDF_MKFS_OPTIONS="$UDF_MKFS_OPTIONS -s $udf_fsize"
-	export MKFS_OPTIONS=$UDF_MKFS_OPTIONS
-	;;
-    nfs)
-	export MKFS_OPTIONS=$NFS_MKFS_OPTIONS
-	;;
-    reiserfs)
-	export MKFS_OPTIONS="$REISERFS_MKFS_OPTIONS -q"
-	;;
-    gfs2)
-	export MKFS_OPTIONS="$GFS2_MKFS_OPTIONS -O -p lock_nolock"
-	;;
-    jfs)
-	export MKFS_OPTIONS="$JFS_MKFS_OPTIONS -q"
-	;;
-    tmpfs)
-	export MKFS_OPTIONS="$TMPFS_MKFS_OPTIONS"
-	;;
-    *)
-	;;
-    esac
-}
-
-_fsck_opts()
-{
-    case $FSTYP in
-    ext2|ext3|ext4|ext4dev)
-	export FSCK_OPTIONS="-nf"
-	;;
-    reiserfs)
-	export FSCK_OPTIONS="--yes"
-	;;
-    *)
-	export FSCK_OPTIONS="-n"
-	;;
-    esac
-}
-
 # we need common/config
 if [ "$iam" != "check" ]
 then
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
