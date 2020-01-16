Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB99C32771
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 01:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F561222C3
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 01:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JAoJuUXR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbgAPBr5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 20:47:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44214 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729949AbgAPBr5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 20:47:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G1iKpl036641;
        Thu, 16 Jan 2020 01:47:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=84hIcV5xw20nFuDUlLPv0H9iLdPo+hEAt1QWgD7Y1OU=;
 b=JAoJuUXRQXzF7xskbeODbrxk1YBOf+B++2oAx1m7RDSxzU2Hdvc3DiSa1F2kM5AsgG9C
 8I+9VrNIMnESaC+bWHqlg0WioIb634DRSQ8i+tHHC7Cnagsa2+AJZDJtKPjjeQ9gm8F0
 DOI40bMboLmxQauEUJY6SPZhXq9cAMAK/tM9vVUc/brGMinX58xSe8dlNGFO4f6uHCdC
 YijVXLujMa7FXEju6tOKKCgVIhhec+VFHQpatIwzl0aBulvyLnLbWc7sAmZ/tb5dC5d6
 1Rh2hK8sWPK9myVPQcg9tlptjXc4GfYGNRCpUM7aUVPf+C3moOiQyCg3ZOT2ON1wimbV +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73yqq7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 01:47:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G1iOco037734;
        Thu, 16 Jan 2020 01:47:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1asafvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 01:47:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00G1lj99002836;
        Thu, 16 Jan 2020 01:47:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 17:47:44 -0800
Date:   Wed, 15 Jan 2020 17:47:44 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: [PATCH v2 3/7] xfs: streamline xfs_attr3_leaf_inactive
Message-ID: <20200116014744.GE8247@magnolia>
References: <157910777330.2028015.5017943601641757827.stgit@magnolia>
 <157910779242.2028015.12106623745208393495.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157910779242.2028015.12106623745208393495.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160012
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
v2: eliminate unnecessary temp variables
---
 fs/xfs/libxfs/xfs_attr_leaf.h |    9 ----
 fs/xfs/xfs_attr_inactive.c    |  101 ++++++++++++-----------------------------
 2 files changed, 29 insertions(+), 81 deletions(-)

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
index edb079087a0c..c75840a9e478 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -37,8 +37,6 @@ xfs_attr3_rmt_stale(
 	int			blkcnt)
 {
 	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		tblkno;
-	int			tblkcnt;
 	int			nmap;
 	int			error;
 
@@ -46,14 +44,12 @@ xfs_attr3_rmt_stale(
 	 * Roll through the "value", invalidating the attribute value's
 	 * blocks.
 	 */
-	tblkno = blkno;
-	tblkcnt = blkcnt;
-	while (tblkcnt > 0) {
+	while (blkcnt > 0) {
 		/*
 		 * Try to remember where we decided to put the value.
 		 */
 		nmap = 1;
-		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
+		error = xfs_bmapi_read(dp, (xfs_fileoff_t)blkno, blkcnt,
 				       &map, &nmap, XFS_BMAPI_ATTRFORK);
 		if (error)
 			return error;
@@ -69,8 +65,8 @@ xfs_attr3_rmt_stale(
 		if (error)
 			return error;
 
-		tblkno += map.br_blockcount;
-		tblkcnt -= map.br_blockcount;
+		blkno += map.br_blockcount;
+		blkcnt -= map.br_blockcount;
 	}
 
 	return 0;
@@ -84,84 +80,45 @@ xfs_attr3_rmt_stale(
  */
 STATIC int
 xfs_attr3_leaf_inactive(
-	struct xfs_trans	**trans,
-	struct xfs_inode	*dp,
-	struct xfs_buf		*bp)
+	struct xfs_trans		**trans,
+	struct xfs_inode		*dp,
+	struct xfs_buf			*bp)
 {
-	struct xfs_attr_leafblock *leaf;
-	struct xfs_attr3_icleaf_hdr ichdr;
-	struct xfs_attr_leaf_entry *entry;
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_mount		*mp = bp->b_mount;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_attr_leaf_entry	*entry;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	struct xfs_attr_inactive_list *list;
-	struct xfs_attr_inactive_list *lp;
-	int			error;
-	int			count;
-	int			size;
-	int			tmp;
-	int			i;
-	struct xfs_mount	*mp = bp->b_mount;
+	int				error;
+	int				i;
 
-	leaf = bp->b_addr;
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
-
-	/*
-	 * If there are no "remote" values, we're done.
-	 */
-	if (count == 0) {
-		xfs_trans_brelse(*trans, bp);
-		return 0;
-	}
+		int		blkcnt;
 
-	/*
-	 * Allocate storage for a list of all the "remote" value extents.
-	 */
-	size = count * sizeof(xfs_attr_inactive_list_t);
-	list = kmem_alloc(size, 0);
+		if (!entry->nameidx || (entry->flags & XFS_ATTR_LOCAL))
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
+		name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+		if (!name_rmt->valueblk)
+			continue;
 
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
 
