Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0499C07E9B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA106108B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381450AbhGTAbL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381041AbhGTA2J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:28:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF78E6113B;
        Tue, 20 Jul 2021 01:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743329;
        bh=LjQS5A/LDnGrwWQVSi1zpBbEHF7ZL70/KpjFdaK85/Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a8EyETAn6UK41hZ13VITloqZqg3w40UPyQIMVzJbhmkrXccgb+wUkjXztTJXCQXP3
         j4A79qZSuoQL6T79N1X9TwyHrNt3MNgx0La00IfTK2kjsS+PrTpkrw4gCcL949k/sf
         WhPzxa5dVEl4yifuFCpPrpaMy9yRhThNMixIvqFbuP5QJZ5pHnvIJvJgBycihUpVpz
         TpgHW5o1399/DRES6h9ddY9DF5a7bYZ9RzKbmKPNkz2k1wOqPM+bm/bVwxTMY4Ld3a
         NSTP3W7luuv5ea2NcyLPXVRf8H9KkDh40jxeckRQxDLiwNeVXPftguVAeS8FT2Q13V
         Qus4uf+d6pNmA==
Subject: [PATCH 1/2] generic: test xattr operations only
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 19 Jul 2021 18:08:48 -0700
Message-ID: <162674332866.2650898.16916837755915187962.stgit@magnolia>
In-Reply-To: <162674332320.2650898.17601790625049494810.stgit@magnolia>
References: <162674332320.2650898.17601790625049494810.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Exercise extended attribute operations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/724     |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/724.out |    2 ++
 2 files changed, 59 insertions(+)
 create mode 100755 tests/generic/724
 create mode 100644 tests/generic/724.out


diff --git a/tests/generic/724 b/tests/generic/724
new file mode 100755
index 00000000..f2f4a2ec
--- /dev/null
+++ b/tests/generic/724
@@ -0,0 +1,57 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 724
+#
+# Run an extended attributes fsstress run with multiple threads to shake out
+# bugs in the xattr code.
+#
+. ./common/preamble
+_begin_fstest auto attr
+
+_cleanup()
+{
+	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+	cd /
+	rm -f $tmp.*
+}
+
+# Modify as appropriate.
+_supported_fs generic
+
+_require_scratch
+_require_command "$KILLALL_PROG" "killall"
+
+echo "Silence is golden."
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+nr_cpus=$((LOAD_FACTOR * 4))
+nr_ops=$((700000 * nr_cpus * TIME_FACTOR))
+
+args=('-z' '-S' 'c')
+
+# Do some directory tree modifications, but the bulk of this is geared towards
+# exercising the xattr code, especially attr_set which can do up to 10k values.
+for verb in unlink rmdir; do
+	args+=('-f' "${verb}=1")
+done
+for verb in creat mkdir; do
+	args+=('-f' "${verb}=2")
+done
+for verb in getfattr listfattr; do
+	args+=('-f' "${verb}=3")
+done
+for verb in attr_remove removefattr; do
+	args+=('-f' "${verb}=4")
+done
+args+=('-f' "setfattr=20")
+args+=('-f' "attr_set=60")	# sets larger xattrs
+
+$FSSTRESS_PROG "${args[@]}" $FSSTRESS_AVOID -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/724.out b/tests/generic/724.out
new file mode 100644
index 00000000..164cfffb
--- /dev/null
+++ b/tests/generic/724.out
@@ -0,0 +1,2 @@
+QA output created by 724
+Silence is golden.

