Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 89AC27E55
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:38:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 52E058F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:38:01 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id fvx9MAI2wN9QPtdE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:37:59 -0700 (PDT)
Subject: [PATCH 55/71] xfs: don't allow reflink when the AG is low on space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:37:55 -0700
Message-ID: <147216827534.867.13543187691263026433.stgit@birch.djwong.org>
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

If the AG free space is down to the reserves, refuse to reflink our
way out of space.  Hopefully userspace will make a real copy and/or go
elsewhere.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 2caed8c..68cd467 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -53,6 +53,8 @@
 #include "xfs_reflink.h"
 #include "xfs_iomap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_sb.h"
+#include "xfs_ag_resv.h"
 
 /*
  * Copy on Write of Shared Blocks
@@ -1095,6 +1097,30 @@ out_error:
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
+	if (xfs_ag_resv_critical(pag, XFS_AG_RESV_AGFL))
+		error = -ENOSPC;
+	xfs_perag_put(pag);
+	return error;
+}
+
+/*
  * Unmap a range of blocks from a file, then map other blocks into the hole.
  * The range to unmap is (destoff : destoff + srcioff + irec->br_blockcount).
  * The extent irec is mapped into dest at irec->br_startoff.
@@ -1126,6 +1152,14 @@ xfs_reflink_remap_extent(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
