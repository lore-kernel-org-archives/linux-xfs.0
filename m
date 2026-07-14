Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B1A3FBB7E;
	Tue, 14 Jul 2026 08:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784017919; cv=none; b=tFZQVGUFVSFdnNLWkT6ZoAD45jBzj3ZH8Y8A5lXnl4CeS6aV66yz/omsOdYIx6fTcwIZj3BGfETER2rWOZImw4MjLcSLZAueus4GiLQ2FvfLFp1+JCDrgD8psNu0ayLqDC5M3mGpuZzat46YJkwRUW03+qJCycXxDQ/9oqlNzCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784017919; c=relaxed/simple;
	bh=mIpMt/nd0CbxXQB1BqNm7V/SHfXY7VyxtInjVCbXVMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7hcjLZYxe+hbhXQJuyMSvbihFft6aRagK59SjwrTKlur2i9VNRFLYQAAOuZ368hQamDw+m7vHCEPHWFenxPS5qM9yv3XrxQwsw+wOzkb3t0wDtt0YQJKQnKG3MR1/YlFuykNNIQ1E891KruwF2G4KY+Sz6V3b6YbDKMjsd6QJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gzsvz5G1gzKHMNr;
	Tue, 14 Jul 2026 16:31:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2588B408C6;
	Tue, 14 Jul 2026 16:31:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH1nLl81VqTRS8BA--.57256S9;
	Tue, 14 Jul 2026 16:31:42 +0800 (CST)
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
	chengzhihao1@huawei.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v4 5/5] iomap: add comments for ifs_clear/set_range_dirty()
Date: Tue, 14 Jul 2026 16:23:25 +0800
Message-ID: <20260714082325.325163-6-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
References: <20260714082325.325163-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDH1nLl81VqTRS8BA--.57256S9
X-Coremail-Antispam: 1UD129KBjvJXoW7CFyUZF4fZryDJFWDCF1xKrg_yoW8Zw48pF
	43K3yDKr4DWrs7u3W3WFW5A34Fqws3XFWfGFWxGwnIga15Ar9rKF1DKa109Fy8KryxJFnY
	kr1j9a4FgF1UAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
	1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The range alignment strategy differs between ifs_clear_range_dirty() and
ifs_set_range_dirty(). The former rounds inwards to clear only
fully-covered blocks, while the latter rounds outwards to mark any
partially-touched block as dirty. Add comments to document this
asymmetry in block range calculation.

Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index a356efbae6b0..c12237ed7cde 100644
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

