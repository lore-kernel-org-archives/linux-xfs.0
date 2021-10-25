Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB0AC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Oct 2021 13:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54EB461057
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Oct 2021 13:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhJYNDU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Oct 2021 09:03:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233387AbhJYNDT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Oct 2021 09:03:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635166857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZxtG0q9XZ9CoVKCRbL+ehUfbFkmT7EaPte/qKWaXens=;
        b=MWlapGCEHWRHwVkARp7c9AKDWrJZreVnEfA7bGVqA/Uj+kl4faNcqjye5VfYoRp2jdD7KS
        01RHuFDsdBIIeIlkoY/ZWMPB0IxrMrJc8LrxexpTvURUnsNTfKRGqAuSdonnH47KM/L3ju
        elNVSP6H/oFbahMpu/vs0xryZRVr25Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-u2Egelu9NOG4NJo89lyOnA-1; Mon, 25 Oct 2021 09:00:56 -0400
X-MC-Unique: u2Egelu9NOG4NJo89lyOnA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D61C5100F943;
        Mon, 25 Oct 2021 13:00:54 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45AC8171FF;
        Mon, 25 Oct 2021 13:00:54 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] tests/xfs: test COW writeback failure when overlapping non-shared blocks
Date:   Mon, 25 Oct 2021 09:00:53 -0400
Message-Id: <20211025130053.8343-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Test that COW writeback that overlaps non-shared delalloc blocks
does not leave around stale delalloc blocks on I/O failure. This
triggers assert failures and free space accounting corruption on
XFS.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Explicitly set COW extent size hint.
- Move to tests/xfs.
- Various minor cleanups.
v1: https://lore.kernel.org/fstests/20211021163959.1887011-1-bfoster@redhat.com/

 tests/xfs/999     | 62 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |  2 ++
 2 files changed, 64 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 00000000..f27972bc
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,62 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 999
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
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "cowextsize"
+_require_flakey_with_error_writes
+
+_scratch_mkfs >> $seqres.full
+_init_flakey
+_mount_flakey
+
+blksz=$(_get_file_block_size $SCRATCH_MNT)
+
+# Set the COW extent size hint to guarantee COW fork preallocation occurs over a
+# bordering block offset.
+$XFS_IO_PROG -c "cowextsize $((blksz * 2))" $SCRATCH_MNT >> $seqres.full
+
+# create two files that share a single block
+$XFS_IO_PROG -fc "pwrite $blksz $blksz" $SCRATCH_MNT/file1 >> $seqres.full
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+
+# Perform a buffered write across the shared and non-shared blocks. On XFS, this
+# creates a COW fork extent that covers the shared block as well as the just
+# created non-shared delalloc block. Fail the writeback to verify that all
+# delayed allocation is cleaned up properly.
+_load_flakey_table $FLAKEY_ERROR_WRITES
+$XFS_IO_PROG -c "pwrite 0 $((blksz * 2))" \
+	-c fsync $SCRATCH_MNT/file2 >> $seqres.full
+_load_flakey_table $FLAKEY_ALLOW_WRITES
+
+# Try a post-fail reflink and then unmount. Both of these are known to produce
+# errors and/or assert failures on XFS if we trip over a stale delalloc block.
+_cp_reflink $SCRATCH_MNT/file2 $SCRATCH_MNT/file3
+_unmount_flakey
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 00000000..88b69c4c
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+fsync: Input/output error
-- 
2.31.1

