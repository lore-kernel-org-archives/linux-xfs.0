Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A4E25484A
	for <linux-xfs@vger.kernel.org>; Mon, 14 Jul 2025 13:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752499049; cv=none; b=lRyXNsYuMLRlPB0c9GevCBttfc1m0PC8H5yYwmeqVT6OvdvTZWDyL1hnfvWI8Bsf7gHgwXsmlQSylzn3awfHbklc0SBY0s8K6RXwAl8Mypn82jVTgSLzvgJLmFV30Kh8FhP2zUL6EjKVBfHCAe+3pH0KDxGOMwjjDJzw/53Nz6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752499049; c=relaxed/simple;
	bh=vW22s/PoPojZugGSb375DX0cbe1kSJqFR28Fk9xR3TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aSl/mjantBx8xju+yZIGOhc7aXp/WrjCkM42DitVTgTcqSXtcO3zDVHSeMmyxMYoiaFB+ZPUpLWLPvc2nP6NuKuDJvhZamiE8wAEwjRDcBSULQEXiVzw+zU2UDc7bOmAGKw2q0RTteAs8wBLmtfaGzJbxwec+4H7FiOD+MQGXRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A2yMqbdU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A2yMqbdU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752499046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QCOjwj+34/t9ifmYam4dh/DH4qIGBIaB0drRCZdZ628=;
	b=A2yMqbdU2ah03oXnS11NREqXcIefMCXA67GbLWNyZuSnqe3GrlKXohCUCaqNCoajwBe6p5
	FLDp8LG14Tx8qGMZc5CbC6f9eTTFg4wX/0oUah1+e12gZr30IYnJTYc9vR27jTaErkufW7
	EIn84hESTlCqyi/gxD3SneB7Qs3hSc4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-emcqoeHGNbKehwyK1ZeI2A-1; Mon,
 14 Jul 2025 09:17:22 -0400
X-MC-Unique: emcqoeHGNbKehwyK1ZeI2A-1
X-Mimecast-MFC-AGG-ID: emcqoeHGNbKehwyK1ZeI2A_1752499040
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4A40195608F;
	Mon, 14 Jul 2025 13:17:20 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.43])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 87C621800285;
	Mon, 14 Jul 2025 13:17:19 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v2 2/7] iomap: move pos+len BUG_ON() to after folio lookup
Date: Mon, 14 Jul 2025 09:20:54 -0400
Message-ID: <20250714132059.288129-3-bfoster@redhat.com>
In-Reply-To: <20250714132059.288129-1-bfoster@redhat.com>
References: <20250714132059.288129-1-bfoster@redhat.com>
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
the filesystem. Move the check a bit further down after the folio
lookup and range trim to verify everything lines up with the current
iomap.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 3729391a18f3..38da2fa6e6b0 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -805,15 +805,12 @@ static int iomap_write_begin(struct iomap_iter *iter, struct folio **foliop,
 {
 	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
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
2.50.0

