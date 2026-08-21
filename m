Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2801E3EC817;
	Fri, 21 Aug 2026 05:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787289283; cv=none; b=Lmc+ASOfbo6WVT6LftWhAQMFv2mgeJtr2UDxeRkl3ouMRNRwtlKbpzCwX8H2nnUA4X72mf324a7iH1A+1BQMn1YOa0LAYVjSIEuNRB/0F8Obx6/9b/d6VUDG98l/okYRgbX/C9VQrIc+KG1mmmSU1DW/Wt7Vqsi/32y1UFz91hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787289283; c=relaxed/simple;
	bh=SZ8t0LOmlLkMp7xSFi85dKwSo/oYx0JSO2EFmKVtqxI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qcJ8oJezmLY+yWlHFkmDrUIAg5YZzWKy0V7dLDkh7G4qjJ3AOa3VEMDKQeBPdKrbS486Y8jaYI6va9LM8edwEq/dip5/dD+W+/op0+mw7dKoH1HamTVc/1nndiTr2Tu3jwSTGTpJxP9KTMI7OVIRryYw3KlwqTry1S18hzUhqak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yNjEeghY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yNjEeghY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=RcF5g/DcNcKLRS/uvocuAfTCgLvmxOc8HPmyi8il6pY=; b=yNjEeghYswquraYNt6I0vDlYnt
	bLFtcJ7QyIiEoOIqulszDeeMI4kNGimEAby02vqbZIMyKAFj5gqW4ZoPyi4IbOKBDvMzutsdKTkmQ
	wEfBtnd2k0qChAZpqNMY0JLT2LHu3497QZZe0uK8OXlje50E8ZjLic2hwhKfqS9sGltDML7VP9Gir
	gcxWMQEU+Xt882Fg8xKTRnQOOp6NwtJAhG0F4eo1cEaiGf5dTKZALHoVWqRMeZKyqLRKfYvxstglr
	6AAzNSW5rnTYYwzjXrAVHajs3sClcntwJ5boep4ifuvh77UhUQz6Vua2vrnvK/lbENnRSDzieBbiD
	afz85U3A==;
Received: from [46.255.74.83] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHaQ-0000000CYNy-45bg;
	Fri, 21 Aug 2026 05:14:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] generic/730: don't override $SCRATCH_DEV
Date: Fri, 21 Aug 2026 07:14:35 +0200
Message-ID: <20260821051435.1818249-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

generic/730 operates on a scsi_debug device, but overrides SCRATCH_DEV
to test for shutdown support.  Switch this to test the shutdown support
on the actual scratch device without overriding it, as shutdown support
should not depend on the actual device, and this ensures that options
that might not work on the scsi_debug device don't get applied to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/730 | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tests/generic/730 b/tests/generic/730
index 1798afb7deea..64d10bba73db 100755
--- a/tests/generic/730
+++ b/tests/generic/730
@@ -25,14 +25,17 @@ _cleanup()
 _require_test
 _require_block_device $TEST_DEV
 _require_scsi_debug
-# scsi_debug doesn't support DAX, so skip this test if MOUNT_OPTIONS
-# contains "dax"
-_exclude_scratch_mount_option "dax"
+
+# The actual test does not use the scratch device, but _require_scratch_shutdown
+# is the most sensible way to check that a file system supports shutdown.
+# Require scratch to use that check, but otherwise just use the scsi_debug
+# device.
+_require_scratch_nocheck
+_require_scratch_shutdown
 
 size=$(_small_fs_size_mb 256)
 SCSI_DEBUG_DEV=`_get_scsi_debug_dev 512 512 0 $size`
 test -b "$SCSI_DEBUG_DEV" || _notrun "Failed to initialize scsi debug device"
-SCRATCH_DEV=$SCSI_DEBUG_DEV _require_scratch_shutdown
 echo "SCSI debug device $SCSI_DEBUG_DEV" >>$seqres.full
 
 run_check _mkfs_dev $SCSI_DEBUG_DEV
-- 
2.53.0

