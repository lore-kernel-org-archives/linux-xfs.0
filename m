Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A907FBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQAFYann"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746E1C433C8;
	Sun, 31 Dec 2023 21:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058417;
	bh=VxG14s1tOg/6X9l//bjZzEnDcPUH8e5lGRuk8CEEDEg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DQAFYannQnomOJqBAkS/9NDkLhwNSfltgNP5WVRBUWD2vgENrudhuSSyOtxxAAKnw
	 rsYrvYIEgPGEURcqvzaTna3gMi4/SgDUCduAv4vsoBK+OeTuOrIhxzBtXphPiileYX
	 ilWc224anjR/6m5UbCwL0JKbBXnQ5VN6uwsWIS/YrRBU8J9riA0VwUSgUMXjFQ7hCT
	 4NFjTod5DY0T2K5tRbW3NzoYaOL1Og0Oez/wy2UbwhXWxtQs6PSg1ng4lBE8YXUR35
	 zwFcfSr5YKYCELZVCwQmZOs/p9cH0n5irfbKpkkZDPo7+Lu+eJStlVhOXFgzEQUk1e
	 Cvui5aB5j249g==
Date: Sun, 31 Dec 2023 13:33:37 -0800
Subject: [PATCH 07/39] xfs: prepare rmap functions to deal with rtrmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850014.1764998.4302501890890069104.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rmap.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h |    3 ++
 2 files changed, 69 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index b3383cc474492..35df4e832996e 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -25,6 +25,7 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "xfs_rmap_item.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -264,11 +265,72 @@ xfs_rmap_check_irec(
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
@@ -285,6 +347,10 @@ xfs_rmap_complain_bad_rec(
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
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 0ccfd7d88e56e..762f2f40b6e47 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
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

