Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BE91D5CDE;
	Thu,  1 May 2025 13:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106990; cv=none; b=iHhGb6+i4thykbhUybZe38g45IN7EdDqdj3KtJXLws5QVxNYuW/4ZinJlH/7xd4Iok8EhucsynGP6Z8YqX2e0htIlS8Mbf4HHLi10S6FDoFgdpu9k7+PD9bqKWsP4/pbO2dE0BmyXKKT+xVUtnfOAVY9s8eIJxD9krKKPVltzlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106990; c=relaxed/simple;
	bh=AFepQtW2jmwuxbTqheD3oMpfoXOuyLyJWka8UKRlrBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4aKmRa9SORnnRQ64WKDpxhHmM6DAqolpbwun2/Xy6SOYueN+REDvuowZzhIzQAiZ4f1JeGc9JTZwfx6BZVytPnWnxfb2Zvu2ra1hJxtDtf6TGm02zzlzFYVVv2EXjHyw+hzM6SIXVlQuTKqTj6RGr7rzlekd1XdhTvJZClBC+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yq45FrCn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yq45FrCn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EDZ+0Jf/fnPWXyJJR0LLrCDxjpD8i8wmNbe9cNAv2Eo=; b=yq45FrCndrfPY4+LcwELxLwb/p
	JgryITb/NRQeUjB56O+7nAdXV1+VeY1Vg4dbrxh04pXkkGLayDc8h/Eud04b6h6NdM/8ZpbHOqJLx
	e8iwMpVJcd1wIAkIo4BUd2qUrcwlqPMjbZBLM0GvMPzlfXmwh1B6Both4XhxBHroQnbBjLLeBLznN
	HBtb7D5551dSf/FkzLqmEmFdW2uz5H5PCsHBdZ+PdI7QOe/DYyKVYOuTRmqbL/1aVR4RL5V/cmogT
	hECYXiqnOzmi/cKb72SjeD5PybtoUAhmHM1ZIQnDyAunU5O5/67lFtDGlo27d6wH6AXf32Q7w8Byy
	z4pwZa8w==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUBw-0000000FrQV-2LBn;
	Thu, 01 May 2025 13:43:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/15] xfs: add a test for writeback after close
Date: Thu,  1 May 2025 08:42:44 -0500
Message-ID: <20250501134302.2881773-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501134302.2881773-1-hch@lst.de>
References: <20250501134302.2881773-1-hch@lst.de>
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
---
 tests/xfs/4206     | 57 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4206.out |  1 +
 2 files changed, 58 insertions(+)
 create mode 100755 tests/xfs/4206
 create mode 100644 tests/xfs/4206.out

diff --git a/tests/xfs/4206 b/tests/xfs/4206
new file mode 100755
index 000000000000..63e6aebeaeec
--- /dev/null
+++ b/tests/xfs/4206
@@ -0,0 +1,57 @@
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
+_cleanup()
+{
+	cd /
+	_scratch_unmount >/dev/null 2>&1
+}
+
+# Import common functions.
+. ./common/filter
+
+_require_scratch
+
+_filter_rgno()
+{
+	# the rg number is in column 4 of xfs_bmap output
+	perl -ne '
+		$rg = (split /\s+/)[4] ;
+		if ($rg =~ /\d+/) {print "$rg "} ;
+	'
+}
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

