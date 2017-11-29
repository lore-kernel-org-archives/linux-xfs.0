Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19929 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbdK2B0C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 20:26:02 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT1Q2Bl015247
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1Q2i2015728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:02 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAT1Q1g2027238
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2017 01:26:01 GMT
Subject: [PATCH 06/16] xfs: check btree block ownership with bnobt/rmapbt
 when scrubbing btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Nov 2017 17:26:00 -0800
Message-ID: <151191876080.8553.10718319703301125265.stgit@magnolia>
In-Reply-To: <151191872395.8553.15627872818207535470.stgit@magnolia>
References: <151191872395.8553.15627872818207535470.stgit@magnolia>
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
 fs/xfs/scrub/btree.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 8d48b5b1..40fc26f 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -359,6 +359,80 @@ xfs_scrub_btree_block_check_siblings(
 	return error;
 }
 
+struct check_owner {
+	struct list_head	list;
+	xfs_daddr_t		daddr;
+	int			level;
+};
+
+/*
+ * Make sure this btree block isn't in the free list and that there's
+ * an rmap record for it.
+ */
+STATIC int
+xfs_scrub_btree_check_block_owner(
+	struct xfs_scrub_btree		*bs,
+	int				level,
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
+		if (!xfs_scrub_btree_xref_process_error(bs->sc, bs->cur,
+				level, &error))
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
+	int				level,
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
+		co = kmem_alloc(sizeof(struct check_owner),
+				KM_MAYFAIL | KM_NOFS);
+		if (!co)
+			return -ENOMEM;
+		co->level = level;
+		co->daddr = XFS_BUF_ADDR(bp);
+		list_add_tail(&co->list, &bs->to_check);
+		return 0;
+	}
+
+	return xfs_scrub_btree_check_block_owner(bs, level, XFS_BUF_ADDR(bp));
+}
+
 /*
  * Grab and scrub a btree block given a btree pointer.  Returns block
  * and buffer pointers (if applicable) if they're ok to use.
@@ -395,6 +469,14 @@ xfs_scrub_btree_get_block(
 	}
 
 	/*
+	 * Check the block's owner; this function absorbs error codes
+	 * for us.
+	 */
+	error = xfs_scrub_btree_check_owner(bs, level, *pbp);
+	if (error)
+		return error;
+
+	/*
 	 * Check the block's siblings; this function absorbs error codes
 	 * for us.
 	 */
@@ -465,6 +547,8 @@ xfs_scrub_btree(
 	struct xfs_btree_block		*block;
 	int				level;
 	struct xfs_buf			*bp;
+	struct check_owner		*co;
+	struct check_owner		*n;
 	int				i;
 	int				error = 0;
 
@@ -556,6 +640,14 @@ xfs_scrub_btree(
 	}
 
 out:
+	/* Process deferred owner checks on btree blocks. */
+	list_for_each_entry_safe(co, n, &bs.to_check, list) {
+		if (!error)
+			error = xfs_scrub_btree_check_block_owner(&bs,
+					co->level, co->daddr);
+		list_del(&co->list);
+		kmem_free(co);
+	}
 
 	return error;
 }

