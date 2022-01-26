Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258DAC5DF62
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jan 2022 02:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbiAZCLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 21:11:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60750 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiAZCLw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jan 2022 21:11:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5B59B81B99;
        Wed, 26 Jan 2022 02:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6800BC340E0;
        Wed, 26 Jan 2022 02:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643163109;
        bh=vFcz+9ZaGOVORcszWZ6dssXVUiBVoK6SI4nN6Y18lK4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ieN9v0ZrPSqte0TINSr7h9IjZYRh3PMdTB1YifWusKdUfHZjmt9HsTrSFDqcSzTcu
         eYUXXwT4mSa009+m2bda2SW9IfB9Ag6fqR4lcVYL96nQqJZt68oRtCnFS2svrvSgNz
         NoFzN/dPWN1q/DwATOIzxXUj/fs7E+YHTVfzWBuFMI5vIIMmvkSkji37KYYdZ64o2b
         mScS/YaMZA+vonY10h/fHu+nzpYYcv1YJt+nPsrnG5Tv8GVgvox0cmNWwhtq7VksgQ
         rZLQMIy2MEsggZVm1BOdBr6KwgTP9pBf6nFSy/qXk7pEENTSssE0U+l8fw4BBxKWj5
         lJmWPBJrKq0Rg==
Subject: [PATCH 1/2] generic: test suid/sgid behavior with reflink and dedupe
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 Jan 2022 18:11:49 -0800
Message-ID: <164316310910.2594527.6072232851001636761.stgit@magnolia>
In-Reply-To: <164316310323.2594527.8578672050751235563.stgit@magnolia>
References: <164316310323.2594527.8578672050751235563.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that we drop the setuid and setgid bits any time reflink or
dedupe change the file contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/950     |  108 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/950.out |   49 ++++++++++++++++++++
 tests/generic/951     |  118 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/951.out |   49 ++++++++++++++++++++
 tests/generic/952     |   71 +++++++++++++++++++++++++++++
 tests/generic/952.out |   13 +++++
 6 files changed, 408 insertions(+)
 create mode 100755 tests/generic/950
 create mode 100644 tests/generic/950.out
 create mode 100755 tests/generic/951
 create mode 100644 tests/generic/951.out
 create mode 100755 tests/generic/952
 create mode 100644 tests/generic/952.out


diff --git a/tests/generic/950 b/tests/generic/950
new file mode 100755
index 00000000..84f1d1f0
--- /dev/null
+++ b/tests/generic/950
@@ -0,0 +1,108 @@
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
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
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
index 00000000..99f67ab7
--- /dev/null
+++ b/tests/generic/951
@@ -0,0 +1,118 @@
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
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
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
index 00000000..470d73bd
--- /dev/null
+++ b/tests/generic/952
@@ -0,0 +1,71 @@
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
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
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

