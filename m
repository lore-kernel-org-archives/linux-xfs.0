Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4065A44D020
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319635; cv=none; b=qil3N87YZr2edeE0FPPiBoh3hKQ6KRgOXXAQYFo4uKtp+KTwrT7ShNh7KNlSnfBVbKK/jKjaFYlPZX5MybksMxYBwt4lizmdNsNeV9B1DRlEuSBKJBTa1tE4TXgLEzlvBzIvr2lUTQhv5dsxE0xroV8VFGIgw1DQfMa6n4c3OUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319635; c=relaxed/simple;
	bh=q4EEquVeL/lroanw37YE8M6Ta6tlxmJQmkS+69KH/Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tttaywq0g2Adr/4qYoD006aZ16hPgPSIoKwUCK1GEV5+vybLndIV6sa677QBDY17Lg2zP925L7SFviudBhj5GDzR6xczKJRqcdxqHtSo6yzbNNN44I4zOZQXK40FDgsFBV7bV4qKdz6JNkXbqodVXDaQw6uVHlsI+nxSleB3z5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOqayHYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOqayHYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745481F000E9;
	Wed, 29 Jul 2026 10:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319634;
	bh=rfQfgwXVYsLl/73nH7P40gS/Bqqnb8XQ/q2UCBBRB2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BOqayHYQavEcPgF4XOsYADhfO9nSn6zBDtpCk7jxenFSnHYrvZp7fBQ7nzJGN/QST
	 v1Htz7BPE2i2MnrlvmNxieE0wrCUC4DoJNDzDcqUYCYjBO3zJhh57mkv2cOg2RQ/qf
	 9y+nkcJEadBObvK9B45QxL9xzCatA3OhNIszOPutPUUsOg9EycYaoiv2Vc1xx0lYEW
	 yRjJt2QgeqrceQIjN/+7Ng0cBuyrzleEEEri1mWkUgszsTDHJMdYXyM0g9kx0q6Agb
	 4tk31cG8QY6exp3HICstmxW/giHQk2QbIRDl/O9UjCzy5sW75bgEkOk9f9rc5itxJ1
	 8QZr/7UUdpwhg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 33/33] xfs: remove dead internal transaction path from xfs_iomap_write_direct
Date: Wed, 29 Jul 2026 20:02:17 +1000
Message-ID: <20260729100629.1943710-34-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
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

