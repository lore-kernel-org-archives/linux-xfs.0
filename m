Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD54153BD4
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538948; cv=none; b=vEr6SII6rLJyXgM5tQFuNnXUWkevvKc4svCJFS+ThqoPN25sAe+jwb5JikOrk7MJW4Dtdpfi4PwQCNkUnElL7C0pAHhratLaVCNyFBhDNagp8FRwMmY1eGSCWrJL3JBbaxKzoL/QO8CcrpvAwu8dHEKvRzWRhbXXjG0aRiSKDCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538948; c=relaxed/simple;
	bh=gIM6UqsPpyVgE21NLi+MJWJ0av/j6HR+V0fU06QKbDU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C+tkUDiQ/8T0Qs3zOPr7Cd/ttY/H6G+PU27fjQMMQJ+t1KmHj10YGjGruTtSRCd8HgJiPjpUic7kf3H4EfIfgfbSLpiOpMeYQ0m8j22zYRPjYloylHQIHxpWg3XTjkzdVnioRSNOeEBOdy9aQZJ4GLQ08w2s8OaNURGzRFkiuYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L3wYExFQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L3wYExFQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Qe83DfTex1z7zqi4GxksjarNQRXeRN9ZyszbsgkFHtk=; b=L3wYExFQC0UvuaWRe1nYere+D3
	T0e/ZF+LMHE1lHOttUK8WdQM2kpKei3OFZNmrMIMSa3S9Y2hVRvLta/6vsXwyVahp/L4VnqNYQDxU
	6cUXOBLNN3pxSWmxRVOTXtv/Wj5LVjrmrdH71qt+RPJr0088CIR/EBbAiTFUcXRYQnt8R5x9Xe3+L
	JzQze5Mdqk7zFbrd5/bF74xd6Z8ERDHehQ5LbYP7Bq0bOMugqbt2nAVAjB72vjYVHq+pDENuWtZvs
	oD29U1cbmj6+mIKmn9LN+B1/2APGXvFBLeha0QKdPmJ2791TDKtERQ55WTjvHcWB2REM/2vZ8eQFn
	tu8LAvCw==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjh-0000000D6KF-0TQt;
	Mon, 29 Jan 2024 14:35:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/20] xfs: shmem_file_setup can't return NULL
Date: Mon, 29 Jan 2024 15:34:53 +0100
Message-Id: <20240129143502.189370-12-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129143502.189370-1-hch@lst.de>
References: <20240129143502.189370-1-hch@lst.de>
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
index 71c4102f3305fe..7785afacf21809 100644
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
 
 	xf->file = shmem_file_setup(description, isize, 0);
-	if (!xf->file)
-		goto out_xfile;
 	if (IS_ERR(xf->file)) {
 		error = PTR_ERR(xf->file);
 		goto out_xfile;
-- 
2.39.2

