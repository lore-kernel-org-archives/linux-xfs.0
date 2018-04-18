Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCke (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:40:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2a2Xj097375
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:34 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8jsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:34 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2eXNc012165
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:34 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2eXFs025471
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:33 GMT
Subject: [PATCH 09/11] xfs: btree scrub should check minrecs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:40:32 -0700
Message-ID: <152401923232.11465.11554889141647009009.stgit@magnolia>
In-Reply-To: <152401916729.11465.4212188839231900136.stgit@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Strengthen the btree block header checks to detect the number of records
being less than the btree type's minimum record count.  Certain blocks
are allowed to violate this constraint -- specifically any btree block
at the top of the tree can have fewer than minrecs records.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/btree.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index ea972da..2d29dce 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -455,6 +455,44 @@ xfs_scrub_btree_check_owner(
 }
 
 /*
+ * Check that this btree block has at least minrecs records or is one of the
+ * special blocks that don't require that.
+ */
+STATIC void
+xfs_scrub_btree_check_minrecs(
+	struct xfs_scrub_btree	*bs,
+	int			level,
+	struct xfs_btree_block	*block)
+{
+	unsigned int		numrecs;
+	int			ok_level;
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+
+	/* More records than minrecs means the block is ok. */
+	if (numrecs >= bs->cur->bc_ops->get_minrecs(bs->cur, level))
+		return;
+
+	/*
+	 * Certain btree blocks /can/ have fewer than minrecs records.  Any
+	 * level greater than or equal to the level of the highest dedicated
+	 * btree block are allowed to violate this constraint.
+	 *
+	 * For a btree rooted in a block, the btree root can have fewer than
+	 * minrecs records.  If the btree is rooted in an inode and does not
+	 * store records in the root, the direct children of the root and the
+	 * root itself can have fewer than minrecs records.
+	 */
+	ok_level = bs->cur->bc_nlevels - 1;
+	if (bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+		ok_level--;
+	if (level >= ok_level)
+		return;
+
+	xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, level);
+}
+
+/*
  * Grab and scrub a btree block given a btree pointer.  Returns block
  * and buffer pointers (if applicable) if they're ok to use.
  */
@@ -491,6 +529,8 @@ xfs_scrub_btree_get_block(
 	if (*pbp)
 		xfs_scrub_buffer_recheck(bs->sc, *pbp);
 
+	xfs_scrub_btree_check_minrecs(bs, level, *pblock);
+
 	/*
 	 * Check the block's owner; this function absorbs error codes
 	 * for us.

