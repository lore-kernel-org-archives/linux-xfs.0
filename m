Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B41DA7F59
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 11:56:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A724B304059
	for <xfs@oss.sgi.com>; Mon,  2 Nov 2015 09:56:28 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id S7weeifthxfFE2PJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 Nov 2015 09:56:26 -0800 (PST)
Date: Mon, 2 Nov 2015 09:56:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't leak uuid table on rmmod
Message-ID: <20151102175619.GA2224@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Don't leak the UUID table when the module is unloaded.
(Found with kmemleak.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.c |   10 ++++++++++
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_super.c |    1 +
 3 files changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bf92e0c..fe6fe8a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -47,6 +47,16 @@ static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
 static uuid_t *xfs_uuid_table;
 
+void
+xfs_uuid_table_free(void)
+{
+	if (xfs_uuid_table_size == 0)
+		return;
+	kmem_free(xfs_uuid_table);
+	xfs_uuid_table = NULL;
+	xfs_uuid_table_size = 0;
+}
+
 /*
  * See if the UUID is unique among mounted XFS filesystems.
  * Mount fails if UUID is nil or a FS with the same UUID is already mounted.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7999e91..d6cbdcb 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -312,6 +312,7 @@ typedef struct xfs_perag {
 	int		pagb_count;	/* pagb slots in use */
 } xfs_perag_t;
 
+extern void	xfs_uuid_table_free(void);
 extern int	xfs_log_sbcount(xfs_mount_t *);
 extern __uint64_t xfs_default_resblks(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 904f637..29531ec 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1896,6 +1896,7 @@ exit_xfs_fs(void)
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
 	xfs_destroy_zones();
+	xfs_uuid_table_free();
 }
 
 module_init(init_xfs_fs);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
