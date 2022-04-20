Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21553C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 08:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376775AbiDTIkN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376778AbiDTIkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 04:40:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37AF52A246
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 01:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650443846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uh84sS/8t/iuqJUetVOeGZv2ET8jMRq4FlxqlOZfNYs=;
        b=cqnoL65kXsGM9xGWnDDGnAaGk4w/uGdY8CZDpZRAyOTHTeZxebM9ar2pPzZiAPYMyLh6nj
        na6DTenU9MFhJ+Ps9oB1QmiSh/3G+QPF/P66ItP5vPHlG9eSBl/+DMADIHnZF86/rTAR0u
        ggP9lW/CiAw3IFiCp11N7MZbBDAKTNU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-smoeiskxNmyzuP35I9vJdw-1; Wed, 20 Apr 2022 04:37:23 -0400
X-MC-Unique: smoeiskxNmyzuP35I9vJdw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA3A9299E744;
        Wed, 20 Apr 2022 08:37:22 +0000 (UTC)
Received: from zlang-laptop.redhat.com (ovpn-12-143.pek2.redhat.com [10.72.12.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52C89404E4B1;
        Wed, 20 Apr 2022 08:37:21 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] generic: test data corruption when blocksize < pagesize for mmaped data
Date:   Wed, 20 Apr 2022 16:36:52 +0800
Message-Id: <20220420083653.1031631-4-zlang@redhat.com>
In-Reply-To: <20220420083653.1031631-1-zlang@redhat.com>
References: <20220420083653.1031631-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

page_mkwrite() is used by filesystems to allocate blocks under a page
which is becoming writeably mmapped in some process' address space.
This allows a filesystem to return a page fault if there is not enough
space available, user exceeds quota or similar problem happens, rather
than silently discarding data later when writepage is called. However
VFS fails to call ->page_mkwrite() in all the cases where filesystems
need it when blocksize < pagesize.

At the moment page_mkwrite() is called, filesystem can allocate only
one block for the page if i_size < page size. Otherwise it would
create blocks beyond i_size which is generally undesirable. But later
at writepage() time, we also need to store data at offset 4095 but we
don't have block allocated for it.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 tests/generic/999     | 75 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  5 +++
 2 files changed, 80 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..f1b65982
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,75 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat Inc.  All Rights Reserved.
+#
+# FS QA Test 999
+#
+# Regression test for linux commit 90a80202 ("data corruption when
+# blocksize < pagesize for mmaped data")
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch
+_require_block_device $SCRATCH_DEV
+_require_xfs_io_command mmap "-s <size>"
+_require_xfs_io_command mremap
+_require_xfs_io_command truncate
+_require_xfs_io_command mwrite
+
+sector_size=`_min_dio_alignment $SCRATCH_DEV`
+page_size=$(get_page_size)
+block_size=$((page_size/2))
+if [ $sector_size -gt $block_size ];then
+	_notrun "need sector size < page size"
+fi
+
+unset MKFS_OPTIONS
+# For save time, 512MiB is enough to reproduce bug
+_scratch_mkfs_sized 536870912 $block_size >$seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+# take one block size space
+$XFS_IO_PROG -f -t -c "pwrite 0 $block_size" $SCRATCH_MNT/testfile >>$seqres.full 2>&1
+
+# Fill all free space, dd can keep writing until no space. Note: if the fs
+# isn't be full, this test will fail.
+for ((i=0; i<2; i++));do
+	dd if=/dev/zero of=$SCRATCH_MNT/full bs=$block_size >>$seqres.full 2>&1
+	_scratch_cycle_mount
+done
+
+# truncate 0
+# pwrite -S 0x61 0 $block_size
+# mmap -rw -s $((page_size * 2)) 0 $block_size
+# mwrite -S 0x61 0 1  --> page_mkwrite() for index 0 is called
+# truncate $((page_size * 2))
+# mremap $((page_size * 2))
+# mwrite -S 0x61 $((page_size - 1)) 1  --> [bug] no page_mkwrite() called
+#
+# If there's a bug, the last step will be killed by SIGBUS, and it won't
+# write a "0x61" on the disk.
+#
+# Note: mremap maybe failed when memory load is heavy.
+$XFS_IO_PROG -f \
+             -c "truncate 0" \
+             -c "pwrite -S 0x61 0 $block_size" \
+             -c "mmap -rw -s $((page_size * 2)) 0 $block_size" \
+             -c "mwrite -S 0x61 0 1" \
+             -c "truncate $((page_size * 2))" \
+             -c "mremap $((page_size * 2))" \
+             -c "mwrite -S 0x61 $((page_size - 1)) 1" \
+             $SCRATCH_MNT/testfile | _filter_xfs_io
+
+# we will see 0x61 written by "mwrite -S 0x61 0 1", but we shouldn't see one
+# more 0x61 by the last mwrite (except this fs isn't be full, or a bug)
+od -An -c $SCRATCH_MNT/testfile
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..f1c59e83
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,5 @@
+QA output created by 999
+   a   a   a   a   a   a   a   a   a   a   a   a   a   a   a   a
+*
+  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0  \0
+*
-- 
2.31.1

