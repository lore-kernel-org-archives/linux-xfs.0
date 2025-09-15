Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BE230BF77
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757943067; cv=none; b=kyFRBgtMoG+gXB/658Z3Cx57Ndv8ehsbqIbhWsvBQMMLWk6akgLlvcn12az1CshHaRLN/2QP6yC+9b39R8iBaQL0NqW0aRu4+Kwmxnd3QBZWjCnSyYrNLqUztRNlqrbj2SXkNMueUSEpcQrfuk/tGSxxl0oNOT5tn7p4PeRsQsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757943067; c=relaxed/simple;
	bh=PHkJ4XjiHfMad9hbPTsuxDn3DrWfQwIroUePruSeU1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEpZIyrjjf9hDetdsUPXu6lsDw7hgp9mzm8FS3L1haMbbAt0/bA2vwtVme/X0WBazcbu5UjIiBGfAm2ljTC/F1HHOjgFhcN6WXdMBeONFOYJ/0QlwDsM0mvO9AFZrrY7k8N/WA9eWhmwnM3Mvn/5//MuyGYr5AVyFXTTuApbeqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Hrp/PNkh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hrp/PNkh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2AAV4+AyK4s11YVGj9IcXcL+d0b67LPBn1iEngnMbZo=; b=Hrp/PNkhnAh/Rxl4JaS5YLTT6W
	61oucys3AZA9j0ESwlqaA+TeczXMkXxvB8Ns5rw/X7SdAr+hsarL8hmTuQnI28tq+VO/K3kCYDF96
	HIIv74MpldbwPxXp2rNXPVSdmWnkfEuQLYv5Cw/P61jPFrNkN2gwJehYiHTmOPbLj26+T+CnQ7fPn
	OZgIIsimHuraU2NIp5OX9t5qknRc0tniMp4fJiAOpabXi94uznvC42gIsABB8YVD3TmsZ6MhYDqDq
	VIiAHifiCXYvWNZHeybTCwzu7bjVVYVHw4U/Fp3Fo+DaR1N0uH2J40S28KfGtZSvfQdvCYHCpTVdL
	mcn5E/mQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9IP-00000004KUe-3WAv;
	Mon, 15 Sep 2025 13:31:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: remove pointless externs in xfs_error.h
Date: Mon, 15 Sep 2025 06:30:40 -0700
Message-ID: <20250915133104.161037-5-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

