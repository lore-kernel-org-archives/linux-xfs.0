Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM37mN044306 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:03:07 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282205.o5SM5qNZ018194@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:05:52 -0500
Subject: [PATCH 09/15] xfs: rewrite XFS_SEND_NAMESP() as a function
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

Re-implement XFS_SEND_NAMESP() using a real (static inline) function.

The mount point passed in to XFS_SEND_NAMESP() is always taken from
the i_mount field of the first xfs_inode which is also provided.
(If two inodes are passed they need to reside in the same
filesystem.)  Get rid of the mount point argument altogether, and
compute what would have been passed within the macro, making the
first argument be the inode "target" of the event being signalled.
Rearrange the arguments to the XFS_SEND_NAMESP() macro to be more
regular, since they're a little wonky.

Finally, move the test for whether a given event is enabled into
the called function.  In a few cases this depends on both inodes
rather than just the first, so this ends up being more involved,
but I think it's better to hide these details.

Note that there also a call in xfs_file_aio_write() that needs to
check if the event is enabled before making the call, in order to
avoid unnecessarily unlocking and relocking the target inode.  Take
the branch more generally when DMAPI is enabled on the file system.
This should be an unusual case (ENOSPC), so we'll not worry about
the extra overhead.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_file.c  |    8 +--
 fs/xfs/linux-2.6/xfs_ioctl.c |    9 +--
 fs/xfs/xfs_dmapi.h           |   69 ++++++++++++++++++++++----
 fs/xfs/xfs_rename.c          |   29 ++++-------
 fs/xfs/xfs_vnodeops.c        |  112 ++++++++++++++++++-------------------------
 5 files changed, 126 insertions(+), 101 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -830,14 +830,14 @@ write_retry:
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
-	if (ret == -ENOSPC &&
-			xfs_dmapi_event_enabled(ip, DM_EVENT_NOSPACE) &&
+	if (ret == -ENOSPC && mp->m_flags & XFS_MOUNT_DMAPI &&
 			!(ioflags & IO_INVIS)) {
 		xfs_iunlock(ip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
-		error = XFS_SEND_NAMESP(ip->i_mount, DM_EVENT_NOSPACE, ip,
-				DM_RIGHT_NULL, ip, DM_RIGHT_NULL, NULL, NULL,
+		error = xfs_dmapi_send_namesp(xip, DM_RIGHT_NULL, NULL,
+				DM_EVENT_NOSPACE,
+				xip, DM_RIGHT_NULL, NULL,
 				0, 0, 0); /* Delay flag intentionally  unused */
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
Index: b/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1120,11 +1120,10 @@ xfs_ioctl_setattr(
 	if (code)
 		return code;
 
-	if (xfs_dmapi_event_enabled(ip, DM_EVENT_ATTRIBUTE)) {
-		XFS_SEND_NAMESP(mp, DM_EVENT_ATTRIBUTE, ip, DM_RIGHT_NULL,
-				NULL, DM_RIGHT_NULL, NULL, NULL, 0, 0,
-				(mask & FSX_NONBLOCK) ? DM_FLAGS_NDELAY : 0);
-	}
+	(void) xfs_dmapi_send_namesp(ip, DM_RIGHT_NULL, NULL,
+			DM_EVENT_ATTRIBUTE,
+			NULL, DM_RIGHT_NULL, NULL,
+			0, 0, (mask & FSX_NONBLOCK) ? DM_FLAGS_NDELAY : 0);
 
 	return 0;
 
Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -259,8 +259,60 @@ xfs_dmapi_send_destroy(
 	return send_destroy(ip, right);
 }
 
-#define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
-	(*(mp)->m_dm_ops->xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
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
 
 static inline int
 xfs_dmapi_send_mount(
@@ -281,14 +333,11 @@ static inline void
 xfs_dmapi_send_preunmount(
 	struct xfs_mount	*mp)
 {
-	if (mp->m_flags & XFS_MOUNT_DMAPI) {
-		xfs_send_namesp_t send_namesp = mp->m_dm_ops->xfs_send_namesp;
-
-		(void) send_namesp(DM_EVENT_PREUNMOUNT, mp,
-			mp->m_rootip, DM_RIGHT_NULL,
-			mp->m_rootip, DM_RIGHT_NULL,
-			NULL, NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp));
-	}
+	if (mp->m_flags & XFS_MOUNT_DMAPI)
+		(void) xfs_dmapi_send_namesp(mp->m_rootip, DM_RIGHT_NULL, NULL,
+					DM_EVENT_PREUNMOUNT,
+					mp->m_rootip, DM_RIGHT_NULL, NULL,
+					0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp));
 }
 
 static inline void
Index: b/fs/xfs/xfs_rename.c
===================================================================
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -119,16 +119,13 @@ xfs_rename(
 	xfs_itrace_entry(src_dp);
 	xfs_itrace_entry(target_dp);
 
-	if (xfs_dmapi_event_enabled(src_dp, DM_EVENT_RENAME) ||
-	    xfs_dmapi_event_enabled(target_dp, DM_EVENT_RENAME)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_RENAME,
-					src_dp, DM_RIGHT_NULL,
-					target_dp, DM_RIGHT_NULL,
-					src_name->name, target_name->name,
-					0, 0, 0);
-		if (error)
-			return error;
-	}
+	error = xfs_dmapi_send_namesp(src_dp, DM_RIGHT_NULL, src_name->name,
+				DM_EVENT_RENAME,
+				target_dp, DM_RIGHT_NULL, target_name->name,
+				0, 0, 0);
+	if (error)
+		return error;
+
 	/* Return through std_return after this point. */
 
 	new_parent = (src_dp != target_dp);
@@ -374,14 +371,10 @@ xfs_rename(
 	/* Fall through to std_return with error = 0 or errno from
 	 * xfs_trans_commit	 */
 std_return:
-	if (xfs_dmapi_event_enabled(src_dp, DM_EVENT_POSTRENAME) ||
-	    xfs_dmapi_event_enabled(target_dp, DM_EVENT_POSTRENAME)) {
-		(void) XFS_SEND_NAMESP (mp, DM_EVENT_POSTRENAME,
-					src_dp, DM_RIGHT_NULL,
-					target_dp, DM_RIGHT_NULL,
-					src_name->name, target_name->name,
-					0, error, 0);
-	}
+	(void) xfs_dmapi_send_namesp(src_dp, DM_RIGHT_NULL, src_name->name,
+				DM_EVENT_POSTRENAME,
+				target_dp, DM_RIGHT_NULL, target_name->name,
+				0, error, 0);
 	return error;
 
  abort_return:
Index: b/fs/xfs/xfs_vnodeops.c
===================================================================
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -471,10 +471,10 @@ xfs_setattr(
 			return XFS_ERROR(code);
 	}
 
-	if (xfs_dmapi_event_enabled(ip, DM_EVENT_ATTRIBUTE) &&
-	    !(flags & XFS_ATTR_DMI)) {
-		(void) XFS_SEND_NAMESP(mp, DM_EVENT_ATTRIBUTE, ip, DM_RIGHT_NULL,
-					NULL, DM_RIGHT_NULL, NULL, NULL,
+	if (!(flags & XFS_ATTR_DMI)) {
+		(void) xfs_dmapi_send_namesp(ip, DM_RIGHT_NULL, NULL,
+					DM_EVENT_ATTRIBUTE,
+					NULL, DM_RIGHT_NULL, NULL,
 					0, 0, AT_DELAY_FLAG(flags));
 	}
 	return 0;
@@ -1315,15 +1315,12 @@ xfs_create(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (xfs_dmapi_event_enabled(dp, DM_EVENT_CREATE)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
-				dp, DM_RIGHT_NULL, NULL,
-				DM_RIGHT_NULL, name->name, NULL,
+	error = xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, name->name,
+				DM_EVENT_CREATE,
+				NULL, DM_RIGHT_NULL, NULL,
 				mode, 0, 0);
-
-		if (error)
-			return error;
-	}
+	if (error)
+		return error;
 
 	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 		prid = dp->i_d.di_projid;
@@ -1491,11 +1488,10 @@ xfs_create(
 
 	/* Fallthrough to std_return with error = 0  */
  std_return:
-	if (xfs_dmapi_event_enabled(dp, DM_EVENT_POSTCREATE)) {
-		XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE, dp, DM_RIGHT_NULL,
-				ip, DM_RIGHT_NULL, name->name, NULL, mode,
-				error, 0);
-	}
+	(void) xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, name->name,
+				DM_EVENT_POSTCREATE,
+				ip, DM_RIGHT_NULL, NULL,
+				mode, error, 0);
 
 	return error;
 
@@ -1733,13 +1729,12 @@ xfs_remove(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (xfs_dmapi_event_enabled(dp, DM_EVENT_REMOVE)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dp, DM_RIGHT_NULL,
-					NULL, DM_RIGHT_NULL, name->name, NULL,
-					ip->i_d.di_mode, 0, 0);
-		if (error)
-			return error;
-	}
+	error = xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, name->name,
+				DM_EVENT_REMOVE,
+				NULL, DM_RIGHT_NULL, NULL,
+				ip->i_d.di_mode, 0, 0);
+	if (error)
+		return error;
 
 	error = xfs_qm_dqattach(dp, 0);
 	if (error)
@@ -1879,11 +1874,10 @@ xfs_remove(
 		xfs_filestream_deassociate(ip);
 
  std_return:
-	if (xfs_dmapi_event_enabled(dp, DM_EVENT_POSTREMOVE)) {
-		XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE, dp, DM_RIGHT_NULL,
-				NULL, DM_RIGHT_NULL, name->name, NULL,
+	(void) xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, name->name,
+				DM_EVENT_POSTREMOVE,
+				NULL, DM_RIGHT_NULL, NULL,
 				ip->i_d.di_mode, error, 0);
-	}
 
 	return error;
 
@@ -1918,14 +1912,12 @@ xfs_link(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (xfs_dmapi_event_enabled(tdp, DM_EVENT_LINK)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_LINK,
-					tdp, DM_RIGHT_NULL,
-					sip, DM_RIGHT_NULL,
-					target_name->name, NULL, 0, 0, 0);
-		if (error)
-			return error;
-	}
+	error = xfs_dmapi_send_namesp(tdp, DM_RIGHT_NULL, target_name->name,
+				DM_EVENT_LINK,
+				sip, DM_RIGHT_NULL, NULL,
+				0, 0, 0);
+	if (error)
+		return error;
 
 	/* Return through std_return after this point. */
 
@@ -2021,12 +2013,11 @@ xfs_link(
 
 	/* Fall through to std_return with error = 0. */
 std_return:
-	if (xfs_dmapi_event_enabled(sip, DM_EVENT_POSTLINK)) {
-		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTLINK,
-				tdp, DM_RIGHT_NULL,
-				sip, DM_RIGHT_NULL,
-				target_name->name, NULL, 0, error, 0);
-	}
+	(void) xfs_dmapi_send_namesp(tdp, DM_RIGHT_NULL, target_name->name,
+				DM_EVENT_POSTLINK,
+				sip, DM_RIGHT_NULL, NULL,
+				0, error, 0);
+
 	return error;
 
  abort_return:
@@ -2087,14 +2078,12 @@ xfs_symlink(
 	if (pathlen >= MAXPATHLEN)      /* total string too long */
 		return XFS_ERROR(ENAMETOOLONG);
 
-	if (xfs_dmapi_event_enabled(dp, DM_EVENT_SYMLINK)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dp,
-					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
-					link_name->name,
-					(unsigned char *)target_path, 0, 0, 0);
-		if (error)
-			return error;
-	}
+	error = xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, link_name->name,
+				DM_EVENT_SYMLINK,
+				NULL, DM_RIGHT_NULL,
+				(unsigned char *)target_path, 0, 0, 0);
+	if (error)
+		return error;
 
 	/* Return through std_return after this point. */
 
@@ -2282,14 +2271,10 @@ xfs_symlink(
 	/* Fall through to std_return with error = 0 or errno from
 	 * xfs_trans_commit	*/
 std_return:
-	if (xfs_dmapi_event_enabled(dp, DM_EVENT_POSTSYMLINK)) {
-		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTSYMLINK,
-					dp, DM_RIGHT_NULL,
-					error ? NULL : ip,
-					DM_RIGHT_NULL, link_name->name,
-					(unsigned char *)target_path,
-					0, error, 0);
-	}
+	(void) xfs_dmapi_send_namesp(dp, DM_RIGHT_NULL, link_name->name,
+				DM_EVENT_POSTSYMLINK,
+				error ? NULL : ip, DM_RIGHT_NULL,
+				(unsigned char *) target_path, 0, error, 0);
 
 	if (!error)
 		*ipp = ip;
@@ -2528,12 +2513,11 @@ retry:
 		allocatesize_fsb -= allocated_fsb;
 	}
 dmapi_enospc_check:
-	if (error == ENOSPC && (attr_flags & XFS_ATTR_DMI) == 0 &&
-	    xfs_dmapi_event_enabled(ip, DM_EVENT_NOSPACE)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_NOSPACE,
-				ip, DM_RIGHT_NULL,
-				ip, DM_RIGHT_NULL,
-				NULL, NULL, 0, 0, 0); /* Delay flag intentionally unused */
+	if (error == ENOSPC && (attr_flags & XFS_ATTR_DMI) == 0) {
+		error = xfs_dmapi_send_namesp(ip, DM_RIGHT_NULL, NULL,
+					DM_EVENT_NOSPACE,
+					ip, DM_RIGHT_NULL, NULL,
+					0, 0, 0); /* Delay flag intentionally unused */
 		if (error == 0)
 			goto retry;	/* Maybe DMAPI app. has made space */
 		/* else fall through with error from XFS_SEND_DATA */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
