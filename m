Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM3bop044363 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:03:37 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282206.o5SM6M4v018220@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:06:22 -0500
Subject: [PATCH 12/15] xfs: make DMAPI functions non-inline
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

Now that all of the DMAPI event generation code has been converted
to proper functions, move them out of the header file and make them
non-inline.

One exception is xfs_dmapi_event_enabled(), which would have to be
added to the set of exported symbols otherwise.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_dmapi.h |  460 +++++++----------------------------------------------
 fs/xfs/xfs_dmops.c |  408 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 472 insertions(+), 396 deletions(-)

Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -151,9 +151,6 @@ typedef enum {
  * Prototypes and functions for the Data Migration subsystem.
  */
 
-extern int	xfs_dmops_get(struct xfs_mount *);
-extern void	xfs_dmops_put(struct xfs_mount *);
-
 extern struct xfs_dmops xfs_dmcore_xfs;
 
 typedef int	(*xfs_send_data_t)(int, struct xfs_inode *,
@@ -178,8 +175,10 @@ typedef struct xfs_dmops {
 	xfs_send_unmount_t	xfs_send_unmount;
 } xfs_dmops_t;
 
-#define XFS_DMAPI_UNMOUNT_FLAGS(mp) \
-	(((mp)->m_dmevmask & (1 << DM_EVENT_UNMOUNT)) ? 0 : DM_FLAGS_UNWANTED)
+extern int	xfs_dmops_get(struct xfs_mount *);
+extern void	xfs_dmops_put(struct xfs_mount *);
+
+#ifdef XFS_DMAPI
 
 /*
  * DMAPI events only apply if DMAPI support was specified at mount
@@ -189,409 +188,78 @@ typedef struct xfs_dmops {
 static inline int
 xfs_dmapi_event_enabled(struct xfs_inode *ip, dm_eventtype_t event)
 {
-#ifdef XFS_DMAPI
     	unsigned int event_mask = 1 << event;
 
 	return ip->i_mount->m_dm_ops &&
 		(ip->i_mount->m_dmevmask & event_mask ||
 			ip->i_d.di_dmevmask & event_mask);
-#else /* ! XFS_DMAPI */
-	return 0;
-#endif /* ! XFS_DMAPI */
-}
-
-static inline int
-xfs_dmapi_send_data(
-	struct xfs_inode	*ip,
-	dm_eventtype_t		event,
-	xfs_off_t		offset,
-	size_t			length,
-	int			flags,
-	int			lock_flags)
-{
-	xfs_send_data_t send_data;
-
-	if (! xfs_dmapi_event_enabled(ip, event))
-	    	return 0;
-	send_data = ip->i_mount->m_dm_ops->xfs_send_data;
-
-	return send_data(event, ip, offset, length, flags, lock_flags);
-}
-
-static inline int
-xfs_dmapi_send_mmap(
-	struct vm_area_struct	*vma,
-	unsigned long		vm_flags)
-{
-	struct inode		*inode = vma->vm_file->f_path.dentry->d_inode;
-	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-
-	if (mp->m_dm_ops) {
-		xfs_send_mmap_t	send_mmap = mp->m_dm_ops->xfs_send_mmap;
-
-		return send_mmap(vma, vm_flags);
-	}
-	ASSERT_ALWAYS(vm_flags == VM_WRITE);
-
-	return 0;
-}
-
-static inline int
-xfs_dmapi_send_destroy(
-	struct xfs_inode	*ip,
-	dm_right_t		right)
-{
-	xfs_send_destroy_t	send_destroy;
-
-	if (!xfs_dmapi_event_enabled(ip, DM_EVENT_DESTROY))
-	    	return 0;
-	send_destroy = ip->i_mount->m_dm_ops->xfs_send_destroy;
-
-	return send_destroy(ip, right);
-}
-
-static inline int
-xfs_dmapi_send_namesp(
-	struct xfs_inode	*ip1,
-	dm_right_t		right1,
-	const char		*name1,
-	dm_eventtype_t		event,
-	struct xfs_inode	*ip2,
-	dm_right_t		right2,
-	const char		*name2,
-	mode_t			mode,
-	int			ret,
-	int			flags)
-{
-    	int			enabled;
-	xfs_send_namesp_t	send_namesp;
-
-	ASSERT(ip1 != NULL);
-	if (ip2 && ip1->i_mount != ip2->i_mount)
-		return -EINVAL;
-
-	switch (event) {
-	case DM_EVENT_PREUNMOUNT:	/* xfs_dmapi_send_preunmount() */
-	    	enabled = 1;
-		break;
-	case DM_EVENT_CREATE:
-	case DM_EVENT_POSTCREATE:
-	case DM_EVENT_REMOVE:
-	case DM_EVENT_POSTREMOVE:
-	case DM_EVENT_LINK:
-	case DM_EVENT_POSTLINK:
-	case DM_EVENT_SYMLINK:
-	case DM_EVENT_POSTSYMLINK:
-	case DM_EVENT_ATTRIBUTE:
-	case DM_EVENT_NOSPACE:
-	    	enabled = xfs_dmapi_event_enabled(ip1, event);
-		break;
-	case DM_EVENT_RENAME:
-	case DM_EVENT_POSTRENAME:
-	    	enabled = xfs_dmapi_event_enabled(ip1, event) ||
-	    			xfs_dmapi_event_enabled(ip2, event);
-		break;
-	default:
-		ASSERT(0);
-    		enabled = 0;
-		break;
-	}
-	if (!enabled)
-	    	return 0;
-
-	send_namesp = ip1->i_mount->m_dm_ops->xfs_send_namesp;
-
-	return send_namesp(event, NULL, ip1, right1, ip2, right2,
-				name1, name2, mode, ret, flags);
-}
-
-static inline int
-xfs_dmapi_send_mount(
-	struct xfs_mount	*mp,
-	char			*path)
-{
-    	if (mp->m_dm_ops) {
-		xfs_send_mount_t send_mount = mp->m_dm_ops->xfs_send_mount;
-
-		return send_mount(mp, DM_RIGHT_NULL, path, mp->m_fsname);
-	}
-
-	return ENOSYS;
-}
-
-
-static inline void
-xfs_dmapi_send_preunmount(
-	struct xfs_mount	*mp)
-{
-	if (mp->m_dm_ops)
-		(void) xfs_dmapi_send_namesp(mp->m_rootip, DM_RIGHT_NULL, NULL,
-					DM_EVENT_PREUNMOUNT,
-					mp->m_rootip, DM_RIGHT_NULL, NULL,
-					0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp));
-}
-
-static inline void
-xfs_dmapi_send_unmount(
-	struct xfs_mount	*mp)
-{
-	if (mp->m_dm_ops) {
-		xfs_send_unmount_t send_unmount =
-					mp->m_dm_ops->xfs_send_unmount;
-
-		send_unmount(mp, mp->m_rootip, DM_RIGHT_NULL,
-				0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp));
-	}
 }
 
 /* Customized event functions, based on the DMAPI interfaces */
 
-/* Mount point events */
-
-static inline int
-xfs_dmapi_event_mount(
-	struct xfs_mount	*mp,
-	char			*path)
-{
-	return xfs_dmapi_send_mount(mp, path);
-}
-
-static inline void
-xfs_dmapi_event_preunmount(
-	struct xfs_mount	*mp)
-{
-	xfs_dmapi_send_preunmount(mp);
-}
-
-static inline void
-xfs_dmapi_event_unmount(
-	struct xfs_mount	*mp)
-{
-	xfs_dmapi_send_unmount(mp);
-}
-
-/* Inode events */
-
-static inline int
-xfs_dmapi_event_create(
-	struct xfs_inode	*dip,
-	const char		*name,
-	mode_t			mode)
-{
-	return xfs_dmapi_send_namesp(dip, DM_RIGHT_NULL, name,
-					DM_EVENT_CREATE,
-					NULL, DM_RIGHT_NULL, NULL,
-					mode, 0, 0);
-}
-
-static inline void
-xfs_dmapi_event_postcreate(
-	struct xfs_inode	*dip,
-	struct xfs_inode	*ip,
-	const char		*name,
-	mode_t			mode,
-	int			retcode)
-{
-	(void) xfs_dmapi_send_namesp(dip, DM_RIGHT_NULL, name,
-					DM_EVENT_POSTCREATE,
-					ip, DM_RIGHT_NULL, NULL,
-					mode, retcode, 0);
-}
-
-static inline int
-xfs_dmapi_event_remove(
-	struct xfs_inode	*dip,
-	const char		*name,
-	mode_t			mode)
-{
-	return xfs_dmapi_send_namesp(dip, DM_RIGHT_NULL, name,
-					DM_EVENT_REMOVE,
-					NULL, DM_RIGHT_NULL, NULL,
-					mode, 0, 0);
-}
-
-static inline void
-xfs_dmapi_event_postremove(
-	struct xfs_inode	*dip,
-	const char		*name,
-	mode_t			mode,
-	int			retcode)
-{
-	(void) xfs_dmapi_send_namesp(dip, DM_RIGHT_NULL, name,
-					DM_EVENT_POSTREMOVE,
-					NULL, DM_RIGHT_NULL, NULL,
-					mode, retcode, 0);
-}
+extern int	xfs_dmapi_event_mount(struct xfs_mount *, char *);
+extern void	xfs_dmapi_event_preunmount(struct xfs_mount *);
+extern void	xfs_dmapi_event_unmount(struct xfs_mount *);
+
+extern int	xfs_dmapi_event_create(struct xfs_inode *, const char *,
+				mode_t mode);
+extern void	xfs_dmapi_event_postcreate(struct xfs_inode *,
+				struct xfs_inode *, const char *, mode_t, int);
+extern int	xfs_dmapi_event_remove(struct xfs_inode *, const char *,
+				mode_t);
+extern void	xfs_dmapi_event_postremove(struct xfs_inode *,
+				const char *, mode_t, int);
+extern int	xfs_dmapi_event_rename(struct xfs_inode *, const char *,
+				struct xfs_inode *, const char *);
+extern void 	xfs_dmapi_event_postrename(struct xfs_inode *, const
+				char *, struct xfs_inode *, const char *, int);
+extern int	xfs_dmapi_event_link(struct xfs_inode *, struct xfs_inode *,
+				const char *);
+extern void	xfs_dmapi_event_postlink(struct xfs_inode *, struct xfs_inode *,
+				const char *, int);
+extern int	xfs_dmapi_event_symlink(const char *, struct xfs_inode *,
+				const char *);
+extern void	xfs_dmapi_event_postsymlink(const char *, struct xfs_inode *,
+				struct xfs_inode *, const char *, int);
+extern int	xfs_dmapi_event_mmap(struct vm_area_struct *, unsigned long);
+extern int	xfs_dmapi_event_read(struct xfs_inode *, xfs_off_t, size_t,
+				int, int, int);
+extern int	xfs_dmapi_event_read_simple(struct xfs_inode *);
+extern int	xfs_dmapi_event_write(struct xfs_inode *, xfs_off_t, size_t,
+				int, int, int);
+extern int	xfs_dmapi_event_truncate(struct xfs_inode *, xfs_off_t, int);
+extern void	xfs_dmapi_event_attribute(struct xfs_inode *, int);
+extern void	xfs_dmapi_event_destroy(struct xfs_inode *);
+extern int	xfs_dmapi_event_nospace(struct xfs_inode *);
 
-static inline int
-xfs_dmapi_event_rename(
-	struct xfs_inode	*src_dip,
-	const char		*src_name,
-	struct xfs_inode	*tgt_dip,
-	const char		*tgt_name)
-{
-	return xfs_dmapi_send_namesp(src_dip, DM_RIGHT_NULL, src_name,
-					DM_EVENT_RENAME,
-					tgt_dip, DM_RIGHT_NULL, tgt_name,
-					0, 0, 0);
-}
-
-static inline void
-xfs_dmapi_event_postrename(
-	struct xfs_inode	*src_dip,
-	const char		*src_name,
-	struct xfs_inode	*tgt_dip,
-	const char		*tgt_name,
-	int			retcode)
-{
-	(void) xfs_dmapi_send_namesp(src_dip, DM_RIGHT_NULL, src_name,
-					DM_EVENT_POSTRENAME,
-					tgt_dip, DM_RIGHT_NULL, tgt_name,
-					0, retcode, 0);
-}
-
-static inline int
-xfs_dmapi_event_link(
-	struct xfs_inode	*src_ip,
-	struct xfs_inode	*tgt_dip,
-	const char		*tgt_name)
-{
-	return xfs_dmapi_send_namesp(tgt_dip, DM_RIGHT_NULL, tgt_name,
-					DM_EVENT_LINK,
-					src_ip, DM_RIGHT_NULL, NULL,
-					0, 0, 0);
-}
-
-static inline void
-xfs_dmapi_event_postlink(
-	struct xfs_inode	*src_ip,
-	struct xfs_inode	*tgt_dip,
-	const char		*tgt_name,
-	int			retcode)
-{
-	(void) xfs_dmapi_send_namesp(tgt_dip, DM_RIGHT_NULL, tgt_name,
-					DM_EVENT_POSTLINK,
-					src_ip, DM_RIGHT_NULL, NULL,
-					0, retcode, 0);
-}
-
-static inline int
-xfs_dmapi_event_symlink(
-	const char		*path,		/* pointed-to path */
-	struct xfs_inode	*tgt_dip,
-	const char		*tgt_name)
-{
-	return xfs_dmapi_send_namesp(tgt_dip, DM_RIGHT_NULL, tgt_name,
-					DM_EVENT_SYMLINK,
-					NULL, DM_RIGHT_NULL, path,
-					0, 0, 0);
-}
-
-static inline void
-xfs_dmapi_event_postsymlink(
-	const char		*path,		/* pointed-to path */
-	struct xfs_inode	*tgt_dip,
-	struct xfs_inode	*tgt_ip,	/* ignored if retcode != 0 */
-	const char		*tgt_name,
-	int			retcode)
-{
-	(void) xfs_dmapi_send_namesp(tgt_dip, DM_RIGHT_NULL, tgt_name,
-				DM_EVENT_POSTSYMLINK,
-				retcode ? NULL : tgt_ip, DM_RIGHT_NULL, path,
-				0, retcode, 0);
-}
-
-static inline int
-xfs_dmapi_event_mmap(
-	struct vm_area_struct	*vma,
-	unsigned long		vm_flags)
-{
-	return xfs_dmapi_send_mmap(vma, vm_flags);
-}
-
-static inline int
-xfs_dmapi_event_read(
-	struct xfs_inode	*ip,
-	xfs_off_t		offset,
-	size_t			length,
-	int			non_blocking,
-	int			direct_io,
-	int			lock_flags)
-{
-	int dmflags = non_blocking ? DM_FLAGS_NDELAY : 0;
-
-	if (direct_io)
-	   	dmflags |= DM_FLAGS_IMUX;
-
-	return xfs_dmapi_send_data(ip, DM_EVENT_READ, offset,
-					length, dmflags, lock_flags);
-}
-
-static inline int
-xfs_dmapi_event_read_simple(
-	struct xfs_inode	*ip)
-{
-	return xfs_dmapi_event_read(ip, 0, 0, 0, 0, 0);
-}
-
-static inline int
-xfs_dmapi_event_write(
-	struct xfs_inode	*ip,
-	xfs_off_t		offset,
-	size_t			length,
-	int			non_blocking,
-	int			direct_io,
-	int			lock_flags)
-{
-	int dmflags = non_blocking ? DM_FLAGS_NDELAY : 0;
-
-	if (direct_io)
-	   	dmflags |= DM_FLAGS_IMUX;
-
-	return xfs_dmapi_send_data(ip, DM_EVENT_WRITE, offset,
-					length, dmflags, lock_flags);
-}
-
-static inline int
-xfs_dmapi_event_truncate(
-	struct xfs_inode	*ip,
-	xfs_off_t		size,
-	int			non_blocking)
-{
-	int dmflags = DM_FLAGS_IALLOCSEM_WR|DM_FLAGS_IMUX;
-
-	if (non_blocking)
-		dmflags |= DM_FLAGS_NDELAY;
-
-	return xfs_dmapi_send_data(ip, DM_EVENT_TRUNCATE, size, 0, dmflags, 0);
-}
+#else /* ! XFS_DMAPI */
 
-static inline void
-xfs_dmapi_event_attribute(
-	struct xfs_inode	*ip,
-	int			delay)
-{
-	(void) xfs_dmapi_send_namesp(ip, DM_RIGHT_NULL, NULL,
-					DM_EVENT_ATTRIBUTE,
-					NULL, DM_RIGHT_NULL, NULL,
-					0, 0, delay ? DM_FLAGS_NDELAY : 0);
-}
+#define xfs_dmapi_event_enabled(i, e)				0
 
-static inline void
-xfs_dmapi_event_destroy(
-	struct xfs_inode	*ip)
-{
-	(void) xfs_dmapi_send_destroy(ip, DM_RIGHT_NULL);
-}
+#define xfs_dmapi_event_mount(mp, path)				0
+#define xfs_dmapi_event_preunmount(mp)				(void) 0
+#define xfs_dmapi_event_unmount(mp)				(void) 0
+
+#define xfs_dmapi_event_create(i, n, mode)			0
+#define xfs_dmapi_event_postcreate(dip, ip, n, mode, ret)	(void) 0
+#define xfs_dmapi_event_remove(dip, n, mode) 			0
+#define xfs_dmapi_event_postremove(dip, n, mode, ret)		(void) 0
+#define xfs_dmapi_event_rename(sdip, sn, tdip, tn)		0
+#define xfs_dmapi_event_postrename(sdip, sn, tdip, tn, ret)	(void) 0
+#define xfs_dmapi_event_link(sip, tdip, tn)			0
+#define xfs_dmapi_event_postlink(sip, tdip, tn, ret)		(void) 0
+#define xfs_dmapi_event_symlink(path, tdip, tn)			0
+#define xfs_dmapi_event_postsymlink(path, tdip, tip, tn, ret)	(void) 0
+#define xfs_dmapi_event_mmap(vma, vm_flags)			0
+#define xfs_dmapi_event_read(ip, offset, length, nb, d, lfl)	0
+#define xfs_dmapi_event_read_simple(ip)				0
+#define xfs_dmapi_event_write(ip, offset, length, nb, d, lfl)	0
+#define xfs_dmapi_event_truncate(ip, size, nb)			0
+#define xfs_dmapi_event_attribute(ip, delay)			(void) 0
+#define xfs_dmapi_event_destroy(ip)				(void) 0
+#define xfs_dmapi_event_nospace(ip) 				0
 
-static inline int
-xfs_dmapi_event_nospace(
-	struct xfs_inode	*ip)
-{
-	return xfs_dmapi_send_namesp(ip, DM_RIGHT_NULL, NULL,
-				DM_EVENT_NOSPACE,
-				ip, DM_RIGHT_NULL, NULL,
-				0, 0, 0); /* Delay flag intentionally unused */
-}
+#endif /* ! XFS_DMAPI */
 
 #endif  /* __XFS_DMAPI_H__ */
+
Index: b/fs/xfs/xfs_dmops.c
===================================================================
--- a/fs/xfs/xfs_dmops.c
+++ b/fs/xfs/xfs_dmops.c
@@ -55,8 +55,416 @@ xfs_dmops_get(struct xfs_mount *mp)
 void
 xfs_dmops_put(struct xfs_mount *mp)
 {
+#ifdef	XFS_DMAPI
 	if (mp->m_dm_ops) {
 		symbol_put(xfs_dmcore_xfs);
 		mp->m_dm_ops = NULL;
 	}
+#endif	/* XFS_DMAPI */
+	ASSERT(!mp->m_dm_ops);
 }
+
+#ifdef	XFS_DMAPI
+
+/* Private functions that encapsulate conditionally sending DMAPI messages */
+
+static inline int
+xfs_dmapi_send_data(
+	struct xfs_inode	*ip,
+	dm_eventtype_t		event,
+	xfs_off_t		offset,
+	size_t			length,
+	int			flags,
+	int			lock_flags)
+{
+	xfs_send_data_t send_data;
+
+	if (! xfs_dmapi_event_enabled(ip, event))
+	    	return 0;
+	send_data = ip->i_mount->m_dm_ops->xfs_send_data;
+
+	return send_data(event, ip, offset, length, flags, lock_flags);
+}
+
+static inline int
+xfs_dmapi_send_mmap(
+	struct vm_area_struct	*vma,
+	unsigned long		vm_flags)
+{
+	struct inode		*inode = vma->vm_file->f_path.dentry->d_inode;
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
+
+	if (mp->m_dm_ops) {
+		xfs_send_mmap_t	send_mmap = mp->m_dm_ops->xfs_send_mmap;
+
+		return send_mmap(vma, vm_flags);
+	}
+	ASSERT_ALWAYS(vm_flags == VM_WRITE);
+
+	return 0;
+}
+
+static inline int
+xfs_dmapi_send_destroy(
+	struct xfs_inode	*ip,
+	dm_right_t		right)
+{
+	xfs_send_destroy_t	send_destroy;
+
+	if (!xfs_dmapi_event_enabled(ip, DM_EVENT_DESTROY))
+	    	return 0;
+	send_destroy = ip->i_mount->m_dm_ops->xfs_send_destroy;
+
+	return send_destroy(ip, right);
+}
+
+static inline int
+xfs_dmapi_send_namesp(
+	struct xfs_inode	*ip1,
+	dm_right_t		right1,
+	const char		*name1,
+	dm_eventtype_t		event,
+	struct xfs_inode	*ip2,
+	dm_right_t		right2,
+	const char		*name2,
+	mode_t			mode,
+	int			ret,
+	int			flags)
+{
+    	int			enabled;
+	xfs_send_namesp_t	send_namesp;
+
+	ASSERT(ip1 != NULL);
+	if (ip2 && ip1->i_mount != ip2->i_mount)
+		return -EINVAL;
+
+	switch (event) {
+	case DM_EVENT_PREUNMOUNT:	/* xfs_dmapi_send_preunmount() */
+	    	enabled = 1;
+		break;
+	case DM_EVENT_CREATE:
+	case DM_EVENT_POSTCREATE:
+	case DM_EVENT_REMOVE:
+	case DM_EVENT_POSTREMOVE:
+	case DM_EVENT_LINK:
+	case DM_EVENT_POSTLINK:
+	case DM_EVENT_SYMLINK:
+	case DM_EVENT_POSTSYMLINK:
+	case DM_EVENT_ATTRIBUTE:
+	case DM_EVENT_NOSPACE:
+	    	enabled = xfs_dmapi_event_enabled(ip1, event);
+		break;
+	case DM_EVENT_RENAME:
+	case DM_EVENT_POSTRENAME:
+	    	enabled = xfs_dmapi_event_enabled(ip1, event) ||
+	    			xfs_dmapi_event_enabled(ip2, event);
+		break;
+	default:
+		ASSERT(0);
+    		enabled = 0;
+		break;
+	}
+	if (!enabled)
+	    	return 0;
+
+	send_namesp = ip1->i_mount->m_dm_ops->xfs_send_namesp;
+
+	return send_namesp(event, NULL, ip1, right1, ip2, right2,
+				name1, name2, mode, ret, flags);
+}
+
+static inline int
+xfs_dmapi_send_mount(
+	struct xfs_mount	*mp,
+	char			*path)
+{
+    	if (mp->m_dm_ops) {
+		xfs_send_mount_t send_mount = mp->m_dm_ops->xfs_send_mount;
+
+		return send_mount(mp, DM_RIGHT_NULL, path, mp->m_fsname);
+	}
+
+	return ENOSYS;
+}
+
+#define XFS_DMAPI_UNMOUNT_FLAGS(mp) \
+	(((mp)->m_dmevmask & (1 << DM_EVENT_UNMOUNT)) ? 0 : DM_FLAGS_UNWANTED)
+
+static inline void
+xfs_dmapi_send_preunmount(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_dm_ops)
+		(void) xfs_dmapi_send_namesp(mp->m_rootip, DM_RIGHT_NULL, NULL,
+					DM_EVENT_PREUNMOUNT,
+					mp->m_rootip, DM_RIGHT_NULL, NULL,
+					0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp));
+}
+
+static inline void
+xfs_dmapi_send_unmount(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_dm_ops) {
+		xfs_send_unmount_t send_unmount =
+					mp->m_dm_ops->xfs_send_unmount;
+
+		send_unmount(mp, mp->m_rootip, DM_RIGHT_NULL,
+				0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp));
+	}
+}
+
+/*
+ * Exported event functions, which translate file system events into
+ * the DMAPI messages they should send.
+ */
+
+/* Mount point events */
+
+int
+xfs_dmapi_event_mount(
+	struct xfs_mount	*mp,
+	char			*path)
+{
+	return xfs_dmapi_send_mount(mp, path);
+}
+
+void
+xfs_dmapi_event_preunmount(
+	struct xfs_mount	*mp)
+{
+	xfs_dmapi_send_preunmount(mp);
+}
+
+void
+xfs_dmapi_event_unmount(
+	struct xfs_mount	*mp)
+{
+	xfs_dmapi_send_unmount(mp);
+}
+
+/* Inode events */
+
+int
+xfs_dmapi_event_create(
+	struct xfs_inode	*dip,
+	const char		*name,
+	mode_t			mode)
+{
+	return xfs_dmapi_send_namesp(dip, DM_RIGHT_NULL, name,
+					DM_EVENT_CREATE,
+					NULL, DM_RIGHT_NULL, NULL,
+					mode, 0, 0);
+}
+
+void
+xfs_dmapi_event_postcreate(
+	struct xfs_inode	*dip,
+	struct xfs_inode	*ip,
+	const char		*name,
+	mode_t			mode,
+	int			retcode)
+{
+	(void) xfs_dmapi_send_namesp(dip, DM_RIGHT_NULL, name,
+					DM_EVENT_POSTCREATE,
+					ip, DM_RIGHT_NULL, NULL,
+					mode, retcode, 0);
+}
+
+int
+xfs_dmapi_event_remove(
+	struct xfs_inode	*dip,
+	const char		*name,
+	mode_t			mode)
+{
+	return xfs_dmapi_send_namesp(dip, DM_RIGHT_NULL, name,
+					DM_EVENT_REMOVE,
+					NULL, DM_RIGHT_NULL, NULL,
+					mode, 0, 0);
+}
+
+void
+xfs_dmapi_event_postremove(
+	struct xfs_inode	*dip,
+	const char		*name,
+	mode_t			mode,
+	int			retcode)
+{
+	(void) xfs_dmapi_send_namesp(dip, DM_RIGHT_NULL, name,
+					DM_EVENT_POSTREMOVE,
+					NULL, DM_RIGHT_NULL, NULL,
+					mode, retcode, 0);
+}
+
+int
+xfs_dmapi_event_rename(
+	struct xfs_inode	*src_dip,
+	const char		*src_name,
+	struct xfs_inode	*tgt_dip,
+	const char		*tgt_name)
+{
+	return xfs_dmapi_send_namesp(src_dip, DM_RIGHT_NULL, src_name,
+					DM_EVENT_RENAME,
+					tgt_dip, DM_RIGHT_NULL, tgt_name,
+					0, 0, 0);
+}
+
+void
+xfs_dmapi_event_postrename(
+	struct xfs_inode	*src_dip,
+	const char		*src_name,
+	struct xfs_inode	*tgt_dip,
+	const char		*tgt_name,
+	int			retcode)
+{
+	(void) xfs_dmapi_send_namesp(src_dip, DM_RIGHT_NULL, src_name,
+					DM_EVENT_POSTRENAME,
+					tgt_dip, DM_RIGHT_NULL, tgt_name,
+					0, retcode, 0);
+}
+
+int
+xfs_dmapi_event_link(
+	struct xfs_inode	*src_ip,
+	struct xfs_inode	*tgt_dip,
+	const char		*tgt_name)
+{
+	return xfs_dmapi_send_namesp(tgt_dip, DM_RIGHT_NULL, tgt_name,
+					DM_EVENT_LINK,
+					src_ip, DM_RIGHT_NULL, NULL,
+					0, 0, 0);
+}
+
+void
+xfs_dmapi_event_postlink(
+	struct xfs_inode	*src_ip,
+	struct xfs_inode	*tgt_dip,
+	const char		*tgt_name,
+	int			retcode)
+{
+	(void) xfs_dmapi_send_namesp(tgt_dip, DM_RIGHT_NULL, tgt_name,
+					DM_EVENT_POSTLINK,
+					src_ip, DM_RIGHT_NULL, NULL,
+					0, retcode, 0);
+}
+
+int
+xfs_dmapi_event_symlink(
+	const char		*path,		/* pointed-to path */
+	struct xfs_inode	*tgt_dip,
+	const char		*tgt_name)
+{
+	return xfs_dmapi_send_namesp(tgt_dip, DM_RIGHT_NULL, tgt_name,
+					DM_EVENT_SYMLINK,
+					NULL, DM_RIGHT_NULL, path,
+					0, 0, 0);
+}
+
+void
+xfs_dmapi_event_postsymlink(
+	const char		*path,		/* pointed-to path */
+	struct xfs_inode	*tgt_dip,
+	struct xfs_inode	*tgt_ip,	/* ignored if retcode != 0 */
+	const char		*tgt_name,
+	int			retcode)
+{
+	(void) xfs_dmapi_send_namesp(tgt_dip, DM_RIGHT_NULL, tgt_name,
+				DM_EVENT_POSTSYMLINK,
+				retcode ? NULL : tgt_ip, DM_RIGHT_NULL, path,
+				0, retcode, 0);
+}
+
+int
+xfs_dmapi_event_mmap(
+	struct vm_area_struct	*vma,
+	unsigned long		vm_flags)
+{
+	return xfs_dmapi_send_mmap(vma, vm_flags);
+}
+
+int
+xfs_dmapi_event_read(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	size_t			length,
+	int			non_blocking,
+	int			direct_io,
+	int			lock_flags)
+{
+	int dmflags = non_blocking ? DM_FLAGS_NDELAY : 0;
+
+	if (direct_io)
+	   	dmflags |= DM_FLAGS_IMUX;
+
+	return xfs_dmapi_send_data(ip, DM_EVENT_READ, offset,
+					length, dmflags, lock_flags);
+}
+
+int
+xfs_dmapi_event_read_simple(
+	struct xfs_inode	*ip)
+{
+	return xfs_dmapi_event_read(ip, 0, 0, 0, 0, 0);
+}
+
+int
+xfs_dmapi_event_write(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	size_t			length,
+	int			non_blocking,
+	int			direct_io,
+	int			lock_flags)
+{
+	int dmflags = non_blocking ? DM_FLAGS_NDELAY : 0;
+
+	if (direct_io)
+	   	dmflags |= DM_FLAGS_IMUX;
+
+	return xfs_dmapi_send_data(ip, DM_EVENT_WRITE, offset,
+					length, dmflags, lock_flags);
+}
+
+int
+xfs_dmapi_event_truncate(
+	struct xfs_inode	*ip,
+	xfs_off_t		size,
+	int			non_blocking)
+{
+	int dmflags = DM_FLAGS_IALLOCSEM_WR|DM_FLAGS_IMUX;
+
+	if (non_blocking)
+		dmflags |= DM_FLAGS_NDELAY;
+
+	return xfs_dmapi_send_data(ip, DM_EVENT_TRUNCATE, size, 0, dmflags, 0);
+}
+
+void
+xfs_dmapi_event_attribute(
+	struct xfs_inode	*ip,
+	int			delay)
+{
+	(void) xfs_dmapi_send_namesp(ip, DM_RIGHT_NULL, NULL,
+					DM_EVENT_ATTRIBUTE,
+					NULL, DM_RIGHT_NULL, NULL,
+					0, 0, delay ? DM_FLAGS_NDELAY : 0);
+}
+
+void
+xfs_dmapi_event_destroy(
+	struct xfs_inode	*ip)
+{
+	(void) xfs_dmapi_send_destroy(ip, DM_RIGHT_NULL);
+}
+
+int
+xfs_dmapi_event_nospace(
+	struct xfs_inode	*ip)
+{
+	return xfs_dmapi_send_namesp(ip, DM_RIGHT_NULL, NULL,
+				DM_EVENT_NOSPACE,
+				ip, DM_RIGHT_NULL, NULL,
+				0, 0, 0); /* Delay flag intentionally unused */
+}
+
+#endif	/* XFS_DMAPI */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
