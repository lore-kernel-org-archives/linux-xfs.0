Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DF4A93D
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 05:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747113979; cv=none; b=QCthWCpbmpeyqgYbmfRGqZ85C+3v0G+HnwCpjxZzl1xNFiLY5q9EXYkg4Sw+Iev2Y2ykgWkRFXIyp8APNVzIfiVHIhhMVerObzP9K885dsOg/4NI9gXO8mH2TM2Zdivk2yueLbjI96Kn8qnMVhgirlt5xBGoFqUPGrwFofBQz2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747113979; c=relaxed/simple;
	bh=ZGcyw3Y5tYny8KdkF4wwYgMzqGPXloIcD7KDh+RrGPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kg+DCOvZcYhXmwytTjWH/6RFg2ETuPq/tL9QCJT+UF711/e7FkknIErCAMcxUSqgfNldKKrdCSd3KxRJQQm9II7A1Wrg8y6D8R5c9Ss4jnHhgneeC6gH97sq4QU9NrPzOQmE6XC+VQR/PDnCzwlDqolubsu+v+q4qtM0PjK6yio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VHaQiZwJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VHaQiZwJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=++FgpmZgOkWtNrF3I426fVQ8CeaqBSgw55Z+VhrdbwE=; b=VHaQiZwJP8zDmvHbKPDFKbLD+b
	CDBfA0xY9yI7SibGcSiH6wCQwMvdYz47CYd2nvy3mjwgNNlD8PzuBxNDQMqt1plUw0q0h6S2zqV5X
	qFEbXJ7NCItn2kfAa27C7hY7O5yDUDP7k2Q59OLxqsNP7AsUHT1pIJ3F9rf9XSRXLkV/JuYm1MEjA
	ENibETd7sKIT2G8ARq2OLnjCewfvOR+NAmVyd3tpvQn0W/hShpkfI4lcaXLAD9A8SH56A6Wt1tatk
	L0wA1mEWpKNjKxQu4by9FjqBUgDXfhugNjZreC31jK5vWLGQzLkYFRWh0P6NvVhLBCTJKQ1x/CeGx
	YseoXVkQ==;
Received: from 2a02-8389-2341-5b80-3c00-8f88-6e38-56f1.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3c00:8f88:6e38:56f1] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEi9h-0000000BO9U-1SWT;
	Tue, 13 May 2025 05:26:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	cen zhang <zzzccc427@gmail.com>
Subject: [PATCH] xfs: mark the i_delayed_blks access in xfs_file_release as racy
Date: Tue, 13 May 2025 07:26:14 +0200
Message-ID: <20250513052614.753577-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We don't bother with the ILOCK as this is best-effort and thus a racy
access is ok.  Add a data_race() annotation to make that clear to
memory model verifiers.

Reported-by: cen zhang <zzzccc427@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 84f08c976ac4..a4a2109cb281 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1549,7 +1549,11 @@ xfs_file_release(
 	 */
 	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
 		xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);
-		if (ip->i_delayed_blks > 0)
+		/*
+		 * Don't bother with the ILOCK as this is best-effort and thus
+		 * a racy access is ok.
+		 */
+		if (data_race(ip->i_delayed_blks) > 0)
 			filemap_flush(inode->i_mapping);
 	}
 
-- 
2.47.2

