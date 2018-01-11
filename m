Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754372AbeAKTk1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 14:40:27 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 19D64C05975E
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2018 19:40:27 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B56946560F
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2018 19:40:26 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: account finobt blocks properly in perag reservation
Date: Thu, 11 Jan 2018 14:40:24 -0500
Message-Id: <20180111194024.28775-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

XFS started using the perag metadata reservation pool for free inode
btree blocks in commit 76d771b4cbe33 ("xfs: use per-AG reservations
for the finobt"). To handle backwards compatibility, finobt blocks
are accounted against the pool so long as the full reservation is
available at mount time. Otherwise the ->m_inotbt_nores flag is set
and the filesystem falls back to the traditional per-transaction
finobt reservation.

This commit has two problems:

- finobt blocks are always accounted against the metadata
  reservation on allocation, regardless of ->m_inotbt_nores state
- finobt blocks are never returned to the reservation pool on free

The first problem affects reflink+finobt filesystems where the full
finobt reservation is not available at mount time. finobt blocks are
essentially stolen from the reflink reservation, putting refcountbt
management at risk of allocation failure. The second problem is an
unconditional leak of metadata reservation whenever finobt is
enabled.

Update the finobt block allocation callouts to consider
->m_inotbt_nores and account blocks appropriately. Blocks should be
consistently accounted against the metadata pool when
->m_inotbt_nores is false and otherwise tagged as RESV_NONE.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Update both allocation and free paths to consider ->m_inotbt_nores.
v1: https://marc.info/?l=linux-xfs&m=151552296126950&w=2

 fs/xfs/libxfs/xfs_ialloc_btree.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 47f44d624cb1..af197a5f3a82 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -141,21 +141,42 @@ xfs_finobt_alloc_block(
 	union xfs_btree_ptr	*new,
 	int			*stat)
 {
+	if (cur->bc_mp->m_inotbt_nores)
+		return xfs_inobt_alloc_block(cur, start, new, stat);
 	return __xfs_inobt_alloc_block(cur, start, new, stat,
 			XFS_AG_RESV_METADATA);
 }
 
 STATIC int
-xfs_inobt_free_block(
+__xfs_inobt_free_block(
 	struct xfs_btree_cur	*cur,
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	enum xfs_ag_resv_type	resv)
 {
 	struct xfs_owner_info	oinfo;
 
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	return xfs_free_extent(cur->bc_tp,
 			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
-			&oinfo, XFS_AG_RESV_NONE);
+			&oinfo, resv);
+}
+
+STATIC int
+xfs_inobt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	return __xfs_inobt_free_block(cur, bp, XFS_AG_RESV_NONE);
+}
+
+STATIC int
+xfs_finobt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	if (cur->bc_mp->m_inotbt_nores)
+		return xfs_inobt_free_block(cur, bp);
+	return __xfs_inobt_free_block(cur, bp, XFS_AG_RESV_METADATA);
 }
 
 STATIC int
@@ -380,7 +401,7 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
 	.alloc_block		= xfs_finobt_alloc_block,
-	.free_block		= xfs_inobt_free_block,
+	.free_block		= xfs_finobt_free_block,
 	.get_minrecs		= xfs_inobt_get_minrecs,
 	.get_maxrecs		= xfs_inobt_get_maxrecs,
 	.init_key_from_rec	= xfs_inobt_init_key_from_rec,
-- 
2.13.6

