Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1130B15820C
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479537; cv=none; b=NPFPykSR5R1lzk9LfXXVmE3hx6o8XjFz6Jevseq+3oV70RCsNKuvVoGmJR5uzK3Ln+wRDevqEggnG466dLYPXUydaUxVTJKBouxYLCoc+QlDoUUxfNQ5N+vHwtO5AaXKLWLTXJvcF/UJfNynoDn3SxdJPYXDm3n/k/bzMoPOrvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479537; c=relaxed/simple;
	bh=tgU6IAOsE2grady0FRgR/Vk19r/ZJ9XttjxbfOcwPv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lT7wxjGDs+LqgAVSWu/7lNFvaW/uAG7zcOY95hHshxSiokUD4DDeOfKeG1tcOSvJu85ecsvjfvaozaiRcF+mI9zO4BNPSjmxF2mmXrNLC70wuzaF6+YNhgEVxizyLDdSN7FiSE5o/woFGhK4HYuPlIrW669btVbEIvTeCj8qCZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vd9DsEvQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vd9DsEvQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9tm77WUuBRFcTEQqs42woSPBEv4TWV3Fg/m6UO05FCU=;
	b=Vd9DsEvQgutGQteDNSnju3SN4H7vqBV3t5KAzB+F2fbBVUuG1ZVLVxjgTrvfQnmtEebDaz
	bmQjSkq6CkS//17ooYlL1NkNDSk1hac/qpm6Q0YDCbQwYyX8FrwB7P/qN5qfxdpACYSHXc
	pkZeukkx77LIou7RLDhR04ckycDPFKo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-bGYN72OqMyS0qJtolC-muw-1; Sun, 29 Dec 2024 08:38:53 -0500
X-MC-Unique: bGYN72OqMyS0qJtolC-muw-1
X-Mimecast-MFC-AGG-ID: bGYN72OqMyS0qJtolC-muw
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43628594d34so10048035e9.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:38:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479532; x=1736084332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9tm77WUuBRFcTEQqs42woSPBEv4TWV3Fg/m6UO05FCU=;
        b=aqEfMY+R82RP4dLvC2UyXMJMMHH4RS/S8e1oK7wHw8CtRKIsKHM1l/pw3U1+1OGTSO
         7B4k4sGaekxuk632zO4JTDR3+vE8s3eZMr2AerjlI8wJjy/yw1lkaIy4ZhcqgmI2zJYb
         hilUzgZ0BU8tgHsU9mxTuiKl+IGpYw8h6uQBnDGWkrPSHNQdDlpfkbGVOZGdLwCz0B5G
         q8KQCKD5njLDlE60AuMi3xUGzgDita848S+8aggQOihJ9nVOc2cVbrn4NEAQ3F4vivTd
         R1CUSFcpXmwU0TRj0fUJ6Dlb8yzkrVj2uWzoYC4h+UHAcTVEpc6wx61x6KuHoFmiy9dP
         oByQ==
X-Gm-Message-State: AOJu0YxIOdpl6Cl8Q9Dyk5JC+vpxSA3KgLzcawNCFqFpmtc9MH8TIs+9
	N7XVACYkNf9zzci5UyHZysd393Y3Tk5iPNtNnhiaEWKvQdKQDrXZdOjCfWoguc2qiWOkum1zZpR
	G5eE+sUY1CzVJSwwgaksGHHTwyVT0mVQf4M3E3R3PKcOX2fu81NJY5IGjMUZ7UYkiZgeISXxmk0
	E5u37/KMCy9qiJvm1fxiKgjz3Xtt1z1YhMQW1GO194
X-Gm-Gg: ASbGncteRWQ8iArRy2yIScCL4W0/zynmpTQ3eDnnQXJPmJUVrJMXdaShxRl1abDSsTy
	+2rKpEAlRWr5E2KfDAwxflEVhc9be9K1GgJjPB/wTiXHA4FnNDc8/kiRPTZPJqN/64DqCfwfnYw
	xwIASGG/Y3PRMgAqIEezcy3cVLbwAS1Uy7HYeNAZAZfhNmxuINu4j+2VXPRO/LycNipQY1MPWLz
	nObwx1diFKM+3UNrcaoarb6WdbBYXhVCKR3a5Q9dElyZSIMpv15fKmqyGS+8JT09ndxJXziArph
	FGM8GinBuCv6pQo=
X-Received: by 2002:a05:600c:350c:b0:434:fdaf:af2d with SMTP id 5b1f17b1804b1-43668b7850emr285632275e9.30.1735479531839;
        Sun, 29 Dec 2024 05:38:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGGqpDcZjNVnlNEs9PXqbwn99rIC/70CE8FQwCSVGMYtS+kEK0U9GbyExlQDK/vP6Zm4GVD3A==
X-Received: by 2002:a05:600c:350c:b0:434:fdaf:af2d with SMTP id 5b1f17b1804b1-43668b7850emr285632105e9.30.1735479531435;
        Sun, 29 Dec 2024 05:38:51 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:38:50 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 02/14] iomap: add read path ioends for filesystem read verification
Date: Sun, 29 Dec 2024 14:38:24 +0100
Message-ID: <20241229133836.1194272-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133836.1194272-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133836.1194272-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@redhat.com>

Add iomap_readpage_ops with only optional ->prepare_ioend() to allow
filesystem to add callout used for configuring read path ioend.
Mainly for setting ->bi_end_io() callout.

Make iomap_read_end_io() exportable, so, it can be called back from
filesystem callout after verification is done.

The read path ioend are stored side by side with BIOs allocated from
iomap_read_ioend_bioset.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/iomap/buffered-io.c | 31 ++++++++++++++++++++++++++-----
 include/linux/iomap.h  | 20 ++++++++++++++++++++
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0d9291719d75..93da48ec5801 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -41,6 +41,7 @@ struct iomap_folio_state {
 };
 
 static struct bio_set iomap_ioend_bioset;
+static struct bio_set iomap_read_ioend_bioset;
 
 static inline bool ifs_is_fully_uptodate(struct folio *folio,
 		struct iomap_folio_state *ifs)
@@ -310,7 +311,7 @@ static void iomap_finish_folio_read(struct folio *folio, size_t off,
 		folio_end_read(folio, uptodate);
 }
 
-static void iomap_read_end_io(struct bio *bio)
+void iomap_read_end_io(struct bio *bio)
 {
 	int error = blk_status_to_errno(bio->bi_status);
 	struct folio_iter fi;
@@ -319,6 +320,7 @@ static void iomap_read_end_io(struct bio *bio)
 		iomap_finish_folio_read(fi.folio, fi.offset, fi.length, error);
 	bio_put(bio);
 }
+EXPORT_SYMBOL_GPL(iomap_read_end_io);
 
 /**
  * iomap_read_inline_data - copy inline data into the page cache
@@ -371,6 +373,8 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 	loff_t orig_pos = pos;
 	size_t poff, plen;
 	sector_t sector;
+	struct iomap_read_ioend *ioend;
+	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 
 	if (iomap->type == IOMAP_INLINE)
 		return iomap_read_inline_data(iter, folio);
@@ -407,21 +411,29 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
-		ctx->bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs),
-				     REQ_OP_READ, gfp);
+		ctx->bio = bio_alloc_bioset(iomap->bdev, bio_max_segs(nr_vecs),
+				REQ_OP_READ, gfp, &iomap_read_ioend_bioset);
 		/*
 		 * If the bio_alloc fails, try it again for a single page to
 		 * avoid having to deal with partial page reads.  This emulates
 		 * what do_mpage_read_folio does.
 		 */
 		if (!ctx->bio) {
-			ctx->bio = bio_alloc(iomap->bdev, 1, REQ_OP_READ,
-					     orig_gfp);
+			ctx->bio = bio_alloc_bioset(iomap->bdev, 1,
+				REQ_OP_READ, orig_gfp, &iomap_read_ioend_bioset);
 		}
 		if (ctx->rac)
 			ctx->bio->bi_opf |= REQ_RAHEAD;
 		ctx->bio->bi_iter.bi_sector = sector;
 		ctx->bio->bi_end_io = iomap_read_end_io;
+		ioend = container_of(ctx->bio, struct iomap_read_ioend,
+				io_bio);
+		ioend->io_inode = iter->inode;
+		ioend->io_flags	= srcmap->flags;
+		ioend->io_offset = poff;
+		ioend->io_size = plen;
+		if (ctx->ops && ctx->ops->prepare_ioend)
+			ctx->ops->prepare_ioend(ioend);
 		bio_add_folio_nofail(ctx->bio, folio, plen, poff);
 	}
 
@@ -2157,6 +2169,15 @@ EXPORT_SYMBOL_GPL(iomap_write_region);
 
 static int __init iomap_buffered_init(void)
 {
+	int error = 0;
+
+	error = bioset_init(&iomap_read_ioend_bioset,
+			   4 * (PAGE_SIZE / SECTOR_SIZE),
+			   offsetof(struct iomap_read_ioend, io_bio),
+			   BIOSET_NEED_BVECS);
+	if (error)
+		return error;
+
 	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
 			   offsetof(struct iomap_ioend, io_bio),
 			   BIOSET_NEED_BVECS);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index b5ae08955c87..f089969e4716 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -296,14 +296,34 @@ static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
 		iter->srcmap.type == IOMAP_MAPPED;
 }
 
+struct iomap_read_ioend {
+	struct inode		*io_inode;	/* file being read from */
+	u16			io_flags;	/* IOMAP_F_* */
+	size_t			io_size;	/* size of the extent */
+	loff_t			io_offset;	/* offset in the file */
+	struct work_struct	io_work;	/* post read work (e.g. fs-verity) */
+	struct bio		io_bio;		/* MUST BE LAST! */
+};
+
+struct iomap_readpage_ops {
+	/*
+	 * Optional, allows the file systems to perform actions just before
+	 * submitting the bio and/or override the bio bi_end_io handler for
+	 * additional verification after bio is processed
+	 */
+	void (*prepare_ioend)(struct iomap_read_ioend *ioend);
+};
+
 struct iomap_readpage_ctx {
 	struct folio			*cur_folio;
 	bool				cur_folio_in_bio;
 	struct bio			*bio;
 	struct readahead_control	*rac;
 	int				flags;
+	const struct iomap_readpage_ops	*ops;
 };
 
+void iomap_read_end_io(struct bio *bio);
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops, void *private);
 int iomap_read_folio_ctx(struct iomap_readpage_ctx *ctx,
-- 
2.47.0

