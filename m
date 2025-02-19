Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1098214219
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 17:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739987303; cv=none; b=mqEtJpOU53L4NrRndjWIVuDCSOF0+EwDpMV5NFE2zxq5JW4V7ShoQYsQTRx9JPZv6V4C6+PHMyraSfUsSrx6NgE78R30UZAPdX2p93t2HiW0f21k0jNhUdllpHyz86BUtbPD+djWOOJjSNbccALLuK9iAH8HxcLqm7dZgD5UiNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739987303; c=relaxed/simple;
	bh=KyoC2B2y7CoYQNuhL8Wy1dxI2gJrqI6YF05zx3FfNpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eVyL1HzmpQ63HO4xbnMLUU4FJ58NmxOuEflEBvLiOOUAZLCTPBoCjInwoXhvwtR3bUZF1QjfjAGmfZSitRCawGe7PnGQbsO3qMl+zuGUdzguB6v5qxPuX0So4DPpKHGEuIXgPxexXeURGKCYYRxpH81Tof8OpOlFVno8dIgAm1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KnsFRM4x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KnsFRM4x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739987300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nJdWzUyvNu0ULsN6QMVXy5YY5o2qTfSt53ODJBJ/+PY=;
	b=KnsFRM4xUTABdW5C3HqvoI41vDi1YdeIlHvVG7ZhSDRcjnLjpqVXeLwLc8HCm7XLcNeLp5
	LEW+MFBGEqAj8LRrcpGbdQqFG5UYm6APwkkhIU4kFWR1QUNqxguc+7XanlrPV/nsondIIh
	RtYlXJDsWbUToALJ8lQsd9SDYz4ZC2k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-DKbyMz9CP5WiJyf3gNG_Wg-1; Wed,
 19 Feb 2025 12:48:17 -0500
X-MC-Unique: DKbyMz9CP5WiJyf3gNG_Wg-1
X-Mimecast-MFC-AGG-ID: DKbyMz9CP5WiJyf3gNG_Wg_1739987296
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB8D91800987;
	Wed, 19 Feb 2025 17:48:15 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.79])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DA30F1800267;
	Wed, 19 Feb 2025 17:48:14 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 02/12] iomap: advance the iter on direct I/O
Date: Wed, 19 Feb 2025 12:50:40 -0500
Message-ID: <20250219175050.83986-3-bfoster@redhat.com>
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

Update iomap direct I/O to advance the iter directly rather than via
iter.processed. Update each mapping type helper to advance based on
the amount of data processed and return success or failure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/direct-io.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b521eb15759e..b3599f8d12ac 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -289,8 +289,7 @@ static inline blk_opf_t iomap_dio_bio_opflags(struct iomap_dio *dio,
 	return opflags;
 }
 
-static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
-		struct iomap_dio *dio)
+static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
 	const struct iomap *iomap = &iter->iomap;
 	struct inode *inode = iter->inode;
@@ -303,7 +302,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 	bool need_zeroout = false;
 	bool use_fua = false;
 	int nr_pages, ret = 0;
-	size_t copied = 0;
+	u64 copied = 0;
 	size_t orig_count;
 
 	if (atomic && length != fs_block_size)
@@ -467,30 +466,28 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 	/* Undo iter limitation to current extent */
 	iov_iter_reexpand(dio->submit.iter, orig_count - copied);
 	if (copied)
-		return copied;
+		return iomap_iter_advance(iter, &copied);
 	return ret;
 }
 
-static loff_t iomap_dio_hole_iter(const struct iomap_iter *iter,
-		struct iomap_dio *dio)
+static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
 	loff_t length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
 
 	dio->size += length;
 	if (!length)
 		return -EFAULT;
-	return length;
+	return iomap_iter_advance(iter, &length);
 }
 
-static loff_t iomap_dio_inline_iter(const struct iomap_iter *iomi,
-		struct iomap_dio *dio)
+static int iomap_dio_inline_iter(struct iomap_iter *iomi, struct iomap_dio *dio)
 {
 	const struct iomap *iomap = &iomi->iomap;
 	struct iov_iter *iter = dio->submit.iter;
 	void *inline_data = iomap_inline_data(iomap, iomi->pos);
 	loff_t length = iomap_length(iomi);
 	loff_t pos = iomi->pos;
-	size_t copied;
+	u64 copied;
 
 	if (WARN_ON_ONCE(!iomap_inline_data_valid(iomap)))
 		return -EIO;
@@ -512,11 +509,10 @@ static loff_t iomap_dio_inline_iter(const struct iomap_iter *iomi,
 	dio->size += copied;
 	if (!copied)
 		return -EFAULT;
-	return copied;
+	return iomap_iter_advance(iomi, &copied);
 }
 
-static loff_t iomap_dio_iter(const struct iomap_iter *iter,
-		struct iomap_dio *dio)
+static int iomap_dio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
 	switch (iter->iomap.type) {
 	case IOMAP_HOLE:
-- 
2.48.1

