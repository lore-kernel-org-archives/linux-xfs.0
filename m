Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C9448876C
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330184; cv=none; b=IucAFpe1cIDrA+nq8GdeM2RKiPsYelI94yFMDnwASx2uiT3wnGyY/J4Su/eYu5vG7VVe+svFR54AAnLitxhS7dmYooAdAliVmEBSkIG9HGy3W9GHkb/YLJmJ47mqBTyMEPEsU3nxgFxBwp36J64nIGFRtnYUddOkFwzyrQXRrDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330184; c=relaxed/simple;
	bh=BPFNEWVW/aNc2TWIvhV6Mi5Wl6rL3U//ZUyxvN5bpPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJD1qoaO51bkRjTTCOIAG0Y94GmgYBtiJCA5CniLQSWn4hByQnK4Bsx3aqb2PbC1s+hEX0zObDug10Ak3Rt8m3PuLBo2eXyah39nav2HgTGEH9pYu2fW8aoLgVGZH9rLn479X4Wxx9vh8Nzb9/pp1DN/ooqhtV60h2XWq+mSxVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=asi3oo3B; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="asi3oo3B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=6LSkmbKEsG99JqJ23Dls/d2MfDBqCa+c52Cve3YsyYM=; b=asi3oo3BdfKpYo8NQEBO+7rJit
	mKnfxyam8Vf6ed1m8MPz1UKYF6LNxCpA0Ise/nwzn4QCujTuPee80cg95hFVQzMgDISOcbFy9WQYs
	Tj7BFmpW+s6u98Vuaqyxh07oF4jHuA56dGouZVOUQG8niq5diYvG+fSE0XY1igpaj3PCnib8Frpnw
	ZDlBUnt9+7OzWzzS0X4qUmomTKxzl3HcC1Z+Kn4/w3kWgPolOMrNGywf6dSTFyQ98d2kauk8P2Y5S
	Kj9scz0+k+013pdXNlRBiaY3ycR2jiLZOTXL6ZjUFHFjPFH3HWDIE9xnXsX7FieTzanjJvqxlk5Ft
	EG4odBiA==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3w2-00000004We4-2ZNY;
	Wed, 29 Jul 2026 13:02:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Cc : Hans Holmberg" <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 2/2] xfs: add a comment to describe xfs_gc_bio.victim_rtg
Date: Wed, 29 Jul 2026 15:02:49 +0200
Message-ID: <20260729130256.2282092-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729130256.2282092-1-hch@lst.de>
References: <20260729130256.2282092-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

All other fields have comments describing them, add one for this field
as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_zone_gc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index e4f70e024632..7ab8f2218c6a 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -103,6 +103,7 @@ struct xfs_gc_bio {
 	/* Open Zone being written to */
 	struct xfs_open_zone		*oz;
 
+	/* Realtime group currently being reclaimed */
 	struct xfs_rtgroup		*victim_rtg;
 
 	/* Bio used for reads and writes, including the bvec used by it */
-- 
2.53.0

