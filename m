Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE663D4108
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 07:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785222995; cv=none; b=Y6yCU7X8oSpeLJTpkF54OEL8vMe8Dw2XqKs6MhGA2GYPjFBLSyNGkR1UJJqunAwAyCafed0Z64WI0zYXMl5c+qmlkvp6KywI2DJ7/QsRkwVyBRQSAlPBhZdBbOtav1Z0PI6qtxL4dzuXio6/yWBUNUKuRL/bH3+nQo5+W06QMgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785222995; c=relaxed/simple;
	bh=OeULwsnZg2MQZW9L1hPAE/oBsX4TljyHoz6mxe1+Jjs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IJaxfnMirUe8A/pRxAWtiZbRbuSAUGK+0T5PkKzOUwqXReFIZUPk+hkEIFstnUmrjtVwAubisB2Me8WqQxYBE+IDMqc2Z5fbcKOrj+fu3XbsMkhQoo6k9s0FocUnL0DrJ8UU8PJRxYKhbY7OoTex2rt7HwokUACS7SOGsVMfja4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KdPbCK19; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KdPbCK19"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3811f512167so3307659a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 00:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785222992; x=1785827792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=apHCprtntQyjNX5/kfnKjQo7eiikWtSh5sFZ2UP2db0=;
        b=KdPbCK19cS162Ibo28YqQjjVJkahei+kifSlzBBWexu5UvxpoSK0ISTqsbiINR95bm
         /v9cUT9k4F/tJRhTtB5z2tajnbTdGbGXEi3dcXv29gcop2Gjon0zZTqilW8GBv/09nq/
         B45Fe84tvU3HnNDxQg/73H2lJOB4pewKon4OllxO/DAKHfS0Vyn3Gq54QhsRG2O+pz2E
         wpOxaEEqqw3T9vloDXpFrN7tQO9rwsrISCwoHtQq26MKMKsLmIev7MsKvI2x98S4IhAL
         IvcSm8iIONHn3F7tL8DMUROSOFAhSfw8qrIu0H458oNgzQFwbJnx0+jRw8UXqt3ZHEao
         T0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785222992; x=1785827792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=apHCprtntQyjNX5/kfnKjQo7eiikWtSh5sFZ2UP2db0=;
        b=dq4s39TTTzSOD6cQtCp+e2BcvrEAnAscLXoT6B4aZrXhLwS/3Y2iSWc8/1rIuYpKbm
         fow57b4idgltGSmwr5ElrGvFQD+GnXH8Oey1I39ThG3ZjzWf5YegyrsiS70tlsh8XoWl
         75fGZjnmAtopV+CJ8hkm5qVGHAtFXhhErNYPLmfOXqdQxQ3ZkXu+uNyh8jG7Th9VEOkb
         nftJ2GOfFwHFkKX4mKdt4ahwfwtTb7sml6J0QXeDNVkV82E/wAZdjhsD2V8/vSgQZJFD
         Sf1p0xTHXsfkOrlV2ZYIpIF8nyXGWC7GYsssqlnh5gS5X4kkX47lO9cFfiXFYqDXPbWg
         a1gw==
X-Gm-Message-State: AOJu0YxpSI3oVHSXcub/gDXqmooi+yH8+EcUgtDSv9g9gMgJrKqMgoA5
	hRgY2PXFdKJyT7btMtUj67hZt+Q0H9bBSXsivjY4CJlfBeg06dmDrdZQXkI1irkiuUEfVvWI
X-Gm-Gg: AR+sD125h582rHmRjzJft0Tca0xiB+hXdJDwKtxwOTcDRUbX4kJbXCKafkeC7zt+Bsi
	8a+9FsShMA4WpG3Uy8hGcug0rQUKF6RSwIQpTYuvd06ToUv64Y1d4zqIN22cWkGSiyEyTFt6QtT
	FS3uV3hft+dn/RdI0RGbyY/a4+6IM1DHU/AUDyAZ7jSh/5FO/T2RWKVmV1DNIu+wH1O0QIUYj4Y
	KXonpmxuCRuzbga4BXlPVKO3j8DvLu1WfD2hDPoSYuYYXd52g7xkWqtvGZZ/v399kp0bF3Jbomh
	UM4cBEEIK9mgWpziDj80yXroCvNAvum9Tk98PpSajFGLaMzckpztPgAlHYH5QCbOjlDNqKx+r2M
	nidmGSa6fYCF/oopDJ2yb3TxmT2cZyOLfwmLsCJzuW/pbQ57DFSnYxkdUOWVJQ6gF3ELxu/3X1t
	MCyRyPNyoHegFZmgbJV0zkKSfsyKTG6ylGik+kTcpLp0fD
X-Received: by 2002:a17:90b:1b06:b0:37f:c97a:939f with SMTP id 98e67ed59e1d1-38f6a30c84dmr1315801a91.7.1785222991897;
        Tue, 28 Jul 2026 00:16:31 -0700 (PDT)
Received: from JIAPENGLIN-MC0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f08968de4sm4152456a91.2.2026.07.28.00.16.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jul 2026 00:16:31 -0700 (PDT)
From: Lin Jiapeng <ljp1205831794@gmail.com>
X-Google-Original-From: Lin Jiapeng <jiapenglin@tencent.com>
To: zlang@kernel.org,
	hch@lst.de
Cc: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	djwong@kernel.org,
	jiapenglin@tencent.com
Subject: [PATCH] xfs/842: verify CoW after exchangerange with FILE1_WRITTEN on shared extents
Date: Tue, 28 Jul 2026 15:16:20 +0800
Message-ID: <20260728071625.79516-1-jiapenglin@tencent.com>
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
lose its reflink flag while still owning shared extents.  A subsequent
write then took the non-reflink write path and modified the shared
physical blocks in place, silently corrupting the other file sharing
them:

 --- tests/xfs/842.out
 +++ results/xfs/842.out.bad
 @@ -1,2 +1,3 @@
  QA output created by 842
 +orig changed: md5 e6065c4aa2ab1603008fc18410f579d4 -> 32c5189478e6bafa1cc76423f06c88f2 (write hit shared blocks in place)
  Silence is golden

This test clones a file so that both share extents, swaps the clone
against a sparse donor with FILE1_WRITTEN, writes to the clone, and
verifies after a mount cycle that the original file's data is intact,
i.e. the write was redirected through CoW.

The kernel fix "xfs: fix exchange-range reflink flag clearing issue
with INO1_WRITTEN" refuses the reflink flag exchange whenever
FILE1_WRITTEN is requested, which makes this test pass.

Reported-by: Lin Jiapeng(TencentOS Red Team) <jiapenglin@tencent.com>
Link: https://lore.kernel.org/r/amgekiNKKoAdACnc@infradead.org
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
---
 tests/xfs/842     | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/842.out |  2 ++
 2 files changed, 57 insertions(+)
 create mode 100755 tests/xfs/842
 create mode 100644 tests/xfs/842.out

diff --git a/tests/xfs/842 b/tests/xfs/842
new file mode 100755
index 0000000..6d5bcab
--- /dev/null
+++ b/tests/xfs/842
@@ -0,0 +1,55 @@
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
index 0000000..643d052
--- /dev/null
+++ b/tests/xfs/842.out
@@ -0,0 +1,2 @@
+QA output created by 842
+Silence is golden
-- 
2.50.1 (Apple Git-155)

