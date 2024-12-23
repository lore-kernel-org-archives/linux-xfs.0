Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16F61BEF82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989908; cv=none; b=ovlZP6jFF4y/JZwZgMuLEHMcT2Epedb+E3Fs4CiDIklrjtOBXZv1iWaGeokvB2dkjcBRvWll/qPCrIkw08nFu/2bWMk/QtyUvVrML+7gbHCETNpLjEuzSc8YLDdLl4qdbFXXpdi5oCX+fTP81+Qsf4Td0KlM6/EBvLIaUUG03Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989908; c=relaxed/simple;
	bh=7co+fkSe+54gIFOOWuPLxmv5igeN9Lag1EQUdVzZe2k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bd6nfelF/H43uATldYf+iCJlsjDtbW373Ac0mVhOHdd61TRcLY2tLGvgrBWVVnTt8kvTJi6KXLitLHa2EZthxbX+grsN1YQz4v3siZexrEzG8zu20uEyRq27T3Pappit2XjW/Fte0htzFZ65P5pVzwnOkdFY/v8lSXW6K25NYbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDbowzKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDbowzKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28269C4CED6;
	Mon, 23 Dec 2024 21:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989906;
	bh=7co+fkSe+54gIFOOWuPLxmv5igeN9Lag1EQUdVzZe2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IDbowzKnSnX93TLs/7rek8hkEYM6bx9fU4JXHin333YxK4lLz8SFPz+Rqjm+aHt7n
	 TIC8QHPnL8SQwowgvUiVZEP3m5EOaICqB+zqjJVka+En6gCFA5NRefozXKiO39kD+A
	 O5EJdo6TcIB5yV/GP2aUhhnsh85Riqa+9QbzNu1LO1cRDXXUyqHqGHxmVKJ1r7Vj4b
	 8+V5ZE+uKPS0VSclEkqUY8uPazZVhRT1CLjltkRyqcToWKTUWUl98MI1+oVOhTBjUn
	 UI2zSUxBN4MT1d9EC/vZqStUK2dbq8aFWCRsODemdLgdCPNsYzgPCqvll/Xq8oYGgI
	 KcWJk54k03JeQ==
Date: Mon, 23 Dec 2024 13:38:25 -0800
Subject: [PATCH 05/36] xfs: pass a pag to xfs_difree_inode_chunk
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940024.2293042.16659705325766468185.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 67ce5ba575354da1542e0579fb8c7a871cbf57b3

We'll want to use more than just the agno field in a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ialloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 43af698fa90903..10d88eb0b5bc32 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1969,10 +1969,11 @@ xfs_dialloc(
 static int
 xfs_difree_inode_chunk(
 	struct xfs_trans		*tp,
-	xfs_agnumber_t			agno,
+	struct xfs_perag		*pag,
 	struct xfs_inobt_rec_incore	*rec)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_agnumber_t			agno = pag->pag_agno;
 	xfs_agblock_t			sagbno = XFS_AGINO_TO_AGBNO(mp,
 							rec->ir_startino);
 	int				startidx, endidx;
@@ -2143,7 +2144,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		error = xfs_difree_inode_chunk(tp, pag->pag_agno, &rec);
+		error = xfs_difree_inode_chunk(tp, pag, &rec);
 		if (error)
 			goto error0;
 	} else {

