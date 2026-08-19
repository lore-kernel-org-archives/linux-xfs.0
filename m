Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA53231A3B
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098521; cv=none; b=lh4whnmy0hpFyYRlG1anDO5DGk7pAhYDAEusPpTG5AgxnCtUDNmgMQRs1QfwBNs5zVCj+uWwYK/+mmESdCbrhEY4DhR8NfvgD2/VgNoEY+cGOwwcrsvglp6xnLSxKjEkLRbCHW5vo6P3BKo9PQNyjfSht8gzV8VfB42u4WmFTK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098521; c=relaxed/simple;
	bh=jq+KSfTPWCL+mBpJy/yoObowXaQD+ThbVEc3cPpGECE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOVcc6FIuUCDiSUl/mOOTn6UVXKQoc1eGJ690YeQNBmXgqTIOb56LipWBA+tOQAJ4xVCY6uXE8/IFMrMV3hzteAuiZMMqnI5NOOJp6ksK448rBExD74bofHkEUxX1oc35sEBHzPxgCFZxffE0e+Te8kkcrhyNSO7hfPMSS9lAWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fXjqoklM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fXjqoklM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECB71F00A3A;
	Wed, 19 Aug 2026 00:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098520;
	bh=w9dUY6PyRSP2irjJ+ssMkZYm1DW/QDsSpdYH1s8Z78Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXjqoklMIQ742vpzYggx+0A2KV2VB4bESYDwZpWqLoc1rZqQGwRoDzOYLv0mjYyuX
	 MCRcj7UAaBzupVub/G+vMorX3HWMUMWpmk1W/UG/n7QyXrCAQkr4lKhncyKhym0Zax
	 3YdsKVZtooBvMGXdut3BJ7HFYdEi77XlUaWMIraB1XGgVquKp3lJ0gFMktWBzGAG0B
	 Q9UtYZiXGhinHOWceT5QPTDSjdHWzcjT6l9dAH5iEV1+7dbvVsZDumKMFyFNq11h3h
	 caNk47g/8mTLgA00wI6jSYg2qDixI91xSoWMSfSL7pCsg3xzMro23yKOJ2SuznYdIF
	 I0bVtzGilKWVg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 25/38] xfs: convert xfs_iomap_write_unwritten to rolling transactions
Date: Wed, 19 Aug 2026 10:12:28 +1000
Message-ID: <20260819001442.1451892-26-dgc@kernel.org>
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

Convert xfs_iomap_write_unwritten() from per-iteration transaction
allocation to a single rolling transaction that keeps the ILOCK
held across the entire unwritten extent conversion loop.

Previously each iteration allocated a new transaction, acquired the
ILOCK, converted one extent, committed, and released the ILOCK.
This left a window where the extent tree could change between
iterations.

The rolling transaction keeps the ILOCK held throughout, making the
multi-extent conversion atomic with respect to other concurrent
extent operations. XFS_TRANS_RENEW_BLKRES is set so that the btree
split block reservation is automatically renewed after each
xfs_defer_finish() call.

The startblock corruption check is performed after xfs_defer_finish()
commits the dirty transaction, so that corruption detection warns and
returns an error without causing a filesystem shutdown from cancelling
a dirty transaction.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 71 +++++++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 16feac3ad3bd..e43ce4811283 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -19,6 +19,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trans.h"
+#include "xfs_defer.h"
 #include "xfs_trans_space.h"
 #include "xfs_inode_item.h"
 #include "xfs_iomap.h"
@@ -702,44 +703,49 @@ xfs_iomap_write_unwritten(
 	if (error)
 		return error;
 
-	do {
-		/*
-		 * Set up a transaction to convert the range of extents
-		 * from unwritten to real. Do allocations in a loop until
-		 * we have covered the range passed in.
-		 *
-		 * Note that we can't risk to recursing back into the filesystem
-		 * here as we might be asked to write out the same inode that we
-		 * complete here and might deadlock on the iolock.
-		 */
-		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks,
-				0, true, &tp);
-		if (error)
-			return error;
+	/*
+	 * Allocate the transaction once and use a rolling transaction to
+	 * convert the range of extents from unwritten to real. The rolling
+	 * transaction keeps the ILOCK held across the entire conversion,
+	 * making it atomic with respect to other concurrent extent
+	 * operations. The block reservation is automatically renewed on
+	 * each roll by XFS_TRANS_RENEW_BLKRES.
+	 *
+	 * Note that we can't risk recursing back into the filesystem here
+	 * as we might be asked to write out the same inode that we complete
+	 * here and might deadlock on the iolock.
+	 */
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks,
+			0, true, &tp);
+	if (error)
+		return error;
+	tp->t_flags |= XFS_TRANS_RENEW_BLKRES;
 
+	do {
 		error = xfs_iomap_write_unwritten_one(tp, ip, offset_fsb,
 				count_fsb, end, update_isize, resblks, &imap);
-		if (error) {
-			xfs_trans_cancel(tp);
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			return error;
-		}
+		if (error)
+			goto out_cancel;
 
-		error = xfs_trans_commit(tp);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		/*
+		 * Roll the transaction to commit the conversion and renew
+		 * the block reservation. The startblock validation must be
+		 * done after the roll commits the transaction, so that a
+		 * corruption detection does not cancel a dirty transaction
+		 * and shut down the filesystem.
+		 */
+		error = xfs_defer_finish(&tp);
 		if (error)
-			return error;
+			goto out_cancel;
 
 		if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock))) {
 			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
-			return xfs_alert_fsblock_zero(ip, &imap);
+			error = xfs_alert_fsblock_zero(ip, &imap);
+			goto out_cancel;
 		}
 
-		if ((numblks_fsb = imap.br_blockcount) == 0) {
-			/*
-			 * The numblks_fsb value should always get
-			 * smaller, otherwise the loop is stuck.
-			 */
+		numblks_fsb = imap.br_blockcount;
+		if (numblks_fsb == 0) {
 			ASSERT(imap.br_blockcount);
 			break;
 		}
@@ -747,7 +753,14 @@ xfs_iomap_write_unwritten(
 		count_fsb -= numblks_fsb;
 	} while (count_fsb > 0);
 
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
 
 static inline bool
-- 
2.55.0

