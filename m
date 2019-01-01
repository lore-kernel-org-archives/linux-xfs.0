Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58558 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfAAC0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:26:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012O1BY173799
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:26:00 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2pnxedxay0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:26:00 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012Ps84022838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:54 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012Psju028878
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:54 GMT
Subject: [PATCH 14/20] xfs: create routine to allocate and initialize a
 realtime rmap btree inode
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:25:53 -0800
Message-ID: <154630955347.8108.17487967632558274389.stgit@magnolia>
In-Reply-To: <154630945466.8108.16578904812191021263.stgit@magnolia>
References: <154630945466.8108.16578904812191021263.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a library routine to allocate and initialize an empty realtime
rmapbt inode.  We'll use this for growfs, mkfs, and repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   43 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    5 ++++
 2 files changed, 48 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 798f067ea54f..b27071ca3d76 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -25,6 +25,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_imeta.h"
 
 /*
  * Realtime Reverse map btree.
@@ -745,3 +746,45 @@ xfs_rtrmapbt_to_disk(
 		memcpy(trp, frp, sizeof(*frp) * dmxr);
 	}
 }
+
+/*
+ * Create a realtime rmap btree inode.  The caller must clean up @ic and
+ * release the inode stored in @ipp (if it isn't NULL) regardless of the return
+ * value.
+ */
+int
+xfs_rtrmapbt_create(
+	struct xfs_trans	**tpp,
+	struct xfs_imeta_end	*ic,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = (*tpp)->t_mountp;
+	struct xfs_inode	*ip;
+	struct xfs_btree_block	*block;
+	xfs_ino_t		ino = NULLFSINO;
+	int			error;
+
+	*ipp = NULL;
+	error = xfs_imeta_lookup(mp, &XFS_IMETA_RTRMAPBT, &ino);
+	if (error)
+		return error;
+	if (ino != NULLFSINO)
+		return -EEXIST;
+
+	error = xfs_imeta_create(tpp, &XFS_IMETA_RTRMAPBT, S_IFREG, ipp, ic);
+	if (error)
+		return error;
+
+	ip = *ipp;
+	ip->i_d.di_format = XFS_DINODE_FMT_RMAP;
+	ASSERT(ip->i_df.if_broot_bytes == 0);
+	ASSERT(ip->i_df.if_bytes == 0);
+	ip->i_df.if_broot_bytes = XFS_RTRMAP_BROOT_SPACE_CALC(0, 0);
+	ip->i_df.if_broot = kmem_alloc(ip->i_df.if_broot_bytes,
+			KM_SLEEP | KM_NOFS);
+	block = ip->i_df.if_broot;
+	block->bb_numrecs = cpu_to_be16(0);
+	block->bb_level = cpu_to_be16(0);
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 321be07d1cd1..6b14dc817ba6 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -96,4 +96,9 @@ void xfs_rtrmapbt_to_disk(struct xfs_mount *mp,
 		struct xfs_btree_block *rblock, int rblocklen,
 		struct xfs_rtrmap_root *dblock, int dblocklen);
 
+struct xfs_imeta_end;
+
+int xfs_rtrmapbt_create(struct xfs_trans **tpp, struct xfs_imeta_end *ic,
+		struct xfs_inode **ipp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */
