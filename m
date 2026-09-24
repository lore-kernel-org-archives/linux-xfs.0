Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F3A43FD09;
	Thu, 24 Sep 2026 10:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244577; cv=none; b=vD2n26bDKR2DPhze54XaAci/5Ql7Oee1z1w+XtT9ywVkGh5X67Ap/vk9B23ETw6ZhMtG7WvxGc3lGGaS+ttVLPK6arjWp+qtPdiMS4+BaGP9QOvvl4Wfrq/aoePiyTflq+9clwVpUKn5ef/WbDviTIQ33Q/Rb91unYMqlw2lAOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244577; c=relaxed/simple;
	bh=JV+yV90aN0p9+JthRQ0vwsyZSO5Y/VNjGjjRE/FrvlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUmXbSmiSGtbAN3T8agEzfuBdO6maPZoUSp7+Iecrdc1ItX3sLwSvTQ/6btCQxztVr25bP/oq+vC9h0J6KOfOFkGFV0fgSdPS5a7GiP2KKDHLDgEPq2WrbryB8GmuA6Obd/NLUlFX9mUtZAdu9nrS8q+23AiPC+yejNz8Mxfj34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1ckdaoFL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1ckdaoFL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0RouON+hKvidyYmBceBIs9a0hiIclMExOJWBTfgTzRA=; b=1ckdaoFLLhrxAxcVB4UDFRrcWO
	nvFyVzOWE7Zeql3Uf9BTxtjHibfh1pzkGi8JyixrgFcKiL7t/LjUzOUjSEmFyY4jC01vsxaXWQfGF
	1prKJ++EP7EnNPBMfaB4pHGFIiX5XzQTMLwhhnYdmI6DBrNMkSXfGTNkWuQGCH4OxhSrBtYZVcw3Q
	na7uVfW/B5CsVxWSf7Oi02mZzibcu+cjY8nhWIlvcCBR25MCyHnSPRwCjz5eH8wk4wUFxYRmPh8p+
	ch10g1vo1HY68CMfJIDt0s3h8mOLgp7M5/8ZiOKp1j638fRvGbDYWloBOKS4R4MYM88o7G7w9R53g
	X0lwpyMw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gOD-0000000Afn5-07RU;
	Thu, 24 Sep 2026 10:09:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/13] xfs/206: filter out csum information from mkfs output
Date: Thu, 24 Sep 2026 12:07:45 +0200
Message-ID: <20260924100855.2734089-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100855.2734089-1-hch@lst.de>
References: <20260924100855.2734089-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

To make the test work with csum-enabled mkfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/206 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/206 b/tests/xfs/206
index a515c6c8838c..f5e0b1404732 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -67,6 +67,7 @@ mkfs_filter()
 	    -e 's/, parent=[01]//' \
 	    -e '/rgcount=/d' \
 	    -e '/zoned=/d' \
+	    -e '/csum=/d' \
 	    -e "/^Default configuration/d"
 }
 
-- 
2.53.0

