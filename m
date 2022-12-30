Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4408FC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbiLaAkC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiLaAkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:40:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383141E3FE;
        Fri, 30 Dec 2022 16:40:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAA1D61D18;
        Sat, 31 Dec 2022 00:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B57DC433EF;
        Sat, 31 Dec 2022 00:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447199;
        bh=x0mlas2Jn1y5z4fXt1IrR39/BN9IQ7pKbZJ4w3zYLDk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MAhLukp820jl89E6FTAv8yXQA7BbSz9taYCJZgq0sNUnTBF5v6IKBLZltNHv4x37B
         eEnbye8rSYpmmJWVwLAfhSylUPuoYdjX7F9qTnUxZpcU8AviCVGLEaRUvI7fpBhW9K
         1+Y3U8iw48/QqVDL2S5PWhMwd/qq9K1dWjUCQjnGWLqFyxVbnxKGt94JqxKLXWYoia
         0vdlLVAhAn/8xnnMB5kqhNwDtZcnCw6bA78lh33buz/1xnXOdLdl+eJzIFOXf1KjhB
         jA7d+xlRggYOyMBuqgU7plOfqEb5N8B3WrXKLDB/4cUhq/G7/+zVuSUvkLgU3vgEN9
         JtqkNrmQxiFvw==
Subject: [PATCH 5/5] xfs: race fsstress with online scrubbers for file
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:06 -0800
Message-ID: <167243874673.722028.7027496052735734173.stgit@magnolia>
In-Reply-To: <167243874614.722028.11987534226186856347.stgit@magnolia>
References: <167243874614.722028.11987534226186856347.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For each XFS_SCRUB_TYPE_* that looks at file metadata, create a test
that runs that scrubber in the foreground and fsstress in the
background.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy      |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 tests/xfs/792     |   38 +++++++++++++++++++++++
 tests/xfs/792.out |    2 +
 tests/xfs/793     |   37 ++++++++++++++++++++++
 tests/xfs/793.out |    2 +
 tests/xfs/794     |   39 +++++++++++++++++++++++
 tests/xfs/794.out |    2 +
 tests/xfs/795     |   39 +++++++++++++++++++++++
 tests/xfs/795.out |    2 +
 tests/xfs/796     |   37 ++++++++++++++++++++++
 tests/xfs/796.out |    2 +
 tests/xfs/797     |   40 ++++++++++++++++++++++++
 tests/xfs/797.out |    2 +
 tests/xfs/799     |   38 +++++++++++++++++++++++
 tests/xfs/799.out |    2 +
 tests/xfs/826     |   38 +++++++++++++++++++++++
 tests/xfs/826.out |    2 +
 tests/xfs/827     |   39 +++++++++++++++++++++++
 tests/xfs/827.out |    2 +
 19 files changed, 447 insertions(+), 5 deletions(-)
 create mode 100755 tests/xfs/792
 create mode 100644 tests/xfs/792.out
 create mode 100755 tests/xfs/793
 create mode 100644 tests/xfs/793.out
 create mode 100755 tests/xfs/794
 create mode 100644 tests/xfs/794.out
 create mode 100755 tests/xfs/795
 create mode 100644 tests/xfs/795.out
 create mode 100755 tests/xfs/796
 create mode 100644 tests/xfs/796.out
 create mode 100755 tests/xfs/797
 create mode 100644 tests/xfs/797.out
 create mode 100755 tests/xfs/799
 create mode 100644 tests/xfs/799.out
 create mode 100755 tests/xfs/826
 create mode 100644 tests/xfs/826.out
 create mode 100755 tests/xfs/827
 create mode 100644 tests/xfs/827.out


diff --git a/common/fuzzy b/common/fuzzy
index c4a5bc9261..f7f660bc31 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -330,12 +330,20 @@ __stress_freeze_filter_output() {
 
 # Filter scrub output so that we don't tarnish the golden output if the fs is
 # too busy to scrub.  Note: Tests should _notrun if the scrub type is not
-# supported.
+# supported.  Callers can provide extra strings to filter out as function
+# arguments.
 __stress_scrub_filter_output() {
+	local extra_args=()
+
+	for arg in "$@"; do
+		extra_args+=(-e "/${arg}/d")
+	done
+
 	_filter_scratch | \
 		sed -e '/Device or resource busy/d' \
 		    -e '/Optimization possible/d' \
-		    -e '/No space left on device/d'
+		    -e '/No space left on device/d' \
+		    "${extra_args[@]}"
 }
 
 # Decide if the scratch filesystem is still alive.
@@ -401,13 +409,34 @@ __stress_one_scrub_loop() {
 		fi
 	done
 
+	local extra_filters=()
+	local target_cmd=(echo "$scrub_tgt")
+	case "$scrub_tgt" in
+	"%file%"|"%datafile%"|"%attrfile%")
+		extra_filters+=('No such file or directory' 'No such device or address')
+		target_cmd=(find "$SCRATCH_MNT" -print)
+		;;
+	"%dir%")
+		extra_filters+=('No such file or directory' 'Not a directory')
+		target_cmd=(find "$SCRATCH_MNT" -type d -print)
+		;;
+	"%regfile%"|"%cowfile%")
+		extra_filters+=('No such file or directory')
+		target_cmd=(find "$SCRATCH_MNT" -type f -print)
+		;;
+	esac
+
 	while __stress_scrub_running "$scrub_startat" "$runningfile"; do
 		sleep 1
 	done
 
 	while __stress_scrub_running "$end" "$runningfile"; do
-		$XFS_IO_PROG -x "${xfs_io_args[@]}" "$scrub_tgt" 2>&1 | \
-			__stress_scrub_filter_output
+		readarray -t fnames < <("${target_cmd[@]}" 2>/dev/null)
+		for fname in "${fnames[@]}"; do
+			$XFS_IO_PROG -x "${xfs_io_args[@]}" "$fname" 2>&1 | \
+				__stress_scrub_filter_output "${extra_filters[@]}"
+			__stress_scrub_running "$end" "$runningfile" || break
+		done
 	done
 }
 
@@ -585,6 +614,22 @@ __stress_scrub_fsstress_loop() {
 	"default")
 		# No new arguments
 		;;
+	"symlink")
+		focus+=('-z')
+
+		# Only create, read, and delete symbolic links
+		focus+=('-f' 'symlink=4')
+		focus+=('-f' 'readlink=10')
+		focus+=('-f' 'unlink=1')
+		;;
+	"mknod")
+		focus+=('-z')
+
+		# Only create and delete special files
+		focus+=('-f' 'mknod=4')
+		focus+=('-f' 'getdents=100')
+		focus+=('-f' 'unlink=1')
+		;;
 	*)
 		echo "$stress_tgt: Unrecognized stress target, using defaults."
 		;;
@@ -715,9 +760,31 @@ __stress_scrub_check_commands() {
 	local scrub_tgt="$1"
 	shift
 
+	local cooked_tgt="$scrub_tgt"
+	case "$scrub_tgt" in
+	"%file%"|"%dir%")
+		cooked_tgt="$SCRATCH_MNT"
+		;;
+	"%regfile%"|"%datafile%")
+		cooked_tgt="$SCRATCH_MNT/testfile"
+		echo test > "$cooked_tgt"
+		;;
+	"%attrfile%")
+		cooked_tgt="$SCRATCH_MNT/testfile"
+		$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 64k' "$cooked_tgt" &>/dev/null
+		attr -s attrname "$cooked_tgt" < "$cooked_tgt" &>/dev/null
+		;;
+	"%cowfile%")
+		cooked_tgt="$SCRATCH_MNT/testfile"
+		$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 128k' "$cooked_tgt" &>/dev/null
+		_cp_reflink "$cooked_tgt" "$cooked_tgt.1"
+		$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 1' "$cooked_tgt.1" &>/dev/null
+		;;
+	esac
+
 	for arg in "$@"; do
 		local cooked_arg="$(echo "$arg" | sed -e "s/%agno%/0/g")"
-		testio=`$XFS_IO_PROG -x -c "$cooked_arg" $scrub_tgt 2>&1`
+		testio=`$XFS_IO_PROG -x -c "$cooked_arg" "$cooked_tgt" 2>&1`
 		echo $testio | grep -q "Unknown type" && \
 			_notrun "xfs_io scrub subcommand support is missing"
 		echo $testio | grep -q "Inappropriate ioctl" && \
@@ -749,6 +816,16 @@ __stress_scrub_check_commands() {
 # -S	Pass this option to xfs_scrub.  If zero -S options are specified,
 #	xfs_scrub will not be run.  To select repair mode, pass '-k' or '-v'.
 # -t	Run online scrub against this file; $SCRATCH_MNT is the default.
+#	Special values are as follows:
+#
+#	%file%		all files
+#	%regfile%	regular files
+#	%dir%		direct
+#	%datafile%	regular files with data blocks
+#	%attrfile%	regular files with xattr blocks
+#	%cowfile%	regular files with shared blocks
+#
+#	File selection races with fsstress, so the selection is best-effort.
 # -w	Delay the start of the scrub/repair loop by this number of seconds.
 #	Defaults to no delay unless XFS_SCRUB_STRESS_DELAY is set.  This value
 #	will be clamped to ten seconds before the end time.
@@ -758,6 +835,8 @@ __stress_scrub_check_commands() {
 #       'xattr': Grow extended attributes in a small tree.
 #       'default': Run fsstress with default arguments.
 #       'writeonly': Only perform fs updates, no reads.
+#       'symlink': Only create symbolic links.
+#       'mknod': Only create special files.
 #
 #       The default is 'default' unless XFS_SCRUB_STRESS_TARGET is set.
 # -X	Run this program to exercise the filesystem.  Currently supported
diff --git a/tests/xfs/792 b/tests/xfs/792
new file mode 100755
index 0000000000..0806e87909
--- /dev/null
+++ b/tests/xfs/792
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 792
+#
+# Race fsstress and inode record scrub for a while to see if we crash or
+# livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -s "scrub inode" -t "%file%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/792.out b/tests/xfs/792.out
new file mode 100644
index 0000000000..c9b5ef3a7c
--- /dev/null
+++ b/tests/xfs/792.out
@@ -0,0 +1,2 @@
+QA output created by 792
+Silence is golden
diff --git a/tests/xfs/793 b/tests/xfs/793
new file mode 100755
index 0000000000..41be82d621
--- /dev/null
+++ b/tests/xfs/793
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 793
+#
+# Race fsstress and data fork scrub for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -s "scrub bmapbtd" -t "%datafile%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/793.out b/tests/xfs/793.out
new file mode 100644
index 0000000000..e8a17d4ecb
--- /dev/null
+++ b/tests/xfs/793.out
@@ -0,0 +1,2 @@
+QA output created by 793
+Silence is golden
diff --git a/tests/xfs/794 b/tests/xfs/794
new file mode 100755
index 0000000000..8f4835dbc9
--- /dev/null
+++ b/tests/xfs/794
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 794
+#
+# Race fsstress and attr fork scrub for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+. ./common/attr
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_attrs
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -x 'xattr' -s "scrub bmapbta" -t "%attrfile%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/794.out b/tests/xfs/794.out
new file mode 100644
index 0000000000..bc999c055c
--- /dev/null
+++ b/tests/xfs/794.out
@@ -0,0 +1,2 @@
+QA output created by 794
+Silence is golden
diff --git a/tests/xfs/795 b/tests/xfs/795
new file mode 100755
index 0000000000..ec065bafdd
--- /dev/null
+++ b/tests/xfs/795
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 795
+#
+# Race fsstress and cow fork scrub for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+. ./common/reflink
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_xfs_has_feature "$SCRATCH_MNT" reflink
+_scratch_xfs_stress_scrub -s "scrub bmapbtc" -t "%cowfile%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/795.out b/tests/xfs/795.out
new file mode 100644
index 0000000000..cb357003dd
--- /dev/null
+++ b/tests/xfs/795.out
@@ -0,0 +1,2 @@
+QA output created by 795
+Silence is golden
diff --git a/tests/xfs/796 b/tests/xfs/796
new file mode 100755
index 0000000000..d337701264
--- /dev/null
+++ b/tests/xfs/796
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 796
+#
+# Race fsstress and directory scrub for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -x 'dir' -s "scrub directory" -t "%dir%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/796.out b/tests/xfs/796.out
new file mode 100644
index 0000000000..374e3774a2
--- /dev/null
+++ b/tests/xfs/796.out
@@ -0,0 +1,2 @@
+QA output created by 796
+Silence is golden
diff --git a/tests/xfs/797 b/tests/xfs/797
new file mode 100755
index 0000000000..c68b43be7a
--- /dev/null
+++ b/tests/xfs/797
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 797
+#
+# Race fsstress and extended attributes scrub for a while to see if we crash or
+# livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+. ./common/attr
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_attrs
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -x 'xattr' -s "scrub xattr" -t "%attrfile%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/797.out b/tests/xfs/797.out
new file mode 100644
index 0000000000..6b64f4bf21
--- /dev/null
+++ b/tests/xfs/797.out
@@ -0,0 +1,2 @@
+QA output created by 797
+Silence is golden
diff --git a/tests/xfs/799 b/tests/xfs/799
new file mode 100755
index 0000000000..84007ea9c0
--- /dev/null
+++ b/tests/xfs/799
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 799
+#
+# Race fsstress and parent pointers scrub for a while to see if we crash or
+# livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -s "scrub parent" -t "%dir%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/799.out b/tests/xfs/799.out
new file mode 100644
index 0000000000..f3fd9fa2a0
--- /dev/null
+++ b/tests/xfs/799.out
@@ -0,0 +1,2 @@
+QA output created by 799
+Silence is golden
diff --git a/tests/xfs/826 b/tests/xfs/826
new file mode 100755
index 0000000000..7660270571
--- /dev/null
+++ b/tests/xfs/826
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 826
+#
+# Race fsstress and symlink scrub for a while to see if we crash or livelock.
+# We can't open symlink files directly for scrubbing, so we use xfs_scrub(8).
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+XFS_SCRUB_PHASE=3 _scratch_xfs_stress_scrub -x 'symlink' -S '-n'
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/826.out b/tests/xfs/826.out
new file mode 100644
index 0000000000..93fae86b82
--- /dev/null
+++ b/tests/xfs/826.out
@@ -0,0 +1,2 @@
+QA output created by 826
+Silence is golden
diff --git a/tests/xfs/827 b/tests/xfs/827
new file mode 100755
index 0000000000..55ec01d1e6
--- /dev/null
+++ b/tests/xfs/827
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 827
+#
+# Race fsstress and special file scrub for a while to see if we crash or
+# livelock.  We can't open special files directly for scrubbing, so we use
+# xfs_scrub(8).
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+XFS_SCRUB_PHASE=3 _scratch_xfs_stress_scrub -x 'mknod' -S '-n'
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/827.out b/tests/xfs/827.out
new file mode 100644
index 0000000000..65f29d949d
--- /dev/null
+++ b/tests/xfs/827.out
@@ -0,0 +1,2 @@
+QA output created by 827
+Silence is golden

