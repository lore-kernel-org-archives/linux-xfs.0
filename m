Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCFFC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 01:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbiA0B1C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jan 2022 20:27:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44106 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbiA0B1C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jan 2022 20:27:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3032861BA6;
        Thu, 27 Jan 2022 01:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C682C340E3;
        Thu, 27 Jan 2022 01:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643246821;
        bh=sE6KOXa0iwREZDhQqoKQGGYLm5b6+1ZoeXx/LTvxv4Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M892zkCew242Y2emaBFjCwu2c8hoBoCX9KjO+ChqNot0YpbEVsMqjOFsCH9Zizw7H
         OSPynV6dwB3mqDFg1LzDCWahrHAPp2vC++js1a23mCGTDzB2Fs0uBfEWwohQqsdnPQ
         Eyrn68HyKiswZBpZdGLsWzwnN0yfw++XSdNn3afbrxJKD6w8VZZ9zoGkRxWu1M0bZL
         Y7VMRmL0K+MyjZYc+QLHxySyO1ZwOrl8hyke9KgKL80ym+kCEI37fgCkwVpkKd84K3
         mCBbocbqYwEv+seAEaI26G24hjTq37r3aWPLF40YYONSb18GgqH0LtLjkZBoyoIuqp
         NorgP7H4aVltQ==
Date:   Wed, 26 Jan 2022 17:27:01 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v1.1 1/2] generic: test suid/sgid behavior with reflink and
 dedupe
Message-ID: <20220127012701.GD13540@magnolia>
References: <164316310323.2594527.8578672050751235563.stgit@magnolia>
 <164316310910.2594527.6072232851001636761.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164316310910.2594527.6072232851001636761.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that we drop the setuid and setgid bits any time reflink or
dedupe change the file contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: drop the congruent oplen checks, that was a mismerge
---
 tests/generic/950     |  107 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/950.out |   49 +++++++++++++++++++++
 tests/generic/951     |  117 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/951.out |   49 +++++++++++++++++++++
 tests/generic/952     |   70 +++++++++++++++++++++++++++++
 tests/generic/952.out |   13 +++++
 6 files changed, 405 insertions(+)
 create mode 100755 tests/generic/950
 create mode 100644 tests/generic/950.out
 create mode 100755 tests/generic/951
 create mode 100644 tests/generic/951.out
 create mode 100755 tests/generic/952
 create mode 100644 tests/generic/952.out

diff --git a/tests/generic/950 b/tests/generic/950
new file mode 100755
index 00000000..a7398cb5
--- /dev/null
+++ b/tests/generic/950
@@ -0,0 +1,107 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 950
+#
+# Functional test for dropping suid and sgid bits as part of a reflink.
+#
+. ./common/preamble
+_begin_fstest auto clone quick
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_user
+_require_scratch_reflink
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+chmod a+rw $SCRATCH_MNT/
+
+setup_testfile() {
+	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
+	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
+	_pwrite_byte 0x57 0 1m $SCRATCH_MNT/b >> $seqres.full
+	chmod a+r $SCRATCH_MNT/b
+	sync
+}
+
+commit_and_check() {
+	local user="$1"
+
+	md5sum $SCRATCH_MNT/a | _filter_scratch
+	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
+
+	local cmd="$XFS_IO_PROG -c 'reflink $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
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
+# Commit to a non-exec file by root clears suid but leaves sgid.
+echo "Test 5 - root, non-exec file"
+setup_testfile
+chmod a+rws $SCRATCH_MNT/a
+commit_and_check
+
+# Commit to a group-exec file by root clears suid and sgid.
+echo "Test 6 - root, group-exec file"
+setup_testfile
+chmod g+x,a+rws $SCRATCH_MNT/a
+commit_and_check
+
+# Commit to a user-exec file by root clears suid but not sgid.
+echo "Test 7 - root, user-exec file"
+setup_testfile
+chmod u+x,a+rws,g-x $SCRATCH_MNT/a
+commit_and_check
+
+# Commit to a all-exec file by root clears suid and sgid.
+echo "Test 8 - root, all-exec file"
+setup_testfile
+chmod a+rwxs $SCRATCH_MNT/a
+commit_and_check
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/950.out b/tests/generic/950.out
new file mode 100644
index 00000000..b42e4931
--- /dev/null
+++ b/tests/generic/950.out
@@ -0,0 +1,49 @@
+QA output created by 950
+Test 1 - qa_user, non-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6666 -rwSrwSrw- SCRATCH_MNT/a
+3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
+2666 -rw-rwSrw- SCRATCH_MNT/a
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
+2766 -rwxrwSrw- SCRATCH_MNT/a
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
diff --git a/tests/generic/951 b/tests/generic/951
new file mode 100755
index 00000000..8484f225
--- /dev/null
+++ b/tests/generic/951
@@ -0,0 +1,117 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 951
+#
+# Functional test for dropping suid and sgid bits as part of a deduplication.
+#
+. ./common/preamble
+_begin_fstest auto clone quick
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_user
+_require_scratch_reflink
+_require_xfs_io_command dedupe
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+chmod a+rw $SCRATCH_MNT/
+
+setup_testfile() {
+	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
+	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
+	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/b >> $seqres.full
+	chmod a+r $SCRATCH_MNT/b
+	sync
+}
+
+commit_and_check() {
+	local user="$1"
+
+	md5sum $SCRATCH_MNT/a | _filter_scratch
+	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
+
+	local before_freesp=$(_get_available_space $SCRATCH_MNT)
+
+	local cmd="$XFS_IO_PROG -c 'dedupe $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
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
+	local after_freesp=$(_get_available_space $SCRATCH_MNT)
+
+	echo "before: $before_freesp; after: $after_freesp" >> $seqres.full
+	if [ $after_freesp -le $before_freesp ]; then
+		echo "expected more free space after dedupe"
+	fi
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
+# Commit to a non-exec file by root clears suid but leaves sgid.
+echo "Test 5 - root, non-exec file"
+setup_testfile
+chmod a+rws $SCRATCH_MNT/a
+commit_and_check
+
+# Commit to a group-exec file by root clears suid and sgid.
+echo "Test 6 - root, group-exec file"
+setup_testfile
+chmod g+x,a+rws $SCRATCH_MNT/a
+commit_and_check
+
+# Commit to a user-exec file by root clears suid but not sgid.
+echo "Test 7 - root, user-exec file"
+setup_testfile
+chmod u+x,a+rws,g-x $SCRATCH_MNT/a
+commit_and_check
+
+# Commit to a all-exec file by root clears suid and sgid.
+echo "Test 8 - root, all-exec file"
+setup_testfile
+chmod a+rwxs $SCRATCH_MNT/a
+commit_and_check
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/951.out b/tests/generic/951.out
new file mode 100644
index 00000000..f7099ea2
--- /dev/null
+++ b/tests/generic/951.out
@@ -0,0 +1,49 @@
+QA output created by 951
+Test 1 - qa_user, non-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6666 -rwSrwSrw- SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6666 -rwSrwSrw- SCRATCH_MNT/a
+
+Test 2 - qa_user, group-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6676 -rwSrwsrw- SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6676 -rwSrwsrw- SCRATCH_MNT/a
+
+Test 3 - qa_user, user-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6766 -rwsrwSrw- SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6766 -rwsrwSrw- SCRATCH_MNT/a
+
+Test 4 - qa_user, all-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6777 -rwsrwsrwx SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6777 -rwsrwsrwx SCRATCH_MNT/a
+
+Test 5 - root, non-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6666 -rwSrwSrw- SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6666 -rwSrwSrw- SCRATCH_MNT/a
+
+Test 6 - root, group-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6676 -rwSrwsrw- SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6676 -rwSrwsrw- SCRATCH_MNT/a
+
+Test 7 - root, user-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6766 -rwsrwSrw- SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6766 -rwsrwSrw- SCRATCH_MNT/a
+
+Test 8 - root, all-exec file
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6777 -rwsrwsrwx SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+6777 -rwsrwsrwx SCRATCH_MNT/a
+
diff --git a/tests/generic/952 b/tests/generic/952
new file mode 100755
index 00000000..86443dcc
--- /dev/null
+++ b/tests/generic/952
@@ -0,0 +1,70 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 952
+#
+# Functional test for dropping suid and sgid capabilities as part of a reflink.
+#
+. ./common/preamble
+_begin_fstest auto clone quick
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_user
+_require_command "$GETCAP_PROG" getcap
+_require_command "$SETCAP_PROG" setcap
+_require_scratch_reflink
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+chmod a+rw $SCRATCH_MNT/
+
+setup_testfile() {
+	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
+	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
+	_pwrite_byte 0x57 0 1m $SCRATCH_MNT/b >> $seqres.full
+	chmod a+rwx $SCRATCH_MNT/a $SCRATCH_MNT/b
+	$SETCAP_PROG cap_setgid,cap_setuid+ep $SCRATCH_MNT/a
+	sync
+}
+
+commit_and_check() {
+	local user="$1"
+
+	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
+	_getcap -v $SCRATCH_MNT/a | _filter_scratch
+
+	local cmd="$XFS_IO_PROG -c 'reflink $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
+	if [ -n "$user" ]; then
+		su - "$user" -c "$cmd" >> $seqres.full
+	else
+		$SHELL -c "$cmd" >> $seqres.full
+	fi
+
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
diff --git a/tests/generic/952.out b/tests/generic/952.out
new file mode 100644
index 00000000..eac9e76a
--- /dev/null
+++ b/tests/generic/952.out
@@ -0,0 +1,13 @@
+QA output created by 952
+Test 1 - qa_user
+777 -rwxrwxrwx SCRATCH_MNT/a
+SCRATCH_MNT/a cap_setgid,cap_setuid=ep
+777 -rwxrwxrwx SCRATCH_MNT/a
+SCRATCH_MNT/a
+
+Test 2 - root
+777 -rwxrwxrwx SCRATCH_MNT/a
+SCRATCH_MNT/a cap_setgid,cap_setuid=ep
+777 -rwxrwxrwx SCRATCH_MNT/a
+SCRATCH_MNT/a
+
