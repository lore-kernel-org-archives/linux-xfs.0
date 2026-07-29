Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3C738AC7D
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 02:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293714; cv=none; b=ANqjS7WDJJDI35S5kYFefipBtunE3iF2AtfjKougETfKxW+xGJjXBABpCacBlHh5bLkoKmiWZA3/IRRm+YOcshaLd4JxEmSDELdkmJM9U2yNUw7if5ovL6yVLt5VaAn8KFcVGZTz5y3iIyl19LBbLNQKKDOLJHzqBRiOIOZGzCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293714; c=relaxed/simple;
	bh=9sx8KpJQ8zZQIkq2TbqTseJ6M3MToG8lQm26RBQHbHc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hdsRogeYLukZbCkGCoOPWTo0ZjIyisUqmhSVbLKXXMIdu6FAF0xnzWS13KgRpwhCggb8RSChnNWjDAK4KrIN/VhbjR5BLIlKaJV/IWJOrtKdvbPm9MZabc9rNxDTBzpqTHfyAGI1rbFGVFe5OQzcxRCboa/cPuFkmjsx/600Uqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ob7aGGxV; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ob7aGGxV"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cce6a0c9c3so6761095ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 19:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785293712; x=1785898512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eXPU/pRau728ab5U6cQmQyA1jJ+oymXCadSZuiVyCcg=;
        b=Ob7aGGxV/iN17P+Zh1fvCj0WZif1NW5tAwx6C1X9Gv3+aPW2cINQYBWTyYEO/R/F77
         iuZSQGJc7BjwCd9o7ZHoQxlFIEo76pE/O0IYnTcGIE8/fwXtfoNCHVjg83YoaWQsD+rS
         j1kaVasv3jQDlaTKjhhgAyrxjA7diQJhzM9Y+3IKB7ZCyRzxgNEfEA5Lm4UA8z7FIcLF
         Jpu1Ia62tbrXQp+rkfQ87dWMBrsTdnJZIX2FkGqJcyUhBxSVIejnPuNXmOAASb4T3kn/
         8KLGXNNx0pM1bIZluFZm0Xjwp5xrCtEwwLuLlzKCUoBK01lD2hNqEwG7E4B6QyJW/kx9
         mlaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785293712; x=1785898512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eXPU/pRau728ab5U6cQmQyA1jJ+oymXCadSZuiVyCcg=;
        b=mX8ZK+E3h8PXWEoNSwS+747HiwOh9iU1hXMYtt1W6+zmieFDGXurMiG7zvSnDtbcYC
         GU17Xuj4RBLkkil2Bzz5iGW9cpKcnxdbDcBiPxzLYPVYFWIG4AkzpJKsHYtQA0jSfQ9Q
         6y1yJP0W7XR0cyTQJBxQsorAUwWNveCJ6zQYvL9R6yDb+vF2gV09eylbwFNszWehTGwM
         pwkOibkpvSda5VRPzeHLw7Kvf7ZOUbNCPTuakyWdozMt5zOl78dpjcg9pyW1k6n3d7uL
         Lgirx/xaMgvOSKVcjHxFSCqySP7zur8YT9KBwIZpugkjDi6IyCJx+H0dZ/x1WX6n6Ikl
         3JFQ==
X-Gm-Message-State: AOJu0YwOcAL4Fs44fBP1++vm4f36okKjoKkWCIUTtvqNSf8h3JbYpQVu
	9hEfQ3mCvptlhdIjCKPjJq859ZGGx5R5DSdF6U1mIgCYfpkM8n4DKFvj
X-Gm-Gg: AR+sD11VgjA8ajn7JwNHB8HMOxPShmTxLQPrYZTGsdkKqholGfLf0dFXNk0yQJMsZXh
	xWP3j8LAKk9tJ9o5Dwzk+xoFnEb/6o68IdAQeu1TTl3KCi1jsl+iW7zwKPamd3vtMsLSmCnZxb+
	fps05rOdY5pVEDotXA4N12k3jy/kfLhlqeevPAGn0VCc7Y5t2/MC9YwgI2GEOVVoN892jiFPgRx
	icf9xDCcvcoRUeT8PZlETlJW3y/JvAB6LykY+Xieji+ymmcgnCFV+hSYc1IaR2xTCk4NGHKMCqb
	MrJOhLDJV1x86rRoFewIzJfAVx01Dv98t/nf6XxQvOiF981wmO7MG57i2doICXIATezZRmz9MCw
	fQKOQj8TvLtEu0gZxhQT6abuyDPon3ckA0XE/0Ope48Z+EMLhCJ1v+iD2BniPNAWfVjRz2c3cCo
	3MyhFw6YGUie+Exvd8K06Is82fpTSkE/tOO5VeVT+XwAx5G07BTIIcZFO1U+y5eLO3srYttoyQA
	0EHOD4olJ+pPM9vUkFG46nuuDsn+d4=
X-Received: by 2002:a17:903:38c3:b0:2c9:b396:1a55 with SMTP id d9443c01a7336-2d015af7f8cmr59186925ad.12.1785293712040;
        Tue, 28 Jul 2026 19:55:12 -0700 (PDT)
Received: from JIAPENGLIN-MC0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bc9fe9sm3999745ad.51.2026.07.28.19.55.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jul 2026 19:55:11 -0700 (PDT)
From: Lin Jiapeng <ljp1205831794@gmail.com>
X-Google-Original-From: Lin Jiapeng <jiapenglin@tencent.com>
To: zlang@kernel.org,
	hch@lst.de
Cc: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	djwong@kernel.org,
	jiapenglin@tencent.com
Subject: [PATCH v2] xfs/842: verify CoW after exchangerange with FILE1_WRITTEN on shared extents
Date: Wed, 29 Jul 2026 10:54:54 +0800
Message-ID: <20260729025504.54586-1-jiapenglin@tencent.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a full-file exchangerange is requested with FILE1_WRITTEN for a
fully sparse donor file, every mapping pair is skipped, so no extents
actually move.  However, the kernel decides to swap the reflink inode
flag based on the request geometry alone, so the target file used to
lose its reflink flag to the donor while still owning shared extents.
A subsequent write then took the non-reflink write path and modified
the shared physical blocks in place, silently corrupting the other
file sharing them:

 --- tests/xfs/842.out
 +++ results/xfs/842.out.bad
 @@ -1,4 +1,5 @@
  QA output created by 842
 +vX.reflink = 0
  vX.reflink = 1
 -vX.reflink = 1
 +orig changed: md5 e6065c4aa2ab1603008fc18410f579d4 -> 32c5189478e6bafa1cc76423f06c88f2 (write hit shared blocks in place)
  Silence is golden

This test clones a file so that both share extents, swaps the clone
against a sparse donor with FILE1_WRITTEN, and then checks the defect
twice.  First it inspects the inodes directly with xfs_db: the clone
must still be flagged reflink after the exchange (the donor carrying
the flag too is the conservative outcome of the fix and is harmless).
Then it writes to the clone and verifies after a mount cycle that the
original file's data is intact, i.e. the write was redirected through
CoW.

The kernel fix "xfs: fix exchange-range reflink flag clearing issue
with INO1_WRITTEN" refuses the reflink flag exchange whenever
FILE1_WRITTEN is requested, which makes this test pass.

Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
Link: https://lore.kernel.org/r/amgekiNKKoAdACnc@infradead.org
Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
---
 tests/xfs/842     | 65 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/842.out |  4 +++
 2 files changed, 69 insertions(+)
 create mode 100755 tests/xfs/842
 create mode 100644 tests/xfs/842.out

diff --git a/tests/xfs/842 b/tests/xfs/842
new file mode 100755
index 0000000..c4c2be9
--- /dev/null
+++ b/tests/xfs/842
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2026 Tencent.  All Rights Reserved.
+#
+# FS QA Test No. 842
+#
+# Make sure that a full-file exchangerange under FILE1_WRITTEN does not strip
+# the reflink flag from a file that still owns shared extents.  When the
+# donor file is fully sparse, every mapping pair is skipped, so no extents
+# actually move; the target file must keep its reflink flag, and a later
+# write must go through CoW instead of modifying the shared blocks in place.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+_require_xfs_io_command exchangerange
+_require_scratch_reflink
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+# Create the original file with a known pattern and clone it, so that both
+# files share the same extents.
+_pwrite_byte 0x41 0 1m $SCRATCH_MNT/orig >> $seqres.full
+_reflink $SCRATCH_MNT/orig $SCRATCH_MNT/clone >> $seqres.full
+
+# Create a fully sparse donor file of the same size.
+$XFS_IO_PROG -f -c 'truncate 1m' $SCRATCH_MNT/donor
+
+md5_before=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
+
+# Swap the clone against the sparse donor, claiming the donor is fully
+# written (-w).  Every donor mapping is a hole, so all pairs are skipped
+# and the clone keeps its shared extents in place.
+$XFS_IO_PROG -c "exchangerange -f -w $SCRATCH_MNT/donor" $SCRATCH_MNT/clone \
+	>> $seqres.full
+
+# Directly confirm the inode flag state after the exchange: the clone
+# must still be flagged reflink.  The donor may also carry the flag, which
+# is the conservative outcome of refusing the flag exchange under
+# FILE1_WRITTEN; the extra flag is harmless and can be dropped later by
+# the regular reflink flag cleanup path.
+_scratch_unmount
+_scratch_xfs_db -c "path /clone" -c print -c "path /donor" -c print | \
+	grep reflink | sed -e 's/^v[0-9]*/vX/g'
+_scratch_mount
+
+# Overwrite part of the clone.  With the reflink flag correctly retained,
+# this must go through CoW and leave the shared blocks of orig untouched.
+_pwrite_byte 0x42 0 64k $SCRATCH_MNT/clone >> $seqres.full
+_scratch_cycle_mount
+
+md5_after=$(md5sum $SCRATCH_MNT/orig | awk '{print $1}')
+
+test "$md5_before" != "$md5_after" && \
+	echo "orig changed: md5 $md5_before -> $md5_after (write hit shared blocks in place)"
+
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/842.out b/tests/xfs/842.out
new file mode 100644
index 0000000..1e6345a
--- /dev/null
+++ b/tests/xfs/842.out
@@ -0,0 +1,4 @@
+QA output created by 842
+vX.reflink = 1
+vX.reflink = 1
+Silence is golden
-- 
2.50.1 (Apple Git-155)

