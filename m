Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782796;
	b=ufJtyGBpYh3TMPyL1JYzQCXIbTJsgkdIWq/33K++1mo24Av0mgEnrJaNR9eMmPC+iM6+
	 Wm50LC/rDuI/svrltNNMrbpLkOIpeffUig1OujmCafPSvosFo36hYpfxTDk85n7AiSi5l
	 uOfzCsqU4GOhVLYtDF5+KzYORVDUzNJLP9rPNNsjm5WTwcZUeWCrOt4i1NlJ04POGqOqN
	 8+eY4A2oglB+Tn1Fykpu/3ORLzKJhAN8eQZci3lJcDfQgFLsG0yF0h3uNhihAYfEBXIBD
	 NRy2b3M0w/iVQOiWXMSEHIzzyn2S5/fLFOeW3pxj5AmmRlTClzaKti4klv8V8eJCz7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782796;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=QY/70uK4SJmDwEoWtP/Y9ha+XU199xdVhmfU/lO79iw=;
	b=VeYFyEbn2mSnwv03MFuKIJ5JMdPx/cWOhqwauFkCvwayUOEP9+6EEb4sOhZkyWQMdwAW
	 I2OK5v/qQL4SPr80/T+rs8HZIw1y4NWU20kDH2xgKwd39EYrUTsqmVIUe0440NMxRanzZ
	 MrujjJNpIgjW2JnY93aOzINAC9V+LgyYNno6oT2kRUelX8QNqFJ5I7fN2Zd2yLZAtWLB9
	 9pwHQHDhRqsXZ7NhfXYmQ424wnrRkLDW1vvF0pXWJdlZqHFq4rMS1y4YumPafwZPQvTmR
	 DMGRsLA4Piy+0Jk4DyDboO2d44fL6vkqJtIQSll9RPmykM4upXP2ehmgg5FcesFGsow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=tB62sjuu;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF38606D801;
	Wed,  4 Nov 2026 08:59:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FF38606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=tB62sjuu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QY/70uK4SJmDwEoWtP/Y9ha+XU199xdVhmfU/lO79iw=; b=tB62sjuu6T+XUPBYPttYaSZvSY
	zHD0SlGY2Vnq6admzyHg/mLTQ88Q0eLg18bQhWF1lMRAh9YKdpL15NbbH2OIzLaR9A3WfYq2lhlSv
	rguG6cJrnxdJybUWCsMAzrzIHx0jeEJlI0pchCDC2dQkIbTZizBqeTKyi3/+YUMGsLNkJxiVTDCAh
	A4FWHvJI0iFWbZWPiz18KkQk6v24kGCDI4Vi08AdRXzJt/Bo5IS0CChaUcE1m6qoqNmjrKJY8FG+j
	U4pkGqHIAoFD9t435H5pa6BzgO6W1WXitUhhcEP2U8EOXRUAmPYMIGYKvTYbQ9JqheF/Rptr4AzXK
	VoVYhdwA==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqZ-00000004oNa-3K7R;
	Wed, 04 Nov 2026 08:59:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 08/25] xfs: relase zi_open_zones_lock over xfs_open_zone_put on unmount
Date: Wed,  4 Nov 2026 09:57:12 +0100
Message-ID: <20261104085929.317544-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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
index f827ea3d899a..8909c8d0f5fc 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1037,7 +1037,10 @@ xfs_free_open_zones(
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

