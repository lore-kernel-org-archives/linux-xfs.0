Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF57C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 13:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiKINHy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Nov 2022 08:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiKINHw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2022 08:07:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AB8C35;
        Wed,  9 Nov 2022 05:07:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 986CA61A0D;
        Wed,  9 Nov 2022 13:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38603C433C1;
        Wed,  9 Nov 2022 13:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667999270;
        bh=v7HI9f/Y/UglMvT4d+sTDM2kcepv7L9axaYnTyifsgE=;
        h=From:To:Cc:Subject:Date:From;
        b=XOMGP5GHeimkereeoUFxJA+3UWJyvPIP2FvpB2qQzxDCWSUMSexGku/LLeHF/zEdM
         sGP0+BmABRzTVNndm4jCNXznkBNzUkLkXCLQ34s1MG8vpbaaiPK4++kPLNYhhYaC2K
         0ohggI6rC+QwjwLJJMpD2OUhs5+SHHv5BUrJqDtqYxJhIKVtXEu12pM27rwjS041QD
         sJkPKBfgHHOdEjdRWnfFK5+k5rWScIK/Foo+m+i4BIlDM6UAKBXfc7VihFrkhzxyte
         3tPNfxZo5j3CBGQcZgpbzzsWG30nx35haB4Wgn+7GG0K+VWG7xma+w6m9wpleMtjsS
         u+aO3WNyUJfwg==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3] generic: shutdown might leave NULL files with nonzero di_size
Date:   Wed,  9 Nov 2022 21:07:46 +0800
Message-Id: <20221109130746.3669020-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

An old issue might cause on-disk inode sizes are logged prematurely
via the free eofblocks path on file close. Then fs shutdown might
leave NULL files but their di_size > 0.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

Hi,

V2 replace xfs_io fiemap command with stat command.
V3 replace the stat with the filefrag command, and change the supported_fs
from xfs to generic.

Thanks,
Zorro

 tests/generic/999     | 46 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  5 +++++
 2 files changed, 51 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..ca666de7
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,46 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 999
+#
+# Test an issue in the truncate codepath where on-disk inode sizes are logged
+# prematurely via the free eofblocks path on file close.
+#
+. ./common/preamble
+_begin_fstest auto shutdown
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch
+_require_scratch_shutdown
+_require_command "$FILEFRAG_PROG" filefrag
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount
+
+echo "Create many small files with one extent at least"
+for ((i=0; i<10000; i++));do
+	$XFS_IO_PROG -f -c "pwrite 0 4k" $SCRATCH_MNT/file.$i >/dev/null 2>&1
+done
+
+echo "Shutdown the fs suddently"
+_scratch_shutdown
+
+echo "Cycle mount"
+_scratch_cycle_mount
+
+echo "Check file's (di_size > 0) extents"
+for f in $(find $SCRATCH_MNT -type f -size +0);do
+	# Check if the file has any extent
+	$FILEFRAG_PROG -v $f > $tmp.filefrag
+	grep -Eq ': 0 extents found' $tmp.filefrag
+	if [ $? -eq 0 ];then
+		echo " - $f get no extents, but its di_size > 0"
+		cat $tmp.filefrag
+		break
+	fi
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..50008783
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,5 @@
+QA output created by 999
+Create many small files with one extent at least
+Shutdown the fs suddently
+Cycle mount
+Check file's (di_size > 0) extents
-- 
2.31.1

