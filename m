Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CAC837F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 16:13:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69310AC00B
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 14:13:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Hk5TAijveejMUGvW for
	<xfs@oss.sgi.com>; Tue, 25 Jun 2013 14:13:05 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfs: use xfs_eofblocks_internal for eofblocks scanning
Date: Tue, 25 Jun 2013 17:17:39 -0400
Message-Id: <1372195059-52738-1-git-send-email-bfoster@redhat.com>
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
To: dwight.engen@oracle.com
Cc: xfs@oss.sgi.com

Adds support for additional internal-only functionality to
eofblocks scans such as the scan_owner field. The scan owner
defines an optional inode number that is responsible for the
current scan. The purpose is to identify that an inode is under
iolock and as such, the iolock shouldn't be attempted when
trimming eof blocks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi Dwight,

Here's that patch I referred to... as you said, it's not really that
complicated, so take it or leave it. I suspect you'd have to drop the
eof_scan_owner bits (that's for my use case that is not upstream yet), change
over the uid/gid types, move the defs from xfs_fs.h into xfs_icache.h (I seem
to have got this wrong as well), then pull the conversion up into the ioctl
code rather than xfs_icache.c. It might just be easier to modify what you have
already...

Brian

 fs/xfs/xfs_fs.h     | 26 ++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c | 43 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 32cf913..6cc294b 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -370,6 +370,32 @@ struct xfs_eofblocks {
 	 XFS_EOF_FLAGS_MINFILESIZE | \
 	 XFS_EOF_FLAGS_FLUSH)
 
+struct xfs_eofblocks_internal {
+	__u32		eof_version;
+	__u32		eof_flags;
+	uid_t		eof_uid;
+	gid_t		eof_gid;
+	prid_t		eof_prid;
+	__u64		eof_min_file_size;
+	xfs_ino_t	eof_scan_owner;
+};
+
+static inline void
+xfs_eofb_to_internal(
+	struct xfs_eofblocks_internal *ei,
+	struct xfs_eofblocks *e,
+	xfs_ino_t ino)
+{
+	ei->eof_version = e->eof_version;
+	ei->eof_flags = e->eof_flags;
+	ei->eof_uid = e->eof_uid;
+	ei->eof_gid = e->eof_gid;
+	ei->eof_prid = e->eof_prid;
+	ei->eof_min_file_size = e->eof_min_file_size;
+
+	ei->eof_scan_owner = ino;
+}
+
 
 /*
  * The user-level Handle Request interface structure.
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 869988c..d6592bf 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1198,8 +1198,8 @@ xfs_reclaim_inodes_count(
 
 STATIC int
 xfs_inode_match_id(
-	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_inode		*ip,
+	struct xfs_eofblocks_internal	*eofb)
 {
 	if (eofb->eof_flags & XFS_EOF_FLAGS_UID &&
 	    ip->i_d.di_uid != eofb->eof_uid)
@@ -1224,7 +1224,8 @@ xfs_inode_free_eofblocks(
 	void			*args)
 {
 	int ret;
-	struct xfs_eofblocks *eofb = args;
+	struct xfs_eofblocks_internal *eofb = args;
+	bool need_iolock = true;
 
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
@@ -1244,6 +1245,16 @@ xfs_inode_free_eofblocks(
 
 		if (eofb->eof_flags & XFS_EOF_FLAGS_FLUSH)
 			filemap_flush(VFS_I(ip)->i_mapping);
+
+		/*
+		 * A scan owner implies we already hold the iolock. Skip it in
+		 * xfs_free_eofblocks() to avoid deadlock. This also eliminates
+		 * the possibility of EAGAIN being returned.
+		 */
+		if (eofb->eof_scan_owner != NULLFSINO &&
+		    eofb->eof_scan_owner == ip->i_ino)
+			need_iolock = false;
+
 	}
 
 	/*
@@ -1254,7 +1265,7 @@ xfs_inode_free_eofblocks(
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
-	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
+	ret = xfs_free_eofblocks(ip->i_mount, ip, need_iolock);
 
 	/* don't revisit the inode if we're not waiting */
 	if (ret == EAGAIN && !(flags & SYNC_WAIT))
@@ -1263,10 +1274,10 @@ xfs_inode_free_eofblocks(
 	return ret;
 }
 
-int
-xfs_icache_free_eofblocks(
-	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
+STATIC int
+__xfs_icache_free_eofblocks(
+	struct xfs_mount		*mp,
+	struct xfs_eofblocks_internal	*eofb)
 {
 	int flags = SYNC_TRYLOCK;
 
@@ -1277,6 +1288,22 @@ xfs_icache_free_eofblocks(
 					 eofb, XFS_ICI_EOFBLOCKS_TAG);
 }
 
+int
+xfs_icache_free_eofblocks(
+	struct xfs_mount	*mp,
+	struct xfs_eofblocks	*eofb)
+{
+	struct xfs_eofblocks_internal eofb_i;
+	struct xfs_eofblocks_internal *eofb_p = NULL;
+
+	if (eofb) {
+		xfs_eofb_to_internal(&eofb_i, eofb, NULLFSINO);
+		eofb_p = &eofb_i;
+	}
+
+	return __xfs_icache_free_eofblocks(mp, eofb_p);
+}
+
 void
 xfs_inode_set_eofblocks_tag(
 	xfs_inode_t	*ip)
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
