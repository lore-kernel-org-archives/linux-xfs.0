Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF8327CCB
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 01:23:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 678F78F8040
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 23:23:04 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	rbHkPaoOPcECfCwM for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2016 23:23:01 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] iomap: add fiemap support for attribute mappings
Date: Mon,  8 Aug 2016 16:22:31 +1000
Message-Id: <1470637351-27933-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1470637351-27933-1-git-send-email-david@fromorbit.com>
References: <1470637351-27933-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Prior to the iomap conversion, XFS supported the FIEMAP_FLAG_XATTR
flag for mapping the attribute fork block map. This flag was not
added to the iomap fiemap support so we have regressed fiemap
functionality with this change.

Add an iomap control flag to indicate that we should be operating
on the attribute map rather than the file data map and pass it from
iomap_fiemap() as appropriate. Add the appropriate flags to the XFS
code to switch to the attribute fork lookup, and ensure we return
EINVAL if anyone attempts a write mapping of the attribute fork.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c            | 11 +++++++++--
 fs/xfs/xfs_iomap.c    | 14 +++++++++++++-
 include/linux/iomap.h |  1 +
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 189742b..2a04e5e 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -461,12 +461,13 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 {
 	struct fiemap_ctx ctx;
 	loff_t ret;
+	int flags = 0;
 
 	memset(&ctx, 0, sizeof(ctx));
 	ctx.fi = fi;
 	ctx.prev.type = IOMAP_HOLE;
 
-	ret = fiemap_check_flags(fi, FIEMAP_FLAG_SYNC);
+	ret = fiemap_check_flags(fi, FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR);
 	if (ret)
 		return ret;
 
@@ -476,9 +477,15 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 			return ret;
 	}
 
+	if (fi->fi_flags & FIEMAP_FLAG_XATTR)
+		flags |= IOMAP_ATTR;
+
 	while (len > 0) {
-		ret = iomap_apply(inode, start, len, 0, ops, &ctx,
+		ret = iomap_apply(inode, start, len, flags, ops, &ctx,
 				iomap_fiemap_actor);
+		/* inode with no attribute mapping will give ENOENT */
+		if (ret == -ENOENT)
+			break;
 		if (ret < 0)
 			return ret;
 		if (ret == 0)
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4398932..17b5b82 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -993,10 +993,22 @@ xfs_file_iomap_begin(
 	struct xfs_bmbt_irec	imap;
 	xfs_fileoff_t		offset_fsb, end_fsb;
 	int			nimaps = 1, error = 0;
+	int			bmflags = XFS_BMAPI_ENTIRE;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	/* Attribute fork can only be read via this interface */
+	if (flags & IOMAP_ATTR) {
+		if (flags & ~IOMAP_ATTR)
+			return -EINVAL;
+		/* if there are no attribute fork or extents, return ENOENT */
+		if (!XFS_IFORK_Q(ip) || !ip->i_d.di_anextents)
+			return -ENOENT;
+		ASSERT(ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL);
+		bmflags |= XFS_BMAPI_ATTRFORK;
+	}
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	ASSERT(offset <= mp->m_super->s_maxbytes);
@@ -1006,7 +1018,7 @@ xfs_file_iomap_begin(
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
-			       &nimaps, XFS_BMAPI_ENTIRE);
+			       &nimaps, bmflags);
 	if (error) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		return error;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3267df4..00a5477 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -36,6 +36,7 @@ struct iomap {
  */
 #define IOMAP_WRITE		(1 << 0)
 #define IOMAP_ZERO		(1 << 1)
+#define IOMAP_ATTR		(1 << 2)	/* operate on attributes */
 
 struct iomap_ops {
 	/*
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
