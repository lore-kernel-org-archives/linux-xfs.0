Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C6C200AB
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324094; cv=none; b=t03qJ/177J0pP2S6hSE4ivmzn86tr6KXuMesFHGCtDHokXe776rMBENLkq4ZDwZHcXAjyxch1otF6Fu3FEZMuzK9XnjPID0X+jOZKXQJXB35tWSg7TOxBi2sqmt/FETznAsu8TnlyUefe4+vDZ11qVnUQWswwJIlOGT2kEcRTHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324094; c=relaxed/simple;
	bh=EG6Ch0mSOepSOPeDoBCnZWNmQwKLBafkxZpZBh0iqtg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n9uLRZXVamNG7dcV4cLNpOAMcgtYqW+zRaJL4NlwjRw55uu0EU3q8IK0BfdUQTcjN984dKMbsEcP/TxirbnbUYNrSnGEkAvlhQcNil5bTC/7sqZPm/qvNba4KxInwPs1h6qb3rxQKe4K/3GQ27mzW01VU7y09X+IPNuuJo4EJaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qukGHfrg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qukGHfrg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3S6ntfnJ/Mttd+t3+rSdcxM6Jo8r6DNkjdxq43w+JDI=; b=qukGHfrgvmCkUKibrGcqlD6fPi
	Hoc4k6zg8xjQIztJlzH7nifjE+PhY6CZR4I+DpVcoGDzS+MU8U5QcQj6CMS0Q8oA5whu1MdDUt/8+
	bINQxzKyIrBN8nMvliOYGD5Gw1kVkJ3vSjKHltfFb5NGhI0KAR23qs0OsOYyZDNQu6uodlIY3I1Ab
	X2A3wGDVR3w/wD5MILvfjYyvO8vZfpAGIsrPCIrVY+DESAZVc8cKuBfFqSt5T5ptJ8OIPxNK/qL0H
	vGW6P9nFH5HOFl00nsvo0EvoreumP7zTp6aQt4mBOolmxhYcIUk5Y79KNdjhUiwWscUZbRBKh/aI1
	3rBVbauQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx8N-00000009FNK-18XK;
	Mon, 19 Feb 2024 06:28:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 19/22] xfs: remove xfarray_sortinfo.page_kaddr
Date: Mon, 19 Feb 2024 07:27:27 +0100
Message-Id: <20240219062730.3031391-20-hch@lst.de>
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

