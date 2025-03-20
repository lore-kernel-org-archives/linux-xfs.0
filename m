Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F52D1DE2C2
	for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 07:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742457157; cv=none; b=uSKngJq7W3HnP4osVXK6adyz1JnUNHLMIHs+OagEKdEukLpYBFmfqf5UUVX9mk9tAagRRZbZKhtKcWSe7I2YLAnmpJ3iOe1T5L26Q2Pdov/d03HSWA6VI8imgtMQC3INWL8LY1C57Aopr7+R4Z1j1x5B9UVuPKFtuMVNyBeZBmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742457157; c=relaxed/simple;
	bh=n6Rc4BjZsfiip45UjSTgQuihCuG9DDEdPoAl5eGJSiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBgKudGiSfVKzllWMFrYUNbfRvS+7cFiKuu7r2xXQFgAP6UuICJzkjJzuPrwrc+m2SrlwoBA1nn72eI6cxQFoa/Wxi7rgFUXkOWdZODuT9KI5va5aET/bPUd+KHJ0ZVaX8ySwufXhkRG2MVpBql38sPdSly6JK4SyB0iMhruK90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lq8Jn2F0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lq8Jn2F0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jPcJ0KutlAYUuxcOo81BiTXTszbknOZgeCRZOnAmO6w=; b=Lq8Jn2F0KYrtcfLA+buen2lRje
	fK/YzjUSC+sK9F4RGF/+ghyKmXpChmNR8OIPNQj0TvjkDc1busTlqt5tRSWWr2WzG6qYOLAz9HquF
	F6xuF0OEvZvj4zTHlD8VoyY2ua8THJJtOyhlobfUv5vflb595Fuk9pmwuqkhxHpEHpjJ7bn5n34Ny
	lGxQXi/5WS3O2GEpBqnTAe9rTgU8/Fb1eRWJ2LX3vJey5qruDE1wk6MC+twd6G2H89dT2/ti2HMsl
	+rcnANvSv+iCQM4JrT9KLLjCTq06GO4NXL5PfovA8a0Nksy+ezBn8fSIsC0nrDpHSt+FsaCOlc7t9
	YDfothhg==;
Received: from 2a02-8389-2341-5b80-42af-3c26-e593-7625.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:42af:3c26:e593:7625] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvAhe-0000000BSls-3tG2;
	Thu, 20 Mar 2025 07:52:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: mark xfs_buf_free as might_sleep()
Date: Thu, 20 Mar 2025 08:52:14 +0100
Message-ID: <20250320075221.1505190-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250320075221.1505190-1-hch@lst.de>
References: <20250320075221.1505190-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_free can call vunmap, which can sleep.  The vunmap path is an
unlikely one, so add might_sleep to ensure calling xfs_buf_free from
atomic context gets caught more easily.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8e7f1b324b3b..1a2b3f06fa71 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -105,6 +105,7 @@ xfs_buf_free(
 {
 	unsigned int		size = BBTOB(bp->b_length);
 
+	might_sleep();
 	trace_xfs_buf_free(bp, _RET_IP_);
 
 	ASSERT(list_empty(&bp->b_lru));
-- 
2.45.2

