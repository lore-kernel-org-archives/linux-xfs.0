Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51769 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdC0Itf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:49:35 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/27] xfs: only update mount/resv fields on success in __xfs_ag_resv_init
Date: Mon, 27 Mar 2017 10:48:56 +0200
Message-Id: <20170327084922.11691-2-hch@lst.de>
In-Reply-To: <20170327084922.11691-1-hch@lst.de>
References: <20170327084922.11691-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

commit 4dfa2b84118fd6c95202ae87e62adf5000ccd4d0 upstream.

Try to reserve the blocks first and only then update the fields in
or hanging off the mount structure.  This way we can call __xfs_ag_resv_init
again after a previous failure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index d346d42c54d1..94234bff40dc 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -200,22 +200,27 @@ __xfs_ag_resv_init(
 	struct xfs_mount		*mp = pag->pag_mount;
 	struct xfs_ag_resv		*resv;
 	int				error;
+	xfs_extlen_t			reserved;
 
-	resv = xfs_perag_resv(pag, type);
 	if (used > ask)
 		ask = used;
-	resv->ar_asked = ask;
-	resv->ar_reserved = resv->ar_orig_reserved = ask - used;
-	mp->m_ag_max_usable -= ask;
+	reserved = ask - used;
 
-	trace_xfs_ag_resv_init(pag, type, ask);
-
-	error = xfs_mod_fdblocks(mp, -(int64_t)resv->ar_reserved, true);
-	if (error)
+	error = xfs_mod_fdblocks(mp, -(int64_t)reserved, true);
+	if (error) {
 		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
 				error, _RET_IP_);
+		return error;
+	}
 
-	return error;
+	mp->m_ag_max_usable -= ask;
+
+	resv = xfs_perag_resv(pag, type);
+	resv->ar_asked = ask;
+	resv->ar_reserved = resv->ar_orig_reserved = reserved;
+
+	trace_xfs_ag_resv_init(pag, type, ask);
+	return 0;
 }
 
 /* Create a per-AG block reservation. */
-- 
2.11.0

