Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64ADAC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 07:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 449B82072D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 07:53:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYbUpoFr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHQHxb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 03:53:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44865 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726631AbgHQHxa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 03:53:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597650808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=KmiZNdOD8iZALqKNjUB11REvcQUAuMP7cfDM6CADPaM=;
        b=UYbUpoFrS5st7IUNGfJRDI/G/8EeVyCEp9TnzVg0whwCHKuB1uc6Ck1gXlCPQ71346xdbX
        ekgpTfITJAeBkJEKbxFbQtNfNYEeqyK1/i3AN/LdsfnmdnGo4PbAT1TWnHK5BvRJQNXYyf
        SjDQEBBRUajfihmycJTh/0SE6ogxmwA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-I4N8YXtxP8qBXdxtf6PuQg-1; Mon, 17 Aug 2020 03:53:27 -0400
X-MC-Unique: I4N8YXtxP8qBXdxtf6PuQg-1
Received: by mail-pj1-f69.google.com with SMTP id gl22so9992095pjb.3
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 00:53:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KmiZNdOD8iZALqKNjUB11REvcQUAuMP7cfDM6CADPaM=;
        b=Yw0doYxrf1Hu97ptM667oM6pL4Q+v3XHzCadsOqqP89kxh4Qd9XK63WSU8SrzTXDrH
         a7bcab2wCqKrIeRJ7aXrIjIfawm803rxgPQqFrb6qmnhEflWeTL6U/sSvriJ0NR1zwE8
         Vo005MQaIGXrvy9W0jBcPuwHKx1VrEXWtNoONQN/0QkCrJszJCzSlU66RwWLMK9II2IP
         RM9UL70ldSvMJRdkNQw8OHraQP5oPDpDMMnSvg35C8rk/0OWp9QTHxKqFV6KiZbo2Bfo
         f7d6vB1J8322jTHsA2gSCo1X82qhniPPoAv7Q+jtlgS70HsvPe9mNj8IWiSB+lgPjLoH
         YdjQ==
X-Gm-Message-State: AOAM533GaFjEQW/fkSXWdsa1zV9Cgv8jR8cQWwrLMQqKD3EnHybB/swa
        x/39AVibFOVSw02v6ddKHdvqqt1pkJJYijoKdEdz+J2q72w7BBeUT6PBUtzAkv1eg1W26Xrfrbs
        JMOslUwAyRHkUa83kzCL1
X-Received: by 2002:aa7:9813:: with SMTP id e19mr10492302pfl.285.1597650805818;
        Mon, 17 Aug 2020 00:53:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkLXh3IIjcJzjuUKZdnGiozppVS9UGhDmM4DMA7MJw4Vlri98/Zt9K51HYHUAHHed/ntRuYA==
X-Received: by 2002:aa7:9813:: with SMTP id e19mr10492289pfl.285.1597650805511;
        Mon, 17 Aug 2020 00:53:25 -0700 (PDT)
Received: from don.com ([60.224.129.195])
        by smtp.gmail.com with ESMTPSA id v10sm18330875pff.192.2020.08.17.00.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 00:53:24 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Eryu Guan <guan@eryu.me>, Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v3] xfstests: add test for xfs_repair progress reporting
Date:   Mon, 17 Aug 2020 17:53:13 +1000
Message-Id: <20200817075313.1484879-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200524164648.GB3363@desktop>
References: <20200524164648.GB3363@desktop>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_repair's interval based progress has been broken for
some time, create a test based on dmdelay to stretch out
the time and use ag_stride to force parallelism.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
Changes since v2:
- Fix cleanup handling and function naming
- Added to auto group
Changes since v1:
- Use _scratch_xfs_repair
- Filter only repair output
- Make the filter more tolerant of whitespace and plurals
- Take golden output from 'xfs_repair: fix progress reporting'

 tests/xfs/521     | 75 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/521.out | 15 ++++++++++
 tests/xfs/group   |  1 +
 3 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/521
 create mode 100644 tests/xfs/521.out

diff --git a/tests/xfs/521 b/tests/xfs/521
new file mode 100755
index 00000000..c16c82bf
--- /dev/null
+++ b/tests/xfs/521
@@ -0,0 +1,75 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 521
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
+	rm -f $tmp.*
+	_cleanup_delay > /dev/null 2>&1
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
+filter_repair()
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
+        tee -a $seqres.full > $tmp.repair
+
+cat $tmp.repair | filter_repair | sort -u
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/521.out b/tests/xfs/521.out
new file mode 100644
index 00000000..03337083
--- /dev/null
+++ b/tests/xfs/521.out
@@ -0,0 +1,15 @@
+QA output created by 521
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
index ed0d389e..1c8ec5fa 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -517,3 +517,4 @@
 518 auto quick quota
 519 auto quick reflink
 520 auto quick reflink
+521 auto repair
-- 
2.18.4

