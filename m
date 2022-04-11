Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D957EC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350472AbiDKW5B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350471AbiDKW5A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:57:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345E2B873;
        Mon, 11 Apr 2022 15:54:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B545961773;
        Mon, 11 Apr 2022 22:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DECC385A3;
        Mon, 11 Apr 2022 22:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649717683;
        bh=1OiR8bgNFfnx3MScPV5QH55Wm2L5VuEOgXNDNf2D8BU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MfHBNyZ5kAQ8TeLJanv+mHgr0LRP0hQabESPsZz4gZUbVwRyqgyhBR6HR83IJsgMz
         k1G6IyjTc69D2MwKRouABnbL8SfiDstXocy1+fYKqkD1TugX4sOwNnjjvGDwpciQgI
         vxVx3/0hxfmU5aq1KkKVQ/v63zx6sWlxddjsI4jBEwed1k+lwexRYGjoXiNbdoOhOn
         EWiWbzwC8LBaxM6O1Ffh+19A3+uTBewuJqLX2YAOz82Z55AlWg95zXJcMhBooG6mED
         /GsXAbTl/hsq6sgoCdK+4TbLeFqT/RQrbybuaOoQqYPOWJaeXLDdBXOON9hDlyfCw+
         p2jUK9me5YCew==
Subject: [PATCH 2/4] generic: ensure we drop suid after fallocate
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 11 Apr 2022 15:54:42 -0700
Message-ID: <164971768254.169983.13280225265874038241.stgit@magnolia>
In-Reply-To: <164971767143.169983.12905331894414458027.stgit@magnolia>
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

fallocate changes file contents, so make sure that we drop privileges
and file capabilities after each fallocate operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/834     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/834.out |   33 +++++++++++++
 tests/generic/835     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/835.out |   33 +++++++++++++
 tests/generic/836     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/836.out |   33 +++++++++++++
 tests/generic/837     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/837.out |   33 +++++++++++++
 tests/generic/838     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/838.out |   33 +++++++++++++
 tests/generic/839     |   77 ++++++++++++++++++++++++++++++
 tests/generic/839.out |   13 +++++
 12 files changed, 890 insertions(+)
 create mode 100755 tests/generic/834
 create mode 100644 tests/generic/834.out
 create mode 100755 tests/generic/835
 create mode 100644 tests/generic/835.out
 create mode 100755 tests/generic/836
 create mode 100644 tests/generic/836.out
 create mode 100755 tests/generic/837
 create mode 100644 tests/generic/837.out
 create mode 100755 tests/generic/838
 create mode 100644 tests/generic/838.out
 create mode 100755 tests/generic/839
 create mode 100755 tests/generic/839.out


diff --git a/tests/generic/834 b/tests/generic/834
new file mode 100755
index 00000000..9302137b
--- /dev/null
+++ b/tests/generic/834
@@ -0,0 +1,127 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 834
+#
+# Functional test for dropping suid and sgid bits as part of a fallocate.
+#
+. ./common/preamble
+_begin_fstest auto clone quick
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $junk_dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs btrfs ext4
+_require_user
+_require_test
+verb=falloc
+_require_xfs_io_command $verb
+
+junk_dir=$TEST_DIR/$seq
+junk_file=$junk_dir/a
+mkdir -p $junk_dir/
+chmod a+rw $junk_dir/
+
+setup_testfile() {
+	rm -f $junk_file
+	_pwrite_byte 0x58 0 192k $junk_file >> $seqres.full
+	sync
+}
+
+commit_and_check() {
+	local user="$1"
+	local command="$2"
+	local start="$3"
+	local end="$4"
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+
+	local cmd="$XFS_IO_PROG -c '$command $start $end' $junk_file"
+	if [ -n "$user" ]; then
+		su - "$user" -c "$cmd" >> $seqres.full
+	else
+		$SHELL -c "$cmd" >> $seqres.full
+	fi
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+
+	# Blank line in output
+	echo
+}
+
+nr=0
+# Commit to a non-exec file by an unprivileged user clears suid but
+# leaves sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, non-exec file $verb"
+setup_testfile
+chmod a+rws $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a group-exec file by an unprivileged user clears suid and
+# sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, group-exec file $verb"
+setup_testfile
+chmod g+x,a+rws $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a user-exec file by an unprivileged user clears suid but
+# not sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, user-exec file $verb"
+setup_testfile
+chmod u+x,a+rws,g-x $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a all-exec file by an unprivileged user clears suid and
+# sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, all-exec file $verb"
+setup_testfile
+chmod a+rwxs $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a non-exec file by root clears suid but leaves sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, non-exec file $verb"
+setup_testfile
+chmod a+rws $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a group-exec file by root clears suid and sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, group-exec file $verb"
+setup_testfile
+chmod g+x,a+rws $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a user-exec file by root clears suid but not sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, user-exec file $verb"
+setup_testfile
+chmod u+x,a+rws,g-x $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a all-exec file by root clears suid and sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, all-exec file $verb"
+setup_testfile
+chmod a+rwxs $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/834.out b/tests/generic/834.out
new file mode 100644
index 00000000..2226eea6
--- /dev/null
+++ b/tests/generic/834.out
@@ -0,0 +1,33 @@
+QA output created by 834
+Test 1 - qa_user, non-exec file falloc
+6666 -rwSrwSrw- TEST_DIR/834/a
+666 -rw-rw-rw- TEST_DIR/834/a
+
+Test 2 - qa_user, group-exec file falloc
+6676 -rwSrwsrw- TEST_DIR/834/a
+676 -rw-rwxrw- TEST_DIR/834/a
+
+Test 3 - qa_user, user-exec file falloc
+6766 -rwsrwSrw- TEST_DIR/834/a
+766 -rwxrw-rw- TEST_DIR/834/a
+
+Test 4 - qa_user, all-exec file falloc
+6777 -rwsrwsrwx TEST_DIR/834/a
+777 -rwxrwxrwx TEST_DIR/834/a
+
+Test 5 - root, non-exec file falloc
+6666 -rwSrwSrw- TEST_DIR/834/a
+6666 -rwSrwSrw- TEST_DIR/834/a
+
+Test 6 - root, group-exec file falloc
+6676 -rwSrwsrw- TEST_DIR/834/a
+6676 -rwSrwsrw- TEST_DIR/834/a
+
+Test 7 - root, user-exec file falloc
+6766 -rwsrwSrw- TEST_DIR/834/a
+6766 -rwsrwSrw- TEST_DIR/834/a
+
+Test 8 - root, all-exec file falloc
+6777 -rwsrwsrwx TEST_DIR/834/a
+6777 -rwsrwsrwx TEST_DIR/834/a
+
diff --git a/tests/generic/835 b/tests/generic/835
new file mode 100755
index 00000000..b0dc9cc3
--- /dev/null
+++ b/tests/generic/835
@@ -0,0 +1,127 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 835
+#
+# Functional test for dropping suid and sgid bits as part of a fpunch.
+#
+. ./common/preamble
+_begin_fstest auto clone quick
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $junk_dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs btrfs ext4
+_require_user
+_require_test
+verb=fpunch
+_require_xfs_io_command $verb
+
+junk_dir=$TEST_DIR/$seq
+junk_file=$junk_dir/a
+mkdir -p $junk_dir/
+chmod a+rw $junk_dir/
+
+setup_testfile() {
+	rm -f $junk_file
+	_pwrite_byte 0x58 0 192k $junk_file >> $seqres.full
+	sync
+}
+
+commit_and_check() {
+	local user="$1"
+	local command="$2"
+	local start="$3"
+	local end="$4"
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+
+	local cmd="$XFS_IO_PROG -c '$command $start $end' $junk_file"
+	if [ -n "$user" ]; then
+		su - "$user" -c "$cmd" >> $seqres.full
+	else
+		$SHELL -c "$cmd" >> $seqres.full
+	fi
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+
+	# Blank line in output
+	echo
+}
+
+nr=0
+# Commit to a non-exec file by an unprivileged user clears suid but
+# leaves sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, non-exec file $verb"
+setup_testfile
+chmod a+rws $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a group-exec file by an unprivileged user clears suid and
+# sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, group-exec file $verb"
+setup_testfile
+chmod g+x,a+rws $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a user-exec file by an unprivileged user clears suid but
+# not sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, user-exec file $verb"
+setup_testfile
+chmod u+x,a+rws,g-x $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a all-exec file by an unprivileged user clears suid and
+# sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, all-exec file $verb"
+setup_testfile
+chmod a+rwxs $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a non-exec file by root clears suid but leaves sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, non-exec file $verb"
+setup_testfile
+chmod a+rws $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a group-exec file by root clears suid and sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, group-exec file $verb"
+setup_testfile
+chmod g+x,a+rws $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a user-exec file by root clears suid but not sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, user-exec file $verb"
+setup_testfile
+chmod u+x,a+rws,g-x $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a all-exec file by root clears suid and sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, all-exec file $verb"
+setup_testfile
+chmod a+rwxs $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/835.out b/tests/generic/835.out
new file mode 100644
index 00000000..186d7da4
--- /dev/null
+++ b/tests/generic/835.out
@@ -0,0 +1,33 @@
+QA output created by 835
+Test 1 - qa_user, non-exec file fpunch
+6666 -rwSrwSrw- TEST_DIR/835/a
+666 -rw-rw-rw- TEST_DIR/835/a
+
+Test 2 - qa_user, group-exec file fpunch
+6676 -rwSrwsrw- TEST_DIR/835/a
+676 -rw-rwxrw- TEST_DIR/835/a
+
+Test 3 - qa_user, user-exec file fpunch
+6766 -rwsrwSrw- TEST_DIR/835/a
+766 -rwxrw-rw- TEST_DIR/835/a
+
+Test 4 - qa_user, all-exec file fpunch
+6777 -rwsrwsrwx TEST_DIR/835/a
+777 -rwxrwxrwx TEST_DIR/835/a
+
+Test 5 - root, non-exec file fpunch
+6666 -rwSrwSrw- TEST_DIR/835/a
+6666 -rwSrwSrw- TEST_DIR/835/a
+
+Test 6 - root, group-exec file fpunch
+6676 -rwSrwsrw- TEST_DIR/835/a
+6676 -rwSrwsrw- TEST_DIR/835/a
+
+Test 7 - root, user-exec file fpunch
+6766 -rwsrwSrw- TEST_DIR/835/a
+6766 -rwsrwSrw- TEST_DIR/835/a
+
+Test 8 - root, all-exec file fpunch
+6777 -rwsrwsrwx TEST_DIR/835/a
+6777 -rwsrwsrwx TEST_DIR/835/a
+
diff --git a/tests/generic/836 b/tests/generic/836
new file mode 100755
index 00000000..ff0cf092
--- /dev/null
+++ b/tests/generic/836
@@ -0,0 +1,127 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 836
+#
+# Functional test for dropping suid and sgid bits as part of a fzero.
+#
+. ./common/preamble
+_begin_fstest auto clone quick
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $junk_dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs btrfs ext4
+_require_user
+_require_test
+verb=fzero
+_require_xfs_io_command $verb
+
+junk_dir=$TEST_DIR/$seq
+junk_file=$junk_dir/a
+mkdir -p $junk_dir/
+chmod a+rw $junk_dir/
+
+setup_testfile() {
+	rm -f $junk_file
+	_pwrite_byte 0x58 0 192k $junk_file >> $seqres.full
+	sync
+}
+
+commit_and_check() {
+	local user="$1"
+	local command="$2"
+	local start="$3"
+	local end="$4"
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+
+	local cmd="$XFS_IO_PROG -c '$command $start $end' $junk_file"
+	if [ -n "$user" ]; then
+		su - "$user" -c "$cmd" >> $seqres.full
+	else
+		$SHELL -c "$cmd" >> $seqres.full
+	fi
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+
+	# Blank line in output
+	echo
+}
+
+nr=0
+# Commit to a non-exec file by an unprivileged user clears suid but
+# leaves sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, non-exec file $verb"
+setup_testfile
+chmod a+rws $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a group-exec file by an unprivileged user clears suid and
+# sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, group-exec file $verb"
+setup_testfile
+chmod g+x,a+rws $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a user-exec file by an unprivileged user clears suid but
+# not sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, user-exec file $verb"
+setup_testfile
+chmod u+x,a+rws,g-x $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a all-exec file by an unprivileged user clears suid and
+# sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, all-exec file $verb"
+setup_testfile
+chmod a+rwxs $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a non-exec file by root clears suid but leaves sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, non-exec file $verb"
+setup_testfile
+chmod a+rws $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a group-exec file by root clears suid and sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, group-exec file $verb"
+setup_testfile
+chmod g+x,a+rws $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a user-exec file by root clears suid but not sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, user-exec file $verb"
+setup_testfile
+chmod u+x,a+rws,g-x $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a all-exec file by root clears suid and sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, all-exec file $verb"
+setup_testfile
+chmod a+rwxs $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/836.out b/tests/generic/836.out
new file mode 100644
index 00000000..9f9f5f12
--- /dev/null
+++ b/tests/generic/836.out
@@ -0,0 +1,33 @@
+QA output created by 836
+Test 1 - qa_user, non-exec file fzero
+6666 -rwSrwSrw- TEST_DIR/836/a
+666 -rw-rw-rw- TEST_DIR/836/a
+
+Test 2 - qa_user, group-exec file fzero
+6676 -rwSrwsrw- TEST_DIR/836/a
+676 -rw-rwxrw- TEST_DIR/836/a
+
+Test 3 - qa_user, user-exec file fzero
+6766 -rwsrwSrw- TEST_DIR/836/a
+766 -rwxrw-rw- TEST_DIR/836/a
+
+Test 4 - qa_user, all-exec file fzero
+6777 -rwsrwsrwx TEST_DIR/836/a
+777 -rwxrwxrwx TEST_DIR/836/a
+
+Test 5 - root, non-exec file fzero
+6666 -rwSrwSrw- TEST_DIR/836/a
+6666 -rwSrwSrw- TEST_DIR/836/a
+
+Test 6 - root, group-exec file fzero
+6676 -rwSrwsrw- TEST_DIR/836/a
+6676 -rwSrwsrw- TEST_DIR/836/a
+
+Test 7 - root, user-exec file fzero
+6766 -rwsrwSrw- TEST_DIR/836/a
+6766 -rwsrwSrw- TEST_DIR/836/a
+
+Test 8 - root, all-exec file fzero
+6777 -rwsrwsrwx TEST_DIR/836/a
+6777 -rwsrwsrwx TEST_DIR/836/a
+
diff --git a/tests/generic/837 b/tests/generic/837
new file mode 100755
index 00000000..477b8f21
--- /dev/null
+++ b/tests/generic/837
@@ -0,0 +1,127 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 837
+#
+# Functional test for dropping suid and sgid bits as part of a finsert.
+#
+. ./common/preamble
+_begin_fstest auto clone quick
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $junk_dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs btrfs ext4
+_require_user
+_require_test
+verb=finsert
+_require_xfs_io_command $verb
+
+junk_dir=$TEST_DIR/$seq
+junk_file=$junk_dir/a
+mkdir -p $junk_dir/
+chmod a+rw $junk_dir/
+
+setup_testfile() {
+	rm -f $junk_file
+	_pwrite_byte 0x58 0 192k $junk_file >> $seqres.full
+	sync
+}
+
+commit_and_check() {
+	local user="$1"
+	local command="$2"
+	local start="$3"
+	local end="$4"
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+
+	local cmd="$XFS_IO_PROG -c '$command $start $end' $junk_file"
+	if [ -n "$user" ]; then
+		su - "$user" -c "$cmd" >> $seqres.full
+	else
+		$SHELL -c "$cmd" >> $seqres.full
+	fi
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+
+	# Blank line in output
+	echo
+}
+
+nr=0
+# Commit to a non-exec file by an unprivileged user clears suid but
+# leaves sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, non-exec file $verb"
+setup_testfile
+chmod a+rws $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a group-exec file by an unprivileged user clears suid and
+# sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, group-exec file $verb"
+setup_testfile
+chmod g+x,a+rws $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a user-exec file by an unprivileged user clears suid but
+# not sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, user-exec file $verb"
+setup_testfile
+chmod u+x,a+rws,g-x $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a all-exec file by an unprivileged user clears suid and
+# sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, all-exec file $verb"
+setup_testfile
+chmod a+rwxs $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a non-exec file by root clears suid but leaves sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, non-exec file $verb"
+setup_testfile
+chmod a+rws $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a group-exec file by root clears suid and sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, group-exec file $verb"
+setup_testfile
+chmod g+x,a+rws $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a user-exec file by root clears suid but not sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, user-exec file $verb"
+setup_testfile
+chmod u+x,a+rws,g-x $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a all-exec file by root clears suid and sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, all-exec file $verb"
+setup_testfile
+chmod a+rwxs $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/837.out b/tests/generic/837.out
new file mode 100644
index 00000000..686b806e
--- /dev/null
+++ b/tests/generic/837.out
@@ -0,0 +1,33 @@
+QA output created by 837
+Test 1 - qa_user, non-exec file finsert
+6666 -rwSrwSrw- TEST_DIR/837/a
+666 -rw-rw-rw- TEST_DIR/837/a
+
+Test 2 - qa_user, group-exec file finsert
+6676 -rwSrwsrw- TEST_DIR/837/a
+676 -rw-rwxrw- TEST_DIR/837/a
+
+Test 3 - qa_user, user-exec file finsert
+6766 -rwsrwSrw- TEST_DIR/837/a
+766 -rwxrw-rw- TEST_DIR/837/a
+
+Test 4 - qa_user, all-exec file finsert
+6777 -rwsrwsrwx TEST_DIR/837/a
+777 -rwxrwxrwx TEST_DIR/837/a
+
+Test 5 - root, non-exec file finsert
+6666 -rwSrwSrw- TEST_DIR/837/a
+6666 -rwSrwSrw- TEST_DIR/837/a
+
+Test 6 - root, group-exec file finsert
+6676 -rwSrwsrw- TEST_DIR/837/a
+6676 -rwSrwsrw- TEST_DIR/837/a
+
+Test 7 - root, user-exec file finsert
+6766 -rwsrwSrw- TEST_DIR/837/a
+6766 -rwsrwSrw- TEST_DIR/837/a
+
+Test 8 - root, all-exec file finsert
+6777 -rwsrwsrwx TEST_DIR/837/a
+6777 -rwsrwsrwx TEST_DIR/837/a
+
diff --git a/tests/generic/838 b/tests/generic/838
new file mode 100755
index 00000000..d7c7e5a8
--- /dev/null
+++ b/tests/generic/838
@@ -0,0 +1,127 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 838
+#
+# Functional test for dropping suid and sgid bits as part of a fcollapse.
+#
+. ./common/preamble
+_begin_fstest auto clone quick
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $junk_dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs btrfs ext4
+_require_user
+_require_test
+verb=fcollapse
+_require_xfs_io_command $verb
+
+junk_dir=$TEST_DIR/$seq
+junk_file=$junk_dir/a
+mkdir -p $junk_dir/
+chmod a+rw $junk_dir/
+
+setup_testfile() {
+	rm -f $junk_file
+	_pwrite_byte 0x58 0 192k $junk_file >> $seqres.full
+	sync
+}
+
+commit_and_check() {
+	local user="$1"
+	local command="$2"
+	local start="$3"
+	local end="$4"
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+
+	local cmd="$XFS_IO_PROG -c '$command $start $end' $junk_file"
+	if [ -n "$user" ]; then
+		su - "$user" -c "$cmd" >> $seqres.full
+	else
+		$SHELL -c "$cmd" >> $seqres.full
+	fi
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+
+	# Blank line in output
+	echo
+}
+
+nr=0
+# Commit to a non-exec file by an unprivileged user clears suid but
+# leaves sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, non-exec file $verb"
+setup_testfile
+chmod a+rws $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a group-exec file by an unprivileged user clears suid and
+# sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, group-exec file $verb"
+setup_testfile
+chmod g+x,a+rws $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a user-exec file by an unprivileged user clears suid but
+# not sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, user-exec file $verb"
+setup_testfile
+chmod u+x,a+rws,g-x $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a all-exec file by an unprivileged user clears suid and
+# sgid.
+nr=$((nr + 1))
+echo "Test $nr - qa_user, all-exec file $verb"
+setup_testfile
+chmod a+rwxs $junk_file
+commit_and_check "$qa_user" "$verb" 64k 64k
+
+# Commit to a non-exec file by root clears suid but leaves sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, non-exec file $verb"
+setup_testfile
+chmod a+rws $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a group-exec file by root clears suid and sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, group-exec file $verb"
+setup_testfile
+chmod g+x,a+rws $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a user-exec file by root clears suid but not sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, user-exec file $verb"
+setup_testfile
+chmod u+x,a+rws,g-x $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# Commit to a all-exec file by root clears suid and sgid.
+nr=$((nr + 1))
+echo "Test $nr - root, all-exec file $verb"
+setup_testfile
+chmod a+rwxs $junk_file
+commit_and_check "" "$verb" 64k 64k
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/838.out b/tests/generic/838.out
new file mode 100644
index 00000000..cdc29f4b
--- /dev/null
+++ b/tests/generic/838.out
@@ -0,0 +1,33 @@
+QA output created by 838
+Test 1 - qa_user, non-exec file fcollapse
+6666 -rwSrwSrw- TEST_DIR/838/a
+666 -rw-rw-rw- TEST_DIR/838/a
+
+Test 2 - qa_user, group-exec file fcollapse
+6676 -rwSrwsrw- TEST_DIR/838/a
+676 -rw-rwxrw- TEST_DIR/838/a
+
+Test 3 - qa_user, user-exec file fcollapse
+6766 -rwsrwSrw- TEST_DIR/838/a
+766 -rwxrw-rw- TEST_DIR/838/a
+
+Test 4 - qa_user, all-exec file fcollapse
+6777 -rwsrwsrwx TEST_DIR/838/a
+777 -rwxrwxrwx TEST_DIR/838/a
+
+Test 5 - root, non-exec file fcollapse
+6666 -rwSrwSrw- TEST_DIR/838/a
+6666 -rwSrwSrw- TEST_DIR/838/a
+
+Test 6 - root, group-exec file fcollapse
+6676 -rwSrwsrw- TEST_DIR/838/a
+6676 -rwSrwsrw- TEST_DIR/838/a
+
+Test 7 - root, user-exec file fcollapse
+6766 -rwsrwSrw- TEST_DIR/838/a
+6766 -rwsrwSrw- TEST_DIR/838/a
+
+Test 8 - root, all-exec file fcollapse
+6777 -rwsrwsrwx TEST_DIR/838/a
+6777 -rwsrwsrwx TEST_DIR/838/a
+
diff --git a/tests/generic/839 b/tests/generic/839
new file mode 100755
index 00000000..70bef5fc
--- /dev/null
+++ b/tests/generic/839
@@ -0,0 +1,77 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 839
+#
+# Functional test for dropping capability bits as part of an fallocate.
+#
+. ./common/preamble
+_begin_fstest auto prealloc quick
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $junk_dir
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs btrfs ext4
+_require_user
+_require_command "$GETCAP_PROG" getcap
+_require_command "$SETCAP_PROG" setcap
+_require_xfs_io_command falloc
+_require_test
+
+junk_dir=$TEST_DIR/$seq
+junk_file=$junk_dir/a
+mkdir -p $junk_dir/
+chmod a+rw $junk_dir/
+
+setup_testfile() {
+	rm -f $junk_file
+	touch $junk_file
+	chmod a+rwx $junk_file
+	$SETCAP_PROG cap_setgid,cap_setuid+ep $junk_file
+	sync
+}
+
+commit_and_check() {
+	local user="$1"
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+	_getcap -v $junk_file | _filter_test_dir
+
+	local cmd="$XFS_IO_PROG -c 'falloc 0 64k' $junk_file"
+	if [ -n "$user" ]; then
+		su - "$user" -c "$cmd" >> $seqres.full
+	else
+		$SHELL -c "$cmd" >> $seqres.full
+	fi
+
+	stat -c '%a %A %n' $junk_file | _filter_test_dir
+	_getcap -v $junk_file | _filter_test_dir
+
+	# Blank line in output
+	echo
+}
+
+# Commit by an unprivileged user clears capability bits.
+echo "Test 1 - qa_user"
+setup_testfile
+commit_and_check "$qa_user"
+
+# Commit by root leaves capability bits.
+echo "Test 2 - root"
+setup_testfile
+commit_and_check
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/839.out b/tests/generic/839.out
new file mode 100755
index 00000000..f571cd26
--- /dev/null
+++ b/tests/generic/839.out
@@ -0,0 +1,13 @@
+QA output created by 839
+Test 1 - qa_user
+777 -rwxrwxrwx TEST_DIR/839/a
+TEST_DIR/839/a cap_setgid,cap_setuid=ep
+777 -rwxrwxrwx TEST_DIR/839/a
+TEST_DIR/839/a
+
+Test 2 - root
+777 -rwxrwxrwx TEST_DIR/839/a
+TEST_DIR/839/a cap_setgid,cap_setuid=ep
+777 -rwxrwxrwx TEST_DIR/839/a
+TEST_DIR/839/a
+

