Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD90D42AF85
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244371; cv=none; b=nbccFkq/kJj43TjAWupTsBhLdjx6kZ6ihkJPV9n1IfPfS7qjcfO0LTqeJGMmGKXEx2vAlr+hC8iDxZ+gvX+mDSqUVCUXIPTxqca2A1bWvYnYzmwy5z0jRKbV+cjkvl9frXn4JAXYS7UDA8wCt2r8AWEWABASfav/TX9ZGqtiVL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244371; c=relaxed/simple;
	bh=OUXhMeSS80anbWfGYYw6f6fIrFVswVr/evYVWP7cM68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFnXKI4D/q2NOmgFh+4mYc6BwHBBbv9Q58VA4zdnPWs0rJR5XF6GzAOmMUcms+MEuvpbH6UgooeCol/ipgpfahn3qoecJ9PRsxZCgQCf18ykJylsema+Bihzu4ghARSjd0zx5PBXZT9J/NH49olVu01+BXP9+xbpvTBoxvp3o64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I4kz7mKH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I4kz7mKH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BCJAKN4K13Pk/P9rW4PvJXw0sxcgFc0cm4wYtqfL52o=; b=I4kz7mKHbpwHIcRvZmt2Noqx9f
	ZJN8r9VeXnwieO/EyOBEKf0XBebKLDBAiE7qV+/RTCWxqx622d9QgAd+7TkQ8x7GOuVDES8hzv0l1
	gX/VfmsF7P6HmXWqw7Jchg4wexc+oRxcS3Sorpe5JPZuZEdlx/pbH01XE3R1IFCmYIDbpHNfdtXwm
	5EXkNWz/zKWt3vxDiqBPICepYENB4QWRw4Oeuok58NQeLKrnO+5/CFwSD3hbb5egbQAKXjKHQHvoX
	HW/E8hFTRFeljcJYLzeW2t+VLE+W+It/GmIil/dEq173XNStkPZ2B4AF81ceW2XHmc9swT50+hkS8
	jVdzcYeQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gL1-0000000AfIf-0MhS;
	Thu, 24 Sep 2026 10:05:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/32] FIXUP
Date: Thu, 24 Sep 2026 12:04:02 +0200
Message-ID: <20260924100512.2733748-13-hch@lst.de>
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

---
 db/convert.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/db/convert.c b/db/convert.c
index 3eec4f224f51..9fde50ac8a91 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -39,21 +39,6 @@
 #define	rgnumber_to_bytes(x)	\
 	rgblock_to_bytes((uint64_t)(x) * mp->m_groups[XG_TYPE_RTG].blocks)
 
-static inline xfs_rgnumber_t
-xfs_daddr_to_rgno(
-	struct xfs_mount	*mp,
-	xfs_daddr_t		daddr)
-{
-	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
-
-	if (!xfs_has_rtgroups(mp))
-		return 0;
-
-	if (g->has_daddr_gaps)
-		return XFS_BB_TO_FSBT(mp, daddr) / (1 << g->blklog);
-	return XFS_BB_TO_FSBT(mp, daddr) / g->blocks;
-}
-
 typedef enum {
 	CT_NONE = -1,
 	CT_AGBLOCK,		/* xfs_agblock_t */
-- 
2.53.0

