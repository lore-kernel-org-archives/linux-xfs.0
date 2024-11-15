Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9B912F585
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 20:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731700830; cv=none; b=Ddu4x5OS5JSRKw7QDmaYPltx5XYEum1JtnMywuqFOHMPJLDhQP67NyY41f00ccOu7NR7J2SZQKF1pVT43V6j80iuFtqsXzDsy5zSafDdhIURZjepYLiW0X7b93iSXPGZ4e9d3VhyDPV7bI8RYonQt9kgB2c9qIhPZ04SIacUsgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731700830; c=relaxed/simple;
	bh=xCCcFj0TgUEtGfABdFQM0s73tU4M90qCrb6slEDmq4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b54x+sZktfMxPh4z16oa/1QGgVqyxeMuY7Wb4YZkgtPgPm4Hzfl5dr7KnMZXQEo/D4+FBtpDeNtO2oR/NVMkcUIlw8MJIkHaaEjoDrEUEXThOzO0BKhPTwJJIuX4i4w9TzDJipPURPy4ed/qd5JEOaepfVjABVLLuUAZaNh0Onk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jDh3nGGo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jDh3nGGo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731700827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0RK0ZBTwC8BCQOlAHX4o6t4hLRunjrMolcycpNapl9Q=;
	b=jDh3nGGoMIaowwPKq6znjfX5UHzvAyM9jPWkhKVqD0IuMW8dCRQMY/Ic7GifGs6CAkaA0n
	HPw+sx6L44RHbTUxGzuzezV8HNVtUOLnEGFEtFvwR2Jrk6JlcdXBDhzKe7BiZRfBimkMmL
	OqcIaudXK6xzFQ2j2WAdhvGHq+UE6Kk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-144-sMTN_FJBMaOq-mNP169SyQ-1; Fri,
 15 Nov 2024 15:00:25 -0500
X-MC-Unique: sMTN_FJBMaOq-mNP169SyQ-1
X-Mimecast-MFC-AGG-ID: sMTN_FJBMaOq-mNP169SyQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41D441955F42;
	Fri, 15 Nov 2024 20:00:24 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.120])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 547971953882;
	Fri, 15 Nov 2024 20:00:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v4 1/3] iomap: reset per-iter state on non-error iter advances
Date: Fri, 15 Nov 2024 15:01:53 -0500
Message-ID: <20241115200155.593665-2-bfoster@redhat.com>
In-Reply-To: <20241115200155.593665-1-bfoster@redhat.com>
References: <20241115200155.593665-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

iomap_iter_advance() zeroes the processed and mapping fields on
every non-error iteration except for the last expected iteration
(i.e. return 0 expected to terminate the iteration loop). This
appears to be circumstantial as nothing currently relies on these
fields after the final iteration.

Therefore to better faciliate iomap_iter reuse in subsequent
patches, update iomap_iter_advance() to always reset per-iteration
state on successful completion.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/iter.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 79a0614eaab7..3790918646af 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -22,26 +22,25 @@
 static inline int iomap_iter_advance(struct iomap_iter *iter)
 {
 	bool stale = iter->iomap.flags & IOMAP_F_STALE;
+	int ret = 1;
 
 	/* handle the previous iteration (if any) */
 	if (iter->iomap.length) {
 		if (iter->processed < 0)
 			return iter->processed;
-		if (!iter->processed && !stale)
-			return 0;
 		if (WARN_ON_ONCE(iter->processed > iomap_length(iter)))
 			return -EIO;
 		iter->pos += iter->processed;
 		iter->len -= iter->processed;
-		if (!iter->len)
-			return 0;
+		if (!iter->len || (!iter->processed && !stale))
+			ret = 0;
 	}
 
-	/* clear the state for the next iteration */
+	/* clear the per iteration state */
 	iter->processed = 0;
 	memset(&iter->iomap, 0, sizeof(iter->iomap));
 	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
-	return 1;
+	return ret;
 }
 
 static inline void iomap_iter_done(struct iomap_iter *iter)
-- 
2.47.0

