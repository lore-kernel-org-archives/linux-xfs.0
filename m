Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05766C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E326B61130
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhIOXnp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:43:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232740AbhIOXnp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:43:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9E8B60F8F;
        Wed, 15 Sep 2021 23:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749345;
        bh=8u2vV3aHYUywQ0zRVsZEq0weXYIHf1yfzgmG4/WIy1E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ru2PY3ucBJx1J3Hjz0LH1R2nRIaXPPpSukMVofGfFWm5Pgv5cf1l6hfbfmHiHZ92L
         RsAhIQHJ+NxtznbQmFQPB2Pxj6OpJMecrq+ASkhnZ6+yg/rT3VLdD2ySKYu4NcidKi
         fqnwrR63rAqGSVU5viOqNFnLWmyexV90XClCWyJu8OCpP1S7NqY5dyS8kxdnVOq2Mq
         AQXuW+IbSE9b0tCknZZrjhvWOGOff5P3+d4FXl5yTESLCJF+NqoFdxop4+SgF/oE/p
         0/kzv3tIh2FMiweBSsykiDJBM+l4cLg/Mk+6UgACW5kMD6fUv3mWE92DUWxfDZZ4EM
         E5KmOBgO6b2SA==
Subject: [PATCH 3/3] xfs: test adding realtime sections to filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:25 -0700
Message-ID: <163174934556.380708.17992865379982379232.stgit@magnolia>
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

Add a functional test to exercise using "xfs_growfs -e XXX -r" to add a
realtime section to a filesystem while changing the extent size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/779     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/779.out |    2 +
 2 files changed, 116 insertions(+)
 create mode 100755 tests/xfs/779
 create mode 100644 tests/xfs/779.out


diff --git a/tests/xfs/779 b/tests/xfs/779
new file mode 100755
index 00000000..c4b5f691
--- /dev/null
+++ b/tests/xfs/779
@@ -0,0 +1,114 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test 779
+#
+# Regression test for kernel commits:
+#
+# 83193e5ebb01 ("xfs: correct the narrative around misaligned rtinherit/extszinherit dirs")
+# 5aa5b278237f ("xfs: don't expose misaligned extszinherit hints to userspace")
+# 0e2af9296f4f ("xfs: improve FSGROWFSRT precondition checking")
+# 0925fecc5574 ("xfs: fix an integer overflow error in xfs_growfs_rt")
+# b102a46ce16f ("xfs: detect misaligned rtinherit directory extent size hints")
+#
+# Test for xfs_growfs to make sure that we can add a realtime device and set
+# its extent size hint at the same time.
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
+_supported_fs xfs
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
+sync -f $SCRATCH_MNT
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

