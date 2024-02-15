Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A728F610E
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980080; cv=none; b=hyiW5U7Yfm8COtCA5JDmfa9glu0C2pa1IyWgIcEY2IA6i0MEL0l9GnqT3vj2SAeT9qB0DMRAs92owpfy8qcU0NkA9qjp/xcKlKcASn+ooneHTtTUATmvuCQSeVhiVXmY7VVRtLHiy60ApfQFj2RhzbJM5FQDB0mcby0Fwapn7oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980080; c=relaxed/simple;
	bh=kV5Ce1PoYE44KeJZ5h4PGR1UXCMrMjEjNHkBqIgtXMk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UiaBP8j/Lwiesv6ep3FEQpq+iZh3HC6FKfjh9t6iFQ7rhM7pyodtWkSd6PaD2SXKr/O1Ubdiewq5TGoPss0fdAR1nynlybUzQzhRoZUVJuy3SsqoHjI9noroRA5HQxbVyHHCzYHHbODQciaV3FwDFSkDmAgdRqPTx6ASjzjREWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BRc0oGmS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BRc0oGmS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ebNT9Aa/BcDUTLgLzX2tesmBAQaXVjbgz9Eg/E0mktM=; b=BRc0oGmSU3j2oFIteJpnmbSNgX
	obTCcSGtISgI3uAJv7Gt0pq9XnqODPyD1XTTqYukQH03+zyGFbKkr1ZtEZfGqqVA64lql0w2b+rwq
	8iqt6i1Hw2MoQsfiGQInOHKLOqmL2+D+rTvmfnDCgzXdFSOCiaCln1vPQMKqaAiA9Mrfx+Ivcyyv0
	IBIO+9S/29sm+ReDvsWCjkjYj1B5PhDf5CTMBK29mY6yRdiE4RPPW4tyB5rXUfPHUI35zlAy0Vl3u
	Bl9jJ8+wA1/MXDGyL7Hukn2yVoSI/7Kds7rgCpnEaH/S1Gqi7hIQHXG2LdubowJHXCIlC3OFU0N08
	ezzj5qCw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVdl-0000000F9Bg-41hQ;
	Thu, 15 Feb 2024 06:54:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/26] repair: refactor the BLKMAP_NEXTS_MAX check
Date: Thu, 15 Feb 2024 07:54:01 +0100
Message-Id: <20240215065424.2193735-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215065424.2193735-1-hch@lst.de>
References: <20240215065424.2193735-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Check the 32-bit limits using sizeof instead of cpp ifdefs so that we
can get rid of BITS_PER_LONG.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/bmap.c | 23 +++++++++++++++--------
 repair/bmap.h | 13 -------------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/repair/bmap.c b/repair/bmap.c
index cd1a8b07b..7e32fff33 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -22,6 +22,15 @@
 pthread_key_t	dblkmap_key;
 pthread_key_t	ablkmap_key;
 
+/*
+ * For 32 bit platforms, we are limited to extent arrays of 2^31 bytes, which
+ * limits the number of extents in an inode we can check. If we don't limit the
+ * valid range, we can overflow the BLKMAP_SIZE() calculation and allocate less
+ * memory than we think we needed, and hence walk off the end of the array and
+ * corrupt memory.
+ */
+#define BLKMAP_NEXTS32_MAX	((INT_MAX / sizeof(bmap_ext_t)) - 1)
+
 blkmap_t *
 blkmap_alloc(
 	xfs_extnum_t	nex,
@@ -35,8 +44,7 @@ blkmap_alloc(
 	if (nex < 1)
 		nex = 1;
 
-#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
-	if (nex > BLKMAP_NEXTS_MAX) {
+	if (sizeof(long) == 4 && nex > BLKMAP_NEXTS32_MAX) {
 		do_warn(
 	_("Number of extents requested in blkmap_alloc (%llu) overflows 32 bits.\n"
 	  "If this is not a corruption, then you will need a 64 bit system\n"
@@ -44,7 +52,6 @@ blkmap_alloc(
 			(unsigned long long)nex);
 		return NULL;
 	}
-#endif
 
 	key = whichfork ? ablkmap_key : dblkmap_key;
 	blkmap = pthread_getspecific(key);
@@ -278,20 +285,20 @@ blkmap_grow(
 		ASSERT(pthread_getspecific(key) == blkmap);
 	}
 
-#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
-	if (new_naexts > BLKMAP_NEXTS_MAX) {
+	if (sizeof(long) == 4 && new_naexts > BLKMAP_NEXTS32_MAX) {
 		do_error(
 	_("Number of extents requested in blkmap_grow (%d) overflows 32 bits.\n"
 	  "You need a 64 bit system to repair this filesystem.\n"),
 			new_naexts);
 		return NULL;
 	}
-#endif
+
 	if (new_naexts <= 0) {
 		do_error(
 	_("Number of extents requested in blkmap_grow (%d) overflowed the\n"
-	  "maximum number of supported extents (%d).\n"),
-			new_naexts, BLKMAP_NEXTS_MAX);
+	  "maximum number of supported extents (%ld).\n"),
+			new_naexts,
+			sizeof(long) == 4 ? BLKMAP_NEXTS32_MAX : INT_MAX);
 		return NULL;
 	}
 
diff --git a/repair/bmap.h b/repair/bmap.h
index 4b588df8c..df9602b31 100644
--- a/repair/bmap.h
+++ b/repair/bmap.h
@@ -28,19 +28,6 @@ typedef	struct blkmap {
 #define	BLKMAP_SIZE(n)	\
 	(offsetof(blkmap_t, exts) + (sizeof(bmap_ext_t) * (n)))
 
-/*
- * For 32 bit platforms, we are limited to extent arrays of 2^31 bytes, which
- * limits the number of extents in an inode we can check. If we don't limit the
- * valid range, we can overflow the BLKMAP_SIZE() calculation and allocate less
- * memory than we think we needed, and hence walk off the end of the array and
- * corrupt memory.
- */
-#if BITS_PER_LONG == 32
-#define BLKMAP_NEXTS_MAX	((INT_MAX / sizeof(bmap_ext_t)) - 1)
-#else
-#define BLKMAP_NEXTS_MAX	INT_MAX
-#endif
-
 extern pthread_key_t dblkmap_key;
 extern pthread_key_t ablkmap_key;
 
-- 
2.39.2

