Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2671FBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TaBl9dBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B242C433C7;
	Sun, 31 Dec 2023 20:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053958;
	bh=ZuUXVgpPIz7uoOvU656bXVh7FxENwOII74vI4xDOWUY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TaBl9dBXMC1ZXIW1WprRhDmjVGSlM17GdBY+s+P5dRDh2xm6P+J2gnk518TdorvvG
	 OeGu0vpFG3O+tTGYIDyLxaSpeyMYfAqby52GRusBRNx+to67+Z8Egop3EQmP5AY2TM
	 54rN5s3hjeYtLNBzHQ8yzJAZUwmC86yo3nSyklsfE3UAE4SKpI6iWZbKTS1su7Swc6
	 hwwAP7GOhrvUTcKlJ1LRCupOx0zcpcNU/rFM/dSEv99qm9wuDggdAR2bTfPSccAGSj
	 mafnlvm1cbBwxvZDbXC66/A0ymb5uoK/+o8CEFlIC/ndNwpVjQ0qi4+KYPWdLUBIJC
	 G/GnfhSf6SVMg==
Date: Sun, 31 Dec 2023 12:19:17 -0800
Subject: [PATCH 9/9] xfs: remove unnecessary fields in xfbtree_config
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404830659.1749286.12453760879570391978.stgit@frogsfrogsfrogs>
In-Reply-To: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove these fields now that we get all the info we need from the btree
ops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_mem.h  |    9 ---------
 fs/xfs/libxfs/xfs_rmap_btree.c |    1 -
 fs/xfs/scrub/trace.h           |   10 ++++------
 fs/xfs/scrub/xfbtree.c         |    4 ++--
 4 files changed, 6 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_mem.h b/fs/xfs/libxfs/xfs_btree_mem.h
index 29f97c5030465..1f961f3f55444 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.h
+++ b/fs/xfs/libxfs/xfs_btree_mem.h
@@ -17,17 +17,8 @@ struct xfbtree_config {
 
 	/* Owner of this btree. */
 	unsigned long long		owner;
-
-	/* Btree type number */
-	xfs_btnum_t			btnum;
-
-	/* XFBTREE_CREATE_* flags */
-	unsigned int			flags;
 };
 
-/* btree has long pointers */
-#define XFBTREE_CREATE_LONG_PTRS	(1U << 0)
-
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
 unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f5889da0bff76..b4a8b4b62456b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -669,7 +669,6 @@ xfs_rmapbt_mem_create(
 	struct xfbtree_config	cfg = {
 		.btree_ops	= &xfs_rmapbt_mem_ops,
 		.target		= target,
-		.btnum		= XFS_BTNUM_RMAP,
 		.owner		= agno,
 	};
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 06d593dcd697a..14bbefdd7ab81 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2218,8 +2218,7 @@ TRACE_EVENT(xfbtree_create,
 		 struct xfbtree *xfbt),
 	TP_ARGS(mp, cfg, xfbt),
 	TP_STRUCT__entry(
-		__field(xfs_btnum_t, btnum)
-		__field(unsigned int, xfbtree_flags)
+		__field(const void *, btree_ops)
 		__field(unsigned long, xfino)
 		__field(unsigned int, leaf_mxr)
 		__field(unsigned int, leaf_mnr)
@@ -2228,8 +2227,7 @@ TRACE_EVENT(xfbtree_create,
 		__field(unsigned long long, owner)
 	),
 	TP_fast_assign(
-		__entry->btnum = cfg->btnum;
-		__entry->xfbtree_flags = cfg->flags;
+		__entry->btree_ops = cfg->btree_ops;
 		__entry->xfino = xfbtree_ino(xfbt);
 		__entry->leaf_mxr = xfbt->maxrecs[0];
 		__entry->node_mxr = xfbt->maxrecs[1];
@@ -2237,9 +2235,9 @@ TRACE_EVENT(xfbtree_create,
 		__entry->node_mnr = xfbt->minrecs[1];
 		__entry->owner = cfg->owner;
 	),
-	TP_printk("xfino 0x%lx btnum %s owner 0x%llx leaf_mxr %u leaf_mnr %u node_mxr %u node_mnr %u",
+	TP_printk("xfino 0x%lx btree_ops %pS owner 0x%llx leaf_mxr %u leaf_mnr %u node_mxr %u node_mnr %u",
 		  __entry->xfino,
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __entry->btree_ops,
 		  __entry->owner,
 		  __entry->leaf_mxr,
 		  __entry->leaf_mnr,
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index 9d2e01614d1ff..016026947019a 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -414,7 +414,7 @@ xfbtree_rec_bytes(
 {
 	unsigned int			blocklen = xfo_to_b(1);
 
-	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS) {
+	if (cfg->btree_ops->geom_flags & XFS_BTREE_LONG_PTRS) {
 		if (xfs_has_crc(mp))
 			return blocklen - XFS_BTREE_LBLOCK_CRC_LEN;
 
@@ -504,7 +504,7 @@ xfbtree_create(
 	xfboff_bitmap_init(&xfbt->freespace);
 
 	/* Set up min/maxrecs for this btree. */
-	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS)
+	if (cfg->btree_ops->geom_flags & XFS_BTREE_LONG_PTRS)
 		keyptr_len += sizeof(__be64);
 	else
 		keyptr_len += sizeof(__be32);

