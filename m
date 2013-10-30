Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ECF447F73
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:31:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88F20AC0A3
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:31:37 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IlkMFeJjVDHkv4Ip for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:31:36 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VbNRF-0002ys-Sn
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:26 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VbNRF-0007ez-SF
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 20/30] db: verify and calculate inode CRCs
Date: Wed, 30 Oct 2013 15:31:11 +1100
Message-Id: <1383107481-28937-21-git-send-email-david@fromorbit.com>
In-Reply-To: <1383107481-28937-1-git-send-email-david@fromorbit.com>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When we set the current Io cursor to point at an inode, verify that
the inode CRC is intact. And prior to writing such an IO cursor,
calculate the inode CRC.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/inode.c             | 2 ++
 db/io.c                | 4 ++++
 db/io.h                | 6 +++++-
 include/libxfs.h       | 4 ++++
 libxfs/xfs_inode_buf.c | 8 ++++----
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/db/inode.c b/db/inode.c
index ec533ee..4090855 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -655,6 +655,8 @@ set_cur_inode(
 		blkbb, DB_RING_IGN, NULL);
 	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
 	dip = iocur_top->data;
+	iocur_top->ino_crc_ok = libxfs_dinode_verify(mp, ino, dip);
+	iocur_top->ino_buf = 1;
 	iocur_top->ino = ino;
 	iocur_top->mode = be16_to_cpu(dip->di_mode);
 	if ((iocur_top->mode & S_IFMT) == S_IFDIR)
diff --git a/db/io.c b/db/io.c
index c9452f2..8ddb5e5 100644
--- a/db/io.c
+++ b/db/io.c
@@ -462,6 +462,9 @@ write_cur(void)
 		return;
 	}
 
+	if (iocur_top->ino_buf)
+		libxfs_dinode_calc_crc(mp, iocur_top->data);
+
 	if (iocur_top->bbmap)
 		write_cur_bbs();
 	else
@@ -534,6 +537,7 @@ set_cur(
 	iocur_top->ino = ino;
 	iocur_top->dirino = dirino;
 	iocur_top->mode = mode;
+	iocur_top->ino_buf = 0;
 
 	/* store location in ring */
 	if (ring_flag)
diff --git a/db/io.h b/db/io.h
index d647284..1f8270d 100644
--- a/db/io.h
+++ b/db/io.h
@@ -38,6 +38,8 @@ typedef struct iocur {
 	const struct typ	*typ;	/* type of "data" */
 	bbmap_t			*bbmap;	/* map daddr if fragmented */
 	struct xfs_buf		*bp;	/* underlying buffer */
+	int			ino_crc_ok:1;
+	int			ino_buf:1;
 } iocur_t;
 
 #define DB_RING_ADD 1                   /* add to ring on set_cur */
@@ -62,5 +64,7 @@ extern void     ring_add(void);
 static inline bool
 iocur_crc_valid()
 {
-	return (iocur_top->bp && iocur_top->bp->b_error != EFSCORRUPTED);
+	return (iocur_top->bp &&
+		iocur_top->bp->b_error != EFSCORRUPTED &&
+		(!iocur_top->ino_buf || iocur_top->ino_crc_ok));
 }
diff --git a/include/libxfs.h b/include/libxfs.h
index 08fd0b3..d28ac48 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -755,6 +755,10 @@ void	xfs_dinode_from_disk(struct xfs_icdinode *,
 #define libxfs_idata_realloc		xfs_idata_realloc
 #define libxfs_idestroy_fork		xfs_idestroy_fork
 
+#define libxfs_dinode_verify		xfs_dinode_verify
+bool xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
+		       struct xfs_dinode *dip);
+
 /* xfs_sb.h */
 #define libxfs_mod_sb			xfs_mod_sb
 #define libxfs_sb_from_disk		xfs_sb_from_disk
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index b796556..728ef71 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -276,10 +276,10 @@ xfs_dinode_to_disk(
 	}
 }
 
-static bool
+bool
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
-	struct xfs_inode	*ip,
+	xfs_ino_t		ino,
 	struct xfs_dinode	*dip)
 {
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
@@ -294,7 +294,7 @@ xfs_dinode_verify(
 	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 			      offsetof(struct xfs_dinode, di_crc)))
 		return false;
-	if (be64_to_cpu(dip->di_ino) != ip->i_ino)
+	if (be64_to_cpu(dip->di_ino) != ino)
 		return false;
 	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_uuid))
 		return false;
@@ -346,7 +346,7 @@ xfs_iread(
 		return error;
 
 	/* even unallocated inodes are verified */
-	if (!xfs_dinode_verify(mp, ip, dip)) {
+	if (!xfs_dinode_verify(mp, ip->i_ino, dip)) {
 		xfs_alert(mp, "%s: validation failed for inode %lld failed",
 				__func__, ip->i_ino);
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
