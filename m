Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C48386554;
	Tue, 14 Apr 2026 07:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776153380; cv=none; b=FxRgl++4nFTboGKDSoVNTToNjqlf94bX1lsyTJthKxkDt/NIBkxwRrBfa5sERXIhLV4eWwXknD3jnoUroPKroxW3oR4jKGKdqS5MOlnAMWzagGTVPvEVVkJaYyQkhuXesHVGb+QJWChypob2sCobnRSqFhookrXtubVRQK9JlUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776153380; c=relaxed/simple;
	bh=pWVewNiZ+Kb21Y3Sv3VeuIk1Y12Rj/xzuq6odhHVq08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=myjAT/PRq1F5Jtqq9iggSZbHdnw6ft80iFLUlWuE3ujagtnntmL8cuomCxdNVcHDjb3wCPPxMjKEIxRS8qK3T10XrxzRfPC0Dn5bP4eUswC3PqotRm9QGR+CVpZxYrl79k0OCjqUDknmXYOun1VqZnI13Bn0sR4g4M9ndSR6gls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N8oBXd/N; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N8oBXd/N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WVxMBqL1gFWzzwxQ9lyPCjZhsDPr4E+zJs2+x22l0tM=; b=N8oBXd/NlbjKeY/eh4e8/wJIns
	yvikCVcCxzRm9QxnRTn35XYr3raCk/+n4hbAGWpdwwDjvG4PtE/W46O747m9NwS9u7c1FPJeePos9
	2UfODr/A7FOVVlWukNZQSbSCIW17V4fBZMQ3log5KmCDXOSXycT348UEVSmhob+Ki6IObHKEppR67
	A4VLcKvbGIzrX63ADZU4JWPKcFTtqxZ6tKQsC0ZDAb2XUwuB7pSE0dMBuxCd+Bh2PGDO+d/2zhT3A
	RMVZB6TYXyNVsaojtnKU0SNUUiBCxNxhdGq0Z69Zy5lw/IvSjIrIJjyL4mf2Xs2I0L2vFp5dWAjnV
	4RXg5c/Q==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCYd7-0000000GvdK-3u07;
	Tue, 14 Apr 2026 07:56:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	dlemoal@kernel.org,
	hans.holmberg@wdc.com,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3] xfs: add a test for number of open zones on conventional devices
Date: Tue, 14 Apr 2026 09:55:47 +0200
Message-ID: <20260414075613.544106-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Test that mounts of zoned file systems on conventional devices don't
create more open zones than allowed when the last blocks in one or more
zones have been invalidated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Changes since v2:
 - use raw mkfs to avoid injecting a real RT device
 - _notrun with a useful message when the mkfs or mount fails due to lack
   of RT device or zoned block device support

 tests/xfs/4201     | 69 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4201.out |  1 +
 2 files changed, 70 insertions(+)
 create mode 100755 tests/xfs/4201
 create mode 100644 tests/xfs/4201.out

diff --git a/tests/xfs/4201 b/tests/xfs/4201
new file mode 100755
index 000000000000..56084bca41c0
--- /dev/null
+++ b/tests/xfs/4201
@@ -0,0 +1,69 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Christoph Hellwig.
+#
+# FS QA Test No. 4201
+#
+# Test that mounts of zoned file systems on conventional devices don't create
+# more open zones than allowed when the last blocks in one or more zones have
+# been invalidated.
+#
+
+. ./common/preamble
+_begin_fstest auto quick zone
+
+_require_scratch_nocheck
+_require_odirect
+_require_non_zoned_device $SCRATCH_DEV
+_require_non_zoned_device $SCRATCH_RTDEV
+
+open_zones=5
+blocks=16384
+bsize=4096
+
+zone_size_mib=$((blocks * bsize / 1024 / 1024))
+file_size_mib=$((zone_size_mib / 2))
+nr_files=$((open_zones * 3 - 1))
+
+echo "zone size: $zone_size_mib" >>$seqres.full
+echo "file size: $file_size_mib" >>$seqres.full
+echo "nr files: $nr_files" >>$seqres.full
+
+# don't use _scratch_mkfs/_scratch_mount to avoid injection a real RT device
+$MKFS_XFS_PROG -b size=${bsize} -r zoned=1,rgsize=${blocks}b \
+	$SCRATCH_DEV > "$seqres.full" 2>&1 || \
+		_notrun "Zoned mkfs not supported"
+_mount $SCRATCH_DEV $SCRATCH_MNT -o max_open_zones=${open_zones} || \
+	_notrun "Zoned allocator not supported"
+
+_has_fs_sysfs_attr $SCRATCH_DEV zoned/nr_open_zones || \
+	_notrun "This test requires /sys/fs/${FSTYP}/$SCRATCH_DEV/zoned/nr_open_zones"
+
+for i in $(seq 1 $nr_files); do
+	dd if=/dev/zero of=$SCRATCH_MNT/$i bs=1M count=$file_size_mib \
+		 oflag=direct > /dev/null 2>&1
+done
+
+# delete odd numbered files as they should be at the end of the zones
+for ((i = 0; i < $nr_files; i = $((i + 2)))); do
+	rm $SCRATCH_MNT/$((i + 1))
+done
+
+_scratch_unmount
+_mount $SCRATCH_DEV $SCRATCH_MNT -o max_open_zones=${open_zones}
+
+max_open=$(_get_fs_sysfs_attr $SCRATCH_DEV zoned/max_open_zones)
+nr_open=$(_get_fs_sysfs_attr $SCRATCH_DEV zoned/nr_open_zones)
+
+if [ ${max_open} -ne $((open_zones - 1)) ]; then
+	_fail "Test needs adjustments for multiple open GC zones"
+fi
+
+if [ ${nr_open} -gt ${max_open} ]; then
+	_fail "Too many open zones: $nr_open/$max_open"
+fi
+
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/xfs/4201.out b/tests/xfs/4201.out
new file mode 100644
index 000000000000..32e395dd4d6d
--- /dev/null
+++ b/tests/xfs/4201.out
@@ -0,0 +1 @@
+QA output created by 4201
-- 
2.53.0

