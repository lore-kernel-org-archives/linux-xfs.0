Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED1A1F4295
	for <linux-xfs@vger.kernel.org>; Thu,  5 Jun 2025 06:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104215; cv=none; b=csOaJES4uKvK0FLvV1Y0VuHJWSSg9zN8bOyYD57E8TfQ8+HhqPy0wOkZGpQfRdUWeXGkcLf5pv1CtkvL0uizF7c0wn48mGf/IctCOqInd65VmA4NZEXHs1TlYmFcJKSHBpgQUjC3U+7MNpdQ4Snu3vkPUoHB9MrNfWjimbi6ce8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104215; c=relaxed/simple;
	bh=DIX5FABB5misxNPmQXXtPocm7I+Ngdus3tJJp86UC5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcMxZlnAbMzVKwmQHUl096KIxVxRbyAbM7uSH8t5GGog8W+YlbE9Yya3hDb8USQ43EX8xbi2RVnjcdSQ+QxNl0WwC6u6+juoDs87Mc0rcTUNFtktAKDuAa4zDU0DJaMtqTdeahccNOJzBWXqXYeR4pX53/vURojPvY1Td5qF7No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pW/8paYM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pW/8paYM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EOjbIB60gdnbuCzQ+NMOK87ejI1jBHXPkpLT+3gHqH0=; b=pW/8paYMkNoodLkskeBpXTH7iS
	wKcZTzp0x1xpdQnV7SuqlgbK7eZyqpNxDTE9tJaPcwAkkXB9B9Kj6dwOzdu74tQ7THJKU7vyMIsXt
	VK033S5z44Zl4cFK9o44PQuNwaEIiq7wrKz0GwBSobvyzJbzoPVTkpQPWiyyZjIYD6QGftnPCqrTt
	SVGD0QQCyep9UvkBjg+ntAjAVP+JrWrCbBBus0qrJs6J6WhF3JOM8ffDj7v+VzrPtNrzieLBMwQZH
	/Jplhg0Z56P6cQ6dmstKuzWB2Dce6+IcoBBZNDfBuMq3jU+HZWLf/YsiVTbgcSWTh8Hkoq8vf/Eo4
	iouLkMzQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uN3uG-0000000Eq5p-2Ukn;
	Thu, 05 Jun 2025 06:16:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: [PATCH 3/4] xfs: use xfs_readonly_buftarg in xfs_remount_rw
Date: Thu,  5 Jun 2025 08:16:29 +0200
Message-ID: <20250605061638.993152-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250605061638.993152-1-hch@lst.de>
References: <20250605061638.993152-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use xfs_readonly_buftarg instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0bc4b5489078..bb0a82635a77 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2020,14 +2020,13 @@ xfs_remount_rw(
 	int error;
 
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp &&
-	    bdev_read_only(mp->m_logdev_targp->bt_bdev)) {
+	    xfs_readonly_buftarg(mp->m_logdev_targp)) {
 		xfs_warn(mp,
 			"ro->rw transition prohibited by read-only logdev");
 		return -EACCES;
 	}
 
-	if (mp->m_rtdev_targp &&
-	    bdev_read_only(mp->m_rtdev_targp->bt_bdev)) {
+	if (mp->m_rtdev_targp && xfs_readonly_buftarg(mp->m_rtdev_targp)) {
 		xfs_warn(mp,
 			"ro->rw transition prohibited by read-only rtdev");
 		return -EACCES;
-- 
2.47.2

