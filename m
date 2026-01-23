Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8231334FF4B;
	Fri, 23 Jan 2026 07:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151850; cv=none; b=tKyWOlXTjxbTMqRzaZjbYj0HR5xe0ZXLUxLjAQf9NTT61xSS83aa97rmUpEljdk5Xk4kiEQ16O+ss+PZSX450gWXPqF/bTtsaveAl0JMAn8VM5KUccQdXmiYtAoznFKZmWGNayY2dv/i8m3UVLHFXOo96cz5tFsm1Kw0wS36hbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151850; c=relaxed/simple;
	bh=zs3AfOieqD73TsMYGjB7bL0fCMg8gowQLKGibPQN26Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H71PrQ3N8sFTc2i9W4/q3pffcjgbjsQdw3ibnmt4gv+EwgPR8PlntleEtyUWVvD7kntlgLfiupSbfT5F5edNj8l7Gs0UNEsgsNRS2mA5xapVkx+aYFuVkNJcT4O44BwEBC5Gq/uNVZJKkSMKX0+1xCqqUZOMT6RU2AThhohbDqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zfwrx5Z0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zfwrx5Z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E333C4CEF1;
	Fri, 23 Jan 2026 07:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151849;
	bh=zs3AfOieqD73TsMYGjB7bL0fCMg8gowQLKGibPQN26Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zfwrx5Z0WDwT6fPgJT4KPvf6A1NLqlVYF034yNcnQKMGIO990sFDYfflRuH1YuwRH
	 28FvDtkWFeF3/pShy9QyrHXYPEidDeaG1f6gvKYcP9dov5cbpXu6LRcuSDuMR1k0Ss
	 dfHKvKskKigl66Qk2ro2erv1JuT7gxc4gp6Q+Ows0vOLSeLe0VhlfuuP/+QQNvaEsM
	 //WRgsG7Dz5BG6LZUWA9w+QKvD0JJtx/txJ3k2udZh6TH3KHxaUfMeQf/sgs1rci1A
	 YkG0WCbk/yPiaKKctlqgTDND3Z3tUUznlOLnFu7Jaq07KSb/3Ux3Uiv35rBVCF8h5Q
	 TWtsHOw/2xFqA==
Date: Thu, 22 Jan 2026 23:04:08 -0800
Subject: [PATCH 4/5] xfs: fix UAF in xchk_btree_check_block_owner
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, r772577952@gmail.com, stable@vger.kernel.org,
 linux-xfs@vger.kernel.org, r772577952@gmail.com, hch@lst.de
Message-ID: <176915153782.1677852.511726226065469460.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs>
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We cannot dereference bs->cur when trying to determine if bs->cur
aliases bs->sc->sa.{bno,rmap}_cur after the latter has been freed.
Fix this by sampling before type before any freeing could happen.
The correct temporal ordering was broken when we removed xfs_btnum_t.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.9
Fixes: ec793e690f801d ("xfs: remove xfs_btnum_t")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/btree.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index c440f2eb4d1a44..b497f6a474c778 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -372,12 +372,15 @@ xchk_btree_check_block_owner(
 {
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
+	bool			is_bnobt, is_rmapbt;
 	bool			init_sa;
 	int			error = 0;
 
 	if (!bs->cur)
 		return 0;
 
+	is_bnobt = xfs_btree_is_bno(bs->cur->bc_ops);
+	is_rmapbt = xfs_btree_is_rmap(bs->cur->bc_ops);
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
 	agbno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
 
@@ -400,11 +403,11 @@ xchk_btree_check_block_owner(
 	 * have to nullify it (to shut down further block owner checks) if
 	 * self-xref encounters problems.
 	 */
-	if (!bs->sc->sa.bno_cur && xfs_btree_is_bno(bs->cur->bc_ops))
+	if (!bs->sc->sa.bno_cur && is_bnobt)
 		bs->cur = NULL;
 
 	xchk_xref_is_only_owned_by(bs->sc, agbno, 1, bs->oinfo);
-	if (!bs->sc->sa.rmap_cur && xfs_btree_is_rmap(bs->cur->bc_ops))
+	if (!bs->sc->sa.rmap_cur && is_rmapbt)
 		bs->cur = NULL;
 
 out_free:

