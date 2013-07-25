Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 695A27F67
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 10:49:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD839AC004
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 08:49:32 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Rvp2dGTzaiu0smZK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 08:49:31 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6PFnUVp007019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:31 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6PFnUIl013206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:30 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6PFnUN5017275 for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:30 GMT
Date: Thu, 25 Jul 2013 11:49:42 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v6 5/7] xfs: create internal eofblocks structure with kuid_t
	types
Message-ID: <20130725114942.673238a8@oracle.com>
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
To: xfs@oss.sgi.com

Have eofblocks ioctl convert uid_t to kuid_t into internal structure.
Update internal filter matching to compare ids with kuid_t types.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_fs.h     |  2 +-
 fs/xfs/xfs_icache.c | 12 ++++++------
 fs/xfs/xfs_icache.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c  | 18 ++++++------------
 4 files changed, 56 insertions(+), 19 deletions(-)

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
index 3f90e1c..ed35584 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -619,7 +619,7 @@ restart:
 
 /*
  * Background scanning to trim post-EOF preallocated space. This is queued
- * based on the 'background_prealloc_discard_period' tunable (5m by default).
+ * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
  */
 STATIC void
 xfs_queue_eofblocks(
@@ -1203,15 +1203,15 @@ xfs_inode_match_id(
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
index a01afbb..66a1a22 100644
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
 
@@ -49,4 +57,39 @@ int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
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
index 8edc780..6e72eff 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1610,23 +1610,17 @@ xfs_file_ioctl(
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
