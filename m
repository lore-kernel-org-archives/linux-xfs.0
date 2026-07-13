Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF09395AD3;
	Mon, 13 Jul 2026 07:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783929032; cv=none; b=fzqdlvcnSrovYvbZVw+7LdlAx1/ciT+J5M/L3uCOI6Y2hI9uDL71g+W7N9+Pm7uDu39y1Sga8DE1vha3gyNtgk5roel7ggwZ4EeAxQ7vyHBZxD9AGQ7snenOIoRr3tT1mMQxR2kL5OIoA/ZwOgR7I5pYluZeeSUrr1kGKuUeWLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783929032; c=relaxed/simple;
	bh=pBbRs+BjEMjWLAhBX8qC6H7FhVNneji2nFSMJWMSKUM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MW7i04yGaTpQzAa3e/vP2Oi15u4ADBB+CZBlz6WXEDgVzbA76gxb6SY7bXn/Y3q8zltJgDGr5vFrNSV/G/8FrSfelKNO5Lc7G+xnJm6wUJuVg9Mdt1kHH3KJ3xFPDotrW0BPe3biL6bKRZHL/qZBvulwP2m2CsIVH1bVt9jxZjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gzF2n6pDDzKHMKl;
	Mon, 13 Jul 2026 15:49:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A9D434058C;
	Mon, 13 Jul 2026 15:50:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCXpnKymFRqLqY_BA--.39685S4;
	Mon, 13 Jul 2026 15:50:22 +0800 (CST)
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
Subject: [PATCH] iomap: prevent ioend merge when io_private differs
Date: Mon, 13 Jul 2026 15:42:06 +0800
Message-ID: <20260713074206.1768006-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXpnKymFRqLqY_BA--.39685S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKFW7KF1UKryrJw4DKF4kWFg_yoWDWFXEy3
	WkW3s2kr48JFWY9ryxArWIgF9rCr1UJr48X348Kry3urnFv3yxtFnY9r93Gw4kCF4Ika1x
	Aay5J3yYkry7ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUba8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr
	1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VU13ku3UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Different io_private values indicate distinct completion contexts that
must not be merged together, as this could leak or corrupt the private
data associated with each ioend.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
This is one more change for the ext4 conversion.
Disscussion Link:
 https://lore.kernel.org/linux-ext4/81f4c0ec-1d80-4987-b31e-4e9ecd394c63@huaweicloud.com/

 fs/iomap/ioend.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index acf3cf98b23a..ba59570c0926 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -380,6 +380,8 @@ static bool iomap_ioend_can_merge(struct iomap_ioend *ioend,
 
 	if (ioend->io_bio.bi_status != next->io_bio.bi_status)
 		return false;
+	if (ioend->io_private != next->io_private)
+		return false;
 	if (next->io_flags & IOMAP_IOEND_BOUNDARY)
 		return false;
 	if ((ioend->io_flags & IOMAP_IOEND_NOMERGE_FLAGS) !=
-- 
2.52.0

