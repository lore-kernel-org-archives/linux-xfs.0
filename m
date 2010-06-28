Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM2JQs044192 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:02:20 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282205.o5SM52Qc018142@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:05:02 -0500
Subject: [PATCH 04/15] xfs: rewrite DM_EVENT_ENABLED() as a function
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

Re-implement DM_EVENT_ENABLED() using a real (static inline)
function.  Also, get rid of a redundant test of the DMAPI mount
flag in xfs_file_open_exec().

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_file.c  |   16 ++++++++++------
 fs/xfs/linux-2.6/xfs_ioctl.c |    2 +-
 fs/xfs/xfs_bmap.c            |    2 +-
 fs/xfs/xfs_dmapi.h           |   30 +++++++++++++++++++-----------
 fs/xfs/xfs_rename.c          |    8 ++++----
 fs/xfs/xfs_vnodeops.c        |   29 +++++++++++++++--------------
 6 files changed, 50 insertions(+), 37 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -275,7 +275,8 @@ xfs_file_aio_read(
 		mutex_lock(&inode->i_mutex);
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
-	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) && !(ioflags & IO_INVIS)) {
+	if (xfs_dmapi_event_enabled(ip, DM_EVENT_READ) &&
+			!(ioflags & IO_INVIS)) {
 		int iolock = XFS_IOLOCK_SHARED;
 		int dmflags = FILP_DELAY_FLAG(file);
 
@@ -337,7 +338,8 @@ xfs_file_splice_read(
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 
-	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) && !(ioflags & IO_INVIS)) {
+	if (xfs_dmapi_event_enabled(ip, DM_EVENT_READ)
+			&& !(ioflags & IO_INVIS)) {
 		int iolock = XFS_IOLOCK_SHARED;
 		int error;
 
@@ -384,7 +386,8 @@ xfs_file_splice_write(
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
-	if (DM_EVENT_ENABLED(ip, DM_EVENT_WRITE) && !(ioflags & IO_INVIS)) {
+	if (xfs_dmapi_event_enabled(ip, DM_EVENT_WRITE)
+			&& !(ioflags & IO_INVIS)) {
 		int iolock = XFS_IOLOCK_EXCL;
 		int error;
 
@@ -675,8 +678,8 @@ start:
 		goto out_unlock_mutex;
 	}
 
-	if ((DM_EVENT_ENABLED(ip, DM_EVENT_WRITE) &&
-	    !(ioflags & IO_INVIS) && !eventsent)) {
+	if (xfs_dmapi_event_enabled(ip, DM_EVENT_WRITE) &&
+	    !(ioflags & IO_INVIS) && !eventsent) {
 		int		dmflags = FILP_DELAY_FLAG(file);
 
 		if (need_i_mutex)
@@ -833,7 +836,8 @@ write_retry:
 	}
 
 	if (ret == -ENOSPC &&
-	    DM_EVENT_ENABLED(ip, DM_EVENT_NOSPACE) && !(ioflags & IO_INVIS)) {
+			xfs_dmapi_event_enabled(ip, DM_EVENT_NOSPACE) &&
+			!(ioflags & IO_INVIS)) {
 		xfs_iunlock(ip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
Index: b/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1120,7 +1120,7 @@ xfs_ioctl_setattr(
 	if (code)
 		return code;
 
-	if (DM_EVENT_ENABLED(ip, DM_EVENT_ATTRIBUTE)) {
+	if (xfs_dmapi_event_enabled(ip, DM_EVENT_ATTRIBUTE)) {
 		XFS_SEND_NAMESP(mp, DM_EVENT_ATTRIBUTE, ip, DM_RIGHT_NULL,
 				NULL, DM_RIGHT_NULL, NULL, NULL, 0, 0,
 				(mask & FSX_NONBLOCK) ? DM_FLAGS_NDELAY : 0);
Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5619,7 +5619,7 @@ xfs_getbmap(
 		 * could misinterpret holes in a DMAPI file as true holes,
 		 * when in fact they may represent offline user data.
 		 */
-		if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) &&
+		if (xfs_dmapi_event_enabled(ip, DM_EVENT_READ) &&
 		    !(iflags & BMV_IF_NO_DMAPI_READ)) {
 			error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip,
 					      0, 0, 0, NULL);
Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -70,17 +70,6 @@ typedef enum {
 } dm_right_t;
 #define HAVE_DM_RIGHT_T
 
-/* Defines for determining if an event message should be sent. */
-#ifdef XFS_DMAPI
-#define	DM_EVENT_ENABLED(ip, event) ( \
-	unlikely ((ip)->i_mount->m_flags & XFS_MOUNT_DMAPI) && \
-		( ((ip)->i_d.di_dmevmask & (1 << event)) || \
-		  ((ip)->i_mount->m_dmevmask & (1 << event)) ) \
-	)
-#else /* ! XFS_DMAPI */
-#define DM_EVENT_ENABLED(ip, event)	(0)
-#endif /* ! XFS_DMAPI */
-
 #define DM_XFS_VALID_FS_EVENTS		( \
 	(1 << DM_EVENT_PREUNMOUNT)	| \
 	(1 << DM_EVENT_UNMOUNT)		| \
@@ -201,6 +190,25 @@ typedef struct xfs_dmops {
 #define XFS_DMAPI_UNMOUNT_FLAGS(mp) \
 	(((mp)->m_dmevmask & (1 << DM_EVENT_UNMOUNT)) ? 0 : DM_FLAGS_UNWANTED)
 
+/*
+ * DMAPI events only apply if DMAPI support was specified at mount
+ * time.  If active, a particular DMAPI event can be enabled for
+ * all files the file system, or for individual files.
+ */
+static inline int
+xfs_dmapi_event_enabled(struct xfs_inode *ip, dm_eventtype_t event)
+{
+#ifdef XFS_DMAPI
+    	unsigned int event_mask = 1 << event;
+
+	return ip->i_mount->m_flags & XFS_MOUNT_DMAPI &&
+		(ip->i_mount->m_dmevmask & event_mask ||
+			ip->i_d.di_dmevmask & event_mask);
+#else /* ! XFS_DMAPI */
+	return 0;
+#endif /* ! XFS_DMAPI */
+}
+
 #define XFS_SEND_DATA(mp, ev,ip,off,len,fl,lock) \
 	(*(mp)->m_dm_ops->xfs_send_data)(ev,ip,off,len,fl,lock)
 #define XFS_SEND_MMAP(mp, vma,fl) \
Index: b/fs/xfs/xfs_rename.c
===================================================================
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -119,8 +119,8 @@ xfs_rename(
 	xfs_itrace_entry(src_dp);
 	xfs_itrace_entry(target_dp);
 
-	if (DM_EVENT_ENABLED(src_dp, DM_EVENT_RENAME) ||
-	    DM_EVENT_ENABLED(target_dp, DM_EVENT_RENAME)) {
+	if (xfs_dmapi_event_enabled(src_dp, DM_EVENT_RENAME) ||
+	    xfs_dmapi_event_enabled(target_dp, DM_EVENT_RENAME)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_RENAME,
 					src_dp, DM_RIGHT_NULL,
 					target_dp, DM_RIGHT_NULL,
@@ -374,8 +374,8 @@ xfs_rename(
 	/* Fall through to std_return with error = 0 or errno from
 	 * xfs_trans_commit	 */
 std_return:
-	if (DM_EVENT_ENABLED(src_dp, DM_EVENT_POSTRENAME) ||
-	    DM_EVENT_ENABLED(target_dp, DM_EVENT_POSTRENAME)) {
+	if (xfs_dmapi_event_enabled(src_dp, DM_EVENT_POSTRENAME) ||
+	    xfs_dmapi_event_enabled(target_dp, DM_EVENT_POSTRENAME)) {
 		(void) XFS_SEND_NAMESP (mp, DM_EVENT_POSTRENAME,
 					src_dp, DM_RIGHT_NULL,
 					target_dp, DM_RIGHT_NULL,
Index: b/fs/xfs/xfs_vnodeops.c
===================================================================
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -143,7 +143,7 @@ xfs_setattr(
 			goto error_return;
 		}
 	} else {
-		if (DM_EVENT_ENABLED(ip, DM_EVENT_TRUNCATE) &&
+		if (xfs_dmapi_event_enabled(ip, DM_EVENT_TRUNCATE) &&
 		    !(flags & XFS_ATTR_DMI)) {
 			int dmflags = AT_DELAY_FLAG(flags);
 
@@ -472,7 +472,7 @@ xfs_setattr(
 			return XFS_ERROR(code);
 	}
 
-	if (DM_EVENT_ENABLED(ip, DM_EVENT_ATTRIBUTE) &&
+	if (xfs_dmapi_event_enabled(ip, DM_EVENT_ATTRIBUTE) &&
 	    !(flags & XFS_ATTR_DMI)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_ATTRIBUTE, ip, DM_RIGHT_NULL,
 					NULL, DM_RIGHT_NULL, NULL, NULL,
@@ -1062,7 +1062,8 @@ xfs_inactive(
 
 	mp = ip->i_mount;
 
-	if (ip->i_d.di_nlink == 0 && DM_EVENT_ENABLED(ip, DM_EVENT_DESTROY))
+	if (ip->i_d.di_nlink == 0 &&
+		    xfs_dmapi_event_enabled(ip, DM_EVENT_DESTROY))
 		XFS_SEND_DESTROY(mp, ip, DM_RIGHT_NULL);
 
 	error = 0;
@@ -1316,7 +1317,7 @@ xfs_create(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
+	if (xfs_dmapi_event_enabled(dp, DM_EVENT_CREATE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
 				dp, DM_RIGHT_NULL, NULL,
 				DM_RIGHT_NULL, name->name, NULL,
@@ -1492,7 +1493,7 @@ xfs_create(
 
 	/* Fallthrough to std_return with error = 0  */
  std_return:
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTCREATE)) {
+	if (xfs_dmapi_event_enabled(dp, DM_EVENT_POSTCREATE)) {
 		XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE, dp, DM_RIGHT_NULL,
 				ip, DM_RIGHT_NULL, name->name, NULL, mode,
 				error, 0);
@@ -1734,7 +1735,7 @@ xfs_remove(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
+	if (xfs_dmapi_event_enabled(dp, DM_EVENT_REMOVE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dp, DM_RIGHT_NULL,
 					NULL, DM_RIGHT_NULL, name->name, NULL,
 					ip->i_d.di_mode, 0, 0);
@@ -1880,7 +1881,7 @@ xfs_remove(
 		xfs_filestream_deassociate(ip);
 
  std_return:
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTREMOVE)) {
+	if (xfs_dmapi_event_enabled(dp, DM_EVENT_POSTREMOVE)) {
 		XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE, dp, DM_RIGHT_NULL,
 				NULL, DM_RIGHT_NULL, name->name, NULL,
 				ip->i_d.di_mode, error, 0);
@@ -1919,7 +1920,7 @@ xfs_link(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (DM_EVENT_ENABLED(tdp, DM_EVENT_LINK)) {
+	if (xfs_dmapi_event_enabled(tdp, DM_EVENT_LINK)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_LINK,
 					tdp, DM_RIGHT_NULL,
 					sip, DM_RIGHT_NULL,
@@ -2022,7 +2023,7 @@ xfs_link(
 
 	/* Fall through to std_return with error = 0. */
 std_return:
-	if (DM_EVENT_ENABLED(sip, DM_EVENT_POSTLINK)) {
+	if (xfs_dmapi_event_enabled(sip, DM_EVENT_POSTLINK)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTLINK,
 				tdp, DM_RIGHT_NULL,
 				sip, DM_RIGHT_NULL,
@@ -2088,7 +2089,7 @@ xfs_symlink(
 	if (pathlen >= MAXPATHLEN)      /* total string too long */
 		return XFS_ERROR(ENAMETOOLONG);
 
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_SYMLINK)) {
+	if (xfs_dmapi_event_enabled(dp, DM_EVENT_SYMLINK)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dp,
 					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
 					link_name->name,
@@ -2283,7 +2284,7 @@ xfs_symlink(
 	/* Fall through to std_return with error = 0 or errno from
 	 * xfs_trans_commit	*/
 std_return:
-	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTSYMLINK)) {
+	if (xfs_dmapi_event_enabled(dp, DM_EVENT_POSTSYMLINK)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTSYMLINK,
 					dp, DM_RIGHT_NULL,
 					error ? NULL : ip,
@@ -2417,7 +2418,7 @@ xfs_alloc_file_space(
 	/*	Generate a DMAPI event if needed.	*/
 	if (alloc_type != 0 && offset < ip->i_size &&
 			(attr_flags & XFS_ATTR_DMI) == 0  &&
-			DM_EVENT_ENABLED(ip, DM_EVENT_WRITE)) {
+			xfs_dmapi_event_enabled(ip, DM_EVENT_WRITE)) {
 		xfs_off_t           end_dmi_offset;
 
 		end_dmi_offset = offset+len;
@@ -2531,7 +2532,7 @@ retry:
 	}
 dmapi_enospc_check:
 	if (error == ENOSPC && (attr_flags & XFS_ATTR_DMI) == 0 &&
-	    DM_EVENT_ENABLED(ip, DM_EVENT_NOSPACE)) {
+	    xfs_dmapi_event_enabled(ip, DM_EVENT_NOSPACE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_NOSPACE,
 				ip, DM_RIGHT_NULL,
 				ip, DM_RIGHT_NULL,
@@ -2697,7 +2698,7 @@ xfs_free_file_space(
 	endoffset_fsb = XFS_B_TO_FSBT(mp, end_dmi_offset);
 
 	if (offset < ip->i_size && (attr_flags & XFS_ATTR_DMI) == 0 &&
-	    DM_EVENT_ENABLED(ip, DM_EVENT_WRITE)) {
+	    xfs_dmapi_event_enabled(ip, DM_EVENT_WRITE)) {
 		if (end_dmi_offset > ip->i_size)
 			end_dmi_offset = ip->i_size;
 		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, ip,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
