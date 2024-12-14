Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CC5175AB;
	Sat, 14 Dec 2024 03:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734145860; cv=none; b=AR13UTyByvqApnxOVpl4Y30yYsF8JWPkSR8MHRWMbo6bGESIJTjRZDPBCgdfROWO8FDZYDJwIfQjIs1vDRwztzMkwks2gJj5kCQUPfs0geNp5/xinNFtCDEZFNfXSzInzIL8ZsiNXJ5II8tB+iPfN+K/m1E8r5AbqKjxyHJzsUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734145860; c=relaxed/simple;
	bh=Cyw294pY8t2yQLICdjQY6l3hUilybp3zGt9Q1IBsli0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LU4/0g1J6Jdm3JvcoqbC+9RTCTSriA6q3WX+LVh5WkKL5AjW6OGg+8HI2dcGYqL9ALjPRcWlaBv+d1U26h19k1Tt5bUYdGaDy7AkrfSR8DiKhN+vIlTcrYzJewhRdsDr29ytxbOphwQaWRDsCgGspiHpxXY5ssOAY0yfb8lq0SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q6vmcgeK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q6vmcgeK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XGC/Uaj6ejX3COzNjOnUbs+G/8tqYkyreK9oJdjYOIk=; b=q6vmcgeKRQGC9VxZzw/i1K7IM4
	UNJ2yA++QL819qBrpBG/20R6ObuMeDwxlObsUy00dcyHx3CICTjepQNTTG+/gL1M5fpux2bmxw6n6
	7t4UhgYo+OzeILY+IrXH2oI0Cahn8DBNp7WgjELSFjhfoWfs9IVGP/VhY7NY+jDs5EmPPaa9Y+kIz
	NARAxIxF7SjifSqhF6aI+7Zoi2gPZvlxQYTqJpAlmHGOzy9CjN/G+WQlyLRdP/1UGnYKCEbmo6Bxg
	ZKoyOC8tlp2vZxwmgJINhJlX7cYH+oDp2luJRSXAjsInk1TVs1QoqSD2+d58oT8EvC6nAam8H+IEZ
	urGCzVIw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tMIYN-00000005c3X-3GCO;
	Sat, 14 Dec 2024 03:10:51 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: willy@infradead.org,
	hch@lst.de,
	hare@suse.de,
	dave@stgolabs.net,
	david@fromorbit.com,
	djwong@kernel.org
Cc: john.g.garry@oracle.com,
	ritesh.list@gmail.com,
	kbusch@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	gost.dev@samsung.com,
	p.raghav@samsung.com,
	da.gomez@samsung.com,
	kernel@pankajraghav.com,
	mcgrof@kernel.org
Subject: [RFC v2 01/11] fs/buffer: move async batch read code into a helper
Date: Fri, 13 Dec 2024 19:10:39 -0800
Message-ID: <20241214031050.1337920-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241214031050.1337920-1-mcgrof@kernel.org>
References: <20241214031050.1337920-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Move the code from block_read_full_folio() which does a batch of async
reads into a helper.

No functional changes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/buffer.c | 73 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index cc8452f60251..580451337efa 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2350,6 +2350,48 @@ bool block_is_partially_uptodate(struct folio *folio, size_t from, size_t count)
 }
 EXPORT_SYMBOL(block_is_partially_uptodate);
 
+static void bh_read_batch_async(struct folio *folio,
+				int nr, struct buffer_head *arr[],
+				bool fully_mapped, bool no_reads,
+				bool any_get_block_error)
+{
+	int i;
+	struct buffer_head *bh;
+
+	if (fully_mapped)
+		folio_set_mappedtodisk(folio);
+
+	if (no_reads) {
+		/*
+		 * All buffers are uptodate or get_block() returned an
+		 * error when trying to map them *all* buffers we can
+		 * finish the read.
+		 */
+		folio_end_read(folio, !any_get_block_error);
+		return;
+	}
+
+	/* Stage one: lock the buffers */
+	for (i = 0; i < nr; i++) {
+		bh = arr[i];
+		lock_buffer(bh);
+		mark_buffer_async_read(bh);
+	}
+
+	/*
+	 * Stage 2: start the IO.  Check for uptodateness
+	 * inside the buffer lock in case another process reading
+	 * the underlying blockdev brought it uptodate (the sct fix).
+	 */
+	for (i = 0; i < nr; i++) {
+		bh = arr[i];
+		if (buffer_uptodate(bh))
+			end_buffer_async_read(bh, 1);
+		else
+			submit_bh(REQ_OP_READ, bh);
+	}
+}
+
 /*
  * Generic "read_folio" function for block devices that have the normal
  * get_block functionality. This is most of the block device filesystems.
@@ -2414,37 +2456,8 @@ int block_read_full_folio(struct folio *folio, get_block_t *get_block)
 		arr[nr++] = bh;
 	} while (i++, iblock++, (bh = bh->b_this_page) != head);
 
-	if (fully_mapped)
-		folio_set_mappedtodisk(folio);
-
-	if (!nr) {
-		/*
-		 * All buffers are uptodate or get_block() returned an
-		 * error when trying to map them - we can finish the read.
-		 */
-		folio_end_read(folio, !page_error);
-		return 0;
-	}
-
-	/* Stage two: lock the buffers */
-	for (i = 0; i < nr; i++) {
-		bh = arr[i];
-		lock_buffer(bh);
-		mark_buffer_async_read(bh);
-	}
+	bh_read_batch_async(folio, nr, arr, fully_mapped, nr == 0, page_error);
 
-	/*
-	 * Stage 3: start the IO.  Check for uptodateness
-	 * inside the buffer lock in case another process reading
-	 * the underlying blockdev brought it uptodate (the sct fix).
-	 */
-	for (i = 0; i < nr; i++) {
-		bh = arr[i];
-		if (buffer_uptodate(bh))
-			end_buffer_async_read(bh, 1);
-		else
-			submit_bh(REQ_OP_READ, bh);
-	}
 	return 0;
 }
 EXPORT_SYMBOL(block_read_full_folio);
-- 
2.43.0

