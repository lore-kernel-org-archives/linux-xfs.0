Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F672FA0C4
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 09:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540786; cv=none; b=Dwdo/3zRgJ6+Na+PPEk7tCeIwMaZJ1B/KhBrBwKPu7FDiptmX9J0fDKzKFeQeWQeMkJux7d3ZG3Rqa5iRFS+zVPG0fQwl26m5Aa1OpXjAs6iXvTSTKMohhnsXQNL8swH+ti21zOxQqdjbEVplh9SS6dKSj+danAgKVfI7dNudt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540786; c=relaxed/simple;
	bh=IYa5tmduJc98ZGa5Sg6Psz8AsEZGlgGRIjnE7f7AA+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8k09H5r9C9IWet28yuJ1VdqV9bPLlsQPbIINKkCez4XOvdgRVHT1ITbm9xs+QxImhO/Hun3CzQwvS4kufcODjwsQ8Lh90D31V5obrxlzZE9TSrIwSpbUe/a29HQtgsPCwMlF2Sl1dLhgSXSS2vM8Mm9lYHE2qisvqUdELoCE8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=07G278xn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="07G278xn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=76Xve2O4hTrZHIUt2eVqTyQES1zcs3TXhwZSVORSrJs=; b=07G278xnnN017besig29T2BYco
	IXnoCiaoGfeU7ndKiCxXJW5kg6z6U449kBqZnGIBwTSzbPRx83mdPCIL50UA8UoDFg2D0x4ga4yQ8
	dA1J9FazspHABnJVZ2NwsvmAV+b/3NABO/G/pinArBl+Z37PEEHouOgXer4P4CVjxfStVu92MAxCq
	oIEu82JeFikh01WZBIwOtjsTlwyixiJFv8EEZYPbYL5E2Zq3l00zVg5THiGqgGd71w/l3Qx7Yhm+j
	lSOjZCX02FheEIMvWTV7Qj/nAhHCTYab8HnnfJ9HKkmM+xzHbyjiSUYeSRIonCw4jstThCaiGLsNs
	lc4bvcdQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlkZt-00000006Mhz-0F7m;
	Mon, 20 Jul 2026 09:46:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: add lock annotations to xfs_try_open_zone
Date: Mon, 20 Jul 2026 11:45:42 +0200
Message-ID: <20260720094609.2191633-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720094609.2191633-1-hch@lst.de>
References: <20260720094609.2191633-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Improve the __acquires and __releases annotations so that the new
clang code that is a bit more picky than sparse is happy.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 7d13fa7ab30a..3f42202c3f61 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -475,6 +475,8 @@ static struct xfs_open_zone *
 xfs_try_open_zone(
 	struct xfs_mount	*mp,
 	enum rw_hint		write_hint)
+		__releases(&mp->m_zone_info->zi_open_zones_lock)
+		__acquires(&mp->m_zone_info->zi_open_zones_lock)
 {
 	struct xfs_zone_info	*zi = mp->m_zone_info;
 	struct xfs_open_zone	*oz;
-- 
2.53.0

