Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75941FA3741
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 15:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiJ0PrT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 11:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiJ0PrT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 11:47:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075F51905E0;
        Thu, 27 Oct 2022 08:47:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD2CAB8268E;
        Thu, 27 Oct 2022 15:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37F9C433C1;
        Thu, 27 Oct 2022 15:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666885635;
        bh=6NlJ+cyzmw11eiV3Eqhy3vtSnstoU8/2x30UgmuGGRY=;
        h=From:To:Cc:Subject:Date:From;
        b=rzwGDLjSP2cTGobKulUvkQd/fmA5Hz4HQSnHQhebhhncN9oXSpSgXdmOjCK2+jvvz
         YvDNloKE1z/McbSaplQ8KeL6xA9d5XLLw04Jbu36MbnXPVU1UH+SjmKoPkcDZBpYru
         FEfRxvu6GXPYzwYxPMfnHkERuC6tdawwfLg1Fv0ggdiilDl2IVDdkPbtDeUquNml5h
         yu/Oc9ID/i4qxNE4bi0NVprIqLZWEEOn5n32EYuBFu0oZHo/4eyQVYiLEv98AzsaOM
         JZ9gQcXtTidl5/XK81+uc/wz7ojDEvWnIJu/n+GZJcbvVvpZ1+gKIjJOo1jMbPs0Rm
         k257KMJMlpt7Q==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: new test for randomly fail async buffer writes
Date:   Thu, 27 Oct 2022 23:47:11 +0800
Message-Id: <20221027154711.1458119-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make sure xfs can handle randomly fail async buffer writes, no crash
or hang.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

Hi,

In V1 patch[1], Darrick pointed out that it's not suit for covering e001873853d8
("xfs: ensure we capture IO errors correctly"). So I changed this case to be an
ordinary xfs buf_ioerror test. How about this method?

Thanks,
Zorro

[1]
https://lore.kernel.org/fstests/20221027022459.5ewhsm7gjq5iynra@zlang-mailbox/T/#m856a77c4bb5a61191afeb378b1178f1691ffb8f8

 tests/xfs/554     | 49 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/554.out |  4 ++++
 2 files changed, 53 insertions(+)
 create mode 100755 tests/xfs/554
 create mode 100644 tests/xfs/554.out

diff --git a/tests/xfs/554 b/tests/xfs/554
new file mode 100755
index 00000000..1135f4f3
--- /dev/null
+++ b/tests/xfs/554
@@ -0,0 +1,49 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 554
+#
+# Make sure xfs can handle randomly fail async buffer writes, no crash or hang.
+#
+. ./common/preamble
+_begin_fstest auto eio
+
+_cleanup()
+{
+	$KILLALL_PROG -q fsstress 2> /dev/null
+	# ensures all fsstress processes died
+	wait
+	cd /
+	rm -r -f $tmp.*
+}
+
+# Import common functions.
+. ./common/inject
+
+# real QA test starts here
+_supported_fs xfs
+_require_command "$KILLALL_PROG" "killall"
+_require_scratch
+_require_xfs_debug
+_require_xfs_io_error_injection "buf_ioerror"
+_require_aio
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+echo "Inject buf ioerror tag"
+_scratch_inject_error buf_ioerror
+
+echo "Random I/Os testing (aio sync and write mainly) ..."
+$FSSTRESS_PROG $FSSTRESS_AVOID -d $SCRATCH_MNT -n 10000 -p 100 \
+	-f creat=1000 -f afsync=1000 -f awrite=3000 -l 0 >> $seqres.full 2>&1 &
+for ((i=0; i < 6 * TIME_FACTOR; i++));do
+	echo 3 > /proc/sys/vm/drop_caches
+	sleep 10
+done
+
+echo "No hang or panic"
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/554.out b/tests/xfs/554.out
new file mode 100644
index 00000000..99eca3f0
--- /dev/null
+++ b/tests/xfs/554.out
@@ -0,0 +1,4 @@
+QA output created by 554
+Inject buf ioerror tag
+Random I/Os testing (aio sync and write mainly) ...
+No hang or panic
-- 
2.31.1

