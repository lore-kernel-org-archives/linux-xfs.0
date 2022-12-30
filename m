Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3774C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbiLaAum (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiLaAum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:50:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CFD1C921;
        Fri, 30 Dec 2022 16:50:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E2893CE19DF;
        Sat, 31 Dec 2022 00:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C33C433EF;
        Sat, 31 Dec 2022 00:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447837;
        bh=meuYBXXD8Z+1Tas5iSvK50WmvFyiTG0iKDZc1QiqUWA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jhYeL9fLZvlD982UY9l/DjQnNICLsR/18fjPcXhWw+NZ/MGlrWs1rxZ46Z+kaR3YZ
         DwY6e2bPzzeQQOdOx502ET7+DcJ5YEhkR9qLrOF5CGjACaKkXrwkWHSSbE7CaFdCOn
         vH+kuRuM04YAJjno1wBj99Fb33Fuwo7iq/wbH+IF80gviZpzPW602bGAqNfuFlZkZI
         wGPXWFVKXUIeuRr0Dxc7xMFg3uHsM8bDw4T5fK7OfI7Hz3yaZE9D9/zAPPIWTfWBAn
         NTWa318y8A0YfFJieOnTBBCPkkCk1D0YkMm6ukF+3KXJpXfZHd5/xkfKkqAkqXOwxA
         Jf/0sV211cxSw==
Subject: [PATCH 1/5] fuzzy: test fuzzing directory block mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:44 -0800
Message-ID: <167243878483.731641.7350453901027339940.stgit@magnolia>
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

Fuzz the block mappings of directories to see what happens.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy       |   16 ++++++++++++++++
 tests/xfs/1554     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1554.out |   10 ++++++++++
 tests/xfs/1555     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1555.out |   10 ++++++++++
 tests/xfs/1556     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1556.out |   10 ++++++++++
 7 files changed, 190 insertions(+)
 create mode 100755 tests/xfs/1554
 create mode 100644 tests/xfs/1554.out
 create mode 100755 tests/xfs/1555
 create mode 100644 tests/xfs/1555.out
 create mode 100755 tests/xfs/1556
 create mode 100644 tests/xfs/1556.out


diff --git a/common/fuzzy b/common/fuzzy
index 53fe22db69..09f42d9225 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -549,6 +549,22 @@ _require_scratch_xfs_fuzz_fields()
 	_require_xfs_db_command "fuzz"
 }
 
+# Sets the array SCRATCH_XFS_DIR_FUZZ_TYPES to the list of directory formats
+# available for fuzzing.  Each list item must match one of the /S_IFDIR.FMT_*
+# files created by the fs population code.  Users can override this by setting
+# SCRATCH_XFS_LIST_FUZZ_DIRTYPE in the environment.  BTREE is omitted here
+# because that refers to the fork format and does not affect the directory
+# structure at all.
+_scratch_xfs_set_dir_fuzz_types() {
+	if [ -n "${SCRATCH_XFS_LIST_FUZZ_DIRTYPE}" ]; then
+		mapfile -t SCRATCH_XFS_DIR_FUZZ_TYPES < \
+				<(echo "${SCRATCH_XFS_LIST_FUZZ_DIRTYPE}" | tr '[ ,]' '[\n\n]')
+		return
+	fi
+
+	SCRATCH_XFS_DIR_FUZZ_TYPES=(BLOCK LEAF LEAFN NODE)
+}
+
 # Grab the list of available fuzzing verbs
 _scratch_xfs_list_fuzz_verbs() {
 	if [ -n "${SCRATCH_XFS_LIST_FUZZ_VERBS}" ]; then
diff --git a/tests/xfs/1554 b/tests/xfs/1554
new file mode 100755
index 0000000000..b43c705cb9
--- /dev/null
+++ b/tests/xfs/1554
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1554
+#
+# Populate a XFS filesystem and fuzz the data mappings of every directory type.
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
+_scratch_xfs_set_dir_fuzz_types
+
+# Now fuzz the block maps of each directory type.
+for dirtype in "${SCRATCH_XFS_DIR_FUZZ_TYPES[@]}"; do
+	echo "Fuzz block map for ${dirtype}" | tee -a $seqres.full
+
+	# Restore a correct copy of the filesystem before we start a round of
+	# fuzzing.  This avoids corruption errors from xfs_db when
+	# _scratch_xfs_fuzz_metadata probes the directory block fields.
+	__scratch_xfs_fuzz_mdrestore
+
+	_scratch_mount
+	inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_${dirtype})
+	_scratch_unmount
+
+	_scratch_xfs_fuzz_metadata 'u*.bmx' 'online'  "inode ${inum}" >> $seqres.full
+	echo "Done fuzzing dir map ${dirtype}"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1554.out b/tests/xfs/1554.out
new file mode 100644
index 0000000000..9985ed1990
--- /dev/null
+++ b/tests/xfs/1554.out
@@ -0,0 +1,10 @@
+QA output created by 1554
+Format and populate
+Fuzz block map for BLOCK
+Done fuzzing dir map BLOCK
+Fuzz block map for LEAF
+Done fuzzing dir map LEAF
+Fuzz block map for LEAFN
+Done fuzzing dir map LEAFN
+Fuzz block map for NODE
+Done fuzzing dir map NODE
diff --git a/tests/xfs/1555 b/tests/xfs/1555
new file mode 100755
index 0000000000..8dee177a3d
--- /dev/null
+++ b/tests/xfs/1555
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1555
+#
+# Populate a XFS filesystem and fuzz the data mappings of every directory type.
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
+_scratch_xfs_set_dir_fuzz_types
+
+# Now fuzz the block maps of each directory type.
+for dirtype in "${SCRATCH_XFS_DIR_FUZZ_TYPES[@]}"; do
+	echo "Fuzz block map for ${dirtype}" | tee -a $seqres.full
+
+	# Restore a correct copy of the filesystem before we start a round of
+	# fuzzing.  This avoids corruption errors from xfs_db when
+	# _scratch_xfs_fuzz_metadata probes the directory block fields.
+	__scratch_xfs_fuzz_mdrestore
+
+	_scratch_mount
+	inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_${dirtype})
+	_scratch_unmount
+
+	_scratch_xfs_fuzz_metadata 'u*.bmx' 'offline'  "inode ${inum}" >> $seqres.full
+	echo "Done fuzzing dir map ${dirtype}"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1555.out b/tests/xfs/1555.out
new file mode 100644
index 0000000000..38c5714d13
--- /dev/null
+++ b/tests/xfs/1555.out
@@ -0,0 +1,10 @@
+QA output created by 1555
+Format and populate
+Fuzz block map for BLOCK
+Done fuzzing dir map BLOCK
+Fuzz block map for LEAF
+Done fuzzing dir map LEAF
+Fuzz block map for LEAFN
+Done fuzzing dir map LEAFN
+Fuzz block map for NODE
+Done fuzzing dir map NODE
diff --git a/tests/xfs/1556 b/tests/xfs/1556
new file mode 100755
index 0000000000..54df601c11
--- /dev/null
+++ b/tests/xfs/1556
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1556
+#
+# Populate a XFS filesystem and fuzz the data mappings of every directory type.
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
+_scratch_xfs_set_dir_fuzz_types
+
+# Now fuzz the block maps of each directory type.
+for dirtype in "${SCRATCH_XFS_DIR_FUZZ_TYPES[@]}"; do
+	echo "Fuzz block map for ${dirtype}" | tee -a $seqres.full
+
+	# Restore a correct copy of the filesystem before we start a round of
+	# fuzzing.  This avoids corruption errors from xfs_db when
+	# _scratch_xfs_fuzz_metadata probes the directory block fields.
+	__scratch_xfs_fuzz_mdrestore
+
+	_scratch_mount
+	inum=$(stat -c '%i' $SCRATCH_MNT/S_IFDIR.FMT_${dirtype})
+	_scratch_unmount
+
+	_scratch_xfs_fuzz_metadata 'u*.bmx' 'none'  "inode ${inum}" >> $seqres.full
+	echo "Done fuzzing dir map ${dirtype}"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1556.out b/tests/xfs/1556.out
new file mode 100644
index 0000000000..b947285caa
--- /dev/null
+++ b/tests/xfs/1556.out
@@ -0,0 +1,10 @@
+QA output created by 1556
+Format and populate
+Fuzz block map for BLOCK
+Done fuzzing dir map BLOCK
+Fuzz block map for LEAF
+Done fuzzing dir map LEAF
+Fuzz block map for LEAFN
+Done fuzzing dir map LEAFN
+Fuzz block map for NODE
+Done fuzzing dir map NODE

