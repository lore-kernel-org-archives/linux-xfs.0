Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D92945C71B
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244480; cv=none; b=VsYf8k1R9hEqeRl9aBQTkfqCKQ39tGW1QO96aOvy5Phhn21FGvZOZ4Kk8QQnbS2z3P0b1yp4WH34yPrP8q1CJ6qdAO9BS6dsCh1S1Z8FrLUFznwKqmgYx663vukdXZ5urg6q8RcM7NfOX2fJK31JovlMgZdT8iOw73WqmRlLX7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244480; c=relaxed/simple;
	bh=07CEW199NXQH0lM4nzJAhRePmleqgMs8SIxx8ZvBFz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBkzymxxrI82CpNXUHcXIg2r9SNS9/w58Xyu35a3l7eb7uMCFjVvmNZE65FiX0i+dFI5bzm3ZxUZVKZl2Q6aZsVVAQ+jk4D7uUVcowby9QxNmZ1ZrDIcfiygURAb4qLKJKnN0/HeUj0eynwGGatY/z5EWk01WkjL/HZpfGfEc+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rZMZSZBS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rZMZSZBS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+sPB2vEBxZRrnkf6F5RRwF6HflNhB6V2iB9ZKy1VaEA=; b=rZMZSZBSLaacoNdsjOendpZPTN
	cu+tdJ31ratlW9uCsWOPO4JGdlD5sPDMal3f5VDhpoMlxkd31c0Qvo84DHmuv8nZVGjvaRKZi3PYP
	FjiLq06WOgdUdEoczDaEjBizPQXxps2qLoXBUn1CwQc7T1OBn6+6HHpfTGd818YWY1vR4haa6E+ik
	ppsC44M1sUxc4hnT1Iqvd08Y3bHyKe2YIk6INnjt2rnDP20DvYfP7tcnX1BaVj4fdLIIsQXUUAv5H
	Hrt5H85CNXeC+Nd74Qjx+vSlJ8YpI9XHTyjtWKssltXcHBYs3xXE1Zo/3z1d3EFK0y1mT2FaPD5lH
	jCQqQigw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gMg-0000000AfbL-0kPE;
	Thu, 24 Sep 2026 10:07:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 32/32] xfs_scrub: don't merge over unused space when data checksums are enabled
Date: Thu, 24 Sep 2026 12:04:22 +0200
Message-ID: <20260924100512.2733748-33-hch@lst.de>
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

Unused space could be lost space at mount time for which no metadata was
recorded, and we thus might not have valid checksums for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 scrub/read_verify.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 311ea1c29008..0c3bec104d16 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -542,20 +542,33 @@ try_read_verify_schedule_io(
 
 	/*
 	 * If we have a stashed IO, we haven't changed pools, the error
-	 * reporting is the same, and the two extents are close,
-	 * we can combine them.
+	 * reporting is the same, and the two extents are close, we can combine
+	 * them.
+	 *
+	 * If the file system has data checksums enabled, only merge fully
+	 * contigous ranges, as unused data might have invalid checksums.
 	 */
-	if (rs->rvp == rvp && rs->io_length > 0 &&
-	    ((start >= rs->io_start && start <= rv_end + locality) ||
-	     (rs->io_start >= start &&
-	      rs->io_start <= req_end + locality))) {
-		rs->io_start = min(rs->io_start, start);
-		rs->io_length = max(req_end, rv_end) - rs->io_start;
-
-		return true;
+	if (rs->rvp != rvp || !rs->io_length)
+		return false;
+
+	if (rvp->ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_DATA_CSUM) {
+		if (start == rv_end)
+			goto merge;
+		if (rs->io_start == req_end)
+			goto merge;
+	} else {
+		if (start >= rs->io_start && start <= rv_end + locality)
+			goto merge;
+		if (rs->io_start >= start && rs->io_start <= req_end + locality)
+			goto merge;
 	}
 
 	return false;
+
+merge:
+	rs->io_start = min(rs->io_start, start);
+	rs->io_length = max(req_end, rv_end) - rs->io_start;
+	return true;
 }
 
 /* Did read verification succeed? */
-- 
2.53.0

