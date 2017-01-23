Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39100 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdAWVMv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Jan 2017 16:12:51 -0500
Date: Mon, 23 Jan 2017 13:12:21 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: reset ag_max_usable when retrying failed per-ag
 reservation init
Message-ID: <20170123211221.GB31202@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

It's possible for the per-AG reservation initialization to return ENOSPC
when fdblocks says there isn't free space.  This is a valid state for
the reservation tracker since subsequent extent freeing activity will
simply be captured by the reservation mechanism, but if we subsequently
retry a failed initialization, we need to undo the changes we made to
ag_max_usable prior to recreating the reservation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 4773c1e..1bdd091 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -202,6 +202,12 @@ __xfs_ag_resv_init(
 	struct xfs_ag_resv		*resv;
 	int				error;
 
+	/*
+	 * We have to reset ag_max_usable prior to retrying a failed
+	 * initialization with a smaller request.
+	 */
+	mp->m_ag_max_usable += resv->ar_asked;
+
 	resv = xfs_perag_resv(pag, type);
 	if (used > ask)
 		ask = used;
