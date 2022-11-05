Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5B0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Nov 2022 03:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiKEDXg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 23:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKEDXf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 23:23:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560B82BB3D;
        Fri,  4 Nov 2022 20:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5E5A6239C;
        Sat,  5 Nov 2022 03:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB47C433C1;
        Sat,  5 Nov 2022 03:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667618613;
        bh=iFTyhbCLwJZ86uIddXIjd1QI6r33HE0t/l4RhpPte4s=;
        h=From:To:Cc:Subject:Date:From;
        b=ZEKrGfzkzsL33SDDGy4SPC34Z/J/aeq27pABFnRUO2oNheYcZOsgnByVm+WbZtohG
         aIGIryCdyF4P6ucQHLiJxwhc+154p/7XBeQOYjBwvYFqn0LRwPGE6z78lnbHpP8J5F
         BH6sXODxAJ1XWY1mge0Id+hSM+kjApXpYLVmyekn+wgvJ8KX7I4sooJntWvRj+bBip
         ZwaHdUyFh/kWvr4oLLvhe5ZaTRhGuwQp6k2/XYtFtc0NHUsF6Rn2/IgkYRtZuZm/4n
         gX/KEN6iCPE6QCRsjO8lbQJ8t6hK11oPeLDSU0zc+RoOe0qEcRmvjlgkER8V+i5OJo
         sFdCmjDrZx56g==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] nfs: test files written size as expected
Date:   Sat,  5 Nov 2022 11:23:29 +0800
Message-Id: <20221105032329.2067299-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Test nfs and its underlying fs, make sure file size as expected
after writting a file, and the speculative allocation space can
be shrunken.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

Hi,

The original bug reproducer is:
1. mount nfs3 backed by xfs
2. dd if=/dev/zero of=/nfs/10M bs=1M count=10
3. du -sh /nfs/10M                           
16M	/nfs/10M 

As this was a xfs issue, so cc linux-xfs@ to get review.

Thanks,
Zorro

 tests/nfs/002     | 43 +++++++++++++++++++++++++++++++++++++++++++
 tests/nfs/002.out |  2 ++
 2 files changed, 45 insertions(+)
 create mode 100755 tests/nfs/002
 create mode 100644 tests/nfs/002.out

diff --git a/tests/nfs/002 b/tests/nfs/002
new file mode 100755
index 00000000..3d29958d
--- /dev/null
+++ b/tests/nfs/002
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 002
+#
+# Make sure nfs gets expected file size after writting a big sized file. It's
+# not only testing nfs, test its underlying fs too. For example a known old bug
+# on xfs (underlying fs) caused nfs get larger file size (e.g. 16M) after
+# writting 10M data to a file. It's fixed by a series of patches around
+# 579b62faa5fb16 ("xfs: add background scanning to clear eofblocks inodes")
+#
+. ./common/preamble
+_begin_fstest auto rw
+
+# real QA test starts here
+_supported_fs nfs
+_require_test
+
+localfile=$TEST_DIR/testfile.$seq
+rm -rf $localfile
+
+$XFS_IO_PROG -f -t -c "pwrite 0 10m" -c "fsync" $localfile >>$seqres.full 2>&1
+block_size=`stat -c '%B' $localfile`
+iblocks_expected=$((10 * 1024 * 1024 / $block_size))
+# Try several times for the speculative allocated file size can be shrunken
+res=1
+for ((i=0; i<10; i++));do
+	iblocks_real=`stat -c '%b' $localfile`
+	if [ "$iblocks_expected" = "$iblocks_real" ];then
+		res=0
+		break
+	fi
+	sleep 10
+done
+if [ $res -ne 0 ];then
+	echo "Write $iblocks_expected blocks, but get $iblocks_real blocks"
+fi
+
+echo "Silence is golden"
+# success, all done
+status=0
+exit
diff --git a/tests/nfs/002.out b/tests/nfs/002.out
new file mode 100644
index 00000000..61705c7c
--- /dev/null
+++ b/tests/nfs/002.out
@@ -0,0 +1,2 @@
+QA output created by 002
+Silence is golden
-- 
2.31.1

