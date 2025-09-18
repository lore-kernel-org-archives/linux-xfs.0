Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C2221CC63
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 14:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758206098; cv=none; b=X0lKLMmF+OmHW5/jHCikCOqG0kwyaY5hF23Su2EyKyCkQ+Bwwud7SEKoQWOyjfQ/moBUNufWYplKBjqOwtCZm0HATC7ps9OlHq9ObNov35h2UpAmnXhbtgBc7T4I4m7Lyq+lOlpLJISD9WgHt94GwqOAq0eUfH2TFnJArl2IJQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758206098; c=relaxed/simple;
	bh=iWo0EFK7nix6FCNrddAGUFBuybQ0R+RdjpuphEmSx+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bj2brtv9q1dIhfWk50fAY5ThDpcv+NVWHgM9r1c9e0c4rbKMbF0yGGRTPCNOohANxL5Gu20z9Oi7mrP/XVD7g1O5xgyTwqbjgq0XdYyWfGApihinA0Axp4YlmTWHzAXWSYq+ps4bU+5yDlMAG+dXx8XQirZmdNYuL9d8E2D31D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ozeDQ2hg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ozeDQ2hg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zgYg1oteXM/nDIVfeh4JmUqwbT682igamdnL1j7E+Sc=; b=ozeDQ2hgmA86kEm6I7Qhvd3DBG
	t6JxSYbf1hpk/6u94ETRe2X8ELFIp9roCT/Hr294kVhL2mA8gg0BULmHBfIoXxuhLcVZbQrSP7owI
	xgWY6NxB3yO6AayTSzTNu0qfFxSxoIJccn0f1YPQgJyDgs4NQC+zuiIJhoymRM3wtIG4QoMwnZQsr
	EHUJZJ1H3LNIdfBnWl9YqGjDCvRTpJTtsjjbGqsOJL96V0IOGTrnRrkJtF4ZGrgnrDYx+UgVeqamv
	6wcJi5GRNDxgKhZ/H5dAGljxG4918z0l1MJ+iUnSiFYAWiEBWkS2DvTIdMWBd3X4A38DXe9zEaJKW
	OqvsOOHQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzFiq-00000000AE3-29L9;
	Thu, 18 Sep 2025 14:34:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 2/5] xfs: remove xfs_errortag_set
Date: Thu, 18 Sep 2025 07:34:34 -0700
Message-ID: <20250918143454.447290-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250918143454.447290-1-hch@lst.de>
References: <20250918143454.447290-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_errortag_set is only called by xfs_errortag_attr_store, , which does
not need to validate the error tag, because it can only be called on
valid error tags that had a sysfs attribute registered.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_error.c | 29 ++++++-----------------------
 fs/xfs/xfs_error.h |  3 ---
 2 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 45a43e47ce92..fac35ff3da65 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -93,21 +93,18 @@ xfs_errortag_attr_store(
 	size_t			count)
 {
 	struct xfs_mount	*mp = to_mp(kobject);
-	struct xfs_errortag_attr *xfs_attr = to_attr(attr);
+	unsigned int		error_tag = to_attr(attr)->tag;
 	int			ret;
-	unsigned int		val;
 
 	if (strcmp(buf, "default") == 0) {
-		val = xfs_errortag_random_default[xfs_attr->tag];
+		mp->m_errortag[error_tag] =
+			xfs_errortag_random_default[error_tag];
 	} else {
-		ret = kstrtouint(buf, 0, &val);
+		ret = kstrtouint(buf, 0, &mp->m_errortag[error_tag]);
 		if (ret)
 			return ret;
 	}
 
-	ret = xfs_errortag_set(mp, xfs_attr->tag, val);
-	if (ret)
-		return ret;
 	return count;
 }
 
@@ -325,19 +322,6 @@ xfs_errortag_test(
 	return true;
 }
 
-int
-xfs_errortag_set(
-	struct xfs_mount	*mp,
-	unsigned int		error_tag,
-	unsigned int		tag_value)
-{
-	if (!xfs_errortag_valid(error_tag))
-		return -EINVAL;
-
-	mp->m_errortag[error_tag] = tag_value;
-	return 0;
-}
-
 int
 xfs_errortag_add(
 	struct xfs_mount	*mp,
@@ -347,9 +331,8 @@ xfs_errortag_add(
 
 	if (!xfs_errortag_valid(error_tag))
 		return -EINVAL;
-
-	return xfs_errortag_set(mp, error_tag,
-			xfs_errortag_random_default[error_tag]);
+	mp->m_errortag[error_tag] = xfs_errortag_random_default[error_tag];
+	return 0;
 }
 
 int
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 3aeb03001acf..fd60a008f9d2 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -58,8 +58,6 @@ bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
 		mdelay((mp)->m_errortag[(tag)]); \
 	} while (0)
 
-extern int xfs_errortag_set(struct xfs_mount *mp, unsigned int error_tag,
-		unsigned int tag_value);
 extern int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
 extern int xfs_errortag_clearall(struct xfs_mount *mp);
 #else
@@ -67,7 +65,6 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
 #define xfs_errortag_del(mp)
 #define XFS_TEST_ERROR(expr, mp, tag)		(expr)
 #define XFS_ERRORTAG_DELAY(mp, tag)		((void)0)
-#define xfs_errortag_set(mp, tag, val)		(ENOSYS)
 #define xfs_errortag_add(mp, tag)		(ENOSYS)
 #define xfs_errortag_clearall(mp)		(ENOSYS)
 #endif /* DEBUG */
-- 
2.47.2

