Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B9327B341
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761835805; cv=none; b=rId01dZRn2RtV/V+2D0s2WFH16pSLJZ/qHO4LfzDZSJ4+CgVZh+oM4JX7xwurXa822BTmYSUAqbdH4RYeSu/TTrD/niqm41fSoTe8XaKjNm+2xiVjW62xnSRSjciOgasH2WM2AnQSiDi9qcRD4sTkFOQWjc6ViycLDdOfIrkq6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761835805; c=relaxed/simple;
	bh=5GoXNFIWbAw3/2cMgh8Ub0pmCIS1OqoWJqzoS0UVBfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRv+E6tdK9XKPg62dEY2fR4ZzYWBBW9h4ZMZl2ciAG0qWPH4qmOsWcliq1MX8/wp1tJdoLWNQfEw5JhRpHNrAkfIYrjmHO2NIgofHKrfVp+gXz3WvYkF2fCIb21KJVEJWzgFOEOCA2m2OpyObGr2Tc1uHYoiRGn/3xE+zKjsUJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VCzeH4b4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VCzeH4b4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TcqD0aXQV5Tt4eqXK4GyfZMA7pIklqnUmSTh7vfZo9U=; b=VCzeH4b4ZSkOPIvdevR6A9Gq8d
	v/bc30yOEPB8R9KTyQQOyvZgc59F8VFjG4bGIH6qDW+HIoW8QTBUphRBhq7X/Sgn64OQCnJjIMV4v
	JpyRYb6V+/sOe+Zf6PahulghtTCs2aa1YrASnwnSLq8l3NPTSWHVT3iuULiBLasj8MsaGN5zfSTlW
	TKCGTq9pzwgPyAKqv6oI3Y4NmjCRG9f8Fk6fiOi1/ChzkpGkes+eDwEOGOj0Jh+4DhjW0LoCtnX64
	3EqX/22QoD2J8/1nVw+OLv8XPuWuuVPFo+lJPp61UeHcTu7WHMZ1y5hvKoLfVUG3JiPkjtLwYYV8y
	WDYBExzw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vETyU-00000004KO9-22kl;
	Thu, 30 Oct 2025 14:50:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 05/10] xfs: move struct xfs_log_vec to xfs_log_priv.h
Date: Thu, 30 Oct 2025 15:49:15 +0100
Message-ID: <20251030144946.1372887-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030144946.1372887-1-hch@lst.de>
References: <20251030144946.1372887-1-hch@lst.de>
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

