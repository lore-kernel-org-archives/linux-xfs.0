Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BC219DFA7
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609008; cv=none; b=FxUJT9r6yA3N+xSqL+K8bFAIO3eTvBNcCCD/sqK1AMUdLwFCNlB+UtYb/cj9Fox+PcfjA5lVlc0L/PmS2mGl2ckBvFuJo2ObAKuOu0ZvWLb6Sdqx4EtBnOdmK3ptKpBBX8lr2Wfjpl1Y8mt67i4640VofN7HWWxtnKO5ZX/mCL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609008; c=relaxed/simple;
	bh=pjSROCc4EaorLF/xvIFjeZi6DRfa84jWF/KnHdjh4iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1PMtIrTfAcfcNeVqja7w7Scuoq3qpQHmmYv585p6vLkMtFKsXkE97m0TPPZMdec9Puetqzr/MaTumUxZzrP9GrMcYNx0x2sFZkVrta2t88/02VkrqK96LecAnbcxaJdq44YzL7196zOaTSdRThJ/GnBAfUrISW0CRvkBAp4BWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yCDSXYYu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yCDSXYYu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Tqp3OvtCgs7ijWJGkgij74HUGPt4xqwlplL3odFloNo=; b=yCDSXYYuTdFxrKe7YSELtx9g86
	b2MaUZJvBHQ1ApHs1ALFZSh180/J8K7kvx/Dy735IgU/1XGSBJwvQPMEQ9kmA16LCXKfHlCdLJGzD
	Vxyvu3nWOahqc5uY3W7K49Wj32M9EVPh4E8rU55RrPSlfMadTgCA8vLEXuLqpg8Upm7owlzvs9RfE
	qY37V4mQwxQcn/b4kRaoYqyn894NklGfTDoa5le9gKc7RSpI/MBubIk8koQCZ5an3D4RP5QDeo6fv
	2EekTz0yG4RGXLA7BlbKpcPn5LhygO4qAfOoI7apDyDrSk55KUJcS0DbbvdY+MXjW4wHW9fdl4muG
	oo4jyB5g==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CUw-00000000i8d-0uUc;
	Mon, 14 Apr 2025 05:36:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/43] xfs: reduce metafile reservations
Date: Mon, 14 Apr 2025 07:35:48 +0200
Message-ID: <20250414053629.360672-6-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 272e20bb24dc895375ccc18a82596a7259b5a652

There is no point in reserving more space than actually available
on the data device for the worst case scenario that is unlikely to
happen.  Reserve at most 1/4th of the data device blocks, which is
still a heuristic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_metafile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 1216a0e5169e..6ded87d09ab7 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -258,6 +258,7 @@ xfs_metafile_resv_init(
 	struct xfs_rtgroup	*rtg = NULL;
 	xfs_filblks_t		used = 0, target = 0;
 	xfs_filblks_t		hidden_space;
+	xfs_rfsblock_t		dblocks_avail = mp->m_sb.sb_dblocks / 4;
 	int			error = 0;
 
 	if (!xfs_has_metadir(mp))
@@ -295,6 +296,8 @@ xfs_metafile_resv_init(
 	 */
 	if (used > target)
 		target = used;
+	else if (target > dblocks_avail)
+		target = dblocks_avail;
 	hidden_space = target - used;
 
 	error = xfs_dec_fdblocks(mp, hidden_space, true);
-- 
2.47.2

