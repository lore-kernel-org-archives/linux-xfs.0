Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9711C488D93
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330220; cv=none; b=Q11dokH8rDaO0fCxXS/2dKcpV1/9EkbjseNoC6BaT3mecCHyPXMglc+BTX3sqT6/Isj/GqCITMpv/K/h70BM/1kAsI/O4ZU8G2Co8cUCmaS3WbOgQrjsBeNOQxKYj807bQI4N2T0ty0fxq/p5mgz4Ggcu/hTWbTPMCKvVe8zywI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330220; c=relaxed/simple;
	bh=Brs1mdVdtZUWDhZrZbZmV1kwLPYsWx+Mmw7ZwQ7FIaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Skfq3xrztOaPxz24VA4uEj3hHj0kCNVr1eiGKvEygYDIwbgy4R0N3zgT4D85SCXsng1iJwS3ipIM/r5gD2SXmRL9Mu3EBRy88jxxMkAjC3lal+tLD1MLLs06+pdt5pWPwYMxKDSyVnm8e7oMpBhwOyqXGTWeo60e3b+PnUOlhI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ifg2w7Cm; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ifg2w7Cm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=9RPhWilQdJqHU5SvG8bEsnOneQUys00umuj7KsnUcY8=; b=Ifg2w7CmLHwB/rkukm9lpU2DAl
	aijSxFFTdzb3jHgtCdpicztocEG0sXjyYMdVn2XL4J3BSKEYY/RWUjDdWwHjzzQX1LMSsIn1Jqdjg
	HsfVrLZE5KoQoiZWLwZGgdZekO40/v7J7/SDcx3XCldQZrLW9s/INszkMGa8xyP6ziys7K4VA8DI/
	+bD2aEnLI0S2T5a07X4u90N2aG1FMUxHd3z9xcwz4jzZ0Y28COLQJq/FT/EcuG22sC8hTsyIWuPYY
	C9mvx8+ySnvs1WI9dPI0WcB5IzvWzqtv3GHBr28sBldkPnKiyLgEU4HGAGfKgSRsdSCGaO8V32xsT
	Vl6jPVlw==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3wd-00000004WnV-22Df;
	Wed, 29 Jul 2026 13:03:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 16/16] xfs: remove an extra cast in xfs_file_compat_ioctl
Date: Wed, 29 Jul 2026 15:03:15 +0200
Message-ID: <20260729130320.2282183-17-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729130320.2282183-1-hch@lst.de>
References: <20260729130320.2282183-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

The ioctl argument is already available as an unsigned long in the
p variable, so use that directly instead of casting back from p, which
has the same value but was casted to a void pointer before.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 688eb3300495..f6875a2cc706 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -539,6 +539,6 @@ xfs_file_compat_ioctl(
 		return xfs_compat_attrmulti_by_handle(filp, arg);
 	default:
 		/* try the native version */
-		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);
+		return xfs_file_ioctl(filp, cmd, p);
 	}
 }
-- 
2.53.0

