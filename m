Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90E1BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="liOcrfPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F60C433C8;
	Sun, 31 Dec 2023 20:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055162;
	bh=GIfmiSI8kb2WwCnM1Zycv9JdX3IK4ktQWH/A4U1cgQ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=liOcrfPh7us/aRaPLIb/joxeETZcXHLswwtsQwWxUtsCecFYmm3KIifKJP8duZqJR
	 E38NSrabV2htNY7cYBko5rXLyCWgyPVJECC8DYF1jzNbAMcB1C8lpPE+TE6lW94cj7
	 Oy3t7IE7wAisRy+m7TQwkS3PXFDeD0natlSuB4fwJxDefz/AHqfueWJ0nawLI2bIVm
	 hytser5CPdfrEcsA9MmVoPFnJ2/+tc/U8YzAxzrieDV63dixhRA2fy7VrbGUqe+NiL
	 bLkjuPNhYzeOrWiEh5xK2LVOu7mY1hrfuaqklFIyvfQbqGqZkipBM0eV0U0Rw5rErW
	 AOpB9STTUIpoQ==
Date: Sun, 31 Dec 2023 12:39:22 -0800
Subject: [PATCH 1/3] xfs: check AGI unlinked inode buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404837213.1753977.15572072064312695671.stgit@frogsfrogsfrogs>
In-Reply-To: <170404837191.1753977.11382534548825167511.stgit@frogsfrogsfrogs>
References: <170404837191.1753977.11382534548825167511.stgit@frogsfrogsfrogs>
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

Look for corruptions in the AGI unlinked bucket chains.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c      |    2 +-
 fs/xfs/xfs_inode.h      |    1 +
 3 files changed, 42 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 6c6e5eba42c8b..7fd89889d1d81 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -15,6 +15,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_inode.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 
@@ -865,6 +866,43 @@ xchk_agi_xref(
 	/* scrub teardown will take care of sc->sa for us */
 }
 
+/*
+ * Check the unlinked buckets for links to bad inodes.  We hold the AGI, so
+ * there cannot be any threads updating unlinked list pointers in this AG.
+ */
+STATIC void
+xchk_iunlink(
+	struct xfs_scrub	*sc,
+	struct xfs_agi		*agi)
+{
+	unsigned int		i;
+	struct xfs_inode	*ip;
+
+	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
+		xfs_agino_t	agino = be32_to_cpu(agi->agi_unlinked[i]);
+
+		while (agino != NULLAGINO) {
+			if (agino % XFS_AGI_UNLINKED_BUCKETS != i) {
+				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+				return;
+			}
+
+			ip = xfs_iunlink_lookup(sc->sa.pag, agino);
+			if (!ip) {
+				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+				return;
+			}
+
+			if (!xfs_inode_on_unlinked_list(ip)) {
+				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+				return;
+			}
+
+			agino = ip->i_next_unlinked;
+		}
+	}
+}
+
 /* Scrub the AGI. */
 int
 xchk_agi(
@@ -949,6 +987,8 @@ xchk_agi(
 	if (pag->pagi_freecount != be32_to_cpu(agi->agi_freecount))
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
+	xchk_iunlink(sc, agi);
+
 	xchk_agi_xref(sc);
 out:
 	return error;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9618c014615f5..ea1b0bc9a3410 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1987,7 +1987,7 @@ xfs_inactive(
  * only unlinked, referenced inodes can be on the unlinked inode list.  If we
  * don't find the inode in cache, then let the caller handle the situation.
  */
-static struct xfs_inode *
+struct xfs_inode *
 xfs_iunlink_lookup(
 	struct xfs_perag	*pag,
 	xfs_agino_t		agino)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9cee94a0de2c8..8f0dccb0361d7 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -615,6 +615,7 @@ bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
+struct xfs_inode *xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino);
 
 void xfs_end_io(struct work_struct *work);
 

