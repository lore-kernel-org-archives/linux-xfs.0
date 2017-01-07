Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40634 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964977AbdAGAgV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:36:21 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070aKa9023182
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:36:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v070aKT6000426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:36:20 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v070aKHV015717
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:36:20 GMT
Subject: [PATCH 05/47] xfs: report shared extents in getfsmapx
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:36:19 -0800
Message-ID: <148374937921.30431.13515454201640723877.stgit@birch.djwong.org>
In-Reply-To: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Cross-reference the reverse mapping data with the refcount btree to find
out which extents are shared.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 985415b..d729581 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -37,6 +37,8 @@
 #include "xfs_alloc.h"
 #include "xfs_bit.h"
 #include "xfs_fsmap.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 void
@@ -192,6 +194,42 @@ xfs_getfsmap_rec_before_low_key(
 	return false;
 }
 
+/* Decide if this mapping is shared. */
+STATIC int
+xfs_getfsmap_is_shared(
+	struct xfs_mount		*mp,
+	struct xfs_getfsmap_info	*info,
+	struct xfs_rmap_irec		*rec,
+	bool				*stat)
+{
+	struct xfs_btree_cur		*cur;
+	xfs_agblock_t			fbno;
+	xfs_extlen_t			flen;
+	int				error;
+
+	*stat = false;
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+	/* rt files will have agno set to NULLAGNUMBER */
+	if (info->agno == NULLAGNUMBER)
+		return 0;
+
+	/* Are there any shared blocks here? */
+	flen = 0;
+	cur = xfs_refcountbt_init_cursor(mp, NULL, info->agf_bp,
+			info->agno, NULL);
+
+	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
+			rec->rm_blockcount, &fbno, &flen, false);
+
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+	if (error)
+		return error;
+
+	*stat = flen > 0;
+	return 0;
+}
+
 /*
  * Format a reverse mapping for getfsmap, having translated rm_startblock
  * into the appropriate daddr units.
@@ -205,6 +243,7 @@ xfs_getfsmap_helper(
 {
 	struct xfs_fsmap		fmr;
 	xfs_daddr_t			key_end;
+	bool				shared;
 	int				error;
 
 	/*
@@ -304,6 +343,13 @@ xfs_getfsmap_helper(
 		fmr.fmr_flags |= FMR_OF_ATTR_FORK;
 	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK)
 		fmr.fmr_flags |= FMR_OF_EXTENT_MAP;
+	if (fmr.fmr_flags == 0) {
+		error = xfs_getfsmap_is_shared(mp, info, rec, &shared);
+		if (error)
+			return error;
+		if (shared)
+			fmr.fmr_flags |= FMR_OF_SHARED;
+	}
 	error = info->formatter(&fmr, info->format_arg);
 	if (error)
 		return error;

