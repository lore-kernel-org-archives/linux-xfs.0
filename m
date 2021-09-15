Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923BBC43217
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BE9361108
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhIOXnn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233035AbhIOXnj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:43:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B17C610E8;
        Wed, 15 Sep 2021 23:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749340;
        bh=bTaC9AhYN1xz1RbMAXqa6vXGzFez3nYEY36+OZsxxWE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ptSqWY47nvP6F6W+hlfUkaYoU/QkhbdtBBAWeO4daUwpOJFSK63lMiuI6VREMyXlf
         iK9r13VfpEk2TqEQZp4qb3OyrgDp1bakCC0cCfJxwytw6YtEW5scn7582zCFzLMwAj
         znWyW1XImKcC3JU3M6o+RGtjupZcevImGxTlQnN9gsaOk8ZUl3htnI67N2V1Sk6yw7
         1b7UIOhEe4m2PLX8BGU6O+RjHIbudrsVieJTn3RtjJesyPv/rwCuD6JhWeS35YKT/a
         oTmd/jqk1D9K/RN+RSLiwB+j5rqLDQ04jOgxEfKXXqt0ZL58KWbsGrcH3Zdd042gYF
         14wkflcMpXx9A==
Subject: [PATCH 2/3] xfs: test correct propagation of rt extent size hints on
 rtinherit dirs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:20 -0700
Message-ID: <163174934010.380708.2691471795571650697.stgit@magnolia>
In-Reply-To: <163174932920.380708.6760780625209949972.stgit@magnolia>
References: <163174932920.380708.6760780625209949972.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for the following fixes:

 xfs: standardize extent size hint validation
 xfs: validate extsz hints against rt extent size when rtinherit is set
 mkfs: validate rt extent size hint when rtinherit is set

These patches fix inadequate rtextsize alignment validation of extent
size hints on directories with the rtinherit and extszinherit flags set.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/774     |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/774.out |    5 +++
 tests/xfs/776     |   59 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/776.out |    5 +++
 4 files changed, 150 insertions(+)
 create mode 100755 tests/xfs/774
 create mode 100644 tests/xfs/774.out
 create mode 100755 tests/xfs/776
 create mode 100644 tests/xfs/776.out


diff --git a/tests/xfs/774 b/tests/xfs/774
new file mode 100755
index 00000000..2c7adbcc
--- /dev/null
+++ b/tests/xfs/774
@@ -0,0 +1,81 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test 774
+#
+# Regression test for kernel commits:
+#
+# 6b69e485894b ("xfs: standardize extent size hint validation")
+# 603f000b15f2 ("xfs: validate extsz hints against rt extent size when rtinherit is set")
+#
+# Regression test for xfsprogs commit:
+#
+# 1e8afffb ("mkfs: validate rt extent size hint when rtinherit is set")
+#
+# Collectively, these patches ensure that we cannot set the extent size hint on
+# a directory when the directory is configured to propagate its realtime and
+# extent size hint to newly created files when the hint size isn't aligned to
+# the size of a realtime extent.  If the patches aren't applied, the write will
+# fail and xfs_repair will say that the fs is corrupt.
+#
+. ./common/preamble
+_begin_fstest auto quick realtime mkfs
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_scratch
+
+# Check mkfs.xfs option parsing with regards to rtinherit.  XFS doesn't require
+# the realtime volume to be present to set rtinherit, so it's safe to call the
+# mkfs binary directly, in dry run mode, with exactly the parameters we want to
+# check.
+mkfs_args=(-f -N -r extsize=7b -d extszinherit=15 $SCRATCH_DEV)
+$MKFS_XFS_PROG -d rtinherit=1 "${mkfs_args[@]}" &>> $seqres.full && \
+	echo "mkfs should not succeed with heritable rtext-unaligned extent hint"
+$MKFS_XFS_PROG -d rtinherit=0 "${mkfs_args[@]}" &>> $seqres.full || \
+	echo "mkfs should succeed with uninheritable rtext-unaligned extent hint"
+
+# Move on to checking the kernel's behavior
+_scratch_mkfs -r extsize=7b | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
+cat $tmp.mkfs >> $seqres.full
+. $tmp.mkfs
+_scratch_mount
+
+test $rtextsz -ne $dbsize || \
+	_notrun "cannot set rt extent size ($rtextsz) larger than fs block size ($dbsize)"
+
+# Ensure there's no extent size hint set on the directory, then set the
+# rtinherit bit on the directory to test propagation.
+$XFS_IO_PROG -c 'extsize 0' -c 'chattr +t' $SCRATCH_MNT
+
+# Now try to set an extent size hint on the directory that isn't aligned to
+# the rt extent size.
+$XFS_IO_PROG -c "extsize $((rtextsz + dbsize))" $SCRATCH_MNT 2>&1 | _filter_scratch
+$XFS_IO_PROG -c 'stat -v' $SCRATCH_MNT > $tmp.stat
+cat $tmp.stat >> $seqres.full
+grep -q 'fsxattr.xflags.*rt-inherit' $tmp.stat || \
+	echo "rtinherit didn't get set on the directory?"
+grep 'fsxattr.extsize' $tmp.stat
+
+# Propagate the hint from directory to file
+echo moo > $SCRATCH_MNT/dummy
+$XFS_IO_PROG -c 'stat -v' $SCRATCH_MNT/dummy > $tmp.stat
+cat $tmp.stat >> $seqres.full
+grep -q 'fsxattr.xflags.*realtime' $tmp.stat || \
+	echo "realtime didnt' get set on the file?"
+grep 'fsxattr.extsize' $tmp.stat
+
+# Cycle the mount to force the inode verifier to run.
+_scratch_cycle_mount
+
+# Can we still access the dummy file?
+cat $SCRATCH_MNT/dummy
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/774.out b/tests/xfs/774.out
new file mode 100644
index 00000000..767a504e
--- /dev/null
+++ b/tests/xfs/774.out
@@ -0,0 +1,5 @@
+QA output created by 774
+xfs_io: FS_IOC_FSSETXATTR SCRATCH_MNT: Invalid argument
+fsxattr.extsize = 0
+fsxattr.extsize = 0
+moo
diff --git a/tests/xfs/776 b/tests/xfs/776
new file mode 100755
index 00000000..cfa1a4ff
--- /dev/null
+++ b/tests/xfs/776
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021, Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 776
+#
+# Functional test for xfsprogs commit:
+#
+# 5f062427 ("xfs_repair: validate alignment of inherited rt extent hints")
+#
+# This xfs_repair patch detects directories that are configured to propagate
+# their realtime and extent size hints to newly created realtime files when the
+# hint size isn't aligned to the size of a realtime extent.
+#
+# Since this is a test of userspace tool functionality, we don't need kernel
+# support, which in turn means that we omit _require_realtime.  Note that XFS
+# allows users to configure realtime extent size geometry and set RTINHERIT
+# flags even if the filesystem itself does not have a realtime volume attached.
+#
+. ./common/preamble
+_begin_fstest auto repair fuzzers
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+
+echo "Format and mount"
+_scratch_mkfs -r extsize=7b | _filter_mkfs > $seqres.full 2>$tmp.mkfs
+cat $tmp.mkfs >> $seqres.full
+. $tmp.mkfs
+
+test $rtextsz -ne $dbsize || \
+	_notrun "cannot set rt extent size ($rtextsz) larger than fs block size ($dbsize)"
+
+_scratch_mount >> $seqres.full 2>&1
+rootino=$(stat -c '%i' $SCRATCH_MNT)
+_scratch_unmount
+
+echo "Misconfigure the root directory"
+rtextsz_blks=$((rtextsz / dbsize))
+_scratch_xfs_db -x -c "inode $rootino" \
+	-c "write -d core.extsize $((rtextsz_blks + 1))" \
+	-c 'write -d core.rtinherit 1' \
+	-c 'write -d core.extszinherit 1' \
+	-c 'print' >> $seqres.full
+
+echo "Detect misconfigured directory"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 && \
+	echo "repair did not catch error?"
+
+echo "Repair misconfigured directory"
+_scratch_xfs_repair >> $seqres.full 2>&1 || \
+	echo "repair did not fix error?"
+
+status=0
+exit
diff --git a/tests/xfs/776.out b/tests/xfs/776.out
new file mode 100644
index 00000000..05ea73b2
--- /dev/null
+++ b/tests/xfs/776.out
@@ -0,0 +1,5 @@
+QA output created by 776
+Format and mount
+Misconfigure the root directory
+Detect misconfigured directory
+Repair misconfigured directory

