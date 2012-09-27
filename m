Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RHgsAc121766 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 12:42:54 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9p3fOiidMD3LTWEw for
	<xfs@oss.sgi.com>; Thu, 27 Sep 2012 10:44:13 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8RHiDeV018982
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 13:44:13 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8RHiDiJ026820
	for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 13:44:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 7/8] xfs: add enhanced filtering to EOFBLOCKS scan
Date: Thu, 27 Sep 2012 13:45:51 -0400
Message-Id: <1348767952-24229-8-git-send-email-bfoster@redhat.com>
In-Reply-To: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
References: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Support EOFBLOCKS scan filtering by quota ID or minimum file size.
Add the appropriate fields/flags to the xfs_eofblocks structure and
pass it down to xfs_inode_free_eofblocks() where filtering
functionality is implemented.

A (user requested) quota ID based scan requires the associated
quota mode be enabled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fs.h    |    9 +++++++++
 fs/xfs/xfs_ioctl.c |   10 +++++++++-
 fs/xfs/xfs_sync.c  |   30 ++++++++++++++++++++++++++----
 fs/xfs/xfs_sync.h  |    2 +-
 4 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 32bb2e8..54c0f39 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -343,12 +343,21 @@ typedef struct xfs_error_injection {
  */
 struct xfs_eofblocks {
 	__u32		eof_flags;
+	__u32		eof_id;
+	__u64		eof_min_file_size;
 	__s32		version;
 	unsigned char	pad[12];
 };
 
 /* eof_flags values */
 #define XFS_EOF_FLAGS_FORCE		0x01	/* force/wait mode scan */
+#define XFS_EOF_FLAGS_USRID		0x02	/* filter by user id */
+#define XFS_EOF_FLAGS_GRPID		0x04	/* filter by group id */
+#define XFS_EOF_FLAGS_PROJID		0x08	/* filter by project id */
+#define XFS_EOF_FLAGS_MINFILESIZE	0x10	/* minimum file size */
+
+#define XFS_EOF_VALID_QUOTA	(XFS_EOF_FLAGS_USRID|XFS_EOF_FLAGS_GRPID| \
+				 XFS_EOF_FLAGS_PROJID)
 
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 216ca7a..a7bf847 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1609,8 +1609,16 @@ xfs_file_ioctl(
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -XFS_ERROR(EFAULT);
 
+		if (((eofb.eof_flags & XFS_EOF_FLAGS_USRID) &&
+		     !XFS_IS_UQUOTA_ON(mp)) ||
+		    ((eofb.eof_flags & XFS_EOF_FLAGS_GRPID) &&
+		     !XFS_IS_GQUOTA_ON(mp)) ||
+		    ((eofb.eof_flags & XFS_EOF_FLAGS_PROJID) &&
+		     !XFS_IS_PQUOTA_ON(mp)))
+			return -XFS_ERROR(EINVAL);
+
 		flags = (eofb.eof_flags & XFS_EOF_FLAGS_FORCE) ? SYNC_WAIT : SYNC_TRYLOCK;
-		error = xfs_inodes_free_eofblocks(mp, flags);
+		error = xfs_inodes_free_eofblocks(mp, flags, &eofb);
 		return -error;
 	}
 
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 6854800..c9e1c16 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -1015,6 +1015,21 @@ xfs_reclaim_inodes_count(
 }
 
 STATIC int
+xfs_inode_match_quota_id(
+	struct xfs_inode	*ip,
+	struct xfs_eofblocks	*eofb)
+{
+	if (eofb->eof_flags & XFS_EOF_FLAGS_USRID)
+		return ip->i_d.di_uid == eofb->eof_id;
+	else if (eofb->eof_flags & XFS_EOF_FLAGS_GRPID)
+		return ip->i_d.di_gid == eofb->eof_id;
+	else if (eofb->eof_flags & XFS_EOF_FLAGS_PROJID)
+		return xfs_get_projid(ip) == eofb->eof_id;
+
+	return 0;
+}
+
+STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
@@ -1022,6 +1037,7 @@ xfs_inode_free_eofblocks(
 	void			*args)
 {
 	int ret;
+	struct xfs_eofblocks *eofb = args;
 	bool force = flags & SYNC_WAIT;
 
 	if (!xfs_can_free_eofblocks(ip, false)) {
@@ -1031,8 +1047,13 @@ xfs_inode_free_eofblocks(
 		return 0;
 	}
 
-	if (!force && mapping_tagged(VFS_I(ip)->i_mapping,
-				     PAGECACHE_TAG_DIRTY))
+	if ((eofb &&
+	     (((eofb->eof_flags & XFS_EOF_VALID_QUOTA) &&
+	       !xfs_inode_match_quota_id(ip, eofb)) || 
+	      ((eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE) &&
+	       (XFS_ISIZE(ip) < eofb->eof_min_file_size)))) ||
+	    (!force && mapping_tagged(VFS_I(ip)->i_mapping,
+				      PAGECACHE_TAG_DIRTY)))
 		return 0;
 
 	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
@@ -1047,11 +1068,12 @@ xfs_inode_free_eofblocks(
 int
 xfs_inodes_free_eofblocks(
 	struct xfs_mount	*mp,
-	int			flags)
+	int			flags,
+	struct xfs_eofblocks	*eofb)
 {
 	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
 	return xfs_inode_ag_iterator_tag(mp, xfs_inode_free_eofblocks, flags,
-					 NULL, XFS_ICI_EOFBLOCKS_TAG);
+					 eofb, XFS_ICI_EOFBLOCKS_TAG);
 }
 
 void
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 307654a..167f06c 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -45,7 +45,7 @@ void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct xfs_perag *pag,
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
-int xfs_inodes_free_eofblocks(struct xfs_mount *, int);
+int xfs_inodes_free_eofblocks(struct xfs_mount *, int, struct xfs_eofblocks *);
 
 int xfs_sync_inode_grab(struct xfs_inode *ip);
 int xfs_inode_ag_iterator(struct xfs_mount *mp,
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
