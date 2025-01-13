Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDC323ED62
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777558; cv=none; b=lQc1sIzpuZ6CJbgqSS61p2/aOAZCwdrIgcYvrfx/qVfsG67eQkGAfiQO02X15ISP9tt9fq+qass/lzvf0o0D7T7+iiNNWV7jzkNAYENUWki5F55rLT9DbsLZbhzaKEfT4J+XJOf+3KU6uQ24I34Rbbsaz+mQyzIuH8VCVLUjQxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777558; c=relaxed/simple;
	bh=QFoXSQu1MfcgBkc1ZsoPAwE1GKBfptbeQ9K0Ql1XzGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfY40eKvZ81QHj/hHBf1pY94YJLtcU9QBdAj5Zj9NMsdHJ2UhA/8sdHrzxjrVa5i5tfadEXSQCKxm7PM1j6zifbmptv5SBg5tju/L+phUkmrpxnOYxJ4IP99SOf81zNI3Wio+8ZWmZ8D3SaUYIsjJVBABPZFNLg6EUgmuG6ygmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EZYv0U4O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EZYv0U4O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zH6w3ricEdJCk1nmmn9/UtCR8hTBON++lrwSpLirNsw=; b=EZYv0U4OLLX+ZGqYUjWc1NDANC
	zM3sOBAexoDC7mZbs6J1SrOBe0Xk7M/t39iwDNFdUj19ad8WwFPMav6KZlOu6ln++5LY/1wUVVPOr
	JsxioKDc0mIxZsGDKl/aBLj8kWvq4GnoNAKnlnm0W8nmOvFQ6kMmJBgCE43oI02ZivGIYxcXaekhc
	cspGXogdYMLC0fi3ZifrStd2zlOmfjkqaJzLARvL1k5JOziJyB0VbEw+FHvMSXOMU18i9Y1MRB1eI
	N26rbwJsEKnptDKoHRE1L8GStMWdL58QjGSLABU9sciEbr2Z/d/mTbtKLmFdP6J2ngflPVT6G0QPK
	sD9u4qYQ==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBE-00000005MkU-35X7;
	Mon, 13 Jan 2025 14:12:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/15] xfs: remove the incorrect comment above xfs_buf_free_maps
Date: Mon, 13 Jan 2025 15:12:06 +0100
Message-ID: <20250113141228.113714-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113141228.113714-1-hch@lst.de>
References: <20250113141228.113714-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index da38c18acbba..5702cad9ccc9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -203,9 +203,6 @@ xfs_buf_get_maps(
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

