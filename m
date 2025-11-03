Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB9B2FB085
	for <linux-xfs@vger.kernel.org>; Mon,  3 Nov 2025 10:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762164917; cv=none; b=asNtapkdIGsBiucrhMANKBuY7srI4P4cVxa6wj9hqAaTlPLx6mI8xtlXKmqBD6+8NSUpVpqpB5QHH7iqmir97Qu9+q0q3d78wQf0nPKepYez0B636lWT07syp1ojkl/MIf4OjQ4XyPxB0nUlZlt1N9KmBrUkYjCOuc0+5F5NJVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762164917; c=relaxed/simple;
	bh=5rXmMaavWkeFW0CdyIU7zDQYFAk4kujQM+h0Ce14G8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U7w+K5CnbVYQ7L84wL9fVcnZeK7G62crgrgvBlX+ILAEuihO+ZNPVqzaRrZVabNNPoBXnN1awvSWOMp7BDDkGjTyRvFpv/aHpIxocVwm7ObVwQbloO4Ve8K9NHJRHasBInNJ6QemDT/4KgEkPMegMEpSmjbbzweX6FupkCpUOfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tACqj86t; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tACqj86t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=nPcvfBCz09nK/eqPieLtD8IBysGgYJOul7nQB17zgGY=; b=tACqj86tgyjnuOjGGDZnV0V9W+
	KZsCvMA6XC0oAj4OHsX2ZxZaTPdfSbh0wxIzIlZ/cf1gECzweztzoVTSRDZ/cwkVXLeo5W+lO8Sc2
	7L2X+PGaNtumZpCIcf4TaZYcU8p0Tfonpm8PN5I4+Y2HjnxebRd0V2kK/iITbJMAJm6BzvCRd9Foa
	rp0PR6VRopm4duVcmJz1cd9otx5HoAwRsB20tvz/tqKkJAfD6ggZaftgi+ne4eaZagAT2LWMug0Pb
	xct+LnXYZp2OG+/opOZXhjAtIWbpKKAsGgpuvIdW/jJtGyP7ME2y8qxpYIIFKBogE2Xy4STb6usFn
	ExZ3ox2A==;
Received: from [207.253.13.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vFrak-00000009aTa-2ZbF;
	Mon, 03 Nov 2025 10:15:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: Hans.Holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix zone selection in xfs_select_open_zone_mru
Date: Mon,  3 Nov 2025 05:15:13 -0500
Message-ID: <20251103101513.2083084-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_select_open_zone_mru needs to pass XFS_ZONE_ALLOC_OK to
xfs_try_use_zone because we only want to tightly pack into zones of the
same or a compatible temperature instead of any available zone.

This got broken in commit 0301dae732a5 ("xfs: refactor hint based zone
allocation"), which failed to update this particular caller when
switching to an enum.  xfs/638 sometimes, but not reliably fails due to
this change.

Fixes: 0301dae732a5 ("xfs: refactor hint based zone allocation")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 336c9f184a75..f5ffac9819a6 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -615,7 +615,7 @@ xfs_select_open_zone_mru(
 	lockdep_assert_held(&zi->zi_open_zones_lock);
 
 	list_for_each_entry_reverse(oz, &zi->zi_open_zones, oz_entry)
-		if (xfs_try_use_zone(zi, file_hint, oz, false))
+		if (xfs_try_use_zone(zi, file_hint, oz, XFS_ZONE_ALLOC_OK))
 			return oz;
 
 	cond_resched_lock(&zi->zi_open_zones_lock);
-- 
2.47.3

