Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7ED3168EE;
	Thu, 16 Jul 2026 06:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182062; cv=none; b=PLMcbpkfMN4Igl21O1Cq2OmmOir+Npt6QLJZ/QiX4rSY+mV1II6eg+SS8uaD0/QdvRCizzYoAYCkS5aI76YeadeWQiSUZWmzdTba0i8Sx7pV/HDUCJx5vusFw6Rb7STqZaGoOYQIfrqSUCW4ydOy9dQyfWa0htrnywzTmhKa8+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182062; c=relaxed/simple;
	bh=MCYVnPkGObw8i8yiEsekkYsKrBCrnrS9isahMEyUW4o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d5ab94Wr4nlMexpBORECL+rgVoEBD/4bzcfaut+UwUeIquoIDN1LbFbX+VMa7c/LsnVOFzZOoI/UY6IGRtpW+BOTgqaFjnwI+XVjZ2gQ1ucmpL7us9OYHvUFnzrhAiU2lIrAWrS85plJKkRGAxWl9DF0ybNg7KSvobJirlWIztI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9RJxDsL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9RJxDsL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C36411F000E9;
	Thu, 16 Jul 2026 06:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784182060;
	bh=2arsPeaiQbJYSk/npQsAmrIcWH8OsW5CIGwFO/y0h6M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Q9RJxDsLGUyK8KU1Kq9HQ6dxTtAmvey3lxLjJZ3cByZkWN9xOf6UZa8N0eRjT47i1
	 0PRkhHR7ISG+/S8HzLebC+DPmiX2v4dbLKuXN1/0busWCNLuLmdHfUES7J2IkDvx8s
	 atLEJX0AYpKHNlnV1+eQ+BuYPZc3DBfowU6O52Eg2fKQ174WkI515F5qqTJglMO6XV
	 /3mntiTwydN6uyAZ5/VG6zSk3QKwXsMNhifCMxpoxE1Sr3Pm6LjfIpUKgPkQ+jw71C
	 VM9DxbQdzi/XrGztHRo3oChRlxezw2JHdE+7LpLsYaEeq4TSk1pE8aiUxJTC9a1/5w
	 pcj1QREqppwlA==
Date: Wed, 15 Jul 2026 23:07:40 -0700
Subject: [PATCH 6/6] xfs: don't livelock in scrub on a circular unlinked list
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178416797487.2008054.2580454314921003800.stgit@frogsfrogsfrogs>
In-Reply-To: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/agheader.c        |   88 ++++++++++++++++++++++++++++++----------
 fs/xfs/scrub/agheader_repair.c |   17 +++++++-
 2 files changed, 80 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 62ed5eaf08fbc1..0ecf969f95a9d2 100644
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
@@ -932,41 +934,79 @@ xchk_agi_xref(
 	/* scrub teardown will take care of sc->sa for us */
 }
 
+static int
+xchk_iunlink_bucket(
+	struct xfs_scrub	*sc,
+	unsigned int		bucket,
+	xfs_agino_t		agino)
+{
+	struct xagino_bitmap	seen;
+	struct xfs_inode	*ip;
+	int			ret = 0;
+
+	xagino_bitmap_init(&seen);
+
+	while (agino != NULLAGINO) {
+		unsigned int	len = 1;
+
+		if (agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+			goto bad;
+		}
+
+		if (xagino_bitmap_test(&seen, agino, &len)) {
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+			goto bad;
+		}
+
+		ip = xfs_iunlink_lookup(sc->sa.pag, agino);
+		if (!ip) {
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+			goto bad;
+		}
+
+		if (!xfs_inode_on_unlinked_list(ip)) {
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+			goto bad;
+		}
+
+		ret = xagino_bitmap_set(&seen, agino, 1);
+		if (ret)
+			goto out_bitmap;
+
+		agino = ip->i_next_unlinked;
+	}
+	ret = 1;
+
+out_bitmap:
+	xagino_bitmap_destroy(&seen);
+	return ret;
+bad:
+	ret = 0;
+	goto out_bitmap;
+}
+
 /*
  * Check the unlinked buckets for links to bad inodes.  We hold the AGI, so
  * there cannot be any threads updating unlinked list pointers in this AG.
  */
-STATIC void
+STATIC int
 xchk_iunlink(
 	struct xfs_scrub	*sc,
 	struct xfs_agi		*agi)
 {
 	unsigned int		i;
-	struct xfs_inode	*ip;
 
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
-		xfs_agino_t	agino = be32_to_cpu(agi->agi_unlinked[i]);
+		int		ret;
 
-		while (agino != NULLAGINO) {
-			if (agino % XFS_AGI_UNLINKED_BUCKETS != i) {
-				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-				return;
-			}
-
-			ip = xfs_iunlink_lookup(sc->sa.pag, agino);
-			if (!ip) {
-				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-				return;
-			}
-
-			if (!xfs_inode_on_unlinked_list(ip)) {
-				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-				return;
-			}
-
-			agino = ip->i_next_unlinked;
-		}
+		ret = xchk_iunlink_bucket(sc, i,
+					be32_to_cpu(agi->agi_unlinked[i]));
+		if (ret < 1)
+			return ret;
 	}
+
+	return 0;
 }
 
 /* Scrub the AGI. */
@@ -1053,7 +1093,9 @@ xchk_agi(
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

