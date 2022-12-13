Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172E7C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 17:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbiLMRb5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236353AbiLMRas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 12:30:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908EF23394
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670952590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hsBd8ArpKwpbm0RyMTCOHVrg4CJrwS1iGz8TYLb3WGg=;
        b=eSdGuVPudibN4ZdPhmTINkL/Ei0NhU+Htm4a8xR8Cba5V0N+g+zoRoKS7FB6EY8KGPkHmC
        vUgvwYEBaN6/qKmpf59udBuf7Fd5LcEOjxA9bziWE6709vEpR9JUv8KTqXt0h8cE+H+nKQ
        4rqd5eayMRhidsvOByKgHaYZ6zBpLII=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-90-pZNAlk4cO36Z_wPMYD8JTA-1; Tue, 13 Dec 2022 12:29:49 -0500
X-MC-Unique: pZNAlk4cO36Z_wPMYD8JTA-1
Received: by mail-ej1-f71.google.com with SMTP id xc12-20020a170907074c00b007416699ea14so9693631ejb.19
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 09:29:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsBd8ArpKwpbm0RyMTCOHVrg4CJrwS1iGz8TYLb3WGg=;
        b=W4WtmW/QQTDedk+tEUvrF/abjubHdKUwEo9APQe0WLy10yPv5J8XuXcQMzXyBfL1Ox
         4szqJo8QUWNgS/WyS2XzKoJg+/N4pm4s+ygPGqs4EVVMiPHjCjVkzPDxf+zkr6JwnzoQ
         6JBSriTQZkU88RSeFIDE9uzxgUyJqFHmHUi1I6qKX8+ujieYDQwDDiqi6cfXhHpb254H
         LUVSBvSI01Bps4fl2GvGg0wILERhHcMlaYOnXq4m1sk0khE5laS7E3IQQ1KwlCsMQuWa
         H7Gs1pVMeu0w7+8HPv5ew1i4noQvQU0U98pjIuE18fT+0vXswTN732qctMKDKVuQmppu
         Wtuw==
X-Gm-Message-State: ANoB5pk5mIPA4Og9oHg2cgEaIWRK4qMJxnlHsOIUyyFFymzr7/MXj/BF
        C0arerWTUNH6q4gMpZgbunajMx5efiAhIpDmWySIVrjCvgja25wyiUMFSbckeXE2XIrA0eawLyF
        xuzCDzSpcXm5jpjPG5BsA2dXYKjfVia4FulI+ZRuTGZaMifsNSGVMk+PNOkS8cZg/r8QECV8=
X-Received: by 2002:a05:6402:1947:b0:462:7b9a:686f with SMTP id f7-20020a056402194700b004627b9a686fmr16937287edz.4.1670952587730;
        Tue, 13 Dec 2022 09:29:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5/nzk/5ko7ikx1EaJwRFAERJfYlAqOuXuVinbYx0ZIZjaFcSJ2Xf6NmzqQahi9qwhjZixOoQ==
X-Received: by 2002:a05:6402:1947:b0:462:7b9a:686f with SMTP id f7-20020a056402194700b004627b9a686fmr16937270edz.4.1670952587473;
        Tue, 13 Dec 2022 09:29:47 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id ec14-20020a0564020d4e00b0047025bf942bsm1204187edb.16.2022.12.13.09.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:29:47 -0800 (PST)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>
Subject: [RFC PATCH 09/11] iomap: fs-verity verification on page read
Date:   Tue, 13 Dec 2022 18:29:33 +0100
Message-Id: <20221213172935.680971-10-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213172935.680971-1-aalbersh@redhat.com>
References: <20221213172935.680971-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add fs-verity page verification in read IO path. The verification
itself is offloaded into workqueue (provided by fs-verity).

The work_struct items are allocated from bioset side by side with
bio being processed.

As inodes with fs-verity doesn't use large folios we check only
first page of the folio for errors (set by fs-verity if verification
failed).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/iomap/buffered-io.c | 80 +++++++++++++++++++++++++++++++++++++++---
 include/linux/iomap.h  |  5 +++
 2 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 91ee0b308e13d..b7abc2f806cfc 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -17,6 +17,7 @@
 #include <linux/bio.h>
 #include <linux/sched/signal.h>
 #include <linux/migrate.h>
+#include <linux/fsverity.h>
 #include "trace.h"
 
 #include "../internal.h"
@@ -42,6 +43,7 @@ static inline struct iomap_page *to_iomap_page(struct folio *folio)
 }
 
 static struct bio_set iomap_ioend_bioset;
+static struct bio_set iomap_readend_bioset;
 
 static struct iomap_page *
 iomap_page_create(struct inode *inode, struct folio *folio, unsigned int flags)
@@ -189,9 +191,39 @@ static void iomap_read_end_io(struct bio *bio)
 	int error = blk_status_to_errno(bio->bi_status);
 	struct folio_iter fi;
 
-	bio_for_each_folio_all(fi, bio)
+	bio_for_each_folio_all(fi, bio) {
+		/*
+		 * As fs-verity doesn't work with multi-page folios, verity
+		 * inodes have large folios disabled (only single page folios
+		 * are used)
+		 */
+		if (!error)
+			error = PageError(folio_page(fi.folio, 0));
+
 		iomap_finish_folio_read(fi.folio, fi.offset, fi.length, error);
+	}
+
 	bio_put(bio);
+	/* The iomap_readend has been freed by bio_put() */
+}
+
+static void iomap_read_work_end_io(
+	struct work_struct *work)
+{
+	struct iomap_readend *ctx =
+		container_of(work, struct iomap_readend, read_work);
+	struct bio *bio = &ctx->read_inline_bio;
+
+	fsverity_verify_bio(bio);
+	iomap_read_end_io(bio);
+}
+
+static void iomap_read_work_io(struct bio *bio)
+{
+	struct iomap_readend *ctx =
+		container_of(bio, struct iomap_readend, read_inline_bio);
+
+	fsverity_enqueue_verify_work(&ctx->read_work);
 }
 
 struct iomap_readpage_ctx {
@@ -264,6 +296,7 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 	loff_t orig_pos = pos;
 	size_t poff, plen;
 	sector_t sector;
+	struct iomap_readend *readend;
 
 	if (iomap->type == IOMAP_INLINE)
 		return iomap_read_inline_data(iter, folio);
@@ -276,7 +309,21 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 
 	if (iomap_block_needs_zeroing(iter, pos)) {
 		folio_zero_range(folio, poff, plen);
-		iomap_set_range_uptodate(folio, iop, poff, plen);
+		if (!fsverity_active(iter->inode)) {
+			iomap_set_range_uptodate(folio, iop, poff, plen);
+			goto done;
+		}
+
+		/*
+		 * As fs-verity doesn't work with folios sealed inodes have
+		 * multi-page folios disabled and we can check on first and only
+		 * page
+		 */
+		if (fsverity_verify_page(folio_page(folio, 0)))
+			iomap_set_range_uptodate(folio, iop, poff, plen);
+		else
+			folio_set_error(folio);
+
 		goto done;
 	}
 
@@ -297,8 +344,18 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
-		ctx->bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs),
+		if (fsverity_active(iter->inode)) {
+			ctx->bio = bio_alloc_bioset(iomap->bdev,
+					bio_max_segs(nr_vecs), REQ_OP_READ,
+					GFP_NOFS, &iomap_readend_bioset);
+			readend = container_of(ctx->bio,
+					struct iomap_readend,
+					read_inline_bio);
+			INIT_WORK(&readend->read_work, iomap_read_work_end_io);
+		} else {
+			ctx->bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs),
 				     REQ_OP_READ, gfp);
+		}
 		/*
 		 * If the bio_alloc fails, try it again for a single page to
 		 * avoid having to deal with partial page reads.  This emulates
@@ -311,7 +368,11 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 		if (ctx->rac)
 			ctx->bio->bi_opf |= REQ_RAHEAD;
 		ctx->bio->bi_iter.bi_sector = sector;
-		ctx->bio->bi_end_io = iomap_read_end_io;
+		if (fsverity_active(iter->inode))
+			ctx->bio->bi_end_io = iomap_read_work_io;
+		else
+			ctx->bio->bi_end_io = iomap_read_end_io;
+
 		bio_add_folio(ctx->bio, folio, plen, poff);
 	}
 
@@ -1546,6 +1607,17 @@ EXPORT_SYMBOL_GPL(iomap_writepages);
 
 static int __init iomap_init(void)
 {
+#ifdef CONFIG_FS_VERITY
+	int error = 0;
+
+	error = bioset_init(&iomap_readend_bioset,
+			   4 * (PAGE_SIZE / SECTOR_SIZE),
+			   offsetof(struct iomap_readend, read_inline_bio),
+			   BIOSET_NEED_BVECS);
+	if (error)
+		return error;
+#endif
+
 	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
 			   offsetof(struct iomap_ioend, io_inline_bio),
 			   BIOSET_NEED_BVECS);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 238a03087e17e..dbdef159b20d7 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -264,6 +264,11 @@ struct iomap_ioend {
 	struct bio		io_inline_bio;	/* MUST BE LAST! */
 };
 
+struct iomap_readend {
+	struct work_struct	read_work;	/* post read work (fs-verity) */
+	struct bio		read_inline_bio;/* MUST BE LAST! */
+};
+
 struct iomap_writeback_ops {
 	/*
 	 * Required, maps the blocks so that writeback can be performed on
-- 
2.31.1

