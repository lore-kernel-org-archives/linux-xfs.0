Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28734239E9D
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 11:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756121717; cv=none; b=rh/73HHwnaLRbK4EAqpqHmNpx/k7K6J6JCDg5k4nLwWLH1StmtfulTRuPXf1s1HQsQR1Lk0QHbnqpWNgv+vzIjrUwT3W0zzKxCsFxhup4mJvXJAsq0bIJR1N81UlPfj8UP7FU6FScmMMpomW8pdwXp8SIfQ0E735Vl9i4RXECoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756121717; c=relaxed/simple;
	bh=EobWhK8zOoiPIlpjXkS/R0vKcvOeQfjArIYUdGcoPNI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o4726lUHXfIeVOjsltWz7xJLRh5OU1SFY9E4/fxNngiPRDJ4c+9G5eMFd9b7zVjVbO67OnMPBVLeiOhXwa2yCDNXF3fwfS/EThznFuJ7mlVRPlZ+80ir6wuDKVIkC0Sm6o26tJsQW6QVkrs87drhWWRLxva6YQfRtBJoWF9x9R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WsoEwa5/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WsoEwa5/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=MoUhy+RCZCBCbh8YdHwibHF/B616DaTBP8BqHhCC3tw=; b=WsoEwa5/zv9Otkete/EQ8XSXcK
	lM1EVbzMMT96itg4n1MNDQnQHEEo5P23snyOJuaAwJ4mhEJZdP0u5jPu3s6XMgFqP/P0gmQdLGYwJ
	9mPFRmk16Yy0E2aRA/aUbay379ltVXySFlBwXcnGgQ68yYqGkkvIsAzg3U7wzvpbu9rvHNDwXsn9L
	2t7bBKA0SemddNNE7yaCAxwQD7DWvmDYjZ3iEo3ut0GwsijT7xVrauN7imiPJRaFS2v7JREaIF+A6
	XUDmgmqUyzZsjSBkayjB2Osz4Weunvg8/RZQIFp2F6soFY60tWv/bkRgu8kqJ4N9F24cwdxyqRGUA
	BDWZn2ZA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqVTm-00000007mJX-1QnZ;
	Mon, 25 Aug 2025 11:35:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Hans.Holmberg@wdc.com
Subject: [PATCH] xfs: remove the unused bv field in struct xfs_gc_bio
Date: Mon, 25 Aug 2025 13:35:11 +0200
Message-ID: <20250825113511.474923-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 064cd1a857a0..d2d8fe547074 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -114,8 +114,7 @@ struct xfs_gc_bio {
 	/* Open Zone being written to */
 	struct xfs_open_zone		*oz;
 
-	/* Bio used for reads and writes, including the bvec used by it */
-	struct bio_vec			bv;
+	/* Bio used for reads and writes */
 	struct bio			bio;	/* must be last */
 };
 
-- 
2.47.2

