Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB8F236A9F
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596248; cv=none; b=eUQSNm5Cl7TKABXGMz92gKl8fLkAr4fI/53i/yeLSEZOvSP3cNC78uGGlxvdRuqTmSrtLiGuLBHrjsb+Vx0IHRWgFDuFhd9neyPk77BBLmGktjbFV2SP5F7xSlxmCmRFrOpjMWrf20w3yQ+F+3Xlp6bMwWyxYrZmft4n30tqqQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596248; c=relaxed/simple;
	bh=V0V99rj7tDsJHT/BGLYR0qsu++nl4CRh9h8Dhe0u7/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cykW8foc0VRM0ah/U9BdY7lIynkN1NKZiqj1Lr7mqZrDPqibTx37C+anf6Aolwd31KSoT7BtXhlX0NQbs59PjSeBtynKYktTf+x6j7o0Vo1TEIUvQNaLxFG4FTmVRj0NdrizLXvxFmTNX2KZk1frrIut6cRPW6PZcVgb/p8fshs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sxKCqDII; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sxKCqDII"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QCYVeYoS0d39fTzsKVjJggX73WYo+AoJS3AWTEAryx8=; b=sxKCqDIICafSd0Lss4RtPsR4Wy
	gVTz4p7inXDPKScd2xCY8f1F8hgpaHEhx65xuNxSGB8nPp3i+6TMqRxq3mfPTxajgRztynRai5dW2
	gFT2OdGIpNWcMs108H71rEMFJ/3R2FFjq5KL18tRV6qDCE267kH9sEKYw/RQcAqj7ONgKy0/B7FTY
	x4oVirrt1gJIsmWGYxarMokLlmTrAdf5sh6GyIZbJJOp7ejJno9jHZh2QXUFg53g/pL84Fmm5fSjt
	yBTeSj1QVbUtRg7JUzyXTT/CqFW1uTYPpO23t9l8jj2LhqejidzuoWVggLltSlB5U9vlirCeWeSn/
	ioABPPPg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb0-000000053s4-1wpY;
	Wed, 26 Feb 2025 18:57:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/44] xfs: reduce metafile reservations
Date: Wed, 26 Feb 2025 10:56:39 -0800
Message-ID: <20250226185723.518867-8-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There is no point in reserving more space than actually available
on the data device for the worst case scenario that is unlikely to
happen.  Reserve at most 1/4th of the data device blocks, which is
still a heuristic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_metafile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index 88f011750add..225923e463c4 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -260,6 +260,7 @@ xfs_metafile_resv_init(
 	struct xfs_rtgroup	*rtg = NULL;
 	xfs_filblks_t		used = 0, target = 0;
 	xfs_filblks_t		hidden_space;
+	xfs_rfsblock_t		dblocks_avail = mp->m_sb.sb_dblocks / 4;
 	int			error = 0;
 
 	if (!xfs_has_metadir(mp))
@@ -297,6 +298,8 @@ xfs_metafile_resv_init(
 	 */
 	if (used > target)
 		target = used;
+	else if (target > dblocks_avail)
+		target = dblocks_avail;
 	hidden_space = target - used;
 
 	error = xfs_dec_fdblocks(mp, hidden_space, true);
-- 
2.45.2

