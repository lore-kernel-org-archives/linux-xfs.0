Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55C732856B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758040138; cv=none; b=BQ9mm636sLIHp2LGF9PJ6pbhsut2HNgUvS9PPmeAi9vZFmcCFBqAKQp8ZXr9kGtZd3jMimmVN6yQFMijNNkwxHZscla1iLDCdSU6gB8red+++tnW4vk4r+BPMx7Yw4YbiuNDXIKMi5eV13Gn9EfuqABiPkt4S6uuCzXwx2Ofw3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758040138; c=relaxed/simple;
	bh=I45AN+uXtf980jO/5+dAsyXhRda5GTGx/Jsbh8Ozk40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOzx0OnnA/+TpBmgGYs9ja/bOa5ra4yBEBV71VyeBLwASvJYxvXlLB0mHHzBMCgqSStnPswnyc+Mi4WTqEqd0wRbWdPjmG0PVsozh7U5ZkXZsb/gkNtLqiTUrlUvJ8bjndzJtcVrAVQtVzjr/nqaGinIVgV6bPTT7P+RyoP165Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v32TI0DR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v32TI0DR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UVjuEqqgq4Q/ELOWRWguGZ/l/2/bw1DYdkvVHduzn94=; b=v32TI0DRkPdmQYrGqp+GjW/db0
	QBnff9RrzCELMNCwgNfOxuQOajVQmxvsF+adlAF/MLOiOAKps6vUCLd1u7y2DK4Oj7anDDgvsfWRe
	teyR4V3mY2XsqrJgy8hZ/Lfl03FT0RpegRtuWf9NWbFYrAeu/qU7oE0yhfIpMYouRw/N7BzVHMhs/
	mOn2/el03CF6i5W07uEC4JqdBAk8I35t5B2k1v0cEMgL+7xiQE7jKv0AN0EJ+wnwYcZ6LOACLbZYC
	r2sBi/vu76P0iqsBLVQCrIzqNnIgrnKzkzi9aasmaJGMrOTXZuCeihaPWpYSV7rCjufX55kKoh0qt
	PCNdhncQ==;
Received: from [206.0.71.8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyYY4-00000008T3C-0Zsi;
	Tue, 16 Sep 2025 16:28:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 4/6] xfs: remove pointless externs in xfs_error.h
Date: Tue, 16 Sep 2025 09:28:17 -0700
Message-ID: <20250916162843.258959-5-hch@lst.de>
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

