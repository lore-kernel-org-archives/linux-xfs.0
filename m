Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E904F1E7
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 07:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706513548; cv=none; b=SvioQvW5kq5CQ96ayZYWwZRiuSauCIPpYn1ILH+SPgr7uQEhC+INnHU/VLR6IO7GDkkzvi/KeAub5IjRjrFWSydOnNn8OH12Zo//OA3biftJG6aPzcOPKB7H84SWuvaMWGrr7jetUkkgZvbSPnATb7JHtZBsEemAKgpze3mex9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706513548; c=relaxed/simple;
	bh=ZR0wdR3W2QiusoxJ3mPVe76W5J7INsvHy8wCBWcee8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UyOwg/fv1u6mzkBNzXjkxpt+iENVWzdt9cll75670Ms6jO07ViOEtt5g1uFOz47Gm6rmq1aatKbUdo1Pkz7r0psp9+CqEnl75IWnWXi/WDLZuL7kXxQqVe2MP6gobcfQEYgJKjitq+D6BHghn7ppLx/rqYY8z5vLqi/gIkmga5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y2MTv8+X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y2MTv8+X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5w7I0PwHeoSNDq5yQDFqL2hiiLa5yr6DJKKIZrs4Q/I=; b=Y2MTv8+XGyHCIgK3uK0fvMKvOO
	zh9HKFIEluU9A00ogLi0rEcbAoqZTkvzXoSftIBLEpxZtJJud9EfIUHkUR9P2JBpDw9KNvWzviw8B
	HRhPhDU8bP6goSDprleyuQ0H4mytLWaJpbjnGxOco7CTTpoxItNEpcwlE4ZsY+8tiWyyAm+ChPazh
	DW6P0jUD8oU6GHOtWhbh6M0RTq/BbjmNEjQjBNG/cvMve3hF9Udx+k3tuQ+ST2UDynxSWV08ATK2O
	Rv4UcZPPIp7MYQzOMn36bB84JuxdNMNlWBpyrHVE8EbsGbeloD/TO349bNLmojC6Pi1XbFPwtrgn4
	0VpTQceg==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUM82-0000000BcZr-01Vg;
	Mon, 29 Jan 2024 07:32:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/27] repair: refactor the BLKMAP_NEXTS_MAX check
Date: Mon, 29 Jan 2024 08:31:51 +0100
Message-Id: <20240129073215.108519-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129073215.108519-1-hch@lst.de>
References: <20240129073215.108519-1-hch@lst.de>
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
index cd1a8b07b..d1b2faaec 100644
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
+	if (sizeof(long) == 32 && nex > BLKMAP_NEXTS32_MAX) {
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
+	if (sizeof(long) == 32 && new_naexts > BLKMAP_NEXTS32_MAX) {
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
+			sizeof(long) == 32 ? BLKMAP_NEXTS32_MAX : INT_MAX);
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

