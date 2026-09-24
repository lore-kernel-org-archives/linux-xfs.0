Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9554582FE;
	Thu, 24 Sep 2026 10:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244084; cv=none; b=Cvwu6e5h4j14cJbTYEt24Xs2d/wK4IjlUSqES5iztjdkSN6sVXKPOSGT1YBf5zN9S2JnuQiEmE5dLvBHxsPFoh98gnUulBttE868wkio3x6MCERvSuob1+2/Cm+ohaPw84Xo4IqYqRCcKS7dw3mUPbQ3a+b7FvU9jfDcOWyam6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244084; c=relaxed/simple;
	bh=lPM9dZfOhv9QwbMWo2Z7Tz9vwNZCZ53Ry+c2EyrxvYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGqd9Z8MhqZOGm/x4XpbbQWlXiygfW9qD/M3IdyxjB/qPnptXRnnKA4Ksn5wlV9pNC4YKMilvHKw5ZXFkZ/+C0AaDlS8LdTtv7nNZuazOcFz0e7rxrbOh0p4l49nTk6LhJ5dtaSNtj4XCW7Ym3Dg9pIYFpzETE6Tn8Mw1GfdAU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A22syM0f; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A22syM0f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7NdZmdprY/NNR/EYm30/uaKofqxEvxdb4njKr7zG2Hs=; b=A22syM0fwxCsF0wKHwvTIi6gUW
	SuRQiNKha/ZxGdq7sWl9ZguAb9z6ABi5jvI+2ZW/RSb+iQq4vWHX/VC3hhsR8m5ftGz9+wVF8WkQp
	aFOt137H0vB/GdAN1fdVo6AJj649EpQ6fNehhyDRlwWU6QKC6xFuH0sAZY7VS4Y/jJG7TghVeDBBQ
	gVUNavDLJ9iMtDWfJbzYd+6PfhufnHRTy3ZomOryE21WcFZurKFI2Or3gulVSOpcaZiqeGzXVYMAG
	vNy3rsv/ltlNE+/Mf80Jg/HYETUPc+CeLgA9dEMp48c970SQYvh+91GkXmHVl1W/pp3yfURibC/Kx
	ldVosDzQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gGV-0000000AeUy-0OW3;
	Thu, 24 Sep 2026 10:01:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 07/21] xfs: relase zi_open_zones_lock over xfs_open_zone_put on unmount
Date: Thu, 24 Sep 2026 11:59:39 +0200
Message-ID: <20260924100032.2733101-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_open_zone_put will soon grow code that could sleep.  The only
caller that currently doesn't allow that is xfs_free_open_zones, but
that can easily drop zi_open_zones_lock because at this point nothing
else is looking at the open zone list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 8cdd473d8144..bbdff9abe2b2 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1007,7 +1007,10 @@ xfs_free_open_zones(
 	while ((oz = list_first_entry_or_null(&zi->zi_open_zones,
 			struct xfs_open_zone, oz_entry))) {
 		list_del(&oz->oz_entry);
+		spin_unlock(&zi->zi_open_zones_lock);
+
 		xfs_open_zone_put(oz);
+		spin_lock(&zi->zi_open_zones_lock);
 	}
 	spin_unlock(&zi->zi_open_zones_lock);
 
-- 
2.53.0

