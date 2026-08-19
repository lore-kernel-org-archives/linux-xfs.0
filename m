Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BC72641CA
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098513; cv=none; b=YYMqzCBZJhLQTebZgNE6liZawdpMGpP/L7Kys9B4ZgYgfvHHK/kpRGIvHw1phFCMbwmFKPpzNWVYb5THevO2hMm9D6eF5GesoWVN9S+EJXjhy/yPvH2jyPEgytIpLWjG0niHKN5Yi/bbEZv15j/7Ca2fuksHo00ejdt+1M0WXZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098513; c=relaxed/simple;
	bh=JegfE6/EZe5RR1aFHPaWxBt2Xfgvcv2AZfpAYzO45Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZNigPWbp8/AEB3RywIv3OTj/nvJ5Tsbw3WxVCXzS/gNpmZkplOsW41VMbLa0ghK1rrFM9wxFBFWpgzlDt5DIt+vPhufRrHtpoHtSlO7ock5lBWUWBhozUmyuwRYL4xaWs1aeXZ6xrmEhKIyUja2douzN/WRtuoYJnpnkgqxJw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfwrQJFM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfwrQJFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341B01F000E9;
	Wed, 19 Aug 2026 00:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098512;
	bh=765c22fYlSKzAigNnmQDb3Q/nvMQxLKctqXNHCoelB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfwrQJFMj0cJnU9EJJ4IxE6nqSdfFmx5lFJfN9LG283fxBuOubP6C6SqqsTiagrjG
	 99+ND8u145oA7/N88NbS/WRBTzovBianXmbk4eeuoswqMUPwD8LDypFgEwBIEJIoD9
	 zIiZNXPM7oSrCxPoq3E3NxNUu+/rOpzQoiitKGybdoWPG8/sB7PVgqnvwjZwSv95+L
	 o6XnARTN+FyoUvPJrDkkTUkQnRzlGiM+05mF/Mih5M/0+Xji2QLkeZxB7Cp/+QVQqN
	 VGPWmcL7WTRueWZlULQrrU3znpIvjjJAr05cDxp5iApEBdIatJfCUDm3ATNO/CoNjR
	 awUQRSPqcVlLw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 19/38] xfs: remove dead internal transaction allocation from xfs_reflink_fill_delalloc
Date: Wed, 19 Aug 2026 10:12:22 +1000
Message-ID: <20260819001442.1451892-20-dgc@kernel.org>
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

