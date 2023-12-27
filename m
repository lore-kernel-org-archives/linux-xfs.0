Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106A2384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StUbwayL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A640C433C7;
	Mon,  1 Jan 2024 00:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067925;
	bh=9ZMRH8QM6LBLNa/owV8Cvy83WygrnqRQbu4PW+zUmqo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=StUbwayLOXZFmDSqeHe9ay0WLZnvqjnxPEL2Gy7t056XQbW76ZZW/JKcKwvXaOqIQ
	 xfQDzD5y4o+/ZL9UgAVH/ogDBMNsbhdbn62sOE2OxtoElpE4sQ58OK3hprtJjtlCci
	 dW9zFjDdUjlI4mg30BTuhH2TyS9cKbbyO4PibMZWv1naKMAxvkG8h+Dz7kHg0i8EFl
	 TsZu2UsGpu4zwn4lbVAzm3V/mSzyWlLW+Ad8FzVAwFkUMpb2zVC6+w8M99nJL6/MJV
	 LzOABybbA9EV+hy1il0lCGJyg1BVseDcUzKgYQawdGX1Pq/2yDACAUZoDbGoMEAK4+
	 qHFNuV7zuorQQ==
Date: Sun, 31 Dec 2023 16:12:05 +9900
Subject: [PATCH 06/47] xfs: prepare rmap functions to deal with rtrmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015393.1815505.8036795795617210493.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Prepare the high-level rmap functions to deal with the new realtime
rmapbt and its slightly different conventions.  Provide the ability
to talk to either rmapbt or rtrmapbt formats from the same high
level code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap.h |    3 ++
 2 files changed, 69 insertions(+)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 3e95599ab8a..007f17cc644 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -24,6 +24,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "defer_item.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -263,11 +264,72 @@ xfs_rmap_check_irec(
 	return NULL;
 }
 
+xfs_failaddr_t
+xfs_rtrmap_check_irec(
+	struct xfs_rtgroup		*rtg,
+	const struct xfs_rmap_irec	*irec)
+{
+	struct xfs_mount		*mp = rtg->rtg_mount;
+	bool				is_inode;
+	bool				is_unwritten;
+	bool				is_bmbt;
+	bool				is_attr;
+
+	if (irec->rm_blockcount == 0)
+		return __this_address;
+
+	if (irec->rm_owner == XFS_RMAP_OWN_FS) {
+		if (irec->rm_startblock != 0)
+			return __this_address;
+		if (irec->rm_blockcount != mp->m_sb.sb_rextsize)
+			return __this_address;
+		if (irec->rm_offset != 0)
+			return __this_address;
+	} else {
+		if (!xfs_verify_rgbext(rtg, irec->rm_startblock,
+					    irec->rm_blockcount))
+			return __this_address;
+	}
+
+	if (!(xfs_verify_ino(mp, irec->rm_owner) ||
+	      (irec->rm_owner <= XFS_RMAP_OWN_FS &&
+	       irec->rm_owner >= XFS_RMAP_OWN_MIN)))
+		return __this_address;
+
+	/* Check flags. */
+	is_inode = !XFS_RMAP_NON_INODE_OWNER(irec->rm_owner);
+	is_bmbt = irec->rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec->rm_flags & XFS_RMAP_ATTR_FORK;
+	is_unwritten = irec->rm_flags & XFS_RMAP_UNWRITTEN;
+
+	if (!is_inode && irec->rm_owner != XFS_RMAP_OWN_FS)
+		return __this_address;
+
+	if (!is_inode && irec->rm_offset != 0)
+		return __this_address;
+
+	if (is_bmbt || is_attr)
+		return __this_address;
+
+	if (is_unwritten && !is_inode)
+		return __this_address;
+
+	/* Check for a valid fork offset, if applicable. */
+	if (is_inode &&
+	    !xfs_verify_fileext(mp, irec->rm_offset, irec->rm_blockcount))
+		return __this_address;
+
+	return NULL;
+}
+
 static inline xfs_failaddr_t
 xfs_rmap_check_btrec(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*irec)
 {
+	if (cur->bc_btnum == XFS_BTNUM_RTRMAP)
+		return xfs_rtrmap_check_irec(cur->bc_ino.rtg, irec);
+
 	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
 		return xfs_rmap_check_irec(cur->bc_mem.pag, irec);
 	return xfs_rmap_check_irec(cur->bc_ag.pag, irec);
@@ -284,6 +346,10 @@ xfs_rmap_complain_bad_rec(
 	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
 		xfs_warn(mp,
  "In-Memory Reverse Mapping BTree record corruption detected at %pS!", fa);
+	else if (cur->bc_btnum == XFS_BTNUM_RTRMAP)
+		xfs_warn(mp,
+ "RT Reverse Mapping BTree record corruption in rtgroup %u detected at %pS!",
+				cur->bc_ino.rtg->rtg_rgno, fa);
 	else
 		xfs_warn(mp,
  "Reverse Mapping BTree record corruption in AG %d detected at %pS!",
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 0ccfd7d88e5..762f2f40b6e 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -7,6 +7,7 @@
 #define __XFS_RMAP_H__
 
 struct xfs_perag;
+struct xfs_rtgroup;
 
 static inline void
 xfs_rmap_ino_bmbt_owner(
@@ -206,6 +207,8 @@ xfs_failaddr_t xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
 xfs_failaddr_t xfs_rmap_check_irec(struct xfs_perag *pag,
 		const struct xfs_rmap_irec *irec);
+xfs_failaddr_t xfs_rtrmap_check_irec(struct xfs_rtgroup *rtg,
+		const struct xfs_rmap_irec *irec);
 
 int xfs_rmap_has_records(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, enum xbtree_recpacking *outcome);

