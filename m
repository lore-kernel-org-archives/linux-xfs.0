Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D85336D9EB
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 07:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782113458; cv=none; b=YNH97iFlnW4ikOZ7/zIYQ+RxzpsRMHBvzoVWA34AsB7AgiIA/6G4Aw9Z4hjSfodEmGsQt65i7xBZTNpHn8gcvgjbVrOf9Eylwvve+6LCJ5RwvZ1sdnKW+K26j5dnCfuSJFwuwbzOny1h2REYZJZPjHFMEhiihy3hOYaQsl5XVhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782113458; c=relaxed/simple;
	bh=qAvk1fJvEZTmbUfMwvuBMTKl4RQi3LziJQBXhYTv2Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GI38zUc1lf1nl4YM0Z5j7o8LcyEoBSPugoV5egLg7RiFoi/VLZ5xDl6Mnb+oC0HCW0j8TRiAlqJfFwYcIfZg0A3bicwXy1hn4mopn9/n5kmoHFYAselQIeHwRQFWr7FGaqhaOP3cT+0IdCpapnf9z0GOaUaHZFwaYdGxVTFEH/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EhG45Jll; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EhG45Jll"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6tFCjDDfW4WTJ2/qaw90UPvMCMUxp79gRDsdW67luBw=; b=EhG45JllEg34brsWL6uQVZ0qd7
	EyA7aFQ/NyJ7baMjwh8Q9/mcTdmsa/4LiPGAV31aKWg1NnIeL2Hge6f4ZCjHl/btvT99B4sVw2OG1
	GTUlwv5mZii0gdUHLngkrd/nF5O0NgRBBXygElL2rv90qqjo8ZJAhyMenGUr78tvQltuGAKyxPkig
	4GWGosh6P/Wrp1RJA2n1HCw8oQIkZLWVVvbxlx23dVMg+ZZK+XswzUAVPTmr6v5Q0xJ/DvUca+6A/
	tdV3BXdgE8AUHrkG6O0/uOedNtB1Gy157atzKSfvdSq8XFEdxZjqMzSY6QpNtAZU+MfUPoW7TPmrg
	3LmSixmw==;
Received: from 85-127-105-127.dsl.dynamic.surfer.at ([85.127.105.127] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbZ7P-00000004Xeo-0dgI;
	Mon, 22 Jun 2026 07:30:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: fix handling of synchronous errors in xfs_buf_submit
Date: Mon, 22 Jun 2026 09:30:04 +0200
Message-ID: <20260622073035.1370904-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260622073035.1370904-1-hch@lst.de>
References: <20260622073035.1370904-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Synchronous readers and writers already run __xfs_buf_ioend from
xfs_buf_iowait after being woken through bp->b_iowait, so we
should not call it here, which can lead to double completions.

Fixes: 4b90de5bc0f5 ("xfs: reduce context switches for synchronous buffered I/O")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 651add22deea..ffaab0feb230 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1403,12 +1403,12 @@ xfs_buf_submit(
 	bp->b_flags &= ~XBF_DONE;
 	xfs_buf_stale(bp);
 end_io:
-	if (!__xfs_buf_ioend(bp))
-		return;
-	if (bp->b_flags & XBF_ASYNC)
-		xfs_buf_relse(bp);
-	else
+	if (bp->b_flags & XBF_ASYNC) {
+		if (__xfs_buf_ioend(bp))
+			xfs_buf_relse(bp);
+	} else {
 		complete(&bp->b_iowait);
+	}
 }
 
 /*
-- 
2.53.0

