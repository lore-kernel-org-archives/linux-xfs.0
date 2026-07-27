Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656A442A171
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 21:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187471; cv=none; b=loWcndTLrNteVjuXDC3RghnzWRjGHngyWX5h50W6E8EypUCQIAjgdNaFp9UI0k6fg3L1ETYW6TYz7GFbWg8FRDb0V7nZ3HRuicYChqewRbNaylMdNmVT1JG5dvmFA9fWGeGez5LjE12wdr7iXfcs1eeRrepyBZJ9ECTikP/RWsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187471; c=relaxed/simple;
	bh=8S5bcuh9iiTnwlS4cWYCa7b9+ezOgPKIq9XpzPKag+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvnP7sAZFTPYTOBsm81UK5+JiQL1p1vTFf2FDZhGB7SsPdltGfK1Hc/xxj0qwzrj/oXIrAGMWGqiW12w4Ron/58yU+DhPftJC7kMw5K7NrQxIvmej8mhurvYsphXOqnMwZ7DWr9WolSICTDodahNRILBBaNBXoMeIoBQGaYquWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YUXjld+0; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YUXjld+0"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cc73e322dbso30571475ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 14:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187469; x=1785792269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yZggh9MA+ZjoJnApRyIXNH/CAhzh4QegVncenQze78g=;
        b=YUXjld+0uJI/VwrO//IK+u7zKb2gKA/Yt1n4MxLY5DnJ7G2wtiiWHkOdEdBY+l7cCh
         wKydoMePJrogp+IANZLsBdRt+H2uJZUJFnK6K9p4uTBjfeRrSb2Vtk1HLSd+gLZ0NLr3
         RAFT+Oj0l8CJFAqmOW/ez0VxM9pLMpfo2RQ1iqYdqBj6bHUde936Nx7QFKHscTiiJsy/
         741aBxhulhfsX+U9bHn2RKM2Tt8Es1M3kqnVubASuOOwQcKykEJ0frfr8e6md0Fh0k84
         9YBRcKGeTaFLbRyiPKaswHgfENX8U1e+Z3KSc5/g6F0U+noJe3KXG+Ey4plIheR1nLl2
         uvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187469; x=1785792269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yZggh9MA+ZjoJnApRyIXNH/CAhzh4QegVncenQze78g=;
        b=aJ2pRNf2Ms8zpUzEIfVXUzf2uh29MBME/z4QKF9/ozP1pKS9At1Zbs+WDOZplsZi43
         rtJqd/0ptfAMe4J3k2+LcUm6VWIDFphx/aJZqeb05iPQ5IJhTmr601zpY0hiQGNRlIZk
         eeeO+5KcvV+FvlcRaSwuFrsGVjbxq4oPXjgWLk03aRLfbgu7k2bHv5A7Qysgwwpep0Ed
         /3Izv6XItxvGl/u5Q8VzO6a93jCUsxsi6+50ey6K16vw9K6FAVZW2OuVBhjOxn4SES1o
         0Xwxg8rHxS3YJmZyC1RrS5UwHCNPP6tN0gQkq3UuwXsptzvli3FWAv70X9S7z+EA0CdR
         fsxQ==
X-Forwarded-Encrypted: i=1; AHgh+RpIucYlDNwtNrsNIngMSVlBdWHrSNgB82gtpC2E+/RQ/KM7ELKtf7r21e5X7CdqB4vMim6i947KeRk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqiaw77S2q58b60FqebdUvQ0/BxJ5T4B3hJQZwXHB+ctNpuqO/
	UwEKa8qCHjuBBmNlYUifKbHAX4zCURRNxO0fY/yZVNMZYZ9yhUMXwZKZ
X-Gm-Gg: AR+sD10OBTzfQegXdxgPx62jGH9gkuYbUISjqbazW09c5Dabv4Q+q9XQzgRSb1Zer2V
	FyxO0xnWCf+oY88H/7Y27kGJZcEiC5jyHgg4Mm8Rec+mq95/4hvS5TVrNWvT91kBjIBWeeWXAQ6
	/phKewQ/V7dzpxbtHEQlXeHi+fD1e/8zbHh/6ijhWa0zUN8iJFEl4/DkYumzaelGB0cDgCLNoQ9
	8SXDiNzkjpRxxEiL0e48F1275rHLC9j213G7abf02wH2C8y1F8kx3gcb2uPB50Nz+ZAQb+sTAEu
	Nm8nLlOrOsquaJw1/kbXkdnza8aciWuqqxV0sRct0KjjlXKPwxTtNg9Pmubskg4Ky40McnoRwhx
	Dtv/Sh+xSoZQqUC2aEO18cv8kDJUnjgnwGcTtcaNLQhqnFpJ4QibFhhKcJbNVXP8gGs/SaJo0/Q
	lbp7ospnKAB4GTBDrgLaFshq0Y88j8jjJ9j8UKe7EIYlKUXiRPfCqVEg==
X-Received: by 2002:a17:902:ce03:b0:2cc:ae2b:b6d2 with SMTP id d9443c01a7336-2d00f30a13dmr9003265ad.15.1785187468662;
        Mon, 27 Jul 2026 14:24:28 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7d9464sm40894285ad.58.2026.07.27.14.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:28 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 01/21] iomap: split iomap_iter() logic into iomap_iter_next()
Date: Mon, 27 Jul 2026 14:17:38 -0700
Message-ID: <20260727211758.1116539-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for changing iomap to use an in-iter (->iomap_next())
model, move the iomap_iter() logic out into the new iomap_iter_next()
helper function.

iomap_iter_next() is added as an inlined helper so it can be called
directly by ->iomap_next() implementations where the begin()/end()
callbacks can be direct calls.

The DEFINE_IOMAP_ITER_NEXT() and DEFINE_IOMAP_ITER_NEXT_END() macros are
also provided to generate the boilerplate ->iomap_next() wrapper
functions that simply forward to iomap_iter_next() with the appropriate
begin/end callbacks. DEFINE_IOMAP_ITER_NEXT() is for the common case
where there is no end() callback. DEFINE_IOMAP_ITER_NEXT_END() is for
the case where there is an explicit end() callback.

No functional change intended. The only code-level difference is that on
the iomap_end() error path (ret < 0 && !advanced), the old code returned
with iter.status left as the caller's last value whereas the new code
zeroes it, but this is not observable in practice as there are no in-tree
callers that read iter.status after the iteration loop.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/iter.c       | 123 +++++++++++++++++++++---------------------
 include/linux/iomap.h | 102 +++++++++++++++++++++++++++++------
 2 files changed, 147 insertions(+), 78 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index e4a29829591a..66ccb87441ab 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -6,15 +6,6 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
-static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
-{
-	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
-		folio_batch_release(iter->fbatch);
-		folio_batch_reinit(iter->fbatch);
-		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
-	}
-}
-
 /* Advance the current iterator position and decrement the remaining length */
 int iomap_iter_advance(struct iomap_iter *iter, u64 count)
 {
@@ -40,51 +31,28 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
 }
 
 /**
- * iomap_iter - iterate over a ranges in a file
- * @iter: iteration structue
- * @ops: iomap ops provided by the file system
+ * iomap_iter_continue - decide whether iteration should continue
+ * @iter: iteration structure
+ * @iomap: the mapping that was just processed
+ * @srcmap: the source mapping that was just processed
  *
- * Iterate over filesystem-provided space mappings for the provided file range.
+ * Helper normally called via iomap_iter_next(). Called after the previous
+ * mapping has been finished to determine whether there is more of the file
+ * range left to process.
  *
- * This function handles cleanup of resources acquired for iteration when the
- * filesystem indicates there are no more space mappings, which means that this
- * function must be called in a loop that continues as long it returns a
- * positive value.  If 0 or a negative value is returned, the caller must not
- * return to the loop body.  Within a loop body, there are two ways to break out
- * of the loop body:  leave @iter.status unchanged, or set it to a negative
- * errno.
+ * Returns 1 if there is more work to do, in which case @iomap and @srcmap are
+ * cleared so the caller can produce the next mapping; zero if the range is
+ * fully consumed; or a negative errno on error. Any folio batch attached to
+ * the mapping is released before returning.
  */
-int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
+int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap, int ret)
 {
-	bool stale = iter->iomap.flags & IOMAP_F_STALE;
-	ssize_t advanced;
-	u64 olen;
-	int ret;
-
-	trace_iomap_iter(iter, ops, _RET_IP_);
-
-	if (!iter->iomap.length)
-		goto begin;
-
-	/*
-	 * Calculate how far the iter was advanced and the original length bytes
-	 * for ->iomap_end().
-	 */
-	advanced = iter->pos - iter->iter_start_pos;
-	olen = iter->len + advanced;
-
-	if (ops->iomap_end) {
-		ret = ops->iomap_end(iter->inode, iter->iter_start_pos,
-				iomap_length_trim(iter, iter->iter_start_pos,
-						  olen),
-				advanced, iter->flags, &iter->iomap);
-		if (ret < 0 && !advanced)
-			return ret;
-	}
+	const bool stale = iomap->flags & IOMAP_F_STALE;
+	const ssize_t advanced = iter->pos - iter->iter_start_pos;
 
-	/* detect old return semantics where this would advance */
-	if (WARN_ON_ONCE(iter->status > 0))
-		iter->status = -EIO;
+	if (ret < 0 && !advanced)
+		return ret;
 
 	/*
 	 * Use iter->len to determine whether to continue onto the next mapping.
@@ -92,25 +60,58 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 	 * advanced at all (i.e. no work was done for some reason) unless the
 	 * mapping has been marked stale and needs to be reprocessed.
 	 */
-	if (iter->status < 0)
+	if (WARN_ON_ONCE(iter->status > 0))
+		/* detect old return semantics where this would advance */
+		ret = -EIO;
+	else if (iter->status < 0)
 		ret = iter->status;
 	else if (iter->len == 0 || (!advanced && !stale))
 		ret = 0;
 	else
 		ret = 1;
-	iomap_iter_clean_fbatch(iter);
-	iter->status = 0;
+
+	if (iomap->flags & IOMAP_F_FOLIO_BATCH) {
+		folio_batch_release(iter->fbatch);
+		folio_batch_reinit(iter->fbatch);
+		iomap->flags &= ~IOMAP_F_FOLIO_BATCH;
+	}
+
 	if (ret <= 0)
 		return ret;
 
-	memset(&iter->iomap, 0, sizeof(iter->iomap));
-	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
+	memset(iomap, 0, sizeof(*iomap));
+	memset(srcmap, 0, sizeof(*srcmap));
 
-begin:
-	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
-			       &iter->iomap, &iter->srcmap);
-	if (ret < 0)
-		return ret;
-	iomap_iter_done(iter);
-	return 1;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iomap_iter_continue);
+
+/**
+ * iomap_iter - iterate over ranges in a file
+ * @iter: iteration structure
+ * @ops: iomap ops provided by the filesystem
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
+	int ret;
+
+	trace_iomap_iter(iter, ops, _RET_IP_);
+
+	ret = iomap_iter_next(iter, &iter->iomap, &iter->srcmap,
+			ops->iomap_begin, ops->iomap_end);
+	iter->status = 0;
+	if (ret > 0)
+		iomap_iter_done(iter);
+
+	return ret;
 }
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 21e73cb9c51e..36490c08d6e9 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -212,24 +212,27 @@ struct iomap_write_ops {
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
+typedef int (*iomap_iter_begin_fn)(struct inode *inode, loff_t pos,
+		loff_t length, unsigned flags, struct iomap *iomap,
+		struct iomap *srcmap);
 
-	/*
-	 * Commit and/or unreserve space previous allocated using iomap_begin.
-	 * Written indicates the length of the successful write operation which
-	 * needs to be commited, while the rest needs to be unreserved.
-	 * Written might be zero if no data was written.
-	 */
-	int (*iomap_end)(struct inode *inode, loff_t pos, loff_t length,
-			ssize_t written, unsigned flags, struct iomap *iomap);
+/*
+ * Commit and/or unreserve space previously allocated by iomap_iter_begin_fn.
+ * Written indicates the length of the successful write operation which needs
+ * to be committed, while the rest needs to be unreserved.
+ * Written might be zero if no data was written.
+ */
+typedef int (*iomap_iter_end_fn)(struct inode *inode, loff_t pos, loff_t length,
+		ssize_t written, unsigned flags, struct iomap *iomap);
+
+struct iomap_ops {
+	iomap_iter_begin_fn iomap_begin;
+	iomap_iter_end_fn iomap_end;
 };
 
 /**
@@ -317,6 +320,71 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
 	return &i->iomap;
 }
 
+int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap, int ret);
+
+/**
+ * iomap_iter_next - finish the previous mapping and produce the next one
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
+ * This helper is marked __always_inline so that when a caller passes
+ * compile-time-constant @begin and @end callbacks, the compiler can call them
+ * directly, avoiding the indirect-call overhead.
+ *
+ * Returns 1 to continue iterating, 0 once the range is fully consumed, or a
+ * negative errno on error.
+ */
+static __always_inline int iomap_iter_next(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap,
+		iomap_iter_begin_fn begin, iomap_iter_end_fn end)
+{
+	int ret = 0;
+
+	if (iomap->length) {
+		if (end) {
+			/*
+			 * Calculate how far the iter was advanced and the
+			 * original length bytes for end().
+			 */
+			ssize_t advanced = iter->pos - iter->iter_start_pos;
+			loff_t len;
+
+			len = iomap_length_trim(iter, iter->iter_start_pos,
+					iter->len + advanced);
+
+			ret = end(iter->inode, iter->iter_start_pos, len,
+					advanced, iter->flags, iomap);
+		}
+		ret = iomap_iter_continue(iter, iomap, srcmap, ret);
+		if (ret <= 0)
+			return ret;
+	}
+
+	ret = begin(iter->inode, iter->pos, iter->len, iter->flags, iomap,
+			srcmap);
+
+	return ret < 0 ? ret : 1;
+}
+
+#define DEFINE_IOMAP_ITER_NEXT_END(name, begin_fn, end_fn)		\
+int name(const struct iomap_iter *iter, struct iomap *iomap,		\
+		struct iomap *srcmap)					\
+{									\
+	return iomap_iter_next(iter, iomap, srcmap, begin_fn, end_fn);	\
+}
+
+#define DEFINE_IOMAP_ITER_NEXT(name, begin_fn)				\
+	DEFINE_IOMAP_ITER_NEXT_END(name, begin_fn, NULL)
+
 /*
  * Return the file offset for the first unchanged block after a short write.
  *
-- 
2.52.0

