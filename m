Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23603E6DF1;
	Tue, 31 Mar 2026 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970630; cv=none; b=YCtc4su07xM+qmVapVnTcYy/ofl8POIqTqKzpUXXFSEmvbF4ZR2RzJzlsMg4BAAZP1X34Ad3pYjLiL8fGIAGxmOH++jeyv5KmVmMNqL7BL6qk95WZtkXuVBRPMoLOVOv7oI0XejeAVKqEJ1hVKIwR8o2NtPwxr/jxxfzAEzj+lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970630; c=relaxed/simple;
	bh=pRyUQ/TYRH72fhIeGuiYLU9lLLLPWsflTpO/J1WGzdk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z60kzaktRZMXg/N8RwrZJiPoDpOLQI/GQGMzN60Br0BYfnujoPqQaYuDMJKUfnid7CaKuHLECuwmKTuhj84TfXN+xaN2eLTbsIwCoFTtG+uYUf4c1xE/7UUPVBh9EzxFDvFj3DqjG4Vrc2/nZIDXQVRS2vZqGFfjZpscYub3yco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4hc4T4hh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4hc4T4hh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=74coerdAHRWGl/7AAJfyc66/+hEMUcl8G1dgQLtKapQ=; b=4hc4T4hhqGPijqBBkyL5+SuoEW
	7W9sYbx0NpyzAfBlzQWzp2bpbRkj5IbXspW1KMkk5Ivu2xj0GLmcmyN+1VbIVuebCbxO2SDW2sLbn
	DBOxFzbD0ZuCr2ig4ynrHth+fu8dOl7DnNNZia4B09qLfs5xiiTnCO4QBHSHgvaIYkajiZFdc+ZNl
	K6+gC4bM5TMQyMrtsp8vprE5o7M4PAh1aaXwe/Uc8B6PS4rBsZq0XJIA2PLdDxPAL7hMbxu14iLVL
	upf20Kj3JJ6ku/vbvNZzkwl3eZZ7aau4AhW+hCTc0aLWQDvK6gK6vwQTVy30/OtNNuOP/7P8gSTOP
	pPLvOBwA==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7awW-0000000DAeX-0CIL;
	Tue, 31 Mar 2026 15:23:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	dlemoal@kernel.org,
	hans.holmberg@wdc.com,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: add a test for number of open zones on conventional devices
Date: Tue, 31 Mar 2026 17:23:20 +0200
Message-ID: <20260331152341.4047725-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
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

 - delete odd files
 - fix the sysfs attr check to be on the scratch and not the test fs

 tests/xfs/4201     | 66 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/4201.out |  1 +
 2 files changed, 67 insertions(+)
 create mode 100755 tests/xfs/4201
 create mode 100644 tests/xfs/4201.out

diff --git a/tests/xfs/4201 b/tests/xfs/4201
new file mode 100755
index 000000000000..150978a9deda
--- /dev/null
+++ b/tests/xfs/4201
@@ -0,0 +1,66 @@
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
+_require_scratch
+_require_odirect
+_require_non_zoned_device $SCRATCH_DEV
+_require_non_zoned_device $SCRATCH_RTDEV
+
+open_zones=5
+blocks=65536
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
+_scratch_mkfs -b size=${bsize} -r zoned=1,rgsize=${blocks}b \
+	> "$seqres.full" 2>&1
+_scratch_mount -o max_open_zones=${open_zones}
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
+_scratch_mount -o max_open_zones=${open_zones}
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
2.47.3

