Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44434 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfBRJSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 04:18:41 -0500
Received: from [88.128.83.71] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvf4R-0002g7-He
        for linux-xfs@vger.kernel.org; Mon, 18 Feb 2019 09:18:39 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/8] xfs: fix SEEK_DATA for speculative COW fork preallocation
Date: Mon, 18 Feb 2019 10:18:21 +0100
Message-Id: <20190218091827.12619-3-hch@lst.de>
In-Reply-To: <20190218091827.12619-1-hch@lst.de>
References: <20190218091827.12619-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We speculatively allocate extents in the COW fork to reduce
fragmentation.  But when we write data into such COW fork blocks that
do now shadow an allocation in the data fork SEEK_DATA will not
correctly report it, as it only looks at the data fork extents.
The only reason why that hasn't been an issue so far is because
we even use these speculative COW fork preallocations over holes in
the data fork at all for buffered writes, and blocks in the COW
fork that are written by direct writes are moved into the data
fork immediately at I/O completion time.

Add a new set of iomap_ops for SEEK_HOLE/SEEK_DATA which looks into
both the COW and data fork, and reports all COW extents as unwritten
to the iomap layer.  While this isn't strictly true for COW fork
extents that were already converted to real extents, the practical
semantics that you can't read data from them until they are moved
into the data fork are very similar, and this will force the iomap
layer into probing the extents for actually present data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  |  4 +--
 fs/xfs/xfs_iomap.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.h |  1 +
 3 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e47425071e65..1d07dcfbbff3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1068,10 +1068,10 @@ xfs_file_llseek(
 	default:
 		return generic_file_llseek(file, offset, whence);
 	case SEEK_HOLE:
-		offset = iomap_seek_hole(inode, offset, &xfs_iomap_ops);
+		offset = iomap_seek_hole(inode, offset, &xfs_seek_iomap_ops);
 		break;
 	case SEEK_DATA:
-		offset = iomap_seek_data(inode, offset, &xfs_iomap_ops);
+		offset = iomap_seek_data(inode, offset, &xfs_seek_iomap_ops);
 		break;
 	}
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 284c5e68f695..a7599b084571 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1068,6 +1068,91 @@ const struct iomap_ops xfs_iomap_ops = {
 	.iomap_end		= xfs_file_iomap_end,
 };
 
+static int
+xfs_seek_iomap_begin(
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
+	xfs_fileoff_t		cow_fsb = NULLFILEOFF, data_fsb = NULLFILEOFF;
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	imap, cmap;
+	int			error = 0;
+	unsigned		lockmode;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	lockmode = xfs_ilock_data_map_shared(ip);
+	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, &imap)) {
+		/*
+		 * If we found a data extent we are done.
+		 */
+		if (imap.br_startoff <= offset_fsb)
+			goto done;
+		data_fsb = imap.br_startoff;
+	} else {
+		/*
+		 * Fake a hole until the end of the file.
+		 */
+		data_fsb = min(XFS_B_TO_FSB(mp, offset + length),
+			       XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes));
+	}
+
+	/*
+	 * If a COW fork extent covers the hole, report it - capped to the next
+	 * data fork extent:
+	 */
+	if (xfs_inode_has_cow_data(ip) &&
+	    xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
+		cow_fsb = cmap.br_startoff;
+	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
+		if (data_fsb < cow_fsb + cmap.br_blockcount)
+			end_fsb = min(end_fsb, data_fsb);
+		xfs_trim_extent(&cmap, offset_fsb, end_fsb);
+		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, true);
+		/*
+		 * Force page cache probing to avoid reporting COW extents as
+		 * data even if they haven't been written to:
+		 */
+		iomap->type = IOMAP_UNWRITTEN;
+		goto out_unlock;
+	}
+
+	/*
+	 * Else report a hole, capped to the next found data or COW extent.
+	 */
+	if (cow_fsb != NULLFILEOFF && cow_fsb < data_fsb)
+		imap.br_blockcount = cow_fsb - offset_fsb;
+	else
+		imap.br_blockcount = data_fsb - offset_fsb;
+	imap.br_startoff = offset_fsb;
+	imap.br_startblock = HOLESTARTBLOCK;
+	imap.br_state = XFS_EXT_NORM;
+done:
+	xfs_trim_extent(&imap, offset_fsb, end_fsb);
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, false);
+out_unlock:
+	xfs_iunlock(ip, lockmode);
+	return error;
+}
+
+const struct iomap_ops xfs_seek_iomap_ops = {
+	.iomap_begin		= xfs_seek_iomap_begin,
+};
+
 static int
 xfs_xattr_iomap_begin(
 	struct inode		*inode,
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 37b584c3069b..5c2f6aa6d78f 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -40,6 +40,7 @@ xfs_aligned_fsb_count(
 }
 
 extern const struct iomap_ops xfs_iomap_ops;
+extern const struct iomap_ops xfs_seek_iomap_ops;
 extern const struct iomap_ops xfs_xattr_iomap_ops;
 
 #endif /* __XFS_IOMAP_H__*/
-- 
2.20.1
