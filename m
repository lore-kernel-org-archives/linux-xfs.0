Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FE9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbiLaAyR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAyQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:54:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2144613F29;
        Fri, 30 Dec 2022 16:54:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B382A61D51;
        Sat, 31 Dec 2022 00:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180A2C433EF;
        Sat, 31 Dec 2022 00:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448055;
        bh=p9MYa6m7WHFvsYwhRGesBN5zSr3aGrlMGuiTQ2+wqMQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SSuIUawxFNJnhM99qiHaDASkz5dWRH6ZIqgp6GQ0aTuLbILHbHjuTY9iah3fzGJcr
         p3gysxj1QN4SfpL+IPixw28gIT7LPuSk6hF0i/GcxlN7xOwkWeYj4gs57pilCWdeJH
         ml9wAqv3zj5rl1zjXElQJRFIZhCyY6om73znbJB/oZdqqQ/mttX6B0oMDlOHtGcxfO
         ieujlTrxEh6wZDSM509IwZ+ez4naUbn6K7rhOnZ1s9wReN6O1d9mOsuKyYH1MH0QB+
         11AAxGtKvEAY7xGeg3W6aALFiRdDZI0ocCNCKnLkQyoUyyGndvfTh/bhHsQ5IoZivi
         SZfhzqu/PK10w==
Subject: [PATCH 1/2] xfs: ensure that online directory repairs don't hit
 EDQUOT
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:57 -0800
Message-ID: <167243879793.733381.10737467373374867150.stgit@magnolia>
In-Reply-To: <167243879781.733381.1441585366549762189.stgit@magnolia>
References: <167243879781.733381.1441585366549762189.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a test to ensure that the sysadmin doesn't get EDQUOT if they try to
repair directory metadata when we've already exceeded a quota limit
somewhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/841     |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/841.out |    3 ++
 2 files changed, 80 insertions(+)
 create mode 100755 tests/xfs/841
 create mode 100644 tests/xfs/841.out


diff --git a/tests/xfs/841 b/tests/xfs/841
new file mode 100755
index 0000000000..f743454971
--- /dev/null
+++ b/tests/xfs/841
@@ -0,0 +1,77 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 841
+#
+# Ensure that the sysadmin won't hit EDQUOT while repairing file data contents
+# even if the file's quota limits have been exceeded.  This tests the quota
+# reservation handling inside the swapext code used by repair.
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
+_require_quota
+_require_user
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_qmount_option usrquota
+_qmount
+
+blocksize=$(_get_block_size $SCRATCH_MNT)
+alloc_unit=$(_xfs_get_dir_blocksize $SCRATCH_MNT)
+
+# Make sure we can actually repair a directory
+scratchdir=$SCRATCH_MNT/dir
+scratchfile=$SCRATCH_MNT/file
+mkdir $scratchdir
+touch $scratchfile
+$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
+__stress_scrub_check_commands "$scratchdir" "" 'repair directory'
+
+# Create a 2-dirblock directory
+total_size=$((alloc_unit * 2))
+dirents=$((total_size / 255))
+
+for ((i = 0; i < dirents; i++)); do
+	name=$(printf "x%0254d" $i)
+	ln $scratchfile $scratchdir/$name
+done
+
+# Set a low quota hardlimit for an unprivileged uid and chown the files to it
+echo "set up quota" >> $seqres.full
+$XFS_QUOTA_PROG -x -c "limit -u bhard=$alloc_unit $qa_user" $SCRATCH_MNT
+chown $qa_user $scratchdir $scratchfile
+$XFS_QUOTA_PROG -x -c 'report -u' $SCRATCH_MNT >> $seqres.full
+
+# Rebuild the directory
+echo "repairs" >> $seqres.full
+$XFS_IO_PROG -x -c 'inject force_repair' -c 'repair directory' $scratchdir
+$XFS_QUOTA_PROG -x -c 'report -u' $SCRATCH_MNT >> $seqres.full
+
+# Fail at appending the directory as qa_user to ensure quota enforcement works
+echo "fail quota" >> $seqres.full
+for ((i = 0; i < dirents; i++)); do
+	name=$(printf "y%0254d" $i)
+	su - "$qa_user" -c "ln $scratchfile $scratchdir/$name" 2>&1 | \
+		_filter_scratch | sed -e 's/y[0-9]*/yXXX/g'
+	test "${PIPESTATUS[0]}" -ne 0 && break
+done
+$XFS_QUOTA_PROG -x -c 'report -u' $SCRATCH_MNT >> $seqres.full
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/841.out b/tests/xfs/841.out
new file mode 100644
index 0000000000..e8e169111a
--- /dev/null
+++ b/tests/xfs/841.out
@@ -0,0 +1,3 @@
+QA output created by 841
+ln: failed to create hard link 'SCRATCH_MNT/dir/yXXX': Disk quota exceeded
+Silence is golden

