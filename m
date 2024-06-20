Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CF113777F
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924664; cv=none; b=E+xIkYuMtKA8bN2W0v4cENQsO4zaQoP0IAq9M60pc0DRv8AL4TjNdzgzSeJETL+O9kbcSPAieBkEbqARb296WCC8ZGBqM+pULi+fJ04+TKCZT+fWD/WW/FcLq59QTrROxdfKHv7fBBxCn1b12A91eoiw3xfJcg13vaIOuWsfAXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924664; c=relaxed/simple;
	bh=3uv/90NBPGOYh60PeL/bnMAOzUV9APwK5o7t5SORifA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u8caioorfrCYpDtQL0XZMYrkq/IvHRn4E9YxTQRW85bIcQbZ6mo21xl8Pbr9C/WoevsDeseKBSJ9D+AL+jYij9HXrdwugsMitX9D7H+9uKp2oYxNdrJSCubPaKFbqNOBI3BtfjNj1ptDROZUXcfVteeXbY0c0y7UvhDx4QnrB9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uAuDfxlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uAuDfxlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7D7C2BD10;
	Thu, 20 Jun 2024 23:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924664;
	bh=3uv/90NBPGOYh60PeL/bnMAOzUV9APwK5o7t5SORifA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uAuDfxlbkazAZhsKSSj0fUWZzqywFWzp+4zITiL8tedxSB/dlZl4JYOm3748bwJD8
	 z2zgoqTwKATl43eDu0suMQo6nQr0G7UKlemuaBRl4VsVqxtesq14xnEFZ55GQAe5Dq
	 ULdpA6eaG0wYm4tpZSFAViRdWYCAnzOYX9x+B99fP9PpCmzRVxFjdykrtPJwAxI9X/
	 gwGePqwkxqQvcRkOgmgxLtJReXyrREKwwLLkOXdUZAXzq+upgfLONWC63RkxtL+Uxk
	 qa0zWjEIKn04QQ6PQ9jUq1ogH7puI0pWIYlC5eRjedCBNkBDje4YDZPSjSHOOaLDww
	 kjiTRXA+4USog==
Date: Thu, 20 Jun 2024 16:04:23 -0700
Subject: [PATCH 23/24] xfs: get rid of trivial rename helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418295.3183075.6650817239063763087.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Get rid of the largely pointless xfs_cross_rename and xfs_finish_rename
now that we've refactored its parent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   77 +++++++++-------------------------------------------
 1 file changed, 14 insertions(+), 63 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d79a191ed6068..d73e6d843f85d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2102,63 +2102,6 @@ xfs_sort_inodes(
 	}
 }
 
-static int
-xfs_finish_rename(
-	struct xfs_trans	*tp)
-{
-	/*
-	 * If this is a synchronous mount, make sure that the rename transaction
-	 * goes to disk before returning to the user.
-	 */
-	if (xfs_has_wsync(tp->t_mountp) || xfs_has_dirsync(tp->t_mountp))
-		xfs_trans_set_sync(tp);
-
-	return xfs_trans_commit(tp);
-}
-
-/*
- * xfs_cross_rename()
- *
- * responsible for handling RENAME_EXCHANGE flag in renameat2() syscall
- */
-STATIC int
-xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_parent_args	*ip1_ppargs,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	struct xfs_parent_args	*ip2_ppargs,
-	int			spaceres)
-{
-	struct xfs_dir_update	du1 = {
-		.dp		= dp1,
-		.name		= name1,
-		.ip		= ip1,
-		.ppargs		= ip1_ppargs,
-	};
-	struct xfs_dir_update	du2 = {
-		.dp		= dp2,
-		.name		= name2,
-		.ip		= ip2,
-		.ppargs		= ip2_ppargs,
-	};
-	int			error;
-
-	error = xfs_dir_exchange_children(tp, &du1, &du2, spaceres);
-	if (error)
-		goto out_trans_abort;
-
-	return xfs_finish_rename(tp);
-
-out_trans_abort:
-	xfs_trans_cancel(tp);
-	return error;
-}
-
 /*
  * xfs_rename_alloc_whiteout()
  *
@@ -2351,11 +2294,11 @@ xfs_rename(
 
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE) {
-		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
-				du_src.ppargs, target_dp, target_name,
-				target_ip, du_tgt.ppargs, spaceres);
-		nospace_error = 0;
-		goto out_unlock;
+		error = xfs_dir_exchange_children(tp, &du_src, &du_tgt,
+				spaceres);
+		if (error)
+			goto out_trans_cancel;
+		goto out_commit;
 	}
 
 	/*
@@ -2433,7 +2376,15 @@ xfs_rename(
 		VFS_I(du_wip.ip)->i_state &= ~I_LINKABLE;
 	}
 
-	error = xfs_finish_rename(tp);
+out_commit:
+	/*
+	 * If this is a synchronous mount, make sure that the rename
+	 * transaction goes to disk before returning to the user.
+	 */
+	if (xfs_has_wsync(tp->t_mountp) || xfs_has_dirsync(tp->t_mountp))
+		xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp);
 	nospace_error = 0;
 	goto out_unlock;
 

