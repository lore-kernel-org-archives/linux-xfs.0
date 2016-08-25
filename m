Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9196A7DF0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:36:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 648A88F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:36:26 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id EtWm0t9z9JBLTqgC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:36:24 -0700 (PDT)
Subject: [PATCH 40/71] xfs: report shared extents through the iomap interface
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:36:17 -0700
Message-ID: <147216817787.867.4276938642586853650.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Report shared extents through the iomap interface so that FIEMAP
reports shared blocks accurately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c   |   19 ++++++++++++---
 fs/xfs/xfs_iomap.h   |    2 +-
 fs/xfs/xfs_pnfs.c    |    2 +-
 fs/xfs/xfs_reflink.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    3 ++
 5 files changed, 82 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 6065bde..130010a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -987,10 +987,13 @@ void
 xfs_bmbt_to_iomap(
 	struct xfs_inode	*ip,
 	struct iomap		*iomap,
-	struct xfs_bmbt_irec	*imap)
+	struct xfs_bmbt_irec	*imap,
+	bool			is_shared)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
+	if (is_shared)
+		iomap->flags |= IOMAP_F_SHARED;
 	if (imap->br_startblock == HOLESTARTBLOCK) {
 		iomap->blkno = IOMAP_NULL_BLOCK;
 		iomap->type = IOMAP_HOLE;
@@ -1028,6 +1031,7 @@ xfs_file_iomap_begin(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_bmbt_irec	imap;
 	xfs_fileoff_t		offset_fsb, end_fsb;
+	bool			shared, trimmed;
 	int			nimaps = 1, error = 0;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -1053,7 +1057,14 @@ xfs_file_iomap_begin(
 	}
 
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
-			       &nimaps, XFS_BMAPI_ENTIRE);
+			       &nimaps, 0);
+	if (error) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		return error;
+	}
+
+	/* Trim the mapping to the nearest shared extent boundary. */
+	error = xfs_reflink_trim_around_shared(ip, &imap, &shared, &trimmed);
 	if (error) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		return error;
@@ -1095,7 +1106,7 @@ xfs_file_iomap_begin(
 		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
 	}
 
-	xfs_bmbt_to_iomap(ip, iomap, &imap);
+	xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
 	return 0;
 }
 
@@ -1193,7 +1204,7 @@ out_unlock:
 
 	if (!error) {
 		ASSERT(nimaps);
-		xfs_bmbt_to_iomap(ip, iomap, &imap);
+		xfs_bmbt_to_iomap(ip, iomap, &imap, false);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 52f9c99..c04bf99 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -34,7 +34,7 @@ int xfs_iomap_cow_delay(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *);
 
 void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
-		struct xfs_bmbt_irec *);
+		struct xfs_bmbt_irec *, bool);
 
 extern struct iomap_ops xfs_iomap_ops;
 extern struct iomap_ops xfs_xattr_iomap_ops;
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 93a7aaf..5519e4b 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -188,7 +188,7 @@ xfs_fs_map_blocks(
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
-	xfs_bmbt_to_iomap(ip, iomap, &imap);
+	xfs_bmbt_to_iomap(ip, iomap, &imap, false);
 	*device_generation = mp->m_generation;
 	return error;
 out_unlock:
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 82d66a4..885ec61 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -179,6 +179,68 @@ xfs_reflink_find_shared(
 	return error;
 }
 
+/*
+ * Trim the mapping to the next block where there's a change in the
+ * shared/unshared status.  More specifically, this means that we
+ * find the lowest-numbered extent of shared blocks that coincides with
+ * the given block mapping.  If the shared extent overlaps the start of
+ * the mapping, trim the mapping to the end of the shared extent.  If
+ * the shared region intersects the mapping, trim the mapping to the
+ * start of the shared extent.  If there are no shared regions that
+ * overlap, just return the original extent.
+ */
+int
+xfs_reflink_trim_around_shared(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*irec,
+	bool			*shared,
+	bool			*trimmed)
+{
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_extlen_t		aglen;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			error = 0;
+
+	/* Holes, unwritten, and delalloc extents cannot be shared */
+	if (!xfs_is_reflink_inode(ip) ||
+	    ISUNWRITTEN(irec) ||
+	    irec->br_startblock == HOLESTARTBLOCK ||
+	    irec->br_startblock == DELAYSTARTBLOCK) {
+		*shared = false;
+		return 0;
+	}
+
+	trace_xfs_reflink_trim_around_shared(ip, irec);
+
+	agno = XFS_FSB_TO_AGNO(ip->i_mount, irec->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(ip->i_mount, irec->br_startblock);
+	aglen = irec->br_blockcount;
+
+	error = xfs_reflink_find_shared(ip->i_mount, agno, agbno,
+			aglen, &fbno, &flen, true);
+	if (error)
+		return error;
+
+	*shared = *trimmed = false;
+	if (flen == 0) {
+		/* No shared blocks at all. */
+		return 0;
+	} else if (fbno == agbno) {
+		/* The start of this extent is shared. */
+		irec->br_blockcount = flen;
+		*shared = true;
+		*trimmed = true;
+		return 0;
+	} else {
+		/* There's a shared extent midway through this extent. */
+		irec->br_blockcount = fbno - agbno;
+		*trimmed = true;
+		return 0;
+	}
+}
+
 /* Find the shared ranges under an irec, and set up delalloc extents. */
 static int
 xfs_reflink_reserve_cow_extent(
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 0ffabfb..e0bad68 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -23,6 +23,9 @@
 extern int xfs_reflink_find_shared(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
 		xfs_extlen_t *flen, bool find_maximal);
+extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
+		struct xfs_bmbt_irec *irec, bool *shared, bool *trimmed);
+
 extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip,
 		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb);
 extern bool xfs_reflink_is_cow_pending(struct xfs_inode *ip, xfs_off_t offset);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
