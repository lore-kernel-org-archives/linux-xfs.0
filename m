Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BAF1A9FB8
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758040130; cv=none; b=MNL0cLezFPN/59sOXCWPi0OeLxxIsqNIiTa6q9+M4FsnssT7T4ugfqw/CT6bYjEGmlzQlhq0Bl8xL/sva5zuHVLgI2wAtG0x37dg9H7xvEEHknhuFP4xmDOTn9Rk0CiakBG1IxFWCEI0xu3zEv3AlcRaqnt3ZpF6ZdgKzRvJExk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758040130; c=relaxed/simple;
	bh=op6mvmwdAXxyTSvmcToJVAbphIb2ycpMSMQx+g6q0Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwsBtQLgtItb/R6LKjQP55P2YDTFrGUWrqA4P8j9XzGLW3Q4V80C5yAmxeEo7S0N5iZh7DzDW0ut4N2WOgq4KNL+C+LtMzT59kdiToTtuBpAnlL/nDEphC9bzDA2r7rN0Rlmi01cpSD7A4GPJqyiXCxgKAobYoZQm/snQUlzTcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mHzoXhac; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mHzoXhac"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+jX7qbLYHMipzEPAcA0qmCSrcnZpYfl9fALE+uItK+U=; b=mHzoXhacmWl54lSKdGr9Oji1mb
	ebTnTAupMXMt60Oc84/Bu+zNaByo7btoFOJ+e1mkn/MLhwpbFzuPE9IjQ4DXc8hP8iD5OMLv5iiOX
	mPzjVoWGWJo79jDOJayxfvYMCmzFVE0raPdPx6uHmFc8NL8SHik8zhcQRBJEebi7LXEHzt9SyyETF
	z2F/7E2h2wv+1NGq9J2iLoHUA35XFaCxBSIHwM6gRatpsCr3xsFHBEnox+yP34hnMpRGrjJfDKx6R
	ZoSkE/4QQOIB9lDv/+ReH76EBXOxIKRit4amKeWqdq8rvSRbcMPrJ4FjfAvFoCj7gS/nTsGUGhgTr
	eDkwN42A==;
Received: from [206.0.71.8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyYXx-00000008T2n-04yL;
	Tue, 16 Sep 2025 16:28:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 1/6] xfs: remove xfs_errortag_get
Date: Tue, 16 Sep 2025 09:28:14 -0700
Message-ID: <20250916162843.258959-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250916162843.258959-1-hch@lst.de>
References: <20250916162843.258959-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_errortag_get is only called by xfs_errortag_attr_show, which does not
need to validate the error tag, because it can only be called on valid
error tags that had a sysfs attribute registered.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_error.c | 16 ++--------------
 fs/xfs/xfs_error.h |  1 -
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index dbd87e137694..45a43e47ce92 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -118,10 +118,9 @@ xfs_errortag_attr_show(
 	char			*buf)
 {
 	struct xfs_mount	*mp = to_mp(kobject);
-	struct xfs_errortag_attr *xfs_attr = to_attr(attr);
+	unsigned int		error_tag = to_attr(attr)->tag;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n",
-			xfs_errortag_get(mp, xfs_attr->tag));
+	return snprintf(buf, PAGE_SIZE, "%u\n", mp->m_errortag[error_tag]);
 }
 
 static const struct sysfs_ops xfs_errortag_sysfs_ops = {
@@ -326,17 +325,6 @@ xfs_errortag_test(
 	return true;
 }
 
-int
-xfs_errortag_get(
-	struct xfs_mount	*mp,
-	unsigned int		error_tag)
-{
-	if (!xfs_errortag_valid(error_tag))
-		return -EINVAL;
-
-	return mp->m_errortag[error_tag];
-}
-
 int
 xfs_errortag_set(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 0b9c5ba8a598..3aeb03001acf 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -58,7 +58,6 @@ bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
 		mdelay((mp)->m_errortag[(tag)]); \
 	} while (0)
 
-extern int xfs_errortag_get(struct xfs_mount *mp, unsigned int error_tag);
 extern int xfs_errortag_set(struct xfs_mount *mp, unsigned int error_tag,
 		unsigned int tag_value);
 extern int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
-- 
2.47.2

