Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A90EC4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2078460F23
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhG1AKT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232778AbhG1AKS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 085D0601FC;
        Wed, 28 Jul 2021 00:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627431018;
        bh=SE2vvoqQLvXPIYlN7dlqt+4lP6hI4EgxTfWRjftnTFo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UQWrOjomMct51Stm3YnFQifDJufWDwwtQ54z59LEC4bkLqlyBI6eP4kjCVDixUw7c
         QRWPy7SwCnt6DEH+DI7kc/n8cDNRJUR+lOjFQRZAnKjWUVTdyLCre3xJevMQAA4LVU
         /hqUQzRnuhe1kpUrnEMpkkIfqtrsWDhFvK/AASLQV7DBzkB/Ybt9cCXSVAz5IJErrr
         1+9wURmRaOxVI6jgU5Fci+BJ0IHAAM5zB50mpunFRwV9i+fRG+bMKcxNdJkHHGhvAS
         tJOtg8qlu23EloCOIKmH3DOEqKg1hPmdeoVmkOsFSlzKZfteE6/eNX7e3WhEqlYNpW
         WXHteRNYCcN8A==
Subject: [PATCH 3/3] xfs: test adding realtime sections to filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Jul 2021 17:10:17 -0700
Message-ID: <162743101775.3428143.6280448731776178585.stgit@magnolia>
In-Reply-To: <162743100128.3428143.7362558731136046380.stgit@magnolia>
References: <162743100128.3428143.7362558731136046380.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a functional test to exercise using "xfs_growfs -e XXX -r" to add a
realtime section to a filesystem while changing the extent size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/779     |  112 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/779.out |    2 +
 2 files changed, 114 insertions(+)
 create mode 100755 tests/xfs/779
 create mode 100644 tests/xfs/779.out


diff --git a/tests/xfs/779 b/tests/xfs/779
new file mode 100755
index 00000000..f064879c
--- /dev/null
+++ b/tests/xfs/779
@@ -0,0 +1,112 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test 779
+#
+# Test for xfs_growfs to make sure that we can add a realtime device and set
+# its extent size hint at the same time.  This also checks for the presence of
+# these patches:
+#
+#	xfs: improve FSGROWFSRT precondition checking
+#	xfs: fix an integer overflow error in xfs_growfs_rt
+#	xfs: correct the narrative around misaligned rtinherit/extszinherit dirs
+#	xfs: don't expose misaligned extszinherit hints to userspace
+#
+. ./common/preamble
+_begin_fstest auto quick realtime growfs
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_realtime
+_require_scratch
+
+# Format scratch fs with no realtime section.
+SCRATCH_RTDEV="" _scratch_mkfs | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
+_scratch_mount
+
+# Check that there's no realtime section.
+source $tmp.mkfs
+test $rtblocks -eq 0 || echo "expected 0 rtblocks, got $rtblocks"
+
+# Compute a new rt extent size and a separate rt extent size hint to exercise
+# the code that ignores hints that aren't a multiple of the extent size.
+XFS_MAX_RTEXTSIZE=$((1024 * 1024 * 1024))
+new_rtextsz=$((rtextsz + dbsize))
+if [ $new_rtextsz -gt $XFS_MAX_RTEXTSIZE ]; then
+	new_rtextsz=$((rtextsz - dbsize))
+fi
+new_rtextsz_blocks=$(( new_rtextsz / dbsize ))
+
+new_extszhint=$((rtextsz * 2))
+if [ $new_extszhint -eq $new_rtextsz ]; then
+	new_extszhint=$((rtextsz * 3))
+fi
+
+# Set the inheritable extent size hint and rt status.
+$XFS_IO_PROG -c 'chattr +t' -c "extsize $new_extszhint" $SCRATCH_MNT
+
+# Check that the hint was set correctly
+after_extszhint=$($XFS_IO_PROG -c 'stat' $SCRATCH_MNT | \
+	grep 'fsxattr.extsize' | cut -d ' ' -f 3)
+test $after_extszhint -eq $new_extszhint || \
+	echo "expected extszhint $new_extszhint, got $after_extszhint"
+
+# Add a realtime section and change the extent size.
+echo $XFS_GROWFS_PROG -e $new_rtextsz_blocks -r $SCRATCH_MNT >> $seqres.full
+$XFS_GROWFS_PROG -e $new_rtextsz_blocks -r $SCRATCH_MNT >> $seqres.full 2> $tmp.growfs
+res=$?
+cat $tmp.growfs
+
+# If the growfs failed, skip the post-test check because the scratch fs does
+# not have SCRATCH_RTDEV configured.  If the kernel didn't support adding the
+# rt volume, skip everything else.
+if [ $res -ne 0 ]; then
+	rm -f ${RESULT_DIR}/require_scratch
+	if grep -q "Operation not supported" $tmp.growfs; then
+		_notrun "growfs not supported on rt volume"
+	fi
+fi
+
+# Now that the root directory's extsize hint is no longer aligned to the rt
+# extent size, check that we don't report it to userspace any more.
+grow_extszhint=$($XFS_IO_PROG -c 'stat' $SCRATCH_MNT | \
+	grep 'fsxattr.extsize' | cut -d ' ' -f 3)
+test $grow_extszhint -eq 0 || \
+	echo "expected post-grow extszhint 0, got $grow_extszhint"
+
+# Check that we now have rt extents.
+rtextents=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | \
+	grep 'geom.rtextents' | cut -d ' ' -f 3)
+test $rtextents -gt 0 || echo "expected rtextents > 0"
+
+# Check the new rt extent size.
+after_rtextsz_blocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | \
+	grep 'geom.rtextsize' | cut -d ' ' -f 3)
+test $after_rtextsz_blocks -eq $new_rtextsz_blocks || \
+	echo "expected rtextsize $new_rtextsz_blocks, got $after_rtextsz_blocks"
+
+# Create a new realtime file to prove that we can.
+echo moo > $SCRATCH_MNT/a
+sync
+$XFS_IO_PROG -c 'lsattr -v' $SCRATCH_MNT/a | \
+	cut -d ' ' -f 1 | \
+	grep -q realtime || \
+	echo "$SCRATCH_MNT/a is not a realtime file?"
+
+# Check that the root directory's hint (which was aligned before the grow and
+# misaligned after) did not propagate to the new realtime file.
+file_extszhint=$($XFS_IO_PROG -c 'stat' $SCRATCH_MNT/a | \
+	grep 'fsxattr.extsize' | cut -d ' ' -f 3)
+test $file_extszhint -eq 0 || \
+	echo "expected file extszhint 0, got $file_extszhint"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/779.out b/tests/xfs/779.out
new file mode 100644
index 00000000..1f79fae2
--- /dev/null
+++ b/tests/xfs/779.out
@@ -0,0 +1,2 @@
+QA output created by 779
+Silence is golden

