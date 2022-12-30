Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A59BAC3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbiLaAxB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:53:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57A913F29;
        Fri, 30 Dec 2022 16:52:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94A14B81DFA;
        Sat, 31 Dec 2022 00:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43985C433EF;
        Sat, 31 Dec 2022 00:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447977;
        bh=lcRbbT4hYzL+E4ZZlSfVwqApsVGMxkx0njhBLIOXB8g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZseYNclfQj8hOtdVmtJWUxWtgEfFIC1L+W6U52nPJd4QiGfYJr3I8Zj9vlHuXqmL6
         fCf21zGmsUCMzp2xKCf6jQ25G7vHPYrcE4gETC/w0JIMl5jGDGkzIUC4p+UXa3Nsj3
         jJAglYSgx5CGBtTZBo/6MkyoVHkl2LpNZ8N1dJcDNvtU7rOV0puJwDnAxdF3TcSPfl
         yNlVrcIdjkOY3GNquebZHLegmfDH3HgCRFMy9TROdaI4iZBflYZOkfP9VoMZF3i1V/
         TWm5Y1FJk2vQZWNpLCeff8mdzygBW5hK+mnNLK/z2ydLDRD94BEsJB4YdNNjGkiHED
         XpfCUxDT928+A==
Subject: [PATCH 5/7] generic: test that file privilege gets dropped with
 FIEXCHANGE_RANGE
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878886.732172.11575927475610726999.stgit@magnolia>
In-Reply-To: <167243878818.732172.6392253687008406885.stgit@magnolia>
References: <167243878818.732172.6392253687008406885.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that we clear the suid and sgid bits and capabilities during a
FIEXCHANGE_RANGE call just like we would for a regular file write.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/1218     |  115 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1218.out |   49 ++++++++++++++++++++
 tests/generic/1219     |   83 +++++++++++++++++++++++++++++++++++
 tests/generic/1219.out |   17 +++++++
 4 files changed, 264 insertions(+)
 create mode 100755 tests/generic/1218
 create mode 100644 tests/generic/1218.out
 create mode 100755 tests/generic/1219
 create mode 100755 tests/generic/1219.out


diff --git a/tests/generic/1218 b/tests/generic/1218
new file mode 100755
index 0000000000..e6c170351e
--- /dev/null
+++ b/tests/generic/1218
@@ -0,0 +1,115 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1218
+#
+# Functional test for dropping suid and sgid bits as part of an atomic file
+# commit.
+#
+. ./common/preamble
+_begin_fstest auto fiexchange swapext quick
+
+# Override the default cleanup function.
+# _cleanup()
+# {
+# 	cd /
+# 	rm -r -f $tmp.*
+# }
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_user
+_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command startupdate
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
+chmod a+rw $SCRATCH_MNT/
+
+setup_testfile() {
+	rm -f $SCRATCH_MNT/a
+	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
+	sync
+}
+
+commit_and_check() {
+	local user="$1"
+
+	md5sum $SCRATCH_MNT/a | _filter_scratch
+	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
+
+	local cmd="$XFS_IO_PROG -c 'startupdate' -c 'pwrite -S 0x57 0 1m' -c 'commitupdate' $SCRATCH_MNT/a"
+	if [ -n "$user" ]; then
+		su - "$user" -c "$cmd" >> $seqres.full
+	else
+		$SHELL -c "$cmd" >> $seqres.full
+	fi
+
+	_scratch_cycle_mount
+	md5sum $SCRATCH_MNT/a | _filter_scratch
+	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
+
+	# Blank line in output
+	echo
+}
+
+# Commit to a non-exec file by an unprivileged user clears suid but leaves
+# sgid.
+echo "Test 1 - qa_user, non-exec file"
+setup_testfile
+chmod a+rws $SCRATCH_MNT/a
+commit_and_check "$qa_user"
+
+# Commit to a group-exec file by an unprivileged user clears suid and sgid.
+echo "Test 2 - qa_user, group-exec file"
+setup_testfile
+chmod g+x,a+rws $SCRATCH_MNT/a
+commit_and_check "$qa_user"
+
+# Commit to a user-exec file by an unprivileged user clears suid but not sgid.
+echo "Test 3 - qa_user, user-exec file"
+setup_testfile
+chmod u+x,a+rws,g-x $SCRATCH_MNT/a
+commit_and_check "$qa_user"
+
+# Commit to a all-exec file by an unprivileged user clears suid and sgid.
+echo "Test 4 - qa_user, all-exec file"
+setup_testfile
+chmod a+rwxs $SCRATCH_MNT/a
+commit_and_check "$qa_user"
+
+# Commit to a non-exec file by root leaves suid and sgid.
+echo "Test 5 - root, non-exec file"
+setup_testfile
+chmod a+rws $SCRATCH_MNT/a
+commit_and_check
+
+# Commit to a group-exec file by root leaves suid and sgid.
+echo "Test 6 - root, group-exec file"
+setup_testfile
+chmod g+x,a+rws $SCRATCH_MNT/a
+commit_and_check
+
+# Commit to a user-exec file by root leaves suid and sgid.
+echo "Test 7 - root, user-exec file"
+setup_testfile
+chmod u+x,a+rws,g-x $SCRATCH_MNT/a
+commit_and_check
+
+# Commit to a all-exec file by root leaves suid and sgid.
+echo "Test 8 - root, all-exec file"
+setup_testfile
+chmod a+rwxs $SCRATCH_MNT/a
+commit_and_check
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1218.out b/tests/generic/1218.out
new file mode 100644
index 0000000000..8f4469aad4
--- /dev/null
+++ b/tests/generic/1218.out
@@ -0,0 +1,49 @@
+QA output created by 1218
+Test 1 - qa_user, non-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6666 -rwSrwSrw- SCRATCH_MNT/a
+3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
+666 -rw-rw-rw- SCRATCH_MNT/a
+
+Test 2 - qa_user, group-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6676 -rwSrwsrw- SCRATCH_MNT/a
+3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
+676 -rw-rwxrw- SCRATCH_MNT/a
+
+Test 3 - qa_user, user-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6766 -rwsrwSrw- SCRATCH_MNT/a
+3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
+766 -rwxrw-rw- SCRATCH_MNT/a
+
+Test 4 - qa_user, all-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6777 -rwsrwsrwx SCRATCH_MNT/a
+3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
+777 -rwxrwxrwx SCRATCH_MNT/a
+
+Test 5 - root, non-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6666 -rwSrwSrw- SCRATCH_MNT/a
+3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
+6666 -rwSrwSrw- SCRATCH_MNT/a
+
+Test 6 - root, group-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6676 -rwSrwsrw- SCRATCH_MNT/a
+3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
+6676 -rwSrwsrw- SCRATCH_MNT/a
+
+Test 7 - root, user-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6766 -rwsrwSrw- SCRATCH_MNT/a
+3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
+6766 -rwsrwSrw- SCRATCH_MNT/a
+
+Test 8 - root, all-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6777 -rwsrwsrwx SCRATCH_MNT/a
+3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
+6777 -rwsrwsrwx SCRATCH_MNT/a
+
diff --git a/tests/generic/1219 b/tests/generic/1219
new file mode 100755
index 0000000000..fe20475058
--- /dev/null
+++ b/tests/generic/1219
@@ -0,0 +1,83 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1219
+#
+# Functional test for dropping capability bits as part of an atomic file
+# commit.
+#
+. ./common/preamble
+_begin_fstest auto fiexchange swapext quick
+
+# Override the default cleanup function.
+# _cleanup()
+# {
+# 	cd /
+# 	rm -r -f $tmp.*
+# }
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_user
+_require_command "$GETCAP_PROG" getcap
+_require_command "$SETCAP_PROG" setcap
+_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command startupdate
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
+chmod a+rw $SCRATCH_MNT/
+
+setup_testfile() {
+	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
+	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
+	_pwrite_byte 0x57 0 1m $SCRATCH_MNT/b >> $seqres.full
+	chmod a+rw $SCRATCH_MNT/a $SCRATCH_MNT/b
+	$SETCAP_PROG cap_setgid,cap_setuid+ep $SCRATCH_MNT/a
+	sync
+}
+
+commit_and_check() {
+	local user="$1"
+
+	md5sum $SCRATCH_MNT/a | _filter_scratch
+	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
+	_getcap -v $SCRATCH_MNT/a | _filter_scratch
+
+	local cmd="$XFS_IO_PROG -c 'startupdate' -c 'pwrite -S 0x57 0 1m' -c 'commitupdate' $SCRATCH_MNT/a"
+	if [ -n "$user" ]; then
+		su - "$user" -c "$cmd" >> $seqres.full
+	else
+		$SHELL -c "$cmd" >> $seqres.full
+	fi
+
+	_scratch_cycle_mount
+	md5sum $SCRATCH_MNT/a | _filter_scratch
+	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
+	_getcap -v $SCRATCH_MNT/a | _filter_scratch
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
diff --git a/tests/generic/1219.out b/tests/generic/1219.out
new file mode 100755
index 0000000000..a925b4ec4f
--- /dev/null
+++ b/tests/generic/1219.out
@@ -0,0 +1,17 @@
+QA output created by 1219
+Test 1 - qa_user
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+666 -rw-rw-rw- SCRATCH_MNT/a
+SCRATCH_MNT/a cap_setgid,cap_setuid=ep
+3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
+666 -rw-rw-rw- SCRATCH_MNT/a
+SCRATCH_MNT/a
+
+Test 2 - root
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+666 -rw-rw-rw- SCRATCH_MNT/a
+SCRATCH_MNT/a cap_setgid,cap_setuid=ep
+3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
+666 -rw-rw-rw- SCRATCH_MNT/a
+SCRATCH_MNT/a
+

