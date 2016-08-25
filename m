Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 16D857ED4
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:40:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5769304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:40:31 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id B7A56keMhv0BqBRN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:40:30 -0700 (PDT)
Subject: [PATCH 02/25] xfs: report shared extents in getfsmapx
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:40:25 -0700
Message-ID: <147216842570.3108.8594952543604455508.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
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

Cross-reference the reverse mapping data with the refcount btree to find
out which extents are shared.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index a167acb..2eca7b9 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -37,6 +37,8 @@
 #include "xfs_alloc.h"
 #include "xfs_bit.h"
 #include "xfs_fsmap.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
 
 /* getfsmap query state */
 struct xfs_getfsmap_info {
@@ -99,6 +101,42 @@ xfs_getfsmap_rec_before_low_key(
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
+	cur = xfs_refcountbt_init_cursor(mp, NULL, info->agbp,
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
@@ -112,6 +150,7 @@ xfs_getfsmap_helper(
 {
 	struct getfsmap			fmv;
 	xfs_daddr_t			key_end;
+	bool				shared;
 	int				error;
 
 	/*
@@ -221,6 +260,13 @@ xfs_getfsmap_helper(
 		fmv.fmv_oflags |= FMV_OF_ATTR_FORK;
 	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK)
 		fmv.fmv_oflags |= FMV_OF_EXTENT_MAP;
+	if (fmv.fmv_oflags == 0) {
+		error = xfs_getfsmap_is_shared(mp, info, rec, &shared);
+		if (error)
+			return error;
+		if (shared)
+			fmv.fmv_oflags |= FMV_OF_SHARED;
+	}
 	error = info->formatter(&fmv, info->format_arg);
 	if (error)
 		return error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
