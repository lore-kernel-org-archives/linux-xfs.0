Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D1629D264
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 02:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782356012; cv=none; b=cOELl0KVfO3fkiZkoOs7xIwFcooOJNr4dz7bKkrbitIZ/uSATY1FhfWLVjgz00pE1OHfRhCgUiN3RVEBr08lWi55QLuVZNrKgjdypjPS8ogTr2P95t1VK+dCGbkJ3tCq6fZ72VYoYE1STGmzlfn76wO/rTNWc1gjEE2Ydhr3fNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782356012; c=relaxed/simple;
	bh=jxT/LdytOro1GV02ab7E9A+pkXxXSwapMUe8MtGx1R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCng0SZjA3yDxjJwVGT3FMAQ0PAY2l/Naui3H61gHmdezXD704VOVfUp1rL9Kt3RWgFmtOcNh0Eu6HQdQpJWAczeVwCTSk4XSCrtCzqoDmcU3TOanzt4y4hKtaLyMG5DuW7Rl9nLRh+KOOmw75pgGl5rg7ihXaI3SZ8n/YIAZaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WySoYARa; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WySoYARa"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6a11c68ae41so853450eaf.3
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 19:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782356010; x=1782960810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZyNGCOA5Pib8qjMedCH/EAv/uvESG0jhSq7lr95gl0U=;
        b=WySoYARapg5mZ3cGVMvq/YpPhl9LDxAWdtZBDMOGHVDU4QTIlXWvj79upGMoYPaJii
         X+2eVzAbSHFChstBwxvM/Uar1nUontY5bGT3elvbO0byWxrp5iJwYYQtN8FQMYMJzCWA
         RF8dF/anhFrdpti8VgEU4VIoVekax8ppQjOQ4jYXXCuupx/AWhp0IORxrMgwqPdbv0pv
         lPSyUvi0ZVTyCQqDazywlX4w9TdB9IpQ7tMzmp4eXyIGv/99mOXNyUMmODNR7zoYTZ1h
         hPTtmgz3UjW63vBpJDRvjgj6ulh4sjIU/lpbYkzRuurGgxGKkIabPRCKn6FEXfua2Duz
         SkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782356010; x=1782960810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZyNGCOA5Pib8qjMedCH/EAv/uvESG0jhSq7lr95gl0U=;
        b=jQ5vmGr369NLjRye/G4nsIIazykLcPHaJqOnr2rkZrqlarwCW6OIg+hlFurTyVRIED
         GxBiOo0fTv9Pw1On7MgXYl1lLvcnKYrcWvOdFC0pZDvWGLWzv0xIUMghvfoJB7hLjT8z
         7/26ZWodH6ylo77xN9VlOELH+KijE68uTOfUA8yvicgOzBmWyJNenL0MVJPWAIjDjpu4
         g9M+h2O3vOTh/zXKpGNZnjLjxxxoHaLeMiqzYebemxSsj+kc2t0IasAYjMIULnj8mvzF
         JAZIGMZVKadpQQyn5CbWyk3pOBrrx860AAizJQBN9g2z7Xnh2swFBLPdyBw1B9WKAa+/
         8Gyw==
X-Forwarded-Encrypted: i=1; AFNElJ/05LsHMw7fknkdStjXZi1VLMR+EFvEQJk+oSesQEgZaEdLVM+IOVe2pTXddT8wZ/ooWDicPKIUrec=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMWtKYN6fnOwjyGMhnfIIpkKKXyyw0ueWNnjepjGJOaqNNg6HN
	oy9Mj+Bm8EmpDFsliXl95tzZVP13ZyBCEAB4ldwswWZN5JDhJtWK9dyXviTHXw==
X-Gm-Gg: AfdE7cn4dl5oqipSPWc7oigtKvXxMQNtDpk7GkSZ+6BCQ3uHnEWOXBIpAHt4pHOp3uH
	epWo2A0lNCB4P1KbqEocSmiQ7J9VfYTFEt4i4zpimY+C4vzkyAbzBLl73OlPrZOm9oQ7IDrDheo
	Wb/tqcwsS9FL9Im8TkBXzDEmnvcMAK8NftIVflYshPOiuJ9Us7IjGOsQ8uXbWT/+cXURYRuMZM2
	PkezWkYqp3G1eS1EGyjF0SJCqdntsxHFapdaXfEHxm8BithefEKWDFMcYMWktsXlaTMIjMKmvCd
	kbcKT+RkDTH+w7h+5aqYlXIhGXHTno9dqnvO0K+a4K9FC+CgTf6ZM3e3eaC5xnmLyMZc6OEiTdd
	RH5U7XrTOsMOe4ZIoiNMWJinrFZ5Rb4k+7r3jWFKUHW1yDvWpgpkX0ukSPOu6/VeL+EcReT/wpZ
	NXLkUjb4ioEu7XtNmXFmfX7QldclXvlGDx3OSRcoaficJS19Z0u9PInTAkgzsig5o=
X-Received: by 2002:a05:6820:2110:b0:6a1:1eab:179e with SMTP id 006d021491bc7-6a135216bcemr516361eaf.40.1782356009731;
        Wed, 24 Jun 2026 19:53:29 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a0e9fae72csm10380283eaf.7.2026.06.24.19.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 19:53:28 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: hch@lst.de,
	willy@infradead.org,
	djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [RFC PATCH v1 1/3] iomap: add ->iomap_next() and iomap_process() helper
Date: Wed, 24 Jun 2026 19:47:21 -0700
Message-ID: <20260625024723.1611000-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260625024723.1611000-1-joannelkoong@gmail.com>
References: <20260625024723.1611000-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Have one ->iomap_next() callback instead of ->iomap_begin() and
->iomap_end(). ->iomap_next() finishes the previous mapping if needed,
and produces the next mapping. This lets performance-critical callers
inline the iteration with a fixed callback, which the compiler is able
to call directly instead of indirectly.

iomap_iter() uses ->iomap_next() when the filesystem provides that
callback and otherwise falls back to the ->iomap_begin()/->iomap_end()
path, so filesystems can be converted one at a time.

Add a iomap_process() inline helper that does most of the logic needed
in an ->iomap_next() implementation.

Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 96 +++++++++++++++++++++++++++++++++++--------
 include/linux/iomap.h | 51 ++++++++++++++++++++---
 2 files changed, 126 insertions(+), 21 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index e4a29829591a..2d5469996a51 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -39,22 +39,7 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
 		trace_iomap_iter_srcmap(iter->inode, &iter->srcmap);
 }
 
-/**
- * iomap_iter - iterate over a ranges in a file
- * @iter: iteration structue
- * @ops: iomap ops provided by the file system
- *
- * Iterate over filesystem-provided space mappings for the provided file range.
- *
- * This function handles cleanup of resources acquired for iteration when the
- * filesystem indicates there are no more space mappings, which means that this
- * function must be called in a loop that continues as long it returns a
- * positive value.  If 0 or a negative value is returned, the caller must not
- * return to the loop body.  Within a loop body, there are two ways to break out
- * of the loop body:  leave @iter.status unchanged, or set it to a negative
- * errno.
- */
-int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
+static int iomap_iter_legacy(struct iomap_iter *iter, const struct iomap_ops *ops)
 {
 	bool stale = iter->iomap.flags & IOMAP_F_STALE;
 	ssize_t advanced;
@@ -114,3 +99,82 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	iomap_iter_done(iter);
 	return 1;
 }
+
+static int iomap_iter_next(struct iomap_iter *iter, const struct iomap_ops *ops)
+{
+	int ret;
+
+	trace_iomap_iter(iter, ops, _RET_IP_);
+
+	ret = ops->iomap_next(iter, &iter->iomap, &iter->srcmap);
+	if (ret > 0) {
+		iter->status = 0;
+		iomap_iter_done(iter);
+	}
+
+	return ret;
+}
+
+/**
+ * iomap_iter - iterate over a ranges in a file
+ * @iter: iteration structue
+ * @ops: iomap ops provided by the file system
+ *
+ * Iterate over filesystem-provided space mappings for the provided file range.
+ *
+ * This function handles cleanup of resources acquired for iteration when the
+ * filesystem indicates there are no more space mappings, which means that this
+ * function must be called in a loop that continues as long it returns a
+ * positive value.  If 0 or a negative value is returned, the caller must not
+ * return to the loop body.  Within a loop body, there are two ways to break out
+ * of the loop body:  leave @iter.status unchanged, or set it to a negative
+ * errno.
+ */
+int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
+{
+	if (ops->iomap_next)
+		return iomap_iter_next(iter, ops);
+
+	return iomap_iter_legacy(iter, ops);
+}
+
+int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap, int ret)
+{
+	bool stale = iter->iomap.flags & IOMAP_F_STALE;
+	ssize_t advanced = iter->pos - iter->iter_start_pos;
+
+	if (!iomap->length)
+		return 1;
+
+	/*
+	 * Use iter->len to determine whether to continue onto the next mapping.
+	 * Explicitly terminate on error status or if the current iter has not
+	 * advanced at all (i.e. no work was done for some reason) unless the
+	 * mapping has been marked stale and needs to be reprocessed.
+	 */
+	if (ret < 0 && !advanced)
+		return ret;
+
+	if (iter->status < 0)
+		ret = iter->status;
+	else if (iter->len == 0 || (!advanced && !stale))
+		ret = 0;
+	else
+		ret = 1;
+
+	if (iomap->flags & IOMAP_F_FOLIO_BATCH) {
+		folio_batch_release(iter->fbatch);
+		folio_batch_reinit(iter->fbatch);
+		iomap->flags &= ~IOMAP_F_FOLIO_BATCH;
+	}
+
+	if (ret <= 0)
+		return ret;
+
+	memset(iomap, 0, sizeof(*iomap));
+	memset(srcmap, 0, sizeof(*srcmap));
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iomap_iter_continue);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3582ed1fe236..335a3858601c 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -212,15 +212,19 @@ struct iomap_write_ops {
 #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
 #define IOMAP_DONTCACHE		(1 << 10)
 
+typedef int (*iomap_begin_fn)(struct inode *inode, loff_t pos, loff_t length,
+		unsigned flags, struct iomap *iomap, struct iomap *srcmap);
+
+typedef int (*iomap_end_fn)(struct inode *inode, loff_t pos, loff_t length,
+		ssize_t written, unsigned flags, struct iomap *iomap);
+
 struct iomap_ops {
 	/*
 	 * Return the existing mapping at pos, or reserve space starting at
 	 * pos for up to length, as long as we can do it as a single mapping.
 	 * The actual length is returned in iomap->length.
 	 */
-	int (*iomap_begin)(struct inode *inode, loff_t pos, loff_t length,
-			unsigned flags, struct iomap *iomap,
-			struct iomap *srcmap);
+	iomap_begin_fn iomap_begin;
 
 	/*
 	 * Commit and/or unreserve space previous allocated using iomap_begin.
@@ -228,8 +232,15 @@ struct iomap_ops {
 	 * needs to be commited, while the rest needs to be unreserved.
 	 * Written might be zero if no data was written.
 	 */
-	int (*iomap_end)(struct inode *inode, loff_t pos, loff_t length,
-			ssize_t written, unsigned flags, struct iomap *iomap);
+	iomap_end_fn iomap_end;
+
+	/*
+	 * Produce the next mapping (finishing the previous one if needed).
+	 * Return 1 to continue iterating, 0 if the range is fully consumed,
+	 * or a negative error on failure.
+	 */
+	int (*iomap_next)(const struct iomap_iter *iter, struct iomap *iomap,
+			struct iomap *srcmap);
 };
 
 /**
@@ -317,6 +328,9 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
 	return &i->iomap;
 }
 
+int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap, int ret);
+
 /*
  * Return the file offset for the first unchanged block after a short write.
  *
@@ -648,4 +662,31 @@ static inline void iomap_bio_readahead(struct readahead_control *rac,
 }
 #endif /* CONFIG_BLOCK */
 
+static __always_inline int iomap_process(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap,
+		iomap_begin_fn begin, iomap_end_fn end)
+{
+	int ret = 0;
+
+	if (iomap->length && end) {
+		ssize_t advanced = iter->pos - iter->iter_start_pos;
+		loff_t len;
+
+		len = iomap_length_trim(iter, iter->iter_start_pos,
+				iter->len + advanced);
+
+		ret = end(iter->inode, iter->iter_start_pos, len, advanced,
+				iter->flags, iomap);
+	}
+
+	ret = iomap_iter_continue(iter, iomap, srcmap, ret);
+	if (ret <= 0)
+		return ret;
+
+	ret = begin(iter->inode, iter->pos, iter->len, iter->flags, iomap,
+			srcmap);
+
+	return ret < 0 ? ret : 1;
+}
+
 #endif /* LINUX_IOMAP_H */
-- 
2.52.0

