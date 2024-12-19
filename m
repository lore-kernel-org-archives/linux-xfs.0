Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661E219884C
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637064; cv=none; b=WluyoJnG3uPuc4r0lrx1PVjiT3MkDGVGhXG8bsp6F1dm/ktjnlIzylSLioP3J1faSJT80V9lx6nVqes+0zQ33TnLjx7fKrQWh16uukgi/ll6VrmDueIX3HEaA8dPeIDIxOUttbkIjlae7N7xr+E/i9A4NqnrIWpUy79JrW3WUxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637064; c=relaxed/simple;
	bh=VqbvNoWjRQs46L5/Xu/EPUXMq6a+GB9slHXl2N51EB4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TsqfQ0mwAh//6Uo9IPuKdu1zc8XbqC7bFxGzxtaRiLh4LDrA/lHrJnc2c2wqQtLz3PUnMsOTRXhzAgXCSj40J1oR7k8jO4jASNmslunnYD8lnAq4WiZAmVGg8x2bjrnseB3ZzXMEGQooKO+Hh6g1FSFoZxPbWtnu2a48k3+EMSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jupXuzKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jupXuzKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C7FC4CECE;
	Thu, 19 Dec 2024 19:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637063;
	bh=VqbvNoWjRQs46L5/Xu/EPUXMq6a+GB9slHXl2N51EB4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jupXuzKq6n8f5FM2fdZdIlF9NzuYo3bSt7rv0mShVppmgEkMau6RdspyJAw53hePX
	 ekLMaRcnKfvBgGEBjklDkHxjHZhUfWw5lL1WRmiIKmeotJO3m6P178wQbrjgbR18jT
	 2HKdnRiLHAIIdt9DKClsOS0xqstXuAG/ZNASbYdJq0S+aPt6mzzGQ6g9OlmupBYesM
	 WiVkLgjxYPE/wOHsePTiTrduHZUvCp7VkaOUP8vPpsGqk3AbzDkqMAXtMYrPdafFj0
	 6J1YU4LqIYknWop2zaL2d+2a0jdQqxKUGDG2Htl+G5HzWJ322UBV5iZsCP6t2jMQHs
	 +beF8ktWGmraA==
Date: Thu, 19 Dec 2024 11:37:43 -0800
Subject: [PATCH 18/43] xfs: refactor reflink quota updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581287.1572761.10199818887802475152.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Hoist all quota updates for reflink into a helper function, since things
are about to become more complicated.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c |   37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 66ce29101462cd..29574b015fddc0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -739,6 +739,35 @@ xfs_reflink_cancel_cow_range(
 	return error;
 }
 
+#ifdef CONFIG_XFS_QUOTA
+/*
+ * Update quota accounting for a remapping operation.  When we're remapping
+ * something from the CoW fork to the data fork, we must update the quota
+ * accounting for delayed allocations.  For remapping from the data fork to the
+ * data fork, use regular block accounting.
+ */
+static inline void
+xfs_reflink_update_quota(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	bool			is_cow,
+	int64_t			blocks)
+{
+	unsigned int		qflag;
+
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		qflag = is_cow ? XFS_TRANS_DQ_DELRTBCOUNT :
+				 XFS_TRANS_DQ_RTBCOUNT;
+	} else {
+		qflag = is_cow ? XFS_TRANS_DQ_DELBCOUNT :
+				 XFS_TRANS_DQ_BCOUNT;
+	}
+	xfs_trans_mod_dquot_byino(tp, ip, qflag, blocks);
+}
+#else
+# define xfs_reflink_update_quota(tp, ip, is_cow, blocks)	((void)0)
+#endif
+
 /*
  * Remap part of the CoW fork into the data fork.
  *
@@ -833,8 +862,7 @@ xfs_reflink_end_cow_extent(
 		 */
 		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &data);
 		xfs_refcount_decrease_extent(tp, isrt, &data);
-		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
-				-data.br_blockcount);
+		xfs_reflink_update_quota(tp, ip, false, -data.br_blockcount);
 	} else if (data.br_startblock == DELAYSTARTBLOCK) {
 		int		done;
 
@@ -859,8 +887,7 @@ xfs_reflink_end_cow_extent(
 	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &del);
 
 	/* Charge this new data fork mapping to the on-disk quota. */
-	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
-			(long)del.br_blockcount);
+	xfs_reflink_update_quota(tp, ip, true, del.br_blockcount);
 
 	/* Remove the mapping from the CoW fork. */
 	xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
@@ -1347,7 +1374,7 @@ xfs_reflink_remap_extent(
 		qdelta += dmap->br_blockcount;
 	}
 
-	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, qdelta);
+	xfs_reflink_update_quota(tp, ip, false, qdelta);
 
 	/* Update dest isize if needed. */
 	newlen = XFS_FSB_TO_B(mp, dmap->br_startoff + dmap->br_blockcount);

