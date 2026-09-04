Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070C8419FB0;
	Fri,  4 Sep 2026 06:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502437; cv=none; b=psRNiLV+D1q3mqVYG4xbNSQyCMT7YokH3BlmFHds7Dr+UjBso1UW+3i+CJxUunIjwztcoAWOkj77TiDFx8HrmIFXa0rn7IlBGtPMV+I3MNaRVSYEQjWQsgEpIzXFhMx611XUyPasiwAJlNBhyAM9XQFDXX+FgG3L+O3/doamxec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502437; c=relaxed/simple;
	bh=/DLlz09o7G5yTC/pdR4ntqZXukfqSChR5QrE3u4iNmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSGGkfUG4f9Bf2OzewkpkBlo8Q7PGHOpTXZvYJ1JeoroyrOnNWnVV+kqA8bvzpwg4IcVCw2hqSM/xvnHxm7+e084ggTwF1QRGKcdng0bITnGz1Xx8PBamgQScRFfqZLZoSWnqWNhViXn+TJPMbZd8k5O1GLp5Sn9oN66pVkTAhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbmNh2d8CzYQtyH;
	Fri,  4 Sep 2026 14:13:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 7D17340DD8;
	Fri,  4 Sep 2026 14:13:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCHbwqeYZpqTb3FAg--.50434S7;
	Fri, 04 Sep 2026 14:13:52 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: cem@kernel.org,
	dgc@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH 3/5] xfs: remove unused xfs_buf_iodone declaration
Date: Fri,  4 Sep 2026 14:06:46 +0800
Message-ID: <20260904060648.1966130-4-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260904060648.1966130-1-wozizhi@huaweicloud.com>
References: <20260904060648.1966130-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCHbwqeYZpqTb3FAg--.50434S7
X-Coremail-Antispam: 1UD129KBjvdXoWrZrW7Kw1xtw45JF17tw1fJFb_yoWDJrX_K3
	y3Kr4Sqa4UJry7Aw47Gr4vqFyqqa1xCan7CayUAas0qw12q3ZYvrWDAFyUZr9Ig39xJr1f
	Ja45WrWjgr9FyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTAYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r1rM2
	8IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F
	4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUFF4iUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Commit 664ffb8a429a ("xfs: move the buffer retry logic to xfs_buf.c")
removed the xfs_buf_iodone() implementation and its last caller in
favour of xfs_buf_ioend_finish(), but the declaration in xfs_buf_item.h was
left behind. It has been a dead prototype ever since (2020).

Remove the stale declaration.

Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 fs/xfs/xfs_buf_item.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 3159325dd17b..28c79989d725 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -60,7 +60,6 @@ static inline void xfs_buf_dquot_iodone(struct xfs_buf *bp)
 {
 }
 #endif /* CONFIG_XFS_QUOTA */
-void	xfs_buf_iodone(struct xfs_buf *);
 bool	xfs_buf_log_check_iovec(struct kvec *iovec);
 
 unsigned int xfs_buf_inval_log_space(unsigned int map_count,
-- 
2.52.0

