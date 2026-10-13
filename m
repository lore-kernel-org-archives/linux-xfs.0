Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0868198A17;
	Tue, 13 Oct 2026 00:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791850226; cv=none; b=nhq4lGBs6qbNbnbOQ5Ik6aBLpCkewliVmaG6tRqTjXfIH1CEdyLOd4HENofc/nvTzG6BnCLgrP59YNG0fbAFiwo2UQtljRJcmiDAfNWv4Ne6sJEq2V+kv6towpY/bJr/zDNLuwbAP6cD8yzqTyHew2IZ70iFLgpUaUJcr3inunc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791850226; c=relaxed/simple;
	bh=oEcETex5by4ToBsydI6shaWsOxkAmp+KcDHlVwnceJs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BqnlJ6OcdApdY8G/igebtYrJU7A3PRQuA/QJWWWENMbyk9ZjFoeb29cJRbeWfM4A89XSBxz2Dr9KPQ9sBW4z1PJm4XHH+TnowFQ398iH/2mTSiEv0wnm5ADvHZUtF1Jqs94gCiHRKOqrsHE32RhvxzqV52M60oJyBSfE8Nc2LKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9t8P0Px; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9t8P0Px"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9392B1F0089B;
	Tue, 13 Oct 2026 00:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791850224;
	bh=Z3n4sG4hKfarEzbd2NiabzfGIK/fpu/gJ3vKKXAuow8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=G9t8P0PxzSdE02uPMFqJ4QMukKf123gbo/Rik8Zy8bYBSc8+YVNwdhVuLFkukjrSy
	 LMPmEOgT77ccE0c3KORkCLlN0+qMnEOWMEKxARXw97wc3qK7CdOC6amZi7jp8Ah/uh
	 hXcou2n74i8y/bL6YBveY16RyDwaEcxutSX66PF11hX7bYLblXisqLsQGfQ1FgdkSL
	 9lysik4N7f5OoBmGWi3rs46qJ7vWyNlgXrFV50nsf8ts2S9Vv6bzW46CfiVHlcFx2+
	 yN6QDt4BQDTI9nX03zS1ucsmGA3C1paYVREcEUiIqUHQD8ynWZjfvv1TfZL/txuOGq
	 oaM2+7Kuv/3KQ==
Date: Mon, 12 Oct 2026 17:10:24 -0700
Subject: [PATCH 1/2] xfs: test rt group superblock repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179185007762.1732474.3280794647975804123.stgit@frogsfrogsfrogs>
In-Reply-To: <179185007737.1732474.11416600010761357309.stgit@frogsfrogsfrogs>
References: <179185007737.1732474.11416600010761357309.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Test that we can rewrite the rt superblock if necessary.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1905     |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1905.out |    2 ++
 tests/xfs/1906     |   48 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1906.out |    2 ++
 4 files changed, 105 insertions(+)
 create mode 100755 tests/xfs/1905
 create mode 100644 tests/xfs/1905.out
 create mode 100755 tests/xfs/1906
 create mode 100755 tests/xfs/1906.out


diff --git a/tests/xfs/1905 b/tests/xfs/1905
new file mode 100755
index 00000000000000..98750171762f1d
--- /dev/null
+++ b/tests/xfs/1905
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1905
+#
+# Repair a rtgroup superblock that was overwritten after mount.
+#
+. ./common/preamble
+_begin_fstest online_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+_require_external_realtime_device # rgsuper requires external rt device
+_require_scratch
+_require_scratch_shutdown
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" realtime
+_xfs_force_bdev realtime $SCRATCH_MNT
+_xfs_has_feature "$SCRATCH_MNT" rtgroups || _notrun 'rtgroups not enabled'
+_xfs_has_feature "$SCRATCH_MNT" zoned && _notrun 'no rgsuper on zoned fs'
+
+$XFS_IO_PROG -c 'scrub rgsuper 0' $SCRATCH_MNT
+$XFS_IO_PROG -c 'pwrite -S 0x59 0 512' -c fsync $SCRATCH_RTDEV >> $seqres.full
+$XFS_IO_PROG -c 'scrub rgsuper 0' $SCRATCH_MNT
+$XFS_IO_PROG -x -c 'repair rgsuper 0' $SCRATCH_MNT
+
+_scratch_cycle_mount
+
+$XFS_IO_PROG -c 'scrub rgsuper 0' $SCRATCH_MNT
+$XFS_IO_PROG -c 'pwrite -S 0x59 0 512' -c fsync $SCRATCH_RTDEV >> $seqres.full
+$XFS_IO_PROG -x -c 'repair rgsuper 0' -c 'shutdown' $SCRATCH_MNT
+
+_scratch_cycle_mount
+
+$XFS_IO_PROG -c 'scrub rgsuper 0' $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1905.out b/tests/xfs/1905.out
new file mode 100644
index 00000000000000..4321fcc3524411
--- /dev/null
+++ b/tests/xfs/1905.out
@@ -0,0 +1,2 @@
+QA output created by 1905
+Corruption detected.
diff --git a/tests/xfs/1906 b/tests/xfs/1906
new file mode 100755
index 00000000000000..a1b529004c5359
--- /dev/null
+++ b/tests/xfs/1906
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1906
+#
+# Repair a datadev superblock that was overwritten after mount.
+#
+. ./common/preamble
+_begin_fstest online_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+_require_scratch
+_require_scratch_shutdown
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -c 'scrub sb 0' $SCRATCH_MNT
+$XFS_IO_PROG -c 'pwrite -S 0x59 0 512' -c fsync $SCRATCH_DEV >> $seqres.full
+$XFS_IO_PROG -c 'scrub sb 0' $SCRATCH_MNT
+$XFS_IO_PROG -x -c 'repair sb 0' $SCRATCH_MNT
+
+_scratch_cycle_mount
+
+$XFS_IO_PROG -c 'scrub sb 0' $SCRATCH_MNT
+$XFS_IO_PROG -c 'pwrite -S 0x59 0 512' -c fsync $SCRATCH_DEV >> $seqres.full
+$XFS_IO_PROG -x -c 'repair sb 0' -c 'shutdown' $SCRATCH_MNT
+
+_scratch_cycle_mount
+
+$XFS_IO_PROG -c 'scrub sb 0' $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1906.out b/tests/xfs/1906.out
new file mode 100755
index 00000000000000..062ae73e77273b
--- /dev/null
+++ b/tests/xfs/1906.out
@@ -0,0 +1,2 @@
+QA output created by 1906
+Corruption detected.

