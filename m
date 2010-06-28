Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM3R0X044342 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:03:27 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282206.o5SM6CDs018212@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:06:12 -0500
Subject: [PATCH 11/15] xfs: create DMAPI event functions
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

Create customized functions that implement making the DMAPI event
calls, one for each event type needed.  These functions will only
take the arguments that are required, and will hide the details
of passing various constant values to the "standard" XFS DMAPI
interfaces.

Also kill off two macros, FILP_DELAY_FLAG() and AT_DELAY_FLAG(),
which are only used in a few places and which can easily be
expanded in-line.

In the read, write, and truncate event cases, arrange for the
interface to allow the caller to specify the conditions that
would require particular DMAPI flags to be used, rather than
specifying the DMAPI flags themselves.

Signed-off-by Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_file.c  |   40 ++----
 fs/xfs/linux-2.6/xfs_ioctl.c |    5 
 fs/xfs/linux-2.6/xfs_super.c |    6 
 fs/xfs/xfs_bmap.c            |    3 
 fs/xfs/xfs_dmapi.h           |  259 +++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_rename.c          |   12 -
 fs/xfs/xfs_vnodeops.c        |   76 +++---------
 7 files changed, 296 insertions(+), 105 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -276,12 +276,9 @@ xfs_file_aio_read(
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
 	if (!(ioflags & IO_INVIS)) {
-		int dmflags = FILP_DELAY_FLAG(file);
-
-		if (ioflags & IO_ISDIRECT)
-		    	dmflags |= DM_FLAGS_IMUX;
-		ret = -xfs_dmapi_send_data(ip, DM_EVENT_READ, iocb->ki_pos,
-					size, dmflags, XFS_IOLOCK_SHARED);
+		ret = -xfs_dmapi_event_read(ip, iocb->ki_pos, size,
+				file->f_flags & (O_NDELAY|O_NONBLOCK),
+				ioflags & IO_ISDIRECT, XFS_IOLOCK_SHARED);
 		if (ret) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 			if (unlikely(ioflags & IO_ISDIRECT))
@@ -322,7 +319,6 @@ xfs_file_splice_read(
 	unsigned int		flags)
 {
 	struct xfs_inode	*ip = XFS_I(infilp->f_mapping->host);
-	struct xfs_mount	*mp = ip->i_mount;
 	int			ioflags = 0;
 	ssize_t			ret;
 
@@ -339,9 +335,9 @@ xfs_file_splice_read(
 	if (!(ioflags & IO_INVIS)) {
 		int error;
 
-		error = xfs_dmapi_send_data(ip, DM_EVENT_READ, *ppos,
-					count, FILP_DELAY_FLAG(infilp),
-					XFS_IOLOCK_SHARED);
+		error = xfs_dmapi_event_read(ip, *ppos, count,
+				infilp->f_flags & (O_NDELAY|O_NONBLOCK),
+				0, XFS_IOLOCK_SHARED);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 			return -error;
@@ -368,7 +364,6 @@ xfs_file_splice_write(
 {
 	struct inode		*inode = outfilp->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fsize_t		isize, new_size;
 	int			ioflags = 0;
 	ssize_t			ret;
@@ -386,9 +381,9 @@ xfs_file_splice_write(
 	if (!(ioflags & IO_INVIS)) {
 		int error;
 
-		error = xfs_dmapi_send_data(ip, DM_EVENT_WRITE, *ppos, count,
-					FILP_DELAY_FLAG(outfilp),
-					XFS_IOLOCK_EXCL);
+		error = xfs_dmapi_event_write(ip, *ppos, count,
+				outfilp->f_flags & (O_NDELAY|O_NONBLOCK),
+				0, XFS_IOLOCK_EXCL);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return -error;
@@ -675,14 +670,10 @@ start:
 	}
 
 	if (mp->m_dm_ops && !(ioflags & IO_INVIS) && !eventsent) {
-		int	dmflags = FILP_DELAY_FLAG(file);
-
-		if (need_i_mutex)
-			dmflags |= DM_FLAGS_IMUX;
-
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		error = xfs_dmapi_send_data(ip, DM_EVENT_WRITE,
-				      pos, count, dmflags, iolock);
+		error = xfs_dmapi_event_write(ip, pos, count,
+					file->f_flags & (O_NDELAY|O_NONBLOCK),
+					need_i_mutex, iolock);
 		if (error)
 			goto out_unlock_internal;
 		eventsent = 1;
@@ -833,10 +824,9 @@ write_retry:
 		xfs_iunlock(ip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
-		error = xfs_dmapi_send_namesp(xip, DM_RIGHT_NULL, NULL,
-				DM_EVENT_NOSPACE,
-				xip, DM_RIGHT_NULL, NULL,
-				0, 0, 0); /* Delay flag intentionally  unused */
+
+		error = xfs_dmapi_event_nospace(xip);
+
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
 		xfs_ilock(ip, iolock);
Index: b/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1120,10 +1120,7 @@ xfs_ioctl_setattr(
 	if (code)
 		return code;
 
-	(void) xfs_dmapi_send_namesp(ip, DM_RIGHT_NULL, NULL,
-			DM_EVENT_ATTRIBUTE,
-			NULL, DM_RIGHT_NULL, NULL,
-			0, 0, (mask & FSX_NONBLOCK) ? DM_FLAGS_NDELAY : 0);
+	xfs_dmapi_event_attribute(ip, mask & FSX_NONBLOCK);
 
 	return 0;
 
Index: b/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1206,7 +1206,7 @@ xfs_fs_put_super(
 		xfs_sync_attr(mp, 0);
 	}
 
-	xfs_dmapi_send_preunmount(mp);
+	xfs_dmapi_event_preunmount(mp);
 
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
@@ -1217,7 +1217,7 @@ xfs_fs_put_super(
 
 	XFS_bflush(mp->m_ddev_targp);
 
-	xfs_dmapi_send_unmount(mp);
+	xfs_dmapi_event_unmount(mp);
 
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
@@ -1612,7 +1612,7 @@ xfs_fs_fill_super(
 	 * others.  If that happens, we should probably disable
 	 * DMAPI on the file system or something.
 	 */
-	(void) xfs_dmapi_send_mount(mp, mtpt);
+	(void) xfs_dmapi_event_mount(mp, mtpt);
 
 	sb->s_magic = XFS_SB_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5620,8 +5620,7 @@ xfs_getbmap(
 		 * when in fact they may represent offline user data.
 		 */
 		if (!(iflags & BMV_IF_NO_DMAPI_READ)) {
-			error = xfs_dmapi_send_data(ip, DM_EVENT_READ,
-					      0, 0, 0, 0);
+			error = xfs_dmapi_event_read_simple(ip);
 			if (error)
 				return XFS_ERROR(error);
 		}
Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -148,15 +148,6 @@ typedef enum {
 #define DM_FLAGS_IALLOCSEM_WR	0x020	/* thread holds i_alloc_sem wr */
 
 /*
- *	Macros to turn caller specified delay/block flags into
- *	dm_send_xxxx_event flag DM_FLAGS_NDELAY.
- */
-
-#define FILP_DELAY_FLAG(filp) ((filp->f_flags&(O_NDELAY|O_NONBLOCK)) ? \
-			DM_FLAGS_NDELAY : 0)
-#define AT_DELAY_FLAG(f) ((f & XFS_ATTR_NONBLOCK) ? DM_FLAGS_NDELAY : 0)
-
-/*
  * Prototypes and functions for the Data Migration subsystem.
  */
 
@@ -353,4 +344,254 @@ xfs_dmapi_send_unmount(
 	}
 }
 
+/* Customized event functions, based on the DMAPI interfaces */
+
+/* Mount point events */
+
+static inline int
+xfs_dmapi_event_mount(
+	struct xfs_mount	*mp,
+	char			*path)
+{
+	return xfs_dmapi_send_mount(mp, path);
+}
+
+static inline void
+xfs_dmapi_event_preunmount(
+	struct xfs_mount	*mp)
+{
+	xfs_dmapi_send_preunmount(mp);
+}
+
+static inline void
+xfs_dmapi_event_unmount(
+	struct xfs_mount	*mp)
+{
+	xfs_dmapi_send_unmount(mp);
+}
+
+/* Inode events */
+
+static inline int
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
+static inline void
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
+static inline int
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
+static inline void
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
+static inline int
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
+static inline void
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
+static inline int
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
+static inline void
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
+static inline int
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
+static inline void
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
+static inline int
+xfs_dmapi_event_mmap(
+	struct vm_area_struct	*vma,
+	unsigned long		vm_flags)
+{
+	return xfs_dmapi_send_mmap(vma, vm_flags);
+}
+
+static inline int
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
+static inline int
+xfs_dmapi_event_read_simple(
+	struct xfs_inode	*ip)
+{
+	return xfs_dmapi_event_read(ip, 0, 0, 0, 0, 0);
+}
+
+static inline int
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
+static inline int
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
+static inline void
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
+static inline void
+xfs_dmapi_event_destroy(
+	struct xfs_inode	*ip)
+{
+	(void) xfs_dmapi_send_destroy(ip, DM_RIGHT_NULL);
+}
+
+static inline int
+xfs_dmapi_event_nospace(
+	struct xfs_inode	*ip)
+{
+	return xfs_dmapi_send_namesp(ip, DM_RIGHT_NULL, NULL,
+				DM_EVENT_NOSPACE,
+				ip, DM_RIGHT_NULL, NULL,
+				0, 0, 0); /* Delay flag intentionally unused */
+}
+
 #endif  /* __XFS_DMAPI_H__ */
Index: b/fs/xfs/xfs_rename.c
===================================================================
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -119,10 +119,8 @@ xfs_rename(
 	xfs_itrace_entry(src_dp);
 	xfs_itrace_entry(target_dp);
 
-	error = xfs_dmapi_send_namesp(src_dp, DM_RIGHT_NULL, src_name->name,
-				DM_EVENT_RENAME,
-				target_dp, DM_RIGHT_NULL, target_name->name,
-				0, 0, 0);
+	error = xfs_dmapi_event_rename(src_dp, src_name->name,
+					target_dp, target_name->name);
 	if (error)
 		return error;
 
@@ -371,10 +369,8 @@ xfs_rename(
 	/* Fall through to std_return with error = 0 or errno from
 	 * xfs_trans_commit	 */
 std_return:
-	(void) xfs_dmapi_send_namesp(src_dp, DM_RIGHT_NULL, src_name->name,
-				DM_EVENT_POSTRENAME,
-				target_dp, DM_RIGHT_NULL, target_name->name,
-				0, error, 0);
+	xfs_dmapi_event_postrename(src_dp, src_name->name,
+					target_dp, target_name->name, error);
 	return error;
 
  abort_return:
Index: b/fs/xfs/xfs_vnodeops.c
===================================================================
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -144,11 +144,8 @@ xfs_setattr(
 		}
 	} else {
 		if (!(flags & XFS_ATTR_DMI)) {
-			int dmflags = AT_DELAY_FLAG(flags);
-
-			dmflags |= DM_FLAGS_IALLOCSEM_WR|DM_FLAGS_IMUX;
-			code = xfs_dmapi_send_data(ip, DM_EVENT_TRUNCATE,
-				iattr->ia_size, 0, dmflags, 0);
+			code = xfs_dmapi_event_truncate(ip, iattr->ia_size,
+						flags & XFS_ATTR_NONBLOCK);
 			if (code) {
 				lock_flags = 0;
 				goto error_return;
@@ -471,12 +468,8 @@ xfs_setattr(
 			return XFS_ERROR(code);
 	}
 
-	if (!(flags & XFS_ATTR_DMI)) {
-		(void) xfs_dmapi_send_namesp(ip, DM_RIGHT_NULL, NULL,
-					DM_EVENT_ATTRIBUTE,
-					NULL, DM_RIGHT_NULL, NULL,
-					0, 0, AT_DELAY_FLAG(flags));
-	}
+	if (!(flags & XFS_ATTR_DMI))
+		xfs_dmapi_event_attribute(ip, flags & XFS_ATTR_NONBLOCK);
 	return 0;
 
  abort_return:
@@ -1062,7 +1055,7 @@ xfs_inactive(
 	mp = ip->i_mount;
 
 	if (ip->i_d.di_nlink == 0)
-		(void) xfs_dmapi_send_destroy(ip, DM_RIGHT_NULL);
+		xfs_dmapi_event_destroy(ip);
 
 	error = 0;
 
@@ -1315,10 +1308,7 @@ xfs_create(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	error = xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, name->name,
-				DM_EVENT_CREATE,
-				NULL, DM_RIGHT_NULL, NULL,
-				mode, 0, 0);
+	error = xfs_dmapi_event_create(dp, name->name, mode);
 	if (error)
 		return error;
 
@@ -1488,10 +1478,7 @@ xfs_create(
 
 	/* Fallthrough to std_return with error = 0  */
  std_return:
-	(void) xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, name->name,
-				DM_EVENT_POSTCREATE,
-				ip, DM_RIGHT_NULL, NULL,
-				mode, error, 0);
+	xfs_dmapi_event_postcreate(dp, ip, name->name, mode, error);
 
 	return error;
 
@@ -1729,10 +1716,7 @@ xfs_remove(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	error = xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, name->name,
-				DM_EVENT_REMOVE,
-				NULL, DM_RIGHT_NULL, NULL,
-				ip->i_d.di_mode, 0, 0);
+	error = xfs_dmapi_event_remove(dp, name->name, ip->i_d.di_mode);
 	if (error)
 		return error;
 
@@ -1874,10 +1858,7 @@ xfs_remove(
 		xfs_filestream_deassociate(ip);
 
  std_return:
-	(void) xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, name->name,
-				DM_EVENT_POSTREMOVE,
-				NULL, DM_RIGHT_NULL, NULL,
-				ip->i_d.di_mode, error, 0);
+	xfs_dmapi_event_postremove(dp, name->name, ip->i_d.di_mode, error);
 
 	return error;
 
@@ -1912,10 +1893,7 @@ xfs_link(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	error = xfs_dmapi_send_namesp(tdp, DM_RIGHT_NULL, target_name->name,
-				DM_EVENT_LINK,
-				sip, DM_RIGHT_NULL, NULL,
-				0, 0, 0);
+	error = xfs_dmapi_event_link(sip, tdp, target_name->name);
 	if (error)
 		return error;
 
@@ -2013,10 +1991,7 @@ xfs_link(
 
 	/* Fall through to std_return with error = 0. */
 std_return:
-	(void) xfs_dmapi_send_namesp(tdp, DM_RIGHT_NULL, target_name->name,
-				DM_EVENT_POSTLINK,
-				sip, DM_RIGHT_NULL, NULL,
-				0, error, 0);
+	xfs_dmapi_event_postlink(sip, tdp, target_name->name, error);
 
 	return error;
 
@@ -2078,10 +2053,8 @@ xfs_symlink(
 	if (pathlen >= MAXPATHLEN)      /* total string too long */
 		return XFS_ERROR(ENAMETOOLONG);
 
-	error = xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, link_name->name,
-				DM_EVENT_SYMLINK,
-				NULL, DM_RIGHT_NULL,
-				(unsigned char *)target_path, 0, 0, 0);
+	error = xfs_dmapi_event_symlink((unsigned char *) target_path, dp,
+    				link_name->name);
 	if (error)
 		return error;
 
@@ -2271,10 +2244,8 @@ xfs_symlink(
 	/* Fall through to std_return with error = 0 or errno from
 	 * xfs_trans_commit	*/
 std_return:
-	(void) xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, link_name->name,
-				DM_EVENT_POSTSYMLINK,
-				error ? NULL : ip, DM_RIGHT_NULL,
-				(unsigned char *) target_path, 0, error, 0);
+	xfs_dmapi_event_postsymlink((unsignec char *) target_path, dp, ip,
+				link_name->name, error);
 
 	if (!error)
 		*ipp = ip;
@@ -2406,8 +2377,8 @@ xfs_alloc_file_space(
 		end_dmi_offset = offset+len;
 		if (end_dmi_offset > ip->i_size)
 			end_dmi_offset = ip->i_size;
-		error = xfs_dmapi_send_data(ip, DM_EVENT_WRITE, offset,
-				      end_dmi_offset - offset, 0, 0);
+		error = xfs_dmapi_event_write(ip, offset,
+				      end_dmi_offset - offset, 0, 0, 0);
 		if (error)
 			return error;
 	}
@@ -2514,11 +2485,8 @@ retry:
 	}
 dmapi_enospc_check:
 	if (error == ENOSPC && (attr_flags & XFS_ATTR_DMI) == 0) {
-		error = xfs_dmapi_send_namesp(ip, DM_RIGHT_NULL, NULL,
-					DM_EVENT_NOSPACE,
-					ip, DM_RIGHT_NULL, NULL,
-					0, 0, 0); /* Delay flag intentionally unused */
-		if (error == 0)
+		error = xfs_dmapi_event_nospace(ip);
+		if (! error)
 			goto retry;	/* Maybe DMAPI app. has made space */
 		/* else fall through with error from XFS_SEND_DATA */
 	}
@@ -2681,9 +2649,9 @@ xfs_free_file_space(
 	if (offset < ip->i_size && (attr_flags & XFS_ATTR_DMI) == 0) {
 		if (end_dmi_offset > ip->i_size)
 			end_dmi_offset = ip->i_size;
-		error = xfs_dmapi_send_data(ip, DM_EVENT_WRITE,
-				offset, end_dmi_offset - offset,
-				AT_DELAY_FLAG(attr_flags), 0);
+		error = xfs_dmapi_event_write(ip, offset,
+				end_dmi_offset - offset,
+				attr_flags & XFS_ATTR_NONBLOCK, 0, 0);
 		if (error)
 			return error;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
