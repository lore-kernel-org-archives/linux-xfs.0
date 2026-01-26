Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0920223336;
	Mon, 26 Jan 2026 05:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769406885; cv=none; b=u9XP/ZUC6bxeQSOVml+sgNryc8yKtnfqDGz7trIQX4HOxH/rBjDdU9T5ij4+WGD2pXgiotjjSNP4U+Yb+jVnLqy7i5dGqKfS/oALxdiPfQ4IJgf31l/e5VHUqFtghyECvsWzCeuFc7Cuwzi3huaI5fSgNx+ht8xfbNOf6badp3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769406885; c=relaxed/simple;
	bh=PT2f4azBsijlT1dSm6doVN2Lny6POIRW3sYqM+ZcUHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWnVYbGm0ud5JQJjW78huVzhXCodXjp5YAx2ZhEYgOzCX7LuP3HOFKIsw7hOARbctLm0vdss7ksvXNu24OlrWqPiEwgR8AUxz8tKYfdr4J5cL6CW/ppE9poPJdlXOPoeJhs9EB16GftPKaSntkBqkLP3+bNFNDA6YUsZRqHkYzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u/7Wn8iF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u/7Wn8iF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GaK9f7GNG5jt2q9FYJX47fvTQUzLlPrfxtwSUqDJZAU=; b=u/7Wn8iFzXdDIMoIAwLdk2YK7O
	+6sp3UqBhCds6a8fOUODqeXDaEfY2K3c5HL1ED5bfETV4TyNdYlqqCfRO1vkW0MpeGoFO+sEhP2jk
	3+/Pff4sOYtxsdWCt1nRjI0HUAJ/1/Fx1nxYtVfpx7FgceGDn3iP2v5nfhu6hxbp+q9W8QaM2kPgX
	9F859cymySht0SvTyPu1acj70bPBHIB3NT0S3aULUQSF+ItH46Wn69YkulqWWpDiEcNtp3YzUTDu6
	t97D42snRtU6q2TaTaJGhyd1TwC3NyV3Qy/hd8x/PYFXZFss81kG2k59fiU1Q/zJpzwxSSv1zLLT2
	nzOZphJg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkFYg-0000000BxGw-3xV5;
	Mon, 26 Jan 2026 05:54:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 07/15] iomap: fix submission side handling of completion side errors
Date: Mon, 26 Jan 2026 06:53:38 +0100
Message-ID: <20260126055406.1421026-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126055406.1421026-1-hch@lst.de>
References: <20260126055406.1421026-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The "if (dio->error)" in iomap_dio_bio_iter exists to stop submitting
more bios when a completion already return an error.  Commit cfe057f7db1f
("iomap_dio_actor(): fix iov_iter bugs") made it revert the iov by
"copied", which is very wrong given that we've already consumed that
range and submitted a bio for it.

Fixes: cfe057f7db1f ("iomap_dio_actor(): fix iov_iter bugs")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/direct-io.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 4000c8596d9b..867c0ac6df8f 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -443,9 +443,13 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	nr_pages = bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS);
 	do {
 		size_t n;
-		if (dio->error) {
-			iov_iter_revert(dio->submit.iter, copied);
-			copied = ret = 0;
+
+		/*
+		 * If completions already occurred and reported errors, give up now and
+		 * don't bother submitting more bios.
+		 */
+		if (unlikely(data_race(dio->error))) {
+			ret = 0;
 			goto out;
 		}
 
-- 
2.47.3

