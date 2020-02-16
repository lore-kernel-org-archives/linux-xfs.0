Return-Path: <SRS0=TKlC=4E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175CEC76199
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Feb 2020 18:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA93E20857
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Feb 2020 18:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNBTr2mD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgBPSQs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 Feb 2020 13:16:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21328 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725993AbgBPSQs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Feb 2020 13:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581877007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=S8gClrM/f6niNMYvKhNQbJCmVh8vitWMsktaBkaysCA=;
        b=jNBTr2mDOx4PlllMJQgIFMxp078g5pb2oORwv8RFM3y5Mot3gv4nRYEvHeVgmgGkgTyFOV
        36WNV9pZfKrl0ufpzsxQEug9d78qgrFm0A67Uqbhuqt/8YIWSyYNCdIV9/oL3X6NJDRGCN
        Nhy7ORDIxE92XpkzvJCUV6JMZn6uuMc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-lZwDT2_3NSaIZ9S6mY1RjQ-1; Sun, 16 Feb 2020 13:16:42 -0500
X-MC-Unique: lZwDT2_3NSaIZ9S6mY1RjQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A06318017CC;
        Sun, 16 Feb 2020 18:16:41 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-51.pek2.redhat.com [10.72.12.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B11160BF1;
        Sun, 16 Feb 2020 18:16:37 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] generic: per-type quota timers set/get test
Date:   Mon, 17 Feb 2020 02:16:30 +0800
Message-Id: <20200216181631.22560-1-zlang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Set different grace time, make sure each of quota (user, group and
project) timers can be set (by setquota) and get (by repquota)
correctly.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

This case test passed on ext4, but on XFS (xfs-linux for-next branch with
Eric's patchset: [PATCH 0/4] xfs: enable per-type quota timers and warn l=
imits)
I got below different output:

# diff -u tests/generic/593.out results/generic/593.out.bad
--- tests/generic/593.out       2020-02-15 12:08:49.012651926 -0500
+++ results//generic/593.out.bad        2020-02-16 13:00:58.811815870 -05=
00
@@ -5,28 +5,28 @@
 *** Report for group quotas on device SCRATCH_DEV
 Block grace time: 7days; Inode grace time: 7days
 *** Report for project quotas on device SCRATCH_DEV
-Block grace time: 00:10; Inode grace time: 00:20
+Block grace time: 7days; Inode grace time: 7days
=20
 2. set group quota timer
 *** Report for user quotas on device SCRATCH_DEV
 Block grace time: 7days; Inode grace time: 7days
 *** Report for group quotas on device SCRATCH_DEV
-Block grace time: 00:30; Inode grace time: 00:40
+Block grace time: 7days; Inode grace time: 7days
 *** Report for project quotas on device SCRATCH_DEV
-Block grace time: 00:10; Inode grace time: 00:20
+Block grace time: 7days; Inode grace time: 7days
=20
 3. set user quota timer
 *** Report for user quotas on device SCRATCH_DEV
 Block grace time: 00:50; Inode grace time: 01:00
 *** Report for group quotas on device SCRATCH_DEV
-Block grace time: 00:30; Inode grace time: 00:40
+Block grace time: 00:50; Inode grace time: 01:00
 *** Report for project quotas on device SCRATCH_DEV
-Block grace time: 00:10; Inode grace time: 00:20
+Block grace time: 00:50; Inode grace time: 01:00
=20
 4. cycle mount
 *** Report for user quotas on device SCRATCH_DEV
 Block grace time: 00:50; Inode grace time: 01:00
 *** Report for group quotas on device SCRATCH_DEV
-Block grace time: 00:30; Inode grace time: 00:40
+Block grace time: 00:50; Inode grace time: 01:00
 *** Report for project quotas on device SCRATCH_DEV
-Block grace time: 00:10; Inode grace time: 00:20
+Block grace time: 00:50; Inode grace time: 01:00

This looks like totally wrong, can anyone help to take a look at it?

Thanks,
Zorro

 tests/generic/593     | 69 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/593.out | 32 ++++++++++++++++++++
 tests/generic/group   |  1 +
 3 files changed, 102 insertions(+)
 create mode 100755 tests/generic/593
 create mode 100644 tests/generic/593.out

diff --git a/tests/generic/593 b/tests/generic/593
new file mode 100755
index 00000000..fd695329
--- /dev/null
+++ b/tests/generic/593
@@ -0,0 +1,69 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 593
+#
+# Test per-type(user, group and project) filesystem quota timers, make s=
ure
+# each of grace time can be set/get properly.
+#
+seq=3D`basename $0`
+seqres=3D$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=3D`pwd`
+tmp=3D/tmp/$$
+status=3D1	# failure is the default!
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_quota
+
+_scratch_mkfs >$seqres.full 2>&1
+_scratch_enable_pquota
+_qmount_option "usrquota,grpquota,prjquota"
+_qmount
+_require_prjquota $SCRATCH_DEV
+
+MIN=3D60
+
+echo "1. set project quota timer"
+setquota -t -P $((10 * MIN)) $((20 * MIN)) $SCRATCH_MNT
+repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | _filter_scratch
+echo
+
+echo "2. set group quota timer"
+setquota -t -g $((30 * MIN)) $((40 * MIN)) $SCRATCH_MNT
+repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | _filter_scratch
+echo
+
+echo "3. set user quota timer"
+setquota -t -u $((50 * MIN)) $((60 * MIN)) $SCRATCH_MNT
+repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | _filter_scratch
+echo
+
+# cycle mount, make sure the quota timers are still right
+echo "4. cycle mount"
+_qmount
+repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | _filter_scratch
+
+# success, all done
+status=3D0
+exit
diff --git a/tests/generic/593.out b/tests/generic/593.out
new file mode 100644
index 00000000..71dfa224
--- /dev/null
+++ b/tests/generic/593.out
@@ -0,0 +1,32 @@
+QA output created by 593
+1. set project quota timer
+*** Report for user quotas on device SCRATCH_DEV
+Block grace time: 7days; Inode grace time: 7days
+*** Report for group quotas on device SCRATCH_DEV
+Block grace time: 7days; Inode grace time: 7days
+*** Report for project quotas on device SCRATCH_DEV
+Block grace time: 00:10; Inode grace time: 00:20
+
+2. set group quota timer
+*** Report for user quotas on device SCRATCH_DEV
+Block grace time: 7days; Inode grace time: 7days
+*** Report for group quotas on device SCRATCH_DEV
+Block grace time: 00:30; Inode grace time: 00:40
+*** Report for project quotas on device SCRATCH_DEV
+Block grace time: 00:10; Inode grace time: 00:20
+
+3. set user quota timer
+*** Report for user quotas on device SCRATCH_DEV
+Block grace time: 00:50; Inode grace time: 01:00
+*** Report for group quotas on device SCRATCH_DEV
+Block grace time: 00:30; Inode grace time: 00:40
+*** Report for project quotas on device SCRATCH_DEV
+Block grace time: 00:10; Inode grace time: 00:20
+
+4. cycle mount
+*** Report for user quotas on device SCRATCH_DEV
+Block grace time: 00:50; Inode grace time: 01:00
+*** Report for group quotas on device SCRATCH_DEV
+Block grace time: 00:30; Inode grace time: 00:40
+*** Report for project quotas on device SCRATCH_DEV
+Block grace time: 00:10; Inode grace time: 00:20
diff --git a/tests/generic/group b/tests/generic/group
index 6fe62505..637ae325 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -595,3 +595,4 @@
 590 auto prealloc preallocrw
 591 auto quick rw pipe splice
 592 auto quick encrypt
+593 auto quick quota
--=20
2.20.1

