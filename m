Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FC1C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 05:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiCAFAk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 00:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiCAFAh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 00:00:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57C6240A2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 20:59:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 946EFB81709
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 04:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36136C340EE
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 04:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646110790;
        bh=nFTcd6a/oH0oOQQhKJhtohXCGQM7yje5LH5R4Q6lnRM=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=myMZTqlkJTqGKtzS9YSr/Aqa5CN8LbyZKTQBQzLLXXxGj9oN7C1lBtWAbt5ATqQyB
         8MY0V9Kg77i654jlfdSeEZdmKKrdD3ERG9t96TQ7j1lEHFkeGTBn7n+Nyx7TadeX5W
         C2D8T4FmGJIVZxutr+YGLenBYTLVsw1IoGcJPFamAu8RpjtpD5ezjALHbEuABDT04B
         TsYWAN+X2BpZWDLV7gW9W3t/aGTmP2c8CAS7Y4SIS1skYKE5qMHbHGLEyBuj1vEbYW
         hT5MibUTSQCTgMAZC8OQMnrzKiT0kWj/M7N7f0tnjW55YwSHs2GUenzIETpvLmzJ3q
         VICanypRNpW+Q==
Date:   Mon, 28 Feb 2022 20:59:49 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] generic: test that linking into a directory fails with EDQUOT
Message-ID: <20220301045949.GH117732@magnolia>
References: <20220301025118.GG117732@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301025118.GG117732@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a regression test to make sure that unprivileged userspace linking
into a directory fails with EDQUOT when the directory quota limits have
been exceeded.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/732     |   67 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/732.out |    3 ++
 2 files changed, 70 insertions(+)
 create mode 100755 tests/generic/732
 create mode 100644 tests/generic/732.out

diff --git a/tests/generic/732 b/tests/generic/732
new file mode 100755
index 00000000..c4a3dcb6
--- /dev/null
+++ b/tests/generic/732
@@ -0,0 +1,67 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 732
+#
+# Ensure that unprivileged userspace hits EDQUOT while linking files into a
+# directory when the directory's quota limits have been exceeded.
+#
+# Regression test for commit:
+#
+# XXXXXXXXXXXX ("xfs: reserve quota for directory expansion when hardlinking files")
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
diff --git a/tests/generic/732.out b/tests/generic/732.out
new file mode 100644
index 00000000..15d2cb61
--- /dev/null
+++ b/tests/generic/732.out
@@ -0,0 +1,3 @@
+QA output created by 732
+ln: failed to create hard link 'SCRATCH_MNT/dir/yXXX': Disk quota exceeded
+Silence is golden
