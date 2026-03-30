Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4153D3CFA
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 13:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774876576; cv=none; b=BGZDdDx+BFzgfrYbSEnXEMyM+8lbxM7ybY4xg9ooe3B+blTKHaxmhH2mQm71gc3Lg761Ohyi+qCCINnJ/d19oT6t+FoqK/ZsivUUJ41oAI5jCN4wAuIgnXda20/Jve4BVNy6cMXjCapXRQbGuX+NZTVtny/22nRQto5/Z4skjVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774876576; c=relaxed/simple;
	bh=KAbUrlOqDrtg71Hlwsc6IE/9HoeGF5eY45HDC28Pzww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuewrfEoPBKECCS+apRbHCMuerL/fB3Fm7OzjOfBXCW64+S2JTC3piOz1Flj0Z6swE5PH8XxwWVcn3NlQ+8HctCGbNS0pFV2m4RnrfbDqda6b0N+637Z8vwUzJuE4Rw4vrj49DZh3GID0oLAGigHeohhgyl5a8WrZ4ZV5/F5K08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KCY+B6dO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KCY+B6dO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=t4ziCWgvu6B+TVL4ipFQfLyZCfxwcs4TqFFJMGZ5rI4=; b=KCY+B6dOCrIQGdGV8J6MBJdQ+A
	YbsJX/zd6cYNfvK+Wz6e3tHARjnr5RODGQy3pfUxXhrGbzjRxlXQzNiPswtqtk3ZdGxUnXi7F+tOA
	EWsGJMW9R3tMt9djh/vgH93hLgUc0ynE0fKB60gLQZ6xOfCQjbHEJxCK9G5P8pTKKbtE5EWRylLoi
	mLdcdzv/KMCE8VNrG8C8S3979BoE+2aLO8ekfEbG9sBg6gXaxw4Q9cENbLhjZz3L5ZvJkph+nUBWS
	Jzl2oPlPLSZ0VtN+7G0lpmh7FhCWgmK81hf9U1JIS1PATjd0OCMS6TljCxFPGiFX575M6H508oVwR
	cORpSxhw==;
Received: from [94.154.173.90] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7CTU-0000000BKSA-0vVf;
	Mon, 30 Mar 2026 13:16:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: remove a duplicate assert in xfs_setattr_size
Date: Mon, 30 Mar 2026 15:15:59 +0200
Message-ID: <20260330131607.3904269-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330131607.3904269-1-hch@lst.de>
References: <20260330131607.3904269-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There already is an assert that checks for uid and gid changes besides a
lot of others at the beginning of the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iops.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 208543e57eda..b0256a4a8aa8 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1109,7 +1109,6 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
-	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
 	setattr_copy(idmap, inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-- 
2.47.3

