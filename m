Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D26472555;
	Thu, 24 Sep 2026 10:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244580; cv=none; b=RWYD+JDAUlbcDsn7HJL6zp1OxE+tWKoUGltaCTzhp2gTrf1BodSFKrP/NzyK5OpXKFhhUgcWcC2r+cAgLN7tt3DrT43wgWG/gTaYHklaWwOpFxHtQp0EvDSGsRMXefy0x5SEjVnzUJH6llGBbfUYr3XwFzhaWsOWjNMWFxeTv8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244580; c=relaxed/simple;
	bh=82pHFzvLoRxwuKnlQjBkWIKGf0ugI8ZtZq+AC4rox+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbxrxpySL0dmG1Qd7+kR/gCvfSDNAt8Np0bpG/q35FtuGZHGcg9pkjHjYTA1hicL5xjE+XBJ8VlxPkZl5hpVv94pk4IumD+EgH0r4fGQWki1GnZ1V0P6eYFM0Zf80woeaLBDdWzER6C00UcyuqV585q7WkdDD2kVTAmewFu3gb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Owf57pGv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Owf57pGv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IVBNJ0tnnmuHp6bsx33b/1xX7BI4/8nYqcwOMUI2KYA=; b=Owf57pGviZI2bOhqR36riZjz9j
	7RxZ21wo5VLKR7jaTb7k033SamX6aTYmfvWPD5AM7HHn5FTIUbn+9Vfy90PEIjWSxpWNcp70KZb16
	7pt0nA4oyw2ThbMjm3siQFGSoJ4mYMcnfkBeGakGeBLN/CMP+9rh9yF/Wvc0qtBlRVsbQGlqwIB+k
	3PnyyBp4zptEq+AEsuErmPFpn9B34qHPoIRB1stR/WocHN8b6e782dGjxl58GxCiSLpFiG9trkn/G
	WhxQtlT+Aky0P9JORDJncd3c5EPv6Rm9nX9PT+Jn3HKTjuYTFH8W+Citg15StYYzGZWftAbThXrLZ
	pGwg1MXw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gOM-0000000Afp5-3Kwu;
	Thu, 24 Sep 2026 10:09:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/13] xfs/2302: add a basic data checksum test
Date: Thu, 24 Sep 2026 12:07:48 +0200
Message-ID: <20260924100855.2734089-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100855.2734089-1-hch@lst.de>
References: <20260924100855.2734089-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Setup a zoned loop device, mess up the data and make sure both buffered
and direct I/O catch it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/2302     | 96 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/2302.out | 25 ++++++++++++
 2 files changed, 121 insertions(+)
 create mode 100755 tests/xfs/2302
 create mode 100644 tests/xfs/2302.out

diff --git a/tests/xfs/2302 b/tests/xfs/2302
new file mode 100755
index 000000000000..d0ef9abc87b0
--- /dev/null
+++ b/tests/xfs/2302
@@ -0,0 +1,96 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Christoph Hellwig
+#
+# FS QA Test No. 2302
+#
+# Test that data checksums detect data corruption using all three bounce
+# buffering modes.
+#
+. ./common/preamble
+. ./common/filter
+. ./common/zoned
+
+_begin_fstest auto zone quick datacsum
+
+cleanup_devices()
+{
+	[ -n "$mnt" ] && _unmount $mnt 2>/dev/null
+	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
+	_destroy_zloop $zloop_dev
+	cd /
+	rm -rf $loopfile $zloopdir $mnt
+}
+
+_cleanup()
+{
+	cleanup_devices
+}
+
+_require_test
+_require_loop
+_require_zloop
+# hack to only run for block based file systems
+_require_block_device $SCRATCH_DEV
+
+loopfile="$TEST_DIR/loopfile"
+zloopdir="$TEST_DIR/zloop"
+mnt="$TEST_DIR/mnt"
+
+test_error_detection()
+{
+	local bounce_mode=$1
+
+	echo
+	echo
+	echo "Testing bounce mode: $bounce_mode"
+	echo
+
+	rm -rf $loopfile $zloopdir $mnt
+	mkdir -p $mnt
+	truncate -s 1g $loopfile
+
+	local loop_dev=$(_create_loop_device $loopfile)
+	local zloop_dev=$(_create_zloop $zloopdir 256 0)
+	local zloop_id=$(echo $zloop_dev | grep -oE '[0-9]+$')
+
+	_try_mkfs_dev $loop_dev -r rtdev=$zloop_dev,csum=crc32c \
+		>> $seqres.full 2>&1 || \
+		_notrun "cannot mkfs filesystem with data checksums"
+	_mount $loop_dev -o rtdev=$zloop_dev $mnt
+
+	dd if=/dev/urandom of=$mnt/file bs=1M count=200 conv=fsync >/dev/null 2>&1
+
+	local rg=`xfs_bmap -v $mnt/file | head -n 3 | _filter_bmap_gno`
+	local zloop_filename=$(printf "seq-%06u\n" $rg)
+	local backing_file="$zloopdir/$zloop_id/$zloop_filename"
+
+	_unmount $mnt 2>/dev/null
+
+	# intentionally corrupt the data on the backing device
+	xfs_io $backing_file -d -c 'pwrite 0 16384' >> $seqres.full 2>&1
+
+	# should return an error on buffered read
+	_mount $loop_dev -o rtdev=$zloop_dev $mnt
+	_set_fs_sysfs_attr $loop_dev csum/read_bounce $bounce_mode
+	echo "Reading file using cat - should fail"
+	cat $mnt/file > /dev/null | _filter_test_dir
+
+	sleep 1
+	_unmount $mnt 2>/dev/null
+
+	# same with direct I/O
+	_mount $loop_dev -o rtdev=$zloop_dev $mnt
+	_set_fs_sysfs_attr $loop_dev csum/read_bounce $bounce_mode
+	echo "Reading file using O_DIRECT - should fail"
+	xfs_io -d $mnt/file -c 'pread 0 200M' | _filter_test_dir
+
+	sleep 1
+	cleanup_devices
+}
+
+test_error_detection "never"
+test_error_detection "always"
+test_error_detection "lazy"
+
+_exit 0
diff --git a/tests/xfs/2302.out b/tests/xfs/2302.out
new file mode 100644
index 000000000000..5e2108b5cec0
--- /dev/null
+++ b/tests/xfs/2302.out
@@ -0,0 +1,25 @@
+QA output created by 2302
+
+
+Testing bounce mode: never
+
+Reading file using cat - should fail
+cat: /mnt/test/mnt/file: Input/output error
+Reading file using O_DIRECT - should fail
+pread: Input/output error
+
+
+Testing bounce mode: always
+
+Reading file using cat - should fail
+cat: /mnt/test/mnt/file: Input/output error
+Reading file using O_DIRECT - should fail
+pread: Input/output error
+
+
+Testing bounce mode: lazy
+
+Reading file using cat - should fail
+cat: /mnt/test/mnt/file: Input/output error
+Reading file using O_DIRECT - should fail
+pread: Input/output error
-- 
2.53.0

