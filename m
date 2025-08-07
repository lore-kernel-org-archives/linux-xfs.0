Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD718267F59
	for <linux-xfs@vger.kernel.org>; Thu,  7 Aug 2025 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754577815; cv=none; b=oS3lPl4LsHP4qV4nTF0kaj7mGWRs9wW9FKPmFNx3wylGN/S/G8jsJeljb8fFr6dmnRAppIFkq441+oE6Ba0WW2nFKXwMvWMVWNpNp2300n+nBpZyHFABiSoSo69i+hz5DGbbpKjA6qnlIYaiT4DNI1nU2xCmdCCgMHe9r+t3ddg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754577815; c=relaxed/simple;
	bh=+BFalO01dBuQBj2kvt6050joIdbJ0RokioQT0dcLkk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ue9wzowzL1YL5OLbFrdDAQtaC70D42BxVl4YPr4UEGf95ekFD+U5lgFVsarESXqrgKcz4Se6NbJN0whB+/ms6Y9Tn6Nn8ijhCX+9YbdgTQLBexLBHWXwDE2q/57Aq7HdRJngvLhCdftlloSF3TOX0F82owGKij+iyUEnspix9uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=btSVvyND; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="btSVvyND"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754577811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4hm1cBxL4CiOFlgRy+2RR5vulmGkLMB/1ZOnWypg050=;
	b=btSVvyNDDJNBG/bPzrLsNT9ib9+cluoUk5/wpkNNJD62HNIVxXo5BIPC0UwvxpWzAZswPR
	r13eJV6xZyKbzSUSttK2720fvrezv6XtYHnkMvP4NGtE4R4SMdOxsNBD0/RPFT+NjTS3FN
	pq2HKEpoXCfJWE4zs7RJX89CTQtl9ps=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-VCRoputKOFGGr0R1NpgjoA-1; Thu,
 07 Aug 2025 10:43:27 -0400
X-MC-Unique: VCRoputKOFGGr0R1NpgjoA-1
X-Mimecast-MFC-AGG-ID: VCRoputKOFGGr0R1NpgjoA_1754577805
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F09919560AF;
	Thu,  7 Aug 2025 14:43:25 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 242641800294;
	Thu,  7 Aug 2025 14:43:23 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v4 2/7] iomap: remove pos+len BUG_ON() to after folio lookup
Date: Thu,  7 Aug 2025 10:47:05 -0400
Message-ID: <20250807144711.564137-3-bfoster@redhat.com>
In-Reply-To: <20250807144711.564137-1-bfoster@redhat.com>
References: <20250807144711.564137-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The bug checks at the top of iomap_write_begin() assume the pos/len
reflect exactly the next range to process. This may no longer be the
case once the get folio path is able to process a folio batch from
the filesystem. On top of that, len is already trimmed to within the
iomap/srcmap by iomap_length(), so these checks aren't terribly
useful. Remove the unnecessary BUG_ON() checks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index fd827398afd2..01721f10cf6e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -812,15 +812,12 @@ static int iomap_write_begin(struct iomap_iter *iter,
 		size_t *poffset, u64 *plen)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
-	loff_t pos = iter->pos;
+	loff_t pos;
 	u64 len = min_t(u64, SIZE_MAX, iomap_length(iter));
 	struct folio *folio;
 	int status = 0;
 
 	len = min_not_zero(len, *plen);
-	BUG_ON(pos + len > iter->iomap.offset + iter->iomap.length);
-	if (srcmap != &iter->iomap)
-		BUG_ON(pos + len > srcmap->offset + srcmap->length);
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
-- 
2.50.1

