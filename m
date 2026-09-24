Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ABE45A2B4
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244333; cv=none; b=XDJz8VOK5CmJqLklCEm/vday7OCBB2lDvz5Fr8IznFdoJcjied1upDdfxw2wV3Z4jGH9XwquFn/Z4ha8URtBXqjqyMW1gbxIAQOUp62bphywnbBe7v2WebqXeTeD2Dzj+3XiHcfpq9T+o+qvnLmuiKyZ0vnxzPFiPAlfGkco1Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244333; c=relaxed/simple;
	bh=QFAJKedDk5yG3z+1ln2UCnDg2PtxEdY0fYf+awBJFy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYDbJxszg4IGEgD2PYh2pvK6M5sniaNbmxcTPL7M/HtxtKlVs/GnXAPqRMhklxy+g+d/TKr+gUXrKjFtoXSAsbxys7ruzOsyTE0FTncs3Fsmpw9MA4iJ2y5rGrO2D+r+qDV6NNKfVBmiWKhUDwup0MqWpyMY3jwR/ngnHJ7Y90s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jks6QlLJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jks6QlLJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jRsox5j9sImXffb1nXuU3ze2EZOCoSHkL7aTwbPlqCo=; b=Jks6QlLJEqJ+M5hK4637n1w5gp
	Tv66jFfHWCLQgzCL4QYs41zJNOv/TREc1kMALLKeQor1QgHBKsINPLaQCv6IiMc6i/oGCkHPjL67/
	4hBy4jvTSbtaxFlG++3uUq2zWC9BqEZe4gPBX9ibicby+xMeV1HcudN6ywJgBCNpIyeMn/shGwvT/
	s5yaAmW2aysiedjzIvKLOji4tRLdTyMJzn8OgoNdrn9nz0DQRUR9xqp/57Q3DfFHnwzWiEqMH/oji
	4OKdTelkOapsPDjQ1dxgrO8qvAejllZFVS/RYQoXCUIydqAZQAC6KEmLub+9ZZrzXF2ySKQfJhSFe
	LKAPHi1w==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKP-0000000AfA9-2KCZ;
	Thu, 24 Sep 2026 10:05:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/32] add cpu_to_le64 and le64_to_cpu_helpers
Date: Thu, 24 Sep 2026 12:03:52 +0200
Message-ID: <20260924100512.2733748-3-hch@lst.de>
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

The crc64 handling will need them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_arch.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/xfs_arch.h b/include/xfs_arch.h
index d46ae47094ae..348ff0077c99 100644
--- a/include/xfs_arch.h
+++ b/include/xfs_arch.h
@@ -195,6 +195,8 @@ static __inline__ void __swab64s(__u64 *addr)
 
 #define cpu_to_le32(val)	((__force __be32)__swab32((__u32)(val)))
 #define le32_to_cpu(val)	(__swab32((__force __u32)(__le32)(val)))
+#define cpu_to_le64(val)	((__force __be64)__swab64((__u64)(val)))
+#define le64_to_cpu(val)	(__swab64((__force __u64)(__le64)(val)))
 
 #define __constant_cpu_to_le32(val)	\
 	((__force __le32)___constant_swab32((__u32)(val)))
@@ -210,6 +212,8 @@ static __inline__ void __swab64s(__u64 *addr)
 
 #define cpu_to_le32(val)	((__force __le32)(__u32)(val))
 #define le32_to_cpu(val)	((__force __u32)(__le32)(val))
+#define cpu_to_le64(val)	((__force __le64)(__u64)(val))
+#define le64_to_cpu(val)	((__force __u64)(__le64)(val))
 
 #define __constant_cpu_to_le32(val)	\
 	((__force __le32)(__u32)(val))
-- 
2.53.0

