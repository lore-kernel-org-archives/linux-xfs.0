Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AABB158858
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479430; cv=none; b=WvdSIxcX3jRNm2nxUUmdWFjHPTaqcBCiwJl8hPXN+eLG9OH0VTrmEMVowY6j1PLsibur06TRDvZm8ywvr++Z3ligNV4bMuqHLWsSvMyNYzeBssX5jYp64D2nK62uMD6Qo2KqHbz26YOgR0VRyHiJdlSlWoYqRkg42We0sLDrfBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479430; c=relaxed/simple;
	bh=R2RwdLTSYPE9pmyXGXnXGfCyAtfZa7isu69ljMNwZ9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeerZEM2GihmurzDBscVk6drDG2YzjS+MrDGpDW9IQWQr3Bf332Iif4yDjn7krcJILJIrVaOXlm4xOminrlh25j0zJ061gz1mPXeG+SJY35MXKCePpaNfA63yGGQ3bOpAZjVbTfkP4HHZ1lTUSj78CV3wLvvOhUZY5imBSYbIGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e2XXmXHi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e2XXmXHi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0c9Lpd0KWjnczMEitX9P0qn3rosZAzNZ2jkFo4S//Bc=;
	b=e2XXmXHiPz7g3gZDADAT3T+UfCVNkeQwjhAhcogVovS1e0nF/ag/EWsKwCQhsYg44RjiR1
	ePC49ddc0TlgKRklf5WiJDIazfNnWiKMEv5Ffq+82ycKKG6ewi6T5hQxs8BauMQkOqamK4
	HVNINPcFoeO5YDRXfzmlAX95IwEIOUM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-kBqYhS6zPuewLXOWtIzkAw-1; Sun, 29 Dec 2024 08:37:06 -0500
X-MC-Unique: kBqYhS6zPuewLXOWtIzkAw-1
X-Mimecast-MFC-AGG-ID: kBqYhS6zPuewLXOWtIzkAw
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5d43ec75bc4so7479932a12.2
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:37:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479425; x=1736084225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0c9Lpd0KWjnczMEitX9P0qn3rosZAzNZ2jkFo4S//Bc=;
        b=wcOM1H3mXUmdkJU/m7UN1T6l/AGfiM1R7DjlqL/rmb2bl8Ly/n2x8IVKgM5l1TgPSB
         Wxnd4D4q0zeiS+j7cVEFC/jP5wATf47mcW4qKYhmCgwgUb2kVPupGaQvUv/tLix+ieeV
         tzUbbC6uvcPp6AbC0GtlheUMAMBzqMBEg5TQER3ARaew3jk+VPWQVnLwgn8DL5Uik/9q
         iWZbStUaA4lNBijRQjGzqhpN/Oo5meg7oLELK3Pu/VD93Xe9Pff8FtiuXk92sRO3zu91
         wwKSwHRMIJIiKIqO3Fyra1xLqoK6oq/ucsm2mKAR1E5udrQ7+IBY54RRtIJdQcqyteeV
         7ldg==
X-Gm-Message-State: AOJu0Yzo2+Z6zDYzQnVZu2HlxiwUzVPP9Cbz3ZFd+Ft819iuwKQJf03N
	KMRPWzbSuav34akMahIgZ8VyfHOjR2sqtawtJeenCSWvfN+IveUiIFxoppHhxMLokhJata5bV4a
	uk9MVrYB5GPtQvyxcCC5LW8oIYFQdG/c3F2lo4Gzxbc9AbuKdNeVJvu94a2bpKemm9ODsQbZEfk
	saXfwu5N60qyazHW+GKwiQuRLk+6RtrKorTLldmllc
X-Gm-Gg: ASbGnctYqYrNLOyWssTMl9mfbCcJzdsW3LsFxv+o5fchKeio/Ne88e4DkkAv6F7bQIW
	5/2ptxfuSA+KYmi5S5yn5vhtWVmtanBQLxVWzuGtd6EYL3CfJpyZ7+sszyt1aiqvrel2PvJHXLy
	lXaIufBlFPgeozaipbHolmG5SfWjjzcXJSabq44TbG1pPMYClS+cO6gPIsRA8XnPIXwB2104oK4
	1znjFyb7kBRt5JI54BhDxF1SvqW/mHU7FR/StE/3h9vhGwOSkHXTIv/fF5lUFPdvaL5AOJUyuT4
	BPm4gVqV4GDeI88=
X-Received: by 2002:a05:6402:34ca:b0:5d2:d72a:77e4 with SMTP id 4fb4d7f45d1cf-5d81de38bd2mr33832725a12.28.1735479424787;
        Sun, 29 Dec 2024 05:37:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFqxI6D37+5zTM3OgEqVfoN/RjdMu3BnRA597lL7ywDMnNA0Yw4l+Rj3G7wC2CaJD7leuPOrw==
X-Received: by 2002:a05:6402:34ca:b0:5d2:d72a:77e4 with SMTP id 4fb4d7f45d1cf-5d81de38bd2mr33832686a12.28.1735479424296;
        Sun, 29 Dec 2024 05:37:04 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d806fedbc5sm13839735a12.60.2024.12.29.05.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:37:03 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 2/2] iomap: introduce iomap_read/write_region interface
Date: Sun, 29 Dec 2024 14:36:40 +0100
Message-ID: <20241229133640.1193578-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133640.1193578-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133640.1193578-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@redhat.com>

Interface for writing pages beyond EOF into offsetted region in
page cache.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/iomap/buffered-io.c | 103 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/iomap.h  |  13 ++++++
 2 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 61ec924c5b80..0f33ac975209 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -325,6 +325,7 @@ struct iomap_readpage_ctx {
 	bool			cur_folio_in_bio;
 	struct bio		*bio;
 	struct readahead_control *rac;
+	int			flags;
 };
 
 /**
@@ -363,7 +364,8 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
 
 	return srcmap->type != IOMAP_MAPPED ||
 		(srcmap->flags & IOMAP_F_NEW) ||
-		pos >= i_size_read(iter->inode);
+		(pos >= i_size_read(iter->inode) &&
+		 !(srcmap->flags & IOMAP_F_BEYOND_EOF));
 }
 
 static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
@@ -2044,6 +2046,105 @@ iomap_writepages_unbound(struct address_space *mapping, struct writeback_control
 }
 EXPORT_SYMBOL_GPL(iomap_writepages_unbound);
 
+struct folio *
+iomap_read_region(struct ioregion *region)
+{
+	struct inode *inode = region->inode;
+	fgf_t fgp = FGP_CREAT | FGP_LOCK | fgf_set_order(region->length);
+	pgoff_t index = (region->pos | region->offset) >> PAGE_SHIFT;
+	struct folio *folio = __filemap_get_folio(inode->i_mapping, index, fgp,
+				    mapping_gfp_mask(inode->i_mapping));
+	struct iomap_readpage_ctx ctx = {
+		.cur_folio = folio,
+	};
+	struct iomap_iter iter = {
+		.inode = inode,
+		.pos = folio_pos(folio),
+		.len = folio_size(folio),
+	};
+	int ret;
+
+	if (folio_test_uptodate(folio)) {
+		folio_unlock(folio);
+		return folio;
+	}
+
+	while ((ret = iomap_iter(&iter, region->ops)) > 0)
+		iter.processed = iomap_readpage_iter(&iter, &ctx, 0);
+
+	if (ret < 0) {
+		folio_unlock(folio);
+		return ERR_PTR(ret);
+	}
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
+static loff_t iomap_write_region_iter(struct iomap_iter *iter, const void *buf)
+{
+	loff_t pos = iter->pos;
+	loff_t length = iomap_length(iter);
+	loff_t written = 0;
+
+	do {
+		struct folio *folio;
+		int status;
+		size_t offset;
+		size_t bytes = min_t(u64, SIZE_MAX, length);
+		bool ret;
+
+		status = iomap_write_begin(iter, pos, bytes, &folio);
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
+		ret = iomap_write_end(iter, pos, bytes, bytes, folio);
+		if (WARN_ON_ONCE(!ret))
+			return -EIO;
+
+		__iomap_put_folio(iter, pos, written, folio);
+
+		pos += bytes;
+		length -= bytes;
+		written += bytes;
+	} while (length > 0);
+
+	return written;
+}
+
+int
+iomap_write_region(struct ioregion *region)
+{
+	struct iomap_iter iter = {
+		.inode		= region->inode,
+		.pos		= region->pos | region->offset,
+		.len		= region->length,
+	};
+	ssize_t ret;
+
+	while ((ret = iomap_iter(&iter, region->ops)) > 0)
+		iter.processed = iomap_write_region_iter(&iter, region->buf);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iomap_write_region);
+
 static int __init iomap_buffered_init(void)
 {
 	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3bfd3035ac28..3297ed36c26b 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -68,6 +68,7 @@ struct vm_fault;
 #endif /* CONFIG_BUFFER_HEAD */
 #define IOMAP_F_XATTR		(1U << 5)
 #define IOMAP_F_BOUNDARY	(1U << 6)
+#define IOMAP_F_BEYOND_EOF	(1U << 7)
 
 /*
  * Flags set by the core iomap code during operations:
@@ -458,4 +459,16 @@ int iomap_swapfile_activate(struct swap_info_struct *sis,
 # define iomap_swapfile_activate(sis, swapfile, pagespan, ops)	(-EIO)
 #endif /* CONFIG_SWAP */
 
+struct ioregion {
+	struct inode *inode;
+	loff_t pos;				/* IO position */
+	const void *buf;			/* Data to be written (in only) */
+	size_t length;				/* Length of the date */
+	loff_t offset;				/* Region offset in the cache */
+	const struct iomap_ops *ops;
+};
+
+struct folio *iomap_read_region(struct ioregion *region);
+int iomap_write_region(struct ioregion *region);
+
 #endif /* LINUX_IOMAP_H */
-- 
2.47.0

