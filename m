Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o61JtMNY208660 for <xfs@oss.sgi.com>; Thu, 1 Jul 2010 14:55:22 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D5E11E1CA07
	for <xfs@oss.sgi.com>; Thu,  1 Jul 2010 12:58:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FdRBiMTpkRXsnPMQ for
	<xfs@oss.sgi.com>; Thu, 01 Jul 2010 12:58:09 -0700 (PDT)
Received: from int-mx03.intmail.prod.int.phx2.redhat.com
	(int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o61Jw8VJ009728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 1 Jul 2010 15:58:08 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o61Jw8H9023383
	for <xfs@oss.sgi.com>; Thu, 1 Jul 2010 15:58:08 -0400
Message-ID: <4C2CF34F.7070008@redhat.com>
Date: Thu, 01 Jul 2010 14:58:07 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH xfstests] _qmount: mount w/o selinux xattrs
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

when selinux is on it can change quota usage due to extra
xattr blocks.

Mounting with a context prevents this.  We already do so
for xfs in general because so many things look at detailed
on-disk format, and extra xattrs confuses those tests.

For other filesystems, we've left selinux alone so far, 
as that seemed the best way to test.

However, it throws quota accounting off, so add a fixup
in _qmount()

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common.quota b/common.quota
index d32e285..87a766c 100644
--- a/common.quota
+++ b/common.quota
@@ -131,8 +131,17 @@ _choose_prid()
 
 _qmount()
 {
+    # SELinux adds extra xattrs which can mess up our expected usage.
+    # So, mount with a context, and they won't be created
+    # nfs_t is a "liberal" context so we can use it.
+    # Only set it if we didn't inherit SELINUX_MOUNT_OPTIONS for
+    # all mounts anyway.
+    if [ -z "$SELINUX_MOUNT_OPTIONS" -a -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
+        QUOTA_SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
+    fi
+
     umount $SCRATCH_DEV >/dev/null 2>&1
-    _scratch_mount || _fail "qmount failed"
+    _scratch_mount $QUOTA_SELINUX_MOUNT_OPTIONS || _fail "qmount failed"
     chmod ugo+rwx $SCRATCH_MNT
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
