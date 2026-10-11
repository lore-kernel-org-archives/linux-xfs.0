Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D7B1799F;
	Sun, 11 Oct 2026 17:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738651; cv=none; b=EzQWFJ7GNYJOV1Lh+7FXH0aDjaTgAH/Eb5bNG/Ny4eW17BboMq0sQGpCk+J1HUUuqF8OUIKg6anzoJkaFdLgJHoLcyAGvpr0fs7dW5Gc3hBZSvpfuwLUwcMFqwROesPzTlvNRy/pegSSu9EODbPUDtJv3Jrim+bJasIG/9JMis8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738651; c=relaxed/simple;
	bh=tMh17T2lfSfDB4jySMADL4BHLYBllXZmqDk1Sh5gLKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObmgqgjZK4b5ndURbTyXFYR2hixawf5zV0ehI0tytxPYRH2BfZ2Jq7LuAtgStRCmvyUW9UfEE2OJmlFYyvUM9bX1Uc/ew8ETWvddiEuxPpub0tsyXjnPof6Jr8NWtAFUpbxINDOqVc9Fri11itgaZoIPKV1edMpYqExKLWvhmbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tCmR19rh; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tCmR19rh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738644; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=MNHvpV3essq4tUhV6VcEgoNvT0qhWCnVrQakDvUXdEY=;
	b=tCmR19rhf8xzltI1GfL6ZDrnF4N3mXKagyBHgcLpWk9tWrKZX8CgqRZsHFfILRP4wEs6kWy5EBo+EOyoO08LOmckAsJznUkMySsPLnPGaOAuE01fER6uo5p8AIw7uA7bDmbqIPsEKMdkQ20CCQ8MBb9KzX5cfEi9ST46tx3qmyI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCYQXYB_1791738641;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXYB_1791738641 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:42 +0800
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
Subject: [PATCH 12/13] ext4: send folios that cover a wraparound to the buffer_head path
Date: Mon, 12 Oct 2026 01:09:57 +0800
Message-ID: <20261011170958.1759230-13-libaokun@linux.alibaba.com>
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

ext4_mpage_readpages() puts a whole folio into a bio with a single
crypt context, taken from the position of the folio, and blk-crypto
increments the data unit number for each data unit that follows in
the bio.

By contrast, fscrypt truncates the data unit numbers to 32 bits for
IV_INO_LBLK_32, the only supported IV generation method whose data
unit numbers wrap around within a file.

The blocks after a wraparound inside a folio are then en/decrypted
with IVs of 2^32 + i instead of i.  fscrypt_mergeable_bio() only runs
between folios, so nothing catches this.

This is reachable even without a block size larger than the page
size: when a filesystem is mounted without the encrypt feature,
ext4_set_max_mapping_order() does not cap its folio order, and
enabling the feature on the mounted filesystem does not change that.

The encrypted files of a policy that is set up afterwards then get
large folios, which can cover the data unit number wraparound of the
file.

Fix this by sending folios that cover a wraparound to the buffer_head
based path in ext4_mpage_readpages(), which creates one bio per block:
fscrypt_limit_io_blocks() tells whether the wraparound falls inside
the folio's blocks, and only the folio covering it takes the slower
path.

At most one folio per file is affected: the extra cost is a
buffer_head and a bio per block for that folio, and the block layer
merges those bios back together.

Fixes: 709f0f1f1bf5 ("ext4: add checks for large folio incompatibilities when BS > PS")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/readpage.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index c7b6cdb2e124..0c0dfaac6ded 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -264,6 +264,17 @@ static int ext4_mpage_readpages(struct inode *inode, struct fsverity_info *vi,
 			folio_set_mappedtodisk(folio);
 		}
 
+		/*
+		 * A bio's data unit numbers are derived from its first data
+		 * unit, so a folio that covers a data unit number wraparound
+		 * would be encrypted with the wrong IVs.  Only IV_INO_LBLK_32
+		 * can wrap; route such folios to the buffer_head based path,
+		 * which creates a bio per block.
+		 */
+		if (fscrypt_limit_io_blocks(inode, pos >> blkbits,
+					    first_hole) < first_hole)
+			goto confused;
+
 		/*
 		 * This folio will go to BIO.  Do we need to send this
 		 * BIO off first?
-- 
2.43.7

