Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCE3D534
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 06:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714371339; cv=none; b=f0NqUQtmJnJIs70BRrORffHS7KrMiaOXuWviZrabMN0wjvgQj5ODNvkahjZMgPiAZ0/cJQ4XdsbV3B7lTRDxQOoQZlNYOodrRcC9qzUAm5hd8QWduqXTl9e1oVCInaUS1kRzR5kK5RAUOyAeyujhIzVxvPHcdsmCPAaJbhACC+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714371339; c=relaxed/simple;
	bh=I0agVvLdO3ZnCpMFi0oOJZTzdZZ6hn1jLejOXAy46Ow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WZeUgmphI8sgfcdddZkS91lxx3hsRsfnqzmMbydUyCjyenOaABadooDaGrzQvGPT2qqBxmrvXLuBRz9iDldaA2baaN72GJckbZun5vlmAbfoi2Why+uf9u1ViTppax/O0gtveyJjRLYY6mm7P1+5JqFv7MCijsv36hAlk9NL+SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tTtCv9mT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tTtCv9mT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mmqbceSLjqfsFeCo/uFED4Gr7gistXzQcq1Gr2B0qSg=; b=tTtCv9mTJ1CUP/b5qIpAOe8Q7N
	NK+nzrykzdaILwOe8tX4gjN0v5CP2QzrN7kQG33tuQxLdRs8P/ROdq3vExhFrQjC2whZ0FqyJgt0g
	wMb+okxPf3bDhUKM1YcC9YzBPOqyOw/N89+A5Z/0HJthDs+Q6AuSiv1cdK90+bn5sjVyzDV8PNw6W
	RXE4jwxpZh9JW2aCN8z2+tpcKmd7uvEvxdOXY+1GCumnCvFhCKfBPQJyZ0enUJ/BI01e5g/ls4HGy
	AgKf03+orcJrLhfZA69nOgaP3wcI8NfdjCJzpUDMt+DuvSyzy8hlGx4bQQh3wjN7eutmDkllEMdnv
	RD5LjzcQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1KIb-00000001ciK-0WQ6;
	Mon, 29 Apr 2024 06:15:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/9] xfs: remove the unusued tmp_logflags variable in xfs_bmapi_allocate
Date: Mon, 29 Apr 2024 08:15:22 +0200
Message-Id: <20240429061529.1550204-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429061529.1550204-1-hch@lst.de>
References: <20240429061529.1550204-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

tmp_logflags is initialized to 0 and then ORed into bma->logflags, which
isn't actually doing anything.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f19191d6eade7e..1ea1b78ad5a560 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4182,7 +4182,6 @@ xfs_bmapi_allocate(
 	struct xfs_mount	*mp = bma->ip->i_mount;
 	int			whichfork = xfs_bmapi_whichfork(bma->flags);
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(bma->ip, whichfork);
-	int			tmp_logflags = 0;
 	int			error;
 
 	ASSERT(bma->length > 0);
@@ -4253,8 +4252,6 @@ xfs_bmapi_allocate(
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
 				whichfork, &bma->icur, &bma->cur, &bma->got,
 				&bma->logflags, bma->flags);
-
-	bma->logflags |= tmp_logflags;
 	if (error)
 		return error;
 
-- 
2.39.2

