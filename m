Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39966 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbcKEA1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:27:17 -0400
Subject: [PATCH 25/39] xfs: cross-reference bnobt records with cntbt
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:27:12 -0700
Message-ID: <147830563269.4165.13867077929260899377.stgit@birch.djwong.org>
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

Scrub should make sure that each bnobt record has a corresponding
cntbt record.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c |    2 +-
 libxfs/xfs_alloc.h |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 76622d1..3b8323d 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -165,7 +165,7 @@ xfs_alloc_lookup_ge(
  * Lookup the first record less than or equal to [bno, len]
  * in the btree given by cur.
  */
-static int				/* error */
+int					/* error */
 xfs_alloc_lookup_le(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 3fd6540..b79159c 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -202,6 +202,13 @@ xfs_free_extent(
 	enum xfs_ag_resv_type	type);	/* block reservation type */
 
 int				/* error */
+xfs_alloc_lookup_le(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	int			*stat);	/* success/failure */
+
+int				/* error */
 xfs_alloc_lookup_ge(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */

