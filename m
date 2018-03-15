Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39002 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbeCOAaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 20:30:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2F0RPVj158078
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:03 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2gqdhrg366-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:02 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2F0U2OS028700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:02 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w2F0U11I014167
        for <linux-xfs@vger.kernel.org>; Thu, 15 Mar 2018 00:30:01 GMT
Subject: [PATCH 5/9] xfs: bmap scrubber should do rmap xref with bmap for
 sparse files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 14 Mar 2018 17:30:00 -0700
Message-ID: <152107380082.19571.10988218532838802248.stgit@magnolia>
In-Reply-To: <152107377037.19571.8618901963505842632.stgit@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're scanning an extent mapping inode fork, ensure that every rmap
record for this ifork has a corresponding bmbt record too.  This
(mostly) provides the ability to cross-reference rmap records with bmap
data.  The rmap scrubber cannot do the xref on its own because that
requires taking an ilock with the agf lock held, which violates our
locking order rules (inode, then agf).

Note that we only do this for forks that are in btree format due to the
increased complexity; or forks that should have data but suspiciously
have zero extents because the inode could have just had its iforks
zapped by the inode repair code and now we need to reclaim the old
extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c |  164 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 163 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index d002821..2f38add 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
@@ -423,6 +424,163 @@ xfs_scrub_bmap_btree(
 	return error;
 }
 
+struct xfs_scrub_bmap_check_rmap_info {
+	struct xfs_scrub_context	*sc;
+	int				whichfork;
+	struct xfs_iext_cursor		icur;
+};
+
+/* Can we find bmaps that fit this rmap? */
+STATIC int
+xfs_scrub_bmap_check_rmap(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*priv)
+{
+	struct xfs_bmbt_irec		irec;
+	struct xfs_scrub_bmap_check_rmap_info	*sbcri = priv;
+	struct xfs_ifork		*ifp;
+	struct xfs_scrub_context	*sc = sbcri->sc;
+	bool				have_map;
+
+	/* Is this even the right fork? */
+	if (rec->rm_owner != sc->ip->i_ino)
+		return 0;
+	if ((sbcri->whichfork == XFS_ATTR_FORK) ^
+	    !!(rec->rm_flags & XFS_RMAP_ATTR_FORK))
+		return 0;
+	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK)
+		return 0;
+
+	/* Now look up the bmbt record. */
+	ifp = XFS_IFORK_PTR(sc->ip, sbcri->whichfork);
+	if (!ifp) {
+		xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+				rec->rm_offset);
+		goto out;
+	}
+	have_map = xfs_iext_lookup_extent(sc->ip, ifp, rec->rm_offset,
+			&sbcri->icur, &irec);
+	if (!have_map)
+		xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+				rec->rm_offset);
+
+	while (have_map) {
+		if (irec.br_startoff != rec->rm_offset)
+			xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+					rec->rm_offset);
+		if (irec.br_startblock != XFS_AGB_TO_FSB(sc->mp,
+				cur->bc_private.a.agno, rec->rm_startblock))
+			xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+					rec->rm_offset);
+		if (irec.br_blockcount > rec->rm_blockcount)
+			xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+					rec->rm_offset);
+		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			break;
+		rec->rm_startblock += irec.br_blockcount;
+		rec->rm_offset += irec.br_blockcount;
+		rec->rm_blockcount -= irec.br_blockcount;
+		if (rec->rm_blockcount == 0)
+			break;
+		have_map = xfs_iext_next_extent(ifp, &sbcri->icur, &irec);
+		if (!have_map)
+			xfs_scrub_fblock_set_corrupt(sc, sbcri->whichfork,
+					rec->rm_offset);
+	}
+
+out:
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return XFS_BTREE_QUERY_RANGE_ABORT;
+	return 0;
+}
+
+/* Make sure each rmap has a corresponding bmbt entry. */
+STATIC int
+xfs_scrub_bmap_check_ag_rmaps(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_agnumber_t			agno)
+{
+	struct xfs_scrub_bmap_check_rmap_info	sbcri;
+	struct xfs_btree_cur		*cur;
+	struct xfs_buf			*agf;
+	int				error;
+
+	error = xfs_alloc_read_agf(sc->mp, sc->tp, agno, 0, &agf);
+	if (error)
+		return error;
+
+	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, agno);
+	if (!cur) {
+		error = -ENOMEM;
+		goto out_agf;
+	}
+
+	sbcri.sc = sc;
+	sbcri.whichfork = whichfork;
+	error = xfs_rmap_query_all(cur, xfs_scrub_bmap_check_rmap, &sbcri);
+	if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+		error = 0;
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+out_agf:
+	xfs_trans_brelse(sc->tp, agf);
+	return error;
+}
+
+/* Make sure each rmap has a corresponding bmbt entry. */
+STATIC int
+xfs_scrub_bmap_check_rmaps(
+	struct xfs_scrub_context	*sc,
+	int				whichfork)
+{
+	loff_t				size;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb) ||
+	    whichfork == XFS_COW_FORK ||
+	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		return 0;
+
+	/* Don't support realtime rmap checks yet. */
+	if (XFS_IS_REALTIME_INODE(sc->ip) && whichfork == XFS_DATA_FORK)
+		return 0;
+
+	/*
+	 * Only do this for complex maps that are in btree format, or for
+	 * situations where we would seem to have a size but zero extents.
+	 * The inode repair code can zap broken iforks, which means we have
+	 * to flag this bmap as corrupt if there are rmaps that need to be
+	 * reattached.
+	 */
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		size = i_size_read(VFS_I(sc->ip));
+		break;
+	case XFS_ATTR_FORK:
+		size = XFS_IFORK_Q(sc->ip);
+		break;
+	default:
+		size = 0;
+		break;
+	}
+	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE &&
+	    (size == 0 || XFS_IFORK_NEXTENTS(sc->ip, whichfork) > 0))
+		return 0;
+
+	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
+		error = xfs_scrub_bmap_check_ag_rmaps(sc, whichfork, agno);
+		if (error)
+			return error;
+		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			break;
+	}
+
+	return 0;
+}
+
 /*
  * Scrub an inode fork's block mappings.
  *
@@ -463,7 +621,7 @@ xfs_scrub_bmap(
 		break;
 	case XFS_ATTR_FORK:
 		if (!ifp)
-			goto out;
+			goto out_check_rmap;
 		if (!xfs_sb_version_hasattr(&mp->m_sb) &&
 		    !xfs_sb_version_hasattr2(&mp->m_sb))
 			xfs_scrub_ino_set_corrupt(sc, sc->ip->i_ino, NULL);
@@ -534,6 +692,10 @@ xfs_scrub_bmap(
 			goto out;
 	}
 
+out_check_rmap:
+	error = xfs_scrub_bmap_check_rmaps(sc, whichfork);
+	if (!xfs_scrub_fblock_xref_process_error(sc, whichfork, 0, &error))
+		goto out;
 out:
 	return error;
 }

