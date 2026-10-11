Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C44348445;
	Sun, 11 Oct 2026 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738665; cv=none; b=Tuok9YNeMXR8/rZ+xV2lpDvQUfJbDggIdm/hSPGCVErDzxcUktkSavMODsZFpsL6nWI5E68O8Wqyq4IdWBta/XMs951xyJrPtiMmZMKKGYxP/8Q6e8cZst5uVhIoZ63WMh9sLIWndrvp4wrYS5muL/x/BPCtpMyqwUcrDoRyee4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738665; c=relaxed/simple;
	bh=+rARsB6qbJMD+EqSp3kNWjX4INkebtLZwP8y3c1zRlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/f6hMFz4xf/fMvd231jfjf6OheC/zdyBKxeQ1yTxg6ntdm32dszr/yzUFqEyyin4wqEfZuKk8Rrez4VPL6bWSKnKcufwWxO8nFcVd9eftRjSwc9IqB3cHw9u7OqLM3Wkw3kgjVuGTynzqrlGeNDAEmbClUlIFDTchsG5+Kctw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lp8XF2az; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lp8XF2az"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738645; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=6QTfjxNJiEIz7iir6m8FkfgBMO2ZQ0s5GMO5wK8WRoQ=;
	b=lp8XF2az39yIXaosKYkKMj9MA9foSj8U1A4dNoFqY+v12XXCRblxuHBMiBvnYzKv+XTn2owQS4aeqcapKlc7YIpr3mmuhRBvKtYKQGPjs8yPhoDc1lk8iAyRI6o2QNyMscswExpm7KDqqWWqs7C7NFyDW5epOFReOGAq/kEYyZk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCYQXYX_1791738643;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXYX_1791738643 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:43 +0800
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
	ritesh.list@gmail.com
Subject: [PATCH 13/13] ext4: allow large folios for encrypted files
Date: Mon, 12 Oct 2026 01:09:58 +0800
Message-ID: <20261011170958.1759230-14-libaokun@linux.alibaba.com>
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

Encrypted filesystems keep their folio order at s_min_folio_order,
because the read path could not handle a folio that covers a data
unit number wraparound.  The read path now sends such folios to the
buffer_head based path, so drop the restriction and give large folios
to all encrypted files, including the ones whose block size is not
larger than the page size.

Writes and direct I/O don't need the same treatment: ext4_writepages()
checks fscrypt_mergeable_bio() for every block, so a write bio never
spans a wraparound, and the bios of direct I/O are cut at the block
size.

Performance:

Hardware: 96-core machine, 3.84T NVMe, 512G memory
Filesystem: ext4 with a 4k block size, encryption on the fallback path

Buffered sequential writes (1G, fsync) in MiB/s; medians of 3 runs.

  bs      Before     After    gain
  ----    ------    ------    ----
  4k        1118      1162     +4%
  16k       1260      1756    +39%
  64k       1272      1977    +55%
  256k      1308      2081    +59%
  1M        1260      1455    +15%

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9cd5b7445a27..a788613a53a4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5116,8 +5116,7 @@ static void ext4_set_max_mapping_order(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ||
-	    ext4_has_feature_encrypt(sb))
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
 		sbi->s_max_folio_order = sbi->s_min_folio_order;
 	else
 		sbi->s_max_folio_order = EXT4_MAX_PAGECACHE_ORDER(sb);
-- 
2.43.7

