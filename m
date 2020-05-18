Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD04AC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 19:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B3C62083E
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 19:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zyu6IbFT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgERT7r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 15:59:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728592AbgERT7q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 15:59:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589831984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=O22ZnOhuK7BEfDMk0dHYXju3qO0/jFq1UCkPd5OWRsw=;
        b=Zyu6IbFT/zVW7agNSCpA4YdjNMYnIpr5RSPV40o3eiqA80alvRgk8l9SyJFrwBQ1YVIsXr
        W/aC9sWdU3vAa6UWOyv3s/oq/ybnH9gevxMU+dz8YqLOjql1d348uB/3Qt6bZ09gOvDcbI
        0Xyh3/JnUp4lo0ffcAN6XAv0wluw9Wg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-z3wKlkNQNnCrm6uEdGqqfg-1; Mon, 18 May 2020 15:59:41 -0400
X-MC-Unique: z3wKlkNQNnCrm6uEdGqqfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B4FB8018A5;
        Mon, 18 May 2020 19:59:40 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3527782A18;
        Mon, 18 May 2020 19:59:40 +0000 (UTC)
Subject: [PATCH 1/4] xfs: make sure our default quota warning limits and grace
 periods survive quotacheck
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <9c9a63f3-13ab-d5b6-923c-4ea684b6b2f8@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <4b264d49-c5d4-4e0f-3710-38a3e0c321a1@redhat.com>
Date:   Mon, 18 May 2020 14:59:39 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <9c9a63f3-13ab-d5b6-923c-4ea684b6b2f8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Make sure that the default quota grace period and maximum warning limits
set by the administrator survive quotacheck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 tests/xfs/900     | 69 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/900.out | 13 +++++++++
 tests/xfs/group   |  1 +
 3 files changed, 83 insertions(+)
 create mode 100755 tests/xfs/900
 create mode 100644 tests/xfs/900.out

diff --git a/tests/xfs/900 b/tests/xfs/900
new file mode 100755
index 00000000..106a7367
--- /dev/null
+++ b/tests/xfs/900
@@ -0,0 +1,69 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 900
+#
+# Make sure that the quota default grace period and maximum warning limits
+# survive quotacheck.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
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
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_quota
+
+rm -f $seqres.full
+
+# Format filesystem and set up quota limits
+_scratch_mkfs > $seqres.full
+_qmount_option "usrquota"
+_scratch_mount >> $seqres.full
+
+$XFS_QUOTA_PROG -x -c 'timer -u 300m' $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+_scratch_unmount
+
+# Remount and check the limits
+_scratch_mount >> $seqres.full
+$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+_scratch_unmount
+
+# Run repair to force quota check
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+# Remount (this time to run quotacheck) and check the limits.  There's a bug
+# in quotacheck where we would reset the ondisk default grace period to zero
+# while the incore copy stays at whatever was read in prior to quotacheck.
+# This will show up after the /next/ remount.
+_scratch_mount >> $seqres.full
+$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+_scratch_unmount
+
+# Remount and check the limits
+_scratch_mount >> $seqres.full
+$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/900.out b/tests/xfs/900.out
new file mode 100644
index 00000000..90d0482c
--- /dev/null
+++ b/tests/xfs/900.out
@@ -0,0 +1,13 @@
+QA output created by 900
+Blocks grace time: [0 days 05:00:00]
+Inodes grace time: [0 days 05:00:00]
+Realtime Blocks grace time: [0 days 05:00:00]
+Blocks grace time: [0 days 05:00:00]
+Inodes grace time: [0 days 05:00:00]
+Realtime Blocks grace time: [0 days 05:00:00]
+Blocks grace time: [0 days 05:00:00]
+Inodes grace time: [0 days 05:00:00]
+Realtime Blocks grace time: [0 days 05:00:00]
+Blocks grace time: [0 days 05:00:00]
+Inodes grace time: [0 days 05:00:00]
+Realtime Blocks grace time: [0 days 05:00:00]
diff --git a/tests/xfs/group b/tests/xfs/group
index 12eb55c9..0818c5c6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -513,3 +513,4 @@
 513 auto mount
 514 auto quick db
 515 auto quick quota
+900 auto quick quota
-- 
2.17.0


