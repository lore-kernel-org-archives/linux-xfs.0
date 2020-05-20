Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66541C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 03:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 447492083E
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 03:53:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MJG7F6iD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgETDx3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 23:53:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46698 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726379AbgETDx3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 23:53:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589946806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Y3HTKPlIJbtBtMsP1jAkuNttAPTG0h+wqvf9AMksg5A=;
        b=MJG7F6iDLHTEx/sEYMrVSmVO7txFBFeB8jJOCPehbwmo+j23530OYzULWatZpekB0ZKQ44
        Vt1VDd0eS4ZgfuNw6utvX9GeEzucbO/81lGpxJ3ZJOz6gC//JvssE34VFKXp/zN+4xOWa1
        ARtBBgLdCJ2C6ItkrRm90SCxfJqPKHY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-eyQaSx_pNtaIy2Um3Co6Hw-1; Tue, 19 May 2020 23:53:25 -0400
X-MC-Unique: eyQaSx_pNtaIy2Um3Co6Hw-1
Received: by mail-pj1-f69.google.com with SMTP id gk8so1679674pjb.8
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 20:53:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y3HTKPlIJbtBtMsP1jAkuNttAPTG0h+wqvf9AMksg5A=;
        b=XgAo8jMRDlune21Mp/BDetPDpRQ/IHQS18MMhRVbU0D43ihwcYj+w0XTgphv794qel
         oxHHmhQMVbaU0ofKkQ/Hlb9LU+PYQXKbnMAWhR23QMvrV6HJD/6apoEZRoBMDSLS/MhD
         XDGgtr1CEBQEq0V9wCBM1ZzcewNGtLM/g86tSTV6gZxwlKQqvVLbSvk37MkkZGu/Aeml
         kXuG10KoJjmQdSgAB+LcUTf/LvDh06PdQaquQV1DoQvLjqBvKC6Y380HU++DFX6Pa43H
         oRfYgZq1snx8Ez4wOKSdCAlRL06IWVKfQPWR9KMmO+wh8YAJRsX9rr1I5N77Rt7vCYbC
         ApZg==
X-Gm-Message-State: AOAM532+kXrtAhChLCWk2m3O2t9bGntGj7/heRmILo8w45ZxPGOmLoyy
        LA5ndmgHWvXdnBzQqMb9vhhSOFP7p0YPpOSvaYmElsZNJAbCcPRaTwyeE6ridjc7Aml9iSzCZFP
        Cru33bHS3nFStX66DpQI8
X-Received: by 2002:a17:90a:3262:: with SMTP id k89mr2935715pjb.33.1589946803550;
        Tue, 19 May 2020 20:53:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTJSIC2fSkoW1Mv4jAscRcz7moZ025Fsw3acYh1/dXPWSfufxy9P8/ijRq0yXoWa19tEMa2Q==
X-Received: by 2002:a17:90a:3262:: with SMTP id k89mr2935699pjb.33.1589946803240;
        Tue, 19 May 2020 20:53:23 -0700 (PDT)
Received: from don.com ([60.224.129.195])
        by smtp.gmail.com with ESMTPSA id t23sm769649pji.32.2020.05.19.20.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 20:53:22 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v2] xfstests: add test for xfs_repair progress reporting
Date:   Wed, 20 May 2020 13:52:58 +1000
Message-Id: <20200520035258.298516-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200519160125.GB17621@magnolia>
References: <20200519160125.GB17621@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_repair's interval based progress has been broken for
some time, create a test based on dmdelay to stretch out
the time and use ag_stride to force parallelism.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
Changes since v1:
- Use _scratch_xfs_repair
- Filter only repair output
- Make the filter more tolerant of whitespace and plurals
- Take golden output from 'xfs_repair: fix progress reporting'

 tests/xfs/516     | 76 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/516.out | 15 ++++++++++
 tests/xfs/group   |  1 +
 3 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/516
 create mode 100644 tests/xfs/516.out

diff --git a/tests/xfs/516 b/tests/xfs/516
new file mode 100755
index 00000000..1c0508ef
--- /dev/null
+++ b/tests/xfs/516
@@ -0,0 +1,76 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 516
+#
+# Test xfs_repair's progress reporting
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
+	_dmsetup_remove delay-test > /dev/null 2>&1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmdelay
+. ./common/populate
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+_require_dm_target delay
+
+# Filter output specific to the formatters in xfs_repair/progress.c
+# Ideally we'd like to see hits on anything that matches
+# awk '/{FMT/' repair/progress.c
+_filter_repair()
+{
+	sed -ne '
+	s/[0-9]\+/#/g;
+	s/^\s\+/ /g;
+	s/\(second\|minute\)s/\1/g
+	/#:#:#:/p
+	'
+}
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Introduce a dmdelay"
+_init_delay
+
+# Introduce a read I/O delay
+# The default in common/dmdelay is a bit too agressive
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 100 $SCRATCH_DEV 0 0"
+_load_delay_table $DELAY_READ
+
+echo "Run repair"
+SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
+        tee -a $seqres.full > $seqres.xfs_repair.out
+
+cat $seqres.xfs_repair.out | _filter_repair | sort -u
+
+_cleanup_delay
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/516.out b/tests/xfs/516.out
new file mode 100644
index 00000000..85018b93
--- /dev/null
+++ b/tests/xfs/516.out
@@ -0,0 +1,15 @@
+QA output created by 516
+Format and populate
+Introduce a dmdelay
+Run repair
+ - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
+ - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
+ - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
+ - #:#:#: process known inodes and inode discovery - # of # inodes done
+ - #:#:#: process newly discovered inodes - # of # allocation groups done
+ - #:#:#: rebuild AG headers and trees - # of # allocation groups done
+ - #:#:#: scanning agi unlinked lists - # of # allocation groups done
+ - #:#:#: scanning filesystem freespace - # of # allocation groups done
+ - #:#:#: setting up duplicate extent list - # of # allocation groups done
+ - #:#:#: verify and correct link counts - # of # allocation groups done
+ - #:#:#: zeroing log - # of # blocks done
diff --git a/tests/xfs/group b/tests/xfs/group
index 12eb55c9..aeeca23f 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -513,3 +513,4 @@
 513 auto mount
 514 auto quick db
 515 auto quick quota
+516 repair
-- 
2.18.4

