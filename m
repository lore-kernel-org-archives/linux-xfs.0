Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074D62DEA84
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582717; cv=none; b=pAA8dq/lM+sAaoR5N4sIhNYVGcK+QH6RQIS+/M994/UNsKf7Z23bAcdzm4P5S6X4uBnN9742Cppf3/a3jRU1XoJC8eTXpIEevWSd7FV2bmTc6ijwB8qnRGeOrPRT1zP/IfiQZ3l6x1C/EAy2zQ/MsK0BV9LDe98XVALjDpItL0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582717; c=relaxed/simple;
	bh=oZAVCkBBvtEA3Ml9YQDTp+HabfoLmRbMtwxoDDYn/hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjFBOy5KmQLzDEHYfMZmVLiZ2K3SiyaF875xCesD2K3/VqwR1eYFXyCq+NAQ2oM25u+f+07EpjnlOqEl5cogsi2bfh+NbNZTLlnmYp0gWMGHEKJuSkMcquF1ixxapIzqj3wvDmWhyZNExiCN3Jlt0NzhttLk4doE7DkMECuNVqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UEZUODi3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UEZUODi3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/mll0lFfH2M83MkOBUjAZMIyl6xyZMEyPTDofSe9Wn0=; b=UEZUODi3Mmd0f1LHPmvu/SyXwB
	apn18stB7dFz7+pyoR/aLvViWcdGbD11YH1wJOh4ZCXjy+RWPCOOS2TgOyg8w1TSyG3mCciS63B8A
	MJVNAHmZRgi1mWrAPxrRu55MPT2zxtReifP1MCd9nLkyG2q1JeMMj8hVBAn44FYIokB91A9jpIdfh
	RWQbPG0qAGOmYoA8hapjrDB4NxRvNU8B0WQGPxdHxGMSx6OkfKIgMZf7b3YZ8kQ5jV87Nig0mpMWa
	22m24nt94tpJeyzzKJsKOxmqnqGfS+E/U0RtKmJoAJDgVGSuGVtiYnOuB5giCxfrJ6YTJwwqKnYhY
	Hhdt2nPg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubep9-000000054rR-0p9G;
	Tue, 15 Jul 2025 12:31:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 10/18] xfs: move struct xfs_log_vec to xfs_log_priv.h
Date: Tue, 15 Jul 2025 14:30:15 +0200
Message-ID: <20250715123125.1945534-11-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715123125.1945534-1-hch@lst.de>
References: <20250715123125.1945534-1-hch@lst.de>
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
index 110f02690f85..780155839df4 100644
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
 #define XFS_LOG_VEC_ORDERED	(-1)
 
 /*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index fd6968ce7bd0..7c298fba26e7 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -19,6 +19,18 @@ struct xfs_log_iovec {
 	uint		i_type;		/* type of region */
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
2.47.2

