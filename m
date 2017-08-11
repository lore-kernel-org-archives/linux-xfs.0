Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50420 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbdHKHKw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:10:52 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7Apxi031435
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7ApEq021796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:51 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7B7Ap6C020466
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:51 GMT
Subject: [PATCH 06/16] xfs: check btree block ownership with bnobt/rmapbt
 when scrubbing btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:10:50 -0700
Message-ID: <150243545000.29473.11176465161812133180.stgit@magnolia>
In-Reply-To: <150243541274.29473.1227559008347544526.stgit@magnolia>
References: <150243541274.29473.1227559008347544526.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When scanning a metadata btree block, cross-reference the block location
with the free space btree and the reverse mapping btree to ensure that
the rmapbt knows about the block and the bnobt does not.  Add a
mechanism to defer checks when we happen to be scanning the bnobt/rmapbt
itself because it's less efficient to repeatedly clone and destroy the
cursor.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/btree.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 6f63523..4053bb1 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -370,6 +370,72 @@ xfs_scrub_btree_block_check_siblings(
 	return error;
 }
 
+struct check_owner {
+	struct list_head	list;
+	xfs_daddr_t		daddr;
+};
+
+/*
+ * Make sure this btree block isn't in the free list and that there's
+ * an rmap record for it.
+ */
+STATIC int
+xfs_scrub_btree_check_block_owner(
+	struct xfs_scrub_btree		*bs,
+	xfs_daddr_t			daddr)
+{
+	struct xfs_scrub_ag		sa = { 0 };
+	struct xfs_scrub_ag		*psa;
+	xfs_agnumber_t			agno;
+	int				error = 0;
+
+	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
+
+	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		error = xfs_scrub_ag_init(bs->sc, agno, &sa);
+		if (error)
+			return error;
+		psa = &sa;
+	} else {
+		psa = &bs->sc->sa;
+	}
+
+	if (psa == &sa)
+		xfs_scrub_ag_free(bs->sc, &sa);
+
+	return error;
+}
+
+/* Check the owner of a btree block. */
+STATIC int
+xfs_scrub_btree_check_owner(
+	struct xfs_scrub_btree		*bs,
+	struct xfs_buf			*bp)
+{
+	struct xfs_btree_cur		*cur = bs->cur;
+	struct check_owner		*co;
+
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) && bp == NULL)
+		return 0;
+
+	/*
+	 * We want to cross-reference each btree block with the bnobt
+	 * and the rmapbt.  We cannot cross-reference the bnobt or
+	 * rmapbt while scanning the bnobt or rmapbt, respectively,
+	 * because we cannot alter the cursor and we'd prefer not to
+	 * duplicate cursors.  Therefore, save the buffer daddr for
+	 * later scanning.
+	 */
+	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
+		co = kmem_alloc(sizeof(struct check_owner), KM_SLEEP | KM_NOFS);
+		co->daddr = XFS_BUF_ADDR(bp);
+		list_add_tail(&co->list, &bs->to_check);
+		return 0;
+	}
+
+	return xfs_scrub_btree_check_block_owner(bs, XFS_BUF_ADDR(bp));
+}
+
 /* Grab and scrub a btree block. */
 STATIC int
 xfs_scrub_btree_block(
@@ -390,6 +456,10 @@ xfs_scrub_btree_block(
 	if (error)
 		return error;
 
+	error = xfs_scrub_btree_check_owner(bs, *pbp);
+	if (error)
+		return error;
+
 	return xfs_scrub_btree_block_check_siblings(bs, *pblock);
 }
 
@@ -415,6 +485,8 @@ xfs_scrub_btree(
 	struct xfs_btree_block		*block;
 	int				level;
 	struct xfs_buf			*bp;
+	struct check_owner		*co;
+	struct check_owner		*n;
 	int				i;
 	int				error = 0;
 
@@ -512,6 +584,14 @@ xfs_scrub_btree(
 	}
 
 out:
+	/* Process deferred owner checks on btree blocks. */
+	list_for_each_entry_safe(co, n, &bs.to_check, list) {
+		if (!error)
+			error = xfs_scrub_btree_check_block_owner(&bs,
+					co->daddr);
+		list_del(&co->list);
+		kmem_free(co);
+	}
 
 	return error;
 }

