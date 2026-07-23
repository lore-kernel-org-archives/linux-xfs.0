Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63FF440A19;
	Thu, 23 Jul 2026 14:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818244; cv=none; b=qiqH7Asi5DPZxPunORk0FXrfrpp2cXfevdgcQBVlcDTTalMZPM16U9TgjVjlmpI2uk414Fjj71/0nx+C6cxCDTPsXR9sZWGzIa951xWanYh2pb1ODuVVeNKzQsZV6qiMWWtZ0qrq0DMzS+9nk0/QEDYgg8/E0DnMmu3kjjXtlC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818244; c=relaxed/simple;
	bh=hJB7BsptBIRrpjuCt/GFquUpHUZOhrbztd/k7eu40/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7QFqCisjtz+g4YiqLPevTLowdHSRiKtgVwNwBTuYl617BEB1Lva3eul/DMNKPjEjYSjv+G3JcbB23iOFSyYfsqWKX7HQOOM5RoMqFbOCALJvzz/jw58AxbmPsbOYi+sKuNkfIkH396UBk2B5KWKh/w/nAyrticYrcpdgGmeZBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r+tY3d8y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r+tY3d8y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MIPgQENIykshuY3a5UEAjqj+/zGiAh8sjEzXeOF21lo=; b=r+tY3d8yaK+35lp1BYwEuN+dEc
	c/iKHdPZHzJMgrKGdYf5y5NdxljTGqUU0j72TDN7yccOt2DeO1TqKEnja8y121m5TtbtQtkUW6oST
	38aCNwrjMYcWY4GBYJ+U0srk17cnf3cjFgN5p9ALQzg9t84+TRaOn7+FA52Z1sV3W931Yo09iinZq
	Z6ketSzKT5FAXzSvpHng8V90sRgh27erAUVDHdgL/9BU5Wjx42eerwDMJZ6NSu85X5wzXInZXsKx0
	0hU+5rUMywNl41nwm8wV9BVYLNIfhKj3M/kagAjAeiu3EagirFYZFw8bW54ILnu4ko86CbthMShPb
	zQn+fHyg==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuky-0000000EXJe-34NB;
	Thu, 23 Jul 2026 14:50:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 08/22] block: don't delay bio task completions
Date: Thu, 23 Jul 2026 16:49:33 +0200
Message-ID: <20260723145000.116419-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723145000.116419-1-hch@lst.de>
References: <20260723145000.116419-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The delay causes a more than an order of magnitude slow down when using
it to defer the T10 PI processing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index f228940d6b42..79fb94f85a5f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1811,7 +1811,7 @@ void __bio_complete_in_task(struct bio *bio)
 
 	if (was_empty)
 		mod_delayed_work_on(batch->cpu, bio_complete_wq,
-				    &batch->work, 1);
+				    &batch->work, 0);
 }
 EXPORT_SYMBOL_GPL(__bio_complete_in_task);
 
-- 
2.53.0

