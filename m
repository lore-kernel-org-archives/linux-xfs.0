Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CC3C388F7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53F402224C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNmEKJAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKMMFH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgKML2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:28:07 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE8EC0613D1;
        Fri, 13 Nov 2020 03:27:58 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id i13so6850799pgm.9;
        Fri, 13 Nov 2020 03:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BGm+n+4cGbjW8YX1IQesAH1JhTJWOfK5uX+zfpwxaZg=;
        b=jNmEKJAg7YiVjLF/3mGOrJY2/nXGx0AnuHcMaijntkLr0t9mG7F3+vZn8KbxD2Wnm1
         jqvjq3IyL/ixP9rRro64Ps81uIm61vCvk2nktono6oqw8gByVy0Yih+qtsrDGv2nT6MG
         Pd7xr/IpkjbO2o1mz1BCn8OMA/lltkRask2sAMWlALcY634HNV/xYO8pQy8FjiAh+D6k
         hkPq7jADVUQXhjq9Wl/k+Mg1ysu9c8dizWAocdceZLXVkaGzgjtvrPt42tye25ascNUZ
         uKia5VjeSnFNj77SsnowiPPSBhOTjK1MtGZgite4+snw/rzB/vtMlWB2TEFvK9Vz9ezw
         EUcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BGm+n+4cGbjW8YX1IQesAH1JhTJWOfK5uX+zfpwxaZg=;
        b=CKJuJ/Vhu1N5/HjC0xSMmh/oWcEmZxrHEku8Jgcn3fu0pUegGyG6JeHKjdsaI2EXDp
         07HzCTVNj0LDh16aKmEXA96dY6lz6GQndIBySf/RJ8STN7Nfa097msCPOcrqvs4guA7o
         w0ILOy2XdqsOg1tY7zEXkahUkYVYBVEGKx43xt3lwyBrZMYGm8CZPbGg3+3B9gDSRqXg
         sf9EjWJt1PA8JaOT64DyH8zfrfEeosYPsQvr5NiHbzRPGLiNUlkoeyUXbthJfJ07me/u
         9sZqjs1NAjC5HRFBlObBOZwbZOqV2xVE4qQTdI9CZjoKiPf5zTYVtbcBaBufcdiSH3B/
         +vIQ==
X-Gm-Message-State: AOAM5309X//PlT0ZCb/jEy7O2y8bsNzFUmOiW1x2YOWzLw5rYDPicwGo
        0UaLoRFNBxSxV9Vfm3Nbt9MrQ8lONSI=
X-Google-Smtp-Source: ABdhPJxXVGx0v3g6jyM9hNEv0qnhIXHLFqtXATFd5UyFA/b8M7MXvyFfUNOn6OO58Dxu5qmYDMCBjQ==
X-Received: by 2002:a17:90a:77ca:: with SMTP id e10mr2365216pjs.113.1605266877710;
        Fri, 13 Nov 2020 03:27:57 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:57 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 11/11] xfs: Stress test with with bmap_alloc_minlen_extent error tag enabled
Date:   Fri, 13 Nov 2020 16:57:03 +0530
Message-Id: <20201113112704.28798-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a stress test that executes fsstress with
bmap_alloc_minlen_extent error tag enabled.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/531     | 85 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/531.out |  6 ++++
 tests/xfs/group   |  1 +
 3 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/531
 create mode 100644 tests/xfs/531.out

diff --git a/tests/xfs/531 b/tests/xfs/531
new file mode 100755
index 00000000..e846cc0e
--- /dev/null
+++ b/tests/xfs/531
@@ -0,0 +1,85 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 531
+#
+# Execute fsstress with bmap_alloc_minlen_extent error tag enabled.
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/inject
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+testfile=$SCRATCH_MNT/testfile
+
+echo "Consume free space"
+dd if=/dev/zero of=${testfile} bs=${bsize} >> $seqres.full 2>&1
+sync
+
+echo "Create fragmented filesystem"
+$here/src/punch-alternating $testfile >> $seqres.full
+sync
+
+echo "Inject bmap_alloc_minlen_extent error tag"
+xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
+
+echo "Execute fsstress in background"
+$FSSTRESS_PROG -d $SCRATCH_MNT -p128 -n999999999 \
+		 -f bulkstat=0 \
+		 -f bulkstat1=0 \
+		 -f fiemap=0 \
+		 -f getattr=0 \
+		 -f getdents=0 \
+		 -f getfattr=0 \
+		 -f listfattr=0 \
+		 -f mread=0 \
+		 -f read=0 \
+		 -f readlink=0 \
+		 -f readv=0 \
+		 -f stat=0 \
+		 -f aread=0 \
+		 -f dread=0 > /dev/null 2>&1 &
+
+fsstress_pid=$!
+sleep 2m
+
+echo "Killing fsstress process $fsstress_pid ..." >> $seqres.full
+kill $fsstress_pid >> $seqres.full
+wait $fsstress_pid
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/531.out b/tests/xfs/531.out
new file mode 100644
index 00000000..e0a419c2
--- /dev/null
+++ b/tests/xfs/531.out
@@ -0,0 +1,6 @@
+QA output created by 531
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject bmap_alloc_minlen_extent error tag
+Execute fsstress in background
diff --git a/tests/xfs/group b/tests/xfs/group
index 81a15582..f4cb5af6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -528,3 +528,4 @@
 528 auto quick reflink
 529 auto quick reflink
 530 auto quick
+531 auto stress
-- 
2.28.0

