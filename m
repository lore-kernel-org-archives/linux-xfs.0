Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0702D415F29;
	Fri,  4 Sep 2026 06:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502439; cv=none; b=B/uosdicEb8QJsSrqtjjBFLbb4nx220mLDH4hmRRjQydihHn6iKh35rTo5AP7lZpQVco+5kmxiIx7QgBaM3+h6WwhCnDaTkMzoLgwwV93446Bah1AmEsNE1EQNnFnpYQ5NpfuzzpsBO/5q3u2mK8WxQw4FHhZhFAAisFX5t+H7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502439; c=relaxed/simple;
	bh=pUoh/92+pS2sxovDzdzoh4Ltpb6Q6JWLld4HMmwYZGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6Natyu8UC0Rs7MBX6EC9erQ8ZRLQbYZDMMbhgOcElP2Dwhor0vDk3u6rPRLR0zMsRVCJfmiuOrGw2vftNSCSKoMLBMdEsHEFtxumuMu6J+pIjGQlqM5Boov/MVKXwMwe93HvhYR5HG1S6A8LBNfNwjBfQjiS6yO4C4mo18Xwqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbmNh4L73zYQttq;
	Fri,  4 Sep 2026 14:13:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 8520940DCE;
	Fri,  4 Sep 2026 14:13:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCHbwqeYZpqTb3FAg--.50434S8;
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
Subject: [PATCH 4/5] xfs: remove unused kmem_to_page helper
Date: Fri,  4 Sep 2026 14:06:47 +0800
Message-ID: <20260904060648.1966130-5-wozizhi@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgCHbwqeYZpqTb3FAg--.50434S8
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4DurykJF45Zw1fKw15Jwb_yoW8JFy7pF
	n3Ww1Ikr98Wr1jkw1DJw40v3yYkws2kr4rAws3Gw1Iva45Zr1a9ry0qFyrWryjqrZ293yU
	ZF43tryUZw4Yv3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I
	0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU1aLvJUUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Commit 5ced480d4886 ("xfs: simplify building the bio in xlog_write_iclog")
switched the log I/O path to the bio_add_virt_nofail and bio_add_vmalloc
helpers, removing the last caller of kmem_to_page(). The helper itself was
left behind in xfs_platform.h and nothing has referenced it.

Remove the stale helper.

Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
Note: this helper was only recently orphaned by 5ced480d4886 since 2025. If
it's intended to be kept for upcoming bio/vmalloc work, please just drop
this patch.

 fs/xfs/xfs_platform.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
index 59a33c60e0ca..5d542e95fe44 100644
--- a/fs/xfs/xfs_platform.h
+++ b/fs/xfs/xfs_platform.h
@@ -289,15 +289,4 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 # define PTR_FMT "%p"
 #endif
 
-/*
- * Helper for IO routines to grab backing pages from allocated kernel memory.
- */
-static inline struct page *
-kmem_to_page(void *addr)
-{
-	if (is_vmalloc_addr(addr))
-		return vmalloc_to_page(addr);
-	return virt_to_page(addr);
-}
-
 #endif /* _XFS_PLATFORM_H */
-- 
2.52.0

