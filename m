Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67700C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbiLaAvB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiLaAu4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:50:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E3E13F29;
        Fri, 30 Dec 2022 16:50:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4F5DB81D68;
        Sat, 31 Dec 2022 00:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5065C433EF;
        Sat, 31 Dec 2022 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447852;
        bh=dvyjhui+iQxyCoW6tJ2MrhnAfdiB75xuzwOH/4sotsw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QmClZxmZW/4HMZWdG55gFHYcBC8mI2d93mVadg9Ms8HkxQMaYubtA6KSKzXZuQpvC
         /wc4CfoUGu/1jxJIUVNomjKzNwkmgTCUzYqKOhPVipscOpdnFIoBSZ7poMg7DO7jjW
         RUMB9f/MWT78ilFvuiGdpoLXFwZdBPf09CEXb5VSejezP1imFrf96MAlJBCJpwEgyf
         JYXdK+CqINCRYMh0cRz15dpCLCZqpiqaAj+oIXvzf/WJwAkyfpYTaPQ3oNGkGj3kTj
         ZpAjj4eaeH/vFmF53f8Gd8YQC7SrYZ5EK4Xw23/pVp5NCCjevfomPH4SN4g+rL7Se6
         3fkGiQak4aEuA==
Subject: [PATCH 2/5] fuzzy: test fuzzing xattr block mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:44 -0800
Message-ID: <167243878496.731641.9800334424221991155.stgit@magnolia>
In-Reply-To: <167243878469.731641.981302372644525592.stgit@magnolia>
References: <167243878469.731641.981302372644525592.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fuzz the block mappings of extended attributes to see what happens.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy       |   16 ++++++++++++++++
 tests/xfs/1557     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1557.out |   10 ++++++++++
 tests/xfs/1558     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1558.out |   10 ++++++++++
 tests/xfs/1559     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1559.out |   10 ++++++++++
 7 files changed, 190 insertions(+)
 create mode 100755 tests/xfs/1557
 create mode 100644 tests/xfs/1557.out
 create mode 100755 tests/xfs/1558
 create mode 100644 tests/xfs/1558.out
 create mode 100755 tests/xfs/1559
 create mode 100644 tests/xfs/1559.out


diff --git a/common/fuzzy b/common/fuzzy
index 09f42d9225..d8eb7d8b72 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -565,6 +565,22 @@ _scratch_xfs_set_dir_fuzz_types() {
 	SCRATCH_XFS_DIR_FUZZ_TYPES=(BLOCK LEAF LEAFN NODE)
 }
 
+# Sets the array SCRATCH_XFS_XATTR_FUZZ_TYPES to the list of xattr formats
+# available for fuzzing.  Each list item must match one of the /ATTR.FMT_*
+# files created by the fs population code.  Users can override this by setting
+# SCRATCH_XFS_LIST_FUZZ_XATTRTYPE in the environment.  BTREE is omitted here
+# because that refers to the fork format and does not affect the extended
+# attribute structure at all.
+_scratch_xfs_set_xattr_fuzz_types() {
+	if [ -n "${SCRATCH_XFS_LIST_FUZZ_XATTRTYPE}" ]; then
+		mapfile -t SCRATCH_XFS_XATTR_FUZZ_TYPES < \
+				<(echo "${SCRATCH_XFS_LIST_FUZZ_XATTRTYPE}" | tr '[ ,]' '[\n\n]')
+		return
+	fi
+
+	SCRATCH_XFS_XATTR_FUZZ_TYPES=(EXTENTS_REMOTE3K EXTENTS_REMOTE4K LEAF NODE)
+}
+
 # Grab the list of available fuzzing verbs
 _scratch_xfs_list_fuzz_verbs() {
 	if [ -n "${SCRATCH_XFS_LIST_FUZZ_VERBS}" ]; then
diff --git a/tests/xfs/1557 b/tests/xfs/1557
new file mode 100755
index 0000000000..afd5d31f62
--- /dev/null
+++ b/tests/xfs/1557
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1555
+#
+# Populate a XFS filesystem and fuzz the attr mappings of every xattr type.
+# Use xfs_scrub to fix the corruption.
+#
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
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+_scratch_xfs_set_xattr_fuzz_types
+
+# Now fuzz the block maps of each xattr type.
+for attrtype in "${SCRATCH_XFS_XATTR_FUZZ_TYPES[@]}"; do
+	echo "Fuzz block map for ${attrtype}" | tee -a $seqres.full
+
+	# Restore a correct copy of the filesystem before we start a round of
+	# fuzzing.  This avoids corruption errors from xfs_db when
+	# _scratch_xfs_fuzz_metadata probes the xattr block fields.
+	__scratch_xfs_fuzz_mdrestore
+
+	_scratch_mount
+	inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_${attrtype})
+	_scratch_unmount
+
+	_scratch_xfs_fuzz_metadata 'a*.bmx' 'online'  "inode ${inum}" >> $seqres.full
+	echo "Done fuzzing attr map ${attrtype}"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1557.out b/tests/xfs/1557.out
new file mode 100644
index 0000000000..e4d92dd6b8
--- /dev/null
+++ b/tests/xfs/1557.out
@@ -0,0 +1,10 @@
+QA output created by 1557
+Format and populate
+Fuzz block map for EXTENTS_REMOTE3K
+Done fuzzing attr map EXTENTS_REMOTE3K
+Fuzz block map for EXTENTS_REMOTE4K
+Done fuzzing attr map EXTENTS_REMOTE4K
+Fuzz block map for LEAF
+Done fuzzing attr map LEAF
+Fuzz block map for NODE
+Done fuzzing attr map NODE
diff --git a/tests/xfs/1558 b/tests/xfs/1558
new file mode 100755
index 0000000000..0683b06010
--- /dev/null
+++ b/tests/xfs/1558
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1557
+#
+# Populate a XFS filesystem and fuzz the attr mappings of every xattr type.
+# Use xfs_repair to fix the corruption.
+#
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
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+_scratch_xfs_set_xattr_fuzz_types
+
+# Now fuzz the block maps of each xattr type.
+for attrtype in "${SCRATCH_XFS_XATTR_FUZZ_TYPES[@]}"; do
+	echo "Fuzz block map for ${attrtype}" | tee -a $seqres.full
+
+	# Restore a correct copy of the filesystem before we start a round of
+	# fuzzing.  This avoids corruption errors from xfs_db when
+	# _scratch_xfs_fuzz_metadata probes the xattr block fields.
+	__scratch_xfs_fuzz_mdrestore
+
+	_scratch_mount
+	inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_${attrtype})
+	_scratch_unmount
+
+	_scratch_xfs_fuzz_metadata 'a*.bmx' 'offline'  "inode ${inum}" >> $seqres.full
+	echo "Done fuzzing attr map ${attrtype}"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1558.out b/tests/xfs/1558.out
new file mode 100644
index 0000000000..6fed892cb4
--- /dev/null
+++ b/tests/xfs/1558.out
@@ -0,0 +1,10 @@
+QA output created by 1558
+Format and populate
+Fuzz block map for EXTENTS_REMOTE3K
+Done fuzzing attr map EXTENTS_REMOTE3K
+Fuzz block map for EXTENTS_REMOTE4K
+Done fuzzing attr map EXTENTS_REMOTE4K
+Fuzz block map for LEAF
+Done fuzzing attr map LEAF
+Fuzz block map for NODE
+Done fuzzing attr map NODE
diff --git a/tests/xfs/1559 b/tests/xfs/1559
new file mode 100755
index 0000000000..886c1f2641
--- /dev/null
+++ b/tests/xfs/1559
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1559
+#
+# Populate a XFS filesystem and fuzz the attr mappings of every xattr type.
+# Do not fix the filesystem, to test metadata verifiers.
+#
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_norepair
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
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+_scratch_xfs_set_xattr_fuzz_types
+
+# Now fuzz the block maps of each xattr type.
+for attrtype in "${SCRATCH_XFS_XATTR_FUZZ_TYPES[@]}"; do
+	echo "Fuzz block map for ${attrtype}" | tee -a $seqres.full
+
+	# Restore a correct copy of the filesystem before we start a round of
+	# fuzzing.  This avoids corruption errors from xfs_db when
+	# _scratch_xfs_fuzz_metadata probes the xattr block fields.
+	__scratch_xfs_fuzz_mdrestore
+
+	_scratch_mount
+	inum=$(stat -c '%i' $SCRATCH_MNT/ATTR.FMT_${attrtype})
+	_scratch_unmount
+
+	_scratch_xfs_fuzz_metadata 'a*.bmx' 'none'  "inode ${inum}" >> $seqres.full
+	echo "Done fuzzing attr map ${attrtype}"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1559.out b/tests/xfs/1559.out
new file mode 100644
index 0000000000..19fe4c91df
--- /dev/null
+++ b/tests/xfs/1559.out
@@ -0,0 +1,10 @@
+QA output created by 1559
+Format and populate
+Fuzz block map for EXTENTS_REMOTE3K
+Done fuzzing attr map EXTENTS_REMOTE3K
+Fuzz block map for EXTENTS_REMOTE4K
+Done fuzzing attr map EXTENTS_REMOTE4K
+Fuzz block map for LEAF
+Done fuzzing attr map LEAF
+Fuzz block map for NODE
+Done fuzzing attr map NODE

