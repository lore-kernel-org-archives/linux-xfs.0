Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25330 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbdISSKo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 14:10:44 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8JIAhfu003686
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2017 18:10:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8JIAhSV001781
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2017 18:10:43 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8JIAgkI016103
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2017 18:10:43 GMT
Date: Tue, 19 Sep 2017 11:10:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: perag initialization should only touch m_ag_max_usable
 for AG 0
Message-ID: <20170919181041.GC7112@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

We call __xfs_ag_resv_init to make a per-AG reservation for each AG.
This makes the reservation per-AG, not per-filesystem.  Therefore, it
is incorrect to adjust m_ag_max_usable for each AG.  Adjust it only
when we're reserving AG 0's blocks so that we only do it once per fs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index b008ff3..df3e600 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -156,7 +156,8 @@ __xfs_ag_resv_free(
 	trace_xfs_ag_resv_free(pag, type, 0);
 
 	resv = xfs_perag_resv(pag, type);
-	pag->pag_mount->m_ag_max_usable += resv->ar_asked;
+	if (pag->pag_agno == 0)
+		pag->pag_mount->m_ag_max_usable += resv->ar_asked;
 	/*
 	 * AGFL blocks are always considered "free", so whatever
 	 * was reserved at mount time must be given back at umount.
@@ -216,7 +217,14 @@ __xfs_ag_resv_init(
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
