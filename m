Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6607C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A863C64F2C
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239992AbhBBToy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239834AbhBBTmk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 14:42:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0829464E43;
        Tue,  2 Feb 2021 19:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612294919;
        bh=uSmC8EmPkjyC1kBYtjXcH0D5QH0pPJne9kK4qhJwIOU=;
        h=Date:From:To:Cc:Subject:From;
        b=lFCjrlSYu2bxTi+VxkqMTliVnW8GOii0HcNfl4wdsqv2by7tFxQAk6JhNla9MORWe
         uQbIPtDKate8KXahrUXe6O7KWpNn0+A+nFxp4cgWFFm4FPOkXyoCx1X4aQ4SbjKkLo
         bvJNxbpUpNMO53kLL2FhrdvOg/uG1RbJWJc50DNX1g9UW75BmLLspuKdpcmjsfgwBt
         WnLNrYMBgbHiqVmwiNWPpR0mzdvACzBDlsw6s5M/JBPAfBeeRGPOwr3hoBikHyESIS
         BfnV66GaCOuQgG4LQ182dpCF1DvJ+/50ZbaVW0ksTpasH74vJwXUB22sDvRXKwlWjv
         1Tb9vqN10hpWg==
Date:   Tue, 2 Feb 2021 11:41:58 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: test a regression in dquot type checking
Message-ID: <20210202194158.GR7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for incorrect ondisk dquot type checking that
was introduced in Linux 5.9.  The bug is that we can no longer switch a
V4 filesystem from having group quotas to having project quotas (or vice
versa) without logging corruption errors.  That is a valid use case, so
add a regression test to ensure this can be done.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/766     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/766.out |    5 ++++
 tests/xfs/group   |    1 +
 3 files changed, 69 insertions(+)
 create mode 100755 tests/xfs/766
 create mode 100644 tests/xfs/766.out

diff --git a/tests/xfs/766 b/tests/xfs/766
new file mode 100755
index 00000000..55bc03af
--- /dev/null
+++ b/tests/xfs/766
@@ -0,0 +1,63 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 766
+#
+# Regression test for incorrect validation of ondisk dquot type flags when
+# we're switching between group and project quotas while mounting a V4
+# filesystem.  This test doesn't actually force the creation of a V4 fs because
+# even V5 filesystems ought to be able to switch between the two without
+# triggering corruption errors.
+#
+# The appropriate XFS patch is:
+# xfs: fix incorrect root dquot corruption error when switching group/project
+# quota types
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_debug
+_require_quota
+_require_scratch
+
+rm -f $seqres.full
+
+echo "Format filesystem" | tee -a $seqres.full
+_scratch_mkfs > $seqres.full
+
+echo "Mount with project quota" | tee -a $seqres.full
+_qmount_option 'prjquota'
+_qmount
+_require_prjquota $SCRATCH_DEV
+
+echo "Mount with group quota" | tee -a $seqres.full
+_qmount_option 'grpquota'
+_qmount
+$here/src/feature -G $SCRATCH_DEV || echo "group quota didn't mount?"
+
+echo "Check dmesg for corruption"
+_check_dmesg_for corruption && \
+	echo "should not have seen corruption messages"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/766.out b/tests/xfs/766.out
new file mode 100644
index 00000000..18bd99f0
--- /dev/null
+++ b/tests/xfs/766.out
@@ -0,0 +1,5 @@
+QA output created by 766
+Format filesystem
+Mount with project quota
+Mount with group quota
+Check dmesg for corruption
diff --git a/tests/xfs/group b/tests/xfs/group
index fb78b0d7..cdca04b5 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -545,6 +545,7 @@
 763 auto quick rw realtime
 764 auto quick repair
 765 auto quick quota
+766 auto quick quota
 908 auto quick bigtime
 909 auto quick bigtime quota
 910 auto quick inobtcount
