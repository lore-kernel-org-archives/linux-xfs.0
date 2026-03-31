Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497C936B046
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 15:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970907; cv=none; b=Bf6Xg1JK8J6U6qL9y5Fz0gh8QNvsycXXWUNCD00qtSmeHgQxi7ffmDC+Wgbw9/6oWV/hrYYQpiNKgrMqoyOBNA1jwNz92B3tUptdCfCEFXf8pWnYWqiZDtHTXSkhHu68lWD9bx3vtBMnLjSui8YSCOCQ8QnAzOkUn43e0kmash0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970907; c=relaxed/simple;
	bh=4QfnCUVQsavgmcFegJuOADPyypGesQ4xwMlG6Sy+sV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/DRc0hJ3oWtOS94hZTgP5MiqUpGwa5b/ap3M167OqR6P/WOsDBbVXFoGOyLCb8EMnTzMOS/LwiEm9fpFb62a3BDPLwRA3cD0/gKjHWViUEzjW5z0ig7cjZXBUfuDIC2YNeQe5kyurXSxydZtX8GJTntrh+ztr8TLR7ciYYBlz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jWzO6s/W; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jWzO6s/W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GKGL6alrC3ZrPWq8pBlqN5uF9BsLBuRx3sKcBr/ooYY=; b=jWzO6s/WyDYR2ExbPiZRyibfmu
	M3QkWsFE6dlUNAcY3vPnYNuyWdETZiQo+64NQUcLXTT21cIXDvzyqnprR8MiLVyIqZAfmz2/3mU4Z
	ysJBL8OvwEtB9aQ53NHxIsqugu78iWc1UtsVledJ0Uz0wAozy5Oa6jZ1iDYqDBGfr/lisjz90xIU/
	DkyPH/bO7sJpS+U1B1Sz96ZoYxMquwZu56wgkZpsl9yeah79vJePdET+fSw5awHgq8WO0rNBffVeH
	5/i3aSEmcD57U7Fn6cn5DsAB44G8rDeassHiU2BrgBdNVJN1SsxXWDFiAi2271WFaSPxnJcQD1V7T
	ucUXF8WQ==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7b0z-0000000DBG4-1slt;
	Tue, 31 Mar 2026 15:28:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 9/9] xfs: untangle the open zones reporting in mountinfo
Date: Tue, 31 Mar 2026 17:27:31 +0200
Message-ID: <20260331152751.4048218-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331152751.4048218-1-hch@lst.de>
References: <20260331152751.4048218-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Keeping a value per line makes parsing much easier, so move the maximum
number of open zones into a separate line, and also add a new line for
the number of open open GC zones.  While that has to be either 0 or 1
currently having a value future-proofs the interface for adding more open
GC zones if needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_info.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
index dcdc1dd206b2..47b475e21af8 100644
--- a/fs/xfs/xfs_zone_info.c
+++ b/fs/xfs/xfs_zone_info.c
@@ -95,8 +95,12 @@ xfs_zoned_show_stats(
 	seq_printf(m, "\tfree zones: %d\n", atomic_read(&zi->zi_nr_free_zones));
 
 	spin_lock(&zi->zi_open_zones_lock);
-	seq_printf(m, "\tnumber of open zones: %u / %u\n",
-		zi->zi_nr_open_zones, mp->m_max_open_zones);
+	seq_printf(m, "\tmax open zones: %u\n",
+		mp->m_max_open_zones);
+	seq_printf(m, "\tnr open zones: %u\n",
+		zi->zi_nr_open_zones);
+	seq_printf(m, "\tnr open GC zones: %u\n",
+		zi->zi_nr_open_gc_zones);
 	seq_puts(m, "\topen zones:\n");
 	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
 		xfs_show_open_zone(m, oz);
-- 
2.47.3

