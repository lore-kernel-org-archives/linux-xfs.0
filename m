Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E44344BCA5
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319612; cv=none; b=Akz/PbQ9CBcbQ++vMA3P+EHGS1dR3Yb0bSsaBN2d/PNGECdvgBWdox5s6IX+SBZY2lVanBIRWCFcddJcT2WGwLF2yt4q9UpNHevElQSoMWG+wACNWUiUvauT0ZDU2SQhnBDncZPKJjAEjQprUxu9C22GtdiUb3uccUhu0JCGOoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319612; c=relaxed/simple;
	bh=JegfE6/EZe5RR1aFHPaWxBt2Xfgvcv2AZfpAYzO45Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgqkFGUV734f2Wfe5UwLz5YxEbCqL/emC5wQIiSowNVxItgwfgt2SD9UGMsV5bCRloUf07FMFL9fviiz/SBvnZeLmvTCrCaQjPr4hMxsUfpIo3ZkmSjLLfyoFyYaXpbfwOs7F7TFTw50LH1h3JwcFuwAY4/Jj7yrX5dLLv31/uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EslfAxo4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EslfAxo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC33F1F00A3A;
	Wed, 29 Jul 2026 10:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319611;
	bh=765c22fYlSKzAigNnmQDb3Q/nvMQxLKctqXNHCoelB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EslfAxo4OGcXMt6YNKYOjWn50Kn1588t4A97SoL1z1OZ3awIO01pD18lmuqMKgPdM
	 dIrmaV7a2BmEUbFL1KTC0h0PiE42VvP5GxkhTAkH9cnpjMZ3nebVE+zrTMJVcjl/BA
	 XBItoJfRpdn4NfaRCCF7i0ylD54XvBj8LdAyGeTnd39AeCH03crZypSTdqJjXghcn2
	 pmNuqfKr5c3TRB/ZxIDuwodal1FzVKC1pEaBkOUXYuF0mgOoEeFWjInKOPu1yZSPi8
	 wF/a88ZKYgK0fD29QZmFZhT/Q39Sx/S5X1gPn0BF13l/cl1KNSmCd3u4TQ6cO+kXR4
	 egMY4VAWcoFJg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 14/33] xfs: remove dead internal transaction allocation from xfs_reflink_fill_delalloc
Date: Wed, 29 Jul 2026 20:01:58 +1000
Message-ID: <20260729100629.1943710-15-dgc@kernel.org>
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

Now that xfs_reflink_fill_delalloc() is always called with a valid
caller-supplied transaction via the -EAGAIN retry mechanism, remove
the dead internal transaction allocation path.

This removes the ILOCK drop/reacquire cycle that was previously
needed to allocate a transaction. The delalloc conversion loop runs
entirely under the caller's ILOCK hold using rolling transactions,
eliminating the window where racing DIO writes could cause stale
extent state.

The lockmode parameter is also removed as the function no longer
modifies the lock state.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_reflink.c | 59 ++++++--------------------------------------
 1 file changed, 8 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cc3c1caee2d8..e40f7afc2c7b 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -498,51 +498,20 @@ xfs_reflink_fill_delalloc(
 	struct xfs_bmbt_irec	*imap,
 	struct xfs_bmbt_irec	*cmap,
 	bool			*shared,
-	uint			*lockmode,
 	bool			convert_now)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
 	int			nimaps;
 	int			error;
 	bool			found;
 
-	if (!tp) {
-		unsigned int	seq_before = READ_ONCE(ip->i_df.if_seq);
-
-		xfs_iunlock(ip, *lockmode);
-		*lockmode = 0;
-
-		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, 0, 0,
-				false, &tp);
-		if (error)
-			return error;
-
-		*lockmode = XFS_ILOCK_EXCL;
-
-		/*
-		 * The data fork mapping may have changed while we dropped the
-		 * ILOCK (a racing O_DIRECT writer under IOLOCK_SHARED can
-		 * complete a full CoW cycle including xfs_reflink_end_cow(),
-		 * which remaps this offset and drops the refcount of the old
-		 * shared block).  Re-read it so the shared-status recheck
-		 * below and the caller's in-place iomap both operate on the
-		 * current mapping rather than a stale physical block.
-		 */
-		if (seq_before != READ_ONCE(ip->i_df.if_seq)) {
-			nimaps = 1;
-			error = xfs_bmapi_read(ip, imap->br_startoff,
-					imap->br_blockcount, imap, &nimaps, 0);
-			if (error)
-				goto out_trans_cancel;
-		}
-	}
+	ASSERT(tp);
 
 	do {
 		error = xfs_find_trim_cow_extent(ip, imap, cmap, shared,
 				&found);
 		if (error || !*shared)
-			goto out_trans_cancel;
+			goto out_error;
 
 		if (found)
 			break;
@@ -559,30 +528,18 @@ xfs_reflink_fill_delalloc(
 				XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0,
 				cmap, &nimaps);
 		if (error)
-			goto out_trans_cancel;
+			goto out_error;
 
 		xfs_inode_set_cowblocks_tag(ip);
 
 		error = xfs_defer_finish(&tp);
 		if (error)
-			goto out_trans_cancel;
+			goto out_error;
 	} while (cmap->br_startoff + cmap->br_blockcount <= imap->br_startoff);
 
-	if (*tpp) {
-		*tpp = tp;
-	} else {
-		error = xfs_trans_commit(tp);
-		if (error)
-			return error;
-	}
-
-	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
-
-out_trans_cancel:
-	if (*tpp)
-		*tpp = tp;
-	else
-		xfs_trans_cancel(tp);
+	error = xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
+out_error:
+	*tpp = tp;
 	return error;
 }
 
@@ -633,7 +590,7 @@ xfs_reflink_allocate_cow(
 	if (isnullstartblock(cmap->br_startblock) ||
 	    cmap->br_startblock == DELAYSTARTBLOCK)
 		return xfs_reflink_fill_delalloc(tpp, ip, imap, cmap, shared,
-				lockmode, convert_now);
+				convert_now);
 
 	/* Shouldn't get here. */
 	ASSERT(0);
-- 
2.55.0

