Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792A33D6498
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 09:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540781; cv=none; b=Nvm9OidiDkDxQ7B3gYyhkcCrqO7g+iewZNlXg0kRDexSfABD3Fp0Q0VnO72ZG4sgG3pI4ps5YJd4vDAc2lSAnxP2RNzs8olHuQUoe/JwuiIlE39XRm4khFYBeE6/r+yOR2IWe2h1bP3hR3Dzc5vaWlTh5Pdi2gqQebhDSHliMFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540781; c=relaxed/simple;
	bh=rklYQj7ih/vPlzu4l6yMTsV+dIgGdzN5poJi48ztIvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLNF9ROVuZgVmJSnt0itXu10a74FjjNRgfGOhaaBtraLYjp36mCnjiF8KuvbrN+5TbcSynAaF1h7fTXd8A8N9DfsIIKErCVUJ0RwKycZ/h1e/240wjc+Dqqblo0OWZpiTJc+AhyPF0vW/RmuZM3xcG7STdTxI5SrpCM2LmDuhzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vMrDlXfp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vMrDlXfp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VEIcomV0YDeDMM3XuYqsL9n7rlMQEeyVItGV6kndUOM=; b=vMrDlXfpCmYWsXheb1TfDL49IV
	OJVXouO8ei+ndqRRcdiheObxAr/u3Bf+p+OJaGovT9MbY1i5G0yJrpc5J/IQFNAmknPqBOnibRjqg
	k/y0p5JdpTTbzy0WlD0MhpvepZwzLUUOvIfXoLWAhN26QbYWyI+or0rNih3rAPS2jwdlRat9Rm03E
	k5c0A8LKJ9PmPJVwR7R6cWP9PAPxjBGBjkuwHpxOrxEtTFHN1UuHPRiQgcy+H6LSf8azMGvlx2uzH
	MkU057tH7yOugN4T8Mqt8vX28Am8eEE8tw+R73aBcDLfdvy7tYI5zcbVP6ikR7PTuSR6jrgLWkKGi
	CZarHgiQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlkZn-00000006Mhk-2lfx;
	Mon, 20 Jul 2026 09:46:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: fix the lock annotation in xfs_mru_cache_lookup
Date: Mon, 20 Jul 2026 11:45:40 +0200
Message-ID: <20260720094609.2191633-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720094609.2191633-1-hch@lst.de>
References: <20260720094609.2191633-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Name the actual lock.  Unlike sparse, clang wants the annotation to
be correct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mru_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index d61ec8cb126d..3f3af2e2e31c 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -520,7 +520,7 @@ xfs_mru_cache_lookup(
 	if (elem) {
 		list_del(&elem->list_node);
 		_xfs_mru_cache_list_insert(mru, elem);
-		__release(mru_lock); /* help sparse not be stupid */
+		__release(&mru->lock);
 	} else
 		spin_unlock(&mru->lock);
 
-- 
2.53.0

