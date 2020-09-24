Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B347C4727D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 18:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2193D2220C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 18:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OX+Q29hE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgIXSTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 14:19:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51961 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728666AbgIXSTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 14:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600971593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PNFDhRkiEfQGHLhKd3cGNS0NyucRKF3B38ZZ1mHi0TI=;
        b=OX+Q29hEISeFw6LUsU3nwEw100qbun0FOdox6LHV+4oyAgVaLaakrfONEX2YQrCJVOncUS
        nA7cJAkd+opte2W2j5dnT/w2dlr8DM6DUkKQt2nSpeJRlcKukHlKWY54ITqB+SQZFwKivX
        LVa6ElFPw0pxZ9ZsgndUjc8+fe0bj/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-r9wkfMdNM-GtI9XL31L4Og-1; Thu, 24 Sep 2020 14:19:51 -0400
X-MC-Unique: r9wkfMdNM-GtI9XL31L4Og-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D33C894C0B;
        Thu, 24 Sep 2020 18:19:50 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 586767B7C4;
        Thu, 24 Sep 2020 18:19:50 +0000 (UTC)
To:     fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] generic: test reflinked file corruption after short COW
Message-ID: <b63354c6-795d-78e2-4002-83c08a373171@redhat.com>
Date:   Thu, 24 Sep 2020 13:19:49 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test essentially creates an existing COW extent which
covers the first 1M, and then does another IO that overlaps it,
but extends beyond it.  The bug was that we did not trim the
new IO to the end of the existing COW extent, and so the IO
extended past the COW blocks and corrupted the reflinked files(s).

The bug came and went upstream; it will be hopefully fixed in the
5.4.y stable series via:

https://lore.kernel.org/stable/e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com/

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/generic/612 b/tests/generic/612
new file mode 100755
index 00000000..5a765a0c
--- /dev/null
+++ b/tests/generic/612
@@ -0,0 +1,83 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 612
+#
+# Regression test for reflink corruption present as of:
+# 78f0cc9d55cb "xfs: don't use delalloc extents for COW on files with extsize hints"
+# and (inadvertently) fixed as of:
+# 36adcbace24e "xfs: fill out the srcmap in iomap_begin"
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_test
+_require_test_reflink
+
+DIR=$TEST_DIR/dir.$seq
+mkdir -p $DIR
+rm -f $DIR/a $DIR/b
+
+# This test essentially creates an existing COW extent which
+# covers the first 1M, and then does another IO that overlaps it,
+# but extends beyond it.  The bug was that we did not trim the
+# new IO to the end of the existing COW extent, and so the IO
+# extended past the COW blocks and corrupted the reflinked files(s).
+
+# Make all files w/ 1m hints; create original 2m file
+$XFS_IO_PROG -c "extsize 1048576" $DIR | _filter_xfs_io
+$XFS_IO_PROG -c "cowextsize 1048576" $DIR | _filter_xfs_io
+
+echo "Create file b"
+$XFS_IO_PROG -f -c "pwrite -S 0x0 0 2m" -c fsync $DIR/b | _filter_xfs_io
+
+# Make a reflinked copy
+echo "Reflink copy from b to a"
+cp --reflink=always $DIR/b $DIR/a
+
+echo "Contents of b"
+hexdump -C $DIR/b
+
+# Cycle mount to get stuff out of cache
+_test_cycle_mount
+
+# Create a 1m-hinted IO at offset 0, then
+# do another IO that overlaps but extends past the 1m hint
+echo "Write to a"
+$XFS_IO_PROG -c "pwrite -S 0xa 0k -b 4k 4k" \
+       -c "pwrite -S 0xa 4k -b 1m 1m" \
+       $DIR/a | _filter_xfs_io
+
+$XFS_IO_PROG -c fsync $DIR/a
+
+echo "Contents of b now:"
+hexdump -C $DIR/b
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/612.out b/tests/generic/612.out
new file mode 100644
index 00000000..237a9638
--- /dev/null
+++ b/tests/generic/612.out
@@ -0,0 +1,18 @@
+QA output created by 612
+Create file b
+wrote 2097152/2097152 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Reflink copy from b to a
+Contents of b
+00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
+*
+00200000
+Write to a
+wrote 4096/4096 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 1048576/1048576 bytes at offset 4096
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Contents of b now:
+00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
+*
+00200000
diff --git a/tests/generic/group b/tests/generic/group
index 4af4b494..bc115f21 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -614,3 +614,4 @@
 609 auto quick rw
 610 auto quick prealloc zero
 611 auto quick attr
+612 auto quick clone

