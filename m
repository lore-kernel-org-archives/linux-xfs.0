Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1B12837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995459; cv=none; b=V2Y5FmrbYVnVTNhOj8W+HMqpObgVO2s2YDPqA06h+OhQDsJKKrhqnEw7wx/VYUAkk0zn+hRtenrp2RTNg25x38nlZivinAgI4f9st1ixTOJ9I6dx4x/5dZklG8kEi2qjmWAu5dqJGebD6AH7bP5nyE5+PHI7PaFeDUiWV76djtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995459; c=relaxed/simple;
	bh=VqbvNoWjRQs46L5/Xu/EPUXMq6a+GB9slHXl2N51EB4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nfpV+8H3/FHEZQw2VOivsg1mf1PXUph0hEFQ0Kg8B3nq5aOH+4dNQhgG61wwLHKo9/XNsmSIyJC1A0e+9ElKqmFlZ9o7yEMSZmWxgvx5M7w6Fma63JS6mP2Nd3mH53WXcDMtxyupwU7le+6CSyLuYgZgQ2WcpdScAwL3HTB7R1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVm3uGqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVm3uGqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBB1C4CED3;
	Mon, 23 Dec 2024 23:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995459;
	bh=VqbvNoWjRQs46L5/Xu/EPUXMq6a+GB9slHXl2N51EB4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YVm3uGqRQ3G2l66FSJ+wgzeAs0PE8TGUKJjokkCkHYHmtpspHNYScPr/EKiL4f0Ff
	 UVR0dH4mCq27cVqiu3LxjYZeF3x0VmKstnUMX/Ja5S0VsU/NltAPBa6Ynofymt0qxD
	 ttWh4DQKcb5s4eol9Z6Y3pymSy58tgewBwwIUmdD9Mt+G/e6LwG26IZED7WaHsXmpD
	 XnqkrAXGHgrCZ/dZsbPrG5N7EAwbGojP2PlpP9SDjebVvrAujBfLY1VgIO1Bb9kkwR
	 BzFP2S6kqv45+l0YFZuOXowTKXbgfIDkO0+9FDxb1LTZqBHDNNIFkZ2Zu7mpkWenHJ
	 GSJW/0hvfx0LA==
Date: Mon, 23 Dec 2024 15:10:58 -0800
Subject: [PATCH 18/43] xfs: refactor reflink quota updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420248.2381378.364102620650375754.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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

