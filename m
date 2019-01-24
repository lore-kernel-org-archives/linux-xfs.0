Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727649AbfAXPyl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Jan 2019 10:54:41 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4D4C119CF7B
        for <linux-xfs@vger.kernel.org>; Thu, 24 Jan 2019 15:54:41 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E936F2635A
        for <linux-xfs@vger.kernel.org>; Thu, 24 Jan 2019 15:54:40 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfs: support magic value in xfs_buf_ops
Date: Thu, 24 Jan 2019 10:54:40 -0500
Message-Id: <20190124155440.46469-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add a field to specify the v4 and v5 magic values in xfs_buf_ops.
This allows otherwise identical verifiers to distinguish between
and verify different magic values (inobt vs. finobt buffers). This
also facilitates verification of the appropriate magic value based
on superblock version.

The magic field is optional and is free to be used as appropriate
for each particular verifier.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

What do folks think of something like this as a lightweight (and
untested) means to do proper [f]inobt magic verification? For reference,
the initial version of this put together to help root cause a user
report is here[1]. I was hoping to do the same thing with less code
duplication. A couple things that come to mind:

1. I know scrub has at least one place where we invoke the verifier with
->b_ops == NULL, which will cause this to explode. Could we fix that up
to assign and reset ->b_ops to accommodate something like this, or is
that problematic?

2. We have some other verifiers around that actually use the buffer
magic to set a more specific verifier. See xfs_da3_node_read_verify()
for an example. I'm not sure this is all that useful for such higher
level verifiers, but I think we'd at least be able to use it for the
underlying verifiers. That might provide some extra sb version vs. magic
sanity checking for places that might not already look at the sb version
(otherwise it's just refactoring).

Thoughts or other ideas before I try to apply this more broadly? Thanks.

Brian

[1] https://marc.info/?l=linux-xfs&m=154809431726435&w=2

 fs/xfs/libxfs/xfs_ialloc_btree.c | 27 +++++++++++++++++----------
 fs/xfs/xfs_buf.h                 |  1 +
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 9b25e7a0df47..59b0cf1d759a 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -259,6 +259,12 @@ xfs_inobt_verify(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	xfs_failaddr_t		fa;
 	unsigned int		level;
+	uint32_t		magic;
+
+	ASSERT(bp->b_ops);
+	magic = bp->b_ops->magic[xfs_sb_version_hascrc(&mp->m_sb)];
+	if (block->bb_magic != cpu_to_be32(magic))
+		return __this_address;
 
 	/*
 	 * During growfs operations, we can't verify the exact owner as the
@@ -270,18 +276,10 @@ xfs_inobt_verify(
 	 * but beware of the landmine (i.e. need to check pag->pagi_init) if we
 	 * ever do.
 	 */
-	switch (block->bb_magic) {
-	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
-	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		fa = xfs_btree_sblock_v5hdr_verify(bp);
 		if (fa)
 			return fa;
-		/* fall through */
-	case cpu_to_be32(XFS_IBT_MAGIC):
-	case cpu_to_be32(XFS_FIBT_MAGIC):
-		break;
-	default:
-		return __this_address;
 	}
 
 	/* level verification */
@@ -328,6 +326,15 @@ xfs_inobt_write_verify(
 
 const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.name = "xfs_inobt",
+	.magic = { XFS_IBT_MAGIC, XFS_IBT_CRC_MAGIC },
+	.verify_read = xfs_inobt_read_verify,
+	.verify_write = xfs_inobt_write_verify,
+	.verify_struct = xfs_inobt_verify,
+};
+
+const struct xfs_buf_ops xfs_finobt_buf_ops = {
+	.name = "xfs_finobt",
+	.magic = { XFS_FIBT_MAGIC, XFS_FIBT_CRC_MAGIC },
 	.verify_read = xfs_inobt_read_verify,
 	.verify_write = xfs_inobt_write_verify,
 	.verify_struct = xfs_inobt_verify,
@@ -389,7 +396,7 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 	.init_rec_from_cur	= xfs_inobt_init_rec_from_cur,
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
-	.buf_ops		= &xfs_inobt_buf_ops,
+	.buf_ops		= &xfs_finobt_buf_ops,
 	.diff_two_keys		= xfs_inobt_diff_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b9f5511ea998..ce61e6b94725 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -125,6 +125,7 @@ struct xfs_buf_map {
 
 struct xfs_buf_ops {
 	char *name;
+	uint32_t magic[2];
 	void (*verify_read)(struct xfs_buf *);
 	void (*verify_write)(struct xfs_buf *);
 	xfs_failaddr_t (*verify_struct)(struct xfs_buf *bp);
-- 
2.17.2
