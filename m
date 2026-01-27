Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B0235D611
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769530002; cv=none; b=qNYqlJsKpuwWUge1ozJ4gpBLmYJOhMIjtsP2OOhojbhRR9T3QGhX4bU5BnxmVhnm7EmdDY8Z31XgzIKtZdCqG9WehP1GNDPtomqa86QTSgRtpGXvFYQjeWQnE4aGeagSFoF5XwtHwWRrSRl1jLsUgj7kUEC/vRZDq1RnpDzRv6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769530002; c=relaxed/simple;
	bh=HyJd8Hbre73RCj+NcdYRYNQKQRJGwkCLMTYrZYCN8Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3/oD2DWUnrXZIUGYQyX1vLSNuuFFXUN2aMkzORBgZcbS+Skn8hvCBTWiRWbbsTQaFo+k1Brddz6Qo7+xtGqocTvaTx2nASi+bO4SOfb8SL6OVaLWZiMEEQF/xdMCdG3W0sWkTi2IqKkwvNx+SoNv5eQ/4XXuctbXcMMMtyIk7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QgYgpcgS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QgYgpcgS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hC+6LBwa5B1ZxdqakTm+XaPa6lcNa2ncWeHQjHafSmo=; b=QgYgpcgSqRpGBtRXcxs6rqVMF7
	03WJd7JexVgDh/jTxPj/n06lepbEoixrNhz+OqjUhh4aYDDJkMrYTEwi7RosOeHBn7LjmRMmEAqQy
	x4C1YjXTfMVVw9CT2JG60gl19GodNgJj4W980F4bmllbNZ5t7bILXsH62z4CjuiuNaWFxyqnFc92K
	8ihefH43EFdN3LL3j3GuawMrgT4boaC7CGanbL0RxzQ7pQbAw/S3f9yijf2PAgB9HUerSHX7cbAio
	S1p2jYuhomwXntosWBJAfWI5vpyxXrSt/wdUmZka1QSJZVSJV2nmue9NTTCKNCwV8zU0UzwX7KDUg
	vYR5QVsA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vklaS-0000000EblF-0GoJ;
	Tue, 27 Jan 2026 16:06:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of line
Date: Tue, 27 Jan 2026 17:05:44 +0100
Message-ID: <20260127160619.330250-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260127160619.330250-1-hch@lst.de>
References: <20260127160619.330250-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Mirror what is done for the more common XFS_ERRORTAG_TEST version,
and also only look at the error tag value once now that we can
easily have a local variable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_error.c | 21 +++++++++++++++++++++
 fs/xfs/xfs_error.h | 15 +++------------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 52a1d51126e3..a6f160a4d0e9 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -144,6 +144,27 @@ xfs_errortag_test(
 	return true;
 }
 
+void
+xfs_errortag_delay(
+	struct xfs_mount	*mp,
+	const char		*file,
+	int			line,
+	unsigned int		error_tag)
+{
+	unsigned int		delay = mp->m_errortag[error_tag];
+
+	might_sleep();
+
+	if (!delay)
+		return;
+
+	xfs_warn_ratelimited(mp,
+"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"",
+		delay, file, line,
+		mp->m_super->s_id);
+	mdelay(delay);
+}
+
 int
 xfs_errortag_add(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index ec22546a8ca8..b40e7c671d2a 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -40,19 +40,10 @@ bool xfs_errortag_test(struct xfs_mount *mp, const char *file, int line,
 		unsigned int error_tag);
 #define XFS_TEST_ERROR(mp, tag)		\
 	xfs_errortag_test((mp), __FILE__, __LINE__, (tag))
-bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
+void xfs_errortag_delay(struct xfs_mount *mp, const char *file, int line,
+		unsigned int error_tag);
 #define XFS_ERRORTAG_DELAY(mp, tag)		\
-	do { \
-		might_sleep(); \
-		if (!mp->m_errortag[tag]) \
-			break; \
-		xfs_warn_ratelimited((mp), \
-"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"", \
-				(mp)->m_errortag[(tag)], __FILE__, __LINE__, \
-				(mp)->m_super->s_id); \
-		mdelay((mp)->m_errortag[(tag)]); \
-	} while (0)
-
+	xfs_errortag_delay((mp), __FILE__, __LINE__, (tag))
 int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
 int xfs_errortag_clearall(struct xfs_mount *mp);
 #else
-- 
2.47.3

