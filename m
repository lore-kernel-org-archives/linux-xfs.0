Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DCA183CC3
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 05:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769750429; cv=none; b=XsL8vu5byLGAMcAzbSa4KjSxFgI291o9h7+oltFbkdE9CY5TRkwoIpWN1Wpr7ZNFeHep95BwR38kzrxCgzjUww8wZLuAM3arvNxKN4jTvPt5d45UU+XPIUYzYAu0r95F0lrG36agA1rDU2kUsAxkNeB+fdDTLGT49Jb1BNNJJ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769750429; c=relaxed/simple;
	bh=mIMPNQYuYj2jhh6nIQfWmc4CX+wUYcDuEQuu3/mYN00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W82PEJNoY0izsi7/LqOFBgph7EcVshd3YfscuW6oeL0aBMfNteQXi9JoAeHttVDHF5ityfz77b6UvdL4VOCkl6kF0gotAEsfXZPgBMEY3lvGz3qprXTlo/NzozKH8XtXR/9QVIPNns8Wwd2vI6oUDIspy6MB79NrteI8Re53oTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FouSQfQH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FouSQfQH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1o5K1t2Trrzj+eSwJso9d1oru+a+GXJ3jJYSLLzcMsU=; b=FouSQfQHQG5jVDlZGuz0t8sMlz
	/TYC5US6/iN06/mvmYkDxRgSnCYPbU+AN+vojPG9C9Ctc6RkkPXnrpMTseWMwt4jWE5IgLtD/Z4g8
	l7A5pnn6HSyz6fCa6i2szXaMWLgYZICV1APjOfRqHK/ojS8/UF5uBXdbrIl5qJAiBN1kxY21sU3Pb
	eREk4stvIeDuw8QQkNku8Pp+jphB7qtsnqm2XYO8YiCJUzqAvXJY6D9XapGdM8opgoOJX5e89Gmj5
	L8xV/BEkfQI74XUBU6QmulrO1kAQCLyKdRlAbAlPcC79NHBW/kLndg/66DtO7zU1n9sW68p0Qn0eT
	/QSjPlKg==;
Received: from [185.190.48.89] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vlgvi-000000013Hw-2JDW;
	Fri, 30 Jan 2026 05:20:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 03/11] xfs: don't validate error tags in the I/O path
Date: Fri, 30 Jan 2026 06:19:18 +0100
Message-ID: <20260130052012.171568-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130052012.171568-1-hch@lst.de>
References: <20260130052012.171568-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We can trust XFS developers enough to not pass random stuff to
XFS_ERROR_TEST/DELAY.  Open code the validity check in xfs_errortag_add,
which is the only place that receives unvalidated error tag values from
user space, and drop the now pointless xfs_errortag_enabled helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_errortag.h |  2 +-
 fs/xfs/xfs_error.c           | 38 ++++++++++--------------------------
 fs/xfs/xfs_error.h           |  2 +-
 3 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 57e47077c75a..b7d98471684b 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -53,7 +53,7 @@
  * Drop-writes support removed because write error handling cannot trash
  * pre-existing delalloc extents in any useful way anymore. We retain the
  * definition so that we can reject it as an invalid value in
- * xfs_errortag_valid().
+ * xfs_errortag_add().
  */
 #define XFS_ERRTAG_DROP_WRITES				28
 #define XFS_ERRTAG_LOG_BAD_CRC				29
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index dfa4abf9fd1a..52a1d51126e3 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -125,30 +125,6 @@ xfs_errortag_del(
 	xfs_sysfs_del(&mp->m_errortag_kobj);
 }
 
-static bool
-xfs_errortag_valid(
-	unsigned int		error_tag)
-{
-	if (error_tag >= XFS_ERRTAG_MAX)
-		return false;
-
-	/* Error out removed injection types */
-	if (error_tag == XFS_ERRTAG_DROP_WRITES)
-		return false;
-	return true;
-}
-
-bool
-xfs_errortag_enabled(
-	struct xfs_mount	*mp,
-	unsigned int		tag)
-{
-	if (!xfs_errortag_valid(tag))
-		return false;
-
-	return mp->m_errortag[tag] != 0;
-}
-
 bool
 xfs_errortag_test(
 	struct xfs_mount	*mp,
@@ -158,9 +134,6 @@ xfs_errortag_test(
 {
 	unsigned int		randfactor;
 
-	if (!xfs_errortag_valid(error_tag))
-		return false;
-
 	randfactor = mp->m_errortag[error_tag];
 	if (!randfactor || get_random_u32_below(randfactor))
 		return false;
@@ -178,8 +151,17 @@ xfs_errortag_add(
 {
 	BUILD_BUG_ON(ARRAY_SIZE(xfs_errortag_random_default) != XFS_ERRTAG_MAX);
 
-	if (!xfs_errortag_valid(error_tag))
+	if (error_tag >= XFS_ERRTAG_MAX)
+		return -EINVAL;
+
+	/* Error out removed injection types */
+	switch (error_tag) {
+	case XFS_ERRTAG_DROP_WRITES:
 		return -EINVAL;
+	default:
+		break;
+	}
+
 	mp->m_errortag[error_tag] = xfs_errortag_random_default[error_tag];
 	return 0;
 }
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 3a78c8dfaec8..ec22546a8ca8 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -44,7 +44,7 @@ bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
 #define XFS_ERRORTAG_DELAY(mp, tag)		\
 	do { \
 		might_sleep(); \
-		if (!xfs_errortag_enabled((mp), (tag))) \
+		if (!mp->m_errortag[tag]) \
 			break; \
 		xfs_warn_ratelimited((mp), \
 "Injecting %ums delay at file %s, line %d, on filesystem \"%s\"", \
-- 
2.47.3

