Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756956AbdLWAsM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 19:48:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN0l7sq065437
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:48:11 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2f1cvd8046-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:48:11 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN0hAkk012924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:10 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBN0h94E031387
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 00:43:09 GMT
Subject: [PATCH 03/21] xfs: xfs_scrub_bmap should use for_each_xfs_iext
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 16:43:08 -0800
Message-ID: <151398978874.18741.7497018527609073813.stgit@magnolia>
In-Reply-To: <151398977028.18741.12031215574014508438.stgit@magnolia>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_scrub_bmap to use for_each_xfs_iext now that it exists.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 42fec0b..0261e11 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -235,7 +235,6 @@ xfs_scrub_bmap(
 	struct xfs_ifork		*ifp;
 	xfs_fileoff_t			endoff;
 	struct xfs_iext_cursor		icur;
-	bool				found;
 	int				error = 0;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -314,9 +313,7 @@ xfs_scrub_bmap(
 	/* Scrub extent records. */
 	info.lastoff = 0;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	for (found = xfs_iext_lookup_extent(ip, ifp, 0, &icur, &irec);
-	     found != 0;
-	     found = xfs_iext_next_extent(ifp, &icur, &irec)) {
+	for_each_xfs_iext(ifp, &icur, &irec) {
 		if (xfs_scrub_should_terminate(sc, &error))
 			break;
 		if (isnullstartblock(irec.br_startblock))

