Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4F2275851
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 11:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747050194; cv=none; b=XfIQS+y3iocstImcq5SJJjuEW7Ou45wG/Lx8wyXkMORSCYGnPuC3I7HcWwG0INBjBTAPoXh4SRM3757uqkB1im/hTaR+2eZBPksAHyzjhsQy3tHTtihdcLVnWNACB2SaRQ3gY0L/GkA+en1k4nayvesNmdrzzdFc2zuXJ56DwZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747050194; c=relaxed/simple;
	bh=jVMRzvT9+eYbMrAQLirGYxWcGdmL9S4Tzs+nVdn6jRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paCCWlQIJKGHJnXe2VXFr9zEHpiWoO70EXpdPLexmWT+g+zfcG2a5WnMCi5JvXfRdSMGH3Tm3hVzdVin9OdwPS2CRHndPXfzaO6EgsGZ6q8vvNE6fSbGxeY7SHQVpXpPyBAghZboBwavEvGpmp+VypKLRPvhHtYhrTRv7mU3mh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sSEx64QI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sSEx64QI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1452C4CEED;
	Mon, 12 May 2025 11:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747050194;
	bh=jVMRzvT9+eYbMrAQLirGYxWcGdmL9S4Tzs+nVdn6jRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSEx64QIyfE5RqaP7DGt6Rj+VTAHHWpbEctlJ1rPRj6sStOh2xWspTEHGvAvrtMpd
	 vk/T4kx/IBSQQ4jMvkoTITIxhoLvc+kJanfsp/M1C3op/NQ8VGIK6AsqC84OXYn6ml
	 /Kd6AiZyHMka2itMbdVRgW/DQbsGKHAXuqbUMBwaiLaF12WPCWZKBS8jbzb8tTRlKN
	 LEA6/iJ39UA6A0vlbbaQira6tUDkkf1r9wgIDNGVPWAUkN5MwGHoEQFOUsbOy96OuV
	 iw3HCMExFkQBBmO3SZYXSxdawCSk4Wfed9KFR1iOy3ceZH7zgjWEho0ojsEm3mhiFV
	 OzdkRdGn68liQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	djwong@kernel.org,
	david@fromorbit.com
Subject: [PATCH V2 2/2] xfs: Fix comment on xfs_trans_ail_update_bulk()
Date: Mon, 12 May 2025 13:42:56 +0200
Message-ID: <20250512114304.658473-3-cem@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512114304.658473-1-cem@kernel.org>
References: <20250512114304.658473-1-cem@kernel.org>
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
Changelog:
	V2: - Fix a busted comment
	    - Wrap lines over 80+ columns
	    - Update subject

 fs/xfs/xfs_trans_ail.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 7d327a3e5a73..67c328d23e4a 100644
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
+ * Items that are already in the AIL are first deleted from their current
+ * location before being added to the temporary list.
+ *
+ * This avoids needing to do an insert operation on every item.
+ *
+ * The AIL lock is dropped by xfs_ail_update_finish() before returning to
+ * the caller.
  */
 void
 xfs_trans_ail_update_bulk(
-- 
2.49.0

