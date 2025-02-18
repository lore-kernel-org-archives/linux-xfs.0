Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC6522AE7F
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866332; cv=none; b=lYl9sGUC9zKzE0Lmc6cJolKzfdQZhlaFUer9XeyGejOZxfkrIOrqWkmkxYEpU88NSiqt8IJy5Gke0yA032KaZzq/YsmmkKH2NKg77tCPsZtYDynfb7Ne76N+wJusc2X+tKkioB8Yrw/C15+a4ghsL6vnfbuYRlAD0aSWbbsP3rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866332; c=relaxed/simple;
	bh=OywrHKD202JhuozPWSVB18EUnPltXCSqYpdSXIRS25Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2fLIGmUY6G5dP8uyY2/AK4/7T9lodZSMNHyMDSo4C2dRXZP6OkdoeJD5WLnSQoM9Rfj8AGyHmOmfy0k66kjMvAnhKMjTZaQRcJh7Qdk+/+m12cY5RxGwEyLm/r04WqSyxsrWo9Um+wcaD1Z8Ppo2fh0yu4uvgIkDFfrr0tYB0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u9G+tFo6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u9G+tFo6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7IdZk82QInq9ZNvhsqRdZxU4d5+cFjUoKwB2FwuTtx8=; b=u9G+tFo6CmDil+sTlerDQAxvsn
	GXYcY/itWQ1AeMaWsR+T6E1uK1gM95NhhyuN0rxK2JI1Kw9TPib8FcD8fLAzWb3sK4DFnUxEZEmdD
	xsnqOp40qePTHI9kbZOy+srIb1gbfLtNjiiXfEgStkMaIwNMTi6Zwhhr4TNyHcBPocQaYAVWqDRHU
	+l/uq+jkbbK4ME9xkf1oAMqdTd0fYDAdazlI4gDWPEfYeWIJRwxGZNziiMPM1Mp4wwX1mjkQwDjpL
	S1/bZCGHE/UbeWUplaUZx9tEcszRYSg0H7A/nQVFRfpphBUpJyIt9ZEG2KNOybeBOQ5+2i4OTbWbs
	K2mhtv+w==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIiA-00000007CJ1-2ZC1;
	Tue, 18 Feb 2025 08:12:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/45] xfs: preserve RT reservations across remounts
Date: Tue, 18 Feb 2025 09:10:08 +0100
Message-ID: <20250218081153.3889537-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Hans Holmberg <hans.holmberg@wdc.com>

Introduce a reservation setting for rt devices so that zoned GC
reservations are preserved over remount ro/rw cycles.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c | 30 ++++++++++++++++++++++--------
 fs/xfs/xfs_mount.h |  3 ++-
 fs/xfs/xfs_super.c |  2 +-
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0270c77796e5..6b80fd55c787 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -464,11 +464,21 @@ xfs_mount_reset_sbqflags(
 	return xfs_sync_sb(mp, false);
 }
 
+static const char *const xfs_free_pool_name[] = {
+	[XC_FREE_BLOCKS]	= "free blocks",
+	[XC_FREE_RTEXTENTS]	= "free rt extents",
+};
+
 uint64_t
-xfs_default_resblks(xfs_mount_t *mp)
+xfs_default_resblks(
+	struct xfs_mount	*mp,
+	enum xfs_free_counter	ctr)
 {
 	uint64_t resblks;
 
+	if (ctr == XC_FREE_RTEXTENTS)
+		return 0;
+
 	/*
 	 * We default to 5% or 8192 fsbs of space reserved, whichever is
 	 * smaller.  This is intended to cover concurrent allocation
@@ -681,6 +691,7 @@ xfs_mountfs(
 	uint			quotamount = 0;
 	uint			quotaflags = 0;
 	int			error = 0;
+	int			i;
 
 	xfs_sb_mount_common(mp, sbp);
 
@@ -1049,18 +1060,21 @@ xfs_mountfs(
 	 * privileged transactions. This is needed so that transaction
 	 * space required for critical operations can dip into this pool
 	 * when at ENOSPC. This is needed for operations like create with
-	 * attr, unwritten extent conversion at ENOSPC, etc. Data allocations
-	 * are not allowed to use this reserved space.
+	 * attr, unwritten extent conversion at ENOSPC, garbage collection
+	 * etc. Data allocations are not allowed to use this reserved space.
 	 *
 	 * This may drive us straight to ENOSPC on mount, but that implies
 	 * we were already there on the last unmount. Warn if this occurs.
 	 */
 	if (!xfs_is_readonly(mp)) {
-		error = xfs_reserve_blocks(mp, XC_FREE_BLOCKS,
-				xfs_default_resblks(mp));
-		if (error)
-			xfs_warn(mp,
-	"Unable to allocate reserve blocks. Continuing without reserve pool.");
+		for (i = 0; i < XC_FREE_NR; i++) {
+			error = xfs_reserve_blocks(mp, i,
+					xfs_default_resblks(mp, i));
+			if (error)
+				xfs_warn(mp,
+"Unable to allocate reserve blocks. Continuing without reserve pool for %s.",
+					xfs_free_pool_name[i]);
+		}
 
 		/* Reserve AG blocks for future btree expansion. */
 		error = xfs_fs_reserve_ag_blocks(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f63410acc8fd..579eaf09157d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -644,7 +644,8 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 }
 
 extern void	xfs_uuid_table_free(void);
-extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
+uint64_t	xfs_default_resblks(struct xfs_mount *mp,
+			enum xfs_free_counter ctr);
 extern int	xfs_mountfs(xfs_mount_t *mp);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1e61283efdfe..366837e71eeb 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -947,7 +947,7 @@ xfs_restore_resvblks(
 			resblks = mp->m_free[i].res_saved;
 			mp->m_free[i].res_saved = 0;
 		} else
-			resblks = xfs_default_resblks(mp);
+			resblks = xfs_default_resblks(mp, i);
 		xfs_reserve_blocks(mp, i, resblks);
 	}
 }
-- 
2.45.2

