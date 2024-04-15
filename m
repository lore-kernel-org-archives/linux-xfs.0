Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A047B1591F9
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225277; cv=none; b=aFPhMaOsfFo6MgglTSei7J/167e5j8WpvYYZDAfkAASRCKnlBGC5gkELNvEa6vkvsIb4MNacAAIOqkR2xVRXj7EfPahFZHGcc6np7r+Sann0i0jnVynoWuH5DD9M0sMnzcxbhRN1hfSMsCQkUFf+fkmFzwvq11TLdeO1/+13LUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225277; c=relaxed/simple;
	bh=P4wg5A6myyHFJe5UrgtQb9cPunREa+89rBSUYRiftD8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RFrJIHByz2jHaRzDzPtwh+6DF+xx+bzQ1E/cuVSA1kjOPZ+QzK/5i98F/rjzd9v0Xq5mAyQ+66p8byXY/tFoMXbmle9DG3LZsda3G6LAYEDKKn5nVQDE5fxbgfTaVjk8cAH851DkV78o7ImH71RHrjDRa2uQyjJb4XDjZwMLzZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oG1roagx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oG1roagx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B9CC113CC;
	Mon, 15 Apr 2024 23:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225277;
	bh=P4wg5A6myyHFJe5UrgtQb9cPunREa+89rBSUYRiftD8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oG1roagxaKaJmruVNJGbJTZPYdxbA7uc5Zu9YsQRPD4VqdjiHR4N3A7vyJGwJfD86
	 HQ72xGcT+5ya3xlMpsxf7Nu2NmL/TuJlcfdHn2lgaS5tYZfN6Q1eXsmJ1KAEg17YFF
	 SxaEFV79sX7DwQBxV30/jbbceamfOcKEYrbxTgK2X2JyWyJ23r0yJVGzdVt99S8apS
	 exEOpmJzG11QPwIaRxwYoOj7ymaXtViNKOKl8tl15qm/++Spa9uESHr7SrZ003PCvJ
	 Vauxhm3Km51F0JZ/FO8t2Ku0NFtgDT6cbC3NGqS/5wL8yQIHyilXnfvfZ+JMGzwkvq
	 OIR+km6BXh0Mg==
Date: Mon, 15 Apr 2024 16:54:36 -0700
Subject: [PATCH 1/3] xfs: check AGI unlinked inode buckets
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322385037.91285.10853660290517439889.stgit@frogsfrogsfrogs>
In-Reply-To: <171322385012.91285.3470147913307339944.stgit@frogsfrogsfrogs>
References: <171322385012.91285.3470147913307339944.stgit@frogsfrogsfrogs>
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
index e954f07679dd..1528f14bd925 100644
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
index 803a64687014..fed0cd6bffdf 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1985,7 +1985,7 @@ xfs_inactive(
  * only unlinked, referenced inodes can be on the unlinked inode list.  If we
  * don't find the inode in cache, then let the caller handle the situation.
  */
-static struct xfs_inode *
+struct xfs_inode *
 xfs_iunlink_lookup(
 	struct xfs_perag	*pag,
 	xfs_agino_t		agino)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 18bc3d7750a0..c74c48bc0945 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -619,6 +619,7 @@ bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
+struct xfs_inode *xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino);
 
 void xfs_end_io(struct work_struct *work);
 

