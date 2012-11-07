Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA7HHQw5163792 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 11:17:26 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S0h2HpfnpKmupN7L for
	<xfs@oss.sgi.com>; Wed, 07 Nov 2012 09:19:23 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA7HJMR1007721
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 12:19:23 -0500
Received: from bfoster.bfoster (dhcp-191-48.bos.redhat.com [10.16.191.48])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id qA7HJMAK008728
	for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 12:19:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v7 07/10] xfs: add inode id filtering to eofblocks scan
Date: Wed,  7 Nov 2012 12:21:13 -0500
Message-Id: <1352308874-64562-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1352308874-64562-1-git-send-email-bfoster@redhat.com>
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352308874-64562-1-git-send-email-bfoster@redhat.com>
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

Support inode ID filtering in the eofblocks scan. The caller must
set the associated XFS_EOF_FLAGS_*ID bit and ID field.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---

v7:
- Separate padding into two fields to explicitly handle alignment requirements.
- Fix up style of flags defines.

 fs/xfs/xfs_fs.h     |   14 ++++++++++++--
 fs/xfs/xfs_icache.c |   22 ++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c  |    3 ++-
 3 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 26ff43a..7113564 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -345,13 +345,23 @@ typedef struct xfs_error_injection {
 struct xfs_eofblocks {
 	__u32		eof_version;
 	__u32		eof_flags;
-	__u64		pad[15];
+	uid_t		eof_uid;
+	gid_t		eof_gid;
+	prid_t		eof_prid;
+	__u32		pad32;
+	__u64		pad64[13];
 };
 
 /* eof_flags values */
 #define XFS_EOF_FLAGS_SYNC		(1 << 0) /* sync/wait mode scan */
+#define XFS_EOF_FLAGS_UID		(1 << 1) /* filter by uid */
+#define XFS_EOF_FLAGS_GID		(1 << 2) /* filter by gid */
+#define XFS_EOF_FLAGS_PRID		(1 << 3) /* filter by project id */
 #define XFS_EOF_FLAGS_VALID	\
-	(XFS_EOF_FLAGS_SYNC)
+	(XFS_EOF_FLAGS_SYNC |	\
+	 XFS_EOF_FLAGS_UID |	\
+	 XFS_EOF_FLAGS_GID |	\
+	 XFS_EOF_FLAGS_PRID)
 
 
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b79aebe..393cd36 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1171,6 +1171,21 @@ xfs_reclaim_inodes_count(
 }
 
 STATIC int
+xfs_inode_match_id(
+	struct xfs_inode	*ip,
+	struct xfs_eofblocks	*eofb)
+{
+	if (eofb->eof_flags & XFS_EOF_FLAGS_UID)
+		return ip->i_d.di_uid == eofb->eof_uid;
+	else if (eofb->eof_flags & XFS_EOF_FLAGS_GID)
+		return ip->i_d.di_gid == eofb->eof_gid;
+	else if (eofb->eof_flags & XFS_EOF_FLAGS_PRID)
+		return xfs_get_projid(ip) == eofb->eof_prid;
+
+	return 0;
+}
+
+STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
@@ -1178,6 +1193,7 @@ xfs_inode_free_eofblocks(
 	void			*args)
 {
 	int ret;
+	struct xfs_eofblocks *eofb = args;
 
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
@@ -1194,6 +1210,12 @@ xfs_inode_free_eofblocks(
 	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
+	if (eofb &&
+	    (eofb->eof_flags & (XFS_EOF_FLAGS_UID|XFS_EOF_FLAGS_GID|
+			       XFS_EOF_FLAGS_PRID)) &&
+	    !xfs_inode_match_id(ip, eofb))
+		return 0;
+
 	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
 
 	/* don't revisit the inode if we're not waiting */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5b20ab0..c1c3ef8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1615,7 +1615,8 @@ xfs_file_ioctl(
 		if (eofb.eof_flags & ~XFS_EOF_FLAGS_VALID)
 			return -XFS_ERROR(EINVAL);
 
-		if (memchr_inv(eofb.pad, 0, sizeof(eofb.pad)))
+		if (memchr_inv(&eofb.pad32, 0, sizeof(eofb.pad32)) ||
+		    memchr_inv(eofb.pad64, 0, sizeof(eofb.pad64)))
 			return -XFS_ERROR(EINVAL);
 
 		error = xfs_icache_free_eofblocks(mp, &eofb);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
