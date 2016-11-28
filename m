Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19779 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754134AbcK1TJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Nov 2016 14:09:44 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A5F6561E4C
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 19:09:43 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uASJ9hEc032612
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 14:09:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/6] xfs: fiemap support for cow fork
Date: Mon, 28 Nov 2016 14:09:36 -0500
Message-Id: <1480360181-20396-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
References: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The XFS reflink implementation adds a copy-on-write inode fork to track
newly allocated extents used to replace shared blocks on write. While,
in principle, these extents are tracked by the cow fork temporarily,
fragmentation avoidance mechanisms like the cowextsize hint and COW fork
speculative preallocation allocate additional blocks outside of the
range of the write. This means that blocks in the COW fork can linger
for some time until written to and remapped to the data fork or reaped
by the background cow fork reclaimer.

To facilitate development and debugging, define and wire up a fiemap
flag to query the cow fork extent list of an inode. Note that fiemap
triggers writeback, which means all COW fork extents that are the target
of I/O are remapped to the data fork as part of the query. As a result,
the cow fork fiemap request returns only the blocks that have been
allocated and not yet written to or reclaimed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c          | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.h          |  1 +
 fs/xfs/xfs_iops.c           |  4 ++++
 include/uapi/linux/fiemap.h |  1 +
 4 files changed, 51 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 15a83813..4f46f49 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1159,3 +1159,48 @@ xfs_xattr_iomap_begin(
 struct iomap_ops xfs_xattr_iomap_ops = {
 	.iomap_begin		= xfs_xattr_iomap_begin,
 };
+
+static int
+xfs_cow_iomap_begin(
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
+	int			error = 0;
+	int			nimaps = 1;
+	unsigned		lockmode;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	lockmode = xfs_ilock_data_map_shared(ip);
+
+	if (!xfs_is_reflink_inode(ip)) {
+		error = -ENOENT;
+		goto out_unlock;
+	}
+
+	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
+			       &nimaps, XFS_BMAPI_ENTIRE | XFS_BMAPI_COWFORK);
+
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
+struct iomap_ops xfs_cow_iomap_ops = {
+	.iomap_begin		= xfs_cow_iomap_begin,
+};
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 6d45cf0..69b62e4 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -35,5 +35,6 @@ xfs_extlen_t xfs_eof_alignment(struct xfs_inode *ip, xfs_extlen_t extsize);
 
 extern struct iomap_ops xfs_iomap_ops;
 extern struct iomap_ops xfs_xattr_iomap_ops;
+extern struct iomap_ops xfs_cow_iomap_ops;
 
 #endif /* __XFS_IOMAP_H__*/
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 405a65c..517eeed 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1043,6 +1043,10 @@ xfs_vn_fiemap(
 		fieinfo->fi_flags &= ~FIEMAP_FLAG_XATTR;
 		error = iomap_fiemap(inode, fieinfo, start, length,
 				&xfs_xattr_iomap_ops);
+	} else if (fieinfo->fi_flags & FIEMAP_FLAG_COW) {
+		fieinfo->fi_flags &= ~FIEMAP_FLAG_COW;
+		error = iomap_fiemap(inode, fieinfo, start, length,
+				&xfs_cow_iomap_ops);
 	} else {
 		error = iomap_fiemap(inode, fieinfo, start, length,
 				&xfs_iomap_ops);
diff --git a/include/uapi/linux/fiemap.h b/include/uapi/linux/fiemap.h
index 0c51d61..7014b4c 100644
--- a/include/uapi/linux/fiemap.h
+++ b/include/uapi/linux/fiemap.h
@@ -41,6 +41,7 @@ struct fiemap {
 #define FIEMAP_FLAG_SYNC	0x00000001 /* sync file data before map */
 #define FIEMAP_FLAG_XATTR	0x00000002 /* map extended attribute tree */
 #define FIEMAP_FLAG_CACHE	0x00000004 /* request caching of the extents */
+#define FIEMAP_FLAG_COW		0x00000010 /* map cow fork extents */
 
 #define FIEMAP_FLAGS_COMPAT	(FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR)
 
-- 
2.7.4

