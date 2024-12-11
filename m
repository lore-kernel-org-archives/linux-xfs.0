Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C331D7E46
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907415; cv=none; b=iqQPDscZbO/j6LSTUgZAdVYgdwyfLgVtHfo2Tu5jqXVCzA36H2ZrMdd9qR2kHvGVhCc8rocEBYVLUH+gsZDUuXLZFHf9IFjU1CG25Ns5/TNDJkQdzP/p4fMe0lv3Cau5oXzTB+jUZqkMvmHyxrxzhmbI43hNcZXy+caOjX/GeIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907415; c=relaxed/simple;
	bh=iYlifTfT7zBgKKZmc11/483IVe5P9tjtsPOGUokk230=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOjMNNB1B8vlFeunJcQlW7ehC7HAKve1VKR2/Vwv9PJ6xs4AUVdhfdyyYDsc/MGaZyLXBtbmFsk/z0S1ayOwpdxDJts6B/XEXIehUrXTeZ+ZNFZflu8rK3yrHKrRVobh/2+cCsbg7zvzjA6PB8W6nX9bEqw6DjSUWi5GX2rhwFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sleMKRvw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sleMKRvw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nwcGC67ZkBqcrKTxXhqRG9NBVBrphO8J5lg/vZqlRs0=; b=sleMKRvwdflly9sHaqjjiEg6rl
	3yhueByj3iersOhHIqCxS6wq4RvBly2u9zez7GKZEvcthQYix7uYdur5rB16TXtvXw+ELfe0fMpyC
	YEJAI8Wdxjkxbt8NrTreROLl/8C+k9iH4iJoIjIvyLF4kGPHsEay7W0/dWDiISeTT8pPdfwPSF355
	t6pdDj36vctKf9qU+KuwahmoHNx1w034MnsScor4N9tK/H2t2VR1gDHOWhz1eanppAoSd0OG0PcKu
	QyUX1SwN9ZtKX99e7RJz6duiGySx/3SyQ5R0bwWQs+gT1aFsut+D8lLgw8/YizVyfBX2dKGI1KnbK
	wrh7Pb5g==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWZ-0000000EJ0t-28J4;
	Wed, 11 Dec 2024 08:56:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/43] xfs: don't take m_sb_lock in xfs_fs_statfs
Date: Wed, 11 Dec 2024 09:54:30 +0100
Message-ID: <20241211085636.1380516-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The only non-constant value read under m_sb_lock in xfs_fs_statfs is
sb_dblocks, and it could become stale right after dropping the lock
anyway.  Remove the thus pointless lock section.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0fa7b7cc75c1..bfa8cc927009 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -850,11 +850,9 @@ xfs_fs_statfs(
 	ifree = percpu_counter_sum(&mp->m_ifree);
 	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 
-	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
 	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
 	statp->f_blocks = sbp->sb_dblocks - lsize;
-	spin_unlock(&mp->m_sb_lock);
 
 	/* make sure statp->f_bfree does not underflow */
 	statp->f_bfree = max_t(int64_t, 0,
-- 
2.45.2

