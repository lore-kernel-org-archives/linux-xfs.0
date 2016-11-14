Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48362 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753899AbcKNRM6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 12:12:58 -0500
Received: from [83.175.99.196] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6KoT-00055l-3R
        for linux-xfs@vger.kernel.org; Mon, 14 Nov 2016 17:12:57 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/14] xfs: new inode extent list lookup helpers
Date: Mon, 14 Nov 2016 18:12:32 +0100
Message-Id: <1479143565-30615-2-git-send-email-hch@lst.de>
In-Reply-To: <1479143565-30615-1-git-send-email-hch@lst.de>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_iext_lookup_extent looks up a single extent at the passed in offset,
and returns the extent covering the area, or the one behind it in case
of a hole, as well as the index of the returned extent in arguments,
as well as a simple bool as return value that is set to false if no
extent could be found because the offset is behind EOF.  It is a simpler
replacement for xfs_bmap_search_extent that leaves looking up the rarely
needed previous extent to the caller and has a nicer calling convention.

xfs_iext_get_extent is a helper for iterating over the extent list,
it takes an extent index as input, and returns the extent at that index
in it's expanded form in an argument if it exists.  The actual return
value is a bool whether the index is valid or not.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 46 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |  6 ++++++
 2 files changed, 52 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 5fbe24c..749fbfb 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -2003,3 +2003,49 @@ xfs_ifork_init_cow(
 	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
 	ip->i_cnextents = 0;
 }
+
+/*
+ * Lookup the extent covering bno.
+ *
+ * If there is an extent covering bno return the extent index, and store the
+ * expanded extent structure in *gotp, and the extent indes in *idx.
+ * If there is no extent covering bno, but there is an extent after it (e.g.
+ * it lies in a hole) return that extent in *gotp and its index in *idx
+ * instead.
+ * If bno is beyond the last extent return false, and return the index after
+ * the last valid index in *idxp.
+ */
+bool
+xfs_iext_lookup_extent(
+	struct xfs_inode	*ip,
+	struct xfs_ifork	*ifp,
+	xfs_fileoff_t		bno,
+	xfs_extnum_t		*idxp,
+	struct xfs_bmbt_irec	*gotp)
+{
+	struct xfs_bmbt_rec_host *ep;
+
+	XFS_STATS_INC(ip->i_mount, xs_look_exlist);
+
+	ep = xfs_iext_bno_to_ext(ifp, bno, idxp);
+	if (!ep)
+		return false;
+	xfs_bmbt_get_all(ep, gotp);
+	return true;
+}
+
+/*
+ * Return true if there is an extent at index idx, and return the expanded
+ * extent structure at idx in that case.  Else return false.
+ */
+bool
+xfs_iext_get_extent(
+	struct xfs_ifork	*ifp,
+	xfs_extnum_t		idx,
+	struct xfs_bmbt_irec	*gotp)
+{
+	if (idx < 0 || idx >= xfs_iext_count(ifp))
+		return false;
+	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), gotp);
+	return true;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 8bf112e..7fb8365 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -182,6 +182,12 @@ void		xfs_iext_irec_compact_pages(struct xfs_ifork *);
 void		xfs_iext_irec_compact_full(struct xfs_ifork *);
 void		xfs_iext_irec_update_extoffs(struct xfs_ifork *, int, int);
 
+bool		xfs_iext_lookup_extent(struct xfs_inode *ip,
+			struct xfs_ifork *ifp, xfs_fileoff_t bno,
+			xfs_extnum_t *idxp, struct xfs_bmbt_irec *gotp);
+bool		xfs_iext_get_extent(struct xfs_ifork *ifp, xfs_extnum_t idx,
+			struct xfs_bmbt_irec *gotp);
+
 extern struct kmem_zone	*xfs_ifork_zone;
 
 extern void xfs_ifork_init_cow(struct xfs_inode *ip);
-- 
2.1.4

