Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E20135A46
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441960; cv=none; b=ARNlYqNuaADKIWcZQHscG5qJircC8decHdv5yuC709KlWko4S7p/Kd3F+2KKqH0l/JxznIiXa5T5xpsTYi1AilyypUOPKSRpWt0AbDpWfseDv9pKjw1Xjkgr7bqpOen/glIynjA+GT1oaxTYt6x6E3P5RZqHsDRon94zoG6rBWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441960; c=relaxed/simple;
	bh=deXFYBNw64FmcghR710weYfXOrxF9GcJU73HjmIZK+k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vql/KjC+bh0djhH/TL7FbIVPdNGltQPtkJLVVDI6K8AlUTebx3C7nd4/fxpYjvNJRoRO8Gbx0CUf24rFinp6LKGtZs/mBXSmUSa7q12k2m5lspGfF/Rop/vmn3NoWWBh+wSpCZRNEsugFlzns8HjRm4kMFBus4msyDkYxSCobWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WriEIH0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WriEIH0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDE7C2BD10;
	Mon,  3 Jun 2024 19:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441959;
	bh=deXFYBNw64FmcghR710weYfXOrxF9GcJU73HjmIZK+k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WriEIH0yeoYIj09Fmrz2EBeaCFhVUHHeBagSlao8gf1Y5mciJCqYqx8yjS/MaCG7L
	 KfdzRA4JferC6NLW3KnFbGmo21IZgnHkSBW2UtYpq9LUDkWFVpQXSNHHWSHQDDVitW
	 QQMpN9dDHNU+NwVfsTJWDC1aF/ug0RD6zk4wj/VTTpchgFR650pslLiHdu4SQ99rwL
	 Xw9kRvPor4vopcPBTqzxs1iGIw75oQupQ/wk5OC54CLQhDpmxLl7KD26kzo+UKXwR7
	 SN2xMT80+nqw2Z5qCWImreNgJzlGGaMYkaxjLJNq8zBBweluhMtnYK2yentYckIaUC
	 JtQnBmjR3mGTA==
Date: Mon, 03 Jun 2024 12:12:38 -0700
Subject: [PATCH 079/111] xfs: misc cleanups for __xfs_btree_check_sblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040557.1443973.10015465885425498687.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 43be09192ce1f3cf9c3d2073e822a1d0a42fe5b2

Remove the local crc variable that is only used once and remove the bp
NULL checking as it can't ever be NULL for short form blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 4fb167f57..359125a21 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -170,15 +170,13 @@ __xfs_btree_check_sblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_perag	*pag = cur->bc_ag.pag;
-	bool			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
-	xfs_agblock_t		agbno = NULLAGBLOCK;
+	xfs_agblock_t		agbno;
 
-	if (crc) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
-		if (block->bb_u.s.bb_blkno !=
-		    cpu_to_be64(bp ? xfs_buf_daddr(bp) : XFS_BUF_DADDR_NULL))
+		if (block->bb_u.s.bb_blkno != cpu_to_be64(xfs_buf_daddr(bp)))
 			return __this_address;
 	}
 
@@ -190,9 +188,7 @@ __xfs_btree_check_sblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
-	if (bp)
-		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
-
+	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_sblock_siblings(pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)

