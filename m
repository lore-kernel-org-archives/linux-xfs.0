Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9026382F25
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849296; cv=none; b=b4qYdHp/Fm2hFX0LG8XQOft8Z8inntfufvw7VngV6VgqkyyTm2KdIhiI0uIeF0O7xCNU7CHXuMCCTpBoSyMOj7kXhF4OjbPip66j3pD93XY/8LHKBVJ7CIu2Emb5Mmuz9dc5pNK2Xi6AHL3cwNcojUM60kBIYknFH9MWDfa5pUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849296; c=relaxed/simple;
	bh=/OrABDIilBt2+OC6jUKL8k9nLym26AKcILw3IhSNJ7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cI3UopPNQBgPoAdcw88o2pYRRHAAcMnZ6b67B/Dab+GvuiYeppeRPeWTedw+fw3myFfLf2so1uvMboUTxFV2F73Ivnw4LPZwIFVlOdCZTsyT30aFu6nzFQiItuNHXi2ZKUNqazDAaCo3d3EJV/qU2qVvAzl1bOnzDAU3gyZq6wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zN8WjiIh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zN8WjiIh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BIEkOVNsHssP8esdvn6k1lUucb2/WCv8Uk1/vcYhEWk=; b=zN8WjiIhALG8nIpXEOi1RifOrf
	4+6Fn9OmqtM8azQXmphz5iVZE7KSuGtHMHNbE4s4/dzOqtlgw0zMFMyXd7PXULac0sgqL4i66kyV/
	KMMMV8anE4DZfXKTxmcZUjBnrxlvfgbr9NpUQFUaNQcK7VQOzBFMy+iyGpCPDRdxRd6foUuHKcmZC
	tpxb80voYC349j3xsXH2nmQRK3zLH88fX5vjVYRizGJF9E7lN96jvloqzAxvDjPMt05aTd+ANNky+
	SGZc4Yxbmfl5EQGLKV4U9HgkCTIhuvIBVhp6Hol+6HaK4NhjggIUa/tTk33O0ZTTrZz4Db90Ml+Ef
	vzEJbT3w==;
Received: from [81.201.198.26] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w75NV-0000000AeOd-0lmy;
	Mon, 30 Mar 2026 05:41:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: untangle the open zones reporting in mountinfo
Date: Mon, 30 Mar 2026 07:41:00 +0200
Message-ID: <20260330054111.3855818-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330054111.3855818-1-hch@lst.de>
References: <20260330054111.3855818-1-hch@lst.de>
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
the currently open number of open GC zones.  While that has to be either
0 or 1 currently having a value future-proofs the interface for adding
more open GC zones if needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_info.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
index a2af44011654..8e56181021b3 100644
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

