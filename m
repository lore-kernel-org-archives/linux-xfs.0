Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164118564C
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817241; cv=none; b=uLpqskUmXeA+lH1riGjhaBBeiZ5mztRhtd51vRLkzVF0vO0UqMR0unjHmnzDrgu5/iz3+hTxqJTzscKUhtyRkpNuS4Zvi0m+ydjZFvmA2N87Jl/WWvRMjq3M9tyYCptvJxeFzANQT+vZn0YEPMONKALI87+shucRAzZjkWDf8/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817241; c=relaxed/simple;
	bh=VoY908ZMi0f171m78Zgrn+P/tO0WI6479civcrIVJJ8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K6NK6Qfq2AtFnagwj7AEGHOZxw8vpLgwF9JvYhIUOvOk9cax55KDryhFI0OAijf+iwJbx7kWFg0GaPsYEGYsqQzMMvj57miSkua2hhAgk/QztdMRjvNX8YXQOiPyTvin5dvXQ7A5U27uHuqJdIYtLZEP/UAKpLKRrcnlxlT3U5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5+huO2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5+huO2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881EAC433C7;
	Thu,  1 Feb 2024 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817240;
	bh=VoY908ZMi0f171m78Zgrn+P/tO0WI6479civcrIVJJ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L5+huO2HeFmg0UgEaS/kKTQwEc1pzdK8zB8bAZ989eetM9e2qKxBi8uyqunvOZZM5
	 34zirq9KJKAJepVgzq+oM3zhQy1jBbbkNjs/laqJCCVHWfODWheQLyeJj8Zv20xWnC
	 +i6NRH7HxO/E9t2jkHYaX92ILzUV2UVlKMWMK+2RcD3Mwu+anSO5N3g5szWynezYKt
	 fL9FIq79V8w/wS7aIMuwFS0FRR9eNTq8I160OxMjDcVBKA1fJ66Lzx7ZKKXaR9Z7ow
	 Wun1WW1kOJNht5gZUzWGLYkqotrEIN4se/yvs/niaomXkSZ39PwiODJ0+U2uouQf94
	 +mE1DB8E+WqcA==
Date: Thu, 01 Feb 2024 11:54:00 -0800
Subject: [PATCH 05/10] xfs: misc cleanups for __xfs_btree_check_sblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335694.1606142.107334013076983573.stgit@frogsfrogsfrogs>
In-Reply-To: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
References: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
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

Remove the local crc variable that is only used once and remove the bp
NULL checking as it can't ever be NULL for short form blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 1a0816aa50091..255d5437b6e2a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -173,15 +173,13 @@ __xfs_btree_check_sblock(
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
 
@@ -193,9 +191,7 @@ __xfs_btree_check_sblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
-	if (bp)
-		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
-
+	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
 	fa = xfs_btree_check_sblock_siblings(pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)

