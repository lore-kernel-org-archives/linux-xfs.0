Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBD4152DFA
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538969; cv=none; b=uKRhwKGoZ1ncwpFGyxQQihpdvXGCxkYGdYHX2p3KcLB3RJQBfw6lntVI4XIvJr52I6mspQRjdBRdK6ThqUDzVXyc0t3EIyr64mlNz6V8stnxQ0XKuU8MIlBUH1ujy2O+KqE/0BgbqtbIIq6n5FbN9YlMtoNkPQ4YLKHHkMBBhUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538969; c=relaxed/simple;
	bh=EG6Ch0mSOepSOPeDoBCnZWNmQwKLBafkxZpZBh0iqtg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DHuarBQLfjKEgye/s3TTS8X7eYvwOyo3Dsbkjn3zdZQVO3YMDgjs7BhaMED1nJYaHmO0l12r/p0Xj8qpkR4Cq3/66WB1+GpAR9bw40N5PCOR3BWZHoN6htfvBgPCYeqrpOgwU+oxfDs92cfxAcezMojhJAV6upQnZk89aP27TRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=idRwDPMa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="idRwDPMa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3S6ntfnJ/Mttd+t3+rSdcxM6Jo8r6DNkjdxq43w+JDI=; b=idRwDPMa/1mhc9knuQ1IMinnMU
	FQ3aK7oA+CoznHpL0Jce9W0VvBSgvpkoQjTRd9YgVzH8tznUPJPk5UJ+d3hs+TpZHUJ1Vi8MHRyAf
	xC5qTXDOeLWREkbhCSTf9TUNrFiS0Tepw3S0hyRiVKjJSCTktzcgC3rkCMQppM/HCwWgBmmj0fSq0
	zxlHGNyDrXaDJoohXROVEUNgqsTvTAPKrSw42OmG6ufUK3I6BrWYHnxrOG6/BMvhfEfag/r3m6TtZ
	V97ZjDXOeh8GSqGXZPbrzELNV0MtxRB/wWaedYOU8DZN+tfhcI6cNR/68N9PmGBeFf3lewxk8m10i
	P80WKlQw==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSk2-0000000D6S6-0A7O;
	Mon, 29 Jan 2024 14:36:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 17/20] xfs: remove xfarray_sortinfo.page_kaddr
Date: Mon, 29 Jan 2024 15:34:59 +0100
Message-Id: <20240129143502.189370-18-hch@lst.de>
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

Now that xfile pages don't need kmapping, there is no need to cache
the kernel virtual address for them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfarray.c | 22 ++++------------------
 fs/xfs/scrub/xfarray.h |  1 -
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index d0f98a43b2ba0a..82b2a35a8e8630 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -570,18 +570,7 @@ xfarray_sort_get_page(
 	loff_t			pos,
 	uint64_t		len)
 {
-	int			error;
-
-	error = xfile_get_page(si->array->xfile, pos, len, &si->xfpage);
-	if (error)
-		return error;
-
-	/*
-	 * xfile pages must never be mapped into userspace, so we skip the
-	 * dcache flush when mapping the page.
-	 */
-	si->page_kaddr = page_address(si->xfpage.page);
-	return 0;
+	return xfile_get_page(si->array->xfile, pos, len, &si->xfpage);
 }
 
 /* Release a page we grabbed for sorting records. */
@@ -589,11 +578,8 @@ static inline int
 xfarray_sort_put_page(
 	struct xfarray_sortinfo	*si)
 {
-	if (!si->page_kaddr)
+	if (!xfile_page_cached(&si->xfpage))
 		return 0;
-
-	si->page_kaddr = NULL;
-
 	return xfile_put_page(si->array->xfile, &si->xfpage);
 }
 
@@ -636,7 +622,7 @@ xfarray_pagesort(
 		return error;
 
 	xfarray_sort_bump_heapsorts(si);
-	startp = si->page_kaddr + offset_in_page(lo_pos);
+	startp = page_address(si->xfpage.page) + offset_in_page(lo_pos);
 	sort(startp, hi - lo + 1, si->array->obj_size, si->cmp_fn, NULL);
 
 	xfarray_sort_bump_stores(si);
@@ -883,7 +869,7 @@ xfarray_sort_load_cached(
 			return error;
 	}
 
-	memcpy(ptr, si->page_kaddr + offset_in_page(idx_pos),
+	memcpy(ptr, page_address(si->xfpage.page) + offset_in_page(idx_pos),
 			si->array->obj_size);
 	return 0;
 }
diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index 62b9c506fdd1b7..6f2862054e194d 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -107,7 +107,6 @@ struct xfarray_sortinfo {
 
 	/* Cache a page here for faster access. */
 	struct xfile_page	xfpage;
-	void			*page_kaddr;
 
 #ifdef DEBUG
 	/* Performance statistics. */
-- 
2.39.2

