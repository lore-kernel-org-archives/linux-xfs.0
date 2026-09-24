Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280FB326928
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244334; cv=none; b=NVvJ/e6mX5ClHUBGMvZmvfydh5sJv0KJ/DRYHh+Y8UObHg6lIRyKor2UEr3VyXnUTQWM9t/rZPfWrr5FaE/XBTR7ahMYu4mCWejiWeKenFhPtX45S+N7jixaV11+nqt1GVmx1QY1c1y8ZwMRE7i4ZNiPhGf00W0C7k7JucTQtCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244334; c=relaxed/simple;
	bh=hudqfYg7kDiRLieOrQi5f+r+d51MIe1TZQgFPfvbXwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqlNU8QeXg9LO3hDuODRd5teNUbv4GPccRjbEZwPfSxbkWPG4LEgZYknnyPm/VjI/gtvMVvgs+RUhqIkRNHaH1UUwImPpTQKdnEnkW8T58dp5TX7zHtuMA6eAU6llj5s7mS5NoRtUQ+LGWzV5SvqnzpPtBFzbztQE3etfhLh4mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rB/4b5k7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rB/4b5k7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gve2rbRSkH+54vr4JRuBlUtXM0/F9IlyRkjIS/ym7wQ=; b=rB/4b5k7rd4l+h4jNwEol60F0j
	6HdODDQhG1r9FCkl3SV6YFrTDrbChef7xqXZMbUv+wp3hkU0vTZA2AOTnpu26B5jhl9dLurQ1KpUP
	2fEgbmfjlY5I603RUpbuIpR2uXa2MW/qwFxjnLLDookofYkhM0gh18SbOVUkWCULRF0HMIbg4EFqd
	MHYHYNjQqlJYyGEDMxt6DTJ4BerPToB6EghlKWI2h3PJ7U14AVXhV8eHzqAcdnbA8a/oF5xJtuiMa
	ahk3oYLZ45wmKDwAwv2IQH5E0Hhhagz+mUfkl9q4dU8QbpDaMW3+q8OF6VT5M/cpwHrkof5wB6pq0
	+HCb0MwQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKV-0000000AfBp-33Ja;
	Thu, 24 Sep 2026 10:05:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/32] libxfs: add DIV_ROUND_UP_ULL
Date: Thu, 24 Sep 2026 12:03:54 +0200
Message-ID: <20260924100512.2733748-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_platform.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index d09fb0aae00f..a61d50de9dc0 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -212,6 +212,7 @@ void inode_init_owner(struct mnt_idmap *idmap, struct inode *inode,
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+#define DIV_ROUND_UP_ULL(n,d) DIV_ROUND_UP(n,d)
 
 /*
  * Handling for kernel bitmap types.
-- 
2.53.0

