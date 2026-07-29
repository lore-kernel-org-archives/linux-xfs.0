Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B42ECD35
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 06:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785307214; cv=none; b=VYSw7qg7xZEGQ88w5iivE9YcIYPC3smdltIx72TzBrYZkvhJwPQyUyPqwA8bRFkIqExbTiKRSJeyaX8mzAnNXuUgsCDKJAHpxdksRnvhyV4LxloWVjXj59horKn4W3TcBXshygseNgPg3M2cNrpDuaWAU8IazFIZqakHgfuTLEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785307214; c=relaxed/simple;
	bh=LnYNxN0F70JksMYZ16+FLvewdRid2Kd0I3zXyJ/ZjfU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qJFvE2c1w51DwgZHOtXg00Vm86oqpuvPLceHh1jasTeR5RUrkvpIUgUg3qvqC4m8NeK1X7dFKTDXFBTWAKkQ1wHL2dMfftPOHIQOL1xpSi2kiB9kXlQba/uCuP5EA/fgkgWgelvSXn7EKzMuM7MHyYHxUlQR1Nt5TsRM+r+qwzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BYVNrz1Y; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BYVNrz1Y"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8487214ad2bso905225b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 23:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785307212; x=1785912012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tzycku+Dc6z2N1jBytEdQ2C8WB3ON5IhtKaw/WWhdEk=;
        b=BYVNrz1YfQTcD3EvHe+HiuDP7i/R/JxP+MUZKCZWynfPNXCVmRmyHBc4+gx1wn20Ub
         nSVfXtliE4lWLrk7lnR3vM7390nGIBOtSwBpdLb/H45g4TIN5fo3Ipr+u+Fx4cIFBxVk
         dImdouh2Gmns57zcjmkKurVI2krxwmSTm6/E1pX7b/yTvY0eeJaYTH+ujHpP1+/LCwOC
         KX3VIu4DbdDhM/tIgjN9uTbFvZMnP83+hNgbKAdo5ZECoapHg7aVP0J10QFrwBCKyWY5
         sBEpywxzPEdKozBamGomgLpzf4DpdESz5U5d6HIi4SLjlLncnBbAI5hI7AAU/1nxKYBm
         MsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785307212; x=1785912012;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tzycku+Dc6z2N1jBytEdQ2C8WB3ON5IhtKaw/WWhdEk=;
        b=pAMklsbHmmuU34Xb232wsj8z3eI0uGOvHHve7wpdFtXXLx+/f4Og4O9T+9/h/adkOY
         yOpTS67VZ0NoF44kpPctMobTPvjcDCZeXavrn6cS9fGUvyeJpQ28lqut/riHKqChZb/G
         NMvH96Aze8kMh4jIhyQF4UQAwCsYjmRrudTFR0QuIVKNLlGk2Mbq8dc7vSnmMR2T7j5N
         anpDq3TYTssYV42AYpaduWytEBZX7NphaB7hRMNIuHVud//iCVnbmSHUiQ9ca2pFgzAd
         ZYQedBQGNTzs8UHa5lzKb/fSUVnnoqX5tGE3TgXxoAKL2haPmoUVx1AzUhKtNC4jyKzf
         aI9w==
X-Gm-Message-State: AOJu0YyYURa+z20Cnskfkq5TrzvvPrnBKFrhCUK7Jtu1gGHfX5B6iJ+b
	czIN2mrW+Mi163rLlZoHvgmiQYlZLYwZ1P3Jm5+mWm5PyXdlLUS5aeFhbAmuv84KrtHxTszV
X-Gm-Gg: AR+sD10ehqPrRZ0uTyePd401A2WAcCQNKOQ9ZZhLzwMK+nrW+7yskW8Gg0cQZ5Qi5O/
	o0lsVicWjVKELVAP4LyeHtZpSyxwkEtU1tiEuqvC8W6Yb9yTOpO7ry4T3/gax8xg2ZDDLR9+GGU
	CmFWj4TTECchJhP1gpJU5TALRdc3Ktqe6R7ymFCBR2abVCz4xEVav3K7gTvEBOf8dbCuQQ2xXfC
	Of+LREtpKhV6rRW6wx68G0aa6wP0ZerBMYcMY7ZLfk8ksmbqYuHeuj0HA67+0fJ3wrysPhjt3be
	2Sy35bibpX7Bba402jRUXHH5/ujgN1fWhXxup0tD/ybRbWGkSna6UQWE4mqB8yD2NdQrMiHUiag
	beogEPEEoDv7GJjCs7cKR3rBNm+pvJVioXV9kYCZDb16hfuT0wvdIzIthuLx0cRIqubITgIj9Dm
	MLNgIF0OKmW9shlEKp5gUbksqOHNUSgxWmvcYQ8jwuSEuR5gUh8Xgpav69rgArjIFLKSZ4WmPmi
	+drMfK2zMDj9huxcclF9yui3DnLOick
X-Received: by 2002:a05:6a00:cc6:b0:848:467d:293b with SMTP id d2e1a72fcca58-84e931b505dmr5585233b3a.11.1785307212240;
        Tue, 28 Jul 2026 23:40:12 -0700 (PDT)
Received: from JIAPENGLIN-MC0.tencent.com ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0378b18sm840056b3a.48.2026.07.28.23.40.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jul 2026 23:40:11 -0700 (PDT)
From: Lin Jiapeng <ljp1205831794@gmail.com>
X-Google-Original-From: Lin Jiapeng <jiapenglin@tencent.com>
To: zlang@kernel.org,
	hch@lst.de
Cc: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	djwong@kernel.org,
	jiapenglin@tencent.com
Subject: [PATCH v3] xfs/842: verify CoW after exchangerange with FILE1_WRITTEN on shared extents
Date: Wed, 29 Jul 2026 14:39:52 +0800
Message-ID: <20260729063956.3664-1-jiapenglin@tencent.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

