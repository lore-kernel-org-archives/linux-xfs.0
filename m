Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0622A1DE4F1;
	Wed,  7 May 2025 05:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746594799; cv=none; b=sdWtVXJbKgw42vuxFXK/KmGszxPYFBkipryWm8YWpDvgj1CQhic242l6Jzka3SavqDsnpJ+8jW8VYFEre43dRdxRInTJI+eLHO856te3+bY3zq+/SHcSaNMKsWxsOnQpqraxA90AB4Ze31+X3usZjVZB3b401hgqz5Ac2REhjDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746594799; c=relaxed/simple;
	bh=hus/Q5UtfmEn1HlwUj5tczsUh0ws5oKjb/+3a9Mi9U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1vovtE7OOBPGvsDUSo0I4OW2+quBRHSZqzxt67MPenL09NUhhHJKc2xLYWsme941DOxv411fEQC0VtdyHnkJvtuuan0YR52RK5kGhBVgp2aDDsJcE4E7sMO4BZ/ny1vYtNHWrmWpBRnJF8cqw6ig/enpMRZ/XyWgX8er7wSPRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=35xTPqDW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="35xTPqDW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nRqpHZaUedMD3at1EUF8IytJKo4ka16Fs+L2azwXaqY=; b=35xTPqDWwMGGpRildrlQNqvGha
	7EMhrbQvrRJqZJzhdiIuZHcePB+09WE1R1OXqw7QKcJfm5TzDGhI3Sec6JStBJ38w/UiTsfudXWNm
	6EqO1b6/XdngUfzofwZuYMNIsycpcx8Zrt7kRmAXvLoduiV+hSnYwpDqYId0l1I6skFnN/d+xXMUu
	MVrrOv/fSMRnb0mUZSUCUpkN5MirGxF3PkIHG0sz/AfBMcRT4ef+eMNooUz92n3zV4SPR9hRlcwWt
	hOn+uDDI0IhRVjd+ID+26cnrW8FZi1Y6SkPCuMduqpN1E2nzfvXN9w7L2poYcsl2jRvbObuRExlM7
	i1Im3IsA==;
Received: from 2a02-8389-2341-5b80-3ba7-83fe-7065-4f0b.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3ba7:83fe:7065:4f0b] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uCX5n-0000000EEw2-3ItC;
	Wed, 07 May 2025 05:13:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/15] xfs: add a test for writeback after close
Date: Wed,  7 May 2025 07:12:28 +0200
Message-ID: <20250507051249.3898395-9-hch@lst.de>
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

Test that files written back after closing are packed tightly instead of
using up open zone resources.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/4206     | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4206.out |  1 +
 2 files changed, 42 insertions(+)
 create mode 100755 tests/xfs/4206
 create mode 100644 tests/xfs/4206.out

diff --git a/tests/xfs/4206 b/tests/xfs/4206
new file mode 100755
index 000000000000..f87c2868ebb4
--- /dev/null
+++ b/tests/xfs/4206
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4206
+#
+# Test that data is packed tighly for writeback after the files were
+# closed.
+#
+. ./common/preamble
+_begin_fstest auto quick rw zone
+
+. ./common/xfs
+
+_require_scratch
+
+_scratch_mkfs_xfs >>$seqres.full 2>&1
+_scratch_mount
+_require_xfs_scratch_zoned
+
+# Create a bunch of small files
+for i in `seq 1 100`; do
+	file=$SCRATCH_MNT/$i
+
+	$XFS_IO_PROG -f -c 'pwrite 0 8k' $file >>$seqres.full
+done
+
+sync
+
+# Check that all small files are placed together
+short_rg=`xfs_bmap -v $SCRATCH_MNT/1 | _filter_rgno`
+for i in `seq 2 100`; do
+	file=$SCRATCH_MNT/$i
+	rg=`xfs_bmap -v $file | _filter_rgno`
+	if [ "${rg}" != "${short_rg}" ]; then
+		echo "RG mismatch for file $i: $short_rg/$rg"
+	fi
+done
+
+status=0
+exit
diff --git a/tests/xfs/4206.out b/tests/xfs/4206.out
new file mode 100644
index 000000000000..4835b5053ae5
--- /dev/null
+++ b/tests/xfs/4206.out
@@ -0,0 +1 @@
+QA output created by 4206
-- 
2.47.2

