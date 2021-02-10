Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D68DC433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 17:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD95764E15
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 17:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhBJRIM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 12:08:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230005AbhBJRIF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Feb 2021 12:08:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612976796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wf8zkafown8gQ/K/b9ZcsmxUxUswF899Aa2mZ1SQwwk=;
        b=McjIA9xELEipeY94obisWYJjVkheGYgBUJO2Hz/iQQErRB1aHxdMxoza5qN2R5kgzt8D3i
        7+eMmS6ym56ZS5KFPEEYVaoYK/41fFiNzrYLvZnEsBLtBoezx7kqnlcorQIcw2U8RXLdXd
        /40Wn7lfMaHYi7rDdTu00RdWF5iXoDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-J6N-jvOFNP2EG8hMEl3QrQ-1; Wed, 10 Feb 2021 12:06:30 -0500
X-MC-Unique: J6N-jvOFNP2EG8hMEl3QrQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BC4310CE786;
        Wed, 10 Feb 2021 17:06:29 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07AD95D9D0;
        Wed, 10 Feb 2021 17:06:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] generic: test mapped write after shutdown and failed writeback
Date:   Wed, 10 Feb 2021 12:06:28 -0500
Message-Id: <20210210170628.173200-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS has a regression where it failed to check shutdown status in the
write fault path. This produced an iomap warning if the page
happened to recently fail a writeback attempt because writeback
failure can clear Uptodate status on the page. Add a test for this
scenario to help ensure mapped write failures are handled as
expected in the event of filesystem shutdown.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Note that this test currently fails on XFS. The fix is posted for review
on linux-xfs:

https://lore.kernel.org/linux-xfs/20210210170112.172734-1-bfoster@redhat.com/

Brian

 tests/generic/999     | 45 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  4 ++++
 tests/generic/group   |  1 +
 3 files changed, 50 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..5e5408e7
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright 2021 Red Hat, Inc.
+#
+# FS QA Test No. 999
+#
+# Test a write fault scenario on a shutdown fs.
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
+	rm -f $tmp.*
+}
+
+. ./common/rc
+. ./common/filter
+
+rm -f $seqres.full
+
+_supported_fs generic
+_require_scratch_nocheck
+_require_scratch_shutdown
+
+_scratch_mkfs &>> $seqres.full
+_scratch_mount
+
+# XFS had a regression where it failed to check shutdown status in the fault
+# path. This produced an iomap warning because writeback failure clears Uptodate
+# status on the page.
+file=$SCRATCH_MNT/file
+$XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
+$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
+	-c "mwrite 0 4k" $file | _filter_xfs_io
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..f55569ff
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,4 @@
+QA output created by 999
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+fsync: Input/output error
diff --git a/tests/generic/group b/tests/generic/group
index b10fdea4..edd54ce5 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -625,3 +625,4 @@
 620 auto mount quick
 621 auto quick encrypt
 622 auto shutdown metadata atime
+999 auto quick shutdown
-- 
2.26.2

