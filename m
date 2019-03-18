Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34378 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfCRQoS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Mar 2019 12:44:18 -0400
Date: Mon, 18 Mar 2019 09:44:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: always init bma in xfs_bmapi_write
Message-ID: <20190318164401.GP4929@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Always init the tp/ip fields of bma in xfs_bmapi_write so that the
bmapi_finish at the bottom never trips over null transaction or inode
pointers.

Coverity-id: 1443964
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 625ddfb9653e..17c7168966c6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4254,9 +4254,13 @@ xfs_bmapi_write(
 	struct xfs_bmbt_irec	*mval,		/* output: map values */
 	int			*nmap)		/* i/o: mval size/count */
 {
+	struct xfs_bmalloca	bma = {
+		.tp		= tp,
+		.ip		= ip,
+		.total		= total,
+	};
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
-	struct xfs_bmalloca	bma = { NULL };	/* args for xfs_bmap_alloc */
 	xfs_fileoff_t		end;		/* end of mapped file region */
 	bool			eof = false;	/* after the end of extents */
 	int			error;		/* error return */
@@ -4324,10 +4328,6 @@ xfs_bmapi_write(
 		eof = true;
 	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
 		bma.prev.br_startoff = NULLFILEOFF;
-	bma.tp = tp;
-	bma.ip = ip;
-	bma.total = total;
-	bma.datatype = 0;
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
 	n = 0;
