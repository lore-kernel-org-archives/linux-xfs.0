Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC122C21C0
	for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 07:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548790; cv=none; b=gMHtDz9j3GtMfbJVf9hrwoFFUO3OcxXYssXrUzBUSVXbnAQOzliHHdiYY8X97xH1x4mc/5jdyVjiCem7QTeefVMuVqcQkSW+8cZro26qnkccLeUtqKf9cSeKlo6siRmHcvphsH/UQMERKpjyo216wG6NkZbHlEHdyJAsjJurHyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548790; c=relaxed/simple;
	bh=MUiI4rNKcDBU2l08N6TbUcCzjGZKCr67w/laoVCswTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CL57tuA0TPRyvsnzIfJpxIsNQM6QJmS5auFQ4i54E3+dJsaUGOnzfsdon3ZlHQlSWfDITfKwyJqX2N5tVoi+D4XDjXTC9Glv2lF3TpQdKvnLduH2nxD7otwh1AgMR68vbH6txOTunPvGMUxaYT3eXMY37No4WA8qdRpdol0S0BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4K2lHstr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4K2lHstr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QUO3wTjEaFpmrUBYiEiptDwS74FB0ie8XFcfw2+lsU4=; b=4K2lHstrbPRZcZRgcd0YWsnDed
	JT8f/BcAfFQhQMiodX7Q4s07jz5FHhiLp/PlcT/zP87OXJhO1Ndl9kvb0oor6ZMQFYl/BtcbtnDXe
	vhtnapdtZmFG12mk8aOf2mvzhCbt+LS4lHMEuxpleBNFsaYj9J+HQIlUGjX/HHjp9MpId6migLLKj
	3OAYilpWJqxmbYirTDOtYkAsrDi83xkXuGY2bUaGqwmpuU4AZMCBUrGu2GXOva9NbF5auwymMXuYz
	0rmDC4UFLj8sJ+Nps4LeKSt3HQcQ/IL3wBeVticUj5+dvgi71/B5Oa2+tFG2BbS0ysEe4+MtK3OXr
	e4ysq/Eg==;
Received: from [62.218.44.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDHJE-0000000DFgi-0c5B;
	Mon, 27 Oct 2025 07:06:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5/9] xfs: remove a very outdated comment from xlog_alloc_log
Date: Mon, 27 Oct 2025 08:05:52 +0100
Message-ID: <20251027070610.729960-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027070610.729960-1-hch@lst.de>
References: <20251027070610.729960-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The xlog_iclog definition has been pretty standard for a while, so drop
this now rather misleading comment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3bd2f8787682..acddab467b77 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1435,13 +1435,6 @@ xlog_alloc_log(
 	init_waitqueue_head(&log->l_flush_wait);
 
 	iclogp = &log->l_iclog;
-	/*
-	 * The amount of memory to allocate for the iclog structure is
-	 * rather funky due to the way the structure is defined.  It is
-	 * done this way so that we can use different sizes for machines
-	 * with different amounts of memory.  See the definition of
-	 * xlog_in_core_t in xfs_log_priv.h for details.
-	 */
 	ASSERT(log->l_iclog_size >= 4096);
 	for (i = 0; i < log->l_iclog_bufs; i++) {
 		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
-- 
2.47.3

