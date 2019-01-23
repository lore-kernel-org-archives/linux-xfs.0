Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbfAWSle (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Jan 2019 13:41:34 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3F1FA8F4
        for <linux-xfs@vger.kernel.org>; Wed, 23 Jan 2019 18:41:33 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E2D01001F3D
        for <linux-xfs@vger.kernel.org>; Wed, 23 Jan 2019 18:41:33 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 5/6] xfs: create delalloc bmapi wrapper for full extent allocation
Date: Wed, 23 Jan 2019 13:41:30 -0500
Message-Id: <20190123184131.46188-6-bfoster@redhat.com>
In-Reply-To: <20190123184131.46188-1-bfoster@redhat.com>
References: <20190123184131.46188-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The writeback delalloc conversion code is racy with respect to
changes in the currently cached file mapping. This stems from the
fact that the bmapi allocation code requires a file range to
allocate and the writeback conversion code assumes the range of the
currently cached mapping is still valid with respect to the fork. It
may not be valid, however, because the ilock is cycled (potentially
multiple times) between the time the cached mapping was populated
and the delalloc conversion occurs.

To facilitate a solution to this problem, create a new
xfs_bmapi_delalloc() wrapper to xfs_bmapi_write() that takes a file
(FSB) offset and attempts to allocate whatever delalloc extent backs
the offset. Use a new bmapi flag to cause xfs_bmapi_write() to set
the range based on the extent backing the bno parameter unless bno
lands in a hole. If bno does land in a hole, fall back to the
current behavior (which may result in an error or quietly skipping
holes in the specified range depending on other parameters). This
patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 48 ++++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_bmap.h |  4 ++++
 2 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4c73927819c2..856de22439a3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4286,10 +4286,6 @@ xfs_bmapi_write(
 			goto error0;
 	}
 
-	n = 0;
-	end = bno + len;
-	obno = bno;
-
 	if (!xfs_iext_lookup_extent(ip, ifp, bno, &bma.icur, &bma.got))
 		eof = true;
 	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
@@ -4299,6 +4295,26 @@ xfs_bmapi_write(
 	bma.total = total;
 	bma.datatype = 0;
 
+	/*
+	 * The reval flag means the caller wants to allocate the entire delalloc
+	 * extent backing bno where bno may not necessarily match the startoff.
+	 * Now that we've looked up the extent, reset the range to map based on
+	 * the extent in the file. If we're in a hole, this may be an error so
+	 * don't adjust anything.
+	 */
+	if ((flags & XFS_BMAPI_REVALRANGE) &&
+	    !eof && bno >= bma.got.br_startoff) {
+		ASSERT(flags & XFS_BMAPI_DELALLOC);
+		bno = bma.got.br_startoff;
+		len = bma.got.br_blockcount;
+#ifdef DEBUG
+		orig_bno = bno;
+		orig_len = len;
+#endif
+	}
+	n = 0;
+	end = bno + len;
+	obno = bno;
 	while (bno < end && n < *nmap) {
 		bool			need_alloc = false, wasdelay = false;
 
@@ -4455,6 +4471,30 @@ xfs_bmapi_write(
 	return error;
 }
 
+/*
+ * Convert an existing delalloc extent to real blocks based on file offset. This
+ * attempts to allocate the entire delalloc extent and may require multiple
+ * invocations to allocate the target offset if a large enough physical extent
+ * is not available.
+ */
+int
+xfs_bmapi_delalloc(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		bno,
+	int			flags,
+	xfs_extlen_t		total,
+	struct xfs_bmbt_irec	*imap,
+	int			*nimaps)
+{
+	/*
+	 * The reval flag means to allocate the entire extent; pass a dummy
+	 * length of 1.
+	 */
+	flags |= XFS_BMAPI_REVALRANGE;
+	return xfs_bmapi_write(tp, ip, bno, 1, flags, total, imap, nimaps);
+}
+
 int
 xfs_bmapi_remap(
 	struct xfs_trans	*tp,
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b4ff710d7250..a53eb3d527e2 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -107,6 +107,8 @@ struct xfs_extent_free_item
 /* Do not update the rmap btree.  Used for reconstructing bmbt from rmapbt. */
 #define XFS_BMAPI_NORMAP	0x2000
 
+#define XFS_BMAPI_REVALRANGE	0x4000
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -227,6 +229,8 @@ int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
 		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
 		int eof);
+int	xfs_bmapi_delalloc(struct xfs_trans *, struct xfs_inode *,
+		xfs_fileoff_t, int, xfs_extlen_t, struct xfs_bmbt_irec *, int *);
 
 static inline void
 xfs_bmap_add_free(
-- 
2.17.2
