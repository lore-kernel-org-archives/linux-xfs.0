Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F845C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235989AbiLaAyB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:54:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3B413F29;
        Fri, 30 Dec 2022 16:54:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26FC761D47;
        Sat, 31 Dec 2022 00:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EDFC433D2;
        Sat, 31 Dec 2022 00:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448039;
        bh=XuVZSW7YgBTOYzzPqFdIvgtWFwDaAnnaY9FXGch19s0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e9GJEZxTixVAiZFOgBaLs/xwyPGj/iK1dYuRvqWR7Vq6kltDt4b8zjDwC9/I+GPK3
         /8IBo8xu4ng6SKGTGvgz4BQVa8zUAv6tSrmAPz0e4pYUA8kwXSltnodVApjGfk35Hr
         +Bg11Ppf7tE9Tv7+wc4bUUsHH0mha2zMal1ZH85Tvyk/402t7cQVFTnL0ALHJOEmSx
         M6syueT96MM8MJfYrOuYGXI8kgd78pHZ9Feq5wjMYHNZdpRj5gy5PKFhj3K6MS1TFN
         3Wd3tbeXFH/xV6QVkF41NCxfNacQdHkEkDXFR4FmVGq/jnBoKsIJdH+2nQ6CsHVuDW
         FL5AOc91fMUiw==
Subject: [PATCH 1/1] xfs: race fsstress with online repair of extended
 attribute data
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:55 -0800
Message-ID: <167243879499.732747.14090877331985296702.stgit@magnolia>
In-Reply-To: <167243879487.732747.6068603679875314716.stgit@magnolia>
References: <167243879487.732747.6068603679875314716.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create tests to race fsstress with extended attribute repair while
running fsstress in the background.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/814     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/814.out |    2 ++
 2 files changed, 42 insertions(+)
 create mode 100755 tests/xfs/814
 create mode 100644 tests/xfs/814.out


diff --git a/tests/xfs/814 b/tests/xfs/814
new file mode 100755
index 0000000000..96abb13691
--- /dev/null
+++ b/tests/xfs/814
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 814
+#
+# Race fsstress and extended attributes repair for a while to see if we crash
+# or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+. ./common/attr
+
+# real QA test starts here
+_supported_fs xfs
+_require_attrs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -x 'xattr' -s "repair xattr" -t "%attrfile%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/814.out b/tests/xfs/814.out
new file mode 100644
index 0000000000..95532d3da7
--- /dev/null
+++ b/tests/xfs/814.out
@@ -0,0 +1,2 @@
+QA output created by 814
+Silence is golden

