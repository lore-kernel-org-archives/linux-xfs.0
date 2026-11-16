Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871099;
	b=L1PDzHKT9gM0us5lMoBUQ/ghO/QjGWNzD7nyZhr3IvaLPgv7lj3oI/wFWHOOAaHeZ8bq
	 QIUk62Lj71tBhXbprtfOuz1vIe8BOyNOlHs89Ci0Qbal+7pm3vk4NFf+uHZ455DyScIbu
	 SvwFhE+8iWVL8bDY/DIxZ6E5C88dWcKpnju/+w81qmt9kZeeeIJW6Em2/RzeTeKo1dtoa
	 9ABisprgTadRq/rTO4W3kSHCg9bgcjYZhz1NxGYNyiQqBfHAzRVIov2VLc48BucpYwTnr
	 18KLPbmQbVvGPga6okoExCIOd8IS6thOr49aZqkf2MhnacxI7iYhxtJgUeZAQzTlPAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yJP584/rRlnmlekmNq+Fv+yNBPqXcnn7mGg1hZAtyh4=;
	b=JIMKtjnFbjdFaxVinL3q9MIbb8kSD3NUcVYhR6cj1x9/hgQ5nPl5T6AQR9mwjrS270SR
	 dMQhYz2ULiwrQqUg8eXOpoRRfjE8JFZiZwS8nvpRyd37bfWtJogY5ZRVb0th4a89DokcT
	 1wJM7HR1zDgXyvKuM0/7LhDuwy7PS3YOuX8nyU4YNx1H9dDGu8swsSL6NySY8zZ9/1P9x
	 Q5RmRVQGn18L/ccX926LjnzaHPwk9E5gAj46qzVvxXn03DXFVu1+twU39UQ/7gg4lmlgo
	 kqWM/T5LNMLoTsdsu6Lg8DfMr7Ug9JEBG+gLB8Q9jDi889+f5qcu2TINOHUuF0Y/1RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IEnHrO46;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0013F606A32C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IEnHrO46
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C341F000C7;
	Mon, 16 Nov 2026 23:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871098;
	bh=yJP584/rRlnmlekmNq+Fv+yNBPqXcnn7mGg1hZAtyh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IEnHrO4687OpSaANUsdiqMy4kfL5NyZ/MdLgX6wUu+cCWCN9LvsGTJSqSmbEZK/au
	 p/sCUYzR0dAKxnXOTtCVbXkB4sZF3Zh7b05eBsJAlr4dKPVvbaurvnJUTR9n/DHT5B
	 3RRtgL1XSqW8MTgysif98Rhwlz5yI3ccCbOZ5W8n/8+YWWIs9i7RA5AgQ/anboNX20
	 1p+5O60BhP2Dv3qfQsA7vukLr+kVkQEWP8lhIBylZQHVsn7IR2D0rXsSg9gyoVD5Dv
	 mUTqMOgr/xufgWRswC3/frQgagVOFYoy93JPxdIc0kMHOhIa2Pg0Rw1pcnRgr2iBgw
	 oX9pAO9EFICUQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 50/59] xfs: allow a long format btree root to be checked without a cursor
Date: Tue, 17 Nov 2026 10:15:07 +1100
Message-ID: <20261116231707.3625263-51-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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
index e03b83b1d9b2..1971d2a56a3d 100644
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
index c4337ab244f2..ad095a8b837c 100644
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

