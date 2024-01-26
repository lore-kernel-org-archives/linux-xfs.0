Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782741BC21
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275823; cv=none; b=hXuL5FGxKUP+sG/92kBcx5vQzGOShcHm4FXorsJoqgfNdjR1Ckjpk8n+kXa6Xo4mbrg/kFKrW0vg8lbOyVrv5H93mst8Vc/usmKg9fYh7/V2iWPZYZYMbxSFr5iJQ90rkLD/ihBwsBNQWDcdeM+9GXPuSJ4FVWJUL3b2bibbtpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275823; c=relaxed/simple;
	bh=EG6Ch0mSOepSOPeDoBCnZWNmQwKLBafkxZpZBh0iqtg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c9/wpQM7iwGs45S9Ka4NCNPCEzu7FEhq6/njzKg3ERR+ER6tCCEokqaUQtyu7uQ9YqwB+/ovWixUWKKZ1L2T4jvSb38UlascAjNZ2d+Uwa9ekMqr1LvdV986my9/c54tk0YKVKL+fWy2PQtwHfo7d0mShJr2xog+Nu9e9pgPSkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sNyn4VLF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sNyn4VLF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3S6ntfnJ/Mttd+t3+rSdcxM6Jo8r6DNkjdxq43w+JDI=; b=sNyn4VLFKK7KKN6xXdNVh+Gfrs
	YBZlvjHMYwgFA+xKWQrZF1xEy98zlVXD3oWPI4rdiDn9jHVZVBojX4ktb8ro0huk+/Rtbvq+3aHEL
	o3EGv5vggwpFIXq8rztl0TM014nJRnm8iHWkaejOlbiCKE+5Ph0d+SwuGkIfUQmxAqMiulNZzZJcn
	EZCy8mEVpGPIJ2DWHMcl7+3xIyLOq3Ujt5AAIFOL1ypE70AZQ7RtPkXdwJ8/il5RKfyYfW+59dNJn
	qIsySAjobSf/eQAHXDf0Jttu575b5KGI33DUnN7B6fjakfL/PLC0nqI1LgytJWT2es+JJQHy2oQld
	kWF9qCAQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMHk-00000004Cwj-3jOh;
	Fri, 26 Jan 2024 13:30:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 18/21] xfs: remove xfarray_sortinfo.page_kaddr
Date: Fri, 26 Jan 2024 14:29:00 +0100
Message-Id: <20240126132903.2700077-19-hch@lst.de>
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

