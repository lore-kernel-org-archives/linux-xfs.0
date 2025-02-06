Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E035A1B7F4
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824333; cv=none; b=bVPsRtSh8zKiYuyYx2qpfO7AmAKWz99vXxvrWtHMpkgXEtP3VYRypDgJOqK7nPRiStKplxlsaIzqYJHE745i6NCyCt53ia+gYGR048vILBitVpC+7rKf0dF7pqjaEx0Pa8Hq7DJ5BzAKnYY0J09d680PjzTyqopFeKFPFuu1SPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824333; c=relaxed/simple;
	bh=q3G1n80Eg+KPcq8lnhedFmL4he3+ro0FOjOw0zcZLv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENL0/uvgqUR4sf5Fi2bZJFXluJzoUqyD+6FFwg2kDzTDlJ/DTYfBBoPzceau7BTQki7FFT3cqo71DiYF8XqUPXcpClmNmhWvcAY/kyYEvSstVMUQRZ1Mpp1mCO1FEw6VzBFDxU4wiYVuQh29taOe+qJi4KoteUfgmPZOSaGhFO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=onUzcXBa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="onUzcXBa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/TEKaFBt8t1vfu5bh+zQscjc5/h9QuIeX7alRk08naw=; b=onUzcXBa2aetPDFRlW3kr4P6v6
	5JB2Z/hJTsdnSpv9EZlZE99QTnEgtjrmzmS/Mc463A/KlXEbtj1P6ZVM9NLwoCh433pN/2HUjGKs3
	S6w9nCxeM35ffJFKyrrOWyrqxLpLf61M164mnty+n8OAjJfmmfohdxtG5ADMEvRn+MB34J2X3h4db
	mfSYwLo+SQK/wwR9cYaCUT5ne5+Yi0MKIV6FYZbq8dPLqE0YzVLfcxcGK6TwoBexDGwpx5tuOa7J8
	3UmPV7Uwl3JI6jXIAxdMmdn37QO1hPORbqT8ZKb2FnQMToUk6z6gyr1UfXW6ApQN02XUTcyhkHz+a
	YeD7/6pw==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvdi-00000005Q6u-0rSu;
	Thu, 06 Feb 2025 06:45:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/43] xfs: preserve RT reservations across remounts
Date: Thu,  6 Feb 2025 07:44:23 +0100
Message-ID: <20250206064511.2323878-8-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
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
 fs/xfs/xfs_mount.c | 30 ++++++++++++++++++++++--------
 fs/xfs/xfs_mount.h |  3 ++-
 fs/xfs/xfs_super.c |  2 +-
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b81a03b3133d..26793d4f2707 100644
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
index 300ffefb2abd..2d0e34e517b1 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -647,7 +647,8 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
 }
 
 extern void	xfs_uuid_table_free(void);
-extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
+uint64_t	xfs_default_resblks(struct xfs_mount *mp,
+			enum xfs_free_counter ctr);
 extern int	xfs_mountfs(xfs_mount_t *mp);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f0b0d8320c51..5c9a2a0826ff 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -947,7 +947,7 @@ xfs_restore_resvblks(
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

