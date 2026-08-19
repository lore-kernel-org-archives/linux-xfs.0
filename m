Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0B82FDC53
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098526; cv=none; b=nERK5XxunNx3+O1UaI5cwQrPbchJZwNapakpiTaKmf6Tj594W1jWIHcfsIxwl1BQUtWNORXSxCx6f7JTQy2p3PlpYi5XsKplizj1x9nlSVb2aiZfR62ypteRE6ajbihN3ULuqaqA3ygj+lOvYCdBwVMmhkrxndPiCLnAHVWxF/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098526; c=relaxed/simple;
	bh=ZxPO/AoIVl+QjYQ6JOUsk/n8zsARkh9pyROd2XeyUmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNgDDFVAoUej3zRY9cUkiMu+3Z7qSrKE0/XpqmRNfgf1c5Y+KyRl8+0ZRMU4oL6gKwFZpzH9Oeg7Rvc/go2bztDqPzXWLdPB+r+2Q7UnNBHG53McqbRK71u5LVRGIMLn9RPxafF37BRrfYo3DYBmHoIv+Et0cTSsizznOLTDUwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/wDFntX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/wDFntX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FE51F00A3A;
	Wed, 19 Aug 2026 00:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098525;
	bh=E4yE3Vq9R1SmS0KwURoTWDMsdlnbiQ+3amuvwp+l+Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/wDFntXsBZkiNr5IjApsJ1sLtuifG6/dQJGKp2NQCoAsnZpQ3Az+ZL6Teymr9Efr
	 /xqXBSKdvdwirT4GPnKZPcQVYUGR0JFb1LgnpsYtbHlELTlCx8JtfYlXuOv7oouK/6
	 9gFyuixwVX0lOCuiePnHTi71xGcj+FVsiMqSWOhYXVoBhiSSVQg2n9fTQjWZkzk008
	 oWI2GHtRKuKBDmT8sK6JeuOSwxqwe1Z0yeZfuV9sr7t5AMxXOLYdVehCCI+j3EG8Qy
	 mXQRuml29OK98oEY00pYC5zktJ0tepyj1Yz4xx0/uvaLxBDRu7pXi+KxSIjpa55J81
	 MMZeRlUCeVr2A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 29/38] xfs: convert xfs_zoned_end_io to rolling transactions
Date: Wed, 19 Aug 2026 10:12:32 +1000
Message-ID: <20260819001442.1451892-30-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
References: <20260819001442.1451892-1-dgc@kernel.org>
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
index 61b483d24c88..25134298a5d3 100644
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
@@ -341,24 +349,23 @@ xfs_zoned_end_io(
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
@@ -366,7 +373,14 @@ xfs_zoned_end_io(
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

