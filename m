Return-Path: <SRS0=WYbU=5O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D38C2D0F0
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 05:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B87C20776
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 05:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y8bOORtL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgC2FSO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 01:18:14 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:44040 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbgC2FSO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 01:18:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585459091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Kz8YPBjTlRKU/qW4zYNZuHy1gi+mQVUUrmlnJZPZXjg=;
        b=Y8bOORtLLkoZazq4nhTwiXRWHSGXiA/UYhnvNd1+4K1mpIMoPkLWIN9FwqCIKExXZPO/2u
        7Bz3YYcbW6d7HugKjsyrBLNJebrz4fw5GHuo7xlFTrGU5RgkjHtfjJZATqzyMXpFsjqR0g
        iHngEgdCS1U+H1j8gKhBdM2+oosxIWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-Fob6KQChOQuwO2-ntHj7mw-1; Sun, 29 Mar 2020 01:18:07 -0400
X-MC-Unique: Fob6KQChOQuwO2-ntHj7mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42B76800D5B;
        Sun, 29 Mar 2020 05:18:06 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-124.pek2.redhat.com [10.72.12.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 025931001B2B;
        Sun, 29 Mar 2020 05:18:04 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3] generic: per-type quota timers set/get test
Date:   Sun, 29 Mar 2020 13:18:01 +0800
Message-Id: <20200329051801.8363-1-zlang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

V2 did below changes:
1) Filter default quota timer (suggested by Eric Sandeen).
2) Try to merge the case from Darrick (please review):
https://marc.info/?l=3Dfstests&m=3D158207247224104&w=3D2

V3 did below changes:
1) _require_scratch_xfs_crc if tests on XFS (suggested by Eryu Guan)

Thanks,
Zorro

 tests/generic/594     | 108 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/594.out |  50 +++++++++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 159 insertions(+)
 create mode 100755 tests/generic/594
 create mode 100644 tests/generic/594.out

diff --git a/tests/generic/594 b/tests/generic/594
new file mode 100755
index 00000000..e501d54c
--- /dev/null
+++ b/tests/generic/594
@@ -0,0 +1,108 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 594
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
+# V4 XFS doesn't support to mount project and group quota together
+if [ "$FSTYP" =3D "xfs" ];then
+	_require_scratch_xfs_crc
+fi
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
+# get default time at first
+def_time=3D`repquota -u $SCRATCH_MNT | \
+		sed -n -e "/^Block/s/.* time: \(.*\); .* time: \(.*\)/\1 \2/p"`
+echo "Default block and inode grace timers are: $def_time" >> $seqres.fu=
ll
+
+filter_repquota()
+{
+	local blocktime=3D$1
+	local inodetime=3D$2
+
+	_filter_scratch | sed -e "s,$blocktime,DEF_TIME,g" \
+			      -e "s,$inodetime,DEF_TIME,g"
+}
+
+echo "1. set project quota timer"
+setquota -t -P $((10 * MIN)) $((20 * MIN)) $SCRATCH_MNT
+repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $de=
f_time
+echo
+
+echo "2. set group quota timer"
+setquota -t -g $((30 * MIN)) $((40 * MIN)) $SCRATCH_MNT
+repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $de=
f_time
+echo
+
+echo "3. set user quota timer"
+setquota -t -u $((50 * MIN)) $((60 * MIN)) $SCRATCH_MNT
+repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $de=
f_time
+echo
+
+# cycle mount, make sure the quota timers are still right
+echo "4. cycle mount test-1"
+_qmount
+repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $de=
f_time
+echo
+
+# Run repair to force quota check
+echo "5. fsck to force quota check"
+_scratch_unmount
+_repair_scratch_fs >> $seqres.full 2>&1
+echo
+
+# Remount (this time to run quotacheck) and check the limits.  There's a=
 bug
+# in quotacheck where we would reset the ondisk default grace period to =
zero
+# while the incore copy stays at whatever was read in prior to quotachec=
k.
+# This will show up after the /next/ remount.
+echo "6. cycle mount test-2"
+_qmount
+repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $de=
f_time
+echo
+
+# Remount and check the limits
+echo "7. cycle mount test-3"
+_qmount
+repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $de=
f_time
+
+# success, all done
+status=3D0
+exit
diff --git a/tests/generic/594.out b/tests/generic/594.out
new file mode 100644
index 00000000..f25e0fac
--- /dev/null
+++ b/tests/generic/594.out
@@ -0,0 +1,50 @@
+QA output created by 594
+1. set project quota timer
+*** Report for user quotas on device SCRATCH_DEV
+Block grace time: DEF_TIME; Inode grace time: DEF_TIME
+*** Report for group quotas on device SCRATCH_DEV
+Block grace time: DEF_TIME; Inode grace time: DEF_TIME
+*** Report for project quotas on device SCRATCH_DEV
+Block grace time: 00:10; Inode grace time: 00:20
+
+2. set group quota timer
+*** Report for user quotas on device SCRATCH_DEV
+Block grace time: DEF_TIME; Inode grace time: DEF_TIME
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
+4. cycle mount test-1
+*** Report for user quotas on device SCRATCH_DEV
+Block grace time: 00:50; Inode grace time: 01:00
+*** Report for group quotas on device SCRATCH_DEV
+Block grace time: 00:30; Inode grace time: 00:40
+*** Report for project quotas on device SCRATCH_DEV
+Block grace time: 00:10; Inode grace time: 00:20
+
+5. fsck to force quota check
+
+6. cycle mount test-2
+*** Report for user quotas on device SCRATCH_DEV
+Block grace time: 00:50; Inode grace time: 01:00
+*** Report for group quotas on device SCRATCH_DEV
+Block grace time: 00:30; Inode grace time: 00:40
+*** Report for project quotas on device SCRATCH_DEV
+Block grace time: 00:10; Inode grace time: 00:20
+
+7. cycle mount test-3
+*** Report for user quotas on device SCRATCH_DEV
+Block grace time: 00:50; Inode grace time: 01:00
+*** Report for group quotas on device SCRATCH_DEV
+Block grace time: 00:30; Inode grace time: 00:40
+*** Report for project quotas on device SCRATCH_DEV
+Block grace time: 00:10; Inode grace time: 00:20
diff --git a/tests/generic/group b/tests/generic/group
index dc95b77b..a83f95cb 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -595,3 +595,4 @@
 591 auto quick rw pipe splice
 592 auto quick encrypt
 593 auto quick encrypt
+594 auto quick quota
--=20
2.20.1

