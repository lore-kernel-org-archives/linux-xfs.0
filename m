Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71182F5337
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789137971; cv=none; b=GovKqPZ06kkjJiiOqvD6MMd+PxaTE8lV5rnrqVk13/NBORriEe0GDOnhfVl6VTzqBR7UAceUrd+jPBlnstTLbQ6icFiCuEq4G9H2eRfVrBJP+yv8jRDGxgtYhPpZCaAXhm3epUYMhuCxo3JU64NI+/l6gQxELLnC3LKGqhpYe94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789137971; c=relaxed/simple;
	bh=P46F/x36USOc5ot3dINdq48f1U/CQJdEo0tgGsDTfHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+aRM5pXYDUTj2nW/daVVO1fSA/tcpX2Pi3vTNGDSA5OieFTG7+zUQwl6YaYaP8DN81jMJgHtFl7Do3zk3Wo2dJmZf7DIYbttrhCrHx0InKc7S7X+okD/IilY2TAaIK89Dg7S13Nc+NLpAlg6qe46YtGwxRxtjfXraImkpB5Cqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ViRv1vjZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ViRv1vjZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jUjzHE6qEQ1SbSLa4EIxcE7oID+EXPsjWDbmp8NN4SU=; b=ViRv1vjZBcThAKpRDynbaWfUQW
	EOqhD27g4W1Eu3lEos3tPd79jCeUn8aIJcVb8iCrsO6xXPbYqTWUUnfqhIHZPTuoyMjuQFGa8HByy
	eroWujGRiqv0xX3Gj/g4XkYcTS3vCthAjLXCdIS0YKlNKZBtAloBhiTaK8QM3EcmYwt++cBCqcpaN
	OMd4MFWu2jBDYHF+JM9AF0nVxRFoEMEw8iKhLaQLZsMotg/0G+cQ8R/gvSOWwrC8g6prWO16EOLjL
	HVTk/Ab7RPXjPXNZCC1JWzH+/Wu210giNOBKD2bRC7IxZ2TNgY4itwAQp/UsbjyGNt5FpqMKzJgj4
	7ypyaR0Q==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x52Vz-0000000Gx35-3xmo;
	Fri, 11 Sep 2026 14:46:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] libxfs: better describe why m_ddev_targp can be set in libxfs_buftarg_init
Date: Fri, 11 Sep 2026 16:45:43 +0200
Message-ID: <20260911144559.1959740-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260911144559.1959740-1-hch@lst.de>
References: <20260911144559.1959740-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I had to wade through this to understand what is going on here, so dump
the thoughts in a comment to make it easier for the next person to
understand the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 2a46ddf086ed..a47e610934e9 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -534,7 +534,12 @@ libxfs_buftarg_init(
 	}
 
 	if (mp->m_ddev_targp) {
-		/* should already have all buftargs initialised */
+		/*
+		 * This can happen if the utility called libxfs_buftarg_init
+		 * manually before libxfs_mount, which calls us again.
+		 *
+		 * In this case all buftargs should be initialized already.
+		 */
 		if (mp->m_ddev_targp->bt_bdev != xi->data.dev ||
 		    mp->m_ddev_targp->bt_mount != mp) {
 			fprintf(stderr,
-- 
2.53.0

