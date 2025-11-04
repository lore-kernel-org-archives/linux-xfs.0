Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D941F163
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 13:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762264259; cv=none; b=dgJ7q2Bt9zHSjGcKo79V90gyvNZhYc8WlTcjNom25ksPYkO6PE/Whv5YxdOCj5nsTeSAkhpAXY6EdVfS+db9rDYohjwgnnK822ScfqeDHAlnEQe2gckV9LhYJXufObky/O/GyfK+5kvkkG0Pg9++aXMMsmLeB8eFzbyfETcY8T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762264259; c=relaxed/simple;
	bh=WEwsCWW70IDzFDmOZ1rrHCtUmHZlpUk88tJGR1bCiY8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aWMdJ5P7XK93aCX7e4mtDyLVXoqi3EPodyIB/5QGHND0H7Ku2uZNsnueNGyUMXzStinqnFoorfPfVkvBEYemofZVYEugzaSLoMYGmQ4U9AQiujyonDh+3aSaWvB7zOE1Dx92Si9Fj+hGKeAZY88jEysCUV8g8DxWQ6keTNVu8J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Wit/nBab; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wit/nBab"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=z4xGhYkz/QPHj6JhusaR+naPRt5ryzDfJeV45FWxizM=; b=Wit/nBabm2FC227IwFM1KbBGND
	ojjmpv0knSpT3c9IM2e+eSrN1VzlhN0BDVhkXVJnOjYaQcaiFJJ20nzg04sSvxXnemZzhRqOgLST7
	BVDhh1G0f5cuUOpVNSo2P2Mnu4lHp25n5Ewxxkj3CQ8DETqbdrH4bZjZXTAfEiu2mN24WA5P08nmB
	cOCb+EANpcpEyEYNHb6FVBClX5NKZ4+2fGHN2DEbdBYZfQNBtjdcmvd6P20c8W0HQIrYH3MvL5wer
	M9Gf8unRn6kSMPCN1gBgyCVYkqWfhcS9arH0c++NZOd9H3BaBwHcooSWjhgNw+aBhbHcRzKXGyGHa
	WHgKSfeA==;
Received: from [207.253.13.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGHR1-0000000Bv1W-116c;
	Tue, 04 Nov 2025 13:50:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix a rtgroup leak when xfs_init_zone fails
Date: Tue,  4 Nov 2025 08:50:53 -0500
Message-ID: <20251104135053.2455097-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Drop the rtgrop reference when xfs_init_zone fails for a conventional
device.

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 9c8587622692..e123d8345d8b 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1249,8 +1249,10 @@ xfs_mount_zones(
 
 		while ((rtg = xfs_rtgroup_next(mp, rtg))) {
 			error = xfs_init_zone(&iz, rtg, NULL);
-			if (error)
+			if (error) {
+				xfs_rtgroup_rele(rtg);
 				goto out_free_zone_info;
+			}
 		}
 	}
 
-- 
2.47.3

