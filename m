Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM3lYI044384 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:03:47 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282206.o5SM6WJ7018228@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:06:32 -0500
Subject: [PATCH 13/15] xfs: make m_dm_ops a void pointer
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

The only remaining reference to the xfs_dmops data type is in the
xfs_mount structure.  Change that pointer into a void pointer,
thereby making it possible to hide the remaining DMAPI type
definitions inside the CONFIG_XFS_DMAPI conditional.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/Makefile    |    3 +++
 fs/xfs/xfs_dmapi.h |   10 +++++-----
 fs/xfs/xfs_dmops.c |   14 ++++++++------
 fs/xfs/xfs_mount.h |    2 +-
 4 files changed, 17 insertions(+), 12 deletions(-)

Index: b/fs/xfs/Makefile
===================================================================
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -23,6 +23,9 @@ XFS_LINUX := linux-2.6
 ifeq ($(CONFIG_XFS_DEBUG),y)
 	EXTRA_CFLAGS += -g
 endif
+ifdef CONFIG_XFS_DMAPI
+	EXTRA_CFLAGS += -I$(srctree)/fs/dmapi
+endif
 
 obj-$(CONFIG_XFS_FS)		+= xfs.o
 
Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -151,6 +151,11 @@ typedef enum {
  * Prototypes and functions for the Data Migration subsystem.
  */
 
+extern int	xfs_dmops_get(struct xfs_mount *);
+extern void	xfs_dmops_put(struct xfs_mount *);
+
+#ifdef XFS_DMAPI
+
 extern struct xfs_dmops xfs_dmcore_xfs;
 
 typedef int	(*xfs_send_data_t)(int, struct xfs_inode *,
@@ -175,11 +180,6 @@ typedef struct xfs_dmops {
 	xfs_send_unmount_t	xfs_send_unmount;
 } xfs_dmops_t;
 
-extern int	xfs_dmops_get(struct xfs_mount *);
-extern void	xfs_dmops_put(struct xfs_mount *);
-
-#ifdef XFS_DMAPI
-
 /*
  * DMAPI events only apply if DMAPI support was specified at mount
  * time.  If active, a particular DMAPI event can be enabled for
Index: b/fs/xfs/xfs_dmops.c
===================================================================
--- a/fs/xfs/xfs_dmops.c
+++ b/fs/xfs/xfs_dmops.c
@@ -66,6 +66,8 @@ xfs_dmops_put(struct xfs_mount *mp)
 
 #ifdef	XFS_DMAPI
 
+#define	DM_OPS(mp)	((struct xfs_dmops *) (mp)->m_dm_ops)
+
 /* Private functions that encapsulate conditionally sending DMAPI messages */
 
 static inline int
@@ -81,7 +83,7 @@ xfs_dmapi_send_data(
 
 	if (! xfs_dmapi_event_enabled(ip, event))
 	    	return 0;
-	send_data = ip->i_mount->m_dm_ops->xfs_send_data;
+	send_data = DM_OPS(ip->i_mount)->xfs_send_data;
 
 	return send_data(event, ip, offset, length, flags, lock_flags);
 }
@@ -95,7 +97,7 @@ xfs_dmapi_send_mmap(
 	struct xfs_mount	*mp = XFS_M(inode->i_sb);
 
 	if (mp->m_dm_ops) {
-		xfs_send_mmap_t	send_mmap = mp->m_dm_ops->xfs_send_mmap;
+		xfs_send_mmap_t	send_mmap = DM_OPS(mp)->xfs_send_mmap;
 
 		return send_mmap(vma, vm_flags);
 	}
@@ -113,7 +115,7 @@ xfs_dmapi_send_destroy(
 
 	if (!xfs_dmapi_event_enabled(ip, DM_EVENT_DESTROY))
 	    	return 0;
-	send_destroy = ip->i_mount->m_dm_ops->xfs_send_destroy;
+	send_destroy = DM_OPS(ip->i_mount)->xfs_send_destroy;
 
 	return send_destroy(ip, right);
 }
@@ -167,7 +169,7 @@ xfs_dmapi_send_namesp(
 	if (!enabled)
 	    	return 0;
 
-	send_namesp = ip1->i_mount->m_dm_ops->xfs_send_namesp;
+	send_namesp = DM_OPS(ip1->i_mount)->xfs_send_namesp;
 
 	return send_namesp(event, NULL, ip1, right1, ip2, right2,
 				name1, name2, mode, ret, flags);
@@ -179,7 +181,7 @@ xfs_dmapi_send_mount(
 	char			*path)
 {
     	if (mp->m_dm_ops) {
-		xfs_send_mount_t send_mount = mp->m_dm_ops->xfs_send_mount;
+		xfs_send_mount_t send_mount = DM_OPS(mp)->xfs_send_mount;
 
 		return send_mount(mp, DM_RIGHT_NULL, path, mp->m_fsname);
 	}
@@ -207,7 +209,7 @@ xfs_dmapi_send_unmount(
 {
 	if (mp->m_dm_ops) {
 		xfs_send_unmount_t send_unmount =
-					mp->m_dm_ops->xfs_send_unmount;
+					DM_OPS(mp)->xfs_send_unmount;
 
 		send_unmount(mp, mp->m_rootip, DM_RIGHT_NULL,
 				0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp));
Index: b/fs/xfs/xfs_mount.h
===================================================================
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -182,7 +182,7 @@ typedef struct xfs_mount {
 	uint			m_chsize;	/* size of next field */
 	struct xfs_chash	*m_chash;	/* fs private inode per-cluster
 						 * hash table */
-	struct xfs_dmops	*m_dm_ops;	/* vector of DMI ops */
+	void			*m_dm_ops;	/* vector of DMI ops */
 	struct xfs_qmops	*m_qm_ops;	/* vector of XQM ops */
 	atomic_t		m_active_trans;	/* number trans frozen */
 #ifdef HAVE_PERCPU_SB

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
