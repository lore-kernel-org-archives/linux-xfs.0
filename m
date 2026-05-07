Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D664C1B78F3
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 05:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778131502; cv=none; b=hxUmWrM7wYJd20fY64CpgWAYvCPTpmA9Y4Z33nEIxnQxGRSKiMlcjVk881TuaEc7IXzVaCSgzhZYxVLqz5poQIK0kTrvlICWT45tNjuuE48WWn3hxebzVO4Sqa87hZSJwzyeoxK8Tu0AMNy25F3faWIpYFK3nD7uAQTca6yHDIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778131502; c=relaxed/simple;
	bh=nVLiVnGVE2i00HynIVTj3WvLHPN7yXs1VTCCEcuvvuw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vk9Iq8qNui3ankiod10fNf1B5hk6avrQuTpSZD7c+dhvj/bxrj6CMfN8yQY7jVqToGfvFrPr9NCL8glj5uBUMs/WuX6vI/64TZ0HDMM9BhqbNZ5RF1SX7YiQEg/AsbntzOdLJstex0Aj5Ra2VzjPSUnzj0Lfvj3wwmf04H55UM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3J6jeQuX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3J6jeQuX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=DS/f3Ffj9PlKUOOjVqNSbX97IqXKaQgOBcoT/ZBM2r0=; b=3J6jeQuXSn//JQ1NrmNwA7S02D
	z3mSZ4UOezMwvLQcNaNu4rojMZRoYOSDYIerXj+u1tnxaUu14LtK0WSxNvQFeiHATjUH2XdKiNPqm
	9SxDdzGOZKN6c3eI8mmj0bK1YmcqNU0az6HhXfRW+lHcqR8SkcHwyr4AjkH2t7J7lj2RhO5EPMQ1N
	kST14ul+hMrPj2TPTwG/jK5vKCVxQ99HGxWA7LedFgRpI265pG35I3nIbwi45tsk/HNpd1W0650DU
	uuXx3iDkHfCjvD8NSRRvLeT9hhR0GbR4zJl3XeLjhstDr2j77q7pNRjnYxpG+RplWRxNq0LvAoWlG
	etnfbRPQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKrEJ-00000002nkW-3uby;
	Thu, 07 May 2026 05:25:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix the "limiting open zones" message
Date: Thu,  7 May 2026 07:24:57 +0200
Message-ID: <20260507052457.1305016-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The xfs logging macros include a newline, remove the \n, which adds an
extra one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index a851b98143c0..e79f9e652dbb 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1170,7 +1170,7 @@ xfs_calc_open_zones(
 
 	if (bdev_open_zones && bdev_open_zones < mp->m_max_open_zones) {
 		mp->m_max_open_zones = bdev_open_zones;
-		xfs_info(mp, "limiting open zones to %u due to hardware limit.\n",
+		xfs_info(mp, "limiting open zones to %u due to hardware limit.",
 			bdev_open_zones);
 	}
 
-- 
2.53.0

