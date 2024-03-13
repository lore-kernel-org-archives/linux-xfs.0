Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8718A22071;
	Wed, 13 Mar 2024 20:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710362308; cv=none; b=obOIvrqSi+S9dLAwU29v1L5sYbuf6+HzoLeXeUvEEtGqly95FUDCE7rkq6nH+B1upL4+8vguKbTS7nE50yZv4eXOSJAHu0S8EYkuD5wvTsAPkL9LUnVgaPrEvidNM9ajxbDY8PtSJkMw/1Hzs7ToSa3KBfU4V3Z6h6dKd1hQybg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710362308; c=relaxed/simple;
	bh=DOgEKBoPtja17MkZZ+RaTWVd+mk8fXIApEPm224DWPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YT8gdLHBDpLoKzzA3AwmfkIfYhWOuudpLeFfon79SmqGjMIut28FQBnexVONhFRB23+6dtpd0DJRY34lJYLg5CNIyw6Kr1ZeIjaUzONgGIeE+//MkasFKy02dh06bv8JoCHF92N26CYp01Oa8NLvapSnqOkCEbho7Oy5QlpzHVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=YtfRkkxZ; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="YtfRkkxZ"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4Tw2Qj35Cnz9spF;
	Wed, 13 Mar 2024 21:38:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1710362301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jBVMMbKg44qa1I9vQfP5N4/miUCY6magYeOwG0Cym+c=;
	b=YtfRkkxZFRGVTGzeo2TGVK2ntvhgj9AlnHhIG8rvS6rDxTVd6mrJtscDmrWex/R9+jmqvS
	8lH2Kzqs/MPANhTCB0ZPMhk2RaqzTOn8KDZjg+SIUp9Vmx0yqTYGJJI2jLj0GYaDkR4di7
	KyecvE637gq5pinTAv00FlLu/dV4NCnAb1YFjdBtxbdXZcGVsuXJKQvMnXntrhvoo8PbxM
	WQGZofXEqDFGgNkERKRxFkepx2DiZLltw+t2pQLdSsLoJ24tzbDyI9BQ+qEq8PuNAKhMO7
	DMrV43sUYSYUNZLH3gDRFK80h+XPmUELoSw44FNUHsmTAFWz9Qh+Mev0Zpz9LQ==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: fstests@vger.kernel.org,
	zlang@redhat.com
Cc: djwong@kernel.org,
	p.raghav@samsung.com,
	linux-xfs@vger.kernel.org,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH] xfs/558: scale blk IO size based on the filesystem blksz
Date: Wed, 13 Mar 2024 21:38:18 +0100
Message-ID: <20240313203818.2361119-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4Tw2Qj35Cnz9spF

From: Pankaj Raghav <p.raghav@samsung.com>

This test fails for 64k filesystem block size on a 4k PAGE_SIZE
system. Scale the `blksz` based on the filesystem block size instead of
fixing it as 64k so that we do get some iomap invalidations while doing
concurrent writes.

Cap the blksz to be at least 64k to retain the same behaviour as before
for smaller filesystem blocksizes.

This fixes the "Expected to hear about writeback iomap invalidations?"
message for 64k filesystems.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Tested-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/558 | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/558 b/tests/xfs/558
index 9e9b3be8..270f458c 100755
--- a/tests/xfs/558
+++ b/tests/xfs/558
@@ -127,7 +127,12 @@ _scratch_mount >> $seqres.full
 $XFS_IO_PROG -c 'chattr -x' $SCRATCH_MNT &> $seqres.full
 _require_pagecache_access $SCRATCH_MNT
 
-blksz=65536
+min_blksz=65536
+file_blksz=$(_get_file_block_size "$SCRATCH_MNT")
+blksz=$(( 8 * $file_blksz ))
+
+blksz=$(( blksz > min_blksz ? blksz : min_blksz ))
+
 _require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 # Make sure we have sufficient extent size to create speculative CoW
-- 
2.43.0

