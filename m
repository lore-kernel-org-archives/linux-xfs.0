Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FE72FD1A6
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943067; cv=none; b=c+81mnYKzy9sYHt+A1yuk4C8NVuP3rp2LY4PFgGJwq1UmCAGrvhNPOmAOp5uqp5Ah3gxaX5eCr8WQGZgn71CxW75MgZqomkZTy7e6rwQdHJMmzVCtO74iXgDuQZRu3a2fcIOJei5kDIgMrwIUTaDhxM3p3P3USnHF9nSHDHm/+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943067; c=relaxed/simple;
	bh=EBh99QjxboHOVaEsbc7UJXHycgaCQB15ZmvZWsFvS1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzxFlO3Pm1lFsK2D/Zfg/O1qpcGSejZDh/OwlNNSHf4BKqkX2FQXDEdS69oZ7zQZcMQqGsPri6u3BE8mfwmSkjiir0xTAufDMIwbOcACKfTmHETx4uSEZc/aBdcbPSSOPB/cNfTSdn6D8ri0FADo3BZlxYT2G8PrLn9syF0+7Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fQDUbQNX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fQDUbQNX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RE6wKUAPNgkMCxDVStFYkCBcdCJ2SU6NE2ycQQA9G/g=; b=fQDUbQNX77ZVwT/VvklfJhmohr
	D9r+f6h6ERjZjXrKNEI/1lxV4tiehyhDLJVZx/J1bVC/6PMM12/EoILdvVyQUgfNlkHNuez8lDS7d
	xAq2pkCTZAyFIcmy22kg0tncveFnVKn3GVJcLe1TKxO8Y/ca5k1GjDcgC+pvrLve0uopKFnwYDadz
	5hoaFJ9EA1Bn5BOTh91ODNXxskQKJB66OPpwrWP+wJ+LZeHVdLDCJPxGByiRWGC9ZPC8bjJkS6acy
	KiYhs8kLdjkxudmr2SlGx6QSHT9ORAgzXyfaGrwEy3fSbm8vAyzf18MEnYuc2/FMog7EvJAlxiyZ9
	2Nxgimpg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9IP-00000004KU8-17ud;
	Mon, 15 Sep 2025 13:31:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: remove xfs_errortag_get
Date: Mon, 15 Sep 2025 06:30:37 -0700
Message-ID: <20250915133104.161037-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915133104.161037-1-hch@lst.de>
References: <20250915133104.161037-1-hch@lst.de>
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

