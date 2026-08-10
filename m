Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FC72253EB
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 15:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786376283; cv=none; b=Rc8NHegEo9udAjpihwtYwwnuIaCr6uHpmkq/DdtnsUpdxa7kAmlB0P/EtF52M2kuoC0UuU22JoRXqJzdLGI/A9SFZHgwFac8SjnpbfQ2+bkdTG0E/DLQt5UG7BOUY5UkwzsZ+L/Meh1yC5VqHhvQw3/sSrSUHWOQfTt/D1e3Bik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786376283; c=relaxed/simple;
	bh=brh2R0dMMOtbLAqSdN9HS6WB4BZhqyy+K/VjjnX3/r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYo+CFBTV8+b/xb3la5GHVkWHp4IEB/ScOZ6Fn6rMbfEOghU+mDPs346+8J91beUBU98H5E9RYMkeKoALa6ML9eIymoarzRZ82JltWp0tb9ryIBtnr4pO3jabjBEt/NGOKxf+saPjLtzflxSpeW2snNUtJi2fgsLYvH2Zu0VUpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fLXcmICI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fLXcmICI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TAj9Jk1uP7e00d5wDH8BztmlR3At5GdFxR3jO7iJTmA=; b=fLXcmICIzW4TVuX6nsKt6PX1Xk
	SuFJTEj8vCwSS1YFQXIjmQsIgoQkd/8ZWIMzf3L/9mdpAjZL+HV0c7CGxJAwSzlVWIg+XqvXtUu/v
	213jb1pwDIOaJGr0QxJfNjwweU04XHpUplzOwYz0EA4q7IQWDqhiFCoc2HlJ9j5pMXSCBI2QozA3I
	pBKCPUZbIQMCKyTM+FlRk4BYTw00IF4/Vn2Aotd8wqSUHMqFXD9jrdfQmB7yXFCeoppiEIKaSRLEz
	FK61dACaJAdhRrka9YZ3a6wA4goe/S+YSSRBX2+8LnzamVhfviqgVD6y0vUwPKYWDPaVHa4FrgnAa
	kNpbBCVA==;
Received: from [12.156.71.108] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtS4e-0000000CHoY-2Hxa;
	Mon, 10 Aug 2026 15:38:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: handle NULL open_zone for merged ioends in xfs_ioend_put_open_zones
Date: Mon, 10 Aug 2026 08:37:42 -0700
Message-ID: <20260810153759.466417-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260810153759.466417-1-hch@lst.de>
References: <20260810153759.466417-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

In theory we could fail multiple ioends before an open zoned was assigned
to them, and the iomap code could merge them.  Check for NULL not only
for the main ioend but also all merged ones on ->io_list to handle this
case.

Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2a0c54256e93..c80f05507373 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -89,8 +89,10 @@ xfs_ioend_put_open_zones(
 	/*
 	 * Put the open zone for all ioends merged into this one (if any).
 	 */
-	list_for_each_entry(tmp, &ioend->io_list, io_list)
-		xfs_open_zone_put(tmp->io_private);
+	list_for_each_entry(tmp, &ioend->io_list, io_list) {
+		if (tmp->io_private)
+			xfs_open_zone_put(tmp->io_private);
+	}
 
 	/*
 	 * The main ioend might not have an open zone if the submission failed
-- 
2.53.0

