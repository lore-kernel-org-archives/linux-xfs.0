Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF773DEAC7;
	Mon, 18 May 2026 06:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779085526; cv=none; b=k3ovpjzGP/X+2B2OzjO7dVhgiI66apntGMoER06mojGSgPBxybsjS0n196hxEvnwFMpqdKnl38g6t1qQgN6ZbpEHKcHbzql7p7jHkD47B7zaYNwhcADxB7OzCyIw3zbJ3eBvrBwfARnFTOpbQU04uQQ2s8WmcYk5kEJSbuylayY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779085526; c=relaxed/simple;
	bh=K8fKyKyfyT9B6YRo5/qqTrnTjKtGKmREFYfyWC98iuU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q+mQ8eMrHVUSA1zuJG2KElvDFVxpJ+9OsGRXaQi4EEbenqGx2rSM6SbOmyhnjpRcTnTSwOevjgr3EIfly8Ve6LCFncuCJd6u7U5tEuHASpIJkhStuPSPSK6VY7DaOz9MLiRTdaLCyun09MMWHxaTpRKI6PFm/f38UnGz1DsKtYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xxDosa/r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xxDosa/r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=HsQzlFWA5M7uaynzHzr3yG7GBzj5xJfNKrSW2p4kcso=; b=xxDosa/rrEsZUUrPSI3+F3QlVj
	DeuUqW/QVHgQweeAXINoWJlDs+4OwW+kuuzwo1uSKMh56xu6ST6wREbALtNmTB3cFMW+DEu9QxB5U
	Osy6fqm/CJA6mc2gRZNBY+NrtZpkn/DqoxKDCYzfh2471ilgCIL8bh2aRay+dDwfwwdi8ggstMvAK
	KO9sFiDDCXHEUZ+SbBXmKVB8xjvrPeKMaHT+pWwRMcHBcLWcSfsXf1uKY3KSEB67ya4NouOccM9K7
	1y8mbO8Qfir5l5uJsdaRGuhStNqLpRo6/di8xsuLS+RbMws8wHB8AtrSUY9puFOr8jY6I0mFh939u
	QW4VUPXQ==;
Received: from [2001:4bb8:2ee:fcf2:e6ad:a575:3e60:e254] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOrPk-0000000EQJo-07jE;
	Mon, 18 May 2026 06:25:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: cmaiolino@redhat.com,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] generic: add a test that stresses metadata eviction
Date: Mon, 18 May 2026 08:24:53 +0200
Message-ID: <20260518062514.506071-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The fsverity test generic/759 could be used to reproduce a regression in
the xfs buffer hashing.  Carlos Maiolino figured out that even removing
the fsverity-specific bits would reproduce the issue.  This test is
thus a copy of generic/759 with the fsverity bits striped out, and
run 5 times as that seems to be the threshold at which the issue
reproduces reliably.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

Not sure how to best credit Eric for the original patch and Carlos
for the extraction, any ideas?

 tests/generic/4201     | 108 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/4201.out |   2 +
 2 files changed, 110 insertions(+)
 create mode 100755 tests/generic/4201
 create mode 100644 tests/generic/4201.out

diff --git a/tests/generic/4201 b/tests/generic/4201
new file mode 100755
index 000000000000..fc367beeadaf
--- /dev/null
+++ b/tests/generic/4201
@@ -0,0 +1,108 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/4201
+#
+# Race dropping file systems caches vs fsstress an repeated reading of files.
+# Based on generic/579 with the fsverity bits stripped out, and an increased
+# number of runs.
+#
+. ./common/preamble
+_begin_fstest auto stress
+
+stop_run()
+{
+	# Stop all subprocesses.
+	_kill_fsstress
+	touch $tmp.done
+	wait
+}
+
+_cleanup()
+{
+	stop_run
+	rm -f $tmp.*
+}
+
+. ./common/filter
+
+fsv_file_size=10000000
+nproc_enabler=$((4 * LOAD_FACTOR))
+nproc_reader=$((6 * LOAD_FACTOR))
+nproc_stress=$((3 * LOAD_FACTOR))
+runtime=$((20 * TIME_FACTOR))
+
+run_test()
+{
+	rm -rf $tmp.done
+
+	# Create the test files and start the fs-verity enabler processes.
+	for ((proc = 0; proc < nproc_enabler; proc++)); do
+		orig_file=$SCRATCH_MNT/orig$proc
+		fsv_file=$SCRATCH_MNT/fsv$proc
+		head -c $fsv_file_size /dev/urandom > $orig_file
+		(
+			while [ ! -e $tmp.done ]; do
+				rm -f $fsv_file
+				cp $orig_file $fsv_file
+				# Give the readers some time to read from the file.
+				sleep 0.$((RANDOM % 100))
+			done
+		) &
+	done
+
+	# Start the reader processes.
+	for ((proc = 0; proc < nproc_reader; proc++)); do
+		(
+			while [ ! -e $tmp.done ]; do
+				# Choose a random file for each iteration, so that
+				# sometimes multiple processes read from the same file.
+				i=$((RANDOM % nproc_enabler))
+				orig_file=$SCRATCH_MNT/orig$i
+				fsv_file=$SCRATCH_MNT/fsv$i
+
+				# After the copy from $orig_file to $fsv_file has
+				# completed, the contents of these two files should
+				# match, regardless of whether verity has been enabled
+				# or not yet (or is currently being enabled).
+				cmp $orig_file $fsv_file |& _filter_scratch | \
+					sed -e "s/'//g" | \
+					grep -v "SCRATCH_MNT/fsv$i: No such file or directory" | \
+					grep -v "EOF on SCRATCH_MNT/fsv$i"
+				done
+		) &
+	done
+
+	# Start a process that occasionally runs 'sync && drop_caches'.  This makes more
+	# reads go through fs-verity for real, rather than just returning pagecache.
+	(
+		while [ ! -e $tmp.done ]; do
+			sleep 2.$((RANDOM % 100))
+			_scratch_sync && echo 3 > /proc/sys/vm/drop_caches
+		done
+	) &
+
+	# Start the fsstress processes.
+	_run_fsstress_bg -p $nproc_stress -l 0 -d $SCRATCH_MNT/stressdir
+
+	# Run for a while.
+	sleep $runtime
+
+	stop_run
+}
+
+for i in $(seq 1 5); do
+	echo "Starting run $i" >> $seqres.full
+
+	_scratch_mkfs &>> $seqres.full
+	_scratch_mount
+	run_test
+	_scratch_unmount
+done
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/4201.out b/tests/generic/4201.out
new file mode 100644
index 000000000000..2c3f3d42ff3f
--- /dev/null
+++ b/tests/generic/4201.out
@@ -0,0 +1,2 @@
+QA output created by 4201
+Silence is golden
-- 
2.53.0

