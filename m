Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HJBFBD254215 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 13:11:16 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0597C13B3D7A
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 11:12:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wrDdfGNZlzPsynlP for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2010 11:12:27 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1HJCQV9007324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 14:12:26 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o1HJCOtj032374
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 14:12:25 -0500
Message-ID: <4B7C3F98.50303@sandeen.net>
Date: Wed, 17 Feb 2010 13:12:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: mount xfs with a context when selinux is on
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

When selinux is on, we get tons of new xattrs, which messes
up all kinds of output.

The simplest way out of this, for now, seems to be to just mount
with a global context instead and skip writing the extra xattrs.

I've been using this internally on Fedora and RHEL for a while now.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/189 b/189
index 8f1c0e1..e91d5cd 100755
--- a/189
+++ b/189
@@ -45,7 +45,8 @@ _cleanup()
 _scratch_filter()
 {
 	sed -e "s#$SCRATCH_DEV#SCRATCH_DEV#" \
-	    -e "s#$SCRATCH_MNT#SCRATCH_MNT#"
+	    -e "s#$SCRATCH_MNT#SCRATCH_MNT#" \
+	    -e "s#,context.*s0\"##"
 }
 
 _check_mount()
diff --git a/common.rc b/common.rc
index c76bcde..ca2cd2c 100644
--- a/common.rc
+++ b/common.rc
@@ -47,8 +47,16 @@ _ls_l()
 
 _mount_opts()
 {
+    # SELinux adds extra xattrs which can mess up our expected output.
+    # So, mount with a context, and they won't be created
+    # nfs_t is a "liberal" context so we can use it.
+    if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
+	SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
+    fi
+
     case $FSTYP in
     xfs)
+	export SELINUX_MOUNT_OPTIONS
 	export MOUNT_OPTIONS=$XFS_MOUNT_OPTIONS
 	;;
     udf)
@@ -214,7 +222,7 @@ _scratch_mount_options()
 {
     _scratch_options mount
 
-    echo $SCRATCH_OPTIONS $MOUNT_OPTIONS $* $SCRATCH_DEV $SCRATCH_MNT
+    echo $SCRATCH_OPTIONS $MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS $* $SCRATCH_DEV $SCRATCH_MNT
 }
 
 _scratch_mount()
@@ -236,7 +244,7 @@ _scratch_remount()
 _test_mount()
 {
     _test_options mount
-    _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $* $TEST_DEV $TEST_DIR
+    _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS $* $TEST_DEV $TEST_DIR
 }
 
 _scratch_mkfs_options()


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
