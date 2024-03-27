Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6824219FC
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505169; cv=none; b=gh1d7q8qMLyWZT6dLwE6cNoQU/WgLnbGqf45QmkKZS2WRJJJsNboY5dW/IxDg3jhndGMSoMc2xpkOXeWia6JSj7J6jv54rBzQN/b7pY2XZl3Kjftlsj5ubcLVGHGnX8V8hQAwe8zwDopwLmzCnJ1EFnPF/RyDxptSSNSru33Qtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505169; c=relaxed/simple;
	bh=wXXuauZ4XUKuje6L27mxVRXnbTcRILB2p0nOMiNl6pU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jQMJMbbvOCk7dFiplZ+E6USfKKQLcgJ4wN/K8PZCEV7S6sES9nrtGO77jgg98ouIWltoIYHH2Ny9g3bj4NSTClJzAx1jKKeB6/zXQcE1OJPO1FnqKQumkyEAJ17Awuy5X+OketjWGDBj3Fx88JW5jPLf0LnPmBbivMJuupsskR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFSUplzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFSUplzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A61CC433F1;
	Wed, 27 Mar 2024 02:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505169;
	bh=wXXuauZ4XUKuje6L27mxVRXnbTcRILB2p0nOMiNl6pU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UFSUplzV04iYaLIq3/KBUyo+KGGT8GCx/ZEhhSXE8t+IFFCOhJhrL5VqH2EhXRaXl
	 1Ih6Q70vZcfpcAHGAYCEuHlQuO65L+LxeqpNVRd3yI/348Fp0GfE7/k6MtgwOobUyX
	 hleHrVZSBMLKMAen4mD+fad3FpJwFCE42Vor9j0yvOg+GVDUphLQFoHTTGbbAVUqFf
	 NhvVmp/hZvZjXWUWAXebFrvuDdSv5Prid7RUSbNIxiLFTYAbX9fTwYNAFTABWXsLeS
	 nrsHAKStg9NspkxJaRiPCYsIXxklXRUIDGcK82CBqLIRs+xI1WrufP0irSPfbGJgtY
	 08ycIFI9CQRAg==
Date: Tue, 26 Mar 2024 19:06:08 -0700
Subject: [PATCH 1/3] xfs: check AGI unlinked inode buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150384729.3220168.6108956906084675411.stgit@frogsfrogsfrogs>
In-Reply-To: <171150384705.3220168.3647633643279321481.stgit@frogsfrogsfrogs>
References: <171150384705.3220168.3647633643279321481.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader.c |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c      |    2 +-
 fs/xfs/xfs_inode.h      |    1 +
 3 files changed, 42 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index e954f07679dd7..1528f14bd9251 100644
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
index c0bdcf0f2448e..666bd03cf05c3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1974,7 +1974,7 @@ xfs_inactive(
  * only unlinked, referenced inodes can be on the unlinked inode list.  If we
  * don't find the inode in cache, then let the caller handle the situation.
  */
-static struct xfs_inode *
+struct xfs_inode *
 xfs_iunlink_lookup(
 	struct xfs_perag	*pag,
 	xfs_agino_t		agino)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 66271daff5b3f..8754e1969350d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -619,6 +619,7 @@ bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
+struct xfs_inode *xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino);
 
 void xfs_end_io(struct work_struct *work);
 

