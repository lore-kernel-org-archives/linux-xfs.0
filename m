Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2168717BC9
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 08:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714379319; cv=none; b=QAemths1v+0w0OOY1qXsf79RCbDTb/W+2BDIbamTkdV1RY7qeUfvxc5ltVWov11prf+j8MRwufdROIZB1Nb11KGL4PCrxGcSS5iIPsUlr2x1hMMloF8OpC603x8fDxHtAwBUry3U2X3fuWoMgJMuUzrTMtekPCrOsWm/TzECa1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714379319; c=relaxed/simple;
	bh=h7pVRrcNjKwnkFkGTCZwXAx229qQ9lCJ4KGQJ1/rqyk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fHhCEmsbAXIQ2uqXjyENuiOP4JPzrEfVsR8rTKZavwElcVp/b8qvhYDVnaetJaJriWD06aR5fhCcPOTUdZET9Ba60mPhtyizfD7aDbsWPLkxy3nFPemo2OxQAfzB6pUx/uYh/DNjjV6NAwbLZ+yc6OhcBJOdfei7AIBcNtbxNdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gguGejPK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gguGejPK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=0HBKQ8fzn9KpERPmuzYZnAAGF9fl2woLnSZSNk8YNj0=; b=gguGejPKFBb2SHLAf0pg8M/0KD
	/CFy59ULONhTXP3ou7Ah3u5bP8C6Brb8AyfDk2GuBS5gwKrniqgmlyokDlbiO2/FbeiRBjwBz5bdS
	DALxUVv+Cvx3u5HXva3hxPU6iVF9SosN39xoPzmfp0hF5uup2X0rumSTB60XvaGzU4rMF+hnoF2Ku
	yXl9EZ2pjGaYjHMgrQpQgXcaap797zF9UIZulKZLDMHhOgCbEtSHrVMltvyVs+2go6XC4KFqhqVgV
	bdMm2DID4IzIfAONE1lPHiepC5TJgB6aHeilJ3iOIbTjA0ks9p9zCpXYWxf5jbFd2s4DnYRC23O6N
	I7I84I1g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1MND-00000001xP9-1WR0;
	Mon, 29 Apr 2024 08:28:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: akpm@linux-foundation.org,
	osalvador@suse.de
Cc: elver@google.com,
	vbabka@suse.cz,
	andreyknvl@gmail.com,
	linux-mm@kvack.org,
	djwong@kernel.org,
	david@fromorbit.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2] mm,page_owner: don't remove __GFP_NOLOCKDEP in add_stack_record_to_list
Date: Mon, 29 Apr 2024 10:28:28 +0200
Message-Id: <20240429082828.1615986-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Otherwise we'll generate false lockdep positives.

Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Changes since v1:
 - only pass on __GFP_NOLOCKDEP and leave the other masking in place

 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index d17d1351ec84af..428c1ea8b4579e 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -170,7 +170,7 @@ static void add_stack_record_to_list(struct stack_record *stack_record,
 
 	/* Filter gfp_mask the same way stackdepot does, for consistency */
 	gfp_mask &= ~GFP_ZONEMASK;
-	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL);
+	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL | __GFP_NOLOCKDEP);
 	gfp_mask |= __GFP_NOWARN;
 
 	set_current_in_page_owner();
-- 
2.39.2

