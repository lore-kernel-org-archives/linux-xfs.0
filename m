Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E702E2AEE1
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185425; cv=none; b=lX363MCdLblV18S1ncLKUkDavpKKShFK0CO6HntDh3rtcVvu4MVPBEcxYzcBBu+uufngFoaADVs52a3DG1MgPEqrXnUe9SD8Kqt+BGn5iLXblGAHE9qvydUT9NxFmmdFTDw5cb13UWHMcdk2c3wCQmFPy1ZoQSDrKbTCAxqa8xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185425; c=relaxed/simple;
	bh=C42eBujB63AA3mA2kkILYkpdzjfZOMKPatYdWItTa7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEcxet80m76j9rrTlyiiF2pEgfHjHMTIxLka7jfI4fM6+vW6Lq5Is30x9IfmmL5LeVZ9Lx4ZaqNTbZsWQr5Gu62yb3YZmUmhaUGPN0x3FWWkhfoTEEA3GcAATWI1+A0EXLRqPEJztUWiYN5EVdTxahRVO0xyTVK7QSuXNIBjvI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OS457LVj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OS457LVj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IbI0g/6Ay7Y0jPSgWH0rz1/yhuVfsYvWUt40hrnRnps=; b=OS457LVjsS1REvai7wP689MuQo
	NR8Y0VLdkG+SKr6DZju5rSPUc3LzQ6FlDo/1rBfprbTFbvyLm8JqJDAo9P72bhXMshbLkEV+7AZhK
	JhNj3fTFRVR1CVdXn/+U8kgLPJlnrBErIO5vCBuJT2lR+IGOTf28m/tww0B6uq5g9flAPjeIkpPpI
	e4rZN3Tkh11UzpAmjAEzCEsiANc1LSqHXDQY3s4yPaIstbsxgD43YsFBMgjBmBmBGfgD/RnWqDQiC
	LEhe8XhJEqFkh7cA5k6CJ6LFxrpf7nKK3xE4fWDkhSFd2WTSxD4SiYceAfXlkyiDU0jxqhqRSeIlj
	DXCqirSA==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QIx-00000006UQh-05Zd;
	Wed, 09 Apr 2025 07:57:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 15/45] xfs: disable sb_frextents for zoned file systems
Date: Wed,  9 Apr 2025 09:55:18 +0200
Message-ID: <20250409075557.3535745-16-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 1d319ac6fe1bd6364c5fc6e285ac47b117aed117

Zoned file systems not only don't use the global frextents counter, but
for them the in-memory percpu counter also includes reservations taken
before even allocating delalloc extent records, so it will never match
the per-zone used information.  Disable all updates and verification of
the sb counter for zoned file systems as it isn't useful for them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 8344b40e4ab9..8df99e518c70 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1330,7 +1330,7 @@ xfs_log_sb(
 	 * we handle nearly-lockless reservations, so we must use the _positive
 	 * variant here to avoid writing out nonsense frextents.
 	 */
-	if (xfs_has_rtgroups(mp)) {
+	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
 		mp->m_sb.sb_frextents =
 				xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
 	}
-- 
2.47.2

