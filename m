Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F7730DED0;
	Wed, 20 May 2026 03:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779246548; cv=none; b=FRS45hW37IDwNQOHMRk2H6hf6xTF4o3Iqr4SSEYjxhSq06t3QjBF4e+J1FJ+VhwgZQrmSpZ8mJViHU4jwwD/sRdOyuV7UYBvuwEb98m5Xkfjs+Jp/mfsfV4MEZrZBAHh8+DhTQR0DYe8V6m/yY2poQSw/zN15MfnIYWhH6GNN6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779246548; c=relaxed/simple;
	bh=wsvccQEvSwcC0EV0aaeTqZgUeR/h9dhnYyjdnfT0zik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldTeAfP0Z8tRPgC6xxwiGhwqN4aenfffhoEdRgOnX7wCerxcSPzASVsiliSiMKByZBaJ+/sT8UejcEHNdVQjL9y5HGhohdA/cRi5PzGPKCSHreDdVqsFAbQee9Q61yD9jsSEBO3aDGD2WcIm7gwroMlu4ONhdD/4PXJ4ErV4Te8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gKxMZ2BG5zKHMcT;
	Wed, 20 May 2026 11:08:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2200140561;
	Wed, 20 May 2026 11:09:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgCnb1vGJQ1qn37HCw--.64508S9;
	Wed, 20 May 2026 11:09:00 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	joannelkoong@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v2 5/5] iomap: add comments for ifs_clear/set_range_dirty()
Date: Wed, 20 May 2026 11:03:57 +0800
Message-ID: <20260520030357.679687-6-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260520030357.679687-1-yi.zhang@huaweicloud.com>
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnb1vGJQ1qn37HCw--.64508S9
X-Coremail-Antispam: 1UD129KBjvJXoW7CFyUZF4fZryDJFWDAF1DZFb_yoW8Zr17pF
	W3K3yDKr4DWrs7u3W3WFW8Aw1Sqws3XFWrGFWxGwnIq3W5Ar9FgF1DG3W0vFy8KryxJFnY
	kr1jga4jgr1UAF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUo73vUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The range alignment strategy differs between ifs_clear_range_dirty() and
ifs_set_range_dirty(). The former rounds inwards to clear only
fully-covered blocks, while the latter rounds outwards to mark any
partially-touched block as dirty. Add comments to document this
asymmetry in block range calculation.

Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/iomap/buffered-io.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 76f9a43e283c..b1d917504d5d 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -173,6 +173,13 @@ static unsigned iomap_find_dirty_range(struct folio *folio, u64 *range_start,
 	return range_end - *range_start;
 }
 
+/*
+ * Clear the per-block dirty bits for the range [@off, @off + @len) within a
+ * folio.  The range is rounded inwards so that only blocks fully covered by
+ * the range are cleared.  This is required for operations like folio
+ * invalidation, where we must ensure a block is fully clean before discarding
+ * it.
+ */
 static void ifs_clear_range_dirty(struct folio *folio,
 		struct iomap_folio_state *ifs, size_t off, size_t len)
 {
@@ -200,6 +207,13 @@ static void iomap_clear_range_dirty(struct folio *folio, size_t off, size_t len)
 		ifs_clear_range_dirty(folio, ifs, off, len);
 }
 
+/*
+ * Set the per-block dirty bits for the range [@off, @off + @len) within a
+ * folio.  The range is rounded outwards so that any block partially touched
+ * by the range is marked dirty.  This ensures blocks containing even a
+ * single dirty byte will be included in subsequent writeback, preventing
+ * data loss when partial blocks are written.
+ */
 static void ifs_set_range_dirty(struct folio *folio,
 		struct iomap_folio_state *ifs, size_t off, size_t len)
 {
-- 
2.52.0

