Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91DD1079D
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 06:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714371357; cv=none; b=N1qt4MTX3Y+QdnbQxpmdw6ouKZULtN4ph9MJz/MCclJFSthDnbPs4aiExycUTIdgukNRsSMgQUWeR2KJUfJSt3IJB/BmtE0mQxFo7v81OnBFZK+oIupoK2kObNU272+XWnS3hb1WPR6IkojzzQRn9xtl0WUwha+2mEYakECw+0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714371357; c=relaxed/simple;
	bh=pqxBVrqJ+ScVtgxtK0xuEKxmTDGnhUH+oQBYu6lOlVY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l62qSPwELBwz7Yz0PUWaSNloVKMzpZZpis8shWOdq/DnxZrLneNwbyPA/fMOHthL2TH9yHf4CJufs2BA4YKFpsL95wy/5ofnSAHw8+c4GZza01pJFi8bvvLfzOILUdHtRnirzL6MbZTd+5Tz0lQPJZXEFiZnaZwGBroX6+gB6G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rkyvispZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rkyvispZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1NPsFOdaXYv2sK/E/aNE5+0Ct82FPTWrDFkYQp4JuSI=; b=rkyvispZxbWye0XvIC+UPzuQx7
	DzJisxiPNg2HiKezPeWz+iAe4fZR72E/CA5WANKCN+/sCZ/hFENS4KMIcpaXPDMnxx5AxXwC/YC2E
	EA+BR/sJXarppUjz123WDM4kXI5KHfbVr/ey1fl/8UDX21IgyMVcAACg69x5mAlbCweY4ZI3/flP9
	GfjeUrLcPkTRgE6EHsrRhhXN4I78/Rae6MEq1MAlMEDGVOsnno7aCLACvSqRQL59GrPPEIy2QYpic
	eOM0ooENH0L0yJR/rHlzh9WZbXU7lApXxTFSS80+/lD0D93cjez1a6QCsaek8nrN5EtMYYLX8JKop
	yneuEQOg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1KIs-00000001coV-36Lw;
	Mon, 29 Apr 2024 06:15:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 9/9] mm,page_owner: don't remove GFP flags in add_stack_record_to_list
Date: Mon, 29 Apr 2024 08:15:29 +0200
Message-Id: <20240429061529.1550204-10-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429061529.1550204-1-hch@lst.de>
References: <20240429061529.1550204-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This loses flags like GFP_NOFS and GFP_NOIO that are important to avoid
deadlocks as well as GFP_NOLOCKDEP that otherwise generates lockdep false
positives.

Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_owner.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index d17d1351ec84af..d214488846fa92 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -168,9 +168,7 @@ static void add_stack_record_to_list(struct stack_record *stack_record,
 	unsigned long flags;
 	struct stack *stack;
 
-	/* Filter gfp_mask the same way stackdepot does, for consistency */
 	gfp_mask &= ~GFP_ZONEMASK;
-	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL);
 	gfp_mask |= __GFP_NOWARN;
 
 	set_current_in_page_owner();
-- 
2.39.2

