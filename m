Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E322153EC
	for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 09:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739784741; cv=none; b=gc4t1rvdAwv+SbXAR+rVaVcnYRBJspIv6JWDGFcu7oObbl0ETpu+0l+dAFp8DHJtposlrTgVtAZ+oOvneqhWEkffXEQWbdJuH23NtfpR3ZKqS6k+7QNHnfPQAz/b3vVpj4eeCxJA6rX9cXV5UCFMNyL/VIljcZOyjRg+8xS5nRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739784741; c=relaxed/simple;
	bh=k/meAa860+T3MCtZzqE4nN+3uq9fY8QeiFtrNUnFXgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eb62uTSGRuHr4tdyH1QA8VPLjsxc+k7kUfANUjrjr7KPQ+PpPppXjYZso7PaePiUhGJc+B8v57Nrs5yrbhDrade77puPNNzx44VUZrdkVEyeRwoKAeE83qUwJYLsKsx1c4Yalsb9WXGcbo3IEOAYRkIT8/djIeP9Kkz4E/fgQ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B+7y7wLT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B+7y7wLT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8ShMEhhMFAbUkuYQ3oBEFRM5BWUVpQKn7ZYeUTDfGi4=; b=B+7y7wLT1ztxssppD+rMwshlZ/
	630mv7kTYV6oY0iSJXe9Nm+Lv31AdsFecCF1fjFlZeBH4W7iXTnXFOOZp4t4mtv5t/T9sgRsXBHAk
	IzF6KRHnBAFB7oEnBVL4jZ8UKkvEP/Y2kWqGnHZ2z6b9bTvnqyw8dBeS0/8HilCwA0zBOQrjCl8KY
	Z9mgXEtSH33IMjPIrsN43ALOoPGoDRuT3lkAetSpPevIJXKrvvBuAYvaYw1vjDnWMOT8y3s4YbSED
	O7daEVNPB3RF/yS1hWfRVhvCjamBeuloNcPJW7qtMk32f1+KprEcfBcVKqMATW7mIzlPN2+1iWfIY
	dp2f3S6w==;
Received: from 2a02-8389-2341-5b80-a8df-74d2-0b85-4db2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:a8df:74d2:b85:4db2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tjxUB-00000003wIt-3fp3;
	Mon, 17 Feb 2025 09:32:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: remove the XBF_STALE check from xfs_buf_rele_cached
Date: Mon, 17 Feb 2025 10:31:29 +0100
Message-ID: <20250217093207.3769550-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250217093207.3769550-1-hch@lst.de>
References: <20250217093207.3769550-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_stale already set b_lru_ref to 0, and thus prevents the buffer
from moving to the LRU.  Remove the duplicate check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f8efdee3c8b4..cf88b25fe3c5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -99,12 +99,6 @@ xfs_buf_stale(
 	 */
 	bp->b_flags &= ~_XBF_DELWRI_Q;
 
-	/*
-	 * Once the buffer is marked stale and unlocked, a subsequent lookup
-	 * could reset b_flags. There is no guarantee that the buffer is
-	 * unaccounted (released to LRU) before that occurs. Drop in-flight
-	 * status now to preserve accounting consistency.
-	 */
 	spin_lock(&bp->b_lock);
 	atomic_set(&bp->b_lru_ref, 0);
 	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
@@ -1033,7 +1027,7 @@ xfs_buf_rele_cached(
 	}
 
 	/* we are asked to drop the last reference */
-	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
+	if (atomic_read(&bp->b_lru_ref)) {
 		/*
 		 * If the buffer is added to the LRU, keep the reference to the
 		 * buffer for the LRU and clear the (now stale) dispose list
-- 
2.45.2

