Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592374FD270
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 11:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892685; cv=none; b=EeBDHWra3uDQN8KTBer9TZZ9Sv/8qUkqudcDacLUbRv1WEPfVOrLad/R5lh2IJGXhyamf+QV94mKfq8ZjgmHpWEYTRq1MwAsCZBh78t3GNkZOKbeghQw4+kX/W18tIm+7sV+6HBmMgMZIOrJwvJyY298tzMEZnKfcRASY2rpMK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892685; c=relaxed/simple;
	bh=ZgM4HG8d+gMK6e7WPrVp2EPJ9zcYlpF+ptSyXEYbihs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZBRIhMJoW4LJhfemuX32q3qYV+Bd6P2jvywUi5QnHbNXYRHkmFi8kGeoNnJWLb7EbrEXrYIgCZe8VNCI2Wzf/5c7HD+F/pxOZtGAc4EzUKl4H/EPhiygxU5MNJBI3UOVHtxAAPxQZpRvlaEcZ85jIjWkxM+lh7rB4opD/F4i0po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vVS7yYZ8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vVS7yYZ8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=2r+bFY7NgiOMiSbCu2rff7xYpebWTsthIqNr/tLSlso=; b=vVS7yYZ8IrkK/PkflhrRHFUuXw
	Yv3wcOuTG9PbeoXeb4fh/hECWkzchgaWXZwney0+c0fXcMzRQABBzJmcp17NT8WVlTz6aGr9wAmNK
	035Ly1xCtWpqJuJZ/sApOCS3Ix8HCXk4/lldAAu+wnCaC1B8yAY59EHztgASYpiFis9CS796EL3lf
	wwgTxV67yuqiE/YwIdPpiKxjdryCvQX+PAdn1tOEnp/CJiCSVYGD2qhKwnzPAZpKNJU1CNohLGkKb
	tHNrlaiB7bIWqKM6ojgqvhlm/SzSvUevNGw1nzlxnC1FYSYYsfc0gxM4e+0EHC4l2O/3BRPX94BYj
	Jq57CCtg==;
Received: from 2a02-8389-2301-9f00-e8f6-a58b-9f49-a02b.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:e8f6:a58b:9f49:a02b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGb8o-0000000CliO-49D2;
	Tue, 13 Oct 2026 11:58:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: hans.holmberg@wdc.com,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: handle NULL open_zone for merged ioends in xfs_end_ioend_write_zoned
Date: Tue, 13 Oct 2026 13:57:55 +0200
Message-ID: <20261013115755.1473496-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The NULL checks on the merged ioends added in commit ae285611891f ("xfs:
handle NULL open_zone for merged ioends in xfs_ioend_put_open_zones") got
lost when the code was moved to a new file.  Reinstate the check, and
also update the comments to be a little more coherent.

Fixes: 6b855256eb9e ("xfs: split ioend handling into a separate source file")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioend.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index f0e01ac34de8..26b996a52d8b 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -182,15 +182,15 @@ xfs_end_ioend_write_zoned(
 		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
 done:
 	/*
-	 * Put the open zone for all ioends merged into this one (if any).
-	 */
-	list_for_each_entry(tmp, &ioend->io_list, io_list)
-		xfs_open_zone_put(tmp->io_private);
-
-	/*
-	 * The main ioend might not have an open zone if the submission failed
-	 * before xfs_zone_alloc_and_submit got called.
+	 * Put the open zone references for all ioends merged into this one in
+	 * addition to the main one they were merged into.  If the submission
+	 * failed before xfs_zone_alloc_and_submit got called, there is open
+	 * zone and at least in theory that could also happen for merged ioends.
 	 */
+	list_for_each_entry(tmp, &ioend->io_list, io_list) {
+		if (tmp->io_private)
+			xfs_open_zone_put(tmp->io_private);
+	}
 	if (oz)
 		xfs_open_zone_put(oz);
 	iomap_finish_ioends(ioend, error);
-- 
2.53.0

