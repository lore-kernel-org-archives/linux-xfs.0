Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BEF2376EB
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596254; cv=none; b=UFJ+0Bh/S+gQOQfX9RkHfWgu4lT+bP5zQ1MbCUlib0sJN7xJXdXN5jzrN17pIWZqm7mHSV6j5n/oy4JHPIxe9HKo0Ccx7C3g0C/HpV5WlhLdk9ys1Q/6ebVV8+VBDc0ZZX7gwVBAnJndaGpSqrO8Z1glwFVX9jrpHfxE1cB/vig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596254; c=relaxed/simple;
	bh=wsGEYcARNmFH1gr3eKJ7DqoywzNdr+gb9WM8VwmAX3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1zXtqJOcNnCGLA34xV6i6ld++IK27lRoIJjCAV67cvnwWoMLs7zcv2iafKJBsEu8L4A/ch8sFbV3+NFCDYn7pmYR1MF0M/U6aDpuge9RfOCbHbQBueEfTvuxkzrm4maMY34Sfldo5XJ5wautBkipJA1cNwwAHBgkB+R7YC+Jgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uTuobiqm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uTuobiqm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Dnl3SlxNETk3bOn2qINl1QWQR5EdLGvESQCRNDuUlcE=; b=uTuobiqmvyZn4EnSSTqopZFBoS
	Wr20svn/cm6SfVJ5jSEj8CqX3+FEGAVTWujogeS44870lWslOs2qcBtB3/zJgxrJybEcdEExtkzwU
	DXTvMgisjagX07ugKEnXqhewBpmhoXTr9dWEpxT6jhy4hBSJ0qpYR8SCleAGS3HuwC+WPxsGKm9JN
	SCPd3MCgukH6/TmXYop1JUPt0dUbulsFzc7vT1PQaPlRq+v/oyN2yyPLdj1uELMo9KuuFGVSQ5fPS
	SrzbpQAIEhUB4oRzr1ZdbHArZp0h85v2YZfZlL7lS74thfS6sRFZcOQZ2fxFned1MesCV1iic6fKA
	XnPgdtvA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb6-000000053ve-3Scs;
	Wed, 26 Feb 2025 18:57:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 28/44] xfs: wire up zoned block freeing in xfs_rtextent_free_finish_item
Date: Wed, 26 Feb 2025 10:57:00 -0800
Message-ID: <20250226185723.518867-29-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Make xfs_rtextent_free_finish_item call into the zoned allocator to free
blocks on zoned RT devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a25c713ff888..777438b853da 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -29,6 +29,7 @@
 #include "xfs_inode.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_zone_alloc.h"
 
 struct kmem_cache	*xfs_efi_cache;
 struct kmem_cache	*xfs_efd_cache;
@@ -767,21 +768,35 @@ xfs_rtextent_free_finish_item(
 
 	trace_xfs_extent_free_deferred(mp, xefi);
 
-	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED)) {
-		if (*rtgp != to_rtg(xefi->xefi_group)) {
-			*rtgp = to_rtg(xefi->xefi_group);
-			xfs_rtgroup_lock(*rtgp, XFS_RTGLOCK_BITMAP);
-			xfs_rtgroup_trans_join(tp, *rtgp,
-					XFS_RTGLOCK_BITMAP);
-		}
-		error = xfs_rtfree_blocks(tp, *rtgp,
-				xefi->xefi_startblock, xefi->xefi_blockcount);
+	if (xefi->xefi_flags & XFS_EFI_CANCELLED)
+		goto done;
+
+	if (*rtgp != to_rtg(xefi->xefi_group)) {
+		unsigned int		lock_flags;
+
+		if (xfs_has_zoned(mp))
+			lock_flags = XFS_RTGLOCK_RMAP;
+		else
+			lock_flags = XFS_RTGLOCK_BITMAP;
+
+		*rtgp = to_rtg(xefi->xefi_group);
+		xfs_rtgroup_lock(*rtgp, lock_flags);
+		xfs_rtgroup_trans_join(tp, *rtgp, lock_flags);
 	}
+
+	if (xfs_has_zoned(mp)) {
+		error = xfs_zone_free_blocks(tp, *rtgp, xefi->xefi_startblock,
+				xefi->xefi_blockcount);
+	} else {
+		error = xfs_rtfree_blocks(tp, *rtgp, xefi->xefi_startblock,
+				xefi->xefi_blockcount);
+	}
+
 	if (error == -EAGAIN) {
 		xfs_efd_from_efi(efdp);
 		return error;
 	}
-
+done:
 	xfs_efd_add_extent(efdp, xefi);
 	xfs_extent_free_cancel_item(item);
 	return error;
-- 
2.45.2

