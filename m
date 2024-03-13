Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDF0BA2D
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295502; cv=none; b=PpDwxpWJPWPPc1Ozj7T5K8dWeiXTgJpeOhCd+S4wsQEQkUJspL4R5b/IJSiE/V3fvW5apBSQmBS8Gtzqj4z0bcq22C439NsMNebONxs9Vgcc1ILA6QApDi8Bx75bjcn4Txi7ZvYP0cLNGLWa4Z5HzRmP+gHL2DMiXJPROD2RR90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295502; c=relaxed/simple;
	bh=N67Ef6epEgg6F7p1q8Uk6ObyAf+gHU0fOa4NCjoKago=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TYWtfqqDWYt8KRgUio5CiWikUN3S/+tq6zYi8EIE+izJa/3wvgfRdvPplquDuw8eeUOfrlxHh69id+W9HslVfvq8RaLhmrByCDoTXEWtsg1ePZmspNY5A1Mp9+hfd0JLccdz4hH8f0CTaVi81gM1GMArXjQnKTdA3GW41Fj3dLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=moCsqa6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="moCsqa6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9A4C433C7;
	Wed, 13 Mar 2024 02:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295502;
	bh=N67Ef6epEgg6F7p1q8Uk6ObyAf+gHU0fOa4NCjoKago=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=moCsqa6yddVSLcbupWucwmgWmXyAJtRfYLCPd3EikyMv4u1gV0EhPG1iDuvauu/Q/
	 NPDbsTQFjKqL3QgDi9cCISMhno9cXPv/RVsxVOAogdtEemP9LLchk77PIkCn0m9U8j
	 XHdhnWirsmZi8smbmLRwyYGKmC3ilkH/AtqF46T69ZeWsLaHU9Ofn392o5TUe+EQxI
	 dUlk1BvbT6x0agT7pyUoY8VKhohSSLHU19iSno5/TgTUhBMafgg/I7QZVJ2i5wVWwy
	 bEVwcAyt4lflRkX4F4pSf98cB2WjZrLyJGEZs1C9vT/y5pKPbB7XPpgGIYRkrxfm7E
	 gW1+oC2lrK4ZA==
Date: Tue, 12 Mar 2024 19:05:01 -0700
Subject: [PATCH 46/67] xfs: remove the xfs_alloc_arg argument to
 xfs_bmap_btalloc_accounting
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431857.2061787.3941433054444287759.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: eef519d746bbfb90cbad4077c2d39d7a359c3282

xfs_bmap_btalloc_accounting only uses the len field from args, but that
has just been propagated to ap->length field by the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3520235b58af..ad058bb126e2 100644
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

