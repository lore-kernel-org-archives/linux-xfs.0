Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521C26FCB
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 07:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714374130; cv=none; b=s+E/4lVBIbjhK/ecv2exXs/a23H9MLXwjBTsinebyH6samLHFpMnFqCkCqVA4BCzYH8AApCB/6zH/hVoOzTQcrwEXFWSqZxBCrzFBVdcmFj9Zw9GQqw1eDyLnQopV6x7r0r8THGmMZtCJ3dS/lRISU8Me2XUz7LdKoB5/7mDzuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714374130; c=relaxed/simple;
	bh=buwV1Moqi1vUl+THbTcE2FpLwTCFNaNfzqrKSqksEQk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rw79912K77YAJViul0so9hGHVvRLgjQTuU9mZgXTGzNXXMtRUI1W4vb37Yy9knq6GwsfdS9mivkfkLCGEH1IjARZ1AU1JJ8Mt9ZcxSFLYQBR3lOfD5sljyekUaJ2TCpA38kQJ4tEOliz55wuyg1rkjNfiGA/IlyF3wcPSapmDhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GDZLBiHi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GDZLBiHi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=c7UlTvZMCUuxmenQ+9SHFKMtJw0lgB+1uonAzDEQJs8=; b=GDZLBiHifOmXJ+fUssvzFnciP3
	omHEHaYwIRLTQ8JzrRpnS4qsirrWXhGmMOIbRo3HLqj07R4UYZ+yO4ZQy8Sihv4QKpULTEsQQ1b19
	WEhTFwO+XpLsNlFuoh0oTI2nENXhzgIhWkL7FcWTr122jAxlM7yVxCOajbo+Q/6W3SxT2IyURvDVi
	UVXpRuiQq/MHhGXZUr9f+xvnR7/8K2yvFap99YkqQMapi4UklMKokL+hoxLZKzDIenZgwNk2p865c
	Ef6/lC2zh/zOmMD1hnxiuhnpewtdfbtTNgycFhKe/06UAd6B/VldlXXs1XVKTO4U9GDo+zTiuWDyq
	lXrLm4Pw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1L1b-00000001kMn-0ret;
	Mon, 29 Apr 2024 07:02:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: restrict the h_size fixup in xlog_do_recovery_pass
Date: Mon, 29 Apr 2024 09:01:59 +0200
Message-Id: <20240429070200.1586537-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429070200.1586537-1-hch@lst.de>
References: <20240429070200.1586537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The reflink and rmap features require a fixed xfsprogs, so don't allow
this fixup for them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bb8957927c3c2e..d73bec65f93b46 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3040,10 +3040,14 @@ xlog_do_recovery_pass(
 		 * Detect this condition here. Use lsunit for the buffer size as
 		 * long as this looks like the mkfs case. Otherwise, return an
 		 * error to avoid a buffer overrun.
+		 *
+		 * Reject the invalid size if the file system has new enough
+		 * features that require a fixed mkfs.
 		 */
 		h_size = be32_to_cpu(rhead->h_size);
 		h_len = be32_to_cpu(rhead->h_len);
-		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
+		if (!xfs_has_reflink(log->l_mp) && xfs_has_reflink(log->l_mp) &&
+		    h_len > h_size && h_len <= log->l_mp->m_logbsize &&
 		    rhead->h_num_logops == cpu_to_be32(1)) {
 			xfs_warn(log->l_mp,
 		"invalid iclog size (%d bytes), using lsunit (%d bytes)",
-- 
2.39.2

