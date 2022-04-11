Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0DEC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350471AbiDKW5H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350475AbiDKW5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:57:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0A7DF28;
        Mon, 11 Apr 2022 15:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14FBBB8199A;
        Mon, 11 Apr 2022 22:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B7DC385A9;
        Mon, 11 Apr 2022 22:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649717688;
        bh=IFRfpBkkmOLxiQESIeeEuh7UioZXxo4ZwgO+aWayNUQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I7ccXA/DxEHi/dliFWG7wrUkcrRf1KhfxXfV3WxJ4SXaXp0LDSat1Mck+xIzsETw4
         C0k9vPJbB8QizhdIkonrEhAl5FkJeiSntGec7+n6DKyNo2Ag7EDtO2KEdMXlx5eO00
         8dm3Al74U/DKL/5azlhQU4SYGXY+wfWONZST5lUNhnUklDALgxp6sUkaTbdCS7Jl95
         DPl/CP1vzAUmFzF2wmeut/z/0GZC4AN9DiqDjV909K1xYKrUYO3RNEqBMc44/IfoKn
         IHVCs2hNSnrTOcBkZBxSR9NZXj4Lu+kuyx4xRqSHwzdGvxypIwx/GlBzSD7LwBybtk
         N0w80HuPlkRwg==
Subject: [PATCH 3/4] generic: test that linking into a directory fails with
 EDQUOT
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 11 Apr 2022 15:54:48 -0700
Message-ID: <164971768834.169983.11537125892654404197.stgit@magnolia>
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

Add a regression test to make sure that unprivileged userspace linking
into a directory fails with EDQUOT when the directory quota limits have
been exceeded.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/832     |   67 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/832.out |    3 ++
 2 files changed, 70 insertions(+)
 create mode 100755 tests/generic/832
 create mode 100644 tests/generic/832.out


diff --git a/tests/generic/832 b/tests/generic/832
new file mode 100755
index 00000000..1190b795
--- /dev/null
+++ b/tests/generic/832
@@ -0,0 +1,67 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 832
+#
+# Ensure that unprivileged userspace hits EDQUOT while linking files into a
+# directory when the directory's quota limits have been exceeded.
+#
+# Regression test for commit:
+#
+# 871b9316e7a7 ("xfs: reserve quota for dir expansion when linking/unlinking files")
+#
+. ./common/preamble
+_begin_fstest auto quick quota
+
+# Import common functions.
+. ./common/filter
+. ./common/quota
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_quota
+_require_user
+_require_scratch
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_qmount_option usrquota
+_qmount
+
+blocksize=$(_get_block_size $SCRATCH_MNT)
+scratchdir=$SCRATCH_MNT/dir
+scratchfile=$SCRATCH_MNT/file
+mkdir $scratchdir
+touch $scratchfile
+
+# Create a 2-block directory for our 1-block quota limit
+total_size=$((blocksize * 2))
+dirents=$((total_size / 255))
+
+for ((i = 0; i < dirents; i++)); do
+	name=$(printf "x%0254d" $i)
+	ln $scratchfile $scratchdir/$name
+done
+
+# Set a low quota hardlimit for an unprivileged uid and chown the files to it
+echo "set up quota" >> $seqres.full
+setquota -u $qa_user 0 "$((blocksize / 1024))" 0 0 $SCRATCH_MNT
+chown $qa_user $scratchdir $scratchfile
+repquota -upn $SCRATCH_MNT >> $seqres.full
+
+# Fail at appending the directory as qa_user to ensure quota enforcement works
+echo "fail quota" >> $seqres.full
+for ((i = 0; i < dirents; i++)); do
+	name=$(printf "y%0254d" $i)
+	su - "$qa_user" -c "ln $scratchfile $scratchdir/$name" 2>&1 | \
+		_filter_scratch | sed -e 's/y[0-9]*/yXXX/g'
+	test "${PIPESTATUS[0]}" -ne 0 && break
+done
+repquota -upn $SCRATCH_MNT >> $seqres.full
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/832.out b/tests/generic/832.out
new file mode 100644
index 00000000..593afe8b
--- /dev/null
+++ b/tests/generic/832.out
@@ -0,0 +1,3 @@
+QA output created by 832
+ln: failed to create hard link 'SCRATCH_MNT/dir/yXXX': Disk quota exceeded
+Silence is golden

