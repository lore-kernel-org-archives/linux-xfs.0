Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AFCC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbiLaDI3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbiLaDI2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:08:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CD81054D;
        Fri, 30 Dec 2022 19:08:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B20E461D33;
        Sat, 31 Dec 2022 03:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D024C433EF;
        Sat, 31 Dec 2022 03:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456106;
        bh=IYhc+HmsqaNHoWwpZz/jZLTCQqHhZF3GWE+egNFNDns=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RS4c/E18D6TyUT1OXaiAVWOy1Eb+2ZXidxG8YVnmN8RyoIICuzC59vgP0EAduDsIk
         lVPRxytU/wIMlSahwY3yWYP3vcTaHf6jng32LKsk77gA+X45yT2VZCPbTIQzWG5/DC
         1zSmFVatX8GRxHPDrhNhZzH2ISP1OHs2vqJK/+xfarnpMRWuR/dHS3TpAe+dn/03rn
         cTjFvPv/zLNVAPzuCeHs90zRTZWdi6d3h3MioMn3ndl38IDSTWYVM8zycNDHVk2qxd
         CW4lC9X9wFSoLRmoXMPdAA0R5mUAq4gRXN3jgtzRJdW7WAbNpyeTUo9XLU9pC/cO2L
         uiwfope2tcziw==
Subject: [PATCH 9/9] xfs: create fuzz tests for metadata directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:33 -0800
Message-ID: <167243883352.736753.14842800987314221725.stgit@magnolia>
In-Reply-To: <167243883244.736753.17143383151073497149.stgit@magnolia>
References: <167243883244.736753.17143383151073497149.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create fuzz tests to make sure that all the validation works for
metadata directories and subdirectories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs         |   22 ++++++++++++++++++++++
 tests/xfs/1546     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1546.out |    4 ++++
 tests/xfs/1547     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1547.out |    4 ++++
 tests/xfs/1548     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1548.out |    4 ++++
 tests/xfs/1549     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1549.out |    4 ++++
 tests/xfs/1550     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1550.out |    4 ++++
 tests/xfs/1551     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1551.out |    4 ++++
 tests/xfs/1552     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1552.out |    4 ++++
 tests/xfs/1553     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1553.out |    4 ++++
 17 files changed, 352 insertions(+)
 create mode 100755 tests/xfs/1546
 create mode 100644 tests/xfs/1546.out
 create mode 100755 tests/xfs/1547
 create mode 100644 tests/xfs/1547.out
 create mode 100755 tests/xfs/1548
 create mode 100644 tests/xfs/1548.out
 create mode 100755 tests/xfs/1549
 create mode 100644 tests/xfs/1549.out
 create mode 100755 tests/xfs/1550
 create mode 100644 tests/xfs/1550.out
 create mode 100755 tests/xfs/1551
 create mode 100644 tests/xfs/1551.out
 create mode 100755 tests/xfs/1552
 create mode 100644 tests/xfs/1552.out
 create mode 100755 tests/xfs/1553
 create mode 100644 tests/xfs/1553.out


diff --git a/common/xfs b/common/xfs
index 99e377631b..77af8a6d60 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1806,3 +1806,25 @@ _xfs_calc_metadir_files() {
 	local metafiles="$($XFS_IO_PROG -c 'bulkstat -m' "$mount" 2>&1 | grep '^bs_ino' | wc -l)"
 	echo $((metafiles - regfiles))
 }
+
+_require_xfs_mkfs_metadir()
+{
+	_scratch_mkfs_xfs_supported -m metadir=1 >/dev/null 2>&1 || \
+		_notrun "mkfs.xfs doesn't have metadir features"
+}
+
+_require_xfs_scratch_metadir()
+{
+	_require_xfs_mkfs_metadir
+	_require_scratch
+
+	_scratch_mkfs -m metadir=1 &> /dev/null
+	_require_scratch_xfs_features METADIR
+	_try_scratch_mount
+	res=$?
+	if [ $res -ne 0 ]; then
+		_notrun "mounting with metadir not supported by filesystem type: $FSTYP"
+	else
+		_scratch_unmount
+	fi
+}
diff --git a/tests/xfs/1546 b/tests/xfs/1546
new file mode 100755
index 0000000000..5b48463abe
--- /dev/null
+++ b/tests/xfs/1546
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1546
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
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
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'online' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1546.out b/tests/xfs/1546.out
new file mode 100644
index 0000000000..b72891a758
--- /dev/null
+++ b/tests/xfs/1546.out
@@ -0,0 +1,4 @@
+QA output created by 1546
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1547 b/tests/xfs/1547
new file mode 100755
index 0000000000..ff86bc657e
--- /dev/null
+++ b/tests/xfs/1547
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1547
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
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
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'offline' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1547.out b/tests/xfs/1547.out
new file mode 100644
index 0000000000..983cc01343
--- /dev/null
+++ b/tests/xfs/1547.out
@@ -0,0 +1,4 @@
+QA output created by 1547
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1548 b/tests/xfs/1548
new file mode 100755
index 0000000000..1f29dfda3b
--- /dev/null
+++ b/tests/xfs/1548
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1548
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_norepair
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
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'none' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1548.out b/tests/xfs/1548.out
new file mode 100644
index 0000000000..9e395bb059
--- /dev/null
+++ b/tests/xfs/1548.out
@@ -0,0 +1,4 @@
+QA output created by 1548
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1549 b/tests/xfs/1549
new file mode 100755
index 0000000000..865023f218
--- /dev/null
+++ b/tests/xfs/1549
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1549
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_bothrepair
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
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'both' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1549.out b/tests/xfs/1549.out
new file mode 100644
index 0000000000..22b3d215e3
--- /dev/null
+++ b/tests/xfs/1549.out
@@ -0,0 +1,4 @@
+QA output created by 1549
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1550 b/tests/xfs/1550
new file mode 100755
index 0000000000..62219e65fc
--- /dev/null
+++ b/tests/xfs/1550
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1550
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
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
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'online' 'path -m /realtime' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1550.out b/tests/xfs/1550.out
new file mode 100644
index 0000000000..7694cd670b
--- /dev/null
+++ b/tests/xfs/1550.out
@@ -0,0 +1,4 @@
+QA output created by 1550
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1551 b/tests/xfs/1551
new file mode 100755
index 0000000000..f101529364
--- /dev/null
+++ b/tests/xfs/1551
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1551
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair
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
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'offline' 'path -m /realtime' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1551.out b/tests/xfs/1551.out
new file mode 100644
index 0000000000..4c3360d08b
--- /dev/null
+++ b/tests/xfs/1551.out
@@ -0,0 +1,4 @@
+QA output created by 1551
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1552 b/tests/xfs/1552
new file mode 100755
index 0000000000..ab3b89ec40
--- /dev/null
+++ b/tests/xfs/1552
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1552
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_norepair
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
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'none' 'path -m /realtime' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1552.out b/tests/xfs/1552.out
new file mode 100644
index 0000000000..6636b1b656
--- /dev/null
+++ b/tests/xfs/1552.out
@@ -0,0 +1,4 @@
+QA output created by 1552
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1553 b/tests/xfs/1553
new file mode 100755
index 0000000000..6acbacbe16
--- /dev/null
+++ b/tests/xfs/1553
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1553
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_bothrepair
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
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'both' 'path -m /realtime' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1553.out b/tests/xfs/1553.out
new file mode 100644
index 0000000000..0298fcfddb
--- /dev/null
+++ b/tests/xfs/1553.out
@@ -0,0 +1,4 @@
+QA output created by 1553
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir

