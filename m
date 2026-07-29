Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B643744C667
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319626; cv=none; b=He9+BknyVnSKas96OUVvL6pAxqceJPPLztEpG13z/7y6csmrS7xzilJ0tMV4TXxWIyiAjX6p55tgSELIgbeYsP0LgMszrtd/SbkVRNdaJoJLPjnNnicGl+wYRlXxdVu/2F5lyW//j5nFqbrylc8oTwdoN3ql/nLpDwrvfK8qNOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319626; c=relaxed/simple;
	bh=lDcIiRTACsDk9Q9x37esvPAvWDRvZwWxigt+B1ZVDvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBTfDhNIWZo6JNey7qEjvO9awuHd79tEl9MC3cXLac9vsrQWeY7l7QpZnsLVy4dq8CtVp9hF785vvRgjsTzavIKe9e8xtS+BCbdOC7PBWIgZWn2l9UAKXiEENNxJKCRejiJwXGZj4uM3Un69qP0QsFk6vypAk1AxEKw5wHpQvmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMncu/mA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMncu/mA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC201F00A3A;
	Wed, 29 Jul 2026 10:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319625;
	bh=EIlMsgL9Oc2lFVOPWzDXgPCsJmXqMoAZNILwXIZDfrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMncu/mAtoCgFWEuRxv8Fz19rSzURahcOvZNtSbp86RLrMyiSe8opFTME5hz2Z6zT
	 MVMlVQnWpF2xVtAG413x1MbSHxHNQ5buMW0yujwcf7CgWiWl+qQzLqV98gVTLzqYyC
	 nj5m8ixiTqc77vpLN8WMwlz4EECiZAqSpVMbXn0Jg4/K5A+NEKdsvuKSLeVtzuwUZJ
	 7ugJKduWgthVWGNSaLg+f9XrrPnZNyKNgJyatPvPlGvLtdoKUBftv+twig+mF2Bvin
	 w2B5I6dsxqlnVBrDzQK2dMelkVqxxyNTjYgkhq78XRxq8uQaszF4QzIV6Vda78SdgT
	 L5UeiSqszxCVA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 26/33] xfs: make xfs_iomap_write_direct fill in the iomap directly
Date: Wed, 29 Jul 2026 20:02:10 +1000
Message-ID: <20260729100629.1943710-27-dgc@kernel.org>
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

Move the xfs_bmbt_to_iomap() call and the xfs_iomap_alloc tracing
into xfs_iomap_write_direct() so that callers do not need to
convert the returned imap to an iomap themselves.

Both callers performed the same conversion after the function
returned. By moving this inside the function, the callers are
simplified and the iomap sequence cookie is correctly captured
after the allocation completes under the ILOCK.

Add iomap, iomap_flags, offset and length parameters so the
function has everything it needs for tracing and the iomap
conversion. Replace the seq output parameter with an internal
variable.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 46 ++++++++++++++++++++++------------------------
 fs/xfs/xfs_iomap.h |  3 ++-
 fs/xfs/xfs_pnfs.c  |  9 ++++-----
 3 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f3e4f243e877..347a451ec7cb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -273,7 +273,10 @@ xfs_iomap_write_direct(
 	xfs_fileoff_t		count_fsb,
 	unsigned int		flags,
 	struct xfs_bmbt_irec	*imap,
-	u64			*seq)
+	loff_t			offset,
+	loff_t			length,
+	struct iomap		*iomap,
+	u16			iomap_flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*local_tp = NULL;
@@ -284,6 +287,7 @@ xfs_iomap_write_direct(
 	int			error;
 	int			bmapi_flags = XFS_BMAPI_PREALLOC;
 	int			nr_exts = XFS_IEXT_ADD_NOSPLIT_CNT;
+	u64			seq;
 
 	ASSERT(count_fsb > 0);
 
@@ -353,27 +357,26 @@ xfs_iomap_write_direct(
 	if (error)
 		goto out_trans_cancel;
 
-	if (!local_tp)
-		return 0;
-
-	error = xfs_trans_commit(tp);
-	if (error)
-		goto out_unlock;
-
-	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
-		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
-		error = xfs_alert_fsblock_zero(ip, imap);
+	seq = xfs_iomap_inode_sequence(ip, iomap_flags);
+	if (local_tp) {
+		error = xfs_trans_commit(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		if (error)
+			return error;
+		if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock))) {
+			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
+			return xfs_alert_fsblock_zero(ip, imap);
+		}
 	}
 
-out_unlock:
-	*seq = xfs_iomap_inode_sequence(ip, 0);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
+	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, imap);
+	return xfs_bmbt_to_iomap(ip, iomap, imap, flags,
+			iomap_flags | IOMAP_F_NEW, seq);
 
 out_trans_cancel:
 	if (local_tp) {
 		xfs_trans_cancel(tp);
-		goto out_unlock;
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 	return error;
 }
@@ -1169,14 +1172,9 @@ xfs_direct_write_iomap_begin(
 		end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
 	xfs_iunlock(ip, lockmode);
 
-	error = xfs_iomap_write_direct(NULL, ip, offset_fsb,
-			end_fsb - offset_fsb, flags, &imap, &seq);
-	if (error)
-		return error;
-
-	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
-				 iomap_flags | IOMAP_F_NEW, seq);
+	return xfs_iomap_write_direct(NULL, ip, offset_fsb,
+			end_fsb - offset_fsb, flags, &imap,
+			offset, length, iomap, iomap_flags);
 
 out_unlock:
 	if (lockmode)
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 937a61c7a610..c883a7175cd0 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -15,7 +15,8 @@ struct xfs_zone_alloc_ctx;
 int xfs_iomap_write_direct(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t offset_fsb, xfs_fileoff_t count_fsb,
 		unsigned int flags, struct xfs_bmbt_irec *imap,
-		u64 *sequence);
+		loff_t offset, loff_t length, struct iomap *iomap,
+		u16 iomap_flags);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 		xfs_fileoff_t end_fsb);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 442564967b39..f9c0e748448e 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -190,8 +190,6 @@ xfs_fs_map_blocks(
 		xfs_iunlock(ip, lock_flags);
 		goto out_unlock;
 	}
-	seq = xfs_iomap_inode_sequence(ip, 0);
-
 	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
 
 	if (write && (!nimaps || imap.br_startblock == HOLESTARTBLOCK)) {
@@ -203,7 +201,8 @@ xfs_fs_map_blocks(
 		xfs_iunlock(ip, lock_flags);
 
 		error = xfs_iomap_write_direct(NULL, ip, offset_fsb,
-				end_fsb - offset_fsb, 0, &imap, &seq);
+				end_fsb - offset_fsb, 0, &imap,
+				offset, length, iomap, 0);
 		if (error)
 			goto out_unlock;
 
@@ -219,11 +218,11 @@ xfs_fs_map_blocks(
 			goto out_unlock;
 
 	} else {
+		seq = xfs_iomap_inode_sequence(ip, 0);
 		xfs_iunlock(ip, lock_flags);
+		error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0, seq);
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0, seq);
 	*device_generation = mp->m_generation;
 	return error;
 out_unlock:
-- 
2.55.0

