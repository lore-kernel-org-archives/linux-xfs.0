Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DAF4854F4
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 08:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790585471; cv=none; b=YCGAnTjQJXi/hWJI7DjqUG0muy3l+PUC5FtCoO+/euG1obB1RNClZlNGDx+gbhvY2fXu8OmZ6xV77ogu48p4vKBs9n5nR63TjK2nPAoK+URuq0h77bDneeHK6wnhI3cfLoNil4yJe7UVFUSQO6I9ZBcNyqMTqm3B9fJFptAUsvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790585471; c=relaxed/simple;
	bh=i1xaD+GQtotG05Y1g1ad3sS/GUQ2zhFzCij3jOg5ZN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DxtL61S6/2699g2005p6wfblUk8D5i4qRnBcQWGjvocf+HpElr/8tuN1LwkV/pu/rs3ht4Q9Et7TRFWX2wkQHc002SmWX0UVzFEdFGTShzxivMQmsApM8+hHNbGF1T7kzQdkzwMZeBLph7CMnaZRaq8nt+uLntcR7mK/YCF9iz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J6PfCJ/d; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J6PfCJ/d"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ff23af865so21140265e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 01:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790585468; x=1791190268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=70HYNxWy1mK2Bp5EVL/Q0ipyOiBKRZxQ8tWA4Mxi4qA=;
        b=J6PfCJ/dxIP+QHBD5qGUQmKWGSbvbNgcwtwLvO8UqwSmodArZ6vT/rnyeEBzFAggoI
         KdHopNWUi9rZdKB+hl99gcbzwxouFbVpQPq8JeRhw308Qc/sG3K/Wrbt7Jey7aTeY3Hl
         PLiPKzObGOLC3cDKMc+TsjSV3CVBIMNQ8m04ZTwvuRkvA7rm5Eyjvt7SQCQ8bNhCO5Tl
         j+0Vm0nRNAE+EwXYAaXWtGCI68zLwGp2HxzoObCNqXfRGQV3ujL9zKdTW3/iHKloXaco
         sIdPTQshUtnUQ7Jo2n2OWIjuzGr5j1HohH1lWlTN0Jj5Q35WZgA/9fhS0dSOb51dYwpa
         UbPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790585468; x=1791190268;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=70HYNxWy1mK2Bp5EVL/Q0ipyOiBKRZxQ8tWA4Mxi4qA=;
        b=jn0a6Lls8LrzpcLZyOXJG3kwEGuUhXAhCx8f55MXGKP9PSviUS2CsnX7U3VzGEuBti
         ZhgRMloqkKyNR9N2ixSz9jT/9pyJBLGvEoEnjvlKJIofwA+S7z7lUCO+wzcWN40Jab1+
         Zi5eB7GXHnZmcUCskGuJ9WZ+1B4th/EYjNvt6SWYDS4vbEqBREnYdyRV1C64CsGD6KuX
         6Aag6CzQ7Djk/nHwZOuKvdR7g3w8wkkgKRVoaHq+Dz7zJXKujZvnoltCLHKjcAuYWtPq
         G6Ju/+4pxa/MgIHnitXbAehamW+KrbFwM8/Dxzn/CP2FRYSazwJZbKe8sNjmf4vw5dNx
         Nnlw==
X-Forwarded-Encrypted: i=1; AKwUvBybeBrnfOyKkH+CU9S+58BVl3xMag0Iiyxf6KLRgLukl277MclzN9XVN6pBklIYwPXKN6uRPThlCMw=@vger.kernel.org
X-Gm-Message-State: AFuF++kOEfNZxS4h27FZPgT10mkcaxMq1w0bYRu5PZA2QNmxfeNbfbbb
	kRoOafcwbtdAbTHtcJOquxC+T2kJSCayyGWMsn9+qY/poVhSw5lgMIw8
X-Gm-Gg: AYBFou3NOx3b2pcMQLxW6qF12eLQ4asMNoyaVsKktbv6TJgIpwxHSAO1hdbhNDkkirf
	Crj5kYyrB72/lpvlXhrdM26bu64qHuaAtchrXMCoeGXAXerBTXVNqbaH22Q3mKt6KOqb0T/YKd1
	IpqMsDtqV5B56mi6cVT0kwyhb9FQtQ4M4oTtVS/syi+fKGlFNY4m9gQMg5Aldxf3Y+TKCvHpN7D
	pMuiThDrB8SHPjtsTEFiAG2I1cTzt9danKbY24lwEMlIRXFhLlkjN9QZJwaTP/Zi3ym6mNcGKZd
	kYKEOanprWo7VbyaJ1Wb5yBJUH3Ia1fk9t9oFQESG97TYe7a9XZ7H07em9ux8fKV1KZYMLhgYda
	Bs5cnl7aiz9OWrljLnEeasbX/yZ2oHuBBfoTTq3ThcvIMVzWnNdR4/9f4u5nhKvZboeiZcrszBo
	zE56AN7oeREDUntHy3dDXbL+0ZRQfjPP1Y/SfhC1t0oOTLGwj5YlCRtJpCymMDOuRLafAHMcciF
	yEixnJkNK1wIOkdYXCgcvoWsvrrSs2igiEj2JXAG+gkR+3g2PfmUJqumIFIydxNZyaVsYn5MaAP
	lavkQ4Z4U2AUClw=
X-Received: by 2002:a05:600c:6388:b0:4a0:1d2:1a8a with SMTP id 5b1f17b1804b1-4a001d21b90mr51057765e9.16.1790585467667;
        Mon, 28 Sep 2026 01:51:07 -0700 (PDT)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0016a8c2asm129029035e9.0.2026.09.28.01.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 01:51:07 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: fstests@vger.kernel.org
Cc: Andrea Parri <parri.andrea@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Zorro Lang <zlang@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] xfs: exercise a failed CoW conversion during writeback
Date: Mon, 28 Sep 2026 10:50:46 +0200
Message-ID: <20260928085047.7250-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iomap_add_to_ioend() submits the pending ioend through
->writeback_submit() before allocating a new one for the current
range.  For XFS, xfs_writeback_submit() converts the ioend's CoW
extents via xfs_reflink_convert_cow() before submitting the bio; if
that conversion fails, ->writeback_submit() completes the ioend with
an error and returns it.  A kernel bug left the stale ioend behind in
wpc->wb_ctx, which iomap_writepages() then submitted a second time,
corrupting XFS's ip->i_ioend_list.

Exercise this path with the wb_cow_convert_error error tag: reflink a
file, dirty several widely separated ranges of the shared extent so
that a single writepages() call has to build and submit more than one
ioend, inject the error, and let writeback run.  On a kernel without
the fix this reliably hits a "list_add double add" WARN from
xfs_end_bio(); on a fixed kernel writeback just fails cleanly.

This requires the wb_cow_convert_error XFS error tag; the test cleanly
not-runs on kernels without it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
The kernel fix and the wb_cow_convert_error error tag this test relies
on are part of the series at:

  https://lore.kernel.org/all/cover.1790342457.git.parri.andrea@gmail.com/

Changes since v1:
 - Cite the kernel fix with _fixed_by_kernel_commit (Darrick).
 - Don't reset the error tag before the remount; the unmount clears it
   anyway (Darrick).
 - Picked up Christoph's Reviewed-by.

v1: https://lore.kernel.org/all/20260924091338.198407-1-parri.andrea@gmail.com/

 tests/xfs/842     | 71 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/842.out |  7 +++++
 2 files changed, 78 insertions(+)
 create mode 100755 tests/xfs/842
 create mode 100644 tests/xfs/842.out

diff --git a/tests/xfs/842 b/tests/xfs/842
new file mode 100755
index 0000000000000..4495e9bdfa530
--- /dev/null
+++ b/tests/xfs/842
@@ -0,0 +1,71 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Andrea Parri.  All Rights Reserved.
+#
+# FS QA Test No. 842
+#
+# Regression test for a failed ->writeback_submit() call leaving a stale
+# wpc->wb_ctx behind.  iomap_writepages() then resubmits whatever
+# wpc->wb_ctx points to, i.e. the ioend that ->writeback_submit() already
+# completed with an error.  For XFS the second bio_endio() lands back in
+# xfs_end_bio(), which list_add_tail()s the already-linked ioend into
+# ip->i_ioend_list a second time, corrupting the list.
+#
+# The only in-tree way for XFS's ->writeback_submit() to fail is a
+# failing xfs_reflink_convert_cow(), so this uses the
+# wb_cow_convert_error error tag to force that on a reflinked file whose
+# CoW extents are dirtied in several widely separated ranges, so that a
+# single writepages() call has to submit more than one ioend.
+#
+. ./common/preamble
+_begin_fstest auto quick clone
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+_fixed_by_kernel_commit XXXXXXXXXXXX \
+	"iomap: don't resubmit an ioend after ->writeback_submit() failed"
+
+_require_cp_reflink
+_require_scratch_reflink
+_require_xfs_io_error_injection "wb_cow_convert_error"
+_require_kernel_config CONFIG_LIST_HARDENED
+
+blksz=65536
+nr=8
+sz=$((blksz * nr * 2))
+
+echo "Format and mount"
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+echo "Create reflinked file with several CoW extents"
+_pwrite_byte 0x58 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+_scratch_sync
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+
+# Dirty several widely separated ranges of file2's CoW extents so that a
+# single writepages() call has to submit more than one ioend.
+seq=0
+while [ $seq -lt $nr ]; do
+	off=$((seq * blksz * 2))
+	_pwrite_byte 0x59 $off $blksz $SCRATCH_MNT/file2 >> $seqres.full
+	seq=$((seq + 1))
+done
+
+echo "Inject wb_cow_convert_error"
+_scratch_inject_error "wb_cow_convert_error"
+
+echo "Trigger writeback with CoW conversion forced to fail"
+_scratch_sync
+
+echo "Remount"
+_scratch_cycle_mount
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/842.out b/tests/xfs/842.out
new file mode 100644
index 0000000000000..72c9c67e7d5fb
--- /dev/null
+++ b/tests/xfs/842.out
@@ -0,0 +1,7 @@
+QA output created by 842
+Format and mount
+Create reflinked file with several CoW extents
+Inject wb_cow_convert_error
+Trigger writeback with CoW conversion forced to fail
+Remount
+Silence is golden
-- 
2.53.0

