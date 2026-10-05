Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E054375ACB;
	Mon,  5 Oct 2026 12:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791204956; cv=none; b=Hjew5wL2igtW/uUOFh6/tlaFy5I+Xplc+UB0xX/NcLSBwB9WHiavoSuZtHeYe26IwsrZ6RPu1Km6VyzhQ+xeq31B0mrxecUIQXY6cuLF+wrJexDJHzIkEDb27mxLJV50oKWNyOFfGKSw9Hr6V1Q8eYfBch1rXztTBCdGJMO5j+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791204956; c=relaxed/simple;
	bh=euyWVYqSbfbD9IHt9T378UkzNt0EqG0/4Cp070vHPRo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ll/OgD+tmwTI0xJVZs0Qyc5mtfoNldpDaWxJWXDf7DxgYt+jYfhlg4E55SIV7c3Xfa809fkd/vXOMXHI1XOqN7qnool23nDusS8fi6udVHyYT/BAlSlQaCii3mSg8vCpjAf5lYEmsOuo/tgw612dobfzicBsDW6sm9JXjth9pw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xM9QY7uC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xM9QY7uC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gpscfjADe8p6HUawEANdMO+qpnpDsdfBE9e4KR/uWOg=; b=xM9QY7uCw0wr55gEkM/ijZAuie
	6XtbOy6iakkq+w3w4XF7IhppfNNcasMQ5b2kNtBLEZNq+RrmySmZ2LAyaMMGj9Ea3Rn3wd3TRrFg+
	2uKbptGlUdWSp5NwPHqHBkHAJDvP6uN2hLr7sQvW2NTWOEY/65886ELZnR8ZJ/DSMvQWn4AARkqEz
	TXVvkpIsTOxMX9rcNQBgqk1rH/2pp0ncYudAYXpsbyBS9A7VKn8whfBv7bJ2/PvWJ8JZr7zi5NUNg
	PVDYIF99PlGaMzscAaB0Ez1b23b/7nLR3KbkD1aKS9Ci586z/UEVhS0icBCAjaI0HgxWlOi3G/f5m
	Em1WZFuw==;
Received: from 2a02-8389-2301-9f00-88fd-fcdd-06aa-821c.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:88fd:fcdd:6aa:821c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiES-0000000GR2P-0MWI;
	Mon, 05 Oct 2026 12:55:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v3] xfs: test libxfs handling of missing RT devices
Date: Mon,  5 Oct 2026 14:55:43 +0200
Message-ID: <20261005125548.1340322-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Test that libxfs rejects initializing a file systems unless in debugger
mode by running xfs_repair and xfs_db with missing arguments.  For
db additionally test that command that require a RT device still do not
work even after libxfs can be initialized using a missing RT device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/2300     | 39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/2300.out | 14 ++++++++++++++
 2 files changed, 53 insertions(+)
 create mode 100755 tests/xfs/2300
 create mode 100644 tests/xfs/2300.out

diff --git a/tests/xfs/2300 b/tests/xfs/2300
new file mode 100755
index 000000000000..9c96e802241f
--- /dev/null
+++ b/tests/xfs/2300
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2026 Christoph Hellwig.
+#
+# FS QA Test No. 2300
+#
+# Tests that repair refuses to work without -r argument, and xfs_db works fine
+# even without it to check libxfs initialization behavior with missing RT
+# devices.
+#
+. ./common/preamble
+_begin_fstest auto quick repair db
+
+. ./common/filter
+
+_require_scratch_nocheck
+_require_external_realtime_device
+
+# require metadir for the rtsb command
+$MKFS_XFS_PROG -f \
+	-m metadir=1 \
+	-r rtdev=$SCRATCH_RTDEV \
+	$SCRATCH_DEV >> $seqres.full 2>&1
+
+echo "Dumping superblock using xfs_db without rtdev"
+$XFS_DB_PROG $SCRATCH_DEV -c 'sb 0' -c 'p' >> $seqres.full
+
+echo "Loading RT superblock using xfs_db without rtdev, should fail"
+$XFS_DB_PROG $SCRATCH_DEV -c 'rtsb'
+
+echo "Running xfs_repair -n without rt device, should fail"
+$XFS_REPAIR_PROG -n $SCRATCH_DEV
+
+echo "Running xfs_repair without rt device, should fail"
+$XFS_REPAIR_PROG $SCRATCH_DEV
+
+
+status=0
+exit
diff --git a/tests/xfs/2300.out b/tests/xfs/2300.out
new file mode 100644
index 000000000000..50aab2b83ec9
--- /dev/null
+++ b/tests/xfs/2300.out
@@ -0,0 +1,14 @@
+QA output created by 2300
+Dumping superblock using xfs_db without rtdev
+Loading RT superblock using xfs_db without rtdev, should fail
+realtime device not loaded, use -R.
+Running xfs_repair -n without rt device, should fail
+Phase 1 - find and verify superblock...
+xfs_repair: filesystem has a realtime subvolume
+xfs_repair: realtime device init failed
+xfs_repair: cannot repair this filesystem.  Sorry.
+Running xfs_repair without rt device, should fail
+Phase 1 - find and verify superblock...
+xfs_repair: filesystem has a realtime subvolume
+xfs_repair: realtime device init failed
+xfs_repair: cannot repair this filesystem.  Sorry.
-- 
2.53.0

