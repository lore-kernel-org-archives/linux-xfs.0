Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44132 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753870AbdJSOXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:23:18 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/16] xfs: perag initialization should only touch m_ag_max_usable for AG 0
Date: Thu, 19 Oct 2017 16:22:49 +0200
Message-Id: <20171019142259.20082-7-hch@lst.de>
In-Reply-To: <20171019142259.20082-1-hch@lst.de>
References: <20171019142259.20082-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 9789dd9e1d939232e8ff4c50ef8e75aa6781b3fb upstream.

We call __xfs_ag_resv_init to make a per-AG reservation for each AG.
This makes the reservation per-AG, not per-filesystem.  Therefore, it
is incorrect to adjust m_ag_max_usable for each AG.  Adjust it only
when we're reserving AG 0's blocks so that we only do it once per fs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 33db69be4832..eed8f5867c46 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -157,7 +157,8 @@ __xfs_ag_resv_free(
 	trace_xfs_ag_resv_free(pag, type, 0);
 
 	resv = xfs_perag_resv(pag, type);
-	pag->pag_mount->m_ag_max_usable += resv->ar_asked;
+	if (pag->pag_agno == 0)
+		pag->pag_mount->m_ag_max_usable += resv->ar_asked;
 	/*
 	 * AGFL blocks are always considered "free", so whatever
 	 * was reserved at mount time must be given back at umount.
@@ -217,7 +218,14 @@ __xfs_ag_resv_init(
 		return error;
 	}
 
-	mp->m_ag_max_usable -= ask;
+	/*
+	 * Reduce the maximum per-AG allocation length by however much we're
+	 * trying to reserve for an AG.  Since this is a filesystem-wide
+	 * counter, we only make the adjustment for AG 0.  This assumes that
+	 * there aren't any AGs hungrier for per-AG reservation than AG 0.
+	 */
+	if (pag->pag_agno == 0)
+		mp->m_ag_max_usable -= ask;
 
 	resv = xfs_perag_resv(pag, type);
 	resv->ar_asked = ask;
-- 
2.14.2

