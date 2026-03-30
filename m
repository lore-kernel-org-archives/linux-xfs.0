Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5E538551A
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849565; cv=none; b=c8wsLdXSHq554kwMIcj9yRkqSp9hRLFc88C2/ofSYQcLHuP2QlJj6N2fqkMy0R7taFEQ25eTTNezKY8kkynjUacMKhjRdUkLStt58rXTOqu3owT97LIMnCf8VmnDqHtZNQXp8ARKolYpHfck4H5g7sqAsEnDk9Vwa37XmRK0BGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849565; c=relaxed/simple;
	bh=Mm23TtaE1JANptm2albRRPEIez9y+HigYqc32SyMmyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuN4OuCN+LXzx03gn2tp2r71/+w7+0sa/JxpXhgCpKPbC7r6ix9gvcc/22jSdSOms9tUHyYpcg61utgFuQvBFvL61Id+1r66FYVY6dvCOx1ZJ/651zJdmCO+nxHgsQESbvQmWId8RdwAsgUnH0QfHYIKbVT1GotbsMD5X8/wGTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RT1eL7pV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RT1eL7pV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eiNeUxHTLQ713QjoXWxvrmQx68LY7h37V3YFD1CGpZc=; b=RT1eL7pVzD7NVeOfLv+o/HYFVl
	aWxd09ORvkM8zbCnbvVSby8Hg4Pk+J5+tTVvzpsKw0aYqq+VAKON6rjRjm8cQt/cTf7xCOPnuhYX2
	KgmqcNVtkuoN0iLwMTtpRPusYuBQ9Pe3qjwaG+rOVv6nAXkRc8mkhR6/QYZml4k/9/UAN4XeoHKft
	9zKCGHHyXvwEQiodGft1JqMVlUjFF9MbCotHRbqSshjzSyOgkP5RPpoWpzSd+91Q8SqnS7nWkLhTM
	gF3LLd4T688aA9VDl0af4y666O0SHwpe+mBApEHnNCBakwmdvuJe2V1wmauINICy2QeIoElQBFddK
	cbX+E2zQ==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75Rr-0000000AeWe-13Fw;
	Mon, 30 Mar 2026 05:46:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/7] xfs: put the open zone later xfs_open_zone_put
Date: Mon, 30 Mar 2026 07:44:13 +0200
Message-ID: <20260330054533.3856339-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330054533.3856339-1-hch@lst.de>
References: <20260330054533.3856339-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The open zone is what holds the rtg reference for us.  This doesn't
matter until we support shrinking, and even then is rather theoretical
because we can't shrink away a just filled zone in a tiny race window,
but let's play safe here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index b0a6bc777c36..297a918bf28e 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -182,11 +182,11 @@ xfs_open_zone_mark_full(
 		list_del_init(&oz->oz_entry);
 	}
 	spin_unlock(&zi->zi_open_zones_lock);
-	xfs_open_zone_put(oz);
 
 	wake_up_all(&zi->zi_zone_wait);
 	if (used < rtg_blocks(rtg))
 		xfs_zone_account_reclaimable(rtg, rtg_blocks(rtg) - used);
+	xfs_open_zone_put(oz);
 }
 
 static inline void
-- 
2.47.3

