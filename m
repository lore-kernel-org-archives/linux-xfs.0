Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF70271449
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582356; cv=none; b=VnG+/Jbs3keEQF//VgGNtOnuZBIEpDt09e1MFl66EVpsM3pbt8fap2iuQqXBtS90xq1qbxN1LkI4e9PTOX6SwwjgJ7NBXLKLhItJJueHLAwS8TIOLnyCS30KQmtHCvK4zDDklR3bHRd2P2gdpS3MLhuiPFmjwdjc2RW/TPbIEnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582356; c=relaxed/simple;
	bh=koEDr1rSFblTro+MvdUjb6Ejm0wVcnzmxMS3dFQIZuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6+2OVYJcOOyrPx9XdZvvvpjSox6r4xJUelgy+tSq11w/7Ayb25gicV8OkWXJNN/7rIj7XbtFLOMPtMHXwGowYOAsijxWqmRJlHmY4YsP2vDHzO9VmyzYnz4V5s8lmpCPUSIZD2J6qw0cRGRQCrENAZvQzt3SbZM2L4OVVzVpBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GmlVAHFv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GmlVAHFv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=npRwz3ltTTSf3STpCm7P1pbnQnpQuJXSCau0K6aYhis=; b=GmlVAHFvPTsRTSbzmZ28kQa0sc
	/42r8z13mvuqsU+G57Wl9c9+gN1WcCy5Y4x15rV4o2t/VTQwyhxyV5noEAutrFJrTYjNaSonKo+w4
	oBMwzTj+wSbpLusHzq64j8POH1w/46nrZgAeyCsyp02afNB/gotg30+vB3pWFyBHUTCwwUJqWkrOQ
	wL6NhlLME5NiktE4vnmqjgDSO7Zn6O3cJUdn1PUf9rYatXkLzoawn4her5GENS6WvJ9fc3sJP5DcA
	MQ7x6N86dy8TFlJ6kbq0kMWgV61Vjmp3bS6U86YfV3ADhPdgHTqqkAn6Nz4L0oi03C9k4026z5Yxk
	xDaufrTQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubejJ-000000053yH-3oDv;
	Tue, 15 Jul 2025 12:25:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: don't use xfs_trans_reserve in xfs_trans_reserve_more
Date: Tue, 15 Jul 2025 14:25:35 +0200
Message-ID: <20250715122544.1943403-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715122544.1943403-1-hch@lst.de>
References: <20250715122544.1943403-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_trans_reserve_more just tries to allocate additional blocks and/or
rtextents and is otherwise unrelated to the transaction reservation
logic.  Open code the block and rtextent reservation in
xfs_trans_reserve_more to prepare for simplifying xfs_trans_reserve.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8b15bfe68774..1fddea8d761a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1146,9 +1146,18 @@ xfs_trans_reserve_more(
 	unsigned int		blocks,
 	unsigned int		rtextents)
 {
-	struct xfs_trans_res	resv = { };
-
-	return xfs_trans_reserve(tp, &resv, blocks, rtextents);
+	bool			rsvd = tp->t_flags & XFS_TRANS_RESERVE;
+
+	if (blocks && xfs_dec_fdblocks(tp->t_mountp, blocks, rsvd))
+		return -ENOSPC;
+	if (rtextents && xfs_dec_frextents(tp->t_mountp, rtextents) < 0) {
+		if (blocks)
+			xfs_add_fdblocks(tp->t_mountp, blocks);
+		return -ENOSPC;
+	}
+	tp->t_blk_res += blocks;
+	tp->t_rtx_res += rtextents;
+	return 0;
 }
 
 /*
-- 
2.47.2

