Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A51435DCE6
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769529997; cv=none; b=ZjKtjJodKFl0UX9rDIlpzoBC//OPJ8XnZK0T836o6q+qc1a8Xso6fzknlKuSoZcalJvXX4yCyOnRa3btQzLQoTAGfqZ+w/0zzZfTro9urNsTiK2MQrw2cHxXeljmMbcXyTuFs1KQCOVV+qTYjVJbP+TskR5EAVotY8X51qlzgX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769529997; c=relaxed/simple;
	bh=SkAjGJ7e5OMPQtEtgZprCktEJOmV5nwqHou2caMUmyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKtzUW4/tTs1nx3nJYBA46ZO4GIeoTVyGnsRW3JchsAFHnPJEL3GpMJmX78HYhV9wtWg3FfqS0Wb7rJAkRl/v/NNvFvPNORa8QOufzUu4zzkaFQQdgYZJ6JhLM6WHftcCPEyJ9myEI4MHfLBFLXMgRt9HsaSUdbCRrSGqNkoCsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pQ/ze8XF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pQ/ze8XF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CrH24MyNJi5fjcYUR3gJlDwp1FCJqgDC4eL+x+vJR1M=; b=pQ/ze8XFznVcr2bQ0YNEM4bMvT
	3g4CDuORwZlrXVwa9Lf9GIx/fhUqC79R6/AejJC5iPvmOgAnh2jmUD+bwmfFbw6+D1c9jhtlLCwuL
	M3my9l2wud0zYwtXJ3ZksNCyJKsEB4yYkao7qM9ct4hqn3ZRP68FMVRDgX5IeBupMkmre+sAO/O4O
	4LZreeugxkT1bk9PG9llstk4Bri1YEHY7fg/e35r7uQyRkQ08aKOHOLVkw2QdKQZube5X4OCHDGLs
	7fUglrxLrBiqD6mhOtBUUWUVmCmnNFMHLkubzM52V9sKofTdVBj5ps8BthfJ623t266NY9bRRNkdr
	+TNdOBvQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vklaM-0000000Ebkc-0cxz;
	Tue, 27 Jan 2026 16:06:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/10] xfs: allocate m_errortag early
Date: Tue, 27 Jan 2026 17:05:42 +0100
Message-ID: <20260127160619.330250-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260127160619.330250-1-hch@lst.de>
References: <20260127160619.330250-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Ensure the mount structure always has a valid m_errortag for debug
builds.  This removes the NULL checking from the runtime code, and
prepares for allowing to set errortags from mount.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_error.c | 26 +-------------------------
 fs/xfs/xfs_super.c | 12 ++++++++++++
 2 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 873f2d1a134c..dfa4abf9fd1a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -114,18 +114,8 @@ int
 xfs_errortag_init(
 	struct xfs_mount	*mp)
 {
-	int ret;
-
-	mp->m_errortag = kzalloc(sizeof(unsigned int) * XFS_ERRTAG_MAX,
-				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
-	if (!mp->m_errortag)
-		return -ENOMEM;
-
-	ret = xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
+	return xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
 				&mp->m_kobj, "errortag");
-	if (ret)
-		kfree(mp->m_errortag);
-	return ret;
 }
 
 void
@@ -133,7 +123,6 @@ xfs_errortag_del(
 	struct xfs_mount	*mp)
 {
 	xfs_sysfs_del(&mp->m_errortag_kobj);
-	kfree(mp->m_errortag);
 }
 
 static bool
@@ -154,8 +143,6 @@ xfs_errortag_enabled(
 	struct xfs_mount	*mp,
 	unsigned int		tag)
 {
-	if (!mp->m_errortag)
-		return false;
 	if (!xfs_errortag_valid(tag))
 		return false;
 
@@ -171,17 +158,6 @@ xfs_errortag_test(
 {
 	unsigned int		randfactor;
 
-	/*
-	 * To be able to use error injection anywhere, we need to ensure error
-	 * injection mechanism is already initialized.
-	 *
-	 * Code paths like I/O completion can be called before the
-	 * initialization is complete, but be able to inject errors in such
-	 * places is still useful.
-	 */
-	if (!mp->m_errortag)
-		return false;
-
 	if (!xfs_errortag_valid(error_tag))
 		return false;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e05bf62a5413..ee335dbe5811 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -40,6 +40,7 @@
 #include "xfs_defer.h"
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
+#include "xfs_errortag.h"
 #include "xfs_iunlink_item.h"
 #include "xfs_dahash_test.h"
 #include "xfs_rtbitmap.h"
@@ -822,6 +823,9 @@ xfs_mount_free(
 	debugfs_remove(mp->m_debugfs);
 	kfree(mp->m_rtname);
 	kfree(mp->m_logname);
+#ifdef DEBUG
+	kfree(mp->m_errortag);
+#endif
 	kfree(mp);
 }
 
@@ -2254,6 +2258,14 @@ xfs_init_fs_context(
 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
 	if (!mp)
 		return -ENOMEM;
+#ifdef DEBUG
+	mp->m_errortag = kcalloc(XFS_ERRTAG_MAX, sizeof(*mp->m_errortag),
+			GFP_KERNEL);
+	if (!mp->m_errortag) {
+		kfree(mp);
+		return -ENOMEM;
+	}
+#endif
 
 	spin_lock_init(&mp->m_sb_lock);
 	for (i = 0; i < XG_TYPE_MAX; i++)
-- 
2.47.3

