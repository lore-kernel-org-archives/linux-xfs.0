Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67C41118D
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 06:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714371349; cv=none; b=VmdbRnK6poroG1E8SuOc+2gQ/eNXW1U6EVp/uonFMq+rahlX3Dt+ejndoBW1/JsAg42Cw7gybF1LBeQTl6gMZ5HryVcSWBMFYe+M8S57Wv8ED6DRTH6PPtWHr7UFvQEjifGI2Tq9zXD6laq2YKDUmi6y62TmW4L9y25n1EnEmyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714371349; c=relaxed/simple;
	bh=wWYTLysWbZVwx7UkQnw3UiKd7VQJ5KYAU9/cdo+r31M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gfsCqQO5sWdmCwG0wwq9Z8oI/QK8lwEGVNQJMSe9IKkLLxWlTVIfjAa1L8J+SEi/8rcpgksOUK2iimb4d+BbiONpCrc1d/hxbxnW90FRfoEFpk70J5QEFnIDhKnCNShHMkHcKql1Q/k6PRFjUlC/TcUs7JXf6qLXepAkKAfQkPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yKLBrQk2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yKLBrQk2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qK56DxKJVjW1wJhi47rvMJIDsf6HftF/f95Q7f1GKwI=; b=yKLBrQk2aopyV1wpq57rzwka1K
	QSGxknPInfv0jJ6rfD7aRrVvPNTk5CN+OsfIimQMQfxjn948zUu31TamgxZZQ2z2gXgpTwRnJsr/G
	2poGdBn2PLgI4I+QAuj8eBP3L14YglJNNnZiJzsWaeWARgdGGgXRLQVpKjlaDW4qYrXseJuoU+fXV
	x8mDqM8AL3W+p7PoE0CG+bwhWwLwoROsvgXqQ9Wo/j4UrFse2zW1jI58Z9n6wSlLaAm17P6GZ61x8
	W3owp1TztIYjh/EdI6CHGbRIYBRrhDVkpssTRc8jtTFPGjc6PJ4IESzxBqPxhZdBW/1j+WR4FFyoq
	uJKGDFkg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1KIl-00000001cm2-0wtV;
	Mon, 29 Apr 2024 06:15:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: remove the xfs_iext_peek_prev_extent call in xfs_bmapi_allocate
Date: Mon, 29 Apr 2024 08:15:26 +0200
Message-Id: <20240429061529.1550204-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429061529.1550204-1-hch@lst.de>
References: <20240429061529.1550204-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Both callers of xfs_bmapi_allocate already initialize bma->prev, don't
redo that in xfs_bmapi_allocate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fe1ccc083eb3c4..472c795beb8add 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4187,11 +4187,6 @@ xfs_bmapi_allocate(
 	ASSERT(bma->length > 0);
 	ASSERT(bma->length <= XFS_MAX_BMBT_EXTLEN);
 
-	if (bma->wasdel) {
-		if (!xfs_iext_peek_prev_extent(ifp, &bma->icur, &bma->prev))
-			bma->prev.br_startoff = NULLFILEOFF;
-	}
-
 	if (bma->flags & XFS_BMAPI_CONTIG)
 		bma->minlen = bma->length;
 	else
-- 
2.39.2

