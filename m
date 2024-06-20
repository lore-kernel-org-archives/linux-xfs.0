Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CFF143865
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924946; cv=none; b=M5dmeCImjEoDXYYErGnMpzMNxfY1ZrBR+zHCXFTAt2B5M1LNY24RzmV4pVNyIHl+kKuGYUQbFUgETvEU7eMbeoPrri8yJ3uWuvTqx0k+OPz14PyPsOxxbPJZJq7FkdZqx+1XfyzELbgjMZJ6pUnsoMv9InCLuaJI8ug8fth/HSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924946; c=relaxed/simple;
	bh=G3Yg58hE2Wm2bF31wFksPDVdg5cCiKM25HqvaYT6oBI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HOGsKgIB0jIteVm2TX2BULEZLxXpOQBVo1C/eShhwG1TtqDgD1E/W98FcXZ+Gpsjmu1sOhRaKvpdIxVpO+Zt2fIz102YsmnuOVC3QXBCwr7jVQJVdXXNqS6o1lcjz6ho0hpXiHdwkbuUlTFnCQPxLb1ALbi7bEgUR3ZFup7ksvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5500klR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5500klR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA3AC2BD10;
	Thu, 20 Jun 2024 23:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924945;
	bh=G3Yg58hE2Wm2bF31wFksPDVdg5cCiKM25HqvaYT6oBI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h5500klRdiHHQ0yKG0qoLBr/O8nuM6RJ5/D+U9SywXjDkldTGc9IrCqLEMlNqLGtg
	 wArgiYjR2mjAX34xBt4Tj6X2sdj2XQMo3UmbfvvlVoUrzRHTPh8z438reeP3vgvFld
	 LfDRwrBKh4vcl4mTsU5tdkJwj8mCndp5d/tJkGvIelNcu3yq5KaHVUF9Y56cfVZF+x
	 FThJDGUwAzcW0IrG5D3FxRK9FqiexsanNLOd35gODD0VANqHHBfnzFeiRlp/wKeGUd
	 PDQrZwSkM2olnchi9IzmMs/Ps9siNFOnZI7QtXjwws31MjXQ60UJFcjMB9EbhvODw/
	 ENwZUcPbWLaMA==
Date: Thu, 20 Jun 2024 16:09:05 -0700
Subject: [PATCH 8/9] xfs: simplify usage of the rcur local variable in
 xfs_rmap_finish_one
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419370.3184396.10850586111347123188.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
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

Only update rcur when we know the final *pcur value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
[djwong: don't leave the caller with a dangling ref]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 0ee97f1698e9d..a5a0fa6a5b5dc 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2570,7 +2570,7 @@ xfs_rmap_finish_one(
 {
 	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_btree_cur		*rcur;
+	struct xfs_btree_cur		*rcur = *pcur;
 	struct xfs_buf			*agbp = NULL;
 	xfs_agblock_t			bno;
 	bool				unwritten;
@@ -2585,7 +2585,6 @@ xfs_rmap_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
@@ -2607,9 +2606,8 @@ xfs_rmap_finish_one(
 			return -EFSCORRUPTED;
 		}
 
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
+		*pcur = rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
 	}
-	*pcur = rcur;
 
 	xfs_rmap_ino_owner(&oinfo, ri->ri_owner, ri->ri_whichfork,
 			ri->ri_bmap.br_startoff);

