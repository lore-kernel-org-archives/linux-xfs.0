Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7D6153823
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804018; cv=none; b=p8R6u2E9Mhv21byZjjOeJR9Ol5wawXsCA2H7UrUYljo3GRghQiflZe/cqDPS+O0DwJ1Bfx7gsBplTaUWRli6vHgK7qVK+58rWQFeNBaR1QTWL0zkQvXVbI/PvHspD+fgmSnbK9f2fA+NPxNPc+r1ZNLe0jD7XObqeJT/1qwIJBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804018; c=relaxed/simple;
	bh=j0kDHaFOc1jHzTMt4bfQ8fY7fCmtKRZgXyhQ47lLlrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFyWAdkMYujJqdSqpo1iXszuFwqf6lU2PK6p5KsW5/ysl5d68OfOx+6uIlgWVekqnWvtSiAzf2s38uIyDYAM/LX4Rt6uHeuXxrM2PpMJEfv3Qe6BBqEtHa8D0JH80T3h35JPVn7f5lykVsaSGvJHscayMgzeGpI57Py2zSdxNdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LfiEOv+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LfiEOv+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2EEC32786;
	Mon, 22 Apr 2024 16:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804017;
	bh=j0kDHaFOc1jHzTMt4bfQ8fY7fCmtKRZgXyhQ47lLlrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfiEOv+/VHDQ0SW79Qnk25ggoozSVxrbmu+FeNp12HTHSWvPgrBa0HtaWk+DWvrgt
	 dfNVwdbWsXCeRmFwTkzipqld+a+lyWHnJkov9yI74BbtA6pDUgnWIQJeqtwwm6sjIx
	 YpCEyHuO5wi47PP7ZKqLzG3STh4rfGuan5QL4P3icvoVx2865d8E7wfyV1+QHWxKJQ
	 XjSODn9qh7oYMc6rTqtsb46nKzg66Zw3eedxZm2v+2KUle6Jc5GGKw+vv1clIibgaz
	 bVsgPoHrRqJXfQWm9zri0zFgz0388bNpFLQtx1vaxsLdX9zYP1T5nLw+uVVvBVXGza
	 T4amcSBVIZaog==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 46/67] xfs: remove the xfs_alloc_arg argument to xfs_bmap_btalloc_accounting
Date: Mon, 22 Apr 2024 18:26:08 +0200
Message-ID: <20240422163832.858420-48-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: eef519d746bbfb90cbad4077c2d39d7a359c3282

xfs_bmap_btalloc_accounting only uses the len field from args, but that
has just been propagated to ap->length field by the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3520235b5..ad058bb12 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3259,8 +3259,7 @@ xfs_bmap_btalloc_select_lengths(
 /* Update all inode and quota accounting for the allocation we just did. */
 static void
 xfs_bmap_btalloc_accounting(
-	struct xfs_bmalloca	*ap,
-	struct xfs_alloc_arg	*args)
+	struct xfs_bmalloca	*ap)
 {
 	if (ap->flags & XFS_BMAPI_COWFORK) {
 		/*
@@ -3273,7 +3272,7 @@ xfs_bmap_btalloc_accounting(
 		 * yet.
 		 */
 		if (ap->wasdel) {
-			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
+			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
 			return;
 		}
 
@@ -3285,22 +3284,22 @@ xfs_bmap_btalloc_accounting(
 		 * This essentially transfers the transaction quota reservation
 		 * to that of a delalloc extent.
 		 */
-		ap->ip->i_delayed_blks += args->len;
+		ap->ip->i_delayed_blks += ap->length;
 		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
-				-(long)args->len);
+				-(long)ap->length);
 		return;
 	}
 
 	/* data/attr fork only */
-	ap->ip->i_nblocks += args->len;
+	ap->ip->i_nblocks += ap->length;
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 	if (ap->wasdel) {
-		ap->ip->i_delayed_blks -= args->len;
-		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)args->len);
+		ap->ip->i_delayed_blks -= ap->length;
+		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
 	}
 	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
 		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
-		args->len);
+		ap->length);
 }
 
 static int
@@ -3374,7 +3373,7 @@ xfs_bmap_process_allocated_extent(
 		ap->offset = orig_offset;
 	else if (ap->offset + ap->length < orig_offset + orig_length)
 		ap->offset = orig_offset + orig_length - ap->length;
-	xfs_bmap_btalloc_accounting(ap, args);
+	xfs_bmap_btalloc_accounting(ap);
 }
 
 #ifdef DEBUG
-- 
2.44.0

