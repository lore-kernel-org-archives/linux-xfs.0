Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54349472F97;
	Thu, 24 Sep 2026 10:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244589; cv=none; b=laUUmwTAI++9Eq+Bi4cVa3ZLqmDwKM135lkCEqXg+lWQGluqUiHjm4iVGJY2cNY1Wpsvbb9YPbNPhGqJ5w7XH28fa1djnJUGTugrmRu3K9Db26sFiJX70wDvfeXZKjQR2oL7DkbP0T1iWj/IKwTm8mnkfe+Q6SvTPX6ACuKdQ3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244589; c=relaxed/simple;
	bh=KjtlvELRf/GRymTyCc3b20UYbPT25RSBb3HP2gSuzsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYR+Ud0LjzSukBmQQXIsGLZ9nvWLl2n+Ski4ZXheozFHzuxrimHsRlrzgx3NuSsntWdL7hK5xZm1/F9kX7cE6GdY3colOup5/z79lLz8txvnqqj3IR56FaK70WYqPIvCAmhwoNwVefWFuvpUmUgXKTwNBFHmjk6oW+t7CoZy9Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KgTA/Uc+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KgTA/Uc+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RDqrA9lSZK4eYow8jLT7BWanbLiA5woYIBT41JURGis=; b=KgTA/Uc+oRF/VYFTPk+3DBc8rL
	W6WOFb9ZD/wXouokxK0ACtW7GkUUfucZJhn93Won9wBahfk13xsQB/UHspDBejQh536cUT3hKu0bI
	HX/e4f3iwYHw9owedeCQC/LP6z088md7d8kZIc1cQhx3ZT0jgYD/6nankXEFELNXzgQJyz/+HkHkO
	ZpqrKCUCfXgM2ZXHUGpSnllHLwU0RrU4hND/lxZXRuoNcanY8mJvZC2K5AfbM23QisVtPnK6acF5u
	9D5J5exgQQi4suy13VEpN+yDxKdjwpnpEASu9ydqDKvnMS+40aCJXd2JknPXoLRBv2NDhdSqdUTMJ
	xJ8El2Zw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gOX-0000000Afpq-1NW3;
	Thu, 24 Sep 2026 10:09:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/13] xfs/2305: version of generic/475 that run xfs_scrub -x for each iteration
Date: Thu, 24 Sep 2026 12:07:51 +0200
Message-ID: <20260924100855.2734089-11-hch@lst.de>
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
 tests/xfs/2305     | 75 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/2305.out |  2 ++
 2 files changed, 77 insertions(+)
 create mode 100755 tests/xfs/2305
 create mode 100644 tests/xfs/2305.out

diff --git a/tests/xfs/2305 b/tests/xfs/2305
new file mode 100755
index 000000000000..277f81c13887
--- /dev/null
+++ b/tests/xfs/2305
@@ -0,0 +1,75 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 2305
+#
+# Copied from generic/475, with added xfs_scrub -x calls for each iteration to
+# verify the integrity of all file data and metadata.
+#
+# Test log recovery with repeated (simulated) disk failures.  We kick
+# off fsstress on the scratch fs, then switch out the underlying device
+# with dm-error to see what happens when the disk goes down.  Having
+# taken down the fs in this manner, remount it and repeat.  This test
+# is a Good Enough (tm) simulation of our internal multipath failure
+# testing efforts.
+#
+. ./common/preamble
+_begin_fstest shutdown auto log metadata eio recoveryloop smoketest datacsum
+
+# Override the default cleanup function.
+_cleanup()
+{
+	_kill_fsstress
+	_dmerror_unmount
+	_dmerror_cleanup
+	cd /
+	rm -f $tmp.*
+}
+
+# Import common functions.
+. ./common/dmerror
+
+# Modify as appropriate.
+
+_require_scratch
+_require_dm_target error
+
+echo "Silence is golden."
+
+_scratch_mkfs >> $seqres.full 2>&1
+_require_metadata_journaling $SCRATCH_DEV
+_dmerror_init
+_dmerror_mount
+
+while _soak_loop_running $((50 * TIME_FACTOR)); do
+	_run_fsstress_bg -d $SCRATCH_MNT -n 999999 -p $((LOAD_FACTOR * 4))
+
+	# purposely include 0 second sleeps to test shutdown immediately after
+	# recovery
+	sleep $((RANDOM % 3))
+
+	# This test aims to simulate sudden disk failure, which means that we
+	# do not want to quiesce the filesystem or otherwise give it a chance
+	# to flush its logs.  Therefore we want to call dmsetup with the
+	# --nolockfs parameter; to make this happen we must call the load
+	# error table helper *without* 'lockfs'.
+	_dmerror_load_error_table
+
+	_kill_fsstress
+
+	# Mount again to replay log after loading working table, so we have a
+	# consistent XFS after test.
+	_dmerror_unmount || _fail "unmount failed"
+	_dmerror_load_working_table
+	_dmerror_mount || _fail "mount failed"
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
diff --git a/tests/xfs/2305.out b/tests/xfs/2305.out
new file mode 100644
index 000000000000..8265227294ca
--- /dev/null
+++ b/tests/xfs/2305.out
@@ -0,0 +1,2 @@
+QA output created by 2305
+Silence is golden.
-- 
2.53.0

