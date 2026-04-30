Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C9341C31C;
	Thu, 30 Apr 2026 13:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777555239; cv=none; b=GachTz5MkiNfYeAK4ANF8dpPi2P/fdvX5wKACwnniB6xijyCJGI5L18sKZeFRsT9RClKBWyNWYDpWdsZ4LMdHKa7XHXPjWMivL9uWLaY/Fngfydu8E7xjlTu9/feIqmEEomvxfD+5NwBubQmLMETnvmmHEJWb7oCKF31pTLfN9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777555239; c=relaxed/simple;
	bh=7EBB5GHCkHN0TskgiyxxoRk10u5pmW6e6NqBn22cBxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=betxRNKFkcTxCX0frmdorSTpRGskAdSqUARFc0ny17JnBqdyxktAsqijtqyPC0iYHWnekMWQQ1g6R5+qvpOFJsUZn8n+A/hE4/N+rGrj+JENHGq3K3ednoz8HIJeWCqfSppVAXJ8yMtHqT/xwmezHMK7m4ow0VX8x0qm+Svyuq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d74SYXVy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d74SYXVy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mDN+B9dh+NPxIY/UB0rdWyWd3aHMT0pACMhP7a3XzOM=; b=d74SYXVyLOMwmRrYGy2Kg2BfDf
	JFqBmzhpexVisgoo7VfdBa5A7ZrymFwsiQiH4u7aQfIm32ba8j8GxP/yYmwzndLGFe3H+Zu64sv6j
	8f0Li/sIZgNl6YT0fLRe3FI6G6YGCSWGuyFMvYkVwfYbKH3Rv3BVdqIjRpjD5I0BDj8VPuZvOp+sG
	NAiFOpfUWoOHU/6Je0ypiFG1M3Hnzq0G3XSenkLWZ4CpkMwWXHKW4ZnUm6BzCn9arkiuHVIpdGf3q
	Sn5/EXzHci3El1f2Iuqt8t5q9qFQ0fwZeP15ULPaes4LGeRokOdOJ46ZbRA19PIa7PU+l/b3xpq0o
	TYwpDuuQ==;
Received: from [2001:4bb8:2d1:b956:8772:dd9e:18ae:7a3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIRJh-00000005WvJ-1MbH;
	Thu, 30 Apr 2026 13:20:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/2] block: align down bounces bios
Date: Thu, 30 Apr 2026 15:20:05 +0200
Message-ID: <20260430132019.312405-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260430132019.312405-1-hch@lst.de>
References: <20260430132019.312405-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Just like for the extract user pages path, we need to align down the
size to the supported boundary.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index f3e5d8bea08c..5f10900b3f42 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1345,7 +1345,7 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 
 	if (!bio->bi_iter.bi_size)
 		return -ENOMEM;
-	return 0;
+	return bio_iov_iter_align_down(bio, iter, minsize - 1);
 }
 
 static int bio_iov_iter_bounce_read(struct bio *bio, struct iov_iter *iter,
@@ -1383,7 +1383,7 @@ static int bio_iov_iter_bounce_read(struct bio *bio, struct iov_iter *iter,
 	bvec_set_folio(&bio->bi_io_vec[0], folio, bio->bi_iter.bi_size, 0);
 	if (iov_iter_extract_will_pin(iter))
 		bio_set_flag(bio, BIO_PAGE_PINNED);
-	return 0;
+	return bio_iov_iter_align_down(bio, iter, minsize - 1);
 }
 
 /**
-- 
2.53.0

