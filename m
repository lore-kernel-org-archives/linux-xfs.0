Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65181CF96
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479428; cv=none; b=gTVcskjfpkWLKXjIOGJpoy4nfi+YH7w9rQy5uUHPJa8sOj+yXZfucLRQvVYnFjDlsQ4V+EWCTkNZgHqwZeEavwvJU+C+RkBY4ye34+qNAbJAcipJRcPNLchKJSitwH7WqznisZE5770PmPUGmEf7p+4SXDNWLBllJK6/NMPYMEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479428; c=relaxed/simple;
	bh=a6fNItMdFkwF6ghWVHy1gN2uZfNcwDIY+03GDKkZraA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhxsYEq/nb2qzZKb/PMbPn26PA8kNTgbOG8OXxf2rdW+dMC8xXuazCQG4OrV/gjbdywNnTvYLIapDCq88LWkuuQ4WT4f4WLYwbQgFDdN9DPefr1XVGgerQ5ro6ilm8puoQv7WtoFdYIDkzCtaBLVrBJUMrKEXdz7LnnjnpmcQI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U37xPLNn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U37xPLNn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hvQt9NMK/dT8IXcOD+VUAhiAdCjhol/sYyPKL8rYUio=;
	b=U37xPLNnbvNl+fswMfkq9SG9dVEE+tYHMIPxmuYp2nRy7NAyjOH7uXRkK5/K3zPNYcHQoX
	qSTtBx0eVpQdbrlWCpXsfdRwZGrY0FkdLgosB88QwRGP0+XTaiAkzT6lAxPc/aDmpVePi/
	vZp2jNk0sBl1eTrDJcFJILHb+AujPIM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-8FKTQYDCPJiCvSzOAkqkWA-1; Sun, 29 Dec 2024 08:37:04 -0500
X-MC-Unique: 8FKTQYDCPJiCvSzOAkqkWA-1
X-Mimecast-MFC-AGG-ID: 8FKTQYDCPJiCvSzOAkqkWA
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aa6a6dcf9a3so634301666b.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:37:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479422; x=1736084222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvQt9NMK/dT8IXcOD+VUAhiAdCjhol/sYyPKL8rYUio=;
        b=EYsxTBJ+KINGbCHA7yNkILwVcnqFhPJZupBMUDsu1rYQKH5bLqe1GbS2Wd51FJcbsp
         ymm5QVf6b1jYo6BPYFShl1byScPhq3DR7WhHmvTU/ayWsJ8EEpPJ/OXN7je8Z3YUW2w5
         1UZcCvju1tP/30QyAlnt7VHvLfdO1Te+tcDuX0b8+TiLK505a2Tvtgykv/tbBe21hF66
         RgP9hHlGsP6lrsemXtmcRBBx32mmrM3KvrT1gro+48X3jo/ETYZ6k9E9cATV4pB+fWAt
         wxqQ/K/emdwjziCerqaRsPM/VVeAI06qvyIo9+P19LjuHxCvJvVLYM5HRbcL2YgznoVp
         VfIQ==
X-Gm-Message-State: AOJu0Yz1k2teVXLvlAVqnj7tuZwugRBMQtB9tJqJEZxTcmGJC03TzRAs
	gz8xyE5BVrwcwvwsfRFd3EVA1D0Vx2HwY5vqgD8TnkWcYYkMpVE460mKunWJU8LulRgIPafjUM0
	R+9S2aAc7MdijvEtIfEIzqmFBzuI6yYWfiEJS9vGBxeERnzuq4I5mV70TSGQdW1p3BEEdSAVmqF
	TC+gV1TchH2uMJTXuNMO0/+Cnq8oQDtfaF5C2gkckF
X-Gm-Gg: ASbGnctn9JNimrhRcVWnsGLkuE9cxa2RAFz41K4innbyhftE89pEEjzhl5Bl2y8RPbp
	Rti4tyyhyQ4QwMXWrCr326dVCv500DUYxW43Ree+TnNiGD8gGnjiFPWDqZKRHLAoEJFLl8QzbH3
	O7DQMUOIgE4kotLw05DcsP1bc1ARtHEEcMdvfe1UdY/5tCWdFR+8VtovyWi8U4FCKvgXw8wpxW6
	osE78l5wPYR1OzMWRFeJD45NuBw0MiHb3VYtU9y1IrEqLKoEZYbGZT5nupid+SzPFQ2dxaSX0OJ
	NH3xT+gyIMlo36o=
X-Received: by 2002:a17:907:60cf:b0:aac:1ea4:8410 with SMTP id a640c23a62f3a-aac2d489f87mr3245624366b.36.1735479422045;
        Sun, 29 Dec 2024 05:37:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFI+nBOekqYb+90nUPE8zGV5Mm4HU3621658m+JikmrI5mxyIUdDyaqCuxF+vbDi9dBi3Fi6Q==
X-Received: by 2002:a17:907:60cf:b0:aac:1ea4:8410 with SMTP id a640c23a62f3a-aac2d489f87mr3245621166b.36.1735479421581;
        Sun, 29 Dec 2024 05:37:01 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d806fedbc5sm13839735a12.60.2024.12.29.05.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:37:01 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 1/2] iomap: add iomap_writepages_unbound() to write beyond EOF
Date: Sun, 29 Dec 2024 14:36:39 +0100
Message-ID: <20241229133640.1193578-2-aalbersh@kernel.org>
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

Add iomap_writepages_unbound() without limit in form of EOF. XFS
will use this to writeback extended attributes (fs-verity Merkle
tree) in range far beyond EOF.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/iomap/buffered-io.c | 55 ++++++++++++++++++++++++++++++++----------
 include/linux/iomap.h  |  4 +++
 2 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 955f19e27e47..61ec924c5b80 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -979,13 +979,13 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		 * unlock and release the folio.
 		 */
 		old_size = iter->inode->i_size;
-		if (pos + written > old_size) {
+		if (!(iter->flags & IOMAP_NOSIZE) && (pos + written > old_size)) {
 			i_size_write(iter->inode, pos + written);
 			iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
 		}
 		__iomap_put_folio(iter, pos, written, folio);
 
-		if (old_size < pos)
+		if (!(iter->flags & IOMAP_NOSIZE) && (old_size < pos))
 			pagecache_isize_extended(iter->inode, old_size, pos);
 
 		cond_resched();
@@ -1918,18 +1918,10 @@ static int iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 	int error = 0;
 	u32 rlen;
 
-	WARN_ON_ONCE(!folio_test_locked(folio));
-	WARN_ON_ONCE(folio_test_dirty(folio));
-	WARN_ON_ONCE(folio_test_writeback(folio));
-
-	trace_iomap_writepage(inode, pos, folio_size(folio));
-
-	if (!iomap_writepage_handle_eof(folio, inode, &end_pos)) {
-		folio_unlock(folio);
-		return 0;
-	}
 	WARN_ON_ONCE(end_pos <= pos);
 
+	trace_iomap_writepage(inode, pos, folio_size(folio));
+
 	if (i_blocks_per_folio(inode, folio) > 1) {
 		if (!ifs) {
 			ifs = ifs_alloc(inode, folio, 0);
@@ -1992,6 +1984,23 @@ static int iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 	return error;
 }
 
+/* Map pages bound by EOF */
+static int iomap_writepage_map_eof(struct iomap_writepage_ctx *wpc,
+		struct writeback_control *wbc, struct folio *folio)
+{
+	int error;
+	struct inode *inode = folio->mapping->host;
+	u64 end_pos = folio_pos(folio) + folio_size(folio);
+
+	if (!iomap_writepage_handle_eof(folio, inode, &end_pos)) {
+		folio_unlock(folio);
+		return 0;
+	}
+
+	error = iomap_writepage_map(wpc, wbc, folio);
+	return error;
+}
+
 int
 iomap_writepages(struct address_space *mapping, struct writeback_control *wbc,
 		struct iomap_writepage_ctx *wpc,
@@ -2008,12 +2017,32 @@ iomap_writepages(struct address_space *mapping, struct writeback_control *wbc,
 			PF_MEMALLOC))
 		return -EIO;
 
+	wpc->ops = ops;
+	while ((folio = writeback_iter(mapping, wbc, folio, &error))) {
+		WARN_ON_ONCE(!folio_test_locked(folio));
+		WARN_ON_ONCE(folio_test_dirty(folio));
+		WARN_ON_ONCE(folio_test_writeback(folio));
+
+		error = iomap_writepage_map_eof(wpc, wbc, folio);
+	}
+	return iomap_submit_ioend(wpc, error);
+}
+EXPORT_SYMBOL_GPL(iomap_writepages);
+
+int
+iomap_writepages_unbound(struct address_space *mapping, struct writeback_control *wbc,
+		struct iomap_writepage_ctx *wpc,
+		const struct iomap_writeback_ops *ops)
+{
+	struct folio *folio = NULL;
+	int error;
+
 	wpc->ops = ops;
 	while ((folio = writeback_iter(mapping, wbc, folio, &error)))
 		error = iomap_writepage_map(wpc, wbc, folio);
 	return iomap_submit_ioend(wpc, error);
 }
-EXPORT_SYMBOL_GPL(iomap_writepages);
+EXPORT_SYMBOL_GPL(iomap_writepages_unbound);
 
 static int __init iomap_buffered_init(void)
 {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 5675af6b740c..3bfd3035ac28 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -181,6 +181,7 @@ struct iomap_folio_ops {
 #define IOMAP_DAX		(1 << 8) /* DAX mapping */
 #else
 #define IOMAP_DAX		0
+#define IOMAP_NOSIZE		(1 << 9) /* Don't update in-memory inode size*/
 #endif /* CONFIG_FS_DAX */
 #define IOMAP_ATOMIC		(1 << 9)
 
@@ -390,6 +391,9 @@ void iomap_sort_ioends(struct list_head *ioend_list);
 int iomap_writepages(struct address_space *mapping,
 		struct writeback_control *wbc, struct iomap_writepage_ctx *wpc,
 		const struct iomap_writeback_ops *ops);
+int iomap_writepages_unbound(struct address_space *mapping,
+		struct writeback_control *wbc, struct iomap_writepage_ctx *wpc,
+		const struct iomap_writeback_ops *ops);
 
 /*
  * Flags for direct I/O ->end_io:
-- 
2.47.0

