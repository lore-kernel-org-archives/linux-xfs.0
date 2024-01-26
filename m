Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E201BC2B
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275826; cv=none; b=AY0F+9KE/geeotIBl38yFvF7k1rurWkpXB/5QWyWDmxZqQnsx5GUem/COaUoNEjAY+xmXyuk8y9/AUxPdsG7rGpoaqT3SblR56T85S+eSKO+xm1whltIx+mHTf6IDWKyw6FnGcWF2MSiFMV9fuAw9Dw/GkuUewbjndfMZVjRrVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275826; c=relaxed/simple;
	bh=fW3amsgJ72Pk0AZUtNdUzvZkBYDdmK4uYJv1DDYZyW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BAjJkltfIg7BLn0tmgJm7vcArmh3reHuMOgw8+CZVny7D8XMvB0Kyzk0BVqn4IM5ZKDGQLcy9qPtRqYONYiTUkL5vI0Ir6t18n4zSpwViOM32/8y21dKefR66GGUvNYCSPSJPBsGp2dsQ4s0Qnnxv4oygp3hsLPWT8RKtk7mzg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bq6TXgEG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bq6TXgEG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YwCZytasSWWNAnywFhe0IpFtb/e1jDVoRPLD3Ievb94=; b=bq6TXgEGS6m0Rgq3y08f1yk9dZ
	sWghYBKjyHZrySsSTo2ZBOh+osK2S0jThJamBFx7T/lIARm1bQTWEbkOiS+hFgOGtSGaFwfjvQpL+
	6GIC1zfxbFWhb9cF15qiQFfa5NVyWeVQBvkOSDjGajaJNqHWFGHxXB3H0t9R4jfU4IBmqydNV5e5H
	h6v7nHwhjYJrFNBOKE2vTdjDNuaFlKn9OPt/PowxxVggaEqekThbYbPQv3Y065Ue9050wEhNtq5lK
	YFs9OuXCq+LLLyyIuU8B1l4aDtBV+QnIiUV0s5jQCkglg6RIalaPO82SnNjlDjqtb8YcvQJHBn9jC
	Qv1QNZEw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMHn-00000004CyD-2bM2;
	Fri, 26 Jan 2024 13:30:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 19/21] xfs: fix a comment in xfarray.c
Date: Fri, 26 Jan 2024 14:29:01 +0100
Message-Id: <20240126132903.2700077-20-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>
References: <20240126132903.2700077-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfiles are shmem files, not memfds.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfarray.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 82b2a35a8e8630..379e1db22269c7 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -16,7 +16,7 @@
  * Large Arrays of Fixed-Size Records
  * ==================================
  *
- * This memory array uses an xfile (which itself is a memfd "file") to store
+ * This memory array uses an xfile (which itself is a shmem file) to store
  * large numbers of fixed-size records in memory that can be paged out.  This
  * puts less stress on the memory reclaim algorithms during an online repair
  * because we don't have to pin so much memory.  However, array access is less
-- 
2.39.2

