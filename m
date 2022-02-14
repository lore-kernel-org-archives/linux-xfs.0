Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70ADC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Feb 2022 20:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiBNUov (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Feb 2022 15:44:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBNUou (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Feb 2022 15:44:50 -0500
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0658C1B71A4;
        Mon, 14 Feb 2022 12:41:18 -0800 (PST)
Received: by mail-qv1-f44.google.com with SMTP id x3so10091605qvd.8;
        Mon, 14 Feb 2022 12:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=poESblMRxcTsDtJ7xmd6lrj5VQOy41yVZyPnVKCR6is=;
        b=am9Jfh3XpTDz3XiOw12LnJ6dqwAEesSaY44CpZsRqBF7Z0PNRkZ1tdfilFDQ0Z/XE6
         ejeXtALQPR6FDcD4fO/BRoPWhi4O1CK6Gwu18dugI/I7aAgcvsO8f1xiLL1J33KYPH9+
         JjZE/1lhp0g26lD8gW8x2wztjUU0KoWo/X/PUYAe9e+cQ3eOuq0WxGQybr5awHWtvi4/
         CSuY+g+VmDI4AJaXDPFmymDW8f/XZc9Xm3frMs9kKRoWxFeufMcgwNaHmKmHXY3XRMKK
         QD93JU7nhvN3FA3Dx4EucHjdx7NJXXCz3RHbdg+32l2srJVhNptMDaDbVsCxIa4e551S
         ATyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=poESblMRxcTsDtJ7xmd6lrj5VQOy41yVZyPnVKCR6is=;
        b=Z548xgffDwDkLPCHXVNBK3fPgWvDGS96lyAoLQSSQcxjvgMKs7H40ADP/dt5NA2AMX
         4AKOtOTY+ApzahfGIlWoaQdwJt10IfdC/CDtlX8qcKObdKjWYCZ7oORhSLqtTkyh3mzM
         2uC/w+8NkOqaNzgXpXqJIr7aUJmYpi/usL310bW3afOE729sPK/rjoOoCWXC0s6Q4N49
         igXyWhXIdTlEfzAxEkiDZzeztNTvGYI4XAIijBbPwpaztRG5FAdLY4eG236WDVtDJFPK
         vB9Q6jQY25Nt4wQJngqvRjhyY5Yi3qU0SsrzZaRuX6Up4y1kzl4tXaok5zEmqXh6+/BS
         F6yw==
X-Gm-Message-State: AOAM531+8kMbMhHpUxbTy/fdBp1ZM0Dmo6XgvgqjVfEEgAVCAjMuwuCu
        aHzyPZOrxePBhRA45zccuyEtShNf5w==
X-Google-Smtp-Source: ABdhPJxGOdbwVGIKAljx1gKbSFuxPWOHdqtjxk2OUIF1Oeg/NqZlRzMErd0/S5MMfBSXpOf0/IqoOw==
X-Received: by 2002:a05:6214:e65:: with SMTP id jz5mr339889qvb.89.1644870919477;
        Mon, 14 Feb 2022 12:35:19 -0800 (PST)
Received: from localhost (209-6-122-159.s2973.c3-0.arl-cbr1.sbo-arl.ma.cable.rcncustomer.com. [209.6.122.159])
        by smtp.gmail.com with UTF8SMTPSA id d11sm18314150qtd.63.2022.02.14.12.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 12:35:19 -0800 (PST)
From:   Masayoshi Mizuma <msys.mizuma@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Masayoshi Mizuma <msys.mizuma@gmail.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: test xfsdump with bind-mounted filesystem
Date:   Mon, 14 Feb 2022 15:34:09 -0500
Message-Id: <20220214203409.10309-1-msys.mizuma@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

commit 25195eb ("xfsdump: handle bind mount target") introduced
a bug of xfsdump which doesn't store the files to the dump file
correctly when the root inode number is changed.

The commit 25195eb is reverted, and commit 0717c1c ("xfsdump: intercept
bind mount targets") which is in xfsdump v3.1.10 fixes the bug to reject
the filesystem if it's bind-mounted.

Test that xfsdump can reject the bind-mounted filesystem.

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 tests/xfs/544     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/544.out |  2 ++
 2 files changed, 65 insertions(+)
 create mode 100755 tests/xfs/544
 create mode 100644 tests/xfs/544.out

diff --git a/tests/xfs/544 b/tests/xfs/544
new file mode 100755
index 00000000..1d586ebc
--- /dev/null
+++ b/tests/xfs/544
@@ -0,0 +1,63 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Fujitsu Limited. All Rights Reserved.
+#
+# FS QA Test 544
+#
+# Regression test for commit:
+# 0717c1c ("xfsdump: intercept bind mount targets")
+
+. ./common/preamble
+_begin_fstest auto dump
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -r -f $tmp.*
+	$UMOUNT_PROG $mntpnt2 2> /dev/null
+	rmdir $mntpnt1/dir 2> /dev/null
+	$UMOUNT_PROG $mntpnt1 2> /dev/null
+	rmdir $mntpnt2 2> /dev/null
+	rmdir $mntpnt1 2> /dev/null
+	[ -n "$loopdev" ] && _destroy_loop_device $loopdev
+	rm -f "$TEST_DIR"/fsfile
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/dump
+
+# real QA test starts here
+
+_supported_fs xfs
+
+mntpnt1=$TEST_DIR/MNT1
+mntpnt2=$TEST_DIR/MNT2
+
+
+# Set up
+$MKFS_XFS_PROG -s size=4096 -b size=4096 \
+	-dfile,name=$TEST_DIR/fsfile,size=8649728b,sunit=1024,swidth=2048 \
+	>> $seqres.full 2>&1 || _fail "mkfs failed"
+
+loopdev=$(_create_loop_device "$TEST_DIR"/fsfile)
+
+mkdir $mntpnt1 >> $seqres.full 2>&1 || _fail "mkdir \"$mntpnt1\" failed"
+
+_mount $loopdev $mntpnt1
+mkdir $mntpnt1/dir >> $seqres.full 2>&1 || _fail "mkdir \"$mntpnt1/dir\" failed"
+mkdir $mntpnt2 >> $seqres.full 2>&1 || _fail "mkdir \"$mntpnt2\" failed"
+
+
+# Test
+echo "*** dump with bind-mounted test ***" >> $seqres.full
+
+mount -o bind $mntpnt1/dir $mntpnt2
+
+$XFSDUMP_PROG -L session -M test -f $tmp.dump $mntpnt2 \
+	>> $seqres.full 2>&1 && echo "dump with bind-mounted should be failed, but passed."
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/544.out b/tests/xfs/544.out
new file mode 100644
index 00000000..fc7ebff3
--- /dev/null
+++ b/tests/xfs/544.out
@@ -0,0 +1,2 @@
+QA output created by 544
+Silence is golden
-- 
2.31.1

