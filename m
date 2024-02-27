Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD674C83
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709001188; cv=none; b=FjfuFMnzfouwYhiWsx60wZUiW9hhCZJ3Vm6/0NjNosfP6/UtZlCDxSvrYoHH7JIXc93ee7OqbosSce8RVQ2Cnaz4j7CKWTHpdepO32iEeXEkg0UQF/TP5500alB7mIvJY0GjPzqGd5z4kTPEfkKWBjAvbHbLrzNLiMlnBvgwrc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709001188; c=relaxed/simple;
	bh=JMH9p1NVJudSTCvnA0dAQXUHL6bzFenip24BxGPYIK8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gEC0ukeMzUTbgw2YAkR3ZA5d1w+AY7A8QEEhXeKJufrW+CNSFDGpBd4XQKjHvB0xpvrUv7i3T+jLT182mPKCg7lolgnq4gw4MUpTcgjDAjS4Z21tI4z9IdzP3gsgxOuNqtBJ3C9WSQcpK010jzlK/RXxY/K2dpkwNTiKWyDo5jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FbOm501V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FbOm501V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CACC433F1;
	Tue, 27 Feb 2024 02:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709001187;
	bh=JMH9p1NVJudSTCvnA0dAQXUHL6bzFenip24BxGPYIK8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FbOm501V/7ttiDUJ14aEIMx4CfR0BTzbVfDusYir2sfzJUOWOjRQqRBe0uNsm+pGV
	 S+WT2wNYLjo67XnnoJ9H4xYq21xjM9dLGEIPj8De8RTwIybSiiPOOJwIZV6+P42LvV
	 2ygajNdHYAD1O2B3oEij5vOUf8D0bCkYRMzEd9Pyy0l5di8M/uPr7ij8K3g+zqn3ZQ
	 0bkWI+jU5gVNYs4aop7URVNSI6Z+ugtKN45GtCok+DV6C/QOGIUtPxeHr/xrS9xBiJ
	 gz8sWJ/iH2cPEZEQxqsY+6qGfGeZdIAes7H/EeQIsuZxxObyuFiECukeKeqs5pc+jc
	 8FJ/QdPCwV1OA==
Date: Mon, 26 Feb 2024 18:33:06 -0800
Subject: [PATCH 1/3] xfs: check AGI unlinked inode buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900015649.939876.11902030314177288352.stgit@frogsfrogsfrogs>
In-Reply-To: <170900015625.939876.13962340231526041298.stgit@frogsfrogsfrogs>
References: <170900015625.939876.13962340231526041298.stgit@frogsfrogsfrogs>
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
index b04f5f0e63b4e..b2c287dca611b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1996,7 +1996,7 @@ xfs_inactive(
  * only unlinked, referenced inodes can be on the unlinked inode list.  If we
  * don't find the inode in cache, then let the caller handle the situation.
  */
-static struct xfs_inode *
+struct xfs_inode *
 xfs_iunlink_lookup(
 	struct xfs_perag	*pag,
 	xfs_agino_t		agino)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index cab52bcb64207..3c3e1e48124ac 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -615,6 +615,7 @@ bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
+struct xfs_inode *xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino);
 
 void xfs_end_io(struct work_struct *work);
 

