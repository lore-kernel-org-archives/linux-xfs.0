Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF81636B93F
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 09:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243907; cv=none; b=GJfADhoxWQhFUQAl2EaHAwVRGEEL4ffUXfgu1/oBJAxrNnMq2yid1v0IhpMV+Fh0olsoGp8KIR0kt8IH6mwa698s+M1SMgQYnbGMG8q4nw5gAVrCYo8aEDScaJN9p+TjPkYMeNMGDSLyyuucMaqCxqAriNarEsvn12Zki2zJVgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243907; c=relaxed/simple;
	bh=5oziLujVG5/WEjnFAJKY2Rdifz8bGRxZkEjLJ9t5514=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nr2IbzX0PFErNFExSJo1Zzi1JOJGINqhpnpSAcyeKuCGxgV33lRaQr5RDwP4e75tKxLqw+7W1AAbdWoEdIpJRbOe/e8D4cbPRTrC3lPVpNdJwWzfjtm4bKI+TIxIcvvIPAQ03sAMp2RTQtXvNUjwIRe3ZJ4uQsjMrOz5OjN63hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JdZRIjQh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JdZRIjQh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6aPEd3ooxe+Aohukn7FzRdEH4N63fGdOYO9dW2xxb+k=; b=JdZRIjQhm8AH22KutOVzah2YN1
	G4gKtaQPL8uqqi30p6JLiluBCiA5HSsWb2oc24u9pG8bpj1IQDQnUIujYkxmPxDR7froUV5OjDXa/
	N3FXtkQvMmwYg3c4y6EVJt/+zXsjGKWsn20ykpkAEKNnhqhOmC3c++VNCSlOlz306f2k2cQ+Tjflm
	rre2KgMARwl3rXTuFHfqgcycnfoN26qOiqfI7ahW4f0db6dPZJahf7PBmfYaMfMZS1AhtrEYsjF/l
	a4yh5Wu+T6NhU0b9Y1Zjx5QqQF4rQI/ODAoU/S+k4UyhxzjnrQq30yKPUwIyfSgcenL81QvlQFQm1
	CgksyF2w==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gDU-0000000AeNg-2id9;
	Thu, 24 Sep 2026 09:58:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 9/9] xfs: calculate end_fsb later in xfs_zoned_fill_srcmap
Date: Thu, 24 Sep 2026 11:57:10 +0200
Message-ID: <20260924095740.2732474-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924095740.2732474-1-hch@lst.de>
References: <20260924095740.2732474-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_trim_extent doesn't need the updated end_fsb as it already is
limited by the smap range.  Move the end_fsb calculation later to
prepare additional reasons that could reduce the smap range.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7bc17f179be7..6701be9325ef 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1613,8 +1613,8 @@ xfs_zoned_fill_srcmap(
 	/*
 	 * There is a data fork mapping, only map until the end of it.
 	 */
-	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
 	xfs_trim_extent(&smap, offset_fsb, *end_fsb - offset_fsb);
+	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
 	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
 			xfs_iomap_inode_sequence(ip, 0));
 }
-- 
2.53.0

