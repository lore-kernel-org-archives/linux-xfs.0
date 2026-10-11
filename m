Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED161361DBE;
	Sun, 11 Oct 2026 17:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791738652; cv=none; b=ngp95Zu24BB90i5G5zmCj6GFuBJhy3SiyhbF1bMORq0j4trNASJuTKJk3XGgKzulEIuavRn5n1u8xOrhPPSyNkjc+D2am686uILRNniMnsSp7NcChPPCQF8+DsFfuvw1POJiLcKy65JCS85Omu7qmU7yLNDDhMGuOnkSXZUSdyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791738652; c=relaxed/simple;
	bh=pk/r4t0Dyj1tlXJ2WYwXDPfkRrhtelBOfLP1fG3ROsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmdD5egKqrqd3O5+95Et8luErF2IdmQXdmn7SpHEULIn6ykv2PjP2tPhDFvSAXdRuUQNLmKwaaMGrhMtjTC4lYY/ccRZE2LZ7/NFrrj4hvf13O4ByDYiw1ApIGdNVVFNceeArMwxbLY4poPf3/HmYNoCKR7KDkkWQcBM1KlQozI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hAzT3PdE; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hAzT3PdE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791738637; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=LHrUn38589OnzuWoSWak524/zuLAm7XpK2v12HcTpK4=;
	b=hAzT3PdESZlaSP28AsZiRn185IF10e0hbQc6/QVBZr4WGNJps5+YXdBFpLLJ3Az3VtUq2xB6RByRo7MxjK/3Lmwt42NauUkw5clLzUsy851+K7SRbFOkV7YUfoJNzCjRkWCB1WrMZRCntD+gSWAHBb/ff/gNsSvYHzr1B9NVqCo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0XCYQXWT_1791738634;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCYQXWT_1791738634 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 01:10:35 +0800
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
Subject: [PATCH 07/13] iomap: align the direct I/O bios of encrypted files to the block size
Date: Mon, 12 Oct 2026 01:09:52 +0800
Message-ID: <20261011170958.1759230-8-libaokun@linux.alibaba.com>
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

A bio that carries an encryption context must cover a whole number of
data units: its data unit number is generated from its first data unit
(see bio_crypt_set_ctx()), and it is only split at data unit
boundaries.

iomap attaches the encryption context of an encrypted file to the bios
that it builds for direct I/O, but it only cuts them at the logical
block size of the device.  A bio ends where the bio_vecs that fit into
it end, not at a fixed number of bytes: the extraction stops when the
bio is out of bio_vecs or when the iterator is exhausted, and a
bio_vec can cover a whole folio.

A bio can end in the middle of a data unit, and a data unit that is
larger than a page makes this reachable without any misaligned input
at all: the extraction then stops in the middle of a folio, and a cut
at a page granularity inside such a data unit is not data unit aligned
even when the position, the length and the buffer are.

The fallback rejects such a bio once it reaches the block layer: one
of its bio_vecs is not data unit aligned, so a direct I/O that should
work fails.

By contrast, the equivalent check on the hardware path lives in the
splitting code, which a small single segment bio skips, so a bio that
starts in the middle of a data unit can reach the hardware without
being rejected.

Fix this by cutting the bios of an encrypted file at the block size,
like the IOMAP_DIO_FSBLOCK_ALIGNED flag does for the filesystems that
pass it.  fscrypt rejects a data unit size larger than the block size,
so a bio that is cut at block size boundaries covers a whole number of
data units.

This also makes the file systems that don't pass the flag follow the
contract, e.g. f2fs, which passes direct I/O that is not aligned to
the logical block size of the device on to iomap expecting it to fail
with -EINVAL, while iomap checks only the file position and the
length, so such a request can reach bio submission.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/iomap/direct-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 8b4039d16ce8..9b6cdf04dced 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -410,6 +410,16 @@ static inline unsigned int iomap_dio_alignment(struct inode *inode,
 {
 	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
 		return i_blocksize(inode);
+
+	/*
+	 * A bio of an encrypted file must cover a whole number of data
+	 * units.  The data unit size of an encryption policy never exceeds
+	 * the block size, so cutting the bios at block size boundaries is
+	 * enough.
+	 */
+	if (IS_ENCRYPTED(inode))
+		return i_blocksize(inode);
+
 	return bdev_logical_block_size(bdev);
 }
 
-- 
2.43.7

