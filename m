Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0ENb5e3009847 for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 17:37:08 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84A5017FE996
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 15:37:04 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 3mDCk9I1CmzRY1JN for <xfs@oss.sgi.com>;
	Wed, 14 Jan 2009 15:37:04 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n0EN5QKw027070
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 18:05:26 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0EN5QBn024265
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 18:05:26 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n0EN5Pxo023517
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2009 18:05:26 -0500
Message-ID: <496E6FB4.8070300@sandeen.net>
Date: Wed, 14 Jan 2009 17:05:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: allow xfs_freeze to work on non-xfs filesystems
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

allow xfs_freeze to freeze "foreign" filesystems

Now that the freeze ioctl has been elevated to the VFS,
let's let xfs_io and xfs_freeze freeze other filesystems
as well - add the CMD_FOREIGN_OK flag to freeze & thaw.

I think the worst that will happen on older kernels is that
the command will fail with ENOSYS or EINVAL....

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/io/freeze.c b/io/freeze.c
index 334b0cf..08f4d47 100644
--- a/io/freeze.c
+++ b/io/freeze.c
@@ -66,14 +66,14 @@ freeze_init(void)
 	freeze_cmd.cfunc = freeze_f;
 	freeze_cmd.argmin = 0;
 	freeze_cmd.argmax = 0;
-	freeze_cmd.flags = CMD_NOMAP_OK;
+	freeze_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	freeze_cmd.oneline = _("freeze filesystem of current file");
 
 	thaw_cmd.name = _("thaw");
 	thaw_cmd.cfunc = thaw_f;
 	thaw_cmd.argmin = 0;
 	thaw_cmd.argmax = 0;
-	thaw_cmd.flags = CMD_NOMAP_OK;
+	thaw_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	thaw_cmd.oneline = _("unfreeze filesystem of current file");
 
 	if (expert) {
diff --git a/io/xfs_freeze.sh b/io/xfs_freeze.sh
index 0aeeae6..45e20d2 100644
--- a/io/xfs_freeze.sh
+++ b/io/xfs_freeze.sh
@@ -33,11 +33,11 @@ if [ "$1" = "" ]; then
 fi
 
 if $FREEZE ; then
-	$DIRNAME/xfs_io -r -p xfs_freeze -x -c "freeze" "$1"
+	$DIRNAME/xfs_io -F -r -p xfs_freeze -x -c "freeze" "$1"
 	status=$?
 	[ $status -ne 0 ] && exit $status
 elif $THAW ; then
-	$DIRNAME/xfs_io -r -p xfs_freeze -x -c "thaw" "$1"
+	$DIRNAME/xfs_io -F -r -p xfs_freeze -x -c "thaw" "$1"
 	status=$?
 	[ $status -ne 0 ] && exit $status
 else


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
