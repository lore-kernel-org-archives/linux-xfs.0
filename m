Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816AD3FA5EB;
	Tue, 14 Jul 2026 08:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784017913; cv=none; b=gc3b1FCv+AIcNHqe8P9VuA8ycT8xf1UCR4fe+RLKMqYdPbgn5VlbCBP5MVbprrBdRdf9XQxHAlM4361funskyXn2SGKllHmhqilj4H6iJyLTYbpZsa9cPs79GwxjirMHPS7+StszN/hTyLtZMF+SfHwdFLxixsC9Ifuu7kC97MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784017913; c=relaxed/simple;
	bh=pc9I7VwVtgC5EC5A549+JH90biQ7qKKttkL32luHcBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXex0bW3wVCgk5mXfbCcPthXQibOaoJX96JK3HraMTEQqkhN2iPh/3XcUy7FJCEKPWDJn6TrHuD4Pt+DLcYOGJGhke8AzjUIQQRsvNyCT0WfQX74lWf94fJeZ1et+vw7H2O6wfRj/TPjlndg/7x0Xb05lZ65GgcPK+E7jllI8as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gzsvz4nHKzKHMP8;
	Tue, 14 Jul 2026 16:31:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 092E140592;
	Tue, 14 Jul 2026 16:31:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH1nLl81VqTRS8BA--.57256S7;
	Tue, 14 Jul 2026 16:31:41 +0800 (CST)
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
Subject: [PATCH v4 3/5] iomap: fix incorrect did_zero setting in iomap_zero_iter()
Date: Tue, 14 Jul 2026 16:23:23 +0800
Message-ID: <20260714082325.325163-4-yi.zhang@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgDH1nLl81VqTRS8BA--.57256S7
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1UJr4fuw1kXF18uw4kZwb_yoW8uw4Dp3
	sxKayDCFs7XrW7uF1kJF9IqFWYkw1rJFW7Wr4UGwn8ZFs0vr4akr1FgayFqF1xJ34fA3WS
	yr40ya4xZF15CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVF
	xhVjvjDU0xZFpf9x0JUHWlkUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

The did_zero output parameter was unconditionally set after the loop,
which is incorrect. It should only be set when the zeroing operation
actually completes, not when IOMAP_F_STALE is set or when
IOMAP_F_FOLIO_BATCH is set but !folio causes the loop to break early,
or when iomap_iter_advance() returns an error.

This causes did_zero to be incorrectly set when zeroing a clean
unwritten extent because the loop exits early without actually zeroing
any data.

Fix it by using a local variable to track whether any folio was actually
zeroed, and only set did_zero after the loop if zeroing happened.

Fixes: 98eb8d95025b ("iomap: set did_zero to true when zeroing successfully")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index aeeed6316cf9..7f77a1f68160 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1542,6 +1542,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		const struct iomap_write_ops *write_ops)
 {
 	u64 bytes = iomap_length(iter);
+	bool zeroed = false;
 	int status;
 
 	do {
@@ -1560,6 +1561,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		/* a NULL folio means we're done with a folio batch */
 		if (!folio) {
 			status = iomap_iter_advance_full(iter);
+			if (status)
+				return status;
 			break;
 		}
 
@@ -1570,6 +1573,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 				bytes);
 
 		folio_zero_range(folio, offset, bytes);
+		zeroed = true;
 		folio_mark_accessed(folio);
 
 		ret = iomap_write_end(iter, bytes, bytes, folio);
@@ -1579,10 +1583,10 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 
 		status = iomap_iter_advance(iter, bytes);
 		if (status)
-			break;
+			return status;
 	} while ((bytes = iomap_length(iter)) > 0);
 
-	if (did_zero)
+	if (did_zero && zeroed)
 		*did_zero = true;
 	return status;
 }
-- 
2.52.0

