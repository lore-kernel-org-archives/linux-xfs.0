Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A9EB676
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157382; cv=none; b=PimcNPxX6dG5RRf2tk336gmSHRl4k2foKK+8idXYQ1crMMIv/bMrKUnSb4u/SIPM8dZqOIW+tOz52yvBn+b1p2g62ZSW1flp3ipxB2qRW50rw3yY6t0prmwlmluemL0eY+ApbOiSg/zwaEeSrcLjuU5XOvj0YJI0gPhm1Tg1zrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157382; c=relaxed/simple;
	bh=AD9ZQIfVAON5Bm5m5XKuhEieP3kGrOLEN2K3cAfzr6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3tzlSVyEjMNz/aZJ1bUSeTgw2m3gFY2rIlLxYNFrJ/x0KXr21wi4vSH3S52kKdgeOrYBSZANqgw5jl762DWxarcQrflawPVRka/rd/BdSYHccAXUEX3JmlpQTkdKLipNqa5VItMk7JyTYJehjLQYHFved1wpssXPgYSNQ1BQPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P+0rRwop; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P+0rRwop"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OdMI8/y2HR9p5kJY5tBrnXXJhRqc956BkP4xpSZ40ag=; b=P+0rRwopYfUm7gJY9Uxp0VuIyM
	xKmFOPfe7N8BGOEQw1Zi+t7pxuRk+tksyz7f+Rmhx8y+JrlaRFH5QTc5AJbyhIoKH+ZnOHTJVeLxs
	gBJU1l6pdNTZQTUeUvsZb2DdosWQUrpfIa5FqeNen2gJ2uOazJWUVr+Pjxe7ChX8h4QoyE8G2KxmV
	t6rI8Ni1EbzLaevQ/+qACEu16aBeH+dANWSFPEFg/lGL+COzGHPfFrzeQr1fvc3RAzsGITaXBKVwp
	D6HGzcCsZO+VzD0pQeGoB4ablJSo/vFUmpvESAmdFDrxIqFNqPbOYLok6ZWrtmChsqJUHFvKMSrl3
	6J1V82gA==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqN-00000000lCE-2zy6;
	Mon, 06 Jan 2025 09:56:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/15] xfs: remove the incorrect comment above xfs_buf_free_maps
Date: Mon,  6 Jan 2025 10:54:39 +0100
Message-ID: <20250106095613.847700-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095613.847700-1-hch@lst.de>
References: <20250106095613.847700-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The comment above xfs_buf_free_maps talks about fields not even used in
the function and also doesn't add any other value.  Remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 787caf0c3254..1927655fed13 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -202,9 +202,6 @@ xfs_buf_get_maps(
 	return 0;
 }
 
-/*
- *	Frees b_pages if it was allocated.
- */
 static void
 xfs_buf_free_maps(
 	struct xfs_buf	*bp)
-- 
2.45.2

