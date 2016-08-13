Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D6F87CA3
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 18:43:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1FCF88F8064
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:11 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 6akhNyKC4A9C5rRF (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:09 -0700 (PDT)
Received: from [107.17.164.165] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bYia5-0006Lb-Ds
	for xfs@oss.sgi.com; Sat, 13 Aug 2016 23:43:09 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/7] xfs: (re-)implement FIEMAP_FLAG_XATTR
Date: Sat, 13 Aug 2016 16:43:01 -0700
Message-Id: <1471131781-14107-8-git-send-email-hch@lst.de>
In-Reply-To: <1471131781-14107-1-git-send-email-hch@lst.de>
References: <1471131781-14107-1-git-send-email-hch@lst.de>
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

Use a special read-only iomap_ops implementation to support fiemap on
the attr fork.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.h |  1 +
 fs/xfs/xfs_iops.c  |  9 ++++++++-
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1cce760..697c8fd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1106,3 +1106,48 @@ struct iomap_ops xfs_iomap_ops = {
 	.iomap_begin		= xfs_file_iomap_begin,
 	.iomap_end		= xfs_file_iomap_end,
 };
+
+static int
+xfs_xattr_iomap_begin(
+	struct inode		*inode,
+	loff_t			offset,
+	loff_t			length,
+	unsigned		flags,
+	struct iomap		*iomap)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + length);
+	struct xfs_bmbt_irec	imap;
+	int			nimaps = 1, error = 0;
+	unsigned		lockmode;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	lockmode = xfs_ilock_data_map_shared(ip);
+
+	/* if there are no attribute fork or extents, return ENOENT */
+	if (XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
+		error = -ENOENT;
+		goto out_unlock;
+	}
+
+	ASSERT(ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL);
+	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
+			       &nimaps, XFS_BMAPI_ENTIRE | XFS_BMAPI_ATTRFORK);
+out_unlock:
+	xfs_iunlock(ip, lockmode);
+
+	if (!error) {
+		ASSERT(nimaps);
+		xfs_bmbt_to_iomap(ip, iomap, &imap);
+	}
+
+	return error;
+}
+
+struct iomap_ops xfs_xattr_iomap_ops = {
+	.iomap_begin		= xfs_xattr_iomap_begin,
+};
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index e066d04..fb8aca3 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -35,5 +35,6 @@ void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
 		struct xfs_bmbt_irec *);
 
 extern struct iomap_ops xfs_iomap_ops;
+extern struct iomap_ops xfs_xattr_iomap_ops;
 
 #endif /* __XFS_IOMAP_H__*/
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ab820f8..b24c310 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1009,7 +1009,14 @@ xfs_vn_fiemap(
 	int			error;
 
 	xfs_ilock(XFS_I(inode), XFS_IOLOCK_SHARED);
-	error = iomap_fiemap(inode, fieinfo, start, length, &xfs_iomap_ops);
+	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
+		fieinfo->fi_flags &= ~FIEMAP_FLAG_XATTR;
+		error = iomap_fiemap(inode, fieinfo, start, length,
+				&xfs_xattr_iomap_ops);
+	} else {
+		error = iomap_fiemap(inode, fieinfo, start, length,
+				&xfs_iomap_ops);
+	}
 	xfs_iunlock(XFS_I(inode), XFS_IOLOCK_SHARED);
 
 	return error;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
