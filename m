Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1133C1D5141
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 15:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971914; cv=none; b=OggVe8bHo8ZghsMZLaYKz4Om7HvCqTGYOQGFdkKywODkcZJ6ubv9u2qXMrLUrfqxS/joyC5J4Lbpc8qkCC/O/1brqwdHkn0yAceoBnrnqldA4k6rHoEF7RJjK5MrtJHi1iD6+Nv1mZ3eWZSiB29kKH6rkX1ZyCZJcWd8GQ8ttZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971914; c=relaxed/simple;
	bh=v6WIwtuLZFPJCJC3LTvpyqyMBQczQNSb4jW8mnhOi5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EvJ5/eFQRmAnQ7afdc3jGmxLSzWWt1Ph8MuGOzVWjF3c+5IoqcWomMdF5pTmnMmxWOe+WgGhDVOL0BB0mXtrm9Mgh8q3lzSlKQwt74Xda0p/B1ZEOfbDdENsuIQh1m8eSPhUvw8Ye/mMniBbLnq/JUiCQLze9BbQ6C9pOn+6V7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ew+43hwi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ew+43hwi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=jBJ4u2c+pVtvjphCg4xkEoOpNkfHiAV1FEkLzh5qQP0=; b=Ew+43hwiSeDlnK6f9roOFb3EE3
	N4wkEQUgRriTV20uo9u4+0r6xAfIe6ESzEeGt6HQpnlTxirFEx5RrkbPoJ0DoPPN0pfY2wW7ARjKK
	FSiH/xlISd/Iird1GtzyUS3xbSxiRu34/rvpH9h5dg+jfdulAcobtfdWCoeZsN0Fe01Bn2ZOmAp2b
	gtHwMuwczyWgN6jSJ0xWG0ZycaSv1gtahzVx/1XGGBqGtniHqGeH8/MxHAyNP0i7g/bgRMa7x7fEZ
	qIrquH1prWRf96kWB4/JUi7i1Fb7ZRS24iPKkenGAPCuofLFRsM8wi26qVSADPHREiMIdoTs/ilDy
	4vE33rLw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veEFz-00000002StB-0N7p;
	Fri, 09 Jan 2026 15:18:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: improve the assert at the top of xfs_log_cover
Date: Fri,  9 Jan 2026 16:18:21 +0100
Message-ID: <20260109151827.2376883-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move each condition into a separate assert so that we can see which
on triggered.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 511756429336..8ddd25970471 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1138,9 +1138,11 @@ xfs_log_cover(
 	int			error = 0;
 	bool			need_covered;
 
-	ASSERT((xlog_cil_empty(mp->m_log) && xlog_iclogs_empty(mp->m_log) &&
-	        !xfs_ail_min_lsn(mp->m_log->l_ailp)) ||
-		xlog_is_shutdown(mp->m_log));
+	if (!xlog_is_shutdown(mp->m_log)) {
+		ASSERT(xlog_cil_empty(mp->m_log));
+		ASSERT(xlog_iclogs_empty(mp->m_log));
+		ASSERT(!xfs_ail_min_lsn(mp->m_log->l_ailp));
+	}
 
 	if (!xfs_log_writable(mp))
 		return 0;
-- 
2.47.3

