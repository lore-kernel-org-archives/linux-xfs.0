Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8A9390C88;
	Mon, 13 Jul 2026 07:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783928248; cv=none; b=tNJ8bFjyLmpPbzvx+OrBdxygN2GB10t1Mf9grfIzxImERT1/kLISGnmYzVL5JsblG6Ef3ONhSvLyXMKszjLN8OJTiUUfAY0FXPK57f4wxNl7yJpw7Ytpy99C1YO6pigVWkQV3/k7kJpYkZiuzZfuTEDFNnMD++Pt/+g8H0DxK/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783928248; c=relaxed/simple;
	bh=Tsw6yRPAQOy2o/4VfW9sWy5urOj82gH/EQSPTX8v5VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmDBB+qNTDR67pirTNSM/8H9FoMd/JIXfkhHmqQQzuuVkNy317qfn0n+Ux5J9TRs+8SHe1zQSfQVepOUf1nCBi3PjB0zOjOUHKb7ksmVMW9juOsb/vhmFyTfxAnFk/QLRdo5xd0S5EyHsQamSjXqJ25WvKzpDN+x6t79+aFqWNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gzDm55csqzYQthf;
	Mon, 13 Jul 2026 15:37:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 02E004058D;
	Mon, 13 Jul 2026 15:37:23 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH1nKmlVRq7pA+BA--.39618S7;
	Mon, 13 Jul 2026 15:37:22 +0800 (CST)
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
Subject: [PATCH v3 3/5] iomap: fix incorrect did_zero setting in iomap_zero_iter()
Date: Mon, 13 Jul 2026 15:29:04 +0800
Message-ID: <20260713072906.1726059-4-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260713072906.1726059-1-yi.zhang@huaweicloud.com>
References: <20260713072906.1726059-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDH1nKmlVRq7pA+BA--.39618S7
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1UJr4fuw1kXF18uw4kZwb_yoW8Zw4Up3
	9xKayDCFn2qrW7uFn5JF9IvFyYkwn5JFW7Wr4UGwn8ZFs0vr4akr1FgayYvF1xJ34fA3WS
	yF4jy34xZF45CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7VUbpwZ7UUUUU==
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

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

