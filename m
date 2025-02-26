Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B6019597F
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585169; cv=none; b=ODVQgN/sHhv2GuDF63k9jh11rWuTU3TOdWt+DKaZK3vkupq+XN9Z/aF+qD0BwvH4sds88ZNo85PKUEOAlV/AGYteXdysdjbG5tZWpLOTaw6Wx+ibB39yHhb2pzxMqUGNU0KLMHB8J90jBViDYJQnECCOBHnNAANqzg2PfSIGmhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585169; c=relaxed/simple;
	bh=wIgz0q21MCRth3M6hR1ai8RTzkSw+Jz68GjG9a2pDY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqmEIQ+yKxRAtw+lniuejD0bERHU12v4UzR/gkPZeoK9EzFAyGlCH2F0GK/hePz/iiZGjgNtDawA/DteNKv+m70d4AXvOGiWC1mMkLOul/9IyD/FcpAvEIMtlDpy9rQbBMhcCvWkk95VFASiDfA8d8AkDeTg6pT6UK89q7+8Q+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kIN7c3bv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kIN7c3bv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nHf3wcGj+D8xdnFyA7p9D1kyiSujpeaXMZ3SXOjiAjU=; b=kIN7c3bv941s0V+7DqZtXDs8XB
	uMwZRVgubtNr1Oadu4S4mG3cxdz898C5sBRlZttEUctnBlxCLXjm1QKOj5bRqz78AuiVIKSfSzUA7
	YjKq5X15qgcdGlnDwZeWZCk2aGT2hHmqJYkboROqIhJoBO1yqWUZHGXbfyGJC8T+Fy8mRJAYYGkmL
	thIObTDsK80n3mi39v6bY17yglSfRs3+OIoUOK0Fl9w5kAdBPwGvTyuYyuZp1cv6bBITIacIOGc2w
	AIQFutkQqzsr9btIuLzvdPnp8hbaJvDG8+Gplz92rv83EP5OtMVn8MJam/bxDm+Ert60ajbaKBrK0
	V7CAyG3w==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnJiI-00000004PLe-0MHr;
	Wed, 26 Feb 2025 15:52:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/12] xfs: add a fast path to xfs_buf_zero when b_addr is set
Date: Wed, 26 Feb 2025 07:51:30 -0800
Message-ID: <20250226155245.513494-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226155245.513494-1-hch@lst.de>
References: <20250226155245.513494-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No need to walk the page list if bp->b_addr is valid.  That also means
b_offset doesn't need to be taken into account in the unmapped loop as
b_offset is only set for kmem backed buffers which are always mapped.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15bb790359f8..9e0c64511936 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1688,13 +1688,18 @@ xfs_buf_zero(
 {
 	size_t			bend;
 
+	if (bp->b_addr) {
+		memset(bp->b_addr + boff, 0, bsize);
+		return;
+	}
+
 	bend = boff + bsize;
 	while (boff < bend) {
 		struct page	*page;
 		int		page_index, page_offset, csize;
 
-		page_index = (boff + bp->b_offset) >> PAGE_SHIFT;
-		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
+		page_index = boff >> PAGE_SHIFT;
+		page_offset = boff & ~PAGE_MASK;
 		page = bp->b_pages[page_index];
 		csize = min_t(size_t, PAGE_SIZE - page_offset,
 				      BBTOB(bp->b_length) - boff);
-- 
2.45.2

