Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B36200B7
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324082; cv=none; b=g0ClIHyUFHfN32oXeLuUuD3adCmso/jHP0CT9q8nMjN+fDBiYmyoMFilfxge4gsToABnogLjUUJdhOV7722geTOOvIyKNAaSAWoRgBBTzcU4S21iSJUmwVUG7MXs1t0Vwv4IWjBVXNoKP681cpUxxKwykowFQ0ZYycwvjVvdx2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324082; c=relaxed/simple;
	bh=O+1mJ8XsYaIADHPbuCoVdSP1tx3nIjcBjPC56zBWHG8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DIee9eX/e417aiZg8tlI7gmKzhxUbbmjP9/wHLVr0yGCVmdM7IVeA1E0H74bYZRKUr4gw6ZghGySB8UgC86ImDogWmavjwFpleowPn/oP4xNbj5tfQ7tuqxt52BNsqmdgiG/u9SA+QuMSms9ukQgT7MRlQDShzPR5kwNuyswAXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XdjKpLfK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XdjKpLfK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=F7Vyl1D3QQTGAjflgR6G3n7BYbKCD0s/3rfb9BjRAcU=; b=XdjKpLfKFuJN2lTHOZIm9KlT6v
	QYEa7VCt9CBmlb5HYKCkB2uV7sM8fUy+SnkgVIAukNQEAIh2GtAcVVA4w5rYRepnGwY+CRPFoPswx
	Ku/8skOkzKDp3banGGM5S9ey6r8xva9uxEwxt30NlzjHa+ASNa01UJN5ck3z6XcgNVMD0lt9XFUcA
	K+6D62p8TN4G9BIO9uQt8y/n7SKx7Q606hvWTKHwwhaAO3Us6oJ8UQyKL+HK3QZfK/6drhsb9ryRa
	PF1ur9Fggmog+eFByc8PuglAwKW6WNSW9n5l/uIDIt9k9Dy+rijoTGS5X0eFruF6fhK7BeW9vtM2N
	snmxUPOw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx8B-00000009FIN-0N6X;
	Mon, 19 Feb 2024 06:27:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 14/22] xfs: don't try to handle non-update pages in xfile_obj_load
Date: Mon, 19 Feb 2024 07:27:22 +0100
Message-Id: <20240219062730.3031391-15-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219062730.3031391-1-hch@lst.de>
References: <20240219062730.3031391-1-hch@lst.de>
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
index c15cc886888001..4ec975977dcd4c 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -149,18 +149,14 @@ xfile_load(
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

