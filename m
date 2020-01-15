Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE126C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CDD7214AF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 17:03:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EVMrY7ij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbgAORDX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 12:03:23 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44976 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgAORDX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 12:03:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGhZRF012447;
        Wed, 15 Jan 2020 17:03:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=rbBHXyRdv2H/+J3fF45TfcHBPdoZPkekaNFh5UJUezo=;
 b=EVMrY7ijd25ivhDZrwG+StpsMBZ888th5NEZVfyPZXzBtUj0iK6QsN1SkYi8DLuCyo60
 qR05w2ZnFG6lLAdql4YPhaseEs8Fwt7StCWXnElZniwfT4JvvhlIrHQ65N7CUHHdu3FO
 1uRZvFHkb87SCJ+dWiTlilasBq2a0VcJG/xXSxeWeNx8tr1uMCVo1pLAyUvnrhWsUKKp
 rEmt0oLBvLyWYHn3Nwl+p2NBtW0nR2N+peSrSMkOyKZy1gOOqn8flmherCGkX1/FM4E2
 /WT0gjZfDcYpjwdNKejvCjGQmZ7VnXFuyKPWnqdNqr5ulrqykOFgvcb21BxFtu9uoKL4 6w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xf73yndsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGiMXd056790;
        Wed, 15 Jan 2020 17:03:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xhy21r2uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 17:03:14 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FH3D5L023459;
        Wed, 15 Jan 2020 17:03:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 09:03:13 -0800
Subject: [PATCH 3/7] xfs: streamline xfs_attr3_leaf_inactive
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 15 Jan 2020 09:03:12 -0800
Message-ID: <157910779242.2028015.12106623745208393495.stgit@magnolia>
In-Reply-To: <157910777330.2028015.5017943601641757827.stgit@magnolia>
References: <157910777330.2028015.5017943601641757827.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we know we don't have to take a transaction to stale the incore
buffers for a remote value, get rid of the unnecessary memory allocation
in the leaf walker and call the rmt_stale function directly.  Flatten
the loop while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.h |    9 ----
 fs/xfs/xfs_attr_inactive.c    |   83 ++++++++++-------------------------------
 2 files changed, 21 insertions(+), 71 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index f4a188e28b7b..73615b1dd1a8 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -39,15 +39,6 @@ struct xfs_attr3_icleaf_hdr {
 	} freemap[XFS_ATTR_LEAF_MAPSIZE];
 };
 
-/*
- * Used to keep a list of "remote value" extents when unlinking an inode.
- */
-typedef struct xfs_attr_inactive_list {
-	xfs_dablk_t	valueblk;	/* block number of value bytes */
-	int		valuelen;	/* number of bytes in value */
-} xfs_attr_inactive_list_t;
-
-
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index edb079087a0c..27cb6bf614c5 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -33,12 +33,10 @@
 STATIC int
 xfs_attr3_rmt_stale(
 	struct xfs_inode	*dp,
-	xfs_dablk_t		blkno,
-	int			blkcnt)
+	xfs_dablk_t		tblkno,
+	int			tblkcnt)
 {
 	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		tblkno;
-	int			tblkcnt;
 	int			nmap;
 	int			error;
 
@@ -46,8 +44,6 @@ xfs_attr3_rmt_stale(
 	 * Roll through the "value", invalidating the attribute value's
 	 * blocks.
 	 */
-	tblkno = blkno;
-	tblkcnt = blkcnt;
 	while (tblkcnt > 0) {
 		/*
 		 * Try to remember where we decided to put the value.
@@ -88,80 +84,43 @@ xfs_attr3_leaf_inactive(
 	struct xfs_inode	*dp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr3_icleaf_hdr ichdr;
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_attr_leafblock *leaf;
 	struct xfs_attr_leaf_entry *entry;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	struct xfs_attr_inactive_list *list;
-	struct xfs_attr_inactive_list *lp;
 	int			error;
-	int			count;
-	int			size;
-	int			tmp;
 	int			i;
-	struct xfs_mount	*mp = bp->b_mount;
 
 	leaf = bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 
 	/*
-	 * Count the number of "remote" value extents.
+	 * Find the remote value extents for this leaf and invalidate their
+	 * incore buffers.
 	 */
-	count = 0;
 	entry = xfs_attr3_leaf_entryp(leaf);
 	for (i = 0; i < ichdr.count; entry++, i++) {
-		if (be16_to_cpu(entry->nameidx) &&
-		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
-			if (name_rmt->valueblk)
-				count++;
-		}
-	}
+		int		blkcnt;
 
-	/*
-	 * If there are no "remote" values, we're done.
-	 */
-	if (count == 0) {
-		xfs_trans_brelse(*trans, bp);
-		return 0;
-	}
+		if (!be16_to_cpu(entry->nameidx) ||
+		    (entry->flags & XFS_ATTR_LOCAL))
+			continue;
 
-	/*
-	 * Allocate storage for a list of all the "remote" value extents.
-	 */
-	size = count * sizeof(xfs_attr_inactive_list_t);
-	list = kmem_alloc(size, 0);
+		name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+		if (!name_rmt->valueblk)
+			continue;
 
-	/*
-	 * Identify each of the "remote" value extents.
-	 */
-	lp = list;
-	entry = xfs_attr3_leaf_entryp(leaf);
-	for (i = 0; i < ichdr.count; entry++, i++) {
-		if (be16_to_cpu(entry->nameidx) &&
-		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
-			if (name_rmt->valueblk) {
-				lp->valueblk = be32_to_cpu(name_rmt->valueblk);
-				lp->valuelen = xfs_attr3_rmt_blocks(dp->i_mount,
-						    be32_to_cpu(name_rmt->valuelen));
-				lp++;
-			}
-		}
-	}
-	xfs_trans_brelse(*trans, bp);	/* unlock for trans. in freextent() */
-
-	/*
-	 * Invalidate each of the "remote" value extents.
-	 */
-	error = 0;
-	for (lp = list, i = 0; i < count; i++, lp++) {
-		tmp = xfs_attr3_rmt_stale(dp, lp->valueblk, lp->valuelen);
-		if (error == 0)
-			error = tmp;	/* save only the 1st errno */
+		blkcnt = xfs_attr3_rmt_blocks(dp->i_mount,
+				be32_to_cpu(name_rmt->valuelen));
+		error = xfs_attr3_rmt_stale(dp,
+				be32_to_cpu(name_rmt->valueblk), blkcnt);
+		if (error)
+			goto err;
 	}
 
-	kmem_free(list);
+	xfs_trans_brelse(*trans, bp);
+err:
 	return error;
 }
 

