Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 147FB7F88
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:31:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C81A38F8035
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:31:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EPcU6PaXxKl7UuZq for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 05:31:10 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UFOM6-0001Rb-2b
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:30:58 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UFOM5-0002Lp-Vr
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:30:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/21] xfs: take inode version into account in XFS_LITINO
Date: Tue, 12 Mar 2013 23:30:36 +1100
Message-Id: <1363091454-8852-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1363091454-8852-1-git-send-email-david@fromorbit.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@lst.de>

Add a version argument to XFS_LITINO so that it can return different values
depending on the inode version.  This is required for the upcoming v3 inodes
with a larger fixed layout dinode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_attr_leaf.c |    6 ++++--
 fs/xfs/xfs_bmap.c      |    4 ++--
 fs/xfs/xfs_dinode.h    |    6 +++---
 fs/xfs/xfs_inode.h     |    5 +++--
 fs/xfs/xfs_vnodeops.c  |    2 +-
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index ee24993..f96a734 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -172,7 +172,8 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 	int dsize;
 	xfs_mount_t *mp = dp->i_mount;
 
-	offset = (XFS_LITINO(mp) - bytes) >> 3; /* rounded down */
+	/* rounded down */
+	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
 
 	switch (dp->i_d.di_format) {
 	case XFS_DINODE_FMT_DEV:
@@ -243,7 +244,8 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
-	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
+	maxforkoff = XFS_LITINO(mp, dp->i_d.di_version) -
+			XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
 	if (offset >= maxforkoff)
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index d490fe8..20efb39 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -228,13 +228,13 @@ xfs_default_attroffset(
 	uint			offset;
 
 	if (mp->m_sb.sb_inodesize == 256) {
-		offset = XFS_LITINO(mp) -
+		offset = XFS_LITINO(mp, ip->i_d.di_version) -
 				XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	} else {
 		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
 	}
 
-	ASSERT(offset < XFS_LITINO(mp));
+	ASSERT(offset < XFS_LITINO(mp, ip->i_d.di_version));
 	return offset;
 }
 
diff --git a/fs/xfs/xfs_dinode.h b/fs/xfs/xfs_dinode.h
index 1d9643b..88a3368 100644
--- a/fs/xfs/xfs_dinode.h
+++ b/fs/xfs/xfs_dinode.h
@@ -104,7 +104,7 @@ typedef enum xfs_dinode_fmt {
 /*
  * Inode size for given fs.
  */
-#define XFS_LITINO(mp) \
+#define XFS_LITINO(mp, version) \
 	((int)(((mp)->m_sb.sb_inodesize) - sizeof(struct xfs_dinode)))
 
 #define	XFS_BROOT_SIZE_ADJ	\
@@ -119,10 +119,10 @@ typedef enum xfs_dinode_fmt {
 #define XFS_DFORK_DSIZE(dip,mp) \
 	(XFS_DFORK_Q(dip) ? \
 		XFS_DFORK_BOFF(dip) : \
-		XFS_LITINO(mp))
+		XFS_LITINO(mp, (dip)->di_version))
 #define XFS_DFORK_ASIZE(dip,mp) \
 	(XFS_DFORK_Q(dip) ? \
-		XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : \
+		XFS_LITINO(mp, (dip)->di_version) - XFS_DFORK_BOFF(dip) : \
 		0)
 #define XFS_DFORK_SIZE(dip,mp,w) \
 	((w) == XFS_DATA_FORK ? \
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 237e7f6..b8520b5 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -180,10 +180,11 @@ typedef struct xfs_icdinode {
 #define XFS_IFORK_DSIZE(ip) \
 	(XFS_IFORK_Q(ip) ? \
 		XFS_IFORK_BOFF(ip) : \
-		XFS_LITINO((ip)->i_mount))
+		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version))
 #define XFS_IFORK_ASIZE(ip) \
 	(XFS_IFORK_Q(ip) ? \
-		XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : \
+		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version) - \
+			XFS_IFORK_BOFF(ip) : \
 		0)
 #define XFS_IFORK_SIZE(ip,w) \
 	((w) == XFS_DATA_FORK ? \
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 77ad748..aa0c066 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1420,7 +1420,7 @@ xfs_symlink(
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
 	 */
-	if (pathlen <= XFS_LITINO(mp))
+	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
 		fs_blocks = 0;
 	else
 		fs_blocks = XFS_B_TO_FSB(mp, pathlen);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
