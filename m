Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38267 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752876AbdKCOqU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:46:20 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdEh-0001wz-Ih
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:46:20 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/21] xfs: iterate over extents in xfs_bmap_extents_to_btree
Date: Fri,  3 Nov 2017 17:45:29 +0300
Message-Id: <20171103144539.2187-12-hch@lst.de>
In-Reply-To: <20171103144539.2187-1-hch@lst.de>
References: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This actually makes the function very slightly less efficient for now as we
detour through the expanded irect format between the in-core extent format
and the on-disk one instead of just endian swapping them.  But with the
incore extent btree the in-core one will use a different format and the
representation will be entirely hidden.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8ce7bf19916f..f4d0639dc4ae 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -667,14 +667,13 @@ xfs_bmap_extents_to_btree(
 	xfs_bmbt_rec_t		*arp;		/* child record pointer */
 	struct xfs_btree_block	*block;		/* btree root block */
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
-	xfs_bmbt_rec_host_t	*ep;		/* extent record pointer */
 	int			error;		/* error return value */
-	xfs_extnum_t		i, cnt;		/* extent record index */
 	xfs_ifork_t		*ifp;		/* inode fork pointer */
 	xfs_bmbt_key_t		*kp;		/* root block key pointer */
 	xfs_mount_t		*mp;		/* mount structure */
-	xfs_extnum_t		nextents;	/* number of file extents */
 	xfs_bmbt_ptr_t		*pp;		/* root block address pointer */
+	struct xfs_bmbt_irec	rec;
+	xfs_extnum_t		i = 0, cnt = 0;
 
 	mp = ip->i_mount;
 	ASSERT(whichfork != XFS_COW_FORK);
@@ -753,15 +752,12 @@ xfs_bmap_extents_to_btree(
 				XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
 				XFS_BTREE_LONG_PTRS);
 
-	arp = XFS_BMBT_REC_ADDR(mp, ablock, 1);
-	nextents =  xfs_iext_count(ifp);
-	for (cnt = i = 0; i < nextents; i++) {
-		ep = xfs_iext_get_ext(ifp, i);
-		if (!isnullstartblock(xfs_bmbt_get_startblock(ep))) {
-			arp->l0 = cpu_to_be64(ep->l0);
-			arp->l1 = cpu_to_be64(ep->l1);
-			arp++; cnt++;
-		}
+	while (xfs_iext_get_extent(ifp, i++, &rec)) {
+		if (isnullstartblock(rec.br_startblock))
+			continue;
+		arp = XFS_BMBT_REC_ADDR(mp, ablock, 1 + cnt);
+		xfs_bmbt_disk_set_all(arp, &rec);
+		cnt++;
 	}
 	ASSERT(cnt == XFS_IFORK_NEXTENTS(ip, whichfork));
 	xfs_btree_set_numrecs(ablock, cnt);
-- 
2.14.2

