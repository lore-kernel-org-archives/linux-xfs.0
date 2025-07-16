Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50E2341AA
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670478; cv=none; b=UrDVdMbngJ6wWwafZ5Z47REkyR3yOrh4camsPd5skcWWMRCe/7HSG9/jH2G+H3DK3W3EoSOBHCrx6w4FAlSERb2ag+epDQY1UkEA/WRyjspNGmgslWKiXRPgVmB1t9U9OjXCSsOqW2DoHo7mLCt2NlEkl91TkuYhH97Dxt9WBuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670478; c=relaxed/simple;
	bh=ztLtyDQ4ckwa8DruvkDn0kP7RazIyrm+H1/ucZ0XrLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIjXzxD58MtK6YOEcITgWnrsHH0Z09NLWaTWqvOoIr7ZPjPnd3qSHVvOReClw/U3OLLqVZv6caGTmgSJHwDfY49XsXMD1y4P/cy52hem0LgiKSh4Vc/TfmQQ/7BM5vKkeM7yTvuqSmeGRRxzwQsaTv52uBZQ9C5lfMuMfVoJeec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jAEkwtDM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jAEkwtDM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4pnE7mjmEL3fJYI/Qy1Mkfu/uVqWM4ZvIFnbHK19b6g=; b=jAEkwtDMURX4RUGYJFWl9DcSf5
	qx8QHdpZ/ElyPFfzazqg537pln+3FAbp7heEJ5adHiOTJdkeD3XS7u2yK/GZPR/h3HxCIJSZU9cVs
	GwCjw8oWXfVwWtEj5H1CUBszXrBGpeTD+QrpiPo2A0ijldZK2yext4aWHQhhsOMuvXB69aJNc7+hM
	XYgo2xGlho4bojzXYIi/VHRMa9LoOcYvaEtNIe0BdQM743T6Le892mKYRCVny6eY7pnPhvqbeowut
	pJmKJKc6i/jUA63BdpzR8oLvRzuzuKgc8qAGkkLALmidMgYpcq4xJCTv281bjyOHsYUNfXf4kdU9W
	HfPxUroQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1ed-00000007iOo-0xK5;
	Wed, 16 Jul 2025 12:54:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org,
	George Hu <integral@archlinux.org>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH 5/7] xfs: replace min & max with clamp() in xfs_max_open_zones()
Date: Wed, 16 Jul 2025 14:54:05 +0200
Message-ID: <20250716125413.2148420-6-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250716125413.2148420-1-hch@lst.de>
References: <20250716125413.2148420-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: George Hu <integral@archlinux.org>

Refactor the xfs_max_open_zones() function by replacing the usage of
min() and max() macro with clamp() to simplify the code and improve
readability.

Signed-off-by: George Hu <integral@archlinux.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_zone_alloc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 729d80ff52c1..d9e2b1411434 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1133,9 +1133,7 @@ xfs_max_open_zones(
 	/*
 	 * Cap the max open limit to 1/4 of available space
 	 */
-	max_open = min(max_open, mp->m_sb.sb_rgcount / 4);
-
-	return max(XFS_MIN_OPEN_ZONES, max_open);
+	return clamp(max_open, XFS_MIN_OPEN_ZONES, mp->m_sb.sb_rgcount / 4);
 }
 
 /*
-- 
2.47.2

