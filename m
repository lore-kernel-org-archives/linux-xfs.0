Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2DA440A36
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 11:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385747; cv=none; b=j1cwMtH2VkLCNOUyC8BuAx30OVxWyNoV7XtnLbadp9ERt/DvzCwRFas2ZTVidbCK6YdZETcLxyECXBlTn8dbobPSmlVKi9TqeQ1JGwWGu6aenisMdDt400NfMK5JbJjCqrlMJpPvXRmCTEzKNMM529VMvi7tkW40X1qwBEEojmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385747; c=relaxed/simple;
	bh=am600qOentaVdzkNYRXqgmt9M4Sq3LYg8QtlKuuWbWI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PdAUUW+CFC/5y0zRA7guJUFpKTsS37Q8ew9BiZl1mb1a8BmNp6qinb9FYz2YJRhXY11gERBhkXvzoPDZvjtsdm1CEek2daOmfOYsJvzneioH03CAKBhtK0wtwujcIdGrebRnGPTZHyhYhhko+ngmqpS2qRniH4JRjU1if+WjQGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QlgZCaw/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QlgZCaw/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=15cuRtOuRo5Dyi2mkfHVHxsS0RP86jqB+wC/jYZGIvg=; b=QlgZCaw/kKskBhj+FIMDMUBRbW
	Uitm23/VLJoxXxbofxc5BfL3OP1aUZD5xDbYZC27pT9QRorCiJ/NSjOw/1Vka4ar+aSVCMka9tTQG
	iYPket0tZcXrLKVmiLTJCyrj1N9XNtT2YNw4PoeSEtyPwosb6JJr016FeQZqcqLYmlC1Kv4hFTC4/
	NWnjnlGP/iY/6j5LNTtCVJFrszrqtC9oosLKgjE/UGhN/hlEcXO4A6E/Yae59ZBnnWTfZN34EBUGI
	mVrLvOqv9fxQor1mySZMyEAZ+t15zGcJjQVhRbo0WqsPrqrlGig3z+vB/pbpBI9CctsLcGUQ09hsR
	Gj1TNwPQ==;
Received: from [94.154.173.22] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x64yL-00000003Gyo-3hcO;
	Mon, 14 Sep 2026 11:35:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	hans.holmberg@wdc.com,
	dlemoal@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: don't try to get a reference to a NULL oz in xfs_get_cached_zone
Date: Mon, 14 Sep 2026 13:35:38 +0200
Message-ID: <20260914113538.2448661-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

oz can be NULL when we resample it after taking i_flags_lock, so account
for that.

Fixes: 2d829cc76777 ("xfs: fix racy open zone caching")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index bede79859671..8cdd473d8144 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -819,7 +819,7 @@ xfs_get_cached_zone(
 		spin_unlock(&ip->i_flags_lock);
 	}
 
-	if (!atomic_inc_not_zero(&oz->oz_ref))
+	if (oz && !atomic_inc_not_zero(&oz->oz_ref))
 		oz = NULL;
 out_unlock:
 	rcu_read_unlock();
-- 
2.53.0

