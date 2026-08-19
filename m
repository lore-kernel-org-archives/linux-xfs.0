Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BC125B0A3
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098538; cv=none; b=djtdwyfdB8Ds49L2CvkOv/TLX8axF0as/tbp8TdLmh7uqHrBcGY6/H5/S3ke4xY/PBvwVVtcdVqjIBvZjQBpKGWuAg6dZqbeq4X9VtatvQcecetpxk1uPlbCG2jDsyyeUwLXbTsoPvl2skauPSCq67GoIqj/+WtcXX/ytCijLhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098538; c=relaxed/simple;
	bh=q4EEquVeL/lroanw37YE8M6Ta6tlxmJQmkS+69KH/Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7zOI+l1v2GwZmSFoSodIPizUf4qP4fu2YEgfGW33hM6+kLLFqvLvLSC729Ojz3Gk5y5Z/8NyqJD/b/7fi5XI8aBv1ri6WZRk0ab1l+t73QXO8Za8WFK0eTzk1vvg8NAYArDVriYPuC8RULz7aCzDbhFLaumK1O3k+lZwxqqWAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8t5Ynbr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8t5Ynbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6141F000E9;
	Wed, 19 Aug 2026 00:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098537;
	bh=rfQfgwXVYsLl/73nH7P40gS/Bqqnb8XQ/q2UCBBRB2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B8t5Ynbr0Xts/9kmm3iGZQ4APcDLHGoufdHtWvZ/z7RFIvCOC0jeg+XdAoZKsZ3Ws
	 7GnyyAfdtnHYN83nhoDN1or2zH+Hw0XgKLGH5HiKlEegAhXxGetsR7qIvMUMoAe5Nf
	 2pGlXe79s1I6cJLFhsl9OyQlM3lcfCGjvW7y9BhRh+d836d7ryp/ZQZTyjJK/pnJj5
	 sTuyWIPvKWJjS1R3bAhh3TqCBGW2L60gPSWkrPozHXm/QRXn48DiZ4ao5e+jhLjBXC
	 cPV9akTvQcyrPnV4hDES1Ladukt2QPEkcm5z5EqN7ISoVEH3ZupsNGG4EcV+3WwV+3
	 JjDi7Cti7wh5g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 38/38] xfs: remove dead internal transaction path from xfs_iomap_write_direct
Date: Wed, 19 Aug 2026 10:12:41 +1000
Message-ID: <20260819001442.1451892-39-dgc@kernel.org>
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

Now that all callers supply a valid transaction via args->tp,
remove the dead internal transaction allocation path from
xfs_iomap_write_direct().

The function is now a pure allocation helper: it reserves blocks
via xfs_trans_reserve_more_inode(), extends the inode extent count,
calls xfs_bmapi_write(), and fills in the iomap. All error paths
return directly since the caller manages the transaction and lock
lifecycle.

The xfs_qm_dqattach() call is replaced with xfs_qm_dqattach_locked()
since the ILOCK is always held on entry.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 48 ++++++++--------------------------------------
 1 file changed, 8 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4b2860e80d9f..4c7b11e4a6a1 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -271,7 +271,6 @@ xfs_iomap_write_direct(
 {
 	struct xfs_inode	*ip = args->ip;
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*local_tp = NULL;
 	xfs_filblks_t		resaligned;
 	int			nimaps;
 	unsigned int		dblocks, rblocks;
@@ -281,6 +280,7 @@ xfs_iomap_write_direct(
 	int			nr_exts = XFS_IEXT_ADD_NOSPLIT_CNT;
 	u64			seq;
 
+	ASSERT(args->tp);
 	ASSERT(args->count_fsb > 0);
 
 	resaligned = xfs_aligned_fsb_count(args->offset_fsb, args->count_fsb,
@@ -293,10 +293,7 @@ xfs_iomap_write_direct(
 		rblocks = 0;
 	}
 
-	if (args->tp)
-		error = xfs_qm_dqattach_locked(ip, false);
-	else
-		error = xfs_qm_dqattach(ip);
+	error = xfs_qm_dqattach_locked(ip, false);
 	if (error)
 		return error;
 
@@ -322,55 +319,26 @@ xfs_iomap_write_direct(
 		}
 	}
 
-	if (args->tp) {
-		error = xfs_trans_reserve_more_inode(args->tp, ip, dblocks,
-				rblocks, force);
-		if (error)
-			return error;
-	} else {
-		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
-				rblocks, force, &args->tp);
-		if (error)
-			return error;
-		local_tp = args->tp;
-	}
+	error = xfs_trans_reserve_more_inode(args->tp, ip, dblocks, rblocks,
+			force);
+	if (error)
+		return error;
 
 	error = xfs_iext_count_extend(args->tp, ip, XFS_DATA_FORK, nr_exts);
 	if (error)
-		goto out_trans_cancel;
+		return error;
 
 	nimaps = 1;
 	error = xfs_bmapi_write(args->tp, ip, args->offset_fsb, args->count_fsb,
 				bmapi_flags, 0, &args->imap, &nimaps);
 	if (error)
-		goto out_trans_cancel;
+		return error;
 
 	seq = xfs_iomap_inode_sequence(ip, args->iomap_flags);
-	if (local_tp) {
-		error = xfs_trans_commit(args->tp);
-		args->tp = NULL;
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		if (error)
-			return error;
-		if (unlikely(!xfs_valid_startblock(ip,
-				args->imap.br_startblock))) {
-			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
-			return xfs_alert_fsblock_zero(ip, &args->imap);
-		}
-	}
-
 	trace_xfs_iomap_alloc(ip, args->offset, args->length, XFS_DATA_FORK,
 			&args->imap);
 	return xfs_bmbt_to_iomap(ip, args->iomap, &args->imap, args->flags,
 			args->iomap_flags | IOMAP_F_NEW, seq);
-
-out_trans_cancel:
-	if (local_tp) {
-		xfs_trans_cancel(args->tp);
-		args->tp = NULL;
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	}
-	return error;
 }
 
 STATIC bool
-- 
2.55.0

