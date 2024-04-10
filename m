Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2FE160780
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 14:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712758084; cv=none; b=EmvLpEYEHfCxXixuv7Y5uSij4fOYfgdsNrUxm7UCLqfrXEczfyT4zcBrVyl2oA7LMRfjfu6CqHFicPW7E6EDjlLOs9LwT8R8DfJkMcy3t6GPtQLUZHjt370EGFfCdwGb5YU5kqWR0OELgxcBGF6Rw8IdHpQkMRlaNQckxUQg2+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712758084; c=relaxed/simple;
	bh=WIPdk4LLVt44VIGow6FHKfCR8GxmUUKgvQKq6Ebnkc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eVFDlYc2Dpsb2BDxQ8xKU3uUu3r/b3BIy8WGFq3b2+E7C8DXkE3vK/jsJx28WT0bNuUg54jkdg7QsKEgz2hvik9BcPUsQsJN281CT+PCMJu9X9oCisga0CgXy5A1Rh6c0Zxy3tui0gO50aDb6yednHbbo64cPXgR8c9ZhXxfA5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iK4GWz2v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iK4GWz2v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712758081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Gpc8NsQlOqmTIysB17MQYNDNTLuUHo+RMJ20Aam3CY=;
	b=iK4GWz2v+gyawmvAxdZzOq19lDf9zt7t2digNix4PHACcPTV+OWxD+FR39sJaDRflUsWTI
	1zRnJkEz8QxGg3jGnt6oeYJGBc4S7xQ5gYFjKg0TWBlGtF32Ak5SP6l6kl2x0RPSaTv7oN
	dQzXaLI88BKtHyW1HxxqeKx6uD5JYao=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-192-J37gXWDvMfiV7x0HTOH6QQ-1; Wed,
 10 Apr 2024 10:07:58 -0400
X-MC-Unique: J37gXWDvMfiV7x0HTOH6QQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2223B3C108CA;
	Wed, 10 Apr 2024 14:07:58 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EB0581C060A6;
	Wed, 10 Apr 2024 14:07:57 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH RFC 1/3] iomap: factor out a bio submission helper
Date: Wed, 10 Apr 2024 10:09:54 -0400
Message-ID: <20240410140956.1186563-2-bfoster@redhat.com>
In-Reply-To: <20240410140956.1186563-1-bfoster@redhat.com>
References: <20240410140956.1186563-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

This is a small cleanup to facilitate a nosubmit iomap flag. No
functional changes intended.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 4e8e41c8b3c0..b6d176027887 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -43,6 +43,23 @@ struct iomap_folio_state {
 
 static struct bio_set iomap_ioend_bioset;
 
+/*
+ * Simple submit_bio() wrapper. Set ->bi_status to trigger error completion.
+ */
+static inline int iomap_submit_bio(struct bio *bio, bool wait)
+{
+	int ret = 0;
+
+	if (bio->bi_status)
+		bio_endio(bio);
+	else if (wait)
+		ret = submit_bio_wait(bio);
+	else
+		submit_bio(bio);
+
+	return ret;
+}
+
 static inline bool ifs_is_fully_uptodate(struct folio *folio,
 		struct iomap_folio_state *ifs)
 {
@@ -411,7 +428,7 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 		unsigned int nr_vecs = DIV_ROUND_UP(length, PAGE_SIZE);
 
 		if (ctx->bio)
-			submit_bio(ctx->bio);
+			iomap_submit_bio(ctx->bio, false);
 
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
@@ -464,7 +481,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 		folio_set_error(folio);
 
 	if (ctx.bio) {
-		submit_bio(ctx.bio);
+		iomap_submit_bio(ctx.bio, false);
 		WARN_ON_ONCE(!ctx.cur_folio_in_bio);
 	} else {
 		WARN_ON_ONCE(ctx.cur_folio_in_bio);
@@ -537,7 +554,7 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
 		iter.processed = iomap_readahead_iter(&iter, &ctx);
 
 	if (ctx.bio)
-		submit_bio(ctx.bio);
+		iomap_submit_bio(ctx.bio, false);
 	if (ctx.cur_folio) {
 		if (!ctx.cur_folio_in_bio)
 			folio_unlock(ctx.cur_folio);
@@ -665,7 +682,7 @@ static int iomap_read_folio_sync(loff_t block_start, struct folio *folio,
 	bio_init(&bio, iomap->bdev, &bvec, 1, REQ_OP_READ);
 	bio.bi_iter.bi_sector = iomap_sector(iomap, block_start);
 	bio_add_folio_nofail(&bio, folio, plen, poff);
-	return submit_bio_wait(&bio);
+	return iomap_submit_bio(&bio, true);
 }
 
 static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
@@ -1667,12 +1684,9 @@ static int iomap_submit_ioend(struct iomap_writepage_ctx *wpc, int error)
 	if (wpc->ops->prepare_ioend)
 		error = wpc->ops->prepare_ioend(wpc->ioend, error);
 
-	if (error) {
+	if (error)
 		wpc->ioend->io_bio.bi_status = errno_to_blk_status(error);
-		bio_endio(&wpc->ioend->io_bio);
-	} else {
-		submit_bio(&wpc->ioend->io_bio);
-	}
+	iomap_submit_bio(&wpc->ioend->io_bio, false);
 
 	wpc->ioend = NULL;
 	return error;
-- 
2.44.0

