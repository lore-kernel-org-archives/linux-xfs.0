Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5CF3F104E
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244355; cv=none; b=OCxBNbo55TN9iKaTH4TjgngQKAforyZ0GzMX4RtH31cp+MGH9tHfMfTYfTa6YfytAifj1LIgtr6kZljzMx7u4MyI9zHOyIsc96BnQWbRWBKH0sWU1hGnssoOk9RJmFWJsO4WjNW8DTy8Y4zv8bjMYamyyWdo+mJmKqJ2NVWLSs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244355; c=relaxed/simple;
	bh=fnfM97Ze/8iehfXNRabfaZd5mFAUcEH/VVy1mVe2VZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWnXrIuYh3FJ6IRXlqFQ+sAZDeoiG7Ao6jiZGXSYb0LyWfy56d68MdpthMt87Ktsie964QivhdvFyLBBb0eL8fMtZ5i/lT9zOlR3dS6N8ZPfMm/la0igmriH/psiXCz+zquNDg3aHm07Hr+E/+Idx7bIDG7pI3MWGO3mQKT3lus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=POt0qcLp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="POt0qcLp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lU+OBV1swr6/LDXIu7UoXiUZFqGOQAdDH43hOsT/viE=; b=POt0qcLpbFMwME/UTl3R1hTgg8
	XzAI7ynk0nGnqY9ngG8qpGIWocyhVL+Sg/oyAk96TOPxtmGV/AUn4/8pDjU/ry/f7hpri83akFBpL
	tEbNi2NvRqnbi298Z7aEeCIedm3WXfs9ozwJrWsJnobPpFSkiGIHw7DZZ4h+C96Maedg78nbYLHWi
	BkuepypQjpuWnldZg5eQ3rm+RAiqiMer7T10mKTC6aHOWx7UYS/M1YXyR6qFfknuzvTZFZn9bjC/a
	w6E/hixKGPPSXWRLs5+7ta3Jj+cYmT4XFVAtPiQJ0ii4YI59demLKuqQMm7woSlbUvLL9QfKxGyYX
	txQj4cMQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKl-0000000AfFT-3kW3;
	Thu, 24 Sep 2026 10:05:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/32] FIXUP
Date: Thu, 24 Sep 2026 12:03:59 +0200
Message-ID: <20260924100512.2733748-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

---
 libxfs/libxfs_io.h    | 6 ++++++
 libxfs/rdwr.c         | 2 --
 libxfs/xfs_platform.h | 1 -
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 5562e2928254..bd0d9ec04bea 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -293,4 +293,10 @@ xfs_buftarg_verify_daddr(
 	return daddr < xfs_buftarg_nr_sectors(btp);
 }
 
+static inline void
+xfs_buf_set_uptodate(
+	struct xfs_buf 		*bp)
+{
+}
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 90f2d56687ca..9b6cbd4aa158 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1426,8 +1426,6 @@ __xfs_buf_mark_corrupt(
 	struct xfs_buf		*bp,
 	xfs_failaddr_t		fa)
 {
-	ASSERT(bp->b_flags & XBF_DONE);
-
 	xfs_buf_corruption_error(bp, fa);
 	xfs_buf_stale(bp);
 }
diff --git a/libxfs/xfs_platform.h b/libxfs/xfs_platform.h
index 0aeb80fb8244..d9cfcec4c1a0 100644
--- a/libxfs/xfs_platform.h
+++ b/libxfs/xfs_platform.h
@@ -322,7 +322,6 @@ static inline unsigned long long mask64_if_power2(unsigned long b)
 
 /* buffer management */
 #define XBF_TRYLOCK			0
-#define XBF_DONE			0
 #define xfs_buf_stale(bp)		((bp)->b_flags |= LIBXFS_B_STALE)
 #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
 
-- 
2.53.0

