Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC15819DFA7
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609051; cv=none; b=EDfERy/Q6P5hL/upPAExk8j+Od2ax1+HAqZSopRRqe1dJOlAV4Fv6KkPzZEyuyQOFyZSWNEfrFaxcf75as8nD+jVg5H+KssLuivPKmzgRbhK+CN6lLv5eaxm8y9+2lFbUGhgsMO6IyBcBaYaVckCkJPvT22INvjh1yTSwU2CTE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609051; c=relaxed/simple;
	bh=Hvx2HBgmmN3L9feZjcjNYq2jyXwVgiswNmyJxH/HfQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYZMFKCUZtY/P3Z6+BKh2zJK79a9vBRUEp2FVpIbR/0Cg1dPZFM0AuB91cA2iUipIM8q3x5Wv58PxuYg1jd2Z/5AfLZWbMwX2He5ZWkQtsukSd8tX6jIhllDPoXQZV5ARBZxtWpU8++5gYTxms4t8xuLMbEHPEafdQk3P+53xwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jy6I/ppM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jy6I/ppM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H5f35Hpi3RfHGZxh3W/9WByq7z32WQ0jtlBPqd1m5to=; b=Jy6I/ppMjzm3MMZ1KaWSkEpbGc
	1Hegf81la323lVVLMPBMgxGNAWetWbKyy+aYWIZ8B/ADiAKUPfzv8H3zLLqrX7hXxipyyJi1mphaV
	Oc6Tg6UTWbd9WU+Gg/6Vmr1JKbZILHNeWPs1GFhPuzCMJHquHwFGGqC3hgRADOviqDWzYVOaaWxVy
	7Y06VeFnTZTgolmLIEkcq+4H0suodMoJrOmWlI3R3PUDioqBac0JCresObN6Beg8gLHCUzpr0YhaG
	SaDQZlXDX1QejYXLdPgn3L03DiIltMdnfH9CFkJjuPl+lCTEvsoYX/yl62twMcd3kF2tAx8fSEQOa
	zNLJ6I0w==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVd-00000000iHC-1C5J;
	Mon, 14 Apr 2025 05:37:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 19/43] xfs: add support for zoned space reservations
Date: Mon, 14 Apr 2025 07:36:02 +0200
Message-ID: <20250414053629.360672-20-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 0bb2193056b5969e4148fc0909e89a5362da873e

For zoned file systems garbage collection (GC) has to take the iolock
and mmaplock after moving data to a new place to synchronize with
readers.  This means waiting for garbage collection with the iolock can
deadlock.

To avoid this, the worst case required blocks have to be reserved before
taking the iolock, which is done using a new RTAVAILABLE counter that
tracks blocks that are free to write into and don't require garbage
collection.  The new helpers try to take these available blocks, and
if there aren't enough available it wakes and waits for GC.  This is
done using a list of on-stack reservations to ensure fairness.

Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c  | 15 +++++++++++----
 libxfs/xfs_types.h | 12 +++++++++++-
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c40cdf004ac9..3a857181bfa4 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -35,6 +35,7 @@
 #include "xfs_symlink_remote.h"
 #include "xfs_inode_util.h"
 #include "xfs_rtgroup.h"
+#include "xfs_zone_alloc.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -4783,12 +4784,18 @@ xfs_bmap_del_extent_delay(
 	da_diff = da_old - da_new;
 	fdblocks = da_diff;
 
-	if (bflags & XFS_BMAPI_REMAP)
+	if (bflags & XFS_BMAPI_REMAP) {
 		;
-	else if (isrt)
-		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, del->br_blockcount));
-	else
+	} else if (isrt) {
+		xfs_rtbxlen_t	rtxlen;
+
+		rtxlen = xfs_blen_to_rtbxlen(mp, del->br_blockcount);
+		if (xfs_is_zoned_inode(ip))
+			xfs_zoned_add_available(mp, rtxlen);
+		xfs_add_frextents(mp, rtxlen);
+	} else {
 		fdblocks += del->br_blockcount;
+	}
 
 	xfs_add_fdblocks(mp, fdblocks);
 	xfs_mod_delalloc(ip, -(int64_t)del->br_blockcount, -da_diff);
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index dc1db15f0be5..f6f4f2d4b5db 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -244,12 +244,22 @@ enum xfs_free_counter {
 	 */
 	XC_FREE_RTEXTENTS,
 
+	/*
+	 * Number of available for use RT extents.
+	 *
+	 * This counter only exists for zoned RT device and indicates the number
+	 * of RT extents that can be directly used by writes.  XC_FREE_RTEXTENTS
+	 * also includes blocks that have been written previously and freed, but
+	 * sit in a rtgroup that still needs a zone reset.
+	 */
+	XC_FREE_RTAVAILABLE,
 	XC_FREE_NR,
 };
 
 #define XFS_FREECOUNTER_STR \
 	{ XC_FREE_BLOCKS,		"blocks" }, \
-	{ XC_FREE_RTEXTENTS,		"rtextents" }
+	{ XC_FREE_RTEXTENTS,		"rtextents" }, \
+	{ XC_FREE_RTAVAILABLE,		"rtavailable" }
 
 /*
  * Type verifier functions
-- 
2.47.2

