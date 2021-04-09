Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920C7C43460
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 12:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FAD46115C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 12:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhDIMuR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 08:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbhDIMte (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 08:49:34 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66980C061761;
        Fri,  9 Apr 2021 05:49:21 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id t22so3852225pgu.0;
        Fri, 09 Apr 2021 05:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FM5YRfgCIbkVp54DQEsjkpf8vnnKXZ2Kt4raLS4sotM=;
        b=OAZHXA7aGa/8H09D9XxBbyLgSNuOZ2kUSe5rDJPGosM982zuHKboyaCFwujsXvhA4o
         ixtGPjcMT2o9rsoaVcwklx3RIGefLUqTgFeLK/tgOC2m/ZjwlMiDq5bzTtdwrG9p7xB9
         BMjkZzn2gFrmlwnaBWElk6RVi7mNo8VNn77WD1vjSvt1MaTsrM4fMhu/kWXZUZPzZAe7
         zhkoXGzdMsCV2wj5/UUUXP+zPQOcPHv6PERC3xXmXGJ9r7hywAd5VSwAsIfAa2kp7vOO
         X3+Z4VeGY7f60wQZLWmcx7aoldntRsWiciTcdwiOT6Y+QchBnJFyxg1IT5FUwmu3+qNt
         zkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FM5YRfgCIbkVp54DQEsjkpf8vnnKXZ2Kt4raLS4sotM=;
        b=E5kQZUeB53qBwg3honz0O27zF0rIJN47ttuGaPTMMDnUb5UFr1b3yrF5skvEwQ89vq
         d53+RIl+LQQDuGudXc1Sl+bW5a5KeWqGiNsi39/3cZk9+IZmDGSUzioDIMqIiya0fGFR
         QUDVshp9vHdxQGrkvd54aC5/TJrjQcSBswv+KiUtePW9vpSPd7FOJ0a6FfmIQ7dv22MN
         tzLmDrgKjV//WmG9nuzS9yB4E333mDHKn+RxmPx2yNBFEv1m8flYH6JU+Ybec0KDqzZ/
         sEuht4ZNa0xzmU5k6/70caeajwEsj1bfKkVLszmiRMbbMdW9mNEETfZcd5tFSHmp6KzE
         7sCA==
X-Gm-Message-State: AOAM530Stg1amBSOZk5Tp6esdyoQhfvXEJm28zry1kWdjcZYZnAZiD1j
        mrni+qHblK11pccucQfFpJqkjhtL0FY=
X-Google-Smtp-Source: ABdhPJyjmF4oRYP/23OX7tBKCHBrDDsSGDZBsUJ+aZ4jbYWaGuUXlq41Uv/CgTqQq5NPRBbWLGilGg==
X-Received: by 2002:a63:1556:: with SMTP id 22mr13455544pgv.142.1617972560857;
        Fri, 09 Apr 2021 05:49:20 -0700 (PDT)
Received: from localhost.localdomain ([122.171.137.117])
        by smtp.gmail.com with ESMTPSA id n22sm2761992pgf.42.2021.04.09.05.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 05:49:20 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH] fstests: Disable realtime inherit flag when executing xfs/{532,533,538}
Date:   Fri,  9 Apr 2021 18:19:03 +0530
Message-Id: <20210409124903.23374-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The minimum length space allocator (i.e. xfs_bmap_exact_minlen_extent_alloc())
depends on the underlying filesystem to be fragmented so that there are enough
one block sized extents available to satify space allocation requests.

xfs/{532,533,538} tests issue space allocation requests for metadata (e.g. for
blocks holding directory and xattr information). With realtime filesystem
instances, these tests would end up fragmenting the space on realtime
device. Hence minimum length space allocator fails since the regular
filesystem space is not fragmented and hence there are no one block sized
extents available.

Thus, this commit disables realtime inherit flag (if any) on root directory so
that space on data device gets fragmented rather than realtime device.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/532 | 4 ++++
 tests/xfs/533 | 4 ++++
 tests/xfs/538 | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/tests/xfs/532 b/tests/xfs/532
index 2bed574a..560af586 100755
--- a/tests/xfs/532
+++ b/tests/xfs/532
@@ -45,6 +45,10 @@ echo "Format and mount fs"
 _scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
 _scratch_mount >> $seqres.full
 
+# Disable realtime inherit flag (if any) on root directory so that space on data
+# device gets fragmented rather than realtime device.
+$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+
 bsize=$(_get_block_size $SCRATCH_MNT)
 
 attr_len=255
diff --git a/tests/xfs/533 b/tests/xfs/533
index be909fcc..dd4cb4c4 100755
--- a/tests/xfs/533
+++ b/tests/xfs/533
@@ -56,6 +56,10 @@ echo "Format and mount fs"
 _scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
 _scratch_mount >> $seqres.full
 
+# Disable realtime inherit flag (if any) on root directory so that space on data
+# device gets fragmented rather than realtime device.
+$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+
 echo "Consume free space"
 fillerdir=$SCRATCH_MNT/fillerdir
 nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
diff --git a/tests/xfs/538 b/tests/xfs/538
index 90eb1637..97273b88 100755
--- a/tests/xfs/538
+++ b/tests/xfs/538
@@ -42,6 +42,10 @@ echo "Format and mount fs"
 _scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
 _scratch_mount >> $seqres.full
 
+# Disable realtime inherit flag (if any) on root directory so that space on data
+# device gets fragmented rather than realtime device.
+$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+
 bsize=$(_get_file_block_size $SCRATCH_MNT)
 
 echo "Consume free space"
-- 
2.29.2

