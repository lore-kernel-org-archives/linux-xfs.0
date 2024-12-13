Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096A5125D6
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052497; cv=none; b=kYb8zJVqX96EDZzeZqx+JqwQoXwzDo7X/UNMrakUtCZ5BtR+amjFRCTkJxmCsTM6SrdcTn0ca8x+LvSMjvOvc8gI8TMyu5TpIDLyqjeUMzLGFYabn65UQueiLjiBem044k4rJ7RHosTFb03qpVU8uOktxRTpT0x6bbEiKkzCvxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052497; c=relaxed/simple;
	bh=pP63uJfHksu1WoUNCTBGDH0eW9QoLqHElQGqo9P1TTw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DGLWU+K7PeOKpREmw//pskjZFZCnXiw6S/6hFDwCQ83RfqFtPm4PErNmn47aCofGfEnrOBkgKMyohh63ZP0T0U0SNYE5tfEB8BRcdS2NQQkv/8TBQWn0FP68xuu/J9jR7ALo1h6LOS54Vf4chz45so8xHVLSgMLY9XHz6Fqn+L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxqBWPn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxqBWPn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86072C4CED3;
	Fri, 13 Dec 2024 01:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052496;
	bh=pP63uJfHksu1WoUNCTBGDH0eW9QoLqHElQGqo9P1TTw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kxqBWPn6AmvAotbWjEP7yC9L2MPvEqh3yKMUJpbFudgvotovAfXtj3jcwAcv79ked
	 YN/tMXV8tDqeyCHpW1SF39Ouvbwzdye0oOllamjxnVmySH9WHqzx8erXhIhe0B/xfh
	 ohKBK+Rt/1oXja59qg+ZoVN7xz5C8SXPyPQ/soe8Oal9taPIyXGk0mTC48nTxoxC9S
	 EYmSi+RaO0IS9AtjV9vWiFfYMnyx2xAsi3ri1eF0XT8SoWEvXOl2rA6QJ5AjwumzSK
	 2FHUsgOJ10Xf2fVgQsDYKAJ9VOMXKEB77e3I36tgefZl+Rs+pGVwhKILcVfeK9LEcJ
	 59zKsO2cJm8oA==
Date: Thu, 12 Dec 2024 17:14:56 -0800
Subject: [PATCH 18/43] xfs: refactor reflink quota updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124876.1182620.15851016747005345273.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

