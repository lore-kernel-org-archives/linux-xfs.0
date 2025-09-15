Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EA030EF87
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943067; cv=none; b=MMPZiYecgsRLvHoBzMy84KSIqpzuEEYnteUWZWuya/1wSsr5jOvNfxUI0XElDytgEu4XxvaMsHlCbvQ+eAwtOrPjJsR0f5mRtF/9ji6810EJRAuFUsQMozglPfk8EoGCFd1cLGxmREOPDLiJQW18de6mcltfH3dqi75FsXHBmwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943067; c=relaxed/simple;
	bh=McBatEyxt4pexhcINTAtlkQDEpBKmizr1oOc2PWEL10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ybnknm5qCgXN2ZYRV9LiWMX5mhU9LVfoB7Wwn6pvAjgK6OGu6TTj1gLA3RdjNkeWa375W5bMsgXMjZjv/eWBHOcjlyfIoqVt3OS7pjV3f3z66uKO+/mGjXx1mWH7amjmlyo3jhUEwcTPOa/VvyV778I4+dkhpKppHJPBRhtE85o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p0cOnse1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p0cOnse1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Xj4WM1KKmwDOtU9ROKcf5ZorLwxZr2Y7xdj6ZK4B8BI=; b=p0cOnse1X8xJxkJJRLnoUv68TG
	muy5VTjoiOvVJK3n+YCpVcJdTwZRB+SHEUG41gi0gHLfcC6fiO7LOhVt4faVcncpG6lLcQoZz+zXi
	AyW8h/iEO/735wVjroSmt28lMpUh/cS6DnaAbuTWbwQNt2GUKIcAZuBtNmrf+z5PT7Ix06WA5YwIq
	2PH6zt297mTmimAcCAVz6yLNm47swKMDVelUOsr3eLkDvQsmzOxPTHEFFlVbfSR1DsZlQKJf1N7cq
	GC55EZ5xrCtlbdGu83vRecl77vDcD38LVsdedCW7iyOMr296AXWGqE9uBEih1B7LsJDVaS05QF01L
	qJHVSQyw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9IQ-00000004KV2-0uUy;
	Mon, 15 Sep 2025 13:31:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: constify xfs_errortag_random_default
Date: Mon, 15 Sep 2025 06:30:42 -0700
Message-ID: <20250915133104.161037-7-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915133104.161037-1-hch@lst.de>
References: <20250915133104.161037-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This table is never modified, so mark it const.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index ac895cd2bc0a..39830b252ac8 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -19,7 +19,7 @@
 #define XFS_ERRTAG(_tag, _name, _default) \
 	[XFS_ERRTAG_##_tag]	= (_default),
 #include "xfs_errortag.h"
-static unsigned int xfs_errortag_random_default[] = { XFS_ERRTAGS };
+static const unsigned int xfs_errortag_random_default[] = { XFS_ERRTAGS };
 #undef XFS_ERRTAG
 
 struct xfs_errortag_attr {
-- 
2.47.2

