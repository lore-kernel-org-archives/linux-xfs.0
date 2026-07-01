Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AE01E515
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864665; cv=none; b=uQxfaeghl8MDgIuTirHYsswWWvl28NkSRlRt/gHlDeMy4Vf2EYKr4+WiJqfTwkZlBnnIZVs01AZrVFed7UcXK8Df7Ya/GqSmeNPXujSQ1HDThDOjoU1ie1o97SP2GBaZJzyhB+dNUY5YFi5ZzyV0pgypVaBrY4LfNBVVNdMiafg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864665; c=relaxed/simple;
	bh=prMP9C9g3myD7OM+U6NWCa8JZc1GHza38F0bLyQmI3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HB6V53Z50qXlHpSPKkeSIFub/Bi/2MYZKlEWCaFY9dsvdBSTKuphFnXCpLDViUdUKfezBz/3vbVg2qxs2jjBzlNir8Y3iU+3vcKDlosBqnT6IeEn+IovLmgP2ZeZ2ncXFG7BwKp0iJbpJdLjH1qf2tdeaDuFIxVeraoICl5wcis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uj5sChWA; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uj5sChWA"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-69dead44101so43102eaf.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864662; x=1783469462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AS8sbubwjIb3lElgkuAHBZ0W5ThBM1Y/YXcEZmFJNnQ=;
        b=Uj5sChWAOMNrOSClLkYLHV30joWGKQ2uW6Z4g38J92fkLd6aHVgCXXycYMKUVszwEE
         tJE8UT40t8VVaJzHnzdIQU/qhxMQHtz9sH69FqtGUkpwQl/bdxcbBMk5pZAOSKPUZk5d
         YxYQHTBWOx8db+nIAngQPQpbQ1Szlam95hjPDEPmgG3HUCF0YZEeIZow5fepg46+3yoA
         zf3kBPXtd/gu6fGfhVlgmaH0h/WeKaHCeywNjewD1x9hqSu/04RzEuVhs7SlkvLdyLN7
         x+qxSb40nRuGpX8eaU5PAIlzSJFlaCwbCSla6O0pSrZk+lBbzHyiuAzi9/K4h1US3YI6
         bt5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864662; x=1783469462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AS8sbubwjIb3lElgkuAHBZ0W5ThBM1Y/YXcEZmFJNnQ=;
        b=ga8H5MMn4dbCV52O1OZo+La9fB8dpHjVFHK6UddYBZuTfoGYDdMcLKw8VtKx2dp2kh
         tL55udXXgTIrw9+49K+nFZSZp0LEcsKgVPG6UawihDASc6sqdLiP5t3ZKzpdxcqH1YQC
         8k+mCb4gRMPp7sFqHHVmfUFBQhfk9+Lov4uA03nt8lqVtcxlHJSXjRhLIEo5mqWAVUY+
         GOlKV7R5v5z0vccq29nFi4zwan/69KZYOqOn0sKrHGd1P+z+pzat9pkF9t7NglTmYAWh
         fQSXXGB3Rxk/LbZjPuMmqPafLrhuuNP0NLWOhWgZvophrCMvqLC+6kIxrtteUJMn4+Wn
         LMCA==
X-Forwarded-Encrypted: i=1; AFNElJ9ejhKToo6FvnZ0Njii5CwdwVcmQIoY3NfDlKidA8FKwjX8iVUNeb4ekyOPEagGKJKA/f737hGGgeQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1X1MCOT2fRic7qbCuuHbVNOdjZ8KzLABcoQWOk7WBmk9NwGur
	k3F17DQXF3HSbL+HZkFTcGSvobXcCkVFklSB9Fiw2x4aF17UDtdHECyN
X-Gm-Gg: AfdE7cnd32wU+xBgS1g7lZoNjs7h6nogd2Cmo0zBxMabnK/3Wp35J+rnXUF7dxRBFpi
	OrqRrRVaHuel0RvwN+JP6rv8LSsRj5xHbIA8mPMmfSrzidHfmHIkQ4kb7iaXwRTKx/c2nx7ZxU2
	OK6IwDo08n7R+6mQoEn8ZPKhOYxtmfHsOikS/TZPB2Amo/vdasAphAIwAxdem1UnoOT+4ubhwNg
	j482Kjp+mJpv/iFN0tz/Rm5rOrZ68ss9s00vy+54vKNGD1Hu4XBrEt3wr7TSQ/k7DYqc1aCE3um
	uYYavNTqVtqg+esELe+kKfZcUyAeZmHBAJ4gHg9ld+OXBHyCqISqgJYtlm92Ifv+3GAMK7AO6tU
	9KKCnQf2kscAEMIM8joLnBBjvI+aF52e41X0KSVqKd2B5N7y5hrBo+9TrOeI+j/vDtke0R4Wb5v
	cCeeFdTJujaLb8W2HNOjQ9EBmcCCNgQ5U3zdfMwy7VNF0IzPetOo0QCT9d7DjkFFZk
X-Received: by 2002:a05:6820:818a:b0:6a1:50eb:2108 with SMTP id 006d021491bc7-6a196cbec3cmr1758758eaf.61.1782864661962;
        Tue, 30 Jun 2026 17:11:01 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a18946385fsm3131609eaf.12.2026.06.30.17.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:00 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 01/18] iomap: add ->iomap_next() and iomap_process() helper
Date: Tue, 30 Jun 2026 17:09:16 -0700
Message-ID: <20260701000949.1666714-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
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
 fs/iomap/iter.c       | 113 ++++++++++++++++++++++++++++++++++++------
 include/linux/iomap.h |  91 +++++++++++++++++++++++++++-------
 2 files changed, 171 insertions(+), 33 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index e4a29829591a..1062e4e34c38 100644
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
@@ -114,3 +99,99 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
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
+	iter->status = 0;
+	if (ret > 0)
+		iomap_iter_done(iter);
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
+/**
+ * iomap_iter_continue - decide whether iteration should continue
+ * @iter: iteration structure
+ * @iomap: the mapping that was just processed
+ * @srcmap: the source mapping that was just processed
+ *
+ * Helper for ->iomap_next() implementations, normally called via
+ * iomap_process().  Called after the previous mapping has been finished to
+ * determine whether there is more of the file range left to process.
+ *
+ * Returns 1 if there is more work to do, in which case @iomap and @srcmap are
+ * cleared so the caller can produce the next mapping; zero if the range is
+ * fully consumed; or a negative errno on error.  Any folio batch attached to
+ * the mapping is released before returning.
+ */
+int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap, int ret)
+{
+	bool stale = iomap->flags & IOMAP_F_STALE;
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
+	/* detect old return semantics where this would advance */
+	if (WARN_ON_ONCE(iter->status > 0))
+		ret = -EIO;
+	else if (iter->status < 0)
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
index 3582ed1fe236..8a78f47c557b 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -212,24 +212,35 @@ struct iomap_write_ops {
 #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
 #define IOMAP_DONTCACHE		(1 << 10)
 
-struct iomap_ops {
-	/*
-	 * Return the existing mapping at pos, or reserve space starting at
-	 * pos for up to length, as long as we can do it as a single mapping.
-	 * The actual length is returned in iomap->length.
-	 */
-	int (*iomap_begin)(struct inode *inode, loff_t pos, loff_t length,
-			unsigned flags, struct iomap *iomap,
-			struct iomap *srcmap);
+/*
+ * Return the existing mapping at pos, or reserve space starting at pos for up
+ * to length, as long as we can do it as a single mapping.
+ * The actual length is returned in iomap->length.
+ */
+typedef int (*iomap_begin_fn)(struct inode *inode, loff_t pos, loff_t length,
+		unsigned flags, struct iomap *iomap, struct iomap *srcmap);
 
-	/*
-	 * Commit and/or unreserve space previous allocated using iomap_begin.
-	 * Written indicates the length of the successful write operation which
-	 * needs to be commited, while the rest needs to be unreserved.
-	 * Written might be zero if no data was written.
-	 */
-	int (*iomap_end)(struct inode *inode, loff_t pos, loff_t length,
-			ssize_t written, unsigned flags, struct iomap *iomap);
+/*
+ * Commit and/or unreserve space previous allocated using iomap_begin.
+ * Written indicates the length of the successful write operation which needs
+ * to be commited, while the rest needs to be unreserved.
+ * Written might be zero if no data was written.
+ */
+typedef int (*iomap_end_fn)(struct inode *inode, loff_t pos, loff_t length,
+		ssize_t written, unsigned flags, struct iomap *iomap);
+
+/*
+ * Produce the next mapping (finishing the previous one if needed).
+ * Return 1 to continue iterating, 0 if the range is fully consumed, or a
+ * negative error on failure.
+ */
+typedef int (*iomap_next_fn)(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap);
+
+struct iomap_ops {
+	iomap_begin_fn iomap_begin;
+	iomap_end_fn iomap_end;
+	iomap_next_fn iomap_next;
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
@@ -648,4 +662,47 @@ static inline void iomap_bio_readahead(struct readahead_control *rac,
 }
 #endif /* CONFIG_BLOCK */
 
+/**
+ * iomap_process - finish the previous mapping and produce the next one
+ * @iter: iteration structure
+ * @iomap: mapping to finish and then repopulate
+ * @srcmap: source mapping to finish and then repopulate
+ * @begin: callback that produces a mapping for the current position
+ * @end: optional callback that finishes the previous mapping, or NULL
+ *
+ * Inline helper that implements the common body of an ->iomap_next()
+ * callback: it finishes the previous mapping via @end (if present), decides
+ * via iomap_iter_continue() whether to keep going, and obtains the next
+ * mapping via @begin.
+ *
+ * Returns 1 to continue iterating, 0 once the range is fully consumed, or a
+ * negative errno on error.
+ */
+static __always_inline int iomap_process(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap, iomap_begin_fn begin,
+		iomap_end_fn end)
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

