Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52488C432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 20:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C11B206DF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 20:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="qXGmNuYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLCUZH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 15:25:07 -0500
Received: from mail-pg1-f173.google.com ([209.85.215.173]:41952 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfLCUZH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 15:25:07 -0500
Received: by mail-pg1-f173.google.com with SMTP id x8so2152661pgk.8
        for <linux-xfs@vger.kernel.org>; Tue, 03 Dec 2019 12:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zU0wZHKsx5ga7fOIBKacf823fT/CeCSavAF46XrTSxI=;
        b=qXGmNuYtLmAXc/DPKNwsI3eCGPgOepnZ+hpZDSMxuLwSMyCurQ0VrZ7T4xSOVXaxhK
         UP+IeF1M1psYKF6ODUPkYAs4ViUWjZGq9QzabpjdnPlOszt71bzNHOYehq5MVA6REDqC
         09gpnrBCyqpv1F8gkmvO3XaDD3UQtkqii71ufow78C477R2ezMQkST5DXfP6vZ+CFpkN
         rWbLWGXS5pyHW9bTdZ/+SUrrJikGsWvZpBK0/setPFkgVtJhAlKQTjw7FhhxGFTnWfBK
         AQCrQqQpHrXFqS5kJqlyQzPnF9LKCK/Ms7Z56WHbDmCom5T1ME6fSA9Mcs3LmF+DansV
         rYpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zU0wZHKsx5ga7fOIBKacf823fT/CeCSavAF46XrTSxI=;
        b=X/WA92HmGLZoDtP9p0P+BZcnWPRGBpPjv/7RgOpDZL+Xcek+XJmWtI9fb2wS5OgEVN
         /Yyklm/SYI/a1tViWesDMiNEWBvkLlzp79S1A6mPY1eyAa0lwDXigz+/lIC6ehXBmRob
         FCq3OYSyXYvvNct6xCElNXUXGthDuWN0gkMDHQiPwtxy9zVq3aZFclQHQVXNEhAc8wCB
         hKbc0FmsryRTukUibdzd8iKyjWcc0WZs4pwjQ+1QCaSIjRZShVigZdpumzBckgDZyPFd
         GfsdrGTOSlzRtzF5A8IaW8DMy+DVUtm/cN326rqttD64q82Oc1rFbxT6apoF3M1gY0I0
         Fa4Q==
X-Gm-Message-State: APjAAAX506WskMhjCjhROJswisxUn5w0LV2NDWY3+DFQQrpMYb9eNoaM
        5/KK7IwFuE2MWl2tZp8zeA3YsNGGnCvf8Q==
X-Google-Smtp-Source: APXvYqyZCDtvQuSUqr4zpdT3o2iDpSQrsNe1iZQ13X9tTktoW1Dkeg4RsDdeeWaC5je/KAB4iPU44A==
X-Received: by 2002:a62:4e03:: with SMTP id c3mr6877063pfb.114.1575404706040;
        Tue, 03 Dec 2019 12:25:06 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:200::3:c979])
        by smtp.gmail.com with ESMTPSA id i9sm1091104pfd.166.2019.12.03.12.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 12:25:05 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     fstests@vger.kernel.org
Cc:     kernel-team@fb.com, linux-xfs@vger.kernel.org
Subject: [PATCH v2] generic: test truncating mixed written/unwritten XFS realtime extent
Date:   Tue,  3 Dec 2019 12:25:01 -0800
Message-Id: <d1c820e50399a16f968b5e0dd32b21234568b163.1575404627.git.osandov@fb.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

The only XFS-specific part of this test is the setup, so we can make the
rest a generic test. It's slow, though, as it needs to write 8GB to
convert a big unwritten extent to written.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Changes from v1:

- If rtdev is not configured, fall back to loop device on test
  filesystem
- Use XFS_IO_PROG instead of fallocate/sync/dd
- Use truncate instead of rm
- Add comments explaining the steps

 tests/generic/589     | 102 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/589.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 105 insertions(+)
 create mode 100755 tests/generic/589
 create mode 100644 tests/generic/589.out

diff --git a/tests/generic/589 b/tests/generic/589
new file mode 100755
index 00000000..3ca1d100
--- /dev/null
+++ b/tests/generic/589
@@ -0,0 +1,102 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Facebook.  All Rights Reserved.
+#
+# FS QA Test 589
+#
+# Test "xfs: fix realtime file data space leak" and "xfs: don't check for AG
+# deadlock for realtime files in bunmapi". On XFS without the fix, truncate
+# will hang forever. On other filesystems, this just tests writing into big
+# fallocates.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	if [[ -n $loop ]]; then
+		losetup -d "$loop" > /dev/null 2>&1
+	fi
+	rm -f "$TEST_DIR/$seq"
+}
+
+. ./common/rc
+. ./common/filter
+
+rm -f $seqres.full
+
+_supported_fs generic
+_supported_os Linux
+_require_scratch_nocheck
+
+maxextlen=$((0x1fffff))
+bs=4096
+rextsize=4
+filesz=$(((maxextlen + 1) * bs))
+
+extra_options=""
+# If we're testing XFS, set up the realtime device to reproduce the bug.
+if [[ $FSTYP = xfs ]]; then
+	# If we don't have a realtime device, set up a loop device on the test
+	# filesystem.
+	if [[ $USE_EXTERNAL != yes || -z $SCRATCH_RTDEV ]]; then
+		_require_test
+		loopsz="$((filesz + (1 << 26)))"
+		_require_fs_space "$TEST_DIR" $((loopsz / 1024))
+		$XFS_IO_PROG -c "truncate $loopsz" -f "$TEST_DIR/$seq"
+		loop="$(losetup -f --show "$TEST_DIR/$seq")"
+		USE_EXTERNAL=yes
+		SCRATCH_RTDEV="$loop"
+	fi
+	extra_options="$extra_options -bsize=$bs"
+	extra_options="$extra_options -r extsize=$((bs * rextsize))"
+	extra_options="$extra_options -d agsize=$(((maxextlen + 1) * bs / 2)),rtinherit=1"
+fi
+_scratch_mkfs $extra_options >>$seqres.full 2>&1
+_scratch_mount
+_require_fs_space "$SCRATCH_MNT" $((filesz / 1024))
+
+# Allocate maxextlen + 1 blocks. As long as the allocator does something sane,
+# we should end up with two extents that look something like:
+#
+# u3.bmx[0-1] = [startoff,startblock,blockcount,extentflag]
+# 0:[0,0,2097148,1]
+# 1:[2097148,2097148,4,1]
+#
+# Extent 0 has blockcount = ALIGN_DOWN(maxextlen, rextsize). Extent 1 is
+# adjacent and has blockcount = rextsize. Both are unwritten.
+$XFS_IO_PROG -c "falloc 0 $filesz" -c fsync -f "$SCRATCH_MNT/file"
+
+# Write extent 0 + one block of extent 1. Our extents should end up like so:
+#
+# u3.bmx[0-1] = [startoff,startblock,blockcount,extentflag]
+# 0:[0,0,2097149,0]
+# 1:[2097149,2097149,3,1]
+#
+# Extent 0 is written and has blockcount = ALIGN_DOWN(maxextlen, rextsize) + 1,
+# Extent 1 is adjacent, unwritten, and has blockcount = rextsize - 1 and
+# startblock % rextsize = 1.
+#
+# The -b is just to speed things up (doing GBs of I/O in 4k chunks kind of
+# sucks).
+$XFS_IO_PROG -c "pwrite -b 1M -W 0 $(((maxextlen + 2 - rextsize) * bs))" \
+	"$SCRATCH_MNT/file" >> "$seqres.full"
+
+# Truncate the extents.
+$XFS_IO_PROG -c "truncate 0" -c fsync "$SCRATCH_MNT/file"
+
+# We need to do this before the loop device gets torn down.
+_scratch_unmount
+_check_scratch_fs
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/589.out b/tests/generic/589.out
new file mode 100644
index 00000000..5ab6ab10
--- /dev/null
+++ b/tests/generic/589.out
@@ -0,0 +1,2 @@
+QA output created by 589
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 87d7441c..be6f4a43 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -591,3 +591,4 @@
 586 auto quick rw prealloc
 587 auto quick rw prealloc
 588 auto quick log clone
+589 auto prealloc preallocrw dangerous
-- 
2.24.0

