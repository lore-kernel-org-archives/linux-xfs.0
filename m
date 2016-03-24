Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 101F27CA0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 12:34:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D832C304059
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 10:34:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Kbxx4Jp4DKRcItVB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 10:34:02 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id F38727F09C
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 17:34:01 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u2OHY1EG015983
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 13:34:01 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Stop retrying to submit buffer IOs in case of umount
Date: Thu, 24 Mar 2016 18:33:56 +0100
Message-Id: <1458840836-19808-1-git-send-email-cmaiolino@redhat.com>
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

Currently xfs_buf_iodone_callbacks() keep retrying forever to submit
a buffer IO, and rely on another part of the filesystem to shutdown
it in case of an IO error.

But, if before some other work happens, the filesystem is unmounted,
it get stuck forever, retrying to submit buffer IOs, and the umount
command will stuck in D state waiting for it.

Also, no extra action from the user can be taken in this situation, since
here, we already removed the mount entry from the namespace, so, not
even xfs_io "shutdown" command can be used.

To fix this, I created a flag to notify any other filesystem task, that it
is being unmounted, so it can be used to stop retrying to submit buffer IOs
to a failed device, in case of the filesystem is being umounted.

I'm not sure if this is a good solution, or if it's more a hack, but I
do believe we need to have some solution like this, otherwise the user can
hit a lockup situation. And sending the patch might be a good start to discuss
about a solution for this.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 9 +++++++++
 fs/xfs/xfs_mount.c    | 3 +++
 fs/xfs/xfs_mount.h    | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 99e91a0..5cd9c6c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1076,6 +1076,15 @@ xfs_buf_iodone_callbacks(
 	    time_after(jiffies, (lasttime + 5*HZ))) {
 		lasttime = jiffies;
 		xfs_buf_ioerror_alert(bp, __func__);
+
+		/*
+		 * If we have a metadata error, and user tried to unmount
+		 * the filesystem, stop retrying to submit buffers forever
+		 * and shutdown the filesystem here, instead of rely in
+		 * another layer to do so.
+		 */
+		if (mp->m_flags & XFS_MOUNT_FS_UNMOUNT)
+			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
 	}
 	lasttarg = bp->b_target;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 536a0ee..5b740df 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -987,6 +987,9 @@ xfs_unmountfs(
 	__uint64_t		resblks;
 	int			error;
 
+	/* filesystem is being unmounted */
+	mp->m_flags |= XFS_MOUNT_FS_UNMOUNT;
+
 	cancel_delayed_work_sync(&mp->m_eofblocks_work);
 
 	xfs_qm_unmount_quotas(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bac6b34..562e5fc 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -191,6 +191,8 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_FILESTREAMS	(1ULL << 24)	/* enable the filestreams
 						   allocator */
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
+#define XFS_MOUNT_FS_UNMOUNT	(1ULL << 26)	/* Notify filesystem is being
+						   unmounted */
 
 #define XFS_MOUNT_DAX		(1ULL << 62)	/* TEST ONLY! */
 
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
