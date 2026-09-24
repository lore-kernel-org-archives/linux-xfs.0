Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6127846C821
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244429; cv=none; b=Wx183VB5gPik7gwxP/mFNUKTsFMpf5FS5sQjTUe4iKuTyTW7HsusazuA8D/xUBwfl6OLwVbj/3Be3AgBI8XPK1KO3oVck+VHiSCnaiJx/rxR1k3/Bs2o0jzE9XEsP4n82SCbGQlPwOtckKifjGp8qLg0pQAINpF5qVFQ1Y1NaLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244429; c=relaxed/simple;
	bh=rF9/8QpyJ8l9uB2LlJR9Vzyxq5LxqUjEWv9PKEVkfw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GReNH9q8tgNeKNg8n04jfcW48P9OwGYcDDerfs7CB0IIV6nTuQBfKdxWLCCRnl4NwI/pLTEn8DGPzxqIaiIy5n1CAJ/UMXCIgAtfcLi2TLEdLQ9+LLRHL6Jrb+lyjlwHhWWrCz9D0GS93r3Dvnep1NxtobQl4XXap5D2UCVN/14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Kiv9fovn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kiv9fovn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NFykpJXuq5azS4zKu1jE4nf3/ZXQlt4DZrWlzgSgASU=; b=Kiv9fovnOhHxqwh5dFUGyrk7a6
	gfya7n1kteYfXrnBE35KXlbIjcAWfCSC0mYXlGMTgOUgFi1y4RMTHMYsNcBZCS6sE6O1384jwci3m
	W4jAWrVPOmL8dctx/ztKM8A29mwbPSvK7N1RntFo/opOxiEu+pMmc487/9Bgy7jPYqSypwQKLpqMD
	YZ6Y9tpDNpMcb7YkZCmzFW/66n5Kfc3yT2OjWXj/0v+I6M2a5VzITyDZnoVOSXbrLdDKqLAT+3mVp
	TXXriaEJrdzy7f0p9GKIJXxLngv8nmBCdPtoQzR9xWdcbcfwV00HrTZJsyrmzwkVIqX2z+BKydDS4
	u+uI5HIg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gLw-0000000AfTf-2Nbw;
	Thu, 24 Sep 2026 10:06:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 25/32] xfs: enable RT data checksums
Date: Thu, 24 Sep 2026 12:04:15 +0200
Message-ID: <20260924100512.2733748-26-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: fedfd9ab32d7f65ef37abb2c06d320b9368d7b6a

All mandatory pieces are in place now, allow mounting.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 1be3d21910a7..8b269fd3ed9f 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -384,7 +384,8 @@ xfs_sb_has_compat_feature(
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
 		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
+		 XFS_SB_FEAT_RO_COMPAT_RTCSUM)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
2.53.0

