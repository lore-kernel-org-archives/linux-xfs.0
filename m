Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7397B7441A;
	Thu, 18 Apr 2024 07:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713426059; cv=none; b=pYG0o5QSrKTZf7iBmST9xvhCWk3YKOIptT7Yr5gWPx6wf2W6onxQr3ZVfiz9J9pQA0GAIHuG8UEiFFSj5wVa/9Q4H7L5dEaWwaEum0uEr0Bemm95H5zmVFCQfOciIU1MF1lsiOee0crUQMCb6puPj3w4MZ66r+W0dNarNHVeh4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713426059; c=relaxed/simple;
	bh=oGYRMa7XnWeNt6URGtqXBe7mbRcCRZ7oxuyP2ZrYF2M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P95ey+FissgSeInnhmpTNi+pQqxUGC8hTqCT7OgTd3cUFfzyIFzQNeRuax4uDnc1CzfAyRd/DI0aMRANoHtIrY5BekmZIE4zGxtj8ToEsjZuyGJHHKdMkKR3uUd7nOKdJ1kGyZZLgz/KUvBGtrpbJiIWA/Tp6E7xvprLz8MV60Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=muGVkrcf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="muGVkrcf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Unn7I8/74TCrASjJaagLLfWetVOoFCeL3Aa2qolzRHk=; b=muGVkrcf5U4w4I9fzQebEMkdvs
	/R/Tv9esbt3M1NA9Rhx4/mG+/MovIfQQirJ0NhwiEmIfG2+e/+jFS5SFfbxuSvYDntGnYWnT8lGdh
	4SYQfnbTloguXDcCN2z1vrACKoJBpIR10r+LTgN0tuQ/s2+8XPyzZnkh/Wj/4pUAdyckRjwSJMDl9
	u+8W6W9beJg1w5lvMTjpDLVArIYHEDHqrlhUA4uSU8ijzSZScXt77ksrJFrqxjHP61lmZULw1VAEU
	sChTKMLdaDD5B7HuK272Eji8Xs6tX3xG9K/jwZAhuGm1f4/11NmRzzXWxTYjIbG8/Bpbq/GlPYExZ
	IVzXgSIA==;
Received: from 3.95.143.157.bbcs.as8758.net ([157.143.95.3] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rxMO8-00000001IjN-1d3k;
	Thu, 18 Apr 2024 07:40:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 2/5] xfs/263: split out the v4 test
Date: Thu, 18 Apr 2024 09:40:43 +0200
Message-Id: <20240418074046.2326450-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240418074046.2326450-1-hch@lst.de>
References: <20240418074046.2326450-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the v4-specific test into a separate test case so that we can still
run the tests on a kernel without v4 support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/096     | 73 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/096.out | 84 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/263     |  5 ---
 tests/xfs/263.out | 85 -----------------------------------------------
 4 files changed, 157 insertions(+), 90 deletions(-)
 create mode 100755 tests/xfs/096
 create mode 100644 tests/xfs/096.out

diff --git a/tests/xfs/096 b/tests/xfs/096
new file mode 100755
index 000000000..7eff6cb1d
--- /dev/null
+++ b/tests/xfs/096
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 096
+#
+# test xfs_quota state command (XFS v4 version)
+#
+. ./common/preamble
+_begin_fstest auto quick quota
+
+# Import common functions.
+. ./common/filter
+. ./common/quota
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+
+_require_scratch
+_require_xfs_quota
+
+function option_string()
+{
+	VAL=$1
+	# Treat 3 options as a bit field, prjquota|grpquota|usrquota
+	OPT="rw"
+	if [ "$((VAL & 4))" -ne "0" ]; then OPT=prjquota,${OPT}; fi;
+	if [ "$((VAL & 2))" -ne "0" ]; then OPT=grpquota,${OPT}; fi;
+	if [ "$((VAL & 1))" -ne "0" ]; then OPT=usrquota,${OPT}; fi;
+	echo $OPT
+}
+
+filter_quota_state() {
+	sed -e 's/Inode: #[0-9]\+/Inode #XXX/g' \
+	    -e '/max warnings:/d' \
+	    -e '/Blocks grace time:/d' \
+	    -e '/Inodes grace time:/d' \
+		| _filter_scratch
+}
+
+filter_quota_state2() {
+	sed -e '/User quota state on/d' \
+	    -e '/ Accounting: /d' \
+	    -e '/ Enforcement: /d' \
+	    -e '/ Inode: /d' \
+	    -e '/Blocks max warnings: /d' \
+	    -e '/Inodes max warnings: /d' \
+		| _filter_scratch
+}
+
+function test_all_state()
+{
+	for I in `seq 0 7`; do
+		OPTIONS=`option_string $I`
+		echo "== Options: $OPTIONS =="
+		# Some combinations won't mount on V4 supers (grp + prj)
+		_qmount_option "$OPTIONS"
+		_try_scratch_mount &>> $seqres.full || continue
+		$XFS_QUOTA_PROG -x -c "state -u" $SCRATCH_MNT | filter_quota_state
+		$XFS_QUOTA_PROG -x -c "state -g" $SCRATCH_MNT | filter_quota_state
+		$XFS_QUOTA_PROG -x -c "state -p" $SCRATCH_MNT | filter_quota_state
+		$XFS_QUOTA_PROG -x -c "state -u" $SCRATCH_MNT | filter_quota_state2
+		_scratch_unmount
+	done
+}
+
+_scratch_mkfs_xfs "-m crc=0 -n ftype=0" >> $seqres.full
+test_all_state
+
+status=0
+exit
diff --git a/tests/xfs/096.out b/tests/xfs/096.out
new file mode 100644
index 000000000..1deb7a8c3
--- /dev/null
+++ b/tests/xfs/096.out
@@ -0,0 +1,84 @@
+QA output created by 096
+== Options: rw ==
+== Options: usrquota,rw ==
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode: N/A
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode: N/A
+Blocks grace time: [7 days]
+Inodes grace time: [7 days]
+Realtime Blocks grace time: [7 days]
+== Options: grpquota,rw ==
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode: N/A
+Blocks grace time: [7 days]
+Inodes grace time: [7 days]
+Realtime Blocks grace time: [7 days]
+== Options: usrquota,grpquota,rw ==
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode: N/A
+Blocks grace time: [7 days]
+Inodes grace time: [7 days]
+Realtime Blocks grace time: [7 days]
+== Options: prjquota,rw ==
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode: N/A
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Blocks grace time: [7 days]
+Inodes grace time: [7 days]
+Realtime Blocks grace time: [7 days]
+== Options: usrquota,prjquota,rw ==
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: OFF
+  Enforcement: OFF
+  Inode: N/A
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+  Accounting: ON
+  Enforcement: ON
+  Inode #XXX (1 blocks, 1 extents)
+Blocks grace time: [7 days]
+Inodes grace time: [7 days]
+Realtime Blocks grace time: [7 days]
+== Options: grpquota,prjquota,rw ==
+== Options: usrquota,grpquota,prjquota,rw ==
diff --git a/tests/xfs/263 b/tests/xfs/263
index bd30dab11..54e9355aa 100755
--- a/tests/xfs/263
+++ b/tests/xfs/263
@@ -66,11 +66,6 @@ function test_all_state()
 	done
 }
 
-echo "==== NO CRC ===="
-_scratch_mkfs_xfs "-m crc=0 -n ftype=0" >> $seqres.full
-test_all_state
-
-echo "==== CRC ===="
 _scratch_mkfs_xfs "-m crc=1" >>$seqres.full
 test_all_state
 
diff --git a/tests/xfs/263.out b/tests/xfs/263.out
index 531d45de5..64c1a5876 100644
--- a/tests/xfs/263.out
+++ b/tests/xfs/263.out
@@ -1,89 +1,4 @@
 QA output created by 263
-==== NO CRC ====
-== Options: rw ==
-== Options: usrquota,rw ==
-User quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Group quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Project quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
-== Options: grpquota,rw ==
-User quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode #XXX (1 blocks, 1 extents)
-Group quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Project quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
-== Options: usrquota,grpquota,rw ==
-User quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Group quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Project quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
-== Options: prjquota,rw ==
-User quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode #XXX (1 blocks, 1 extents)
-Group quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Project quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
-== Options: usrquota,prjquota,rw ==
-User quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Group quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Project quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
-== Options: grpquota,prjquota,rw ==
-== Options: usrquota,grpquota,prjquota,rw ==
-==== CRC ====
 == Options: rw ==
 == Options: usrquota,rw ==
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
-- 
2.39.2

