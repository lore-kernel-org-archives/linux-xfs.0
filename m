Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A51F2368
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907426; cv=none; b=bZqLxShu9VwsYvs6FNpcwXClm0KQVfaD2AKfxR9wB9VJin0TBJIhUdsjplSB+k7RHxq5SfWSgRgImq+954HiZyvVvcPcpuLqoeIy6wt2LEZJru6pXQyeBDYNtau4R5QO64QORLrRfO3L7gWPBf3FsDDmlKBbbcDCpfUN6WpQVxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907426; c=relaxed/simple;
	bh=Y+269esNLkiBIDOq1JuLswxHSHXGSd9VE05gSHYjLsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/2rO76LZ2sqy0+2nTqU5zzRLuJxqZnnmG36uW2VDlA2KVhuSd0l0LuWNuA9gAgAuN7Dy2gq8+b+w6wfG4eFV1TRXXEUu/6AC26ct/fU7JDeEAqp6f9kKcHi3lHogyUPKpvGhWa/anH3Me4hy1aj7LHVLLOatLDEceb613PCFu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TVpeOug9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TVpeOug9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9XiGDwg6p9VB5KKw2vuXj+zusbp8emzj71i5gPdbWHs=; b=TVpeOug9p0wWVePRADXDnDN62j
	Gjk8icAWoPTF139m0Nm6jeh8htAEDKyQgkG74neeZOkaB5GN0Z9IAJGiURZ5D2awH0d1CrSIwKycS
	a0jFnnBLhbq+Vpt7trHMyftfeOMH+7wmiutM11y9J0Cn7sveLmGlH0bsO+3EZIlZ/xAOBTZe+d+nq
	DfD94ZRWRflWFJpBLhzuykueRhjSAAPcG96POqEBUQIhKQgV0DZvILtga55MS1JtBIde6r0Kp6qZy
	90cVHLv7qh6yBKmJ5BzS8VL/UQvnVvbGO8vk1PkEGZLO0N+bTqHbqapRfCnpLY9/MpXu4Cg7cHejH
	lWQUX3RQ==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWm-0000000EJ5u-3U17;
	Wed, 11 Dec 2024 08:57:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/43] xfs: preserve RT reservations across remounts
Date: Wed, 11 Dec 2024 09:54:35 +0100
Message-ID: <20241211085636.1380516-11-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
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
---
 fs/xfs/xfs_mount.c | 22 +++++++++++++++-------
 fs/xfs/xfs_mount.h |  3 ++-
 fs/xfs/xfs_super.c |  2 +-
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4174035b2ac9..db910ecc1ed4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -465,10 +465,15 @@ xfs_mount_reset_sbqflags(
 }
 
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
@@ -683,6 +688,7 @@ xfs_mountfs(
 	uint			quotamount = 0;
 	uint			quotaflags = 0;
 	int			error = 0;
+	int			i;
 
 	xfs_sb_mount_common(mp, sbp);
 
@@ -1051,18 +1057,20 @@ xfs_mountfs(
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
+		for (i = 0; i < XC_FREE_NR; i++) {
+			error = xfs_reserve_blocks(mp, i,
+					xfs_default_resblks(mp, i));
+			if (error)
+				xfs_warn(mp,
 	"Unable to allocate reserve blocks. Continuing without reserve pool.");
+		}
 
 		/* Reserve AG blocks for future btree expansion. */
 		error = xfs_fs_reserve_ag_blocks(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d92bce7bc184..73bc053fdd17 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -640,7 +640,8 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 }
 
 extern void	xfs_uuid_table_free(void);
-extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
+uint64_t	xfs_default_resblks(struct xfs_mount *mp,
+			enum xfs_free_counter ctr);
 extern int	xfs_mountfs(xfs_mount_t *mp);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1960ee0aad45..f57c27940467 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -944,7 +944,7 @@ xfs_restore_resvblks(
 			resblks = mp->m_resblks[i].save;
 			mp->m_resblks[i].save = 0;
 		} else
-			resblks = xfs_default_resblks(mp);
+			resblks = xfs_default_resblks(mp, i);
 		xfs_reserve_blocks(mp, i, resblks);
 	}
 }
-- 
2.45.2

