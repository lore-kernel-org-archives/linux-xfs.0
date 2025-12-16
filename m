Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB41239E79;
	Tue, 16 Dec 2025 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765906232; cv=none; b=Xu+9CwFr0avdRXN2iMtPDh7fwlqPxqhWzZaRDxwsGOqNxzoNUhyD9+uqqQUkGJtwS2Sh2XRrJ7fM4t04IxZCdmR5l0Q0jKoRGt7rbWtv93uYIA1x3GkzELOs/Lahg7r71Hw+NsuQoUa2F8Cnq4oFU5UaKfph4oX2vhYNMK98xDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765906232; c=relaxed/simple;
	bh=61Lwl7zv4haxPqHfSqiilbhWMNHGecr1ePxw9uQzKOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeVOXlTfPtwpcfk6YI/EN86vuStZXv2ib6JXgwhO9u9AB6DF3xeFw7V/BUZzm1geW55ErfB63NmeN90kr9wY/3ZqPx0CVYU9pBhdzKV4k7A1ZAVbMaoR7v6vgK1fIpWmQH44018dr/6/x932LlfjgP/CUhAKQPfXi4ZLTHty3Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uqOJClMo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uqOJClMo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SdXPrR69PiW1QRePlnjbjr3is4+sa0ZSjp8rFZYxSTs=; b=uqOJClMoEr6DuCRkSS/Mqp64HB
	vKlbKweACwbPVG7NdDwQsGWAwCUOYiGCuNN88a5dlGneCi4GCnugk9Gk1m5NK1CElc/896LlI8ov3
	bPa0Nd5MIiZoiz9iAoF60xcI8w7u9SbzdK2c4Q1fuPP21GbKoWiB8MgbMKVw/mRJOfPtZ4gNfa6wM
	JmlUDyk/+q3jzAPmVhms3P3LWDLWVXu9piesk+BpCE/8/v9CpHvGydyN8E8CRM7M8/EJ9VUDMsJCx
	ZDTdOfW0JUbC2ja+xBGkwNSOp47NmEBZXmG3oTa9xxCRGyRESl/iFsJde9vPHg27Wr6z1In51eh6U
	0Rjg4qgg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVYsY-00000005cDG-1OuB;
	Tue, 16 Dec 2025 17:30:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] xfs: fix the zoned RT growfs check for zone alignment
Date: Tue, 16 Dec 2025 18:30:09 +0100
Message-ID: <20251216173014.844835-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216173014.844835-1-hch@lst.de>
References: <20251216173014.844835-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The grofs code for zoned RT subvolums already tries to check for zone
alignment, but gets it wrong by using the old instead of the new mount
structure.

Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Cc: <stable@vger.kernel.org> # v6.15
---
 fs/xfs/xfs_rtalloc.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6907e871fa15..e063f4f2f2e6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1255,12 +1255,10 @@ xfs_growfs_check_rtgeom(
 	min_logfsbs = min_t(xfs_extlen_t, xfs_log_calc_minimum_size(nmp),
 			nmp->m_rsumblocks * 2);
 
-	kfree(nmp);
-
 	trace_xfs_growfs_check_rtgeom(mp, min_logfsbs);
 
 	if (min_logfsbs > mp->m_sb.sb_logblocks)
-		return -EINVAL;
+		goto out_inval;
 
 	if (xfs_has_zoned(mp)) {
 		uint32_t	gblocks = mp->m_groups[XG_TYPE_RTG].blocks;
@@ -1268,16 +1266,20 @@ xfs_growfs_check_rtgeom(
 
 		if (rextsize != 1)
 			return -EINVAL;
-		div_u64_rem(mp->m_sb.sb_rblocks, gblocks, &rem);
+		div_u64_rem(nmp->m_sb.sb_rblocks, gblocks, &rem);
 		if (rem) {
 			xfs_warn(mp,
 "new RT volume size (%lld) not aligned to RT group size (%d)",
-				mp->m_sb.sb_rblocks, gblocks);
-			return -EINVAL;
+				nmp->m_sb.sb_rblocks, gblocks);
+			goto out_inval;
 		}
 	}
 
+	kfree(nmp);
 	return 0;
+out_inval:
+	kfree(nmp);
+	return -EINVAL;
 }
 
 /*
-- 
2.47.3

