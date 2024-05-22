Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C744C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347300; cv=none; b=pH0W2Z/+Ug7Py34t+kTdCllzlbCHhy1AY3NOlyB0Ml4hrWRl84oUSSMfgu+wes+GayT+MZYhKMd/ISdu1KI7kmVbbcUhITKp9JUCEnX/vSlczxs6aR/f/c2hPT36VMAinwsXFQVU1NC5qd2/0h0tsKYOtM5GT2ib6CwCRufcSWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347300; c=relaxed/simple;
	bh=YZ4J6yz5DpGsPYKfBEEBBz2y4D+OPeJMxkilQCm4oCI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QRthx9keFNt5niu/u6I4L8FczXVMdMacL+UK8wBohPx8evbF2JtNAcx4hiQw6g66SvxcAIL4sEhM4SJXPuRCj9L9pMtysOHTa2KNXmOZ12+SQNK5S/IqOjt2Qfh5Z7ilt7I2Okf5+EbMoJqOoiGS0J4zmgeOe5HHM30sX7H6fQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSJp2DMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSJp2DMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BFCC2BD11;
	Wed, 22 May 2024 03:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347300;
	bh=YZ4J6yz5DpGsPYKfBEEBBz2y4D+OPeJMxkilQCm4oCI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FSJp2DMNJiFXceQ3YcUrzwWN077yEIkgnYIqd6qRVsnkEUAo/zWh/GNibpugd5O+Q
	 OX2lllyhKYgWFRir1PpFX6v0zXrI3ZtgmoqTzhhra+ZWpsrtliVYsosYUxb7ppkqCJ
	 iGWJCiaCI+9+0Fp57XVvM5hnAd65gQSFhfyjDzmgBEpmipeNgydUJZA2ZwC0/phhkq
	 vdma2UenpETkrsYr1J07T9k820keRBd5nlt4PUeeUuwBgBlDok/XVdWOa+UahzqGVE
	 Hq+dc9ctFea9NFDxO3bLzClade86FoTOlfFzFPshrCoLwU4+8j+5fT0GTgp4He4yxR
	 0/tidg1DvIXpA==
Date: Tue, 21 May 2024 20:08:20 -0700
Subject: [PATCH 075/111] xfs: simplify xfs_btree_check_sblock_siblings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532823.2478931.14808526851680436018.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4bc94bf640e08cf970354036683ec143a7ae974e

Stop using xfs_btree_check_sptr in xfs_btree_check_sblock_siblings,
as it only duplicates the xfs_verify_agbno call in the other leg of
if / else besides adding a tautological level check.

With this the cur and level arguments can be removed as they are
now unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0b6d8d6f1..4ba36ecbb 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -83,8 +83,6 @@ xfs_btree_check_lblock_siblings(
 static inline xfs_failaddr_t
 xfs_btree_check_sblock_siblings(
 	struct xfs_perag	*pag,
-	struct xfs_btree_cur	*cur,
-	int			level,
 	xfs_agblock_t		agbno,
 	__be32			dsibling)
 {
@@ -96,13 +94,8 @@ xfs_btree_check_sblock_siblings(
 	sibling = be32_to_cpu(dsibling);
 	if (sibling == agbno)
 		return __this_address;
-	if (level >= 0) {
-		if (!xfs_btree_check_sptr(cur, sibling, level + 1))
-			return __this_address;
-	} else {
-		if (!xfs_verify_agbno(pag, sibling))
-			return __this_address;
-	}
+	if (!xfs_verify_agbno(pag, sibling))
+		return __this_address;
 	return NULL;
 }
 
@@ -209,10 +202,10 @@ __xfs_btree_check_sblock(
 	if (bp)
 		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
 
-	fa = xfs_btree_check_sblock_siblings(pag, cur, level, agbno,
+	fa = xfs_btree_check_sblock_siblings(pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_sblock_siblings(pag, cur, level, agbno,
+		fa = xfs_btree_check_sblock_siblings(pag, agbno,
 				block->bb_u.s.bb_rightsib);
 	return fa;
 }
@@ -4710,10 +4703,10 @@ xfs_btree_sblock_verify(
 
 	/* sibling pointer verification */
 	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
-	fa = xfs_btree_check_sblock_siblings(bp->b_pag, NULL, -1, agbno,
+	fa = xfs_btree_check_sblock_siblings(bp->b_pag, agbno,
 			block->bb_u.s.bb_leftsib);
 	if (!fa)
-		fa = xfs_btree_check_sblock_siblings(bp->b_pag, NULL, -1, agbno,
+		fa = xfs_btree_check_sblock_siblings(bp->b_pag, agbno,
 				block->bb_u.s.bb_rightsib);
 	return fa;
 }

