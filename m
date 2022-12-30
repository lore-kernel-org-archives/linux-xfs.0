Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C54FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbiLaAvL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiLaAvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:51:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5C61C921;
        Fri, 30 Dec 2022 16:51:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0CA661D14;
        Sat, 31 Dec 2022 00:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32776C433D2;
        Sat, 31 Dec 2022 00:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447868;
        bh=oyyuHur/DXFNz7J/oQoWbdhwO+6Pd55fMwPnIveT6oY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oT/k8+TVCSh/w68Bf8eKyGJMKavtSEqCl3aLgNPAfWTBBSU1bwnQ6kDuPnfBrkpvz
         QUnBycc4D2+9zY7yfeqKmDhdAyRwVy04q9YZAxAiKL4msRdMZLC1BUXXaMxaiuICs5
         5pQk/zLz02qjxbIuJZY3Pkh9iZtaO6UE2l56gq6OEQvDdVKvit9o7TSGuA8BH0riAE
         PI3EvrmA9N6xlebqXJTaj5440G6jQ7ALhAzd2tnE4wOzpNtlaw1bSlauDVB9Al7m47
         qEp9Ws6vOIJKZwX9I25rt2eZzhwvzK74RuqodQxgeCUrorvMekJkK6bs2aTGoSi1Px
         SDT4RDl3NxpEA==
Subject: [PATCH 3/5] fuzzy: test fuzzing realtime free space metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:45 -0800
Message-ID: <167243878509.731641.14915208406311416359.stgit@magnolia>
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

Fuzz the contents of the realtime bitmap and summary files to see what
happens.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy       |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 tests/xfs/1562     |   41 ++++++++++++++++++++
 tests/xfs/1562.out |    4 ++
 tests/xfs/1563     |   41 ++++++++++++++++++++
 tests/xfs/1563.out |    4 ++
 tests/xfs/1564     |   41 ++++++++++++++++++++
 tests/xfs/1564.out |    4 ++
 tests/xfs/1565     |   41 ++++++++++++++++++++
 tests/xfs/1565.out |    4 ++
 tests/xfs/1566     |   42 ++++++++++++++++++++
 tests/xfs/1566.out |    4 ++
 tests/xfs/1567     |   42 ++++++++++++++++++++
 tests/xfs/1567.out |    4 ++
 tests/xfs/1568     |   41 ++++++++++++++++++++
 tests/xfs/1568.out |    4 ++
 tests/xfs/1569     |   41 ++++++++++++++++++++
 tests/xfs/1569.out |    4 ++
 17 files changed, 465 insertions(+), 4 deletions(-)
 create mode 100755 tests/xfs/1562
 create mode 100644 tests/xfs/1562.out
 create mode 100755 tests/xfs/1563
 create mode 100644 tests/xfs/1563.out
 create mode 100755 tests/xfs/1564
 create mode 100644 tests/xfs/1564.out
 create mode 100755 tests/xfs/1565
 create mode 100644 tests/xfs/1565.out
 create mode 100755 tests/xfs/1566
 create mode 100644 tests/xfs/1566.out
 create mode 100755 tests/xfs/1567
 create mode 100644 tests/xfs/1567.out
 create mode 100755 tests/xfs/1568
 create mode 100644 tests/xfs/1568.out
 create mode 100755 tests/xfs/1569
 create mode 100644 tests/xfs/1569.out


diff --git a/common/fuzzy b/common/fuzzy
index d8eb7d8b72..ef54f2fe2c 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -154,6 +154,12 @@ _scratch_xfs_dump_metadata() {
 	_scratch_xfs_db "${cmds[@]}" -c print
 }
 
+# Decide from the output of the xfs_db "stack" command if the debugger's io
+# cursor is pointed at a block that is an unstructured data format (blob).
+__scratch_xfs_detect_blob_from_stack() {
+	grep -q -E 'inode.*, type (data|rtsummary|rtbitmap)'
+}
+
 # Navigate to some part of the filesystem and print the field info.
 # The first argument is an grep filter for the fields
 # The rest of the arguments are xfs_db commands to locate the metadata.
@@ -169,7 +175,17 @@ _scratch_xfs_list_metadata_fields() {
 	for arg in "$@"; do
 		cmds+=("-c" "${arg}")
 	done
-	_scratch_xfs_db "${cmds[@]}" -c print | __filter_xfs_db_print_fields "${filter}"
+
+	# Does the path argument point towards something that is an
+	# unstructured blob?
+	if _scratch_xfs_db "${cmds[@]}" -c stack 2>/dev/null | \
+			__scratch_xfs_detect_blob_from_stack; then
+		echo "<blob>"
+		return
+	fi
+
+	_scratch_xfs_db "${cmds[@]}" -c print | \
+		__filter_xfs_db_print_fields "${filter}"
 }
 
 # Fuzz a metadata field
@@ -207,6 +223,70 @@ _scratch_xfs_fuzz_metadata_field() {
 	return 0
 }
 
+# List the fuzzing verbs available for unstructured blobs
+__scratch_xfs_list_blob_fuzz_verbs() {
+		cat << ENDL
+zeroes
+ones
+firstbit
+middlebit
+lastbit
+random
+ENDL
+}
+
+# Fuzz a metadata blob
+# The first arg is a blob fuzzing verb
+# The rest of the arguments are xfs_db commands to find the metadata.
+_scratch_xfs_fuzz_metadata_blob() {
+	local fuzzverb="$1"
+	shift
+	local trashcmd=(blocktrash -z)
+
+	local cmds=()
+	for arg in "$@"; do
+		cmds+=("-c" "${arg}")
+	done
+
+	local bytecount=$(_scratch_xfs_db "${cmds[@]}" -c "stack" | grep 'byte.*length' | awk '{print $5}')
+	local bitmax=$((bytecount * 8))
+
+	case "${fuzzverb}" in
+	"zeroes")
+		trashcmd+=(-0 -o 0 -x "${bitmax}" -y "${bitmax}");;
+	"ones")
+		trashcmd+=(-1 -o 0 -x "${bitmax}" -y "${bitmax}");;
+	"firstbit")
+		trashcmd+=(-2 -o 0 -x 1 -y 1);;
+	"middlebit")
+		trashcmd+=(-2 -o $((bitmax / 2)) -x 1 -y 1);;
+	"lastbit")
+		trashcmd+=(-2 -o "${bitmax}" -x 1 -y 1);;
+	"random")
+		trashcmd+=(-3 -o 0 -x "${bitmax}" -y "${bitmax}");;
+	*)
+		echo "Unknown blob fuzz verb \"${fuzzverb}\"."
+		return 1
+		;;
+	esac
+
+	trashcmd="${trashcmd[@]}"
+	oldval="$(_scratch_xfs_get_metadata_field "" "$@")"
+	while true; do
+		_scratch_xfs_db -x "${cmds[@]}" -c "${trashcmd}"
+		echo
+		newval="$(_scratch_xfs_get_metadata_field "" "$@" 2> /dev/null)"
+		if [ "${fuzzverb}" != "random" ] || [ "${oldval}" != "${newval}" ]; then
+			break;
+		fi
+	done
+	if [ "${oldval}" = "${newval}" ]; then
+		echo "Blob already set to new value, skipping test."
+		return 1
+	fi
+	return 0
+}
+
 # Try to forcibly unmount the scratch fs
 __scratch_xfs_fuzz_unmount()
 {
@@ -503,7 +583,11 @@ __scratch_xfs_fuzz_field_test() {
 
 	# Set the new field value
 	__fuzz_notify "+ Fuzz ${field} = ${fuzzverb}"
-	_scratch_xfs_fuzz_metadata_field "${field}" ${fuzzverb} "$@"
+	if [ "$field" = "<blob>" ]; then
+		_scratch_xfs_fuzz_metadata_blob ${fuzzverb} "$@"
+	else
+		_scratch_xfs_fuzz_metadata_field "${field}" ${fuzzverb} "$@"
+	fi
 	res=$?
 	test $res -ne 0 && return
 
@@ -587,7 +671,22 @@ _scratch_xfs_list_fuzz_verbs() {
 		echo "${SCRATCH_XFS_LIST_FUZZ_VERBS}" | tr '[ ,]' '[\n\n]'
 		return;
 	fi
-	_scratch_xfs_db -x -c 'sb 0' -c 'fuzz' | grep '^Fuzz commands:' | \
+
+	local cmds=()
+	for arg in "$@"; do
+		cmds+=("-c" "${arg}")
+	done
+	test "${#cmds[@]}" -eq 0 && cmds=('-c' 'sb 0')
+
+	# Does the path argument point towards something that is an
+	# unstructured blob?
+	if _scratch_xfs_db "${cmds[@]}" -c stack 2>/dev/null | \
+			__scratch_xfs_detect_blob_from_stack; then
+		__scratch_xfs_list_blob_fuzz_verbs
+		return
+	fi
+
+	_scratch_xfs_db -x "${cmds[@]}" -c 'fuzz' | grep '^Fuzz commands:' | \
 		sed -e 's/[,.]//g' -e 's/Fuzz commands: //g' -e 's/ /\n/g' | \
 		grep -v '^random$'
 }
@@ -605,7 +704,7 @@ _scratch_xfs_fuzz_metadata() {
 	shift; shift
 
 	fields="$(_scratch_xfs_list_metadata_fields "${filter}" "$@")"
-	verbs="$(_scratch_xfs_list_fuzz_verbs)"
+	verbs="$(_scratch_xfs_list_fuzz_verbs "$@")"
 	echo "Fields we propose to fuzz with the \"${repair}\" repair strategy: $@"
 	echo $(echo "${fields}")
 	echo "Verbs we propose to fuzz with:"
diff --git a/tests/xfs/1562 b/tests/xfs/1562
new file mode 100755
index 0000000000..015209eeb2
--- /dev/null
+++ b/tests/xfs/1562
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1562
+#
+# Populate a XFS filesystem and fuzz every realtime bitmap field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
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
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rtbitmap"
+is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
+if [ -n "$is_metadir" ]; then
+	path=('path -m /realtime/0.bitmap')
+else
+	path=('sb' 'addr rbmino')
+fi
+_scratch_xfs_fuzz_metadata '' 'online' "${path[@]}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing rtbitmap"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1562.out b/tests/xfs/1562.out
new file mode 100644
index 0000000000..63a3bc7600
--- /dev/null
+++ b/tests/xfs/1562.out
@@ -0,0 +1,4 @@
+QA output created by 1562
+Format and populate
+Fuzz rtbitmap
+Done fuzzing rtbitmap
diff --git a/tests/xfs/1563 b/tests/xfs/1563
new file mode 100755
index 0000000000..2be0870a3d
--- /dev/null
+++ b/tests/xfs/1563
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1563
+#
+# Populate a XFS filesystem and fuzz every realtime summary field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
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
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rtsummary"
+is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
+if [ -n "$is_metadir" ]; then
+	path=('path -m /realtime/0.summary')
+else
+	path=('sb' 'addr rsumino')
+fi
+_scratch_xfs_fuzz_metadata '' 'online' "${path[@]}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing rtsummary"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1563.out b/tests/xfs/1563.out
new file mode 100644
index 0000000000..e4ca8c3733
--- /dev/null
+++ b/tests/xfs/1563.out
@@ -0,0 +1,4 @@
+QA output created by 1563
+Format and populate
+Fuzz rtsummary
+Done fuzzing rtsummary
diff --git a/tests/xfs/1564 b/tests/xfs/1564
new file mode 100755
index 0000000000..c0d10ff0e9
--- /dev/null
+++ b/tests/xfs/1564
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1564
+#
+# Populate a XFS filesystem and fuzz every realtime bitmap field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair realtime
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
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rtbitmap"
+is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
+if [ -n "$is_metadir" ]; then
+	path=('path -m /realtime/0.bitmap')
+else
+	path=('sb' 'addr rbmino')
+fi
+_scratch_xfs_fuzz_metadata '' 'offline' "${path[@]}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing rtbitmap"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1564.out b/tests/xfs/1564.out
new file mode 100644
index 0000000000..afede817b8
--- /dev/null
+++ b/tests/xfs/1564.out
@@ -0,0 +1,4 @@
+QA output created by 1564
+Format and populate
+Fuzz rtbitmap
+Done fuzzing rtbitmap
diff --git a/tests/xfs/1565 b/tests/xfs/1565
new file mode 100755
index 0000000000..6b4186fb3c
--- /dev/null
+++ b/tests/xfs/1565
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1565
+#
+# Populate a XFS filesystem and fuzz every realtime summary field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_repair realtime
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
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rtsummary"
+is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
+if [ -n "$is_metadir" ]; then
+	path=('path -m /realtime/0.summary')
+else
+	path=('sb' 'addr rsumino')
+fi
+_scratch_xfs_fuzz_metadata '' 'offline' "${path[@]}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing rtsummary"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1565.out b/tests/xfs/1565.out
new file mode 100644
index 0000000000..7a8d9d04d6
--- /dev/null
+++ b/tests/xfs/1565.out
@@ -0,0 +1,4 @@
+QA output created by 1565
+Format and populate
+Fuzz rtsummary
+Done fuzzing rtsummary
diff --git a/tests/xfs/1566 b/tests/xfs/1566
new file mode 100755
index 0000000000..8d0f61ae10
--- /dev/null
+++ b/tests/xfs/1566
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1566
+#
+# Populate a XFS filesystem and fuzz every realtime bitmap field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_bothrepair realtime
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
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rtbitmap"
+is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
+if [ -n "$is_metadir" ]; then
+	path=('path -m /realtime/0.bitmap')
+else
+	path=('sb' 'addr rbmino')
+fi
+_scratch_xfs_fuzz_metadata '' 'both' "${path[@]}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing rtbitmap"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1566.out b/tests/xfs/1566.out
new file mode 100644
index 0000000000..d50e1d8539
--- /dev/null
+++ b/tests/xfs/1566.out
@@ -0,0 +1,4 @@
+QA output created by 1566
+Format and populate
+Fuzz rtbitmap
+Done fuzzing rtbitmap
diff --git a/tests/xfs/1567 b/tests/xfs/1567
new file mode 100755
index 0000000000..7dc2012b67
--- /dev/null
+++ b/tests/xfs/1567
@@ -0,0 +1,42 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1567
+#
+# Populate a XFS filesystem and fuzz every realtime summary field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_bothrepair realtime
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
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rtsummary"
+is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
+if [ -n "$is_metadir" ]; then
+	path=('path -m /realtime/0.summary')
+else
+	path=('sb' 'addr rsumino')
+fi
+_scratch_xfs_fuzz_metadata '' 'both' "${path[@]}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing rtsummary"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1567.out b/tests/xfs/1567.out
new file mode 100644
index 0000000000..b88fa0c1b3
--- /dev/null
+++ b/tests/xfs/1567.out
@@ -0,0 +1,4 @@
+QA output created by 1567
+Format and populate
+Fuzz rtsummary
+Done fuzzing rtsummary
diff --git a/tests/xfs/1568 b/tests/xfs/1568
new file mode 100755
index 0000000000..c80640ef97
--- /dev/null
+++ b/tests/xfs/1568
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1568
+#
+# Populate a XFS filesystem and fuzz every realtime bitmap field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_norepair realtime
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
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rtbitmap"
+is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.bitmap')
+if [ -n "$is_metadir" ]; then
+	path=('path -m /realtime/0.bitmap')
+else
+	path=('sb' 'addr rbmino')
+fi
+_scratch_xfs_fuzz_metadata '' 'none' "${path[@]}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing rtbitmap"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1568.out b/tests/xfs/1568.out
new file mode 100644
index 0000000000..a80f579662
--- /dev/null
+++ b/tests/xfs/1568.out
@@ -0,0 +1,4 @@
+QA output created by 1568
+Format and populate
+Fuzz rtbitmap
+Done fuzzing rtbitmap
diff --git a/tests/xfs/1569 b/tests/xfs/1569
new file mode 100755
index 0000000000..e303f08ff5
--- /dev/null
+++ b/tests/xfs/1569
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1569
+#
+# Populate a XFS filesystem and fuzz every realtime summary field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_norepair realtime
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
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz rtsummary"
+is_metadir=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /realtime/0.summary')
+if [ -n "$is_metadir" ]; then
+	path=('path -m /realtime/0.summary')
+else
+	path=('sb' 'addr rsumino')
+fi
+_scratch_xfs_fuzz_metadata '' 'none' "${path[@]}" 'dblock 0' >> $seqres.full
+echo "Done fuzzing rtsummary"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1569.out b/tests/xfs/1569.out
new file mode 100644
index 0000000000..d6202cc3af
--- /dev/null
+++ b/tests/xfs/1569.out
@@ -0,0 +1,4 @@
+QA output created by 1569
+Format and populate
+Fuzz rtsummary
+Done fuzzing rtsummary

