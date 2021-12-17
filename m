Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A73C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Dec 2021 17:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbhLQRSd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Dec 2021 12:18:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236241AbhLQRSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Dec 2021 12:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639761511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=F6UW9yvMuHD672+ggsz67AVxGGq70qZ2O214f3t7jYI=;
        b=MakOs82JC9R7ujo3buH1jwd8YQikQuAmL+ZxPq5GIAhxqPBWTGIbTsoXPc1EVr5FaLbk/B
        Dgg+30KifU69BTKvUfaovxJpTKQxM2KChya8NCEojl4XmN5Yh1AfyJMZ2Q7yn20Qr7s8OG
        KeIratbpLbBK0jY29EKngensMVXM5/k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-Vo_opWfFOOO7lbdE3EfhOw-1; Fri, 17 Dec 2021 12:18:28 -0500
X-MC-Unique: Vo_opWfFOOO7lbdE3EfhOw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C3771030C20;
        Fri, 17 Dec 2021 17:18:27 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.17.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBD251897E;
        Fri, 17 Dec 2021 17:18:26 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v4] tests/xfs: test COW writeback failure when overlapping non-shared blocks
Date:   Fri, 17 Dec 2021 12:18:26 -0500
Message-Id: <20211217171826.287114-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Test that COW writeback that overlaps non-shared delalloc blocks
does not leave around stale delalloc blocks on I/O failure. This
triggers assert failures and free space accounting corruption on
XFS.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---

v4:
- Move filename param of sync_range command.
v3: https://lore.kernel.org/fstests/20211217153234.279540-1-bfoster@redhat.com/
- Use fsync and sync_range to avoid spurious failure caused by log I/O
  errors.
- Add kernel commit reference.
v2: https://lore.kernel.org/fstests/20211025130053.8343-1-bfoster@redhat.com/
- Explicitly set COW extent size hint.
- Move to tests/xfs.
- Various minor cleanups.
v1: https://lore.kernel.org/fstests/20211021163959.1887011-1-bfoster@redhat.com/

 tests/xfs/999     | 67 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |  2 ++
 2 files changed, 69 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 00000000..9fc5d15f
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,67 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 999
+#
+# Test that COW writeback that overlaps non-shared delalloc blocks does not
+# leave around stale delalloc blocks on I/O failure. This triggers assert
+# failures and free space accounting corruption on XFS. Fixed by upstream kernel
+# commit 5ca5916b6bc9 ("xfs: punch out data fork delalloc blocks on COW
+# writeback failure").
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
+$XFS_IO_PROG -fc "reflink $SCRATCH_MNT/file1" \
+	-c fsync $SCRATCH_MNT/file2 >> $seqres.full
+
+# Perform a buffered write across the shared and non-shared blocks. On XFS, this
+# creates a COW fork extent that covers the shared block as well as the just
+# created non-shared delalloc block. Fail the writeback to verify that all
+# delayed allocation is cleaned up properly.
+_load_flakey_table $FLAKEY_ERROR_WRITES
+len=$((blksz * 2))
+$XFS_IO_PROG -c "pwrite 0 $len" \
+	-c "sync_range -w 0 $len" \
+	-c "sync_range -a 0 $len" $SCRATCH_MNT/file2 >> $seqres.full
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
index 00000000..95d64cf0
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+sync_file_range: Input/output error
-- 
2.31.1

