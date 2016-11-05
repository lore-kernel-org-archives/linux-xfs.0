Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19050 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754303AbcKEA1e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:27:34 -0400
Subject: [PATCH 28/39] xfs: cross-reference refcount btree during scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:27:30 -0700
Message-ID: <147830565091.4165.3968389866491066069.stgit@birch.djwong.org>
In-Reply-To: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
References: <147830546754.4165.17790362300876898017.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

During metadata btree scrub, we should cross-reference with the
reference counts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_refcount.c |   19 +++++++++++++++++++
 libxfs/xfs_refcount.h |    3 +++
 2 files changed, 22 insertions(+)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 0508ec3..124d5c0 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1695,3 +1695,22 @@ xfs_refcount_recover_cow_leftovers(
 	xfs_trans_cancel(tp);
 	goto out_free;
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_refcount_has_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*exists)
+{
+	union xfs_btree_irec	low;
+	union xfs_btree_irec	high;
+
+	memset(&low, 0, sizeof(low));
+	low.rc.rc_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rc.rc_startblock = bno + len - 1;
+
+	return xfs_btree_has_record(cur, &low, &high, exists);
+}
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 098dc66..78cb142 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -67,4 +67,7 @@ extern int xfs_refcount_free_cow_extent(struct xfs_mount *mp,
 extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
 		xfs_agnumber_t agno);
 
+extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+
 #endif	/* __XFS_REFCOUNT_H__ */

