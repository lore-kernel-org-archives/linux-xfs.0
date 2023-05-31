Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A1CC77B7A
	for <linux-xfs@archiver.kernel.org>; Wed, 31 May 2023 06:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjEaGlk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 02:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjEaGlj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 02:41:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B6A183
        for <linux-xfs@vger.kernel.org>; Tue, 30 May 2023 23:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685515248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kP3fciMgk/5qy3IHjrvWMiNRmiOvSWrbsCKGKCz1Tw8=;
        b=U/kCC3dqKN/QtdrAo+vtlpPvocSX/vwDd5VTG6RZDSIl4GZWpaiT10LQa4tGn+wsB4SP7V
        3aAJDrHetZZr99sbr89jfJZ/J2ll9iJoT6LkJj1DZWwCeUqpXieA5Nw1BupsCAFE2WgXln
        00jbj5zAbzW5k3Hmi4j5S77ZDD5JkJs=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-q7XOxdd1OyCZM8UdMi8gQw-1; Wed, 31 May 2023 02:40:47 -0400
X-MC-Unique: q7XOxdd1OyCZM8UdMi8gQw-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6af87ea95c6so4146724a34.2
        for <linux-xfs@vger.kernel.org>; Tue, 30 May 2023 23:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685515246; x=1688107246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kP3fciMgk/5qy3IHjrvWMiNRmiOvSWrbsCKGKCz1Tw8=;
        b=AdRTRoGluHUPFCIlLxu2tF3P3g3yMHxSd/P9rIMgx6CntVZfiEXpV3kUj6dLp0ySZO
         8+SOlIJl1Tpr5dqTWPtQ8B8BFvFD+yBp7pFK9xe9JmC9kL8WlD6vMSI3QJdb/UcxeKeg
         jSNt+VevRplgbfwSIg7OB9HeGliY5PJM5EItnB7xt8Cn3jvDSVr4x7pCBCPTEKs2pKse
         7sm4+q+DFXOu7mHGMmvVRd28Tg5fHWR3Yj6fnDbWoCiG79KeLwa8YGDn6K5Nq4VYcvbO
         CYsZJyQsQ5j4LteAQPGNOB4qQDD4EIhKe3ChWhZwsDtMeSG8IqdZF1SpQ5Rkp0zMY7cV
         eVmA==
X-Gm-Message-State: AC+VfDyByc7EbGJ8lCSHN5ZxB8F/8KQzWZnzSSeABqIc5DOzesP/AHhL
        9tQr+z9eKrubOWX6ch4Vg9Fj5d+fDLV5hoQNbuJ9nJzkFxYXQU9zcPq7W4l85Vor8R6u0AcIQ/E
        WTOYVYiEzs0EssX1iNnvSPtdWsFGqqEdZt26WwUGvHFMffq90vRDoCQuQ6vi9+2zPm3AEoqngwM
        Y1Pqqu
X-Received: by 2002:a05:6830:e05:b0:6af:7d71:c9fd with SMTP id do5-20020a0568300e0500b006af7d71c9fdmr1506475otb.13.1685515246048;
        Tue, 30 May 2023 23:40:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5TQmzMHtreVHDFnOAyF8g+KzYgf1uj/6qUpbub4hwOGdmSk2JoxZdMZoJrOv8qeOipzod47w==
X-Received: by 2002:a05:6830:e05:b0:6af:7d71:c9fd with SMTP id do5-20020a0568300e0500b006af7d71c9fdmr1506456otb.13.1685515245754;
        Tue, 30 May 2023 23:40:45 -0700 (PDT)
Received: from anathem.redhat.com ([2001:8003:4b08:fb00:e45d:9492:62e8:873c])
        by smtp.gmail.com with ESMTPSA id g19-20020aa78193000000b0064d566f658esm2635220pfi.135.2023.05.30.23.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 23:40:45 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v4] xfstests: add test for xfs_repair progress reporting
Date:   Wed, 31 May 2023 16:40:24 +1000
Message-Id: <20230531064024.1737213-2-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230531064024.1737213-1-ddouwsma@redhat.com>
References: <20230531064024.1737213-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Confirm that xfs_repair reports on its progress if -o ag_stride is
enabled.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
Changes since v3
- Rebase after tests/xfs/groups removal (tools/convert-group), drop _supported_os
- Shorten the delay, remove superfluous dm-delay parameters
Changes since v2:
- Fix cleanup handling and function naming
- Added to auto group
Changes since v1:
- Use _scratch_xfs_repair
- Filter only repair output
- Make the filter more tolerant of whitespace and plurals
- Take golden output from 'xfs_repair: fix progress reporting'

 tests/xfs/999     | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out | 15 +++++++++++
 2 files changed, 81 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 00000000..9e799f66
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 521
+#
+# Test xfs_repair's progress reporting
+#
+. ./common/preamble
+_begin_fstest auto repair
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_cleanup_delay > /dev/null 2>&1
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/dmdelay
+. ./common/populate
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_require_scratch
+_require_dm_target delay
+
+# Filter output specific to the formatters in xfs_repair/progress.c
+# Ideally we'd like to see hits on anything that matches
+# awk '/{FMT/' xfsprogs-dev/repair/progress.c
+filter_repair()
+{
+	sed -nre '
+	s/[0-9]+/#/g;
+	s/^\s+/ /g;
+	s/(# (week|day|hour|minute|second)s?(, )?)+/{progres}/g;
+	/#:#:#:/p
+	'
+}
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Introduce a dmdelay"
+_init_delay
+DELAY_MS=38
+
+# Introduce a read I/O delay
+# The default in common/dmdelay is a bit too agressive
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 $DELAY_MS"
+_load_delay_table $DELAY_READ
+
+echo "Run repair"
+SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
+        tee -a $seqres.full > $tmp.repair
+
+cat $tmp.repair | filter_repair | sort -u
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 00000000..e27534d8
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,15 @@
+QA output created by 999
+Format and populate
+Introduce a dmdelay
+Run repair
+ - #:#:#: Phase #: #% done - estimated remaining time {progres}
+ - #:#:#: Phase #: elapsed time {progres} - processed # inodes per minute
+ - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
+ - #:#:#: process known inodes and inode discovery - # of # inodes done
+ - #:#:#: process newly discovered inodes - # of # allocation groups done
+ - #:#:#: rebuild AG headers and trees - # of # allocation groups done
+ - #:#:#: scanning agi unlinked lists - # of # allocation groups done
+ - #:#:#: scanning filesystem freespace - # of # allocation groups done
+ - #:#:#: setting up duplicate extent list - # of # allocation groups done
+ - #:#:#: verify and correct link counts - # of # allocation groups done
+ - #:#:#: zeroing log - # of # blocks done
-- 
2.39.3

