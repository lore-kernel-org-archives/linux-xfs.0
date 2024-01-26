Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABC01B80A
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275801; cv=none; b=hoPUJTyhsPMd7B/0mmHNM3n0ulUBlZUkDLuC9pEPXeHXfyzmzp2ppRCHKOdE68ty3hckDaRjtQH7TLpY4j0FqAWl6f0vT+Ae4XD6o1srxGRO64Np3rf3kMiwg498ajah6xDZny/yi9DwUH3C+Zto/gVK46PDo413YEMV+S096D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275801; c=relaxed/simple;
	bh=uDNZvIO3ymmNh8KpM65aczzQJycZuG5g6Z/O2czi7YE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JHi3sQKPTdhcH1I207Gpkts/+wO7tLapSTXWsW4hV2rnRAHuNNgDdhG44X65FwrL+e6HNNpEWQrc911+jJbzx944oz7iFJCr0s4oAXzHrS4ZzDKYaK8ozqYjDQSawejboVKfuFgOsbmHdpI1g3kmnU27ODTY5osu7F5wD7Og0U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1ChCLOer; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1ChCLOer"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5C9VP1SaExA9uyPFl5WPVHE4cTMuqE1mtuEvKQxBCh0=; b=1ChCLOeroR7dQqYdR5AXNYr1Z4
	o8nXFMvA03KaWJYAdTLzKQAjFQDtTJLAjUJym+hifoq1BU+ewTsTqMjsM4rvfMrJTXpNkLkQYpxJ7
	C5P4H4B225jgIsjOBoQFolOqzPJROg4/qHYpxzifySOP+wpW+l8Lfm5PuR5tOyzesgr0Hk/csyvdG
	QY5oL1xAe2TGkD8Bm2Et80Pk/tVUVr8ItZjBFJ4qRn6rBKAaaKOyPfZUem51N2STdSXZu2diYvpms
	NZe32dI0JGZE2SLOiKv8/E4ubitwNdnBLAWJj+w1AOCtlTp3xPqcPKHiVItw5cuXYbd5V26NqnvCk
	LZAXUuYQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMH8-00000004Clz-2KQP;
	Fri, 26 Jan 2024 13:29:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/21] xfs: don't try to handle non-update pages in xfile_obj_load
Date: Fri, 26 Jan 2024 14:28:52 +0100
Message-Id: <20240126132903.2700077-11-hch@lst.de>
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

shmem_read_mapping_page_gfp always returns an uptodate page or an
ERR_PTR.  Remove the code that tries to handle a non-uptodate page.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfile.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index d65681372a7458..71c4102f3305fe 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -166,18 +166,14 @@ xfile_load(
 			goto advance;
 		}
 
-		if (PageUptodate(page)) {
-			/*
-			 * xfile pages must never be mapped into userspace, so
-			 * we skip the dcache flush.
-			 */
-			kaddr = kmap_local_page(page);
-			p = kaddr + offset_in_page(pos);
-			memcpy(buf, p, len);
-			kunmap_local(kaddr);
-		} else {
-			memset(buf, 0, len);
-		}
+		/*
+		 * xfile pages must never be mapped into userspace, so
+		 * we skip the dcache flush.
+		 */
+		kaddr = kmap_local_page(page);
+		p = kaddr + offset_in_page(pos);
+		memcpy(buf, p, len);
+		kunmap_local(kaddr);
 		put_page(page);
 
 advance:
-- 
2.39.2

