Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM2btx044213 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:02:37 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282205.o5SM5M6w018161@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:05:22 -0500
Subject: [PATCH 06/15] xfs: rewrite XFS_SEND_DATA() as a function
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

Re-implement XFS_SEND_DATA() using a real (static inline) function.

The mount point passed in to XFS_SEND_DATA() is always taken from
the i_mount field of an xfs_inode, which is also provided as an
argument.  Get rid of the mount point argument altogether, and
compute what would have been passed within the macro.  Make the
first argument be the inode "target" of the event being signalled.

Also, the implementation of the send data event doesn't side-effect
the value whose address is passed in its lock_flags argument.  So
switch it over to just pass the lock_flags value itself, rather than
the address of a variable.

Finally, move the test for whether a given event is enabled into the
called function.  There's a call in xfs_write() that needs to check
if the event is enabled before making the call, in order to avoid
unnecessarily unlocking and relocking the target inode.  Take the
branch more generally, whenever (but only when) DMAPI is enabled on
the file system; if it is, the second pass is not expensive.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_file.c |   41 ++++++++++++++++++-----------------------
 fs/xfs/xfs_bmap.c           |    7 +++----
 fs/xfs/xfs_dmapi.h          |   22 +++++++++++++++++++---
 fs/xfs/xfs_vnodeops.c       |   23 ++++++++++-------------
 4 files changed, 50 insertions(+), 43 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -275,15 +275,13 @@ xfs_file_aio_read(
 		mutex_lock(&inode->i_mutex);
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
-	if (xfs_dmapi_event_enabled(ip, DM_EVENT_READ) &&
-			!(ioflags & IO_INVIS)) {
-		int iolock = XFS_IOLOCK_SHARED;
+	if (!(ioflags & IO_INVIS)) {
 		int dmflags = FILP_DELAY_FLAG(file);
 
 		if (ioflags & IO_ISDIRECT)
 		    	dmflags |= DM_FLAGS_IMUX;
-		ret = -XFS_SEND_DATA(mp, DM_EVENT_READ, ip, iocb->ki_pos, size,
-					dmflags, &iolock);
+		ret = -xfs_dmapi_send_data(ip, DM_EVENT_READ, iocb->ki_pos,
+					size, dmflags, XFS_IOLOCK_SHARED);
 		if (ret) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 			if (unlikely(ioflags & IO_ISDIRECT))
@@ -338,13 +336,12 @@ xfs_file_splice_read(
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
-	if (xfs_dmapi_event_enabled(ip, DM_EVENT_READ)
-			&& !(ioflags & IO_INVIS)) {
-		int iolock = XFS_IOLOCK_SHARED;
+	if (!(ioflags & IO_INVIS)) {
 		int error;
 
-		error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip, *ppos, count,
-					FILP_DELAY_FLAG(infilp), &iolock);
+		error = xfs_dmapi_send_data(ip, DM_EVENT_READ, *ppos,
+					count, FILP_DELAY_FLAG(infilp),
+					XFS_IOLOCK_SHARED);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 			return -error;
@@ -386,13 +383,12 @@ xfs_file_splice_write(
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
-	if (xfs_dmapi_event_enabled(ip, DM_EVENT_WRITE)
-			&& !(ioflags & IO_INVIS)) {
-		int iolock = XFS_IOLOCK_EXCL;
+	if (!(ioflags & IO_INVIS)) {
 		int error;
 
-		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, ip, *ppos, count,
-					FILP_DELAY_FLAG(outfilp), &iolock);
+		error = xfs_dmapi_send_data(ip, DM_EVENT_WRITE, *ppos, count,
+					FILP_DELAY_FLAG(outfilp),
+					XFS_IOLOCK_EXCL);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return -error;
@@ -678,21 +674,20 @@ start:
 		goto out_unlock_mutex;
 	}
 
-	if (xfs_dmapi_event_enabled(ip, DM_EVENT_WRITE) &&
-	    !(ioflags & IO_INVIS) && !eventsent) {
-		int		dmflags = FILP_DELAY_FLAG(file);
+	if (mp->m_flags & XFS_MOUNT_DMAPI && !(ioflags & IO_INVIS) &&
+			!eventsent) {
+		int	dmflags = FILP_DELAY_FLAG(file);
 
 		if (need_i_mutex)
 			dmflags |= DM_FLAGS_IMUX;
 
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		error = XFS_SEND_DATA(ip->i_mount, DM_EVENT_WRITE, ip,
-				      pos, count, dmflags, &iolock);
-		if (error) {
+		error = xfs_dmapi_send_data(ip, DM_EVENT_WRITE,
+				      pos, count, dmflags, iolock);
+		if (error)
 			goto out_unlock_internal;
-		}
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		eventsent = 1;
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 		/*
 		 * The iolock was dropped and reacquired in XFS_SEND_DATA
Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5619,10 +5619,9 @@ xfs_getbmap(
 		 * could misinterpret holes in a DMAPI file as true holes,
 		 * when in fact they may represent offline user data.
 		 */
-		if (xfs_dmapi_event_enabled(ip, DM_EVENT_READ) &&
-		    !(iflags & BMV_IF_NO_DMAPI_READ)) {
-			error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip,
-					      0, 0, 0, NULL);
+		if (!(iflags & BMV_IF_NO_DMAPI_READ)) {
+			error = xfs_dmapi_send_data(ip, DM_EVENT_READ,
+					      0, 0, 0, 0);
 			if (error)
 				return XFS_ERROR(error);
 		}
Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -166,7 +166,7 @@ extern void	xfs_dmops_put(struct xfs_mou
 extern struct xfs_dmops xfs_dmcore_xfs;
 
 typedef int	(*xfs_send_data_t)(int, struct xfs_inode *,
-			xfs_off_t, size_t, int, int *);
+			xfs_off_t, size_t, int, int);
 typedef int	(*xfs_send_mmap_t)(struct vm_area_struct *, uint);
 typedef int	(*xfs_send_destroy_t)(struct xfs_inode *, dm_right_t);
 typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct xfs_mount *,
@@ -209,8 +209,24 @@ xfs_dmapi_event_enabled(struct xfs_inode
 #endif /* ! XFS_DMAPI */
 }
 
-#define XFS_SEND_DATA(mp, ev,ip,off,len,fl,lock) \
-	(*(mp)->m_dm_ops->xfs_send_data)(ev,ip,off,len,fl,lock)
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
 #define XFS_SEND_MMAP(mp, vma,fl) \
 	(*(mp)->m_dm_ops->xfs_send_mmap)(vma,fl)
 #define XFS_SEND_DESTROY(mp, ip,right) \
Index: b/fs/xfs/xfs_vnodeops.c
===================================================================
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -143,13 +143,12 @@ xfs_setattr(
 			goto error_return;
 		}
 	} else {
-		if (xfs_dmapi_event_enabled(ip, DM_EVENT_TRUNCATE) &&
-		    !(flags & XFS_ATTR_DMI)) {
+		if (!(flags & XFS_ATTR_DMI)) {
 			int dmflags = AT_DELAY_FLAG(flags);
 
 			dmflags |= DM_FLAGS_IALLOCSEM_WR|DM_FLAGS_IMUX;
-			code = XFS_SEND_DATA(mp, DM_EVENT_TRUNCATE, ip,
-				iattr->ia_size, 0, dmflags, NULL);
+			code = xfs_dmapi_send_data(ip, DM_EVENT_TRUNCATE,
+				iattr->ia_size, 0, dmflags, 0);
 			if (code) {
 				lock_flags = 0;
 				goto error_return;
@@ -2417,15 +2416,14 @@ xfs_alloc_file_space(
 
 	/*	Generate a DMAPI event if needed.	*/
 	if (alloc_type != 0 && offset < ip->i_size &&
-			(attr_flags & XFS_ATTR_DMI) == 0  &&
-			xfs_dmapi_event_enabled(ip, DM_EVENT_WRITE)) {
+			(attr_flags & XFS_ATTR_DMI) == 0) {
 		xfs_off_t           end_dmi_offset;
 
 		end_dmi_offset = offset+len;
 		if (end_dmi_offset > ip->i_size)
 			end_dmi_offset = ip->i_size;
-		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, ip, offset,
-				      end_dmi_offset - offset, 0, NULL);
+		error = xfs_dmapi_send_data(ip, DM_EVENT_WRITE, offset,
+				      end_dmi_offset - offset, 0, 0);
 		if (error)
 			return error;
 	}
@@ -2691,19 +2689,18 @@ xfs_free_file_space(
 
 	error = 0;
 	if (len <= 0)	/* if nothing being freed */
-		return error;
+		return 0;
 	rt = XFS_IS_REALTIME_INODE(ip);
 	startoffset_fsb	= XFS_B_TO_FSB(mp, offset);
 	end_dmi_offset = offset + len;
 	endoffset_fsb = XFS_B_TO_FSBT(mp, end_dmi_offset);
 
-	if (offset < ip->i_size && (attr_flags & XFS_ATTR_DMI) == 0 &&
-	    xfs_dmapi_event_enabled(ip, DM_EVENT_WRITE)) {
+	if (offset < ip->i_size && (attr_flags & XFS_ATTR_DMI) == 0) {
 		if (end_dmi_offset > ip->i_size)
 			end_dmi_offset = ip->i_size;
-		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, ip,
+		error = xfs_dmapi_send_data(ip, DM_EVENT_WRITE,
 				offset, end_dmi_offset - offset,
-				AT_DELAY_FLAG(attr_flags), NULL);
+				AT_DELAY_FLAG(attr_flags), 0);
 		if (error)
 			return error;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
