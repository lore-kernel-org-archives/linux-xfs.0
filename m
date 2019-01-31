Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733301AbfAaPqM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 10:46:12 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 249B8C07754E
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 15:46:11 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEEA4600C2
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 15:46:10 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 4/7] xfs: distinguish between inobt and finobt magic values
Date: Thu, 31 Jan 2019 10:46:05 -0500
Message-Id: <20190131154608.36837-5-bfoster@redhat.com>
In-Reply-To: <20190131154608.36837-1-bfoster@redhat.com>
References: <20190131154608.36837-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The inode btree verifier code is shared between the inode btree and
free inode btree because the underlying metadata formats are
essentially equivalent. A side effect of this is that the verifier
cannot determine whether a particular btree block should have an
inobt or finobt magic value.

This logic allows an unfortunate xfs_repair bug to escape detection
where certain level > 0 nodes of the finobt are stamped with inobt
magic by xfs_repair finobt reconstruction. This is fortunately not a
severe problem since the inode btree magic values do not contribute
to any changes in kernel behavior, but we do need a means to detect
and prevent this problem in the future.

Add a field to xfs_buf_ops to store the v4 and v5 superblock magic
values expected by a particular verifier. Add a helper to check an
on-disk magic value against the value expected by the verifier. Call
the helper from the shared [f]inobt verifier code for magic value
verification. This ensures that the inode btree blocks each have the
appropriate magic value based on specific tree type and superblock
version.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc_btree.c | 16 +++++++---------
 fs/xfs/xfs_buf.c                 | 19 +++++++++++++++++++
 fs/xfs/xfs_buf.h                 |  2 ++
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 798269eb4767..c2df1f89eec8 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -260,6 +260,9 @@ xfs_inobt_verify(
 	xfs_failaddr_t		fa;
 	unsigned int		level;
 
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
 	/*
 	 * During growfs operations, we can't verify the exact owner as the
 	 * perag is not fully initialised and hence not attached to the buffer.
@@ -270,18 +273,10 @@ xfs_inobt_verify(
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
@@ -328,6 +323,7 @@ xfs_inobt_write_verify(
 
 const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.name = "xfs_inobt",
+	.magic = { cpu_to_be32(XFS_IBT_MAGIC), cpu_to_be32(XFS_IBT_CRC_MAGIC) },
 	.verify_read = xfs_inobt_read_verify,
 	.verify_write = xfs_inobt_write_verify,
 	.verify_struct = xfs_inobt_verify,
@@ -335,6 +331,8 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 
 const struct xfs_buf_ops xfs_finobt_buf_ops = {
 	.name = "xfs_finobt",
+	.magic = { cpu_to_be32(XFS_FIBT_MAGIC),
+		   cpu_to_be32(XFS_FIBT_CRC_MAGIC) },
 	.verify_read = xfs_inobt_read_verify,
 	.verify_write = xfs_inobt_write_verify,
 	.verify_struct = xfs_inobt_verify,
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 222b5260ed35..0481c19fe5ae 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2204,3 +2204,22 @@ void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
 
 	atomic_set(&bp->b_lru_ref, lru_ref);
 }
+
+/*
+ * Verify an on-disk magic value against the magic value specified in the
+ * verifier structure. The verifier magic is in disk byte order so the caller is
+ * expected to pass the value directly from disk.
+ */
+bool
+xfs_verify_magic(
+	struct xfs_buf		*bp,
+	uint32_t		dmagic)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	int			idx;
+
+	idx = xfs_sb_version_hascrc(&mp->m_sb);
+	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic[idx])))
+		return false;
+	return dmagic == bp->b_ops->magic[idx];
+}
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 1c436a85b71d..8d8fbcf54dda 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -125,6 +125,7 @@ struct xfs_buf_map {
 
 struct xfs_buf_ops {
 	char *name;
+	uint32_t magic[2];		/* v4 and v5 on disk magic values */
 	void (*verify_read)(struct xfs_buf *);
 	void (*verify_write)(struct xfs_buf *);
 	xfs_failaddr_t (*verify_struct)(struct xfs_buf *bp);
@@ -386,5 +387,6 @@ extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
 int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
+bool xfs_verify_magic(struct xfs_buf *, uint32_t);
 
 #endif	/* __XFS_BUF_H__ */
-- 
2.17.2
