Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80A1471CFB;
	Thu, 23 Jul 2026 14:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818229; cv=none; b=dc1KrPfo7PJS1gYYg9HSjoCgU5SGo7PsnzER0Ar+gTd9cbP2EwO2g2g9hlKX+8luuPpcEEHgUxxHsxXtNjjvL6DgJ33pp8lQaJvKBDiyQ9R7e3Iw8cMnr0tWoWSvY26n1w/+CAqa6zpAjlKTszFfcOpimLfCfUfAX1GBufaiS7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818229; c=relaxed/simple;
	bh=oow2OZDssy3qdR30BYSYYhTQ1aDANszpRHj1VIX0bTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdW3WNzdymNejZjV4kBcBSd6bNpxIDPIjp4zFjSJrueTZ3KV54sIITcItIRUWqJ3ybnNW9TWTw7fvMA8MI/72hsj++ezJ/vKh2akx/yi3K6MTbobnLTPlIqmDLgZjlsTBVkIEcKSs5Y3h3qe1m6b+FFRdRyMaQ388b8nf5reBZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TfD5q5cj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TfD5q5cj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=g3MiAM44QpsH5OThcGeQH3JNQ8HnyKAJVP1OSD90Hh4=; b=TfD5q5cjDw3Ej7h9kKnLi6zzxE
	euGbZVQQp8lO98+DTbKpA4TxEC8dPBG9FmeoYoQi9RSrezfJg9FY7ZVJqon1R4L+Q6sZiVOQWvzcG
	CkejFGHWxyNHi/mROAlJxTs/QFFu1kLnpgo9kSKX49RcuWpm+UL4jeG3dVc22/VSaqRJsJXoqzMQh
	CpMJQjlyMdWro3Oh/iZnYmpka1A8QtyaBB4/sGwgONeWhhtZ4gU2SpJjeCj8SVATZTNfNo7n8sPlq
	gY+b6wQ4fCb0bEiWJuuh5243U3/8RSk1xDgx0GuhM8X7GJlRghhCbYJoKtRbr0ZCy1pA11W00s3N6
	0cD0hwsg==;
Received: from 213-225-6-25.nat.highway.a1.net ([213.225.6.25] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmukj-0000000EXI8-0IUi;
	Thu, 23 Jul 2026 14:50:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 05/22] iomap: don't free integrity payload that doesn't exist
Date: Thu, 23 Jul 2026 16:49:30 +0200
Message-ID: <20260723145000.116419-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723145000.116419-1-hch@lst.de>
References: <20260723145000.116419-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

fs_bio_integrity_alloc might not allocate a bio integrity payload if PI
verification is disabled on the block device.  Check for that case before
calling fs_bio_integirty_free in iomap_bio_read_folio_range_sync to
avoid a NULL pointer dereferences.

Make the branch cover the PI verification as well - while
fs_bio_integrity_verify works without an integrity payload, it requires
one to actually do useful work.

Fixes: 0b10a370529c ("iomap: support T10 protection information")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index dc8ac7e370a5..30ef78a66b4f 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -179,7 +179,7 @@ int iomap_bio_read_folio_range_sync(const struct iomap_iter *iter,
 	if (srcmap->flags & IOMAP_F_INTEGRITY)
 		fs_bio_integrity_alloc(&bio);
 	error = submit_bio_wait(&bio);
-	if (srcmap->flags & IOMAP_F_INTEGRITY) {
+	if (bio_integrity(&bio)) {
 		if (!error)
 			error = fs_bio_integrity_verify(&bio, sector, len);
 		fs_bio_integrity_free(&bio);
-- 
2.53.0

