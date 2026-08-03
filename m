Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FC646B5
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 02:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785725790; cv=none; b=T0EmSaSZPc5zqqcXoSYl0otVlKFNU8C78bW2YvDPUw2E0HIs3MP92BzztM+3FUoAc8hSHN1mrWuYxxCa9WRCXQyaIuobLkcEtBoWt+7Y+TiEHOW19ajf4CTpf8Ib5SYkMdWIrj0d8k7E7+W1jfdml9NXQ/BUEKq+BVNjSgZiHNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785725790; c=relaxed/simple;
	bh=9JksVlenLD/tn/RgNkrISaIa/9t4UiEjQRJ5MpQAwd0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FJlkdzBINJXTqPXibniWtVQpdesOjm6S72bsQdjQDY9c/dDKfGbiIIEbAKOsrrL1Zo+93wEcn+43XuKPUTPOc1/+BltYDG5Z/5CXMkI0sFeJ09p0TeQoixW2uBD3umV+mMlq1fcOl6ZvNJasL0DZ9AFWWV//3l5H0r0AE3VEyak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YV57td0A; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YV57td0A"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cf452def93so26923725ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 02 Aug 2026 19:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785725788; x=1786330588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5dShAQ1lYMtkqytfZFTDLWc+qcDcWtf1Ahs1bgrAph4=;
        b=YV57td0AF2rD8UOMBcKQIdUlaFXckgLXA4DyTDxsehta5XsfeH8Pp3nCnM4/K3216V
         J+zOFddtuBAiLfOuu+4TGHbZUr6C0DNQVrei8Ne5ZWfOPGkOB7yqvRHY0LjZiMyD0J6d
         atELreA+yOzSMBL8Myc1ZhQ2F+fOqNmAeq4DkfsDGgiqmS7euSv8JmkbNP0NXPhhbfoO
         EVDx1tvk/6UdnT8DbLXV5VHr+7c01rrv+lx6OCiRtAHaZRlUb2vmgnwuDDKfqF+2EowX
         LALbCCaWC5ijs9QYD5BdqfYXxqMjCjA3qsmSX9Mf2ut+95IrlnEqaAYeLxIu7VMjdlHr
         n9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785725788; x=1786330588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5dShAQ1lYMtkqytfZFTDLWc+qcDcWtf1Ahs1bgrAph4=;
        b=DsGlFT36XqjbgM/O55Nuv8xEnSwk+SZOcHDUMjXwtnHnY8BbccZrI0loQ4cEDXnQaJ
         pDF+lSE2/bDvb/lzPh12WDRmWTzr1AM36N1MBwyiUvRxk5hEao94V2pRZ7M6MXh9e3ks
         zRT4mQeiWfk0pMugnFHOdyxAV5dnAqZXcqd2L2z5Iv0QVk9vJkZ9PQzngQLaMEBePTsF
         hrLvxa+6/MiIvp7B7HSSiCgcdrCbKaXCE8oYd+yJ8b9wzPuZXoTsXGSvnHA3Lo0KMpSI
         pKy+gPw9UjteYhlZTcEPkvu4i3JpR6GORDFLDj5iqJpDsZHAdGDx0Ako4kp5fupszmNC
         dgSw==
X-Forwarded-Encrypted: i=1; AHgh+RrHGQEUv6TbaKOThyMeBy5kRLa9yytz972hbiZnyIFErYoDZ2h/YR8UznNPzW5vMtuBmDEl5HYMhqU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw0JDKFtqu/bRvihxkkXZXyLRIKQfzc/O8yu93VgOByZRBKFg/
	4NqaqB3OXi4EbOC4pJYD3MEVDMY3OefCFPlKls+dosrAY9yq6TXDh00s
X-Gm-Gg: AR+sD13h2FB/43H496zbUR0DqpRi6vDzU/n8gqQVy6mzX5vJVBml8zG6fjHU+j2Lu3g
	UnsNl2zpeKX1p91VQWcY1PHUWSxDFzriI8TPYC+t1WfXRvmS81lHMn0pUOUPBaQkFuXne5MuyW8
	TuCW/m6ocgM5PPTZNFu3opZBM1xlR6Oh1+h5TNawxj5GbLyuf69m89FBMTDeGsBdjCLcYnZs40f
	8Ap0dY3Bev9xgQkNGHfK+Qp3uoX8/GG3A+CegEvrgjfcuLZo/CNFPgy8ZA6MUlVsP4i/xwkJcso
	7uxqTIzsLwCgNRVGbyQnMlOFvv8X9dyTdfmgV7Grp081HBiAcSCOPBcuTh7otdbFQtxYDuLolUB
	za9PWrCF+MB3jyU0lB/6myTL7Ccs+3x/3krHWvpssl4bS1t0jFKWmOjENiuuR/Kvc0WRAa/oNfN
	qKOXG72bsf/W2BQkn9LefmxqoKukFqZoGGRdj/A11HM8ySfoWc8uLZnbEjWjhZRLhXSpyTWdwxt
	+CD0fksT50ICRlKuQrmmpMy970TX/o=
X-Received: by 2002:a17:902:e551:b0:2cc:92ae:b36 with SMTP id d9443c01a7336-2d047e88baemr102252165ad.24.1785725787782;
        Sun, 02 Aug 2026 19:56:27 -0700 (PDT)
Received: from JIAPENGLIN-MC0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae19ba5sm31369665ad.17.2026.08.02.19.56.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 02 Aug 2026 19:56:27 -0700 (PDT)
From: Lin Jiapeng <ljp1205831794@gmail.com>
X-Google-Original-From: Lin Jiapeng <jiapenglin@tencent.com>
To: zlang@kernel.org
Cc: hch@lst.de,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	djwong@kernel.org,
	jiapenglin@tencent.com
Subject: [PATCH v4] xfs/842: verify CoW after exchangerange with FILE1_WRITTEN on shared extents
Date: Mon,  3 Aug 2026 10:56:13 +0800
Message-ID: <20260803025621.52453-1-jiapenglin@tencent.com>
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
 @@ -1,3 +1,4 @@
  QA output created by 842
 +vX.reflink = 0
  vX.reflink = 1
 -vX.reflink = 1
 +orig changed: md5 e6065c4aa2ab1603008fc18410f579d4 -> 32c5189478e6bafa1cc76423f06c88f2 (write hit shared blocks in place)

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
Suggested-by: Zorro Lang <zlang@kernel.org>
Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/842     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/842.out |  3 +++
 2 files changed, 66 insertions(+)
 create mode 100755 tests/xfs/842
 create mode 100644 tests/xfs/842.out

diff --git a/tests/xfs/842 b/tests/xfs/842
new file mode 100755
index 0000000..e9d01f8
--- /dev/null
+++ b/tests/xfs/842
@@ -0,0 +1,63 @@
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
+# success, all done
+_exit 0
diff --git a/tests/xfs/842.out b/tests/xfs/842.out
new file mode 100644
index 0000000..69049d5
--- /dev/null
+++ b/tests/xfs/842.out
@@ -0,0 +1,3 @@
+QA output created by 842
+vX.reflink = 1
+vX.reflink = 1
-- 
2.50.1 (Apple Git-155)

