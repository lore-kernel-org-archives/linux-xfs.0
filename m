Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB6F18952C;
	Wed,  7 May 2025 05:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594809; cv=none; b=t1LdqNKTqvcpQnqsjvnnv+wnCimVBb5yHubp6kfF4WKXdVq6MVzMX1rCbTLsVik5aOMXg4DvOs16jcUQq2dkuohLKX4ssvCQH4SedTIpvOzrvQi1/pMCyYHCejQavz8dFqFH/799tl/gxzqIRAjf4QVmSQohoXJY0lY5E6FFjgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594809; c=relaxed/simple;
	bh=ITqqv63chiuHf94v8UQeaf2IaZ9kMKnEgSfESrtjIcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1d4uy+zSuqwsSQBGzUjS2BFylhLyf9giAyQMBX6kB5xqFiWXEQzGO6ROMEpPxpUBTOZmu6rIJK+7nhz67JGZ/Qx79zMoFX0k5TY7JSAfJXwmVuBx7B6QsvADx52rHLxOCJb5SlHr3NSzv6BHCXCYyl5224rLFTcVAaoSf2EI6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t8Qtd4y+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t8Qtd4y+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pn3QJdwc58Hx/aXRnk7sqoCfxSyK9Rg5vECnKWto+fU=; b=t8Qtd4y+ApWTXpSyuKXuVTWR9I
	IWlrxSXBtlzGME7JLE7YRQ6nLU9E8LLs2T0nXKwnuSI+P3+Nh82K3xpr9DfrOGNPTWwbF3rfbHnDE
	XpF7udSOCipadLrouMcHqUPS+/RNJANQFsv1XvZvC/Hn4VCGeAKqpKJQFLbpda7ff4Wndiergr6w1
	AJLoO/LCw9KTbEwD+rO6mrgqfUn3TsKQuaQT6CdmLLtidzR0rgIzXIC0Aq/bVxm4Bv9x8Ns348aFZ
	IQTCvnax8QCyVPgkgD95l/9M3qg5kuGaoHEEGvUm3oeo15GH6SYXLUJ0HBhmMvizvPwm72ZAS8q4v
	QLH1s1BA==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX5y-0000000EF06-3ybx;
	Wed, 07 May 2025 05:13:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/15] xfs: test zoned ENOSPC behavior with multiple writers
Date: Wed,  7 May 2025 07:12:31 +0200
Message-ID: <20250507051249.3898395-12-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507051249.3898395-1-hch@lst.de>
References: <20250507051249.3898395-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Test that multiple parallel writers can't accidentally dip into the reserved
space pool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4209     | 85 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4209.out |  2 ++
 2 files changed, 87 insertions(+)
 create mode 100755 tests/xfs/4209
 create mode 100644 tests/xfs/4209.out

diff --git a/tests/xfs/4209 b/tests/xfs/4209
new file mode 100755
index 000000000000..57fef69b49e7
--- /dev/null
+++ b/tests/xfs/4209
@@ -0,0 +1,85 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4209
+#
+# Test that multiple parallel writers can't accidentally dip into the reserved
+# space pool.
+#
+. ./common/preamble
+_begin_fstest quick auto rw zone enospc
+
+. ./common/filter
+. ./common/zoned
+
+_require_scratch
+_require_odirect
+_require_aio
+
+_scratch_mkfs_sized $((256 * 1024 * 1024))  >>$seqres.full 2>&1
+
+# limit to two max open zones so that all writes get thrown into the blender
+export MOUNT_OPTIONS="$MOUNT_OPTIONS -o max_open_zones=2"
+_try_scratch_mount || _notrun "mount option not supported"
+_require_xfs_scratch_zoned
+
+fio_config=$tmp.fio
+
+cat >$fio_config <<EOF
+[global]
+bs=64k
+iodepth=16
+iodepth_batch=8
+directory=$SCRATCH_MNT
+ioengine=libaio
+rw=write
+direct=1
+size=60m
+
+[file1]
+filename=file1
+
+[file2]
+filename=file2
+
+[file3]
+filename=file3
+
+[file4]
+filename=file4
+
+[file5]
+filename=file5
+
+[file6]
+filename=file6
+
+[file7]
+filename=file7
+
+[file8]
+filename=file8
+EOF
+
+_require_fio $fio_config
+
+# try to overfill the file system
+$FIO_PROG $fio_config 2>&1 | \
+	grep -q "No space left on dev" || \
+	_fail "Overfill did not cause ENOSPC"
+
+sync
+
+#
+# Compare the df and du values to ensure we did not overshoot
+#
+# Use within_tolerance to paper over the fact that the du output includes
+# the root inode, which does not sit in the RT device, while df does not
+#
+df_val=`df --output=size $SCRATCH_MNT | tail -n 1`
+du_val=`du -s $SCRATCH_MNT | awk '{print $1}'`
+_within_tolerance "file space usage" $df_val $du_val 64 -v
+
+status=0
+exit
diff --git a/tests/xfs/4209.out b/tests/xfs/4209.out
new file mode 100644
index 000000000000..cb72138a1bf6
--- /dev/null
+++ b/tests/xfs/4209.out
@@ -0,0 +1,2 @@
+QA output created by 4209
+file space usage is in range
-- 
2.47.2

