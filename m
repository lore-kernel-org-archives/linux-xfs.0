Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E6AC43331
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B91E65092
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhCIFCa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhCIFCH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:02:07 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88714C06174A;
        Mon,  8 Mar 2021 21:02:07 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so4492258pjb.0;
        Mon, 08 Mar 2021 21:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y0Z+s7Fjcy2Im2UyVPHCdibGR473jRuqO1r2vb39Jps=;
        b=bWJY/3PYuNpZxTHJwRcjgHbB29cQHzo/ReDTDwlqXafn4N5ktmI6vfF7xG9ZU3TGg1
         kpn5g247GyuqZFQBApUQp66mhFOO4btA/UgF7p8K+nZ5lba8hnUJk+LxAEk0LVKnk6yo
         bI1vNoFqgDVJBJ0Pj9L76f1DaCGZpFDjWA3hdwZh7tTDyddv7xEycAwZ/8vl3U90IL8z
         xkaQpx1EcPu5kL1tLbHPkdo0mQhDSe2yw62CDVg75VS0Q4jO5W28/ApbA6jq5LTQf7wI
         mcLBWkg0p6UmYsdD+NuLJrLynBulJ8Nggk62Riyox4sLIoobkAGibzB8LJkfGZIfRG0t
         w9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y0Z+s7Fjcy2Im2UyVPHCdibGR473jRuqO1r2vb39Jps=;
        b=qyN3lH44NKzSxkuja1Kb5i342bP3MK0a5qIQWmPxlJHaKy6WoK46gACXbyO+W+8WeF
         BypUX2GrSizdzJwYdnAO/+7lgPWhoaLFhFTAYrLbubHmat0WmVyrTwF66ruBp9En9AE2
         FpilpBEvCLgRi/YOFEzP7JvEHFTZ+EMrM2LSQfDVdrQy9zMyxixZneeecnb4aktddUkU
         8P2ZHDBcecgs3cp0484hWplVZ1vGdnaF91Yys0t9fZhabjwuuaofN1fDc7pA4TZQJev1
         ha1OuqhLX/wi7g2x+p/MEp5oA/+TKqacG7FUVNxKbOtWBkxNa04cTfK7vzpJs0DvApI5
         Ay6g==
X-Gm-Message-State: AOAM530ucg1beH7o0rQ3o9PQkElhwgc9sV1x01msBHUljsgkKGiUt81f
        xspWWcMK1R+eHxjh3qBQ1poG4yTTOUA=
X-Google-Smtp-Source: ABdhPJy2nJHeU3cC6q+lvLLnXq8DCuZUFVndQQerxS3XkGsWFXipmt+i5Aqmm/QNuKvc10oWIrv/iA==
X-Received: by 2002:a17:90a:64c7:: with SMTP id i7mr2682270pjm.95.1615266126400;
        Mon, 08 Mar 2021 21:02:06 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:02:06 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 13/13] xfs: Stress test with bmap_alloc_minlen_extent error tag enabled
Date:   Tue,  9 Mar 2021 10:31:24 +0530
Message-Id: <20210309050124.23797-14-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a stress test that executes fsstress with
bmap_alloc_minlen_extent error tag enabled.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/537     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/537.out |  7 ++++
 tests/xfs/group   |  1 +
 3 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/537
 create mode 100644 tests/xfs/537.out

diff --git a/tests/xfs/537 b/tests/xfs/537
new file mode 100755
index 00000000..77fa60d9
--- /dev/null
+++ b/tests/xfs/537
@@ -0,0 +1,84 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 537
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
+. ./common/populate
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
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+echo "Consume free space"
+fillerdir=$SCRATCH_MNT/fillerdir
+nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
+nr_free_blks=$((nr_free_blks * 90 / 100))
+
+_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 >> $seqres.full 2>&1
+
+echo "Create fragmented filesystem"
+for dentry in $(ls -1 $fillerdir/); do
+	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
+done
+
+echo "Inject bmap_alloc_minlen_extent error tag"
+_scratch_inject_error bmap_alloc_minlen_extent 1
+
+echo "Scale fsstress args"
+args=$(_scale_fsstress_args -p $((LOAD_FACTOR * 75)) -n $((TIME_FACTOR * 1000)))
+
+echo "Execute fsstress in background"
+$FSSTRESS_PROG -d $SCRATCH_MNT $args \
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
+		 -f dread=0 > /dev/null 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/537.out b/tests/xfs/537.out
new file mode 100644
index 00000000..19633a07
--- /dev/null
+++ b/tests/xfs/537.out
@@ -0,0 +1,7 @@
+QA output created by 537
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject bmap_alloc_minlen_extent error tag
+Scale fsstress args
+Execute fsstress in background
diff --git a/tests/xfs/group b/tests/xfs/group
index ba674a58..5c827727 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -534,3 +534,4 @@
 534 auto quick reflink
 535 auto quick reflink
 536 auto quick
+537 auto stress
-- 
2.29.2

