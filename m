Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6BF7083C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532656; cv=none; b=rvI5MXAZgd2dj0C+TPzmqZDvDxAk3zw5mmokrblNEef1xXKcIQOaCdkNbE2hulubTXhQz0TBwi53stE0J0al+tF0ntv3tavDgx8bcMNmVBnljDYbDm8o+Pr4fD7wnt1APD8fnEUo8MoSLY+Tgx/+wh3Tkk3RrNm9kPi/5DKUTQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532656; c=relaxed/simple;
	bh=uQnKkAS3fGGO1Jz+JvTxJGiR0jbFuGw6Z786vn3Q2Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7SFOsL6yzA9ZMZsio8VCisDMLq+cmgiH3kXYpVK7BbtAxKu+/2TEg/rdyeMMXKJt5kmGsaiIDW4Z27lrLTDjgjf8vRyheMIeqzsgX273WJYvb+rDZ758pkmgsMFn3TmHYcNdb/VpJ5sSFIGOeCs6BZ60D/gQrWaVMkaGELoFPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OzECYquy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OzECYquy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mXT+6KtI/fE36k1nWy8Rkc3gW3P0YmTZ8oy9ruw8uAo=; b=OzECYquyGCyy8/RhEl0KqK8VDf
	qmqU6+ZFtWGbDs9Y2rJfp02eOVRTI7vYg5sOX1osiU4iGO8rguNwtND626TDaX2Rz009NATAOOY/R
	ZOKk+NPxLS+4OMfYOzDl8lDJwHIJrHyxnt7IcbXJU1J8DRpqXLSr6o15a1V4WWooyBWcow9sh5PN1
	2ELihjp4JByM8apzUYLcc6GrTvopG8C5cXyuPSyZdo995ehjsv5zfTfAIpS9vLNaNbrL207QTJjEi
	jNp8PvthtLNTFx+hKllkKaKKL/IJeWPcigdyUZmMu3zK/GqvAyI4RSGhbg+aQXMQ8HTXpp39xASD0
	32XqpASg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrMc-00000005pOD-2dqS;
	Tue, 10 Jun 2025 05:17:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 16/17] xfs: move the XLOG_REG_ constants out of xfs_log_format.h
Date: Tue, 10 Jun 2025 07:15:13 +0200
Message-ID: <20250610051644.2052814-17-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250610051644.2052814-1-hch@lst.de>
References: <20250610051644.2052814-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

These are purely in-memory values and not used at all in xfsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 37 ----------------------------------
 fs/xfs/xfs_log.h               | 37 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e5e6f8c0408f..da99ab4aea6c 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -86,43 +86,6 @@ struct xfs_unmount_log_format {
 	uint32_t	pad2;	/* may as well make it 64 bits */
 };
 
-/* Region types for iovec's i_type */
-#define XLOG_REG_TYPE_BFORMAT		1
-#define XLOG_REG_TYPE_BCHUNK		2
-#define XLOG_REG_TYPE_EFI_FORMAT	3
-#define XLOG_REG_TYPE_EFD_FORMAT	4
-#define XLOG_REG_TYPE_IFORMAT		5
-#define XLOG_REG_TYPE_ICORE		6
-#define XLOG_REG_TYPE_IEXT		7
-#define XLOG_REG_TYPE_IBROOT		8
-#define XLOG_REG_TYPE_ILOCAL		9
-#define XLOG_REG_TYPE_IATTR_EXT		10
-#define XLOG_REG_TYPE_IATTR_BROOT	11
-#define XLOG_REG_TYPE_IATTR_LOCAL	12
-#define XLOG_REG_TYPE_QFORMAT		13
-#define XLOG_REG_TYPE_DQUOT		14
-#define XLOG_REG_TYPE_QUOTAOFF		15
-#define XLOG_REG_TYPE_LRHEADER		16
-#define XLOG_REG_TYPE_UNMOUNT		17
-#define XLOG_REG_TYPE_COMMIT		18
-#define XLOG_REG_TYPE_TRANSHDR		19
-#define XLOG_REG_TYPE_ICREATE		20
-#define XLOG_REG_TYPE_RUI_FORMAT	21
-#define XLOG_REG_TYPE_RUD_FORMAT	22
-#define XLOG_REG_TYPE_CUI_FORMAT	23
-#define XLOG_REG_TYPE_CUD_FORMAT	24
-#define XLOG_REG_TYPE_BUI_FORMAT	25
-#define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_ATTRI_FORMAT	27
-#define XLOG_REG_TYPE_ATTRD_FORMAT	28
-#define XLOG_REG_TYPE_ATTR_NAME		29
-#define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_XMI_FORMAT	31
-#define XLOG_REG_TYPE_XMD_FORMAT	32
-#define XLOG_REG_TYPE_ATTR_NEWNAME	33
-#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
-#define XLOG_REG_TYPE_MAX		34
-
 /*
  * Flags to log operation header
  *
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 110f02690f85..c4930e925fed 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -21,6 +21,43 @@ struct xfs_log_vec {
 	int			lv_alloc_size;	/* size of allocated lv */
 };
 
+/* Region types for iovec's i_type */
+#define XLOG_REG_TYPE_BFORMAT		1
+#define XLOG_REG_TYPE_BCHUNK		2
+#define XLOG_REG_TYPE_EFI_FORMAT	3
+#define XLOG_REG_TYPE_EFD_FORMAT	4
+#define XLOG_REG_TYPE_IFORMAT		5
+#define XLOG_REG_TYPE_ICORE		6
+#define XLOG_REG_TYPE_IEXT		7
+#define XLOG_REG_TYPE_IBROOT		8
+#define XLOG_REG_TYPE_ILOCAL		9
+#define XLOG_REG_TYPE_IATTR_EXT		10
+#define XLOG_REG_TYPE_IATTR_BROOT	11
+#define XLOG_REG_TYPE_IATTR_LOCAL	12
+#define XLOG_REG_TYPE_QFORMAT		13
+#define XLOG_REG_TYPE_DQUOT		14
+#define XLOG_REG_TYPE_QUOTAOFF		15
+#define XLOG_REG_TYPE_LRHEADER		16
+#define XLOG_REG_TYPE_UNMOUNT		17
+#define XLOG_REG_TYPE_COMMIT		18
+#define XLOG_REG_TYPE_TRANSHDR		19
+#define XLOG_REG_TYPE_ICREATE		20
+#define XLOG_REG_TYPE_RUI_FORMAT	21
+#define XLOG_REG_TYPE_RUD_FORMAT	22
+#define XLOG_REG_TYPE_CUI_FORMAT	23
+#define XLOG_REG_TYPE_CUD_FORMAT	24
+#define XLOG_REG_TYPE_BUI_FORMAT	25
+#define XLOG_REG_TYPE_BUD_FORMAT	26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME		29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_XMI_FORMAT	31
+#define XLOG_REG_TYPE_XMD_FORMAT	32
+#define XLOG_REG_TYPE_ATTR_NEWNAME	33
+#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
+#define XLOG_REG_TYPE_MAX		34
+
 #define XFS_LOG_VEC_ORDERED	(-1)
 
 /*
-- 
2.47.2

