Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97025C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbiLaAl7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiLaAlw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:41:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F10C1D0C8;
        Fri, 30 Dec 2022 16:41:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32333B81E5C;
        Sat, 31 Dec 2022 00:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E594FC433D2;
        Sat, 31 Dec 2022 00:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447308;
        bh=P2W3QZG1FHvcjrs1obLySrww9Z+qQqFuBjXBZallNe0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IbN2jh8FOsf82xxc52IXzIKXtvaI1YhAGCxjc91rRzMseMxDVspJwhPBW8Lub2zJE
         5g5FD4x7mlcZMjfs2Fw1XgdHSY+Po124bpLQ/VtYNtFcW5bWXgbz1c8bJz23iKKD7c
         aatA8v7n+MUpzdDrtL98iDH/ygvbFf4SFIC2HL6d7vboU2IY6+8Q6WQXwaC1w/f5Pt
         a4ACB454nRIpCTcpWleYqDFxw672tx9hKseFwjIetPo2aWKRrv2Lo1t4wNl6TP0L5A
         r7wWfk0p44ECkOrpsRDsbWv9wD3qbeBbdWbrJQLV/k40YSv6rgHC0RoFJy8x/v4jc4
         +yYg6HY9cvYIQ==
Subject: [PATCH 3/4] xfs: ensure that online file data fork repairs don't hit
 EDQUOT
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:18 -0800
Message-ID: <167243875875.725760.15413971718682420180.stgit@magnolia>
In-Reply-To: <167243875835.725760.8458608166534095780.stgit@magnolia>
References: <167243875835.725760.8458608166534095780.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a test to ensure that the sysadmin doesn't get EDQUOT if they try to
repair file data fork metadata when we've already exceeded a quota limit
somewhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/840     |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/840.out |    3 ++
 2 files changed, 75 insertions(+)
 create mode 100755 tests/xfs/840
 create mode 100644 tests/xfs/840.out


diff --git a/tests/xfs/840 b/tests/xfs/840
new file mode 100755
index 0000000000..fff41c5b8a
--- /dev/null
+++ b/tests/xfs/840
@@ -0,0 +1,72 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 840
+#
+# Ensure that the sysadmin won't hit EDQUOT while repairing file data forks
+# even if the file's quota limits have been exceeded.  This tests the quota
+# reservation handling inside the bmap btree rebuilding code.
+#
+. ./common/preamble
+_begin_fstest online_repair
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/quota
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_require_xfs_io_command "falloc"
+_require_quota
+_require_user
+_require_test_program "punch-alternating"
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_qmount_option usrquota
+_qmount
+
+blocksize=$(_get_block_size $SCRATCH_MNT)
+alloc_unit=$(_get_file_block_size $SCRATCH_MNT)
+
+# Make sure we can actually repair a data fork
+scratchfile=$SCRATCH_MNT/file
+touch $scratchfile
+$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
+__stress_scrub_check_commands "$scratchfile" "" 'repair bmapbtd'
+
+# Compute the number of extent records needed to guarantee btree format,
+# assuming 16 bytes for each ondisk extent record
+bmbt_records=$(( (blocksize / 16) * 5 / 4 ))
+total_size=$(( bmbt_records * 2 * alloc_unit ))
+
+# Create a file with a data fork in bmap btree format
+$XFS_IO_PROG -c "falloc 0 $total_size" $scratchfile >> $seqres.full
+$here/src/punch-alternating $scratchfile
+
+# Set a low quota hardlimit for an unprivileged uid and chown the file to it
+echo "set up quota" >> $seqres.full
+$XFS_QUOTA_PROG -x -c "limit -u bhard=$((alloc_unit * 2)) $qa_user" $SCRATCH_MNT
+chown $qa_user $scratchfile
+$XFS_QUOTA_PROG -x -c 'report -u' $SCRATCH_MNT >> $seqres.full
+
+# Rebuild the data fork
+echo "repairs" >> $seqres.full
+$XFS_IO_PROG -x -c 'inject force_repair' -c 'repair bmapbtd' $scratchfile
+$XFS_QUOTA_PROG -x -c 'report -u' $SCRATCH_MNT >> $seqres.full
+
+# Fail at appending the file as qa_user to ensure quota enforcement works
+echo "fail quota" >> $seqres.full
+su - "$qa_user" -c "$XFS_IO_PROG -c 'pwrite 10g 1' $scratchfile" >> $seqres.full
+$XFS_QUOTA_PROG -x -c 'report -u' $SCRATCH_MNT >> $seqres.full
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/840.out b/tests/xfs/840.out
new file mode 100644
index 0000000000..8c32ec12bb
--- /dev/null
+++ b/tests/xfs/840.out
@@ -0,0 +1,3 @@
+QA output created by 840
+pwrite: Disk quota exceeded
+Silence is golden

