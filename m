Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23F965190
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389627; cv=none; b=m3SenJofobOl+pS5LYm6YoSyHtiYDp3RXP77P0pnJx3Tv40dc9jR6pPfePKqDtUloUlL6xuIYJbDy42LDKK/M/TwkiOvRncCHBzFkSdv/5dhKYkWdV69KzmyjlUX2gUh0NXxlIj1WCUEf4oa0OG5JkoUr63m9bbBm+FW0gXLv0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389627; c=relaxed/simple;
	bh=27V6PTV3RWC6h4hww+UUo6TGzE+hRl4RDX4UagIPotY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sVlBXguYJrDp9OvTsw0rFzFKZcu4lUS60BD5iGbnjVn6th8E9qsnCVLW8OKMCVS5xZ7dt4VohxHmCrRZYeftbPoPFi+7cBg2U2AVNkwjkkHZqYs/31k2Aappf0HdeF70mDo90yFqrc10L+mfs+bxwrxXuH4ab5xTaEc8+mYYrIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWmV91iG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWmV91iG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA1AC072AA;
	Wed, 17 Apr 2024 21:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389627;
	bh=27V6PTV3RWC6h4hww+UUo6TGzE+hRl4RDX4UagIPotY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YWmV91iGRk8QA1+wMxo7LO062bybEIVYOUDPNbMzvLtVEJW2ioCd7UYVtIBGGKj/h
	 wnjx7kITDUSQ1nkYwRL5nLfpgZ69tj3Nsq7XS2zfOjXsA/2pX8OJdbdJl1hR7tIU5A
	 8SUFxXoL5Eu10K1t5NcsDg0DCaQ0b76IguIA2VpqPgJrxdhsf2y51dN1PPXLJ2Ysp1
	 lrnqaqn4+WTgJANjJSvDrvhF5V3is5EV9IT+givhqyQhRIyERWidJv2q9rTbvzDh4n
	 thZd7au148cAlZmKyoXKRYkXlYleqs1b5SMhfA09ihZBaPLMToQXpBvrXGPLEmf7To
	 aiamSc5DvT0IQ==
Date: Wed, 17 Apr 2024 14:33:46 -0700
Subject: [PATCH 46/67] xfs: remove the xfs_alloc_arg argument to
 xfs_bmap_btalloc_accounting
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843030.1853449.16559372308841894998.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_bmap.c |   19 +++++++++----------
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

