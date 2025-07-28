Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE0E1FF603
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734691; cv=none; b=ndk0FKyYZc6IvxwJTqt07ussf4tVpx2Ypjy7Z8Gs3a7L0x7b6MWgbWkMFh15h/XPnSO0AzhgG/EVUwny/PzI6w4moNXbgUa08MZ4q7sk/RB3EhBDA/E8k+dTRgiE4hAnhXVFEX1k9aY82ugoB+Hjn7BP7w9cHMAQ+WH7sn5o4BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734691; c=relaxed/simple;
	bh=PhEPzhB7szgX5HLGKnYEf7OLhRxK8c5h/JsVcG2QTZU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E7iR/qK2iUa50T62ansHDosbI0RhI5PRHWEwNLGRHyfEkJ6TF84O7zMugrXTHD9tbIuHi6JT1sp0KqQmvmidmqs91ESAVi0TW6LuhzfqhVuUk+w9NbcwZSEvLd7cGx8ny38EX3AZucHdI9tFslvl03uz0fIKkFfi/NMTtCMdegE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PUb4RpGa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PUb4RpGa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJCWHSnxlGASiesYuZTWLZoPwDwOTaS8I6htDF7wjk0=;
	b=PUb4RpGaDh4fLA8p4DpfaHGtBIesWnc6dMl60vPsvI9Y01gtPKA55vTPJqxW6qitneyyu3
	ec+V8J2IRfeNaBvhiSy8vzYdbnUis9MKlwyjCJQxJu22bQ5V3W5DFXj4Cx5NyWwzIq2NvA
	UWpXhwmU7+t2LG65elVMR0SmsnFrawQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-XgooFW9SOdiYhIvAS-2MHA-1; Mon, 28 Jul 2025 16:31:25 -0400
X-MC-Unique: XgooFW9SOdiYhIvAS-2MHA-1
X-Mimecast-MFC-AGG-ID: XgooFW9SOdiYhIvAS-2MHA_1753734684
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ae6d660902cso285424966b.2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734684; x=1754339484;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CJCWHSnxlGASiesYuZTWLZoPwDwOTaS8I6htDF7wjk0=;
        b=mYTNRbUGoIzESK0ZGYk5QpDv6h1HDejlyDv3a2REK7zO7uG/dNdZHWOIL7iT+fFeUO
         FN+L7pESkeHac3emcgty/YVm/4yMBdfx8WQnGY/LCNX0jXe2k4dMLKpGF944rG2meKUU
         7pYknZZXAerW4P9pttTyfkX+qupkgpwot8vjRPqf2DUueH5Vm/+jlQqjXXZXlsjf2uu0
         hEF6k2IPetJnClwR+zzOFIghSPdlrWs3m1JDCQx5McGWlSOBr3LrJeXiUUcFoduAqbql
         5wG8N6VZ8pxGGHmsg1bM5PZA/KJknkbbrNKSMZjL+el/6gVgdC6kiT2lJUezIt0PaTyg
         CBDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkMACz2iw4M6KMBZL3hmyQKuMt/MMlYfCTF8hAIp3+Nsz3gg+dRaI2WPpA0U/YVVF2mx8YlROaInY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrarh3FUxsx7ideUSpbIXKwBXl4xIeWRRJYzqSZyEWAKVd6dL9
	nPIp7ieGJ94zub2eIGFD1H/PQkNtdWRLk9baS/YazP2Lk3uug1n1DwjLcJdj7KCaG+ypFHPbchs
	rMQYMZjrFWATLVTs3s3xibL5AwQO9hkpoHHPHsqzT+9T3ZPM3kePv8GuzD+9/
X-Gm-Gg: ASbGncvVLDYYtBESQHbmfOdf3aEwqTreMO/qp1T5u1FH3M4jPogUfNKAdm/U5RAJW4h
	7JE+vTJHppsbMeYzWcRmUCvjAPYJ34uEv6H6tO/ezXcRV7f/YuKjpjCF+T+S0GtgXULaLz1pVJL
	Cad+OHMWv7pwVMdVkHo0nA48BlQ9yqayjhowWQhn5w3sHggKbOZYhjw6KCa0GZZjFEda4ZJRAvb
	HaggtrhX0MqH+/ECXqjo4yZR2H73ZDy/oIc1yEq2EP55Udt3y1YX8eTvzH651hzz4S2ayVUmoJf
	lUzjzMw1N0MLlp+vLrgerDIVxYWsgiy801rL2g+vWHej4w==
X-Received: by 2002:a17:907:3f16:b0:ad8:8efe:3205 with SMTP id a640c23a62f3a-af61d77d1f6mr1588592866b.55.1753734684293;
        Mon, 28 Jul 2025 13:31:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsytMrfT317PRPo3tW44DVon/D4aGNP+dT7JRWzWMn0A0ZzyLPnWESo3BFxaOmZLcjr28Lfw==
X-Received: by 2002:a17:907:3f16:b0:ad8:8efe:3205 with SMTP id a640c23a62f3a-af61d77d1f6mr1588589766b.55.1753734683871;
        Mon, 28 Jul 2025 13:31:23 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:22 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:06 +0200
Subject: [PATCH RFC 02/29] iomap: introduce iomap_read/write_region
 interface
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-2-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4401; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=povMPkss4mwLeT16OK6utnyhFPbNLh1N4mCgQwHPQJU=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvifvrXa2uiE5+tdGBs6hO1ru1atIHNVOV+wenu
 YaLa/Zvt+8oZWEQ42KQFVNkWSetNTWpSCr/iEGNPMwcViaQIQxcnAIwkd5NDP+TesxWMHxiux3o
 myTGWe225vlT6/B7v6IiRKMUQv3WT7/L8L/0LE/5nXWxIkv42HU/8N0p3iRutKa91fT0C49Ejx0
 6u1kBNjlEtw==
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

Interface for writing data beyond EOF into offsetted region in
page cache.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/iomap/buffered-io.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/iomap.h  | 16 ++++++++
 2 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 7bef232254a3..e959a206cba9 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -321,6 +321,7 @@ struct iomap_readpage_ctx {
 	bool			cur_folio_in_bio;
 	struct bio		*bio;
 	struct readahead_control *rac;
+	int			flags;
 };
 
 /**
@@ -387,7 +388,8 @@ static int iomap_readpage_iter(struct iomap_iter *iter,
 	if (plen == 0)
 		goto done;
 
-	if (iomap_block_needs_zeroing(iter, pos)) {
+	if (iomap_block_needs_zeroing(iter, pos) &&
+	    !(iomap->flags & IOMAP_F_BEYOND_EOF)) {
 		folio_zero_range(folio, poff, plen);
 		iomap_set_range_uptodate(folio, poff, plen);
 		goto done;
@@ -2007,3 +2009,98 @@ iomap_writepages_unbound(struct address_space *mapping, struct writeback_control
 	return iomap_submit_ioend(wpc, error);
 }
 EXPORT_SYMBOL_GPL(iomap_writepages_unbound);
+
+struct folio *
+iomap_read_region(struct ioregion *region)
+{
+	struct inode *inode = region->inode;
+	fgf_t fgp = FGP_CREAT | FGP_LOCK | fgf_set_order(region->length);
+	pgoff_t index = (region->pos) >> PAGE_SHIFT;
+	struct folio *folio = __filemap_get_folio(inode->i_mapping, index, fgp,
+				    mapping_gfp_mask(inode->i_mapping));
+	int ret;
+	struct iomap_iter iter = {
+		.inode		= folio->mapping->host,
+		.pos		= region->pos,
+		.len		= region->length,
+	};
+	struct iomap_readpage_ctx ctx = {
+		.cur_folio	= folio,
+	};
+
+	if (folio_test_uptodate(folio)) {
+		folio_unlock(folio);
+		return folio;
+	}
+
+	while ((ret = iomap_iter(&iter, region->ops)) > 0)
+		iter.status = iomap_read_folio_iter(&iter, &ctx);
+
+	if (ctx.bio) {
+		submit_bio(ctx.bio);
+		WARN_ON_ONCE(!ctx.cur_folio_in_bio);
+	} else {
+		WARN_ON_ONCE(ctx.cur_folio_in_bio);
+		folio_unlock(folio);
+	}
+
+	return folio;
+}
+EXPORT_SYMBOL_GPL(iomap_read_region);
+
+static int iomap_write_region_iter(struct iomap_iter *iter, const void *buf)
+{
+	loff_t pos = iter->pos;
+	u64 bytes = iomap_length(iter);
+	int status;
+
+	do {
+		struct folio *folio;
+		size_t offset;
+		bool ret;
+
+		bytes = min_t(u64, SIZE_MAX, bytes);
+		status = iomap_write_begin(iter, &folio, &offset, &bytes);
+		if (status)
+			return status;
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
+
+		offset = offset_in_folio(folio, pos);
+		if (bytes > folio_size(folio) - offset)
+			bytes = folio_size(folio) - offset;
+
+		memcpy_to_folio(folio, offset, buf, bytes);
+
+		ret = iomap_write_end(iter, bytes, bytes, folio);
+		if (WARN_ON_ONCE(!ret))
+			return -EIO;
+
+		__iomap_put_folio(iter, bytes, folio);
+		if (WARN_ON_ONCE(!ret))
+			return -EIO;
+
+		status = iomap_iter_advance(iter, &bytes);
+		if (status)
+			break;
+	} while (bytes > 0);
+
+	return status;
+}
+
+int
+iomap_write_region(struct ioregion *region)
+{
+	struct iomap_iter iter = {
+		.inode		= region->inode,
+		.pos		= region->pos,
+		.len		= region->length,
+	};
+	ssize_t ret;
+
+	while ((ret = iomap_iter(&iter, region->ops)) > 0)
+		iter.status = iomap_write_region_iter(&iter, region->buf);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iomap_write_region);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 4a0b5ebb79e9..73288f28543f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -83,6 +83,11 @@ struct vm_fault;
  */
 #define IOMAP_F_PRIVATE		(1U << 12)
 
+/*
+ * Writes happens beyound inode EOF
+ */
+#define IOMAP_F_BEYOND_EOF	(1U << 13)
+
 /*
  * Flags set by the core iomap code during operations:
  *
@@ -533,4 +538,15 @@ int iomap_swapfile_activate(struct swap_info_struct *sis,
 
 extern struct bio_set iomap_ioend_bioset;
 
+struct ioregion {
+	struct inode *inode;
+	loff_t pos;				/* IO position */
+	const void *buf;			/* Data to be written (in only) */
+	size_t length;				/* Length of the date */
+	const struct iomap_ops *ops;
+};
+
+struct folio *iomap_read_region(struct ioregion *region);
+int iomap_write_region(struct ioregion *region);
+
 #endif /* LINUX_IOMAP_H */

-- 
2.50.0

