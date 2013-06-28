Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EFF317F63
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 10:11:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BB38C304082
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 08:11:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id SgktGmRZOQ7L4NJI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 08:11:35 -0700 (PDT)
Date: Fri, 28 Jun 2013 11:11:31 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH 5/6] create internal eofblocks structure with kuid_t types
Message-ID: <20130628111131.3ad961e9@oracle.com>
In-Reply-To: <20130626020924.GD29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
Mime-Version: 1.0
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
Cc: Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

Have eofblocks ioctl convert uid_t to kuid_t into internal structure.
Update internal filter matching to compare ids with kuid_t types.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_fs.h     |  2 +-
 fs/xfs/xfs_icache.c |  6 +++---
 fs/xfs/xfs_ioctl.c  | 34 ++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_linux.h  |  8 ++++++++
 4 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index d046955..7eb4a5e 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -344,7 +344,7 @@ typedef struct xfs_error_injection {
  * Speculative preallocation trimming.
  */
 #define XFS_EOFBLOCKS_VERSION		1
-struct xfs_eofblocks {
+struct xfs_fs_eofblocks {
 	__u32		eof_version;
 	__u32		eof_flags;
 	uid_t		eof_uid;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 96e344e..2c35b13 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -617,7 +617,7 @@ restart:
 
 /*
  * Background scanning to trim post-EOF preallocated space. This is queued
- * based on the 'background_prealloc_discard_period' tunable (5m by default).
+ * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
  */
 STATIC void
 xfs_queue_eofblocks(
@@ -1202,11 +1202,11 @@ xfs_inode_match_id(
 	struct xfs_eofblocks	*eofb)
 {
 	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
-	    ip->i_d.di_uid != eofb->eof_uid)
+	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
 		return 0;
 
 	if (eofb->eof_flags & XFS_EOF_FLAGS_GID &&
-	    ip->i_d.di_gid != eofb->eof_gid)
+	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
 		return 0;
 
 	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bedf510..487dca5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1328,6 +1328,31 @@ xfs_ioc_getbmapx(
 	return 0;
 }
 
+STATIC int
+xfs_fs_eofblocks_to_internal(
+	struct xfs_fs_eofblocks		*src,
+	struct xfs_eofblocks		*dst)
+{
+	dst->eof_flags = src->eof_flags;
+	dst->eof_prid = src->eof_prid;
+	dst->eof_min_file_size = src->eof_min_file_size;
+
+	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
+		dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
+		if (!uid_valid(dst->eof_uid))
+			return XFS_ERROR(EINVAL);
+	}
+
+	if (src->eof_flags & XFS_EOF_FLAGS_GID) {
+		dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
+		if (!gid_valid(dst->eof_gid))
+			return XFS_ERROR(EINVAL);
+	}
+
+	return 0;
+}
+
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
@@ -1610,7 +1635,8 @@ xfs_file_ioctl(
 		return -error;
 
 	case XFS_IOC_FREE_EOFBLOCKS: {
-		struct xfs_eofblocks eofb;
+		struct xfs_fs_eofblocks eofb;
+		struct xfs_eofblocks keofb;
 
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -XFS_ERROR(EFAULT);
@@ -1625,7 +1651,11 @@ xfs_file_ioctl(
 		    memchr_inv(eofb.pad64, 0, sizeof(eofb.pad64)))
 			return -XFS_ERROR(EINVAL);
 
-		error = xfs_icache_free_eofblocks(mp, &eofb);
+		error = xfs_fs_eofblocks_to_internal(&eofb, &keofb);
+		if (error)
+			return -XFS_ERROR(error);
+
+		error = xfs_icache_free_eofblocks(mp, &keofb);
 		return -error;
 	}
 
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 761e4c0..3c2f403 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -185,6 +185,14 @@ static inline kgid_t xfs_gid_to_kgid(__uint32_t gid)
 	return make_kgid(&init_user_ns, gid);
 }
 
+struct xfs_eofblocks {
+	__u32		eof_flags;
+	kuid_t		eof_uid;
+	kgid_t		eof_gid;
+	prid_t		eof_prid;
+	__u64		eof_min_file_size;
+};
+
 /*
  * Various platform dependent calls that don't fit anywhere else
  */
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
