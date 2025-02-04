Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DA52185B4;
	Tue,  4 Feb 2025 18:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695098; cv=none; b=imLuwF702hu3iWGy5oFNTf9AEMkcwjCCAJQ7Ow33HvT4bpPLGFqCI1PaensJg+mvCkcrDf9ZSbSWcAEHccOANIF6ZdZsICjWH5sIMzR8mrB8LJiLiTlOV95JnMvVoWe0yIkPFvoVVzkjHFCw9TXibPBcU0IQuXh6RkgzrtDqTMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695098; c=relaxed/simple;
	bh=Oj4GfZBW4oDzY5Nxy5immunZV/OO6PBiunXKTZOu6ms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kHBPajTSGaQaAot36nx9rKCHcTuX3bWuXTjo58YBZzGj9UFuDpiKM+MVP6FPoiEWbIcRvRVOiCmrHDTBp8FPACSKFjF7jpJhZK+nHxSgmpJKHFKa9TQmKuL586+ivSkvquD3DAq8158AsTF0iYPu4KdF7b+7j4H8GjsCd57cr7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8jDTljA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8jDTljA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61020C4CEDF;
	Tue,  4 Feb 2025 18:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695097;
	bh=Oj4GfZBW4oDzY5Nxy5immunZV/OO6PBiunXKTZOu6ms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d8jDTljAY9MMgRIEASFBVofkulD3hcD/t67DoPnIYHcUv5xk68DEBSWW85W03ZVR1
	 sT9TJoB6fPjNsv00Xq9WOOMOf0fCBxMnLswXIlmiGkI//lf7NlkG+lEeL+rhqyf3O5
	 Aq9tnuoB7OzK3MRihzlKmm+v+ZbqfOAJMPmcqshP4T9BsUdVlkY7CkJQX8CB27IQu/
	 0S2uzk2oMWU3UsQbHGKx9v/3Lkz0JVQ/PWkOiDJePWyZEmEiPxE04bnOifjDJyjz3j
	 lfcK/Tk8e/blz2+VR5SZ/V53nipXuOpei9bm7OvU6LvJtMrx7qBClxhSQmarCZSAJG
	 RNu2rdzjb/MgQ==
Date: Tue, 04 Feb 2025 10:51:36 -0800
Subject: [PATCH 02/10] xfs: don't lose solo superblock counter update
 transactions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org
Cc: hch@lst.de, stable@vger.kernel.org
Message-ID: <173869499374.410229.15051479322100938302.stgit@frogsfrogsfrogs>
In-Reply-To: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
References: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

commit c817aabd3b08e8770d89a9a29ae80fead561a1a1 upstream

Superblock counter updates are tracked via per-transaction counters in
the xfs_trans object.  These changes are then turned into dirty log
items in xfs_trans_apply_sb_deltas just prior to commiting the log items
to the CIL.

However, updating the per-transaction counter deltas do not cause
XFS_TRANS_DIRTY to be set on the transaction.  In other words, a pure sb
counter update will be silently discarded if there are no other dirty
log items attached to the transaction.

This is currently not the case anywhere in the filesystem because sb
counter updates always dirty at least one other metadata item, but let's
not leave a logic bomb.

Cc: <stable@vger.kernel.org> # v2.6.35
Fixes: 0924378a689ccb ("xfs: split out iclog writing from xfs_trans_commit()")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 001d9bec4ed571..ee46051db12dde 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -834,6 +834,13 @@ __xfs_trans_commit(
 
 	trace_xfs_trans_commit(tp, _RET_IP_);
 
+	/*
+	 * Commit per-transaction changes that are not already tracked through
+	 * log items.  This can add dirty log items to the transaction.
+	 */
+	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
+		xfs_trans_apply_sb_deltas(tp);
+
 	error = xfs_trans_run_precommits(tp);
 	if (error)
 		goto out_unreserve;
@@ -864,8 +871,6 @@ __xfs_trans_commit(
 	/*
 	 * If we need to update the superblock, then do it now.
 	 */
-	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
-		xfs_trans_apply_sb_deltas(tp);
 	xfs_trans_apply_dquot_deltas(tp);
 
 	xlog_cil_commit(log, tp, &commit_seq, regrant);

