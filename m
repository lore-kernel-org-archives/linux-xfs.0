Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067BBC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 16:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiJZQ55 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 12:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbiJZQ5z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 12:57:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4586F925AC;
        Wed, 26 Oct 2022 09:57:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F227AB82397;
        Wed, 26 Oct 2022 16:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB87C433D6;
        Wed, 26 Oct 2022 16:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666803470;
        bh=dFJuz1FugrZGTqnATzSGk4wTU+SpCE4g0hBxihc28QI=;
        h=From:To:Cc:Subject:Date:From;
        b=FuQxGgetYyBuq6r+choAAjUpYj7lacRJonXALJUGkfZYNTApwOdjxC3W6VwXg7W6Z
         GE90qwZ/KnxBD2rG3M6gQhUT65WNQPEcYF0Wx1fxYADn40yYj8bCXqBpYGJPQUcIwk
         7A/dUlTsSig1tn2fSqM+uRYor519BHWO4Y9dOkY5Q2XMyfDz5ZpiBhoWprSBrolXEd
         BjIn+gt3n+yqjt0YuI3qPYF2FDEMnNei7mSlfyq5Y8+cRSg0KaKnxBURrnk6WOeOiE
         CNC0CC7RJgg031QkAvUGec71Ih7HnepTH/y8aoHniUJqTw03rnnJi+kfhoabzJPdFG
         Hp5Y6vcTKhjMg==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: new test to ensure xfs can capture IO errors correctly
Date:   Thu, 27 Oct 2022 00:57:47 +0800
Message-Id: <20221026165747.1146281-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There was a known xfs crash bug fixed by e001873853d8 ("xfs: ensure
we capture IO errors correctly"), so trys to cover this bug and make
sure xfs can capture IO errors correctly, won't panic and hang again.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

When I tried to tidy up our internal test cases recently, I found a very
old case which trys to cover e001873853d8 ("xfs: ensure we capture IO errors
correctly") which fix by Dave. At that time, we didn't support xfs injection,
so we tested it by a systemtap script [1] to inject an ioerror.

Now this bug has been fixed long long time ago (9+ years), and that stap script
is already out of date, can't work with new kernel. But good news is we have xfs
injection now, so I try to resume this test case in fstests.

I didn't verify if this case can reproduce that bug on old rhel (which doesn't
support error injection). The original case tried to inject errno 11, I'm
not sure if it's worth trying more other errors. I searched "buf_ioerror" in
fstests, found nothing. So maybe this bug is old enough, but it's worth covering
this kind of test. So feel free to tell me if you have any suggestions :)

Thanks,
Zorro

[1]
probe module("xfs").function("xfs_buf_bio_end_io")
{
        if ($error == 0) {
                if ($bio->bi_rw & (1 << 4)) {
                        $error = -11;
                        printf("%s: comm %s, pid %d, setting error 11\n",
                                probefunc(), execname(), pid());
                        print_stack(backtrace());
                }
        }
}

 tests/xfs/554     | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/554.out |  4 ++++
 2 files changed, 57 insertions(+)
 create mode 100755 tests/xfs/554
 create mode 100644 tests/xfs/554.out

diff --git a/tests/xfs/554 b/tests/xfs/554
new file mode 100755
index 00000000..6935bfc0
--- /dev/null
+++ b/tests/xfs/554
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 YOUR NAME HERE.  All Rights Reserved.
+#
+# FS QA Test 554
+#
+# There was a known xfs crash bug fixed by e001873853d8 ("xfs: ensure we
+# capture IO errors correctly"), so trys to cover this bug and make sure
+# xfs can capture IO errors correctly, won't panic and hang again.
+#
+. ./common/preamble
+_begin_fstest auto eio
+
+_cleanup()
+{
+	$KILLALL_PROG -q fsstress 2> /dev/null
+	# ensures all fsstress processes died
+	wait
+	# log replay, due to the buf_ioerror injection might leave dirty log
+	_scratch_cycle_mount
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
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+echo "Inject buf ioerror tag"
+_scratch_inject_error buf_ioerror 11
+
+echo "Random I/Os testing ..."
+$FSSTRESS_PROG $FSSTRESS_AVOID -d $SCRATCH_MNT -n 50000 -p 100 >> $seqres.full &
+for ((i=0; i<5; i++));do
+	# Clear caches, then trys to use 'find' to trigger readahead
+	echo 3 > /proc/sys/vm/drop_caches
+	find $SCRATCH_MNT >/dev/null 2>&1
+	sleep 3
+done
+
+echo "No hang or panic"
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/554.out b/tests/xfs/554.out
new file mode 100644
index 00000000..26910daa
--- /dev/null
+++ b/tests/xfs/554.out
@@ -0,0 +1,4 @@
+QA output created by 554
+Inject buf ioerror tag
+Random I/Os testing ...
+No hang or panic
-- 
2.31.1

