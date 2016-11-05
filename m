Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36756 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbcKEAJ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:09:29 -0400
Subject: [PATCH 14/16] libxfs: remove useless stuff from the kernel
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:09:26 -0700
Message-ID: <147830456618.26713.15449667779126141448.stgit@birch.djwong.org>
In-Reply-To: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Evidently the libxfs-apply script sucked in some fs/xfs/ content from
the kernel patches and an extra redefinition of _bmap_search_extents.
We don't need this, so get rid of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_rmap_item.c |    0 
 fs/xfs/xfs_rmap_item.h |    0 
 libxfs/xfs_bmap.h      |    7 -------
 3 files changed, 7 deletions(-)
 delete mode 100644 fs/xfs/xfs_rmap_item.c
 delete mode 100644 fs/xfs/xfs_rmap_item.h


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
deleted file mode 100644
index e69de29..0000000
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
deleted file mode 100644
index e69de29..0000000
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 482e151..7cae6ec 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -246,13 +246,6 @@ int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *got, struct xfs_bmbt_irec *prev,
 		xfs_extnum_t *lastx, int eof);
 
-struct xfs_bmbt_rec_host *
-	xfs_bmap_search_extents(struct xfs_inode *ip, xfs_fileoff_t bno,
-				int fork, int *eofp, xfs_extnum_t *lastxp,
-				struct xfs_bmbt_irec *gotp,
-				struct xfs_bmbt_irec *prevp);
-
-
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
 	XFS_BMAP_UNMAP,

