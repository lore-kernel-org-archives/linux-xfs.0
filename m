Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34257233723;
	Mon, 27 Jul 2026 05:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129890; cv=none; b=HVwEIDK7ZoSLVgK3Yd7iV3WG3hIoSIedQBxj0w+zsx/mS+2MXkFdgilgQ5OsC/b8YjWtGlx1mhdFGrpd+AQAiHNWYPOS5Ws5nmK13Pye0DWegC5Qw2J7wzkfeZlqW9zJWQLTxIpHcvdcQDBtPudYnQSZY88Pw5gML9DbI7MVWFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129890; c=relaxed/simple;
	bh=PBXhmkaGeuY/15Q37v+tYFIumIm4mCCJgV4ry7FA25Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b9YCASABpS26HASjTFxZavpdkBOBziXphBiaNau3limU442DGmyCGTEAbsXrdDzZfZsN9bX1lb/ybVnyh5WeoOSM9r8wc1LOxaFU2IJ6mU5f/xjPohB24DO093dWGpT8iyxEkJSls7Gaxr+ZkvYz9SiD++lKKxtyBV72yfXj7NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pz9dvk+k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pz9dvk+k"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0B3E01F000E9;
	Mon, 27 Jul 2026 05:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129889;
	bh=HTNaKI91hApaWBWykYoeU/helS8Y4J3dkYgDNf9dUCk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Pz9dvk+kTeybaTHH9IkcePkG0vBITScA/pND9WVEDHdkDdQPt00JHStmZtMMJ9y6T
	 ixtvqSCN16H2Fa+InUPq7w12qWDYNN/t9Ft8OhoFKCV96IFTk9VXYmyyLpmWScy/uh
	 eCwkYsHnRp9weMy++f+E6qgeGLpAe9SpMRUU4NLejURnIGRiv4toIZoHit9h1LfXCt
	 uIqHiTitvZfVXBITG55r9Vkegr2o+gkjvHu4LYxiEfKIGk1VAIWRQ3I7sRn7oXEx1a
	 vGXGzuWWugDO/SbF4VYqvawCEwlyIrexsvm0zAFNwW8oOEfWVb+AuVATnHp3ei4HHo
	 t2UN5NgYLeeeQ==
Date: Sun, 26 Jul 2026 22:24:48 -0700
Subject: [PATCH 02/10] xfs: don't livelock in scrub on a circular unlinked
 list
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389639.1495075.12346183182378310490.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
References: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that online fsck can livelock if an unlinked inode list
contains a loop.  Use a bitmap to detect cycles.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: a12890aebb8959 ("xfs: scrub the AGI")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader.c        |   44 +++++++++++++++++++++++++++++++++-------
 fs/xfs/scrub/agheader_repair.c |   17 ++++++++++++++-
 2 files changed, 51 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index cecf034ef989c7..1fa66aa68e169f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -18,6 +18,8 @@
 #include "xfs_inode.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/bitmap.h"
+#include "scrub/agino_bitmap.h"
 
 int
 xchk_setup_agheader(
@@ -935,7 +937,8 @@ xchk_agi_xref(
 /*
  * Walk the incore unlinked list for a particular AGI bucket to construct
  * the unlinked inode bitmap for later reconstruction of the unlinked list.
- * Returns 1 if we should keep checking, or 0 to stop checking.
+ * Returns 1 if we should keep checking, 0 to stop checking, or a negative
+ * errno.
  */
 static int
 xchk_iunlink_bucket(
@@ -943,36 +946,57 @@ xchk_iunlink_bucket(
 	unsigned int			bucket,
 	xfs_agino_t			agino)
 {
+	struct xagino_bitmap		seen;
+	int				ret;
+
+	xagino_bitmap_init(&seen);
+
 	while (agino != NULLAGINO) {
 		struct xfs_inode	*ip;
+		unsigned int		len = 1;
 
 		if (agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
 			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-			return 0;
+			goto bad;
+		}
+
+		if (xagino_bitmap_test(&seen, agino, &len)) {
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+			goto bad;
 		}
 
 		ip = xfs_iunlink_lookup(sc->sa.pag, agino);
 		if (!ip) {
 			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-			return 0;
+			goto bad;
 		}
 
 		if (!xfs_inode_on_unlinked_list(ip)) {
 			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-			return 0;
+			goto bad;
 		}
 
+		ret = xagino_bitmap_set(&seen, agino, 1);
+		if (ret)
+			goto out_bitmap;
+
 		agino = ip->i_next_unlinked;
 	}
+	ret = 1;
 
-	return 1;
+out_bitmap:
+	xagino_bitmap_destroy(&seen);
+	return ret;
+bad:
+	ret = 0;
+	goto out_bitmap;
 }
 
 /*
  * Check the unlinked buckets for links to bad inodes.  We hold the AGI, so
  * there cannot be any threads updating unlinked list pointers in this AG.
  */
-STATIC void
+STATIC int
 xchk_iunlink(
 	struct xfs_scrub	*sc,
 	struct xfs_agi		*agi)
@@ -985,8 +1009,10 @@ xchk_iunlink(
 		ret = xchk_iunlink_bucket(sc, i,
 				be32_to_cpu(agi->agi_unlinked[i]));
 		if (ret < 1)
-			return;
+			return ret;
 	}
+
+	return 0;
 }
 
 /* Scrub the AGI. */
@@ -1073,7 +1099,9 @@ xchk_agi(
 	if (pag->pagi_freecount != be32_to_cpu(agi->agi_freecount))
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
-	xchk_iunlink(sc, agi);
+	error = xchk_iunlink(sc, agi);
+	if (error)
+		goto out;
 
 	xchk_agi_xref(sc);
 out:
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 2554494847ff1b..13074d5e319cc0 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1080,18 +1080,22 @@ xrep_iunlink_walk_ondisk_bucket(
 	struct xrep_agi		*ragi,
 	unsigned int		bucket)
 {
+	struct xagino_bitmap	seen;
 	struct xfs_scrub	*sc = ragi->sc;
 	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
 	xfs_agino_t		prev_agino = NULLAGINO;
 	xfs_agino_t		next_agino;
 	int			error = 0;
 
+	xagino_bitmap_init(&seen);
+
 	next_agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 	while (next_agino != NULLAGINO) {
 		xfs_agino_t	agino = next_agino;
+		unsigned int	len = 1;
 
 		if (xchk_should_terminate(ragi->sc, &error))
-			return error;
+			goto out_bitmap;
 
 		trace_xrep_iunlink_walk_ondisk_bucket(sc->sa.pag, bucket,
 				prev_agino, agino);
@@ -1099,15 +1103,24 @@ xrep_iunlink_walk_ondisk_bucket(
 		if (bucket != agino % XFS_AGI_UNLINKED_BUCKETS)
 			break;
 
+		if (xagino_bitmap_test(&seen, agino, &len))
+			break;
+
 		next_agino = xrep_iunlink_next(sc, agino);
 		if (!next_agino)
 			next_agino = xrep_iunlink_reload_next(ragi, prev_agino,
 					agino);
 
+		error = xagino_bitmap_set(&seen, agino, 1);
+		if (error)
+			goto out_bitmap;
+
 		prev_agino = agino;
 	}
 
-	return 0;
+out_bitmap:
+	xagino_bitmap_destroy(&seen);
+	return error;
 }
 
 /* Decide if this is an unlinked inode in this AG. */

