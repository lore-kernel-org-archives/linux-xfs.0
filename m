Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB69AC433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 22:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9783D64ED5
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 22:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBTWRX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Feb 2021 17:17:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhBTWRW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Feb 2021 17:17:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613859355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gt25dl1aBg0tAqBBTwvlbMp0nsmIiyYScgWt915aRHM=;
        b=eRvG2n4QA4Lhrnj/5d4FST0oiNRpO+zNKHL9mZ439a/xEM7gfi3eBwEGcFWqkvkpAlxRb7
        h8Fcwe1jYt9LgTdIVIX4U5PJchCUmf9VP4WwuDztHK+3ZYLuF7tJZ8nPJKkgwV1iJ6GI9x
        Gzk0GHi5iIBzokzxIMTRZjhPG1RXHJM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-mQJlvk-HPsGtmL0WalKAuQ-1; Sat, 20 Feb 2021 17:15:53 -0500
X-MC-Unique: mQJlvk-HPsGtmL0WalKAuQ-1
Received: by mail-ed1-f71.google.com with SMTP id p12so4907501edw.9
        for <linux-xfs@vger.kernel.org>; Sat, 20 Feb 2021 14:15:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gt25dl1aBg0tAqBBTwvlbMp0nsmIiyYScgWt915aRHM=;
        b=k0lS5CLih/WIUnfmBgPyBezv+8sxn4T6wr4pN+wLVSNwEe3CFIRYrUaDXBmNQ/a4dr
         hR9cBRSXXGWp03TIz2DLQDSBGIbg9FLadufvxzQzVw4T37gkttfkRx4zeXXTWr5/Ytb2
         ei6KfXi2M0Mo9xuCFoTc8smFFvfm+xzVB9jwWEaGsREQmHBCV1CdGskNF8WSKMflf6Ga
         yUVj9V5j2EAgWFY7ZonntNA/cUItViWkbMiTOFqGIwV7VweOUwpRNYcaTVu1+g2R6OZ8
         jj/5TtAQTBmPmFUgpHoFcgJMHm4RR12Gjc90RhXoOw9sqP+OsuhWPFebqR8/IviwycBm
         mepw==
X-Gm-Message-State: AOAM532cdEuM9A1Nddy90gjl6pzDi3QzS8wYBP4Ev1hrF2+8Y99VMpJp
        YTQyIruv1rLv8KGQ2yOAr0fPBTwn8x/aFfQW4PFGHvn/PED71eicteTyS7bPg4GQoFmgWtxKtpJ
        r37aqM/BPGezHClxtTg1IGdDF4IOTwFG44iXK1NaL0QrrBfCwc9t5aa2aXz8J/4PbiAUPY+I=
X-Received: by 2002:a17:906:9bd2:: with SMTP id de18mr13269625ejc.191.1613859351823;
        Sat, 20 Feb 2021 14:15:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTdnBfCjTpVNJ7gkwC2hoBUd9ij+9CwCk8JrT61i+puqxZjKblUZ2+7zLzCAdi1XRftgktOQ==
X-Received: by 2002:a17:906:9bd2:: with SMTP id de18mr13269611ejc.191.1613859351549;
        Sat, 20 Feb 2021 14:15:51 -0800 (PST)
Received: from localhost.localdomain.com ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id k6sm7020286ejb.84.2021.02.20.14.15.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 14:15:51 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Add test for printing deprec. mount options
Date:   Sat, 20 Feb 2021 23:15:48 +0100
Message-Id: <20210220221549.290538-2-preichl@redhat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210220221549.290538-1-preichl@redhat.com>
References: <20210220221549.290538-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Verify that warnings about deprecated mount options are properly
printed.

Verify that no excessive warnings are printed during remounts.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 tests/xfs/528     | 88 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/528.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/528
 create mode 100644 tests/xfs/528.out

diff --git a/tests/xfs/528 b/tests/xfs/528
new file mode 100755
index 00000000..0fc57cef
--- /dev/null
+++ b/tests/xfs/528
@@ -0,0 +1,88 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.. All Rights Reserved.
+#
+# FS QA Test 528
+#
+# Verify that warnings about deprecated mount options are properly printed.
+#  
+# Verify that no excessive warnings are printed during remounts.
+#
+
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+_require_check_dmesg
+_supported_fs xfs
+_require_scratch
+
+log_tag()
+{
+	echo "fstests $seqnum [tag]" > /dev/kmsg
+}
+
+dmesg_since_test_tag()
+{
+        dmesg | tac | sed -ne "0,\#fstests $seqnum \[tag\]#p" | \
+                tac
+}
+
+check_dmesg_for_since_tag()
+{
+        dmesg_since_test_tag | egrep -q "$1"
+}
+
+echo "Silence is golden."
+
+log_tag
+
+# Test mount
+for VAR in {attr2,ikeep,noikeep}; do
+	_scratch_mkfs > $seqres.full 2>&1
+	_scratch_mount -o $VAR
+	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated" || \
+		echo "Could not find deprecation warning for $VAR"
+	umount $SCRATCH_MNT
+done
+
+# Test mount with default options (attr2 and noikeep) and remount with
+# 2 groups of options
+# 1) the defaults (attr2, noikeep)
+# 2) non defaults (noattr2, ikeep)
+_scratch_mount
+for VAR in {attr2,noikeep}; do
+	log_tag
+	mount -o $VAR,remount $SCRATCH_MNT
+	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated." && \
+		echo "Should not be able to find deprecation warning for $VAR"
+done
+for VAR in {noattr2,ikeep}; do
+	log_tag
+	mount -o $VAR,remount $SCRATCH_MNT
+	check_dmesg_for_since_tag "XFS: $VAR mount option is deprecated" || \
+		echo "Could not find deprecation warning for $VAR"
+done
+umount $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
+
diff --git a/tests/xfs/528.out b/tests/xfs/528.out
new file mode 100644
index 00000000..762dccc0
--- /dev/null
+++ b/tests/xfs/528.out
@@ -0,0 +1,2 @@
+QA output created by 528
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index e861cec9..ad3bd223 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -525,3 +525,4 @@
 525 auto quick mkfs
 526 auto quick mkfs
 527 auto quick quota
+528 auto quick mount
-- 
2.29.2

