Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BD8F67FBB
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:41:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 824208F8035
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 22:41:27 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	U2WrJL2mIBvqsmrD for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 22:41:25 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VgU8O-0005bs-9e
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VgU8O-0006jB-7p
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 23/36] db: verify and calculate inode CRCs
Date: Wed, 13 Nov 2013 17:40:47 +1100
Message-Id: <1384324860-25677-24-git-send-email-david@fromorbit.com>
In-Reply-To: <1384324860-25677-1-git-send-email-david@fromorbit.com>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
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

When we set the current IO cursor to point at an inode, verify that
the inode CRC is intact. And prior to writing such an IO cursor,
calculate the inode CRC.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 2d1cc56..6e3282e 100644
--- a/db/io.c
+++ b/db/io.c
@@ -464,6 +464,9 @@ write_cur(void)
 		return;
 	}
 
+	if (iocur_top->ino_buf)
+		libxfs_dinode_calc_crc(mp, iocur_top->data);
+
 	if (iocur_top->bbmap)
 		write_cur_bbs();
 	else
@@ -536,6 +539,7 @@ set_cur(
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
index b097bd2..cbb5757 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -748,6 +748,10 @@ void	xfs_dinode_from_disk(struct xfs_icdinode *,
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
