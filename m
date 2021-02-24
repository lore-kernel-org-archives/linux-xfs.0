Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC36C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD63064F03
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhBXVo4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:44:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232718AbhBXVoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 16:44:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614203007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4gyevHG2wwe2Wggj/EzCbWgoef9XA5NaUW8y6Xdb+RM=;
        b=EA8K41GTJNgF0Z87pXrQO3H95jnH4P93h2rSavtuWB0f6oyHBanZuvmMnuSBdcY6XlzRuJ
        NtBXN2m5LkcPeoLJ6AWNiXzYZP5vFTX75hffMCgYdyOU3U8ebxE2YwQ/Gi9Mxq2P6ByeAy
        HTT8CbvtIg9ueijRWReD0jKHb7/Ysds=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-UO6Gl4HINNuP7zPdQeb2RQ-1; Wed, 24 Feb 2021 16:43:26 -0500
X-MC-Unique: UO6Gl4HINNuP7zPdQeb2RQ-1
Received: by mail-wr1-f70.google.com with SMTP id j12so1616876wrt.9
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 13:43:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4gyevHG2wwe2Wggj/EzCbWgoef9XA5NaUW8y6Xdb+RM=;
        b=GUlDrsdQrqMCil3dTadFaF7XgtIGa13pO7YeX27Nlas7lErnFhBOn6vtSyiVAZ0Fd3
         AWDdI/2+HJ7G2CBc+S9ADcsEJW0Zojwo3aaEVOVqUuYN6LYZNCEfiO5jI9g/UHqPsG6U
         M8XycaFlODqMVPu2rjOvOi7vhWi9uf2wXMAOS7sj90chWwe3fCwpR6LNCilZp1LPrpaa
         Y+k7v9E/7kyQno4wh90uJefX6lVJSrE9jXcHv+/pM8A+4oH1TQw8wMoL9JFwWDnamb5G
         bplHCPHC+0zAcHG2tpFzLa5qFDwsT8D7zMRBvFT0SBcBstz19pFo7LxeCNtQPLUnoard
         4aTQ==
X-Gm-Message-State: AOAM533Dse6ELn66KQT0hXxZGWkO+HbaAKbU+oH4brSFaM+zM7yAST08
        GEFfcIIc1SbiU9oxcZtPGhll4DhZvXr7Xk+MWM8sCFiMR8krpqeo0Wtq5SbyEQOPGYBMKZr3qqu
        STHC6ucOYSIGYUEuHD9JuR0fAY1fDCNOwh8LLWYicP43bHARDVqtzEUGvL814e0J8SURbwMA=
X-Received: by 2002:a5d:6783:: with SMTP id v3mr87684wru.394.1614203005020;
        Wed, 24 Feb 2021 13:43:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzdEKwCtP37JQXnJA0KI9v2u9ML434Ha/qNel54wFGpqyJ9bkHu55cF6Mv9Uf6b4CSAd1QZVA==
X-Received: by 2002:a5d:6783:: with SMTP id v3mr87672wru.394.1614203004803;
        Wed, 24 Feb 2021 13:43:24 -0800 (PST)
Received: from localhost.localdomain.com ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id x13sm4477251wrt.75.2021.02.24.13.43.24
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 13:43:24 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: Add test for printing deprec. mount options
Date:   Wed, 24 Feb 2021 22:43:21 +0100
Message-Id: <20210224214323.394286-2-preichl@redhat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210224214323.394286-1-preichl@redhat.com>
References: <20210224214323.394286-1-preichl@redhat.com>
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
 tests/xfs/528     | 86 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/528.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 89 insertions(+)
 create mode 100755 tests/xfs/528
 create mode 100644 tests/xfs/528.out

diff --git a/tests/xfs/528 b/tests/xfs/528
new file mode 100755
index 00000000..111a3770
--- /dev/null
+++ b/tests/xfs/528
@@ -0,0 +1,86 @@
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
+	dmesg | tac | sed -ne "0,\#fstests $seqnum \[tag\]#p" | \
+		tac
+}
+
+check_dmesg_for_since_tag()
+{
+	dmesg_since_test_tag | egrep -q "$1"
+}
+
+echo "Silence is golden."
+
+
+# Skip old kernels that did not print the warning yet
+log_tag
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount -o attr2
+umount $SCRATCH_MNT
+check_dmesg_for_since_tag "XFS: attr2 mount option is deprecated" || \
+	_notrun "Deprecation warning are not printed at all."
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

