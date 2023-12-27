Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D96644;
	Mon,  1 Jan 2024 01:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CwNaXt6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC61C433C7;
	Mon,  1 Jan 2024 01:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070868;
	bh=dmBTfiAJigB4Xq3+7Cdcl5eClHzGxnU3SAmz8EQDx4s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CwNaXt6Coz17uwtrYRU/7zW/14eAQcFAaKNP5vjAMx0WunEMLDU7x3IJcGqbHbRqD
	 I4lHc7ni0xR61thQJgDrQ8Eu5AyaPqT45L2G4MEYI/vqUd/fcg82zTjSwhqzZ6ioIs
	 jqyeO/oGKN1kUc1stAO3V01nlzGoEBHJhY2LyEAqHcQmt1jey08CVUAQOO9+CtFglw
	 1BYA9VmbBo5EYmkAi8xm/HwFIznARZqg3IZt/gCnZqu/zoykd34ZCWz+9mgPZqtqw/
	 ndIVvKYDIlYs0N4H69nYh+z9tt9zjM8bRsI2jvidOAON7FMguXpg57lTx3YmiOK4+s
	 vlbBZhQ3QQSxA==
Date: Sun, 31 Dec 2023 17:01:07 +9900
Subject: [PATCH 13/13] fuzzy: create missing fuzz tests for rt rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031404.1826914.5544607212081205345.stgit@frogsfrogsfrogs>
In-Reply-To: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
References: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Back when I first created the fuzz tests for the realtime rmap btree, I
forgot a couple of things.  Add tests to fuzz rtrmap btree leaf records,
and node keys.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1528     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1528.out |    4 ++++
 tests/xfs/1529     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1529.out |    4 ++++
 tests/xfs/407      |    2 +-
 5 files changed, 90 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1528
 create mode 100644 tests/xfs/1528.out
 create mode 100755 tests/xfs/1529
 create mode 100644 tests/xfs/1529.out


diff --git a/tests/xfs/1528 b/tests/xfs/1528
new file mode 100755
index 0000000000..24cbb55c23
--- /dev/null
+++ b/tests/xfs/1528
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1528
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt record field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
+
+echo "Fuzz rtrmapbt recs"
+_scratch_xfs_fuzz_metadata '' 'both' "path -m $path" "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing rtrmapbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1528.out b/tests/xfs/1528.out
new file mode 100644
index 0000000000..b51b640c40
--- /dev/null
+++ b/tests/xfs/1528.out
@@ -0,0 +1,4 @@
+QA output created by 1528
+Format and populate
+Fuzz rtrmapbt recs
+Done fuzzing rtrmapbt recs
diff --git a/tests/xfs/1529 b/tests/xfs/1529
new file mode 100755
index 0000000000..3930edad47
--- /dev/null
+++ b/tests/xfs/1529
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1529
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+
+echo "Fuzz rtrmapbt keyptrs"
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' "path -m $path" >> $seqres.full
+echo "Done fuzzing rtrmapbt keyptrs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1529.out b/tests/xfs/1529.out
new file mode 100644
index 0000000000..808fcc957f
--- /dev/null
+++ b/tests/xfs/1529.out
@@ -0,0 +1,4 @@
+QA output created by 1529
+Format and populate
+Fuzz rtrmapbt keyptrs
+Done fuzzing rtrmapbt keyptrs
diff --git a/tests/xfs/407 b/tests/xfs/407
index 2460ea336c..bd439105e2 100755
--- a/tests/xfs/407
+++ b/tests/xfs/407
@@ -26,7 +26,7 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
-path="$(_scratch_xfs_find_rgbtree_height 'rmap' 1)" || \
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
 	_fail "could not find two-level rtrmapbt"
 inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
 

