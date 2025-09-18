Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FFD236435
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 14:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758206099; cv=none; b=CdM3eGWzYjuB47ISQr7fKzUYIUi3Lq3DICvwC5REZuT3T7x6xmbgA29nCo33Y3TonNT3czP+VYulW8qhuBjnOE2MOA0iFFt6QPBTYQaKp2rlVmQCRpLSGZD/69XyLmahfVw5IumtHfJc6V4wESzlVpxz1Du7xwCsLScka/yWSXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758206099; c=relaxed/simple;
	bh=I45AN+uXtf980jO/5+dAsyXhRda5GTGx/Jsbh8Ozk40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pr69bd3d3WsUYzByPiVwWKfwUHl6Dih8ReV9wCn1vZLGx2iq7L6ne3JoTVF1rWMPnxFljxII4GF40MuC+QJk9ETOsMUsiWXpakmXuXdVZaN5TWaYUwdsXMQoa3zeFqOMdMiGD6eqoQrPCHIQ6VHjirOlzthyNQAu9Jc6VzWie1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CnhzBBZ6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CnhzBBZ6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UVjuEqqgq4Q/ELOWRWguGZ/l/2/bw1DYdkvVHduzn94=; b=CnhzBBZ6L6ZeloRjwoo30II2S9
	ICWA6weOF9WLvj95prugUSg4M/1ShqzCpf8hRNhs/HPmilRaC5hLJ39YvOHPnPUqQz9S1Qf0UpwfQ
	MjbgJT+G7mrm7VMBa/AhhJT9CwxrXVJqx6XSpnrwdbC7z56zx9Fo6glXhXc5RtuippkLnS4Y/Hf5n
	3Bks62Vp3Z5eGhR+axnARAThVUpyuoaeLA3pRLcjeuYTjWdKscy5OP31hZQZBf4g0gJdvAIwR33uT
	MI7UFjaO5knrCEQT/7YFUOcLm+r/NYFxe6p8JM/fO8CLEZb/BiYBba6PYSaTR19ykakhMvMpYsdAB
	z6GjgLgg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzFir-00000000AEE-0wI0;
	Thu, 18 Sep 2025 14:34:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 4/5] xfs: remove pointless externs in xfs_error.h
Date: Thu, 18 Sep 2025 07:34:36 -0700
Message-ID: <20250918143454.447290-5-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_error.h | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 8429c1ee86e7..fe6a71bbe9cd 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -8,22 +8,17 @@
 
 struct xfs_mount;
 
-extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
-			const char *filename, int linenum,
-			xfs_failaddr_t failaddr);
-extern void xfs_corruption_error(const char *tag, int level,
-			struct xfs_mount *mp, const void *buf, size_t bufsize,
-			const char *filename, int linenum,
-			xfs_failaddr_t failaddr);
+void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
+		const char *filename, int linenum, xfs_failaddr_t failaddr);
+void xfs_corruption_error(const char *tag, int level, struct xfs_mount *mp,
+		const void *buf, size_t bufsize, const char *filename,
+		int linenum, xfs_failaddr_t failaddr);
 void xfs_buf_corruption_error(struct xfs_buf *bp, xfs_failaddr_t fa);
-extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
-			const char *name, const void *buf, size_t bufsz,
-			xfs_failaddr_t failaddr);
-extern void xfs_verifier_error(struct xfs_buf *bp, int error,
-			xfs_failaddr_t failaddr);
-extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
-			const char *name, const void *buf, size_t bufsz,
-			xfs_failaddr_t failaddr);
+void xfs_buf_verifier_error(struct xfs_buf *bp, int error, const char *name,
+		const void *buf, size_t bufsz, xfs_failaddr_t failaddr);
+void xfs_verifier_error(struct xfs_buf *bp, int error, xfs_failaddr_t failaddr);
+void xfs_inode_verifier_error(struct xfs_inode *ip, int error, const char *name,
+		const void *buf, size_t bufsz, xfs_failaddr_t failaddr);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
 	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
@@ -39,8 +34,8 @@ extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
 #define XFS_CORRUPTION_DUMP_LEN		(128)
 
 #ifdef DEBUG
-extern int xfs_errortag_init(struct xfs_mount *mp);
-extern void xfs_errortag_del(struct xfs_mount *mp);
+int xfs_errortag_init(struct xfs_mount *mp);
+void xfs_errortag_del(struct xfs_mount *mp);
 bool xfs_errortag_test(struct xfs_mount *mp, const char *file, int line,
 		unsigned int error_tag);
 #define XFS_TEST_ERROR(mp, tag)		\
@@ -58,8 +53,8 @@ bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
 		mdelay((mp)->m_errortag[(tag)]); \
 	} while (0)
 
-extern int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
-extern int xfs_errortag_clearall(struct xfs_mount *mp);
+int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
+int xfs_errortag_clearall(struct xfs_mount *mp);
 #else
 #define xfs_errortag_init(mp)			(0)
 #define xfs_errortag_del(mp)
-- 
2.47.2

