Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306363988E3
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871380; cv=none; b=ndF40ag/VcBw3xUhhYNNKKBrdhCGUb8lP3QB2N5iR6ov6wINmaRSAIqkeW+qACvRH1oPZgGHd8jngIZA+XepCkw+6Yfar3zVjDcZQGQpxCeE6BXBXr/HTcCJip6fwAhaoIUahHdZXaXkheHhR7vJ2KvywJERpCeyYrH0O48lPLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871380; c=relaxed/simple;
	bh=szhQYpU6Sxedm0bqz+JVo0w+PCATwt5505ZWJQaAGqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT5ZLwDmFS7rgPSKcLA1NTPe0TxhejGI4wFhUaBizIJ+X4RLJHRcn/miDCEphNqMB2JjQpgXEXjOn7+4Sq+6J/FDP070/yLJXduNxtlWciSC4d45I5MfCYuDIBMj/3ef+xbwEuNhv93IcQpGNnck1Yr88GkgNRY3ps5UH0RSHi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnva5x9S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnva5x9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514361F00893;
	Tue, 13 Oct 2026 06:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871379;
	bh=HLFuXKBssovNf9W9GQXc8euIGSCSYgVrV6ogD1UilTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnva5x9STcxU9EFG78rKvhiQhEHWEgI7Aik/38b4h7l5pf8hsGiHM5xYCLrdt95gQ
	 0TOynHyb3x94WRecjX6yzUH3+lUO5wg+rf//vYizKQwcFwer8KsE3pmTjKYf7ljYd4
	 MyJge0fCU220QVaajL6PfCy6yKrOWRNGJ9TFfosPUcaNCTpxhZeN5yKZMN4S4TyN4F
	 PcFPKNcJt+xrEgC12VIU647ItWykSTXJz54V6G1MMyxun+ghqMiYvqVbmX1tAuMfJL
	 Hhh1CuLGqH0VPAJcqdSSHZY0gCa+ah6tOA/M+XLVoPd07yKJiZLgf2G7DrHdYB3/ft
	 A3KifhUuZrUfw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 40/48] xfs: allow a long format btree root to be checked without a cursor
Date: Tue, 13 Oct 2026 17:01:30 +1100
Message-ID: <20261013060204.3138690-41-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The long format btree block header check derives the block magic and the
maximum record count from a btree cursor. An inode rooted btree logged to the
journal has no cursor available during recovery, so this check cannot be used to
validate a logged btree root.

Rework the header check to take the magic and maximum records as arguments
rather than reading them from a cursor. The cursor based callers derive both
from the cursor and pass them in, so their behaviour is unchanged.

Add xfs_btree_check_fsblock_root_hdr() for callers that hold a long format btree
root but no cursor. It checks the root against the supplied magic, maximum
records and level range, and confirms the root has no siblings.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 50 ++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_btree.h |  4 ++++
 2 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 7effebe297ea..8e56c948ae6d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -123,13 +123,13 @@ xfs_btree_check_agblock_siblings(
 
 static xfs_failaddr_t
 __xfs_btree_check_lblock_hdr(
-	struct xfs_btree_cur	*cur,
+	struct xfs_mount	*mp,
+	uint32_t		magic,
+	unsigned int		maxrecs,
 	struct xfs_btree_block	*block,
 	int			level,
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
@@ -140,12 +140,11 @@ __xfs_btree_check_lblock_hdr(
 			return __this_address;
 	}
 
-	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(mp, cur->bc_ops))
+	if (be32_to_cpu(block->bb_magic) != magic)
 		return __this_address;
 	if (be16_to_cpu(block->bb_level) != level)
 		return __this_address;
-	if (be16_to_cpu(block->bb_numrecs) >
-	    cur->bc_ops->get_maxrecs(cur, level))
+	if (be16_to_cpu(block->bb_numrecs) > maxrecs)
 		return __this_address;
 
 	return NULL;
@@ -157,16 +156,17 @@ __xfs_btree_check_lblock_hdr(
  */
 static xfs_failaddr_t
 __xfs_btree_check_fsblock(
-	struct xfs_btree_cur	*cur,
+	struct xfs_mount	*mp,
+	uint32_t		magic,
+	unsigned int		maxrecs,
 	struct xfs_btree_block	*block,
 	int			level,
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_failaddr_t		fa;
 	xfs_fsblock_t		fsb;
 
-	fa = __xfs_btree_check_lblock_hdr(cur, block, level, bp);
+	fa = __xfs_btree_check_lblock_hdr(mp, magic, maxrecs, block, level, bp);
 	if (fa)
 		return fa;
 
@@ -191,6 +191,29 @@ __xfs_btree_check_fsblock(
 	return fa;
 }
 
+/*
+ * Check the header of a long format btree root that sits in an inode fork,
+ * without needing a btree cursor. The block is a root, so it has no siblings.
+ * The caller supplies the block magic, the maximum records for the block, and
+ * the valid level range for the btree.
+ */
+xfs_failaddr_t
+xfs_btree_check_fsblock_root_hdr(
+	struct xfs_mount	*mp,
+	uint32_t		magic,
+	unsigned int		maxrecs,
+	struct xfs_btree_block	*block,
+	unsigned int		minlevel,
+	unsigned int		maxlevel)
+{
+	unsigned int		level = be16_to_cpu(block->bb_level);
+
+	if (level < minlevel || level > maxlevel)
+		return __this_address;
+
+	return __xfs_btree_check_fsblock(mp, magic, maxrecs, block, level, NULL);
+}
+
 /*
  * Check an in-memory btree block header.  Return the address of the failing
  * check, or NULL if everything is ok.
@@ -202,11 +225,13 @@ __xfs_btree_check_memblock(
 	int			level,
 	struct xfs_buf		*bp)
 {
+	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_buftarg	*btp = cur->bc_mem.xfbtree->target;
 	xfs_failaddr_t		fa;
 	xfbno_t			bno;
 
-	fa = __xfs_btree_check_lblock_hdr(cur, block, level, bp);
+	fa = __xfs_btree_check_lblock_hdr(mp, xfs_btree_magic(mp, cur->bc_ops),
+			cur->bc_ops->get_maxrecs(cur, level), block, level, bp);
 	if (fa)
 		return fa;
 
@@ -277,7 +302,10 @@ __xfs_btree_check_block(
 	case XFS_BTREE_TYPE_AG:
 		return __xfs_btree_check_agblock(cur, block, level, bp);
 	case XFS_BTREE_TYPE_INODE:
-		return __xfs_btree_check_fsblock(cur, block, level, bp);
+		return __xfs_btree_check_fsblock(cur->bc_mp,
+				xfs_btree_magic(cur->bc_mp, cur->bc_ops),
+				cur->bc_ops->get_maxrecs(cur, level),
+				block, level, bp);
 	default:
 		ASSERT(0);
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 60e78572e725..c9ae26454372 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -345,6 +345,10 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
 
 xfs_failaddr_t __xfs_btree_check_block(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
+xfs_failaddr_t xfs_btree_check_fsblock_root_hdr(struct xfs_mount *mp,
+		uint32_t magic, unsigned int maxrecs,
+		struct xfs_btree_block *block, unsigned int minlevel,
+		unsigned int maxlevel);
 int __xfs_btree_check_ptr(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr, int index, int level);
 
-- 
2.55.0

