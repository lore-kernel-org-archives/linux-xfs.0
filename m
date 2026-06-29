Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CFA3FE37A
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 12:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782734558; cv=none; b=jAXBie1iblVgdMn/E7dFk6ODid3z71yMpCKsUwKT3pZd7caeUkJ1di3yvhoqqe8p6v+XFvwGoT1JkgLl/rMQlEB2z3gMYyvIp4mGOHp3a7BlAcdJTM++Dmk1TT3FgA6QP8pbhXn/h3Ae7SqBrQlcnMxKqquQtsRHcO2LUbpmqPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782734558; c=relaxed/simple;
	bh=TcboXjfnw3GWC29M5/vXwCJwozzZV9zFbxnOiAMQUKw=;
	h=Cc:From:Date:In-Reply-To:To:Mime-Version:References:Subject:
	 Message-Id:Content-Type; b=c7vQDJIxxgwn+tbmQFAV9IZrBmrmzKPj+uiv7pxi/4lRUE96RofV1lk4+53EZFoI1YlXjYhR0KvLXrVfGcQ1tjdhOwDMM+qULCd/FEWgLnggIntlajbiTHeH5X250u4cDY4bg5IQ7LP1j3wXN+m6CtBdOtMipp8fe4ej+21PPdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=RcVlQgV2; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="RcVlQgV2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782734546; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=bAgoa3/ClU61fhUDaibF1TS0E3XaqN/FGWAhPE8DBr8=;
 b=RcVlQgV2KxeDNf0lL4s8vp+2Otd9m4quGez3qLiSbxwUb7EMUPeExGfWdcfZ8lvCEI+lp8
 WMTCcMZPkbrDWJTfjPgF4J9rywK5ux5n+rAmyuCm/pWpuGst4RtybMtqpoSqPaK+s7xlvn
 vOMIRGs0tgktaj5ZKHEyOGlK0HyF1Vd7X8lzN4F10rdfys6sovKEiK+3ffvtv0RvLyRDlZ
 c/g4OFS5KTBIwYAtuE7KlE6Jzas6TxpAmdBVeZuJnkLXBcp9KvPzRzpmkiqyaFFHjCnXhw
 edFghriNsTaLn5hs0PVo0pbcMm+Y/dwW9oDdMzHv8E6Vws6krxB/ji0cjLNHiA==
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
From: "Fengnan Chang" <changfengnan@bytedance.com>
Date: Mon, 29 Jun 2026 20:01:22 +0800
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
In-Reply-To: <20260629120124.25223-1-changfengnan@bytedance.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, 
	<pankaj.raghav@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260629120124.25223-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 7bit
Subject: [PATCH v5 2/4] iomap: factor out iomap_dio_bio_release_pages helper
Message-Id: <20260629120124.25223-3-changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+26a425ed0+8861da+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8

Extract bio page-release logic from __iomap_dio_bio_end_io() into a
helper taking (bio, dio_flags, error) so the upcoming simple direct I/O
path can reuse it without a struct iomap_dio.

No functional change.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/iomap/direct-io.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 487c4763f3fde..c40350cdf3b14 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -237,23 +237,29 @@ static void iomap_dio_done(struct iomap_dio *dio)
 	iomap_dio_complete_work(&dio->aio.work);
 }
 
-static void __iomap_dio_bio_end_io(struct bio *bio, bool inline_completion)
+static inline void iomap_dio_bio_release_pages(struct bio *bio,
+		unsigned int dio_flags, bool error)
 {
-	struct iomap_dio *dio = bio->bi_private;
-
 	if (bio_integrity(bio))
 		fs_bio_integrity_free(bio);
 
-	if (dio->flags & IOMAP_DIO_BOUNCE) {
-		bio_iov_iter_unbounce(bio, !!dio->error,
-				dio->flags & IOMAP_DIO_USER_BACKED);
+	if (dio_flags & IOMAP_DIO_BOUNCE) {
+		bio_iov_iter_unbounce(bio, error,
+				dio_flags & IOMAP_DIO_USER_BACKED);
 		bio_put(bio);
-	} else if (dio->flags & IOMAP_DIO_USER_BACKED) {
+	} else if (dio_flags & IOMAP_DIO_USER_BACKED) {
 		bio_check_pages_dirty(bio);
 	} else {
 		bio_release_pages(bio, false);
 		bio_put(bio);
 	}
+}
+
+static void __iomap_dio_bio_end_io(struct bio *bio, bool inline_completion)
+{
+	struct iomap_dio *dio = bio->bi_private;
+
+	iomap_dio_bio_release_pages(bio, dio->flags, !!dio->error);
 
 	/* Do not touch bio below, we just gave up our reference. */
 
-- 
2.39.5 (Apple Git-154)
