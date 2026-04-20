Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7107B39EF2B;
	Mon, 20 Apr 2026 11:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776685667; cv=none; b=dVkxfaC3NdONUUkqK2v+/zjw5FqpD2KuIpjkHjiLJT84eMrIZxhuRVOIcb5kEcnMo0JCCYIT4/TutQMPzQrF3EFUvNYbjgr+mfcyXW75j8Hh4etU66fOEOHdvh5rvNYUc08N3g9jAEOHhL0N65c8wnsgqdc0ycV00Ww5fJ/kbl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776685667; c=relaxed/simple;
	bh=R9xmYqpzgIFigojr0fKbrRlBCOLoFi0C2ZAyyNYRUGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agHgato/UgBYg3mK+5phj9Ns6pW2p+JQB9tjuDjOzFk/uDMslBbsOdlPw/743GQpSLznO9hYaCgQcEitxSfbVNY7BT/ebmDKUSzDlvstQMtQ8dIHMtuL447z3SR+BLKXFZhuGi9kuPpvNqGEpWoYV844aPyZzn+n8hS/HunZmbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GNuaJaFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GNuaJaFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8F3C19425;
	Mon, 20 Apr 2026 11:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776685667;
	bh=R9xmYqpzgIFigojr0fKbrRlBCOLoFi0C2ZAyyNYRUGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNuaJaFC1VMEw66KMvRgR62IXWk/oOY0BksprSIfY+GuQtfJGaWT42SozLCTUTgfE
	 IQnyO5WPS0xUaXpOLXBaaC45/3BBZ3/Y5U8BxPJ3SVGQYwQdFMMSgq7ScCkC5rikIs
	 fyL7Xk8EfSPYR83g02XPBFJymv1r0Ty8x/dIK9Uap1Z9RNcNMIpUKSjOdz2yuafsGe
	 ZLr0QpIH3wyhM8hCRQfW6m/fF3avOs5i/sG/hPFhzyEgs8FxTTavREeqeG8braEfut
	 zbOd9mncRT6yvKw3btxhg4G44ZCHy+QsUj1FnWjT5hD77tNYv2SCnYFPECHO0/F/7D
	 5KGyG2NeND5Yg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 04/22] fsverity: generate and store zero-block hash
Date: Mon, 20 Apr 2026 13:46:51 +0200
Message-ID: <20260420114714.1621982-5-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260420114714.1621982-1-aalbersh@kernel.org>
References: <20260420114714.1621982-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Compute the hash of one filesystem block's worth of zeros. A filesystem
implementation can decide to elide merkle tree blocks containing only
this hash and synthesize the contents at read time.

Let's pretend that there's a file containing 131 data block and whose
merkle tree looks roughly like this:

root
 +--leaf0
 |   +--data0
 |   +--data1
 |   +--...
 |   `--data128
 `--leaf1
     +--data129
     +--data130
     `--data131

If data[0-128] are sparse holes, then leaf0 will contain a repeating
sequence of @zero_digest.  Therefore, leaf0 need not be written to disk
because its contents can be synthesized.

A subsequent xfs patch will use this to reduce the size of the merkle
tree when dealing with sparse gold master disk images and the like.

Note that this works only on the first-level (data holes). fsverity
doesn't store/generate zero_digest for any higher levels.

Add a helper to pre-fill folio with hashes of empty blocks. This will be
used by iomap to synthesize blocks full of zero hashes on the fly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/fsverity_private.h |  3 +++
 fs/verity/measure.c          |  4 ++--
 fs/verity/open.c             |  3 +++
 fs/verity/pagecache.c        | 22 ++++++++++++++++++++++
 include/linux/fsverity.h     |  8 ++++++++
 5 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index 6e6854c19078..881d46f25e08 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -53,6 +53,9 @@ struct merkle_tree_params {
 	u64 tree_size;			/* Merkle tree size in bytes */
 	unsigned long tree_pages;	/* Merkle tree size in pages */
 
+	/* the hash of an all-zeroes block */
+	u8 zero_digest[FS_VERITY_MAX_DIGEST_SIZE];
+
 	/*
 	 * Starting block index for each tree level, ordered from leaf level (0)
 	 * to root level ('num_levels - 1')
diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index 6a35623ebdf0..818083507885 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -68,8 +68,8 @@ EXPORT_SYMBOL_GPL(fsverity_ioctl_measure);
  * @alg: (out) the digest's algorithm, as a FS_VERITY_HASH_ALG_* value
  * @halg: (out) the digest's algorithm, as a HASH_ALGO_* value
  *
- * Retrieves the fsverity digest of the given file.  The file must have been
- * opened at least once since the inode was last loaded into the inode cache;
+ * Retrieves the fsverity digest of the given file. The
+ * fsverity_ensure_verity_info() must be called on the inode beforehand;
  * otherwise this function will not recognize when fsverity is enabled.
  *
  * The file's fsverity digest consists of @raw_digest in combination with either
diff --git a/fs/verity/open.c b/fs/verity/open.c
index d32d0899df25..875e8850ccba 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -153,6 +153,9 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 		goto out_err;
 	}
 
+	fsverity_hash_block(params, page_address(ZERO_PAGE(0)),
+			    params->zero_digest);
+
 	params->tree_size = offset << log_blocksize;
 	params->tree_pages = PAGE_ALIGN(params->tree_size) >> PAGE_SHIFT;
 	return 0;
diff --git a/fs/verity/pagecache.c b/fs/verity/pagecache.c
index 1819314ecaa3..99f5f53eea98 100644
--- a/fs/verity/pagecache.c
+++ b/fs/verity/pagecache.c
@@ -2,6 +2,7 @@
 /*
  * Copyright 2019 Google LLC
  */
+#include "fsverity_private.h"
 
 #include <linux/export.h>
 #include <linux/fsverity.h>
@@ -56,3 +57,24 @@ void generic_readahead_merkle_tree(struct inode *inode, pgoff_t index,
 		folio_put(folio);
 }
 EXPORT_SYMBOL_GPL(generic_readahead_merkle_tree);
+
+/**
+ * fsverity_fill_zerohash() - fill folio with hashes of zero data block
+ * @folio:	folio to fill
+ * @offset:	offset in the folio to start
+ * @len:	length of the range to fill with hashes
+ * @vi:		fsverity info
+ */
+void fsverity_fill_zerohash(struct folio *folio, size_t offset, size_t len,
+			      struct fsverity_info *vi)
+{
+	size_t off = offset;
+
+	WARN_ON_ONCE(!IS_ALIGNED(offset, vi->tree_params.digest_size));
+	WARN_ON_ONCE(!IS_ALIGNED(len, vi->tree_params.digest_size));
+
+	for (; off < (offset + len); off += vi->tree_params.digest_size)
+		memcpy_to_folio(folio, off, vi->tree_params.zero_digest,
+				vi->tree_params.digest_size);
+}
+EXPORT_SYMBOL_GPL(fsverity_fill_zerohash);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 5562271bd628..e4503312d114 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -201,6 +201,8 @@ bool fsverity_verify_blocks(struct fsverity_info *vi, struct folio *folio,
 			    size_t len, size_t offset);
 void fsverity_verify_bio(struct fsverity_info *vi, struct bio *bio);
 void fsverity_enqueue_verify_work(struct work_struct *work);
+void fsverity_fill_zerohash(struct folio *folio, size_t poff, size_t plen,
+			      struct fsverity_info *vi);
 
 #else /* !CONFIG_FS_VERITY */
 
@@ -281,6 +283,12 @@ static inline void fsverity_enqueue_verify_work(struct work_struct *work)
 	WARN_ON_ONCE(1);
 }
 
+static inline void fsverity_fill_zerohash(struct folio *folio, size_t poff,
+		size_t plen, struct fsverity_info *vi)
+{
+	WARN_ON_ONCE(1);
+}
+
 #endif	/* !CONFIG_FS_VERITY */
 
 static inline bool fsverity_verify_folio(struct fsverity_info *vi,
-- 
2.51.2

