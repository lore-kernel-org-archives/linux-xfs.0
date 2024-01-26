Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAA51B813
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275808; cv=none; b=HePg12qSpxco6Wn2u1NP84Lbr2fpUrN/V2icn3PET+RTJND4c6Jyk8pNFVEQkHei2Dzx7Zl/0hnghizS0vp8hvS/VjglYo/hdaPRqXrQrFg0OZ4Gdhe4TlZDihatMKKAZHqo1fFB/2veZFsY6yFZKomSQIfxKC4swjPnEMcOjis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275808; c=relaxed/simple;
	bh=qSCmOc+q3DEnM+aVGU1Pm8dTsMHm4yWswv3khhCLa28=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B7n69oQhyzB3fqXdN8bpkima5hibnsN/dIaeqTa1jvlZ8UzjNy47raHLNPI3VDDCrYyAhFUhvIfMc7qxlVERj+AaOObQ///llyG4nutezMGdS7OQZmynWZ34JmQ+Y0OozvmkxaVZVypeeJZd4eOnM0HUWCb0GJWu5OPkzVsJVto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QHu/d9AT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QHu/d9AT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sf3jM42VSS5lq6M4a06uH+ctEmnHV/8RQw6R+NlmD18=; b=QHu/d9ATjk8ngW++aVNk58xD4m
	WCtoflSjasmfKaq9+PwqNFLLqo7o6ZDNehgioZY+k2QmbbAR8fSLNMe8JrDsHbPNifQkdSHIoPHA1
	abMYA2YfBPIISehCz4grqvAEv0Zrcb/of7nNML1rnosa6VeuWRG9QrmKBtEuUyMMVLf1pZgxQ935+
	fcAMlMp/eUh0/leU4UpZzFsp2xW8IVs7KZvMC9WRV7f4qqgDo9odHXSKiDRYd5tQ4qNtbmmak/jQj
	lHG9sCYLL/tJXIyIdCJNLvLf19Jvne4AdmQ7tW0zo+zaqE3gjqdEKE+6JKIcE89Uqqg5CssXRT/l5
	fnsrli/Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMHV-00000004Cq7-29PL;
	Fri, 26 Jan 2024 13:30:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 13/21] xfs: don't allow highmem pages in xfile mappings
Date: Fri, 26 Jan 2024 14:28:55 +0100
Message-Id: <20240126132903.2700077-14-hch@lst.de>
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

XFS is generally used on 64-bit, non-highmem platforms and xfile
mappings are accessed all the time.  Reduce our pain by not allowing
any highmem mappings in the xfile page cache and remove all the kmap
calls for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfarray.c |  3 +--
 fs/xfs/scrub/xfile.c   | 21 +++++++++------------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 95ac14bceeadd6..d0f98a43b2ba0a 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -580,7 +580,7 @@ xfarray_sort_get_page(
 	 * xfile pages must never be mapped into userspace, so we skip the
 	 * dcache flush when mapping the page.
 	 */
-	si->page_kaddr = kmap_local_page(si->xfpage.page);
+	si->page_kaddr = page_address(si->xfpage.page);
 	return 0;
 }
 
@@ -592,7 +592,6 @@ xfarray_sort_put_page(
 	if (!si->page_kaddr)
 		return 0;
 
-	kunmap_local(si->page_kaddr);
 	si->page_kaddr = NULL;
 
 	return xfile_put_page(si->array->xfile, &si->xfpage);
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 7e915385ef0011..623bbde91ae3fe 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -77,6 +77,12 @@ xfile_create(
 	inode = file_inode(xf->file);
 	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
 
+	/*
+	 * We don't want to bother with kmapping data during repair, so don't
+	 * allow highmem pages to back this mapping.
+	 */
+	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+
 	trace_xfile_create(xf);
 
 	*xfilep = xf;
@@ -126,7 +132,6 @@ xfile_load(
 
 	pflags = memalloc_nofs_save();
 	while (count > 0) {
-		void		*p, *kaddr;
 		unsigned int	len;
 
 		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
@@ -153,10 +158,7 @@ xfile_load(
 		 * xfile pages must never be mapped into userspace, so
 		 * we skip the dcache flush.
 		 */
-		kaddr = kmap_local_page(page);
-		p = kaddr + offset_in_page(pos);
-		memcpy(buf, p, len);
-		kunmap_local(kaddr);
+		memcpy(buf, page_address(page) + offset_in_page(pos), len);
 		put_page(page);
 
 advance:
@@ -221,14 +223,13 @@ xfile_store(
 		 * the dcache flush.  If the page is not uptodate, zero it
 		 * before writing data.
 		 */
-		kaddr = kmap_local_page(page);
+		kaddr = page_address(page);
 		if (!PageUptodate(page)) {
 			memset(kaddr, 0, PAGE_SIZE);
 			SetPageUptodate(page);
 		}
 		p = kaddr + offset_in_page(pos);
 		memcpy(p, buf, len);
-		kunmap_local(kaddr);
 
 		ret = aops->write_end(NULL, mapping, pos, len, len, page,
 				fsdata);
@@ -314,11 +315,7 @@ xfile_get_page(
 	 * to the caller and make sure the backing store will hold on to them.
 	 */
 	if (!PageUptodate(page)) {
-		void	*kaddr;
-
-		kaddr = kmap_local_page(page);
-		memset(kaddr, 0, PAGE_SIZE);
-		kunmap_local(kaddr);
+		memset(page_address(page), 0, PAGE_SIZE);
 		SetPageUptodate(page);
 	}
 
-- 
2.39.2

