Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51654 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdAXURC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 15:17:02 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] xfs: only update mount/resv fields on success in __xfs_ag_resv_init
Date: Tue, 24 Jan 2017 21:16:19 +0100
Message-Id: <1485288980-17075-2-git-send-email-hch@lst.de>
In-Reply-To: <1485288980-17075-1-git-send-email-hch@lst.de>
References: <1485288980-17075-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: bfoster@redhat.com, linux-xfs@vger.kernel.org

Try to reserve the blocks first and only then update the fields in
or hanging off the mount structure.  This way we can call __xfs_ag_resv_init
again after a previous failure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag_resv.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index d346d42..94234bf 100644
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
2.1.4

