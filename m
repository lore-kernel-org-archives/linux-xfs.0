Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 220E87F6D
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 10:49:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE3B28F8037
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 08:49:37 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id BY066EQRSJFuUP3b (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 08:49:37 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6PFnZRT014772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:36 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6PFnYuP017533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:35 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6PFnYXm020299 for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 15:49:34 GMT
Date: Thu, 25 Jul 2013 11:49:46 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v6 6/7] xfs: add permission check to free eofblocks ioctl
Message-ID: <20130725114946.13c7e4ad@oracle.com>
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

We need to check that userspace callers can only truncate preallocated
blocks from files they have write access to to prevent them from prematurley
reclaiming blocks from another user. The internal reclaimer will not specify
the internal XFS_KEOF_FLAGS_PERM_CHECK flag, but callers from userspace will
have it forced on.

Add check for read-only filesystem to free eofblocks ioctl.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_icache.c | 4 ++++
 fs/xfs/xfs_icache.h | 7 ++++++-
 fs/xfs/xfs_ioctl.c  | 3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ed35584..a80f38c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1247,6 +1247,10 @@ xfs_inode_free_eofblocks(
 		if (!xfs_inode_match_id(ip, eofb))
 			return 0;
 
+		if ((eofb->eof_flags & XFS_KEOF_FLAGS_PERM_CHECK) &&
+		    inode_permission(VFS_I(ip), MAY_WRITE))
+			return 0;
+
 		/* skip the inode if the file size is too small */
 		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
 		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 66a1a22..0b52804 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -57,6 +57,11 @@ int xfs_inode_ag_iterator_tag(struct xfs_mount *mp,
 		int flags, void *args),
 	int flags, void *args, int tag);
 
+#define XFS_KEOF_FLAGS_PERM_CHECK	(1 << 31) /* check can write inode */
+#if XFS_KEOF_FLAGS_PERM_CHECK & XFS_EOF_FLAGS_VALID
+#error "Internal XFS_KEOF_FLAGS_PERM_CHECK duplicated bit from XFS_EOF_FLAGS_VALID"
+#endif
+
 static inline int
 xfs_fs_eofblocks_from_user(
 	struct xfs_fs_eofblocks		*src,
@@ -72,7 +77,7 @@ xfs_fs_eofblocks_from_user(
 	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
 		return EINVAL;
 
-	dst->eof_flags = src->eof_flags;
+	dst->eof_flags = src->eof_flags | XFS_KEOF_FLAGS_PERM_CHECK;
 	dst->eof_prid = src->eof_prid;
 	dst->eof_min_file_size = src->eof_min_file_size;
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6e72eff..8500507 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1613,6 +1613,9 @@ xfs_file_ioctl(
 		struct xfs_fs_eofblocks eofb;
 		struct xfs_eofblocks keofb;
 
+		if (IS_RDONLY(inode))
+			return -XFS_ERROR(EROFS);
+
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -XFS_ERROR(EFAULT);
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
