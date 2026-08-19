Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D248F302CC1
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098528; cv=none; b=ngeoShkb5MCEd2ZN6gln3+mn9LknXaaY91cWmMmJ69zlXtiRQHkcdza4zC4PcxaqA2Pk1guzJ6Knl5dMT18I7V2ZeZI6euc01IQjf1t82WIc/RoIbthLd7Y/fF7v874eZsGlASxyMyme8MBEDbtvmTDYFYnupEfpiRajUGjinHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098528; c=relaxed/simple;
	bh=/84Dxa7wp1dKpglL4Ik42kMxKjCyKt/Nd09JathQgKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvMmpKce0Bj/cPhBGB27JWjO/2o9PVYd1vXxmfBUffPgQCYPP50T/mn/wRq/MS0fqA8DgLiGNWHYc3GmqAMeHdiWWCGCkPxAN8x7PPyrP+A/eYohpQePJClAg+l7+xnx5l9z/peGbC5xzKMY9sRO99H0A7OTfLsB0LfqGrKcKVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NeF/6JFg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NeF/6JFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0668A1F000E9;
	Wed, 19 Aug 2026 00:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098526;
	bh=Zp/nIM1LADldFP1w/b+Ezi5Gdh0Ol43mdYiWXbP5dqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NeF/6JFgMzvhZ9JwP/lJ3ked6USGfLnDLW9vsaeGrZ/+ZCfwbPcWGBsjpN8hwxkpc
	 Rc/BUS1oY1ERovmu2mE8F06d8/lWT7COZPB3b3dllUhZ1ZpRN+/Ksn0Fel26TNdwxn
	 IZx9SlefD3v0dvG6kdhgX8SX9Qa1MyZBbAmyqVhWRePSP+ZakM7mbKMMnlo99bIY3I
	 IhVkjvjVwK63bL58FrgJ31NqLAtF9yZJsJcbXtW0qwaOVpWNrOUPphiM8HNE6JmSmB
	 w+vnRIlcz//2hxIJBHASwoaKgSRl4eE4tAby6HLX13QG62gvSuA8M3Kr8wAJzM1ieb
	 YSLDjpLOXi2qQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 30/38] xfs: plumb struct xfs_trans *tp into xfs_iomap_write_direct
Date: Wed, 19 Aug 2026 10:12:33 +1000
Message-ID: <20260819001442.1451892-31-dgc@kernel.org>
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

Add a struct xfs_trans *tp parameter to xfs_iomap_write_direct().
When a non-NULL transaction is provided, use it directly for the
allocation instead of allocating one internally. The block
reservation is added to the caller's transaction via
xfs_trans_reserve_more_inode().

On success with a caller-supplied transaction, the function returns
without committing or unlocking. On error, it returns the error
without cancelling.

When tp is NULL, the existing behaviour is preserved.

All callers currently pass NULL, so there is no functional change.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 41 ++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_iomap.h |  7 ++++---
 fs/xfs/xfs_pnfs.c  |  2 +-
 3 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e43ce4811283..f3e4f243e877 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -267,6 +267,7 @@ xfs_iomap_eof_align_last_fsb(
 
 int
 xfs_iomap_write_direct(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		offset_fsb,
 	xfs_fileoff_t		count_fsb,
@@ -275,7 +276,7 @@ xfs_iomap_write_direct(
 	u64			*seq)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
+	struct xfs_trans	*local_tp = NULL;
 	xfs_filblks_t		resaligned;
 	int			nimaps;
 	unsigned int		dblocks, rblocks;
@@ -296,7 +297,10 @@ xfs_iomap_write_direct(
 		rblocks = 0;
 	}
 
-	error = xfs_qm_dqattach(ip);
+	if (tp)
+		error = xfs_qm_dqattach_locked(ip, false);
+	else
+		error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
 
@@ -322,10 +326,18 @@ xfs_iomap_write_direct(
 		}
 	}
 
-	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
-			rblocks, force, &tp);
-	if (error)
-		return error;
+	if (tp) {
+		error = xfs_trans_reserve_more_inode(tp, ip, dblocks, rblocks,
+				force);
+		if (error)
+			return error;
+	} else {
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
+				rblocks, force, &tp);
+		if (error)
+			return error;
+		local_tp = tp;
+	}
 
 	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK, nr_exts);
 	if (error)
@@ -341,9 +353,9 @@ xfs_iomap_write_direct(
 	if (error)
 		goto out_trans_cancel;
 
-	/*
-	 * Complete the transaction
-	 */
+	if (!local_tp)
+		return 0;
+
 	error = xfs_trans_commit(tp);
 	if (error)
 		goto out_unlock;
@@ -359,8 +371,11 @@ xfs_iomap_write_direct(
 	return error;
 
 out_trans_cancel:
-	xfs_trans_cancel(tp);
-	goto out_unlock;
+	if (local_tp) {
+		xfs_trans_cancel(tp);
+		goto out_unlock;
+	}
+	return error;
 }
 
 STATIC bool
@@ -1154,8 +1169,8 @@ xfs_direct_write_iomap_begin(
 		end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
 	xfs_iunlock(ip, lockmode);
 
-	error = xfs_iomap_write_direct(ip, offset_fsb, end_fsb - offset_fsb,
-			flags, &imap, &seq);
+	error = xfs_iomap_write_direct(NULL, ip, offset_fsb,
+			end_fsb - offset_fsb, flags, &imap, &seq);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index ebcce7d49446..937a61c7a610 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -12,9 +12,10 @@ struct xfs_inode;
 struct xfs_bmbt_irec;
 struct xfs_zone_alloc_ctx;
 
-int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
-		xfs_fileoff_t count_fsb, unsigned int flags,
-		struct xfs_bmbt_irec *imap, u64 *sequence);
+int xfs_iomap_write_direct(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t offset_fsb, xfs_fileoff_t count_fsb,
+		unsigned int flags, struct xfs_bmbt_irec *imap,
+		u64 *sequence);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 		xfs_fileoff_t end_fsb);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f8535ecde21a..442564967b39 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -202,7 +202,7 @@ xfs_fs_map_blocks(
 					       imap.br_blockcount);
 		xfs_iunlock(ip, lock_flags);
 
-		error = xfs_iomap_write_direct(ip, offset_fsb,
+		error = xfs_iomap_write_direct(NULL, ip, offset_fsb,
 				end_fsb - offset_fsb, 0, &imap, &seq);
 		if (error)
 			goto out_unlock;
-- 
2.55.0

