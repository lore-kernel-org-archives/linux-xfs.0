Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160C2315D2F
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942834; cv=none; b=SrrMpBDyKgkEMpVXL+nvzfU4j19s8U/Qcqk+5+k9BRZwmzrTs+DaivlLA6TM7irke8FuYrAw7Uf2vM3jMCLJNt6o02xr7A/SyoPbAdeFPRlHTgOQ7bE3gNrlgsVH4RlqPb+vfvKZLL7W8xju61FdYU9pwFhvzHw7JUSa5jtJ1BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942834; c=relaxed/simple;
	bh=tNnrCAwyetCeJ2hCpD57BE0ISr/BLgOlQegFM4DbB+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMrjmZ47iKMyuGsQS2UXzYDOV48c7Vkt8xxbzprHijZ9qmQ+jqHzIeynGwBZmr1CuyLTRbvH+PIpmSfJlQNP/JIAjVC4wTYnplDNv4mRHHnMEQNcJv1arNgpbG3e3delh6W7JLtkNgr2u10EewWSi5lPG/rrVoAbcU27O52C9Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VfERxs8I; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VfERxs8I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gUqRqgId0jbwKWXSVzFiYdFYtjlnsUm/SgqnHlkPB9I=; b=VfERxs8IAPb8/y7PpTuleNSERt
	4fGyKfsk5s/Oe49HIarUm+hQIiJ1g1N9KBgPSy4nkh4qfLUHt/aA64z4grDWTsqDehpdB3OAGm6T7
	tlyJkHn20NZm3354xj3FuXeWOmT5tjk+6uF8fCgSEpceAa1nl15otEVOnOB3OOe72Z8Kaxksg7g4r
	A0Ljq1HDagVmgZGzR+8MUr/iv7tG6WzmnM2qCim2XMaR8kkrexRjUsBTHTmNgtN3fnHPaN7Uy+Vne
	/4tEGzBbHSWogImy88DtM1qvdZ6rtFZCAHvQDpMATGhhPYGKHydFvaCIzxtJUzL6qoAkeXXofjL27
	2tpGIgmA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ee-00000004Jbl-25KD;
	Mon, 15 Sep 2025 13:27:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 13/15] xfs: remove the unused xfs_dq_logformat_t typedef
Date: Mon, 15 Sep 2025 06:27:03 -0700
Message-ID: <20250915132709.160247-14-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915132709.160247-1-hch@lst.de>
References: <20250915132709.160247-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 1417da3ced32..4ea9749f98e2 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -948,14 +948,14 @@ struct xfs_xmd_log_format {
  * The first two fields must be the type and size fitting into
  * 32 bits : log_recovery code assumes that.
  */
-typedef struct xfs_dq_logformat {
+struct xfs_dq_logformat {
 	uint16_t		qlf_type;      /* dquot log item type */
 	uint16_t		qlf_size;      /* size of this item */
 	xfs_dqid_t		qlf_id;	       /* usr/grp/proj id : 32 bits */
 	int64_t			qlf_blkno;     /* blkno of dquot buffer */
 	int32_t			qlf_len;       /* len of dquot buffer */
 	uint32_t		qlf_boffset;   /* off of dquot in buffer */
-} xfs_dq_logformat_t;
+};
 
 /*
  * log format struct for QUOTAOFF records.
-- 
2.47.2

