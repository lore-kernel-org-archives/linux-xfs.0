Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A0444C653
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319624; cv=none; b=FLlg3NVFpJ9ZSPh5WQk64e3YP95/xpExff4CWTv3wn7eGjSV787nmE+QuE0muDX+vK5QRYiN9HVRwDhTWqzqYpwyCwae85aO4N6ys29338UOvoYL/C9WB3scKBhHQhzfqEmoldJ1/GKSNfI6OORxJLjaQLRmf8phNyk8RoP4T8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319624; c=relaxed/simple;
	bh=b1oaIjEfYCl5ssx33nTYD9wYqVvSiMAFsj07OiAISiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7hD1TrbFySJ2zobVlKpZLgv6Y8OTUSal9qavzyv/UBll8opQuTP9LCrYI27P9/OBoPOkmUnWcMOJtPVSMGMWEUCWV+9/KwYOu6Xknnk/z5SaXajd2A4FRh+uHgSum1BgmGyKdXaAzBuA2hP2VnULDkLAREQ6AmnecmrQs4xs6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LAymOS+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LAymOS+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F1F1F00A3A;
	Wed, 29 Jul 2026 10:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319623;
	bh=+sSkUFXG9Y1E4BsL6ZfOT1rgnJc9KfXxLrh0cZJJoYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LAymOS+89BQRCcizopGw6u1Xa4HQpnCJvVHkE0HphotuPpkJ9Hcj1i42jsJ/AscZy
	 IdOIzeTiMG/owPZH0A0XGBPqvu3ebqSMEsMYT5ez0zuHltBkOScVNnFoAflUXruF5g
	 nmU9UZoUyuyIA5ZwmgJd4ULD8dlPPEnj3vUsYch5po+5cDeNKicPb3q/9whTXAwXh/
	 4jfoKSRhi2GgwGH+JWDoAvivutWg/J3xrGEO5M03cDpvN9srs4Q2wG2bOMU8N4qv1r
	 t8wSp9REGPd33GiFGr9XB6Rv30znAs5q7P+rpbT5oBsoroeTeRK/ZVgOFyUrtYh+Bi
	 +fbS2tCjnzAqw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 24/33] xfs: convert xfs_zoned_end_io to rolling transactions
Date: Wed, 29 Jul 2026 20:02:08 +1000
Message-ID: <20260729100629.1943710-25-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert xfs_zoned_end_io() from per-extent transaction allocation
to a single rolling transaction that keeps the ILOCK held across
the entire extent mapping loop.

The rolling transaction keeps the ILOCK held throughout, making the
zoned IO completion operation atomic with respect to other concurrent
extent manipulations. XFS_TRANS_RENEW_BLKRES is set so that the
block reservation is automatically renewed by xfs_defer_finish()
after each iteration's deferred operations are processed.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 7e3456ca28ac..d24afffe255f 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -13,6 +13,7 @@
 #include "xfs_inode.h"
 #include "xfs_iomap.h"
 #include "xfs_trans.h"
+#include "xfs_defer.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
@@ -314,6 +315,13 @@ xfs_zoned_map_extent(
 	return 0;
 }
 
+/*
+ * Map written extents into the data fork after zoned IO completion.
+ *
+ * The rolling transaction keeps the ILOCK held across the entire mapping
+ * loop, making the operation atomic with respect to other concurrent
+ * extent manipulations.
+ */
 int
 xfs_zoned_end_io(
 	struct xfs_inode	*ip,
@@ -337,24 +345,23 @@ xfs_zoned_end_io(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
+			XFS_TRANS_RESERVE | XFS_TRANS_RENEW_BLKRES, &tp);
+	if (error)
+		return error;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
 	while (new.br_startoff < end_fsb) {
 		new.br_blockcount = end_fsb - new.br_startoff;
 
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
-				XFS_TRANS_RESERVE, &tp);
-		if (error)
-			return error;
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_ijoin(tp, ip, 0);
-
 		error = xfs_zoned_map_extent(tp, ip, &new, oz, old_startblock);
 		if (error)
-			xfs_trans_cancel(tp);
-		else
-			error = xfs_trans_commit(tp);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			goto out_cancel;
+
+		error = xfs_defer_finish(&tp);
 		if (error)
-			return error;
+			goto out_cancel;
 
 		new.br_startoff += new.br_blockcount;
 		new.br_startblock += new.br_blockcount;
@@ -362,7 +369,14 @@ xfs_zoned_end_io(
 			old_startblock += new.br_blockcount;
 	}
 
-	return 0;
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
 }
 
 /*
-- 
2.55.0

