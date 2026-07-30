Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C673AE70A
	for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 12:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785414330; cv=none; b=orJe0q5VfU0r41yheZea3zygvshA13U3xbhb4iJ5iL/ZBrvr0iAbmzyq91FHWr76z44AslDi6uXYcn4PYgcv7jWv4hy0C0HF6CYXPm0D8DUH6V3DjuFBP2ivbofiua1oNy8gOkVB6D5+bOpfRrL+iR1oCOvLWoiXFM5gUV2BTUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785414330; c=relaxed/simple;
	bh=zTmrVAIArnX/EzxQAgktPBw+ZjZdxL49FQ8Vlu8l8Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlcbRwbgkdcB0ssiHEHpnm9wyfNQgjlt+bcdjZZpfSXXee2LAZP6l65W+8WJNn10+7Ps/7BX6xzU3h6rl12FoPJBNJzvRFiIa9M0SDh/FMpt8cab0PgmifJcPcE3wnVmyUu3eo8TPmAP3UhNaJ61FbeV90i16BoSciMoSN4iHMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GlZoosbY; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GlZoosbY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=4otEs0D7TD7fn4OFdg2XAVoZ3NP2/67xUSgL1985d5c=; b=GlZoosbYMFnInyttDR0kEsAY1e
	C1MHhiLwNhTTyAk8zrwKpxDbwZZoYhad94YX9CTBywPIQgo7RZqSd0WyumarQyf8D8UwlE3w2hNbO
	KuI1Y7WChCO3lhiPE57mI14ffSGxEEVps3iofcQBSOzw1cXg2TejsTAjApJeaqEVhaqqW7zABSMOV
	CJ8lEJ8bLMdLV0A7OOH0CzCgXPVYydusHsw5Ycv/xvVEwDYPwmvP78h4coa84DhB/kzzg+FR9xtzL
	Xl4OUtmtr4MhDPjCum0V42UhDQn0M75AEyx0j4cdM7B2xNxOwg1JnwD8B7ea9EyUDM8etGuzOoWqF
	F3aAOZ1w==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpPpE-0000000Dgjd-2MeC;
	Thu, 30 Jul 2026 12:25:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] growfs: clarify the man page a bit
Date: Thu, 30 Jul 2026 14:25:14 +0200
Message-ID: <20260730122521.2578459-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730122521.2578459-1-hch@lst.de>
References: <20260730122521.2578459-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

While no RT section needs to exist for GROWFS_RT to work, the buftarg
must point to a block device already.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/xfs_growfs.8 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
index d6e5fe13e943..1aa57fb0308f 100644
--- a/man/man8/xfs_growfs.8
+++ b/man/man8/xfs_growfs.8
@@ -151,7 +151,8 @@ the real-time section is grown to the largest size possible with the
 option. The filesystem does not need to have contained a real-time section
 before the
 .B xfs_growfs
-operation.
+operation, but it must have been mounted with the -o rtdev option pointing
+to a block device.
 .TP
 .B \-t
 Specifies an alternate mount table file (default is
-- 
2.53.0

