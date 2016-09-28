Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17703 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964876AbcI1C6y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:58:54 -0400
Subject: [PATCH 49/63] xfs: don't allow reflink when the AG is low on space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:58:51 -0700
Message-ID: <147503153101.30303.6670224149668522892.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

If the AG free space is down to the reserves, refuse to reflink our
way out of space.  Hopefully userspace will make a real copy and/or go
elsewhere.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7c6987f..9d74bff 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -54,6 +54,8 @@
 #include "xfs_reflink.h"
 #include "xfs_iomap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_sb.h"
+#include "xfs_ag_resv.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -1106,6 +1108,31 @@ xfs_reflink_update_dest(
 }
 
 /*
+ * Do we have enough reserve in this AG to handle a reflink?  The refcount
+ * btree already reserved all the space it needs, but the rmap btree can grow
+ * infinitely, so we won't allow more reflinks when the AG is down to the
+ * btree reserves.
+ */
+static int
+xfs_reflink_ag_has_free_space(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_perag	*pag;
+	int			error = 0;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+
+	pag = xfs_perag_get(mp, agno);
+	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_AGFL) ||
+	    xfs_ag_resv_critical(pag, XFS_AG_RESV_METADATA))
+		error = -ENOSPC;
+	xfs_perag_put(pag);
+	return error;
+}
+
+/*
  * Unmap a range of blocks from a file, then map other blocks into the hole.
  * The range to unmap is (destoff : destoff + srcioff + irec->br_blockcount).
  * The extent irec is mapped into dest at irec->br_startoff.
@@ -1137,6 +1164,14 @@ xfs_reflink_remap_extent(
 			irec->br_startblock != DELAYSTARTBLOCK &&
 			!ISUNWRITTEN(irec));
 
+	/* No reflinking if we're low on space */
+	if (real_extent) {
+		error = xfs_reflink_ag_has_free_space(mp,
+				XFS_FSB_TO_AGNO(mp, irec->br_startblock));
+		if (error)
+			goto out;
+	}
+
 	/* Start a rolling transaction to switch the mappings */
 	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);

