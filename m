Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8312C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 16:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC8206138D
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 16:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhJUQmT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 12:42:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhJUQmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Oct 2021 12:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634834403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=grdzU5cJ1VaO4NivgFFBYAsl/r2DD1sdXLgcbXPAYGo=;
        b=HJig5uCyflHRdV6bpdOtmHRpCeHU0XtA6rKtS+VimFhyXiQCBfVDf1CNNycFek57LQ+qnj
        aDJZaRfTT9lEGUHt9R0DVOVVecsvAsDxa9Jsv13VyPPzSVcQq1MUhKMfprQPTqNm7YeMXh
        pcI9rhxVbm85phMW0kG4Crt1bbiJvAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-uhKMmNHkN0yWb6TyeTR7JQ-1; Thu, 21 Oct 2021 12:40:01 -0400
X-MC-Unique: uhKMmNHkN0yWb6TyeTR7JQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3CFE5074C;
        Thu, 21 Oct 2021 16:40:00 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 434865F4ED;
        Thu, 21 Oct 2021 16:40:00 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] generic: test COW writeback failure when overlapping non-shared blocks
Date:   Thu, 21 Oct 2021 12:39:59 -0400
Message-Id: <20211021163959.1887011-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Test that COW writeback that overlaps non-shared delalloc blocks
does not leave around stale delalloc blocks on I/O failure. This
triggers assert failures and free space accounting corruption on
XFS.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This test targets the problem addressed by the following patch in XFS:

https://lore.kernel.org/linux-xfs/20211021163330.1886516-1-bfoster@redhat.com/

Brian

 tests/generic/651     | 53 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/651.out |  2 ++
 2 files changed, 55 insertions(+)
 create mode 100755 tests/generic/651
 create mode 100644 tests/generic/651.out

diff --git a/tests/generic/651 b/tests/generic/651
new file mode 100755
index 00000000..8d4e6728
--- /dev/null
+++ b/tests/generic/651
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 651
+#
+# Test that COW writeback that overlaps non-shared delalloc blocks does not
+# leave around stale delalloc blocks on I/O failure. This triggers assert
+# failures and free space accounting corruption on XFS.
+#
+. ./common/preamble
+_begin_fstest auto quick clone
+
+_cleanup()
+{
+	_cleanup_flakey
+	cd /
+	rm -r -f $tmp.*
+}
+
+# Import common functions.
+. ./common/reflink
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch_reflink
+_require_flakey_with_error_writes
+
+_scratch_mkfs >> $seqres.full
+_init_flakey
+_mount_flakey
+
+# create two files that share a single block
+$XFS_IO_PROG -fc "pwrite 4k 4k" $SCRATCH_MNT/file1 >> $seqres.full
+cp --reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+
+# Perform a buffered write across the shared and non-shared blocks. On XFS, this
+# creates a COW fork extent that covers the shared block as well as the just
+# created non-shared delalloc block. Fail the writeback to verify that all
+# delayed allocation is cleaned up properly.
+_load_flakey_table $FLAKEY_ERROR_WRITES
+$XFS_IO_PROG -c "pwrite 0 8k" -c fsync $SCRATCH_MNT/file2 >> $seqres.full
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+
+# Try a post-fail reflink and then unmount. Both of these are known to produce
+# errors and/or assert failures on XFS if we trip over a stale delalloc block.
+cp --reflink $SCRATCH_MNT/file2 $SCRATCH_MNT/file3
+_unmount_flakey
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/651.out b/tests/generic/651.out
new file mode 100644
index 00000000..bd44c80c
--- /dev/null
+++ b/tests/generic/651.out
@@ -0,0 +1,2 @@
+QA output created by 651
+fsync: Input/output error
-- 
2.31.1

