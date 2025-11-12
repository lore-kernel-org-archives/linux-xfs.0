Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFC9320A1D
	for <linux-xfs@vger.kernel.org>; Wed, 12 Nov 2025 12:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762949725; cv=none; b=PGavrFgV9meqUlmrh+PjwFkvclYBdWiRfK9PyhqTWQEAPvuTZVo7hoNt1jKKY+o7HX+K901zFd3fT2ZYM6ljkzmXlwlsZl5qK7yC9JXvEgCgAVacFfbpprAUrSny6AykYTl7hH+P06eFSW+74yw4a2lYGjFXrxH+lhWmxDAFCCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762949725; c=relaxed/simple;
	bh=YlN64b61GzRfyt7PyMKBhlXfKuY3R+UMkB8+1dnJoEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1b5he/eszdqJjS6mb0jNwQYrjalKVKyHGBZVx54KVlNSpkJtxb4zF+9gPoIkhpi2soYZ7p3aqQJfnmwSY4nVK97Q/KvgLk12T9yJFqTiOtXD7thMYgQlq3xwdmqZVhvEgNNP+Z3bcXSHusTwdNpA+e2jKzlPw7p2YQZNA1Sbg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GoLJUWMv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GoLJUWMv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CC4Qe3Ipt7qaA1DgcyT5CAf4jRXvSWtyEQHcKiZ0eIs=; b=GoLJUWMv619wCkbHfwjHq+ZKor
	UPoNMXLPAdc+7YGxXZvX29cny2KFfOtY8v1VLaNXLGbyqZUqXkAkgI/Hg8bXvlMd4nL5enLfGSVpD
	dWYcI4KQ1JzwqT8ZyVeNeV/nwQvxz1KvFh9fMO4H1VLENK7eRPIzk+VoZwaOcRMejWY/a0SJ2q4R1
	6/XvmtghjPe+scHdY5hr76NzrjyaCSMp6OMDfmSDl5mL0r1BePaAsI+sFbwx4Inl3KgbQ84lDFhBW
	x1WFXqDT11qGWAaxu62g9h260WHgiY2oB7e5FKWAL9TUuSdh6GapoKsqCY7Hjxuxpl8HIHYPkIF9I
	IZhf/d5A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ9kw-00000008lCd-15D2;
	Wed, 12 Nov 2025 12:15:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 05/10] xfs: move struct xfs_log_vec to xfs_log_priv.h
Date: Wed, 12 Nov 2025 13:14:21 +0100
Message-ID: <20251112121458.915383-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112121458.915383-1-hch@lst.de>
References: <20251112121458.915383-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The log_vec is a private type for the log/CIL code and should not be
exposed to anything else.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.h      | 12 ------------
 fs/xfs/xfs_log_priv.h | 12 ++++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index c4930e925fed..0f23812b0b31 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -9,18 +9,6 @@
 struct xlog_format_buf;
 struct xfs_cil_ctx;
 
-struct xfs_log_vec {
-	struct list_head	lv_list;	/* CIL lv chain ptrs */
-	uint32_t		lv_order_id;	/* chain ordering info */
-	int			lv_niovecs;	/* number of iovecs in lv */
-	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
-	struct xfs_log_item	*lv_item;	/* owner */
-	char			*lv_buf;	/* formatted buffer */
-	int			lv_bytes;	/* accounted space in buffer */
-	int			lv_buf_used;	/* buffer space used so far */
-	int			lv_alloc_size;	/* size of allocated lv */
-};
-
 /* Region types for iovec's i_type */
 #define XLOG_REG_TYPE_BFORMAT		1
 #define XLOG_REG_TYPE_BCHUNK		2
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b7b3f61aa2ae..cf1e4ce61a8c 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -19,6 +19,18 @@ struct xfs_log_iovec {
 	uint			i_type;	/* type of region */
 };
 
+struct xfs_log_vec {
+	struct list_head	lv_list;	/* CIL lv chain ptrs */
+	uint32_t		lv_order_id;	/* chain ordering info */
+	int			lv_niovecs;	/* number of iovecs in lv */
+	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
+	struct xfs_log_item	*lv_item;	/* owner */
+	char			*lv_buf;	/* formatted buffer */
+	int			lv_bytes;	/* accounted space in buffer */
+	int			lv_buf_used;	/* buffer space used so far */
+	int			lv_alloc_size;	/* size of allocated lv */
+};
+
 /*
  * get client id from packed copy.
  *
-- 
2.47.3

