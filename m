Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5E1E29E19
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 10:47:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C5AF430408C
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 08:47:45 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id QVRE49sWddf3CevC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jul 2013 08:47:44 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6HFlh9L028218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 15:47:44 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6HFlhKa002222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 15:47:43 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6HFlgPf001913 for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 15:47:42 GMT
Date: Wed, 17 Jul 2013 11:47:40 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v4 5/7] xfs: create internal eofblocks structure with kuid_t
	types
Message-ID: <20130717114740.77f7bcee@oracle.com>
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
 fs/xfs/xfs_icache.c |  6 +++---
 fs/xfs/xfs_icache.h | 20 ++++++++++++++++++++
 fs/xfs/xfs_ioctl.c  | 15 +++++++++++++--
 4 files changed, 37 insertions(+), 6 deletions(-)

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
index 3f90e1c..d873ab9e 100644
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
@@ -1204,11 +1204,11 @@ xfs_inode_match_id(
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
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index a01afbb..6cce1e3 100644
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
 
@@ -49,4 +57,16 @@ int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
 		int flags, void *args),
 	int flags, void *args, int tag);
 
+static inline void
+xfs_fs_eofblocks_to_internal(
+	struct xfs_fs_eofblocks		*src,
+	struct xfs_eofblocks		*dst)
+{
+	dst->eof_flags = src->eof_flags;
+	dst->eof_prid = src->eof_prid;
+	dst->eof_min_file_size = src->eof_min_file_size;
+	dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
+	dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
+}
+
 #endif
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8edc780..abbbdcf 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1610,7 +1610,8 @@ xfs_file_ioctl(
 		return -error;
 
 	case XFS_IOC_FREE_EOFBLOCKS: {
-		struct xfs_eofblocks eofb;
+		struct xfs_fs_eofblocks eofb;
+		struct xfs_eofblocks keofb;
 
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -XFS_ERROR(EFAULT);
@@ -1625,7 +1626,17 @@ xfs_file_ioctl(
 		    memchr_inv(eofb.pad64, 0, sizeof(eofb.pad64)))
 			return -XFS_ERROR(EINVAL);
 
-		error = xfs_icache_free_eofblocks(mp, &eofb);
+		xfs_fs_eofblocks_to_internal(&eofb, &keofb);
+
+		if (keofb.eof_flags & XFS_EOF_FLAGS_UID &&
+		    !uid_valid(keofb.eof_uid))
+			return XFS_ERROR(EINVAL);
+
+		if (keofb.eof_flags & XFS_EOF_FLAGS_GID &&
+		    !gid_valid(keofb.eof_gid))
+			return XFS_ERROR(EINVAL);
+
+		error = xfs_icache_free_eofblocks(mp, &keofb);
 		return -error;
 	}
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
