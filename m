Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6983B1FF7B4
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 09:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746611570; cv=none; b=YDisKAImfg8lV3vMIgf/8bXfPTUKDvRna+b3AkMzIPiqpJ/mVbkm9VvLYUxoAFd/Bh/h0/E9eZr2UfM1eS7dCo9bmLB6EY855mT0Fz9VtEeOg4R/oMsE9NY2Gq0CEn36jlxLzag/NMRY7GXG2gMlG09+1F8tBSCfrKRG8KU49cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746611570; c=relaxed/simple;
	bh=LJiZjo3cp+mIUcvPt+QfRWBJG53E9KkTj6t3K1r5yds=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrdCxNmiZoXPZQSK6K1WeGV9UiNyzMFs1f/pAcOYBALIq1HF5cvULOAe6uj56Eimjdo7JzwX+cuFOso+tOsnrIAqzxJdzmUSPr1WaSuHmdQ1ogdJrY+5dmxG5xd3YiG3Lq+/neFMoKgCcDE58qjf+k02VQiueTBGDs7I34qejjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O23i9pIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O23i9pIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A70DC4CEEE
	for <linux-xfs@vger.kernel.org>; Wed,  7 May 2025 09:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746611569;
	bh=LJiZjo3cp+mIUcvPt+QfRWBJG53E9KkTj6t3K1r5yds=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=O23i9pIVvAlY+iawXqAaHery3/2HXnOgNidBfenSZAB6uJFyJiBfNsTl05F+lwmVg
	 +w2/6GThlY831HGM0vr6LAnG5jaWvAQDAUW39AQFbYPQzW6nTsQ7qsLnVZ+8Ka02cS
	 SQvQiCPITpLGQbrmr0mOWmdvg6ZowVo9eb/qAxzdHEKLHp+ljQebwsCmeb5EQO5HKI
	 toWqsnwYpxGedmK/7N0urOUM5xYd+czLXQbaTrWao5aUaV02j7rH4H/pYextF56iTH
	 DFc/mJTfjjibZSxgZNWFQL4xOkyipxeLI/ZuWvdgqU/FoFHDknM3Fhv8DQ3dlITRSu
	 HFYD65YktBCOA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] XFS: Fix comment on xfs_trans_ail_update_bulk()
Date: Wed,  7 May 2025 11:52:31 +0200
Message-ID: <20250507095239.477105-3-cem@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507095239.477105-1-cem@kernel.org>
References: <20250507095239.477105-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This function doesn't take the AIL lock, but should be called
with AIL lock held. Also (hopefuly) simplify the comment.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_trans_ail.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 7d327a3e5a73..ea092368a5c7 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -777,26 +777,28 @@ xfs_ail_update_finish(
 }
 
 /*
- * xfs_trans_ail_update - bulk AIL insertion operation.
+ * xfs_trans_ail_update_bulk - bulk AIL insertion operation.
  *
- * @xfs_trans_ail_update takes an array of log items that all need to be
+ * @xfs_trans_ail_update_bulk takes an array of log items that all need to be
  * positioned at the same LSN in the AIL. If an item is not in the AIL, it will
- * be added.  Otherwise, it will be repositioned  by removing it and re-adding
- * it to the AIL. If we move the first item in the AIL, update the log tail to
- * match the new minimum LSN in the AIL.
+ * be added. Otherwise, it will be repositioned by removing it and re-adding
+ * it to the AIL.
  *
- * This function takes the AIL lock once to execute the update operations on
- * all the items in the array, and as such should not be called with the AIL
- * lock held. As a result, once we have the AIL lock, we need to check each log
- * item LSN to confirm it needs to be moved forward in the AIL.
+ * If we move the first item in the AIL, update the log tail to match the new
+ * minimum LSN in the AIL.
  *
- * To optimise the insert operation, we delete all the items from the AIL in
- * the first pass, moving them into a temporary list, then splice the temporary
- * list into the correct position in the AIL. This avoids needing to do an
- * insert operation on every item.
+ * This function should be called with the AIL lock held.
  *
- * This function must be called with the AIL lock held.  The lock is dropped
- * before returning.
+ * To optimise the insert operation, we add all items to a temporary list, then
+ * splice this list into the correct position in the AIL.
+ *
+ * Items that are already in the AIL are first deleted from their current location
+ * before being added to the temporary list.
+ *
+ * This avoids needing to do an insert operation on every item.
+ *
+ * The AIL lock is dropped by xfs_ail_update_finish() before returning to
+ * the caller.
  */
 void
 xfs_trans_ail_update_bulk(
@@ -817,7 +819,7 @@ xfs_trans_ail_update_bulk(
 	for (i = 0; i < nr_items; i++) {
 		struct xfs_log_item *lip = log_items[i];
 		if (test_and_set_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
-			/* check if we really need to move the item */
+			* check if we really need to move the item */
 			if (XFS_LSN_CMP(lsn, lip->li_lsn) <= 0)
 				continue;
 
-- 
2.49.0

