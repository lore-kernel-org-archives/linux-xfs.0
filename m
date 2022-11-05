Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8805C43217
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Nov 2022 15:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiKEPXe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Nov 2022 11:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiKEPXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Nov 2022 11:23:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FC32099A;
        Sat,  5 Nov 2022 08:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 90BABCE0256;
        Sat,  5 Nov 2022 15:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5D9C433D6;
        Sat,  5 Nov 2022 15:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667661808;
        bh=SBjIQDR2kre6tWcS4uNbVhEnUvGzhUoD756BixwWSWk=;
        h=From:To:Cc:Subject:Date:From;
        b=WSqFzG3EPc4EkwUS63qP/mpLM9la8J7Sl4P+fUieH/9OVHJORmwWohkxQ4Xzn5oar
         KJIE9FoBl47CacwBdfceJrmQF0aPaksnuaz5LL+nU0vjDnU7PzH+/NNM1UOEBw03SE
         ktceehxW3t8hHBKr+jiEfyYxSqdCJImLUKRmt7a1u74zS6xpZTSrYUJaM3FrJokcQ2
         qj5rvO3Z8TraE0CoPdLA1YNFAieNdzF4U5rSSB7/CUSx/7O+E1FVvrT/fLANvaHon5
         amU/ForB61s2KEvxzDRKt+CYYC2/LIlaZ+ZeSaju14MjPoIljp64prpdu6S21A80b/
         noBbBnZ4Klriw==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] generic: shutdown might leave NULL files with nonzero di_size
Date:   Sat,  5 Nov 2022 23:23:24 +0800
Message-Id: <20221105152324.2233310-1-zlang@kernel.org>
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

V2 replace "fiemap" with "stat" command, to check if a file has extents.
That helps this case more common.

Thanks,
Zorro

 tests/generic/999     | 42 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  5 +++++
 2 files changed, 47 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..8b4596e0
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,42 @@
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
+_begin_fstest auto quick shutdown
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_scratch_shutdown
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
+	if [ "$(stat -c "%b" $f)" = "0" ];then
+		echo " - $f get no extents, but its di_size > 0"
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

