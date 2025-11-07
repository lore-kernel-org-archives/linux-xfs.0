Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1C62D9EF2
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 02:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762481236; cv=none; b=JPSLXanazYOew/7+uv24weaBeoEEwubYYeytfcCXmkW0n1BnpB2CerWREeu1bjnFGRmGyK33X2c2gcnIrGFZoGOWsfzfjQMBRelYlHITCqYhagpiYFK48yEuOtMYXcChRC2TIkNd8cJqfhz+CuFu8kCUT711sbgm/qDE3PyKVuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762481236; c=relaxed/simple;
	bh=lli0u4TsngLndxWtzp+3OjhbYuTLmWB5AKNTXIDei0c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WBHCpp5HG1ONhiQhfNMmKzbuWTonSjcIAIg2BnwiUA9pYnxUMv05phk4JbGdY1E6gtS2VEJSUIRhzGgfqwN6xXd/0J4K0DGqbC781PYgj0z78WySn7TAmzmZcbymIwxPEvHe5LVdpkdktNtJAj42QpWPsHkQM0G9Y4wzRAX/EKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=ZK+dqPBD; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ZK+dqPBD"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2953b321f99so2466565ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 06 Nov 2025 18:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1762481234; x=1763086034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOUCCDcR32WTLhwAJaOBtVC8wRTuafJBLOF7ysVPF/4=;
        b=ZK+dqPBDsOX76jp54dJVBVYt5whg6DQHhTju4LBQFrHFooAsi/5qpswY9NzUl3IIKg
         ORS23IsPYDfPoMC7wDtIBkJS2XCawXjd/rZDKBgTWRC8G/cII+mLw0p7ylEE4tmqFiUT
         KrwaN6/hJdr3CDMdjUhFm3ZOsK392ccAT8B/h7v3BNL1wtNd2gQQ9l5Q1aLisQBNBMHG
         qpikA3+ANgyNr287xBjO5oxPeWDat++Nu59Y6VrIqdoR1P6au2prEFiDxfP12Gqm0hyw
         2q/Y7nPm2u3DuuYWLtdiTOXdUykrMqaxzNm+nOBp5j51T+4HWwedUUu+bngkGJVm79YS
         4QNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762481234; x=1763086034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XOUCCDcR32WTLhwAJaOBtVC8wRTuafJBLOF7ysVPF/4=;
        b=av5Vl6FDySd4QEGhEepukNP9q1wpPwaeCph7bavbzYJCRDf7pKwu3493QDBx4fTbES
         NtnFM+nVivWm18X0X4buIvM9YmRptpFLrUCW08CeEhhBQFfIPpausg9A7TFYGhK9al5n
         yBXAnM6hIah1rVF+YOTkTiDwibWQK0yn2IJon5DyagAFO5WGGRxl2LyKp31q7qLH9eYz
         sXCFd4IicoFLsJOIqr4lSP78xcbLqs7GOxsXmv0eG4wKqnpRwE1GIUUl/QNQFBCUAOm2
         bSIBWKrF8LQnBwrPOgQCDR1gKD0UFp35hPlx0NdJoh5MXSdfYM2owzn1EQSMvxxVAsM7
         r2eA==
X-Forwarded-Encrypted: i=1; AJvYcCXegJFN6hLlU5kJbQE6ADJOI6Di7mjCCPSESkC9MQkUgycU7RwiKATfGzzNor/j76wzoySNS46BKsw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCFM387im6U58cYoaxh9zFDunm82DhLgZu/p8ZJrUK5/EG+E9Y
	65EKROrlwOW8C1/LwZpqFfNJrq6F8wiUcyyRKvtGCaNVMz1qvjLaDU0znt754jzF5Ds=
X-Gm-Gg: ASbGncvD7FzfgqZ5mwBD+tLcbQzOOIHJ5TiTRU9O0mOHup2NmrqxWRC7k6U4iznFy28
	tN6Hgbn1j8ZTk3Lqckgn0R2BwUgRsIv5N0nmHHlkkT8MfSF4b4l9U2B1Klbvp1LUPfd20sEGh5q
	IWiUhRRgSR33FXIIjFrfrWtzolyeyCGd6qFN06BAfgK0c2/5eL1C8+7V6DkTHfPhue+2qBvk1Lx
	V5LLw4Ai6GHfZLSAxhbme4OdcCYXwQoFN8n6MX0mb8wUGqxh2m01rVfGf9gSVtRKIN/AeZGWNk4
	jbvU92uzRSAhZUYD+z8ycD8T8uI3/wcPK26u+h92C03EIL32Qn7NNsylexHQwHUQugnElk/dXuY
	mQCAoG0aZ30Nme8zuq7ggwCLnmHHbMGVG8JZKV/tdpLRx1OkxiiBXi6dYa7QVpgsUd4T4vO26q2
	XQolh4svKBWyXSJyb3
X-Google-Smtp-Source: AGHT+IEJti4NiV6U2nPuxp72+m4/jnwAUg2/UAR4b5PLKU43+gH5PrMm/tm0Xa1G5TmaQR5rlzUdcA==
X-Received: by 2002:a17:903:2ac3:b0:290:94ed:184c with SMTP id d9443c01a7336-297c03d5580mr23239875ad.15.1762481234112;
        Thu, 06 Nov 2025 18:07:14 -0800 (PST)
Received: from localhost.localdomain ([2408:8740:c4ff:1::4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096825esm43129885ad.3.2025.11.06.18.07.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Nov 2025 18:07:13 -0800 (PST)
From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	asml.silence@gmail.com,
	willy@infradead.org,
	djwong@kernel.org,
	hch@infradead.org,
	ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	linux-nvme@lists.infradead.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH v2 1/2] block: use bio_alloc_bioset for passthru IO by default
Date: Fri,  7 Nov 2025 10:05:56 +0800
Message-Id: <20251107020557.10097-2-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20251107020557.10097-1-changfengnan@bytedance.com>
References: <20251107020557.10097-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use bio_alloc_bioset for passthru IO by default, so that we can enable
bio cache for irq and polled passthru IO in later.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 block/blk-map.c           | 89 +++++++++++++++------------------------
 drivers/nvme/host/ioctl.c |  2 +-
 2 files changed, 36 insertions(+), 55 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 60faf036fb6e..272a23d8ef8e 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -37,6 +37,25 @@ static struct bio_map_data *bio_alloc_map_data(struct iov_iter *data,
 	return bmd;
 }
 
+static inline void blk_mq_map_bio_put(struct bio *bio)
+{
+	bio_put(bio);
+}
+
+static struct bio *blk_rq_map_bio_alloc(struct request *rq,
+		unsigned int nr_vecs, gfp_t gfp_mask)
+{
+	struct block_device *bdev = rq->q->disk ? rq->q->disk->part0 : NULL;
+	struct bio *bio;
+
+	bio = bio_alloc_bioset(bdev, nr_vecs, rq->cmd_flags, gfp_mask,
+				&fs_bio_set);
+	if (!bio)
+		return NULL;
+
+	return bio;
+}
+
 /**
  * bio_copy_from_iter - copy all pages from iov_iter to bio
  * @bio: The &struct bio which describes the I/O as destination
@@ -154,10 +173,9 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 	nr_pages = bio_max_segs(DIV_ROUND_UP(offset + len, PAGE_SIZE));
 
 	ret = -ENOMEM;
-	bio = bio_kmalloc(nr_pages, gfp_mask);
+	bio = blk_rq_map_bio_alloc(rq, nr_pages, gfp_mask);
 	if (!bio)
 		goto out_bmd;
-	bio_init_inline(bio, NULL, nr_pages, req_op(rq));
 
 	if (map_data) {
 		nr_pages = 1U << map_data->page_order;
@@ -233,43 +251,12 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 cleanup:
 	if (!map_data)
 		bio_free_pages(bio);
-	bio_uninit(bio);
-	kfree(bio);
+	blk_mq_map_bio_put(bio);
 out_bmd:
 	kfree(bmd);
 	return ret;
 }
 
-static void blk_mq_map_bio_put(struct bio *bio)
-{
-	if (bio->bi_opf & REQ_ALLOC_CACHE) {
-		bio_put(bio);
-	} else {
-		bio_uninit(bio);
-		kfree(bio);
-	}
-}
-
-static struct bio *blk_rq_map_bio_alloc(struct request *rq,
-		unsigned int nr_vecs, gfp_t gfp_mask)
-{
-	struct block_device *bdev = rq->q->disk ? rq->q->disk->part0 : NULL;
-	struct bio *bio;
-
-	if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <= BIO_INLINE_VECS)) {
-		bio = bio_alloc_bioset(bdev, nr_vecs, rq->cmd_flags, gfp_mask,
-					&fs_bio_set);
-		if (!bio)
-			return NULL;
-	} else {
-		bio = bio_kmalloc(nr_vecs, gfp_mask);
-		if (!bio)
-			return NULL;
-		bio_init_inline(bio, bdev, nr_vecs, req_op(rq));
-	}
-	return bio;
-}
-
 static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 		gfp_t gfp_mask)
 {
@@ -318,25 +305,23 @@ static void bio_invalidate_vmalloc_pages(struct bio *bio)
 static void bio_map_kern_endio(struct bio *bio)
 {
 	bio_invalidate_vmalloc_pages(bio);
-	bio_uninit(bio);
-	kfree(bio);
+	blk_mq_map_bio_put(bio);
 }
 
-static struct bio *bio_map_kern(void *data, unsigned int len, enum req_op op,
+static struct bio *bio_map_kern(struct request *rq, void *data, unsigned int len,
 		gfp_t gfp_mask)
 {
 	unsigned int nr_vecs = bio_add_max_vecs(data, len);
 	struct bio *bio;
 
-	bio = bio_kmalloc(nr_vecs, gfp_mask);
+	bio = blk_rq_map_bio_alloc(rq, nr_vecs, gfp_mask);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
-	bio_init_inline(bio, NULL, nr_vecs, op);
+
 	if (is_vmalloc_addr(data)) {
 		bio->bi_private = data;
 		if (!bio_add_vmalloc(bio, data, len)) {
-			bio_uninit(bio);
-			kfree(bio);
+			blk_mq_map_bio_put(bio);
 			return ERR_PTR(-EINVAL);
 		}
 	} else {
@@ -349,8 +334,7 @@ static struct bio *bio_map_kern(void *data, unsigned int len, enum req_op op,
 static void bio_copy_kern_endio(struct bio *bio)
 {
 	bio_free_pages(bio);
-	bio_uninit(bio);
-	kfree(bio);
+	blk_mq_map_bio_put(bio);
 }
 
 static void bio_copy_kern_endio_read(struct bio *bio)
@@ -377,9 +361,10 @@ static void bio_copy_kern_endio_read(struct bio *bio)
  *	copy the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-static struct bio *bio_copy_kern(void *data, unsigned int len, enum req_op op,
+static struct bio *bio_copy_kern(struct request *rq, void *data, unsigned int len,
 		gfp_t gfp_mask)
 {
+	enum req_op op = req_op(rq);
 	unsigned long kaddr = (unsigned long)data;
 	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned long start = kaddr >> PAGE_SHIFT;
@@ -394,10 +379,9 @@ static struct bio *bio_copy_kern(void *data, unsigned int len, enum req_op op,
 		return ERR_PTR(-EINVAL);
 
 	nr_pages = end - start;
-	bio = bio_kmalloc(nr_pages, gfp_mask);
+	bio = blk_rq_map_bio_alloc(rq, nr_pages, gfp_mask);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
-	bio_init_inline(bio, NULL, nr_pages, op);
 
 	while (len) {
 		struct page *page;
@@ -431,8 +415,7 @@ static struct bio *bio_copy_kern(void *data, unsigned int len, enum req_op op,
 
 cleanup:
 	bio_free_pages(bio);
-	bio_uninit(bio);
-	kfree(bio);
+	blk_mq_map_bio_put(bio);
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -676,18 +659,16 @@ int blk_rq_map_kern(struct request *rq, void *kbuf, unsigned int len,
 		return -EINVAL;
 
 	if (!blk_rq_aligned(rq->q, addr, len) || object_is_on_stack(kbuf))
-		bio = bio_copy_kern(kbuf, len, req_op(rq), gfp_mask);
+		bio = bio_copy_kern(rq, kbuf, len, gfp_mask);
 	else
-		bio = bio_map_kern(kbuf, len, req_op(rq), gfp_mask);
+		bio = bio_map_kern(rq, kbuf, len, gfp_mask);
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
 	ret = blk_rq_append_bio(rq, bio);
-	if (unlikely(ret)) {
-		bio_uninit(bio);
-		kfree(bio);
-	}
+	if (unlikely(ret))
+		blk_mq_map_bio_put(bio);
 	return ret;
 }
 EXPORT_SYMBOL(blk_rq_map_kern);
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index c212fa952c0f..cd6bca8a5233 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -446,7 +446,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	struct iov_iter iter;
 	struct iov_iter *map_iter = NULL;
 	struct request *req;
-	blk_opf_t rq_flags = REQ_ALLOC_CACHE;
+	blk_opf_t rq_flags;
 	blk_mq_req_flags_t blk_flags = 0;
 	int ret;
 
-- 
2.39.5 (Apple Git-154)

