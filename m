Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC27315FCF9
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 14:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712758084; cv=none; b=o+tZsbDSX9NQtwA+8O++xNIqBliTBTHR1o8okNo8CGhw5Jk/PuHhqOAju5JSXKHXg0F6weUNtAsHYQJDr+EP71ltzYifiUeP94grbP+AybcoCJpm+FKeuGCCnzsMGUdtll9DKOpa3odhw+nk5Ow2tAi+Y1AMcRsF5OHpxqLvOiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712758084; c=relaxed/simple;
	bh=+gCVGg7WykCJCqiT/KTLnUkV/fs21QxdSsOT1bLAqcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XWkSB21SEeflYWaPJnw5OYDTuXcfPoz58pVaRJlH5IJWak9zkmVON4XX3VycnigyZzmCsNfqGSVJtNSMADEfiH5qOrBSkNgZHGokeeH7mlQ6zabnvGq6HLe5ICe50nWOujSmHxsdS66TyRkZVuIYgceTzAOduriia1ATAN8Nozk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZWphFIQE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZWphFIQE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712758081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UO/HFc/5sXpzWZHKxBgz7AEGxInJGIPNp1IQ1Vxtm38=;
	b=ZWphFIQEqJlBe8kyk9LXHHcE8SQ40UZ0wQLVbzy8uc9/LqTHogD84bOqbIVsIJGYC4CXYw
	7shohzOTv+9o9xDT3ujuUw41T2Pp3MOfWKShn3T2hLERCeR9zBx946rXUINtnydLKPZF8v
	eaHQW6nmuDGW0VdGtdttRdbkpGtDgMo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-7_KbXs26P0ywe_MLcUg6LQ-1; Wed, 10 Apr 2024 10:07:58 -0400
X-MC-Unique: 7_KbXs26P0ywe_MLcUg6LQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DFDD1044574;
	Wed, 10 Apr 2024 14:07:58 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2F3911C060A6;
	Wed, 10 Apr 2024 14:07:58 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH RFC 2/3] iomap: add nosubmit flag to skip data I/O on iomap mapping
Date: Wed, 10 Apr 2024 10:09:55 -0400
Message-ID: <20240410140956.1186563-3-bfoster@redhat.com>
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

Define a nosubmit flag to skip data I/O submission on a specified
mapping. The iomap layer still performs every step up through
constructing the bio as if it will be submitted, but instead invokes
completion on the bio directly from submit context. The purpose of
this is to facilitate filesystem metadata performance testing
without the overhead of actual data I/O.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 21 +++++++++++++--------
 include/linux/iomap.h  |  1 +
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index b6d176027887..5d1c443a6fb4 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -46,11 +46,16 @@ static struct bio_set iomap_ioend_bioset;
 /*
  * Simple submit_bio() wrapper. Set ->bi_status to trigger error completion.
  */
-static inline int iomap_submit_bio(struct bio *bio, bool wait)
+static inline int iomap_submit_bio(const struct iomap *iomap, struct bio *bio,
+				   bool wait)
 {
-	int ret = 0;
+	int	ret = 0;
+	bool	nosubmit = iomap->flags & IOMAP_F_NOSUBMIT;
+
+	if (nosubmit)
+		zero_fill_bio_iter(bio, bio->bi_iter);
 
-	if (bio->bi_status)
+	if (bio->bi_status || nosubmit)
 		bio_endio(bio);
 	else if (wait)
 		ret = submit_bio_wait(bio);
@@ -428,7 +433,7 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 		unsigned int nr_vecs = DIV_ROUND_UP(length, PAGE_SIZE);
 
 		if (ctx->bio)
-			iomap_submit_bio(ctx->bio, false);
+			iomap_submit_bio(iomap, ctx->bio, false);
 
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
@@ -481,7 +486,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 		folio_set_error(folio);
 
 	if (ctx.bio) {
-		iomap_submit_bio(ctx.bio, false);
+		iomap_submit_bio(&iter.iomap, ctx.bio, false);
 		WARN_ON_ONCE(!ctx.cur_folio_in_bio);
 	} else {
 		WARN_ON_ONCE(ctx.cur_folio_in_bio);
@@ -554,7 +559,7 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
 		iter.processed = iomap_readahead_iter(&iter, &ctx);
 
 	if (ctx.bio)
-		iomap_submit_bio(ctx.bio, false);
+		iomap_submit_bio(&iter.iomap, ctx.bio, false);
 	if (ctx.cur_folio) {
 		if (!ctx.cur_folio_in_bio)
 			folio_unlock(ctx.cur_folio);
@@ -682,7 +687,7 @@ static int iomap_read_folio_sync(loff_t block_start, struct folio *folio,
 	bio_init(&bio, iomap->bdev, &bvec, 1, REQ_OP_READ);
 	bio.bi_iter.bi_sector = iomap_sector(iomap, block_start);
 	bio_add_folio_nofail(&bio, folio, plen, poff);
-	return iomap_submit_bio(&bio, true);
+	return iomap_submit_bio(iomap, &bio, true);
 }
 
 static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
@@ -1686,7 +1691,7 @@ static int iomap_submit_ioend(struct iomap_writepage_ctx *wpc, int error)
 
 	if (error)
 		wpc->ioend->io_bio.bi_status = errno_to_blk_status(error);
-	iomap_submit_bio(&wpc->ioend->io_bio, false);
+	iomap_submit_bio(&wpc->iomap, &wpc->ioend->io_bio, false);
 
 	wpc->ioend = NULL;
 	return error;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 6fc1c858013d..8d34ec240e12 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -64,6 +64,7 @@ struct vm_fault;
 #define IOMAP_F_BUFFER_HEAD	0
 #endif /* CONFIG_BUFFER_HEAD */
 #define IOMAP_F_XATTR		(1U << 5)
+#define IOMAP_F_NOSUBMIT	(1U << 6)
 
 /*
  * Flags set by the core iomap code during operations:
-- 
2.44.0

