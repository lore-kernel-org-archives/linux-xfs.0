Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E222A7F54
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 13:08:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1C61304053
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:08:12 -0700 (PDT)
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v8 5/7] xfs: create internal eofblocks structure with kuid_t
	types
Date: Thu, 15 Aug 2013 14:08:02 -0400
Message-Id: <1376590084-12888-6-git-send-email-dwight.engen@oracle.com>
In-Reply-To: <1376590084-12888-1-git-send-email-dwight.engen@oracle.com>
References: <1376590084-12888-1-git-send-email-dwight.engen@oracle.com>
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
Cc: Dwight Engen <dwight.engen@oracle.com>, Ben Myers <bpm@sgi.com>

Have eofblocks ioctl convert uid_t to kuid_t into internal structure.
Update internal filter matching to compare ids with kuid_t types.

Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_fs.h     |  2 +-
 fs/xfs/xfs_icache.c | 12 ++++++------
 fs/xfs/xfs_icache.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c  | 18 ++++++------------
 4 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 53e33c2..1edb5cc 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -357,7 +357,7 @@ typedef struct xfs_error_injection {
  * Speculative preallocation trimming.
  */
 #define XFS_EOFBLOCKS_VERSION		1
-struct xfs_eofblocks {
+struct xfs_fs_eofblocks {
 	__u32		eof_version;
 	__u32		eof_flags;
 	uid_t		eof_uid;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2abc945..16219b9 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -620,7 +620,7 @@ restart:
 
 /*
  * Background scanning to trim post-EOF preallocated space. This is queued
- * based on the 'background_prealloc_discard_period' tunable (5m by default).
+ * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
  */
 STATIC void
 xfs_queue_eofblocks(
@@ -1204,15 +1204,15 @@ xfs_inode_match_id(
 	struct xfs_inode	*ip,
 	struct xfs_eofblocks	*eofb)
 {
-	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
-	    ip->i_d.di_uid != eofb->eof_uid)
+	if ((eofb->eof_flags & XFS_EOF_FLAGS_UID) &&
+	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
 		return 0;
 
-	if (eofb->eof_flags & XFS_EOF_FLAGS_GID &&
-	    ip->i_d.di_gid != eofb->eof_gid)
+	if ((eofb->eof_flags & XFS_EOF_FLAGS_GID) &&
+	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
 		return 0;
 
-	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
+	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
 	    xfs_get_projid(ip) != eofb->eof_prid)
 		return 0;
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index e3f2ee0..8a89f7d 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -21,6 +21,14 @@
 struct xfs_mount;
 struct xfs_perag;
 
+struct xfs_eofblocks {
+	__u32		eof_flags;
+	kuid_t		eof_uid;
+	kgid_t		eof_gid;
+	prid_t		eof_prid;
+	__u64		eof_min_file_size;
+};
+
 #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
 #define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
 
@@ -56,4 +64,39 @@ int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
 		int flags, void *args),
 	int flags, void *args, int tag);
 
+static inline int
+xfs_fs_eofblocks_from_user(
+	struct xfs_fs_eofblocks		*src,
+	struct xfs_eofblocks		*dst)
+{
+	if (src->eof_version != XFS_EOFBLOCKS_VERSION)
+		return EINVAL;
+
+	if (src->eof_flags & ~XFS_EOF_FLAGS_VALID)
+		return EINVAL;
+
+	if (memchr_inv(&src->pad32, 0, sizeof(src->pad32)) ||
+	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
+		return EINVAL;
+
+	dst->eof_flags = src->eof_flags;
+	dst->eof_prid = src->eof_prid;
+	dst->eof_min_file_size = src->eof_min_file_size;
+
+	dst->eof_uid = INVALID_UID;
+	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
+		dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
+		if (!uid_valid(dst->eof_uid))
+			return EINVAL;
+	}
+
+	dst->eof_gid = INVALID_GID;
+	if (src->eof_flags & XFS_EOF_FLAGS_GID) {
+		dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
+		if (!gid_valid(dst->eof_gid))
+			return EINVAL;
+	}
+	return 0;
+}
+
 #endif
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 999c1ef..20b4c7a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1720,23 +1720,17 @@ xfs_file_ioctl(
 		return -error;
 
 	case XFS_IOC_FREE_EOFBLOCKS: {
-		struct xfs_eofblocks eofb;
+		struct xfs_fs_eofblocks eofb;
+		struct xfs_eofblocks keofb;
 
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -XFS_ERROR(EFAULT);
 
-		if (eofb.eof_version != XFS_EOFBLOCKS_VERSION)
-			return -XFS_ERROR(EINVAL);
-
-		if (eofb.eof_flags & ~XFS_EOF_FLAGS_VALID)
-			return -XFS_ERROR(EINVAL);
-
-		if (memchr_inv(&eofb.pad32, 0, sizeof(eofb.pad32)) ||
-		    memchr_inv(eofb.pad64, 0, sizeof(eofb.pad64)))
-			return -XFS_ERROR(EINVAL);
+		error = xfs_fs_eofblocks_from_user(&eofb, &keofb);
+		if (error)
+			return -error;
 
-		error = xfs_icache_free_eofblocks(mp, &eofb);
-		return -error;
+		return -xfs_icache_free_eofblocks(mp, &keofb);
 	}
 
 	default:
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
