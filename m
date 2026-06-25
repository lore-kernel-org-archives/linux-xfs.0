Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E33E348477
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 13:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395945; cv=none; b=drT+OgF4Q6EJhtPmDCMPkG8bECk4eADU6rAlNqy5JzPakcP/j2D7Xz73D8cSO0syo2HGUPYz+LlNJL3fXrO9WNh0kri98581YZL5CBBEP4GkByuBcKrGpxziD5UeGP+xk5wgDzHsy7t+jPTuzQwIJysaFzKntpKOlImYiE0Fjpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395945; c=relaxed/simple;
	bh=s4S/0uUIQgDzmeaxzhEpiu20mYK4Ji5WKkgJ/PXgYAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ix+dVtaOrdorozBlerFcSVYeWI0Z9Bc8iDw+DdrpwRHxcdxSy0iCLN3HgZlX0UX7ifr4ZOWtnRKwEeMd7WZF2cyvc8JI3lbrt06lC4aAJF0vBUZ5k/ANJcNmebMIbhP7UA0VgCnTSpk0p+1WSEqpBrt9NF6P5LpUb1I+/+Rfvi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SI97LSbM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SI97LSbM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DpbqLuro7lTgigKyd0clJC2GM6O8YcIfCnfKKzGLq24=; b=SI97LSbM0rZq3MfPOPVC/p3i+E
	leBOy6jGluZkrs9J3xmfO6MEFk33Jhh8oQ/g8a7Do8hiMehRiNuVgC4snf9+nQjKG0u3mmQlRFm4b
	NJXybzDA+RB1TypNYWVulsu3ARHFT8gYMzmtSXaKwN70eLRvX70z4kvMFL43HWWQzeVw5gtuqYNH2
	+4qpY1SAD1h0pgX38P/Rk+7Iw0Hj7DTfRmIdRodD4qjnxa2PMjjsdhh2XvAxoAkFetkk2zxYAwEwo
	vybmAbM+Me8lsJ+ukC+KS1wZOL0PEvpbRcCSZ/fx1HmM65orGAaGu7UYlQrXP5KvRWRsDC/P/hN1S
	JAIRsC/Q==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wckbf-00000009Gs9-2T0Z;
	Thu, 25 Jun 2026 13:59:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 4/6] xfs: remove xfs_buf_ioend
Date: Thu, 25 Jun 2026 15:58:34 +0200
Message-ID: <20260625135849.2494779-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260625135849.2494779-1-hch@lst.de>
References: <20260625135849.2494779-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There are two callers of xfs_buf_ioend, one of which always has the
XBF_ASYNC flag set.  Open code the logic in both callers to prepare for a
bug fix.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 83c74b5b7e8e..3eea9d9ea829 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1146,18 +1146,6 @@ __xfs_buf_ioend(
 	return true;
 }
 
-static void
-xfs_buf_ioend(
-	struct xfs_buf	*bp)
-{
-	if (!__xfs_buf_ioend(bp))
-		return;
-	if (bp->b_flags & XBF_ASYNC)
-		xfs_buf_relse(bp);
-	else
-		complete(&bp->b_iowait);
-}
-
 static void
 xfs_buf_ioend_work(
 	struct work_struct	*work)
@@ -1207,7 +1195,8 @@ xfs_buf_fail(
 	bp->b_flags &= ~XBF_DONE;
 	xfs_buf_stale(bp);
 	xfs_buf_ioerror(bp, -EIO);
-	xfs_buf_ioend(bp);
+	if (__xfs_buf_ioend(bp))
+		xfs_buf_relse(bp);
 }
 
 int
@@ -1414,7 +1403,12 @@ xfs_buf_submit(
 	bp->b_flags &= ~XBF_DONE;
 	xfs_buf_stale(bp);
 end_io:
-	xfs_buf_ioend(bp);
+	if (!__xfs_buf_ioend(bp))
+		return;
+	if (bp->b_flags & XBF_ASYNC)
+		xfs_buf_relse(bp);
+	else
+		complete(&bp->b_iowait);
 }
 
 /*
-- 
2.53.0

