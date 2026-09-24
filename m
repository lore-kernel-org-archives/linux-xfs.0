Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF01E431E51;
	Thu, 24 Sep 2026 10:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244590; cv=none; b=bu9/6iQdA2VarsPpc1yttdceZE8nFTX3jwrM94gP76UX74ZstHzwKSD7jo7mvtuJgg8PMp075+PDQCf8JYY2s+bycllNJzMFZFK3MyWva5PkNFpxRq6Z+Btfdq1CfpxHfA+PfyEJ/PGAiT1T9DV4I2JJD79p+U4H2i7bWbtCTRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244590; c=relaxed/simple;
	bh=z/1KWruy2ikqRPP3NLIL5yoTGHjac0+o7uxwJVmhDDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CB3FVI4d4bofWnimnxEkJUk4hBQ5j6eSvbGplITQKCdLLKLpDhGitOVc3ul1agpqFef50KUto3la+t0WU3YSIjI1sqyi0NZ7RkukxTF0VE04PtgEdLXRAn4M9vhhCSdupYiZKbeXhBjDGsot7gVFESfZHbVR2RP56ZhXx1x4klw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=alxo1x+q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="alxo1x+q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FdEhYqENsWzi1/2fOxqdFnszsuNYFdX6lG2gg3dWKgk=; b=alxo1x+qkp6bYYS7NJSmKKd2EJ
	an7+twUd8ru+buxlN/r+GjWue4laxCqwobiXD1VtziFyN2sZeltWylXQ0vTQKCE/HJ3LtQp/6E7TO
	wariNqkMAnw8pk61RD19N8yeHg3mMu8A/ZTKe4mdHHyPA1z0+WF/B4MR99DQvqoL8Musvecg4Lw3L
	jrlKZUAb7wm2XTVBTbNtp13a4eSmegw5E6Gz5egBH/bwxaGu5u3MbNdYBJNnixbJ5w6LyDEPJYiXS
	OOFXF7FuBP4BXVGa+CTvg8Yv5+ztUvGKpBZE1RNV/JC5spiNCbvLQycD7BZU25t7Zg2f61eJ2IGrd
	hJtOirRg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gOU-0000000AfpS-0A9H;
	Thu, 24 Sep 2026 10:09:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/13] xfs/2304: version of generic/388 that run xfs_scrub -x for each iteration
Date: Thu, 24 Sep 2026 12:07:50 +0200
Message-ID: <20260924100855.2734089-10-hch@lst.de>
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

To check both the metadata integrity and file system checksums after
log replay.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/2304     | 61 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/2304.out |  2 ++
 2 files changed, 63 insertions(+)
 create mode 100755 tests/xfs/2304
 create mode 100644 tests/xfs/2304.out

diff --git a/tests/xfs/2304 b/tests/xfs/2304
new file mode 100755
index 000000000000..ad4f45d79057
--- /dev/null
+++ b/tests/xfs/2304
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 2304
+#
+# Copied from generic/388, with added xfs_scrub -x calls for each iteration to
+# verify the integrity of all file data and metadata.
+#
+# Test XFS log recovery ordering on v5 superblock filesystems. XFS had a problem
+# where it would incorrectly replay older modifications from the log over more
+# recent versions of metadata due to failure to update metadata LSNs during log
+# recovery. This could result in false positive reports of corruption during log
+# recovery and permanent mount failure.
+#
+# To test this situation, run frequent shutdowns immediately after log recovery.
+# Ensure that log recovery does not recover stale modifications and cause
+# spurious corruption reports and/or mount failures.
+#
+. ./common/preamble
+_begin_fstest shutdown auto log metadata recoveryloop datacsum
+
+_require_scratch
+_require_local_device $SCRATCH_DEV
+_require_scratch_shutdown
+
+echo "Silence is golden."
+
+_scratch_mkfs >> $seqres.full 2>&1
+_require_metadata_journaling $SCRATCH_DEV
+_scratch_mount
+_require_scratch_xfs_scrub
+
+while _soak_loop_running $((50 * TIME_FACTOR)); do
+	_run_fsstress_bg -d $SCRATCH_MNT -n 999999 -p 4
+
+	# purposely include 0 second sleeps to test shutdown immediately after
+	# recovery
+	sleep $((RANDOM % 3))
+	_scratch_shutdown
+
+	_kill_fsstress
+
+	# Toggle between rw and ro mounts for recovery. Quit if any mount
+	# attempt fails so we don't shutdown the host fs.
+	if [ $((RANDOM % 2)) -eq 0 ]; then
+		_scratch_cycle_mount || _fail "cycle mount failed"
+	else
+		_scratch_cycle_mount "ro" || _fail "cycle ro mount failed"
+		_scratch_cycle_mount || _fail "cycle rw mount failed"
+	fi
+
+	$XFS_SCRUB_PROG -x $SCRATCH_MNT >> $seqres.full 2>&1
+	if [ $? -ne 0 ]; then
+		_fail "scrub found errors"
+	fi
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/2304.out b/tests/xfs/2304.out
new file mode 100644
index 000000000000..07ee489db9fa
--- /dev/null
+++ b/tests/xfs/2304.out
@@ -0,0 +1,2 @@
+QA output created by 2304
+Silence is golden.
-- 
2.53.0

