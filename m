Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17415 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933939AbcI1C5a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:57:30 -0400
Subject: [PATCH 35/63] xfs: report shared extent mappings to userspace
 correctly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:57:22 -0700
Message-ID: <147503144238.30303.12291150952433415521.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Report shared extents through the iomap interface so that FIEMAP flags
shared blocks accurately.  Have xfs_vm_bmap return zero for reflinked
files because the bmap-based swap code requires static block mappings,
which is incompatible with copy on write.

NOTE: Existing userspace bmap users such as lilo will have the same
problem with reflink files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: combine the fiemap and bmap reporting patches because they're both
related and trivially short.
---
 fs/xfs/xfs_aops.c  |   11 +++++++++++
 fs/xfs/xfs_iomap.c |   12 +++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index aa23993..1d0435a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1509,6 +1509,17 @@ xfs_vm_bmap(
 
 	trace_xfs_vm_bmap(XFS_I(inode));
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+
+	/*
+	 * The swap code (ab-)uses ->bmap to get a block mapping and then
+	 * bypasseѕ the file system for actual I/O.  We really can't allow
+	 * that on reflinks inodes, so we have to skip out here.  And yes,
+	 * 0 is the magic code for a bmap error..
+	 */
+	if (xfs_is_reflink_inode(ip)) {
+		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+		return 0;
+	}
 	filemap_write_and_wait(mapping);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 	return generic_block_bmap(mapping, block, xfs_get_blocks);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ad6939d..765849e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -961,6 +961,7 @@ xfs_file_iomap_begin(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_bmbt_irec	imap;
 	xfs_fileoff_t		offset_fsb, end_fsb;
+	bool			shared, trimmed;
 	int			nimaps = 1, error = 0;
 	unsigned		lockmode;
 
@@ -989,7 +990,14 @@ xfs_file_iomap_begin(
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
-			       &nimaps, XFS_BMAPI_ENTIRE);
+			       &nimaps, 0);
+	if (error) {
+		xfs_iunlock(ip, lockmode);
+		return error;
+	}
+
+	/* Trim the mapping to the nearest shared extent boundary. */
+	error = xfs_reflink_trim_around_shared(ip, &imap, &shared, &trimmed);
 	if (error) {
 		xfs_iunlock(ip, lockmode);
 		return error;
@@ -1028,6 +1036,8 @@ xfs_file_iomap_begin(
 	}
 
 	xfs_bmbt_to_iomap(ip, iomap, &imap);
+	if (shared)
+		iomap->flags |= IOMAP_F_SHARED;
 	return 0;
 }
 

