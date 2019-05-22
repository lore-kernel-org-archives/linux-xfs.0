Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbfEVSFt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 14:05:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 39A7930B9305
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:49 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC0775C296
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 05/11] xfs: track active state of allocation btree cursors
Date: Wed, 22 May 2019 14:05:40 -0400
Message-Id: <20190522180546.17063-6-bfoster@redhat.com>
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
References: <20190522180546.17063-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The upcoming allocation algorithm update searches multiple
allocation btree cursors concurrently. As such, it requires an
active state to track when a particular cursor should continue
searching. While active state will be modified based on higher level
logic, we can define base functionality based on the result of
allocation btree lookups.

Define an active flag in the private area of the btree cursor.
Update it based on the result of lookups in the existing allocation
btree helpers. Finally, provide a new helper to query the current
state.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c       | 24 +++++++++++++++++++++---
 fs/xfs/libxfs/xfs_alloc_btree.c |  1 +
 fs/xfs/libxfs/xfs_btree.h       |  3 +++
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e2fa58f4d477..11d284989399 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -148,9 +148,13 @@ xfs_alloc_lookup_eq(
 	xfs_extlen_t		len,	/* length of extent */
 	int			*stat)	/* success/failure */
 {
+	int			error;
+
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
-	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+	error = xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+	cur->bc_private.a.priv.abt.active = *stat;
+	return error;
 }
 
 /*
@@ -164,9 +168,13 @@ xfs_alloc_lookup_ge(
 	xfs_extlen_t		len,	/* length of extent */
 	int			*stat)	/* success/failure */
 {
+	int			error;
+
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
-	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
+	error = xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
+	cur->bc_private.a.priv.abt.active = *stat;
+	return error;
 }
 
 /*
@@ -180,9 +188,19 @@ xfs_alloc_lookup_le(
 	xfs_extlen_t		len,	/* length of extent */
 	int			*stat)	/* success/failure */
 {
+	int			error;
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
-	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+	cur->bc_private.a.priv.abt.active = *stat;
+	return error;
+}
+
+static inline bool
+xfs_alloc_cur_active(
+	struct xfs_btree_cur	*cur)
+{
+	return cur && cur->bc_private.a.priv.abt.active;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 9fe949f6055e..cfa28890af27 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -508,6 +508,7 @@ xfs_allocbt_init_cursor(
 
 	cur->bc_private.a.agbp = agbp;
 	cur->bc_private.a.agno = agno;
+	cur->bc_private.a.priv.abt.active = false;
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index e3b3e9dce5da..3c105b7dffe8 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -183,6 +183,9 @@ union xfs_btree_cur_private {
 		unsigned long	nr_ops;		/* # record updates */
 		int		shape_changes;	/* # of extent splits */
 	} refc;
+	struct {
+		bool		active;		/* allocation cursor state */
+	} abt;
 };
 
 /*
-- 
2.17.2
