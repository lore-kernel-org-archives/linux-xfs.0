Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39274 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965193AbeALWE0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 17:04:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0CLvQIs044747
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:25 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2ff5c082bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:25 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0CM4PT2020337
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:25 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0CM4PMw011671
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:25 GMT
Subject: [PATCH 4/5] xfs: attr leaf verifier needs to check for obviously
 bad count
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 12 Jan 2018 14:04:24 -0800
Message-ID: <151579466415.8694.4992590880368427655.stgit@magnolia>
In-Reply-To: <151579463950.8694.320025813242574491.stgit@magnolia>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In the attribute leaf verifier, we can check for obviously bad values of
firstused and count so that later attempts at lasthash don't run off the
end of the memory buffer.  Found by ones fuzzing hdr.count in xfs/400 with
KASAN.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6fddce7..712d458 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -249,12 +249,13 @@ xfs_attr3_leaf_hdr_to_disk(
 
 static xfs_failaddr_t
 xfs_attr3_leaf_verify(
-	struct xfs_buf		*bp)
+	struct xfs_buf			*bp)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_attr_leafblock *leaf = bp->b_addr;
-	struct xfs_perag *pag = bp->b_pag;
-	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_mount		*mp = bp->b_target->bt_mount;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_perag		*pag = bp->b_pag;
+	struct xfs_attr_leaf_entry	*entries;
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
@@ -282,6 +283,14 @@ xfs_attr3_leaf_verify(
 	if (pag && pag->pagf_init && ichdr.count == 0)
 		return __this_address;
 
+	if (ichdr.firstused > mp->m_attr_geo->blksize)
+		return __this_address;
+
+	entries = xfs_attr3_leaf_entryp(bp->b_addr);
+	if ((char *)&entries[ichdr.count] >=
+	    (char *)bp->b_addr + ichdr.firstused)
+		return __this_address;
+
 	/* XXX: need to range check rest of attr header values */
 	/* XXX: hash order check? */
 

