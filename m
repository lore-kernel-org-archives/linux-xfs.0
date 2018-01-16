Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40048 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbeAPXeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 18:34:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0GNMCH0105951
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2018 23:34:18 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fhsdqgdwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2018 23:34:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0GNYH0U014228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2018 23:34:17 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0GNYGYC031560
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2018 23:34:17 GMT
Date: Tue, 16 Jan 2018 15:34:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: check that br_blockcount doesn't overflow
Message-ID: <20180116233415.GH5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_bmbt_irec.br_blockcount is declared as xfs_filblks_t, which is an
unsigned 64-bit integer.  Though the bmbt helpers will never set a value
larger than 2^21 (since the underlying on-disk extent record has a
length field that is only 21 bits wide), we should be a little defensive
about checking that a bmbt record doesn't exceed what we're expecting or
overflow into the next AG.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 3a815db..fa64bd4 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -348,6 +348,7 @@ xfs_scrub_bmap_extent(
 {
 	struct xfs_mount		*mp = info->sc->mp;
 	struct xfs_buf			*bp = NULL;
+	xfs_filblks_t			end;
 	int				error = 0;
 
 	if (cur)
@@ -375,19 +376,23 @@ xfs_scrub_bmap_extent(
 				irec->br_startoff);
 
 	/* Make sure the extent points to a valid place. */
+	if (irec->br_blockcount > MAXEXTLEN)
+		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
 	if (irec->br_startblock + irec->br_blockcount <= irec->br_startblock)
 		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
+	end = irec->br_startblock + irec->br_blockcount - 1;
 	if (info->is_rt &&
 	    (!xfs_verify_rtbno(mp, irec->br_startblock) ||
-	     !xfs_verify_rtbno(mp, irec->br_startblock +
-				irec->br_blockcount - 1)))
+	     !xfs_verify_rtbno(mp, end)))
 		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (!info->is_rt &&
 	    (!xfs_verify_fsbno(mp, irec->br_startblock) ||
-	     !xfs_verify_fsbno(mp, irec->br_startblock +
-				irec->br_blockcount - 1)))
+	     !xfs_verify_fsbno(mp, end) ||
+	     XFS_FSB_TO_AGNO(mp, irec->br_startblock) !=
+	     XFS_FSB_TO_AGNO(mp, end)))
 		xfs_scrub_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
