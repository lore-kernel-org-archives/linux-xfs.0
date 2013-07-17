Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 25ED829E1D
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 10:47:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9237AC01B
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 08:47:52 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zOEyPpTLlKLBvXgv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jul 2013 08:47:51 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6HFloqJ025640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 15:47:51 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6HFlnHh014384
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 15:47:50 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6HFlmwX014375 for <xfs@oss.sgi.com>; Wed, 17 Jul 2013 15:47:48 GMT
Date: Wed, 17 Jul 2013 11:47:46 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v4 6/7] xfs: check that eofblocks ioctl caller can write
	matched inodes
Message-ID: <20130717114746.4e133042@oracle.com>
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

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_fs.h     | 1 +
 fs/xfs/xfs_icache.c | 4 ++++
 fs/xfs/xfs_ioctl.c  | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 7eb4a5e..aee4b12 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -361,6 +361,7 @@ struct xfs_fs_eofblocks {
 #define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid */
 #define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by project id */
 #define XFS_EOF_FLAGS_MINFILESIZE	(1 << 4) /* filter by min file size */
+#define XFS_EOF_FLAGS_PERM_CHECK	(1 << 5) /* check can write inode */
 #define XFS_EOF_FLAGS_VALID	\
 	(XFS_EOF_FLAGS_SYNC |	\
 	 XFS_EOF_FLAGS_UID |	\
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d873ab9e..728283a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1247,6 +1247,10 @@ xfs_inode_free_eofblocks(
 		if (!xfs_inode_match_id(ip, eofb))
 			return 0;
 
+		if (eofb->eof_flags & XFS_EOF_FLAGS_PERM_CHECK &&
+		    inode_permission(VFS_I(ip), MAY_WRITE))
+			return 0;
+
 		/* skip the inode if the file size is too small */
 		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
 		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index abbbdcf..e63e359 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1636,6 +1636,8 @@ xfs_file_ioctl(
 		    !gid_valid(keofb.eof_gid))
 			return XFS_ERROR(EINVAL);
 
+		keofb.eof_flags |= XFS_EOF_FLAGS_PERM_CHECK;
+
 		error = xfs_icache_free_eofblocks(mp, &keofb);
 		return -error;
 	}
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
