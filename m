Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1057434EF0C;
	Sun, 11 Oct 2026 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738641; cv=none; b=SiNUpojBzlTLX523qpuuwF8OjGtWj+WqP4LDdUNEoJjCArM/I48rUHunRFezZmqnRml98TNwcjc1Pg/6XPxPMfKRFYihLedblOEstJr/f342j052QlXx8+ELmC0UPRsW2mnd6b3xDwz+LjW/yFgrNXBV/DgIg52zhpjPDqQwK2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738641; c=relaxed/simple;
	bh=TId0VsIIAvCdtW0MT3i7/FkFBCFkp6P0dPHKkhqfqrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1i8E5vHKFa8VVRNvPtJx4Tyr2DvV6noMX1uF0q9vxhuKuyNQPXN8pP6qQgr2sEt9SX3PyuUcieSgxCbaF0U9GQUKtX4VRFgZW6lszvSkiaT7Pxxz5mWOWrzSZS5myOfPIRyZstLNjuEdb503JKqChwyKA9kJXovzm9LWevF3QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=m06PDrKj; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="m06PDrKj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738630; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Qy7kjPBuxr6DOsJ57dabGFPpnblsY+efTVLGxwuRco8=;
	b=m06PDrKjOyW53tWKkcpSi6m29wSjrgOwkf0+HMN8wowmz49hW6e407DeY0h6ujDC2oaE4HFq0qZfr1I4A4i/f5RNbZBK6cX44kDf2J3n4IPUM87qdxbSzXHi4H+OsT/K+CLBvIF1Ayg3+/pvCgjqBa14tvQjA4x8gAecGRtiT1I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCYQXUW_1791738628;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXUW_1791738628 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:29 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ebiggers@kernel.org,
	jaegeuk@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	djwong@kernel.org,
	brauner@kernel.org,
	tytso@mit.edu,
	berto@igalia.com,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH 02/13] ext4: reject encrypted inodes when block size > page size
Date: Mon, 12 Oct 2026 01:09:47 +0800
Message-ID: <20261011170958.1759230-3-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
References: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alberto Garcia <berto@igalia.com>

Encryption is not supported when a filesystem's block size is larger
than the page size. ext4_check_large_folio() refuses to mount a
filesystem like that if the "encrypt" feature is already enabled, and
ext4_set_context() refuses to create encrypted inodes if the feature
is enabled after mounting.

However, a corrupted or hand-crafted filesystem can still have
encrypted inodes even if the "encrypt" feature is not set, and those
inodes can be unlocked if they're using v1 policies.

Check this in __ext4_iget() and reject them as corrupted.

Fixes: 709f0f1f1bf5 ("ext4: add checks for large folio incompatibilities when BS > PS")
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Alberto Garcia <berto@igalia.com>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/ext4/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26f0f9714f03..31248fef8bce 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5671,6 +5671,12 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
 	}
+	if (IS_ENCRYPTED(inode) && sb->s_blocksize > PAGE_SIZE) {
+		ext4_error_inode(inode, function, line, 0,
+				 "encrypted inode with block size larger than page size");
+		ret = -EFSCORRUPTED;
+		goto bad_inode;
+	}
 
 	ext4_set_inode_mapping_order(inode);
 
-- 
2.43.7

