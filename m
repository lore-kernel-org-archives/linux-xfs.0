Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E670A1FA3
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324070; cv=none; b=Ei2rCQjr4PxlJ1JSa48uODR2pdr5ZCSWHQNhSu1igmJrrCDRNc4kKq2B3HkCl2nB9/6MlXsEOMKeD2b6dGpuh3bOIcZftM4uS1ZMXbbfb9MqLAEAZ6prPFQ3P3kBCbWBN2zxSr5UPYJYV+N01OpVWIOj8g/h4xfFIV07CtGBIOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324070; c=relaxed/simple;
	bh=4DpFPJ7DYHzBUvfbYJRLFt1bfvoDN75ib0be552/xD0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QgX/8rSKmZLts+tHdJXOWeyubE0VdhO9ZUkOnlV4ln7Zj0yYiDyKGlJq+KFnOno21OcXsPFFsNPnG9y1SlhV4w+pPFHnSUIFDGB24Cmv6/c/6MA+/mDiQ/840AEJ91t/eQWz9C/lbWeHC4r8zqfgYcMDlc0/k1XE58y0qTERvnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iRcbIgMy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iRcbIgMy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3YY6BZIZmUaROG7bkAzG3HaXF5m4f+ODCrHAQtZlXeU=; b=iRcbIgMysd7NXSEW4lQTxPVtTE
	HmczKWoxUJ9Ldr3AsfZ/GAM/QOrFpLOefjvtEAKezelNC0HEqOGeMz+JOuOPZaE1tdpCgm64jAYNI
	y3EZD2omyyyXZG6qujajC74kjD55zr3wr59ZD5FZCh1FJGaSHiyGgPl1c48cY3df04lIvc4iUPPyp
	h3KHwzam2e83of93/Sld1zUVeOWE2mdflOBg7kiq1Qj50iWEoz+ZnczJIiLM3KVf64LmuPmOrhAx0
	6ddQUNymeDoaEDs+bW9x0GA3bB9ZKr1e655jG8UsncTGJ2UPwG4GP0ix2ndLPKifOZZE3ERvFLOdz
	PVCYq56w==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx7z-00000009FCK-0n3c;
	Mon, 19 Feb 2024 06:27:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/22] xfs: shmem_file_setup can't return NULL
Date: Mon, 19 Feb 2024 07:27:17 +0100
Message-Id: <20240219062730.3031391-10-hch@lst.de>
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

shmem_file_setup always returns a struct file pointer or an ERR_PTR,
so remove the code to check for a NULL return.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfile.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 1cf4b239bdbbd7..e649558351bc5a 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -62,15 +62,13 @@ xfile_create(
 {
 	struct inode		*inode;
 	struct xfile		*xf;
-	int			error = -ENOMEM;
+	int			error;
 
 	xf = kmalloc(sizeof(struct xfile), XCHK_GFP_FLAGS);
 	if (!xf)
 		return -ENOMEM;
 
 	xf->file = shmem_file_setup(description, isize, VM_NORESERVE);
-	if (!xf->file)
-		goto out_xfile;
 	if (IS_ERR(xf->file)) {
 		error = PTR_ERR(xf->file);
 		goto out_xfile;
-- 
2.39.2

