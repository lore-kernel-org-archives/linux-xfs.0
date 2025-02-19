Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5FD215048
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 17:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739987318; cv=none; b=cJSAbrdW3DJLUR3hqtdSWeQ1GokkshS7QXYBbz/DUIUhf11f9ssVjkdepTccpUOtfPCL/F9XIZgNXK7ULLmJG59lpUuxDerueq9QrOb4nHLjoDm5cfdx696yo8NDKCYKXJSxTx91925B8LKpDvNuoonXfV1BaUzTh+vFVsiULWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739987318; c=relaxed/simple;
	bh=JKROBRF7IP5GPphNge9Vh/4KunoD+rLRRFUCmBdcvLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MoNOJpB5my75l3siKQF+3prw7l517Dp1KrsgwsmUp0+hoRkEJrN+sVA7my2G3Y823Y+DiAULssMweboMhXEM8b3rlf11h8H3hDqdegj0jFR1r2m6mSd8OJSNCQi9z3Uj/i4iZd3lE8SPV2kMLA1N5AKXT/9EaIUy+HNrKeSurws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WM3QeEt5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WM3QeEt5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739987316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gbBGUTiTIzap/EX4smSF0j4RvXup8WhyaRsEhY//Dwg=;
	b=WM3QeEt5sEpBno4dUr4R3rRB0l/DHb0wGL0f4Md3P0LxCqkaUNqyD5u+p9IHgth5KGbGjc
	Q5A69U/xiS7NxXH10iFIRhbcA+uxbPcb2v2R73bpZUbqgReJ6/LEcfHufVGSBZGFhhNPBR
	rn+fnHDxgsrJEqCBmefK/lts5o/2fK4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-roUw30rzOAqAckkAfE9aJw-1; Wed,
 19 Feb 2025 12:48:31 -0500
X-MC-Unique: roUw30rzOAqAckkAfE9aJw-1
X-Mimecast-MFC-AGG-ID: roUw30rzOAqAckkAfE9aJw_1739987309
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBB731800878;
	Wed, 19 Feb 2025 17:48:28 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.79])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E072D1800359;
	Wed, 19 Feb 2025 17:48:27 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 12/12] iomap: introduce a full map advance helper
Date: Wed, 19 Feb 2025 12:50:50 -0500
Message-ID: <20250219175050.83986-13-bfoster@redhat.com>
In-Reply-To: <20250219175050.83986-1-bfoster@redhat.com>
References: <20250219175050.83986-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Various iomap_iter_advance() calls advance by the full mapping
length and thus have no need for the current length input or
post-advance remaining length output from the standard advance
function. Add an iomap_iter_advance_full() helper to clean up these
cases.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/dax.c               | 10 ++++------
 fs/iomap/buffered-io.c |  3 +--
 fs/iomap/fiemap.c      |  3 +--
 fs/iomap/swapfile.c    |  4 +---
 include/linux/iomap.h  |  9 +++++++++
 5 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index cab3c5abe5cb..7fd4cd9a51f2 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1266,11 +1266,11 @@ static int dax_unshare_iter(struct iomap_iter *iter)
 	u64 copy_len = iomap_length(iter);
 	u32 mod;
 	int id = 0;
-	s64 ret = iomap_length(iter);
+	s64 ret;
 	void *daddr = NULL, *saddr = NULL;
 
 	if (!iomap_want_unshare_iter(iter))
-		return iomap_iter_advance(iter, &ret);
+		return iomap_iter_advance_full(iter);
 
 	/*
 	 * Extend the file range to be aligned to fsblock/pagesize, because
@@ -1300,16 +1300,14 @@ static int dax_unshare_iter(struct iomap_iter *iter)
 	if (ret < 0)
 		goto out_unlock;
 
-	if (copy_mc_to_kernel(daddr, saddr, copy_len) == 0)
-		ret = iomap_length(iter);
-	else
+	if (copy_mc_to_kernel(daddr, saddr, copy_len) != 0)
 		ret = -EIO;
 
 out_unlock:
 	dax_read_unlock(id);
 	if (ret < 0)
 		return dax_mem2blk_err(ret);
-	return iomap_iter_advance(iter, &ret);
+	return iomap_iter_advance_full(iter);
 }
 
 int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 2b86978010bb..e53ac635e47c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1436,8 +1436,7 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 				range_dirty = false;
 				status = iomap_zero_iter_flush_and_stale(&iter);
 			} else {
-				u64 length = iomap_length(&iter);
-				status = iomap_iter_advance(&iter, &length);
+				status = iomap_iter_advance_full(&iter);
 			}
 			iter.status = status;
 			continue;
diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index 6776b800bde7..80675c42e94e 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -42,7 +42,6 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
 static int iomap_fiemap_iter(struct iomap_iter *iter,
 		struct fiemap_extent_info *fi, struct iomap *prev)
 {
-	u64 length = iomap_length(iter);
 	int ret;
 
 	if (iter->iomap.type == IOMAP_HOLE)
@@ -56,7 +55,7 @@ static int iomap_fiemap_iter(struct iomap_iter *iter,
 		return 0;
 
 advance:
-	return iomap_iter_advance(iter, &length);
+	return iomap_iter_advance_full(iter);
 }
 
 int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
index 9ea185e58ca7..c1a762c10ce4 100644
--- a/fs/iomap/swapfile.c
+++ b/fs/iomap/swapfile.c
@@ -97,8 +97,6 @@ static int iomap_swapfile_fail(struct iomap_swapfile_info *isi, const char *str)
 static int iomap_swapfile_iter(struct iomap_iter *iter,
 		struct iomap *iomap, struct iomap_swapfile_info *isi)
 {
-	u64 length = iomap_length(iter);
-
 	switch (iomap->type) {
 	case IOMAP_MAPPED:
 	case IOMAP_UNWRITTEN:
@@ -135,7 +133,7 @@ static int iomap_swapfile_iter(struct iomap_iter *iter,
 		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
 	}
 
-	return iomap_iter_advance(iter, &length);
+	return iomap_iter_advance_full(iter);
 }
 
 /*
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 29b72a671104..4c7e9fe32117 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -264,6 +264,15 @@ static inline u64 iomap_length(const struct iomap_iter *iter)
 	return iomap_length_trim(iter, iter->pos, iter->len);
 }
 
+/**
+ * iomap_iter_advance_full - advance by the full length of current map
+ */
+static inline int iomap_iter_advance_full(struct iomap_iter *iter)
+{
+	u64 length = iomap_length(iter);
+	return iomap_iter_advance(iter, &length);
+}
+
 /**
  * iomap_iter_srcmap - return the source map for the current iomap iteration
  * @i: iteration structure
-- 
2.48.1

