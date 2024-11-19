Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780B51D0B9B
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 15:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031130; cv=none; b=qz7IPl790A15xEELlKuKH+DY/bQknrPD3FxGwC+v7vLFz/TJRr64vxq3KmAr0bc2GUrTmeTmJ8reqiWY9awkuckIiv5LqfP3zcdgrQNFfGr26e+ukLL76xvnDUIgwW6yEqtkNR0RV7di9rp6oysdlgYWHoInnwyrC6HqiIcEEzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031130; c=relaxed/simple;
	bh=DUqTZuX3ibPNvI0oVsl5z3VIK6xmqdlnQ95TwMVcteo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q42FJ9MGZvVCZUfz26697mGqxkIV0ueNgdmdEJ718ex7kpVr3vyb7Lbv5SAHBVp/xiGU56jb5n8a3ct7r01lMQ7GCwajtu8nrLDHdfF74jJ6wv3BjMPepqjYRgZ5+BtwyxaXVgPPh0p19UO7J/cinJx3yFwEYhupUH9MIKQLLGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aybjoRi5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aybjoRi5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732031126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjZU7g2vo6uZ/HXSxZz5fNHUtmju3LrZ0LlIZ9RX0h4=;
	b=aybjoRi58w4I59jBXXiQmeBf5QKgxIG2hHsFyHGnEIdq6ZiRO0v3Zo/94SGn336UzauDlZ
	zFJoigeSmHKUAP3xZZ2YiBwhvc53JVrU1rfFCd3Mvp0sp+zPYacYjw47xBKHZCKEavi7E2
	1T3GB1ToBz7iaDdHcBXsj+7aYlJa5+Y=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-505-4m05kcxjMXy3WLJZNo6vmg-1; Tue,
 19 Nov 2024 10:45:24 -0500
X-MC-Unique: 4m05kcxjMXy3WLJZNo6vmg-1
X-Mimecast-MFC-AGG-ID: 4m05kcxjMXy3WLJZNo6vmg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54107195608D;
	Tue, 19 Nov 2024 15:45:23 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.120])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AFFDE1956054;
	Tue, 19 Nov 2024 15:45:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH RFC 1/4] iomap: allow passing a folio into write begin path
Date: Tue, 19 Nov 2024 10:46:53 -0500
Message-ID: <20241119154656.774395-2-bfoster@redhat.com>
In-Reply-To: <20241119154656.774395-1-bfoster@redhat.com>
References: <20241119154656.774395-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

To facilitate batch processing of dirty folios for zero range, tweak
the write begin path to allow the caller to optionally pass in its
own folio/pos combination.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index ce73d2a48c1e..d1a86aea1a7a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -781,7 +781,7 @@ static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 {
 	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
-	struct folio *folio;
+	struct folio *folio = *foliop;
 	int status = 0;
 
 	BUG_ON(pos + len > iter->iomap.offset + iter->iomap.length);
@@ -794,9 +794,15 @@ static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 	if (!mapping_large_folio_support(iter->inode->i_mapping))
 		len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
 
-	folio = __iomap_get_folio(iter, pos, len);
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+	/*
+	 * XXX: Might want to plumb batch handling down through here. For now
+	 * let the caller do it.
+	 */
+	if (!folio) {
+		folio = __iomap_get_folio(iter, pos, len);
+		if (IS_ERR(folio))
+			return PTR_ERR(folio);
+	}
 
 	/*
 	 * Now we have a locked folio, before we do anything with it we need to
@@ -918,7 +924,7 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
 
 	do {
-		struct folio *folio;
+		struct folio *folio = NULL;
 		loff_t old_size;
 		size_t offset;		/* Offset into folio */
 		size_t bytes;		/* Bytes to write to folio */
@@ -1281,7 +1287,7 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 		return length;
 
 	do {
-		struct folio *folio;
+		struct folio *folio = NULL;
 		int status;
 		size_t offset;
 		size_t bytes = min_t(u64, SIZE_MAX, length);
@@ -1385,7 +1391,7 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 	}
 
 	do {
-		struct folio *folio;
+		struct folio *folio = NULL;
 		int status;
 		size_t offset;
 		size_t bytes = min_t(u64, SIZE_MAX, length);
-- 
2.47.0

