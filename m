Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 23:19:47 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBC7JV6S031342
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 23:19:36 -0800
Message-ID: <475F8BC3.8020804@sgi.com>
Date: Wed, 12 Dec 2007 18:20:35 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] make xfs_idestroy() wait for log I/O to complete
Content-Type: multipart/mixed;
 boundary="------------030001020001050703050701"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------030001020001050703050701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

An xfs inode can be destroyed before log I/O involving that inode
is complete.  We need to wait for the inode to be unpinned before
tearing it down.  The patch looks big but the only real change is
adding a call to xfs_iunpin_wait() to the start of xfs_idestroy().
The rest of the patch is moving xfs_idestroy() after the pinning
routines.

Lachlan

--------------030001020001050703050701
Content-Type: text/x-patch;
 name="xfs_idestroy.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_idestroy.diff"

--- fs/xfs/xfs_inode.c_1.489	2007-12-12 17:14:54.000000000 +1100
+++ fs/xfs/xfs_inode.c	2007-12-12 17:15:42.000000000 +1100
@@ -2733,71 +2733,6 @@ xfs_idestroy_fork(
 }
 
 /*
- * This is called free all the memory associated with an inode.
- * It must free the inode itself and any buffers allocated for
- * if_extents/if_data and if_broot.  It must also free the lock
- * associated with the inode.
- */
-void
-xfs_idestroy(
-	xfs_inode_t	*ip)
-{
-	switch (ip->i_d.di_mode & S_IFMT) {
-	case S_IFREG:
-	case S_IFDIR:
-	case S_IFLNK:
-		xfs_idestroy_fork(ip, XFS_DATA_FORK);
-		break;
-	}
-	if (ip->i_afp)
-		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
-	mrfree(&ip->i_lock);
-	mrfree(&ip->i_iolock);
-	freesema(&ip->i_flock);
-
-#ifdef XFS_INODE_TRACE
-	ktrace_free(ip->i_trace);
-#endif
-#ifdef XFS_BMAP_TRACE
-	ktrace_free(ip->i_xtrace);
-#endif
-#ifdef XFS_BMBT_TRACE
-	ktrace_free(ip->i_btrace);
-#endif
-#ifdef XFS_RW_TRACE
-	ktrace_free(ip->i_rwtrace);
-#endif
-#ifdef XFS_ILOCK_TRACE
-	ktrace_free(ip->i_lock_trace);
-#endif
-#ifdef XFS_DIR2_TRACE
-	ktrace_free(ip->i_dir_trace);
-#endif
-	if (ip->i_itemp) {
-		/*
-		 * Only if we are shutting down the fs will we see an
-		 * inode still in the AIL. If it is there, we should remove
-		 * it to prevent a use-after-free from occurring.
-		 */
-		xfs_mount_t	*mp = ip->i_mount;
-		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
-
-		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
-				       XFS_FORCED_SHUTDOWN(ip->i_mount));
-		if (lip->li_flags & XFS_LI_IN_AIL) {
-			spin_lock(&mp->m_ail_lock);
-			if (lip->li_flags & XFS_LI_IN_AIL)
-				xfs_trans_delete_ail(mp, lip);
-			else
-				spin_unlock(&mp->m_ail_lock);
-		}
-		xfs_inode_item_destroy(ip);
-	}
-	kmem_zone_free(xfs_inode_zone, ip);
-}
-
-
-/*
  * Increment the pin count of the given buffer.
  * This value is protected by ipinlock spinlock in the mount structure.
  */
@@ -2860,6 +2795,74 @@ xfs_iunpin_wait(
 	wait_event(ip->i_ipin_wait, (atomic_read(&ip->i_pincount) == 0));
 }
 
+/*
+ * This is called free all the memory associated with an inode.
+ * It must free the inode itself and any buffers allocated for
+ * if_extents/if_data and if_broot.  It must also free the lock
+ * associated with the inode.
+ */
+void
+xfs_idestroy(
+	xfs_inode_t	*ip)
+{
+	/*
+	 * Wait for any log writes referencing this inode to complete.
+	 */
+	xfs_iunpin_wait(ip);
+
+	switch (ip->i_d.di_mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFDIR:
+	case S_IFLNK:
+		xfs_idestroy_fork(ip, XFS_DATA_FORK);
+		break;
+	}
+	if (ip->i_afp)
+		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
+	mrfree(&ip->i_lock);
+	mrfree(&ip->i_iolock);
+	freesema(&ip->i_flock);
+
+#ifdef XFS_INODE_TRACE
+	ktrace_free(ip->i_trace);
+#endif
+#ifdef XFS_BMAP_TRACE
+	ktrace_free(ip->i_xtrace);
+#endif
+#ifdef XFS_BMBT_TRACE
+	ktrace_free(ip->i_btrace);
+#endif
+#ifdef XFS_RW_TRACE
+	ktrace_free(ip->i_rwtrace);
+#endif
+#ifdef XFS_ILOCK_TRACE
+	ktrace_free(ip->i_lock_trace);
+#endif
+#ifdef XFS_DIR2_TRACE
+	ktrace_free(ip->i_dir_trace);
+#endif
+	if (ip->i_itemp) {
+		/*
+		 * Only if we are shutting down the fs will we see an
+		 * inode still in the AIL. If it is there, we should remove
+		 * it to prevent a use-after-free from occurring.
+		 */
+		xfs_mount_t	*mp = ip->i_mount;
+		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
+
+		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
+				       XFS_FORCED_SHUTDOWN(ip->i_mount));
+		if (lip->li_flags & XFS_LI_IN_AIL) {
+			spin_lock(&mp->m_ail_lock);
+			if (lip->li_flags & XFS_LI_IN_AIL)
+				xfs_trans_delete_ail(mp, lip);
+			else
+				spin_unlock(&mp->m_ail_lock);
+		}
+		xfs_inode_item_destroy(ip);
+	}
+	kmem_zone_free(xfs_inode_zone, ip);
+}
 
 /*
  * xfs_iextents_copy()

--------------030001020001050703050701--
