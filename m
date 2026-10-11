Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AB323ED6A;
	Sun, 11 Oct 2026 17:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738641; cv=none; b=dmcl78HIX1fVGdG4IU8sH84EXMjiVbMZmR996xoFCkVy1V/7gdXQpwFaYd5NoK421hNmImidWUZGmjCIw8Q4MjfcEN8eOrUWSWacl0T7kAnewKPhulOPpLEdceGyPe4RU5Fytic+5EAPcN9JEb+fgvoD8gCKtwyTcbUGiCzxknU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738641; c=relaxed/simple;
	bh=mWgpJiSaZBn8LrONE9dJ4B6yQjVBUZLG5mkaJnICzvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAQPm0Ue/4chx2/Xz/Nl5GVnHSlr2gRzGuD1REw99rUUSAbx3LD6NodUSb4VcKSCfbzM8lnVpxN78SxO6xL2/GE7ngJRxKD0chmPUq3T51LBNPXSi8Z6CcK3NbK+Lqjdbi3/mnLwq/2y+MbdA3HBlhAUYNELTS2wOqhdIXqiWU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aqSaOYb9; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aqSaOYb9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738629; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=pP/654PDHhmtWqPouuapJaaInSP5pLa6Kxj7C8ScfwI=;
	b=aqSaOYb9lE4kCTC9/puWScNeLaBsA7nn/dsTjL9T5oYwPPinIB3DRTM4CD0EKpHYZCkYRz1aXPYQ3tXqSBjbkRMa17MNHcVBZIJlYhnoH2Z6ySVi5CaWbodsheIDieAb7bA3fOXgFLxjXJUa8P0Ea4YoVivMrf4vOap/czhl6rM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCYQXUC_1791738626;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXUC_1791738626 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:27 +0800
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
Subject: [PATCH 01/13] ext4: refuse encryption when block size > page size
Date: Mon, 12 Oct 2026 01:09:46 +0800
Message-ID: <20261011170958.1759230-2-libaokun@linux.alibaba.com>
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
than the page size, and commit 709f0f1f1bf5 ("ext4: add checks for
large folio incompatibilities when BS > PS") added a check to refuse
mounting such a filesystem.

However, it is also possible to enable the "encrypt" feature on a
filesystem that is already mounted (with tune2fs -O encrypt). Once
that happens it won't be possible to mount the filesystem again in
the future, but there is nothing preventing the user from setting an
encryption policy while the filesystem is still mounted.

Fix this by refusing to set an fscrypt context in ext4_set_context()
when the block size is larger than the page size.

Fixes: 709f0f1f1bf5 ("ext4: add checks for large folio incompatibilities when BS > PS")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Alberto Garcia <berto@igalia.com>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/ext4/crypto.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 1a0fccb084ef..318b2eaea741 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -156,6 +156,15 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
 		return -EOPNOTSUPP;
 
+	/*
+	 * Encryption is not supported when the block size is larger
+	 * than the page size.  This is rejected at mount time by
+	 * ext4_check_large_folio(), and this check here is for the case
+	 * when the 'encrypt' feature is enabled on a mounted filesystem.
+	 */
+	if (inode->i_sb->s_blocksize > PAGE_SIZE)
+		return -EOPNOTSUPP;
+
 	res = ext4_convert_inline_data(inode);
 	if (res)
 		return res;
-- 
2.43.7

