Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEDCCA9EC3
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 17:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 688A82086A
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 17:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KAnDt5Ey"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfJ2Rxz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 13:53:55 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45059 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726836AbfJ2Rxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 13:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572371633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iSewc866B7Y6BxWeJ8OSa2+7VUnFT75DYx53kAp7xx0=;
        b=KAnDt5Ey1gHxhOpxD3178vXwzuc0ER0Hsk4v70oXhJhyTC2uWgJq0+CliR+0RdKBfJ0PHl
        gqTtIhb6chL1bSTO755ERmkAu0amF3h3nEVWsKr4GJVnTRhWv8TCb7Wp7lanFz3KQrFkbp
        uNu8opcA2CpV6QOlq2sOLFXpoaq3E+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-gYvwtlvvNe2v5xyvvCfJQg-1; Tue, 29 Oct 2019 13:53:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4959C1800D56;
        Tue, 29 Oct 2019 17:53:49 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EECA8608E7;
        Tue, 29 Oct 2019 17:53:48 +0000 (UTC)
To:     fstests <fstests@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fstests: verify that xfs_growfs can operate on mounted device
 node
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <1253fd24-a0ef-26ca-6ff9-b3b7a451e78a@redhat.com>
Date:   Tue, 29 Oct 2019 12:53:48 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
MIME-Version: 1.0
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: gYvwtlvvNe2v5xyvvCfJQg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The ability to use a mounted device node as the primary argument
to xfs_growfs will be added back in, because it was an undocumented
behavior that some userspace depended on.  This test exercises that
functionality.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/xfs/148 b/tests/xfs/148
new file mode 100755
index 00000000..357ae01c
--- /dev/null
+++ b/tests/xfs/148
@@ -0,0 +1,100 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 148
+#
+# Test to ensure xfs_growfs command accepts device nodes if & only
+# if they are mounted.
+# This functionality, though undocumented, worked until xfsprogs v4.12
+# It was added back and documented after xfsprogs v5.2
+#
+# Based on xfs/289
+#
+seq=3D`basename $0`
+seqres=3D$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=3D`pwd`
+tmp=3D/tmp/$$
+status=3D1=09# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    $UMOUNT_PROG $mntdir
+    _destroy_loop_device $loop_dev
+    rmdir $mntdir
+    rm -f $loop_symlink
+    rm -f $loopfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_test
+_require_loop
+
+loopfile=3D$TEST_DIR/fsfile
+mntdir=3D$TEST_DIR/mntdir
+loop_symlink=3D$TEST_DIR/loop_symlink.$$
+
+mkdir -p $mntdir || _fail "!!! failed to create temp mount dir"
+
+echo "=3D=3D=3D mkfs.xfs =3D=3D=3D"
+$MKFS_XFS_PROG -d file,name=3D$loopfile,size=3D16m -f >/dev/null 2>&1
+
+echo "=3D=3D=3D truncate =3D=3D=3D"
+$XFS_IO_PROG -fc "truncate 256m" $loopfile
+
+echo "=3D=3D=3D create loop device =3D=3D=3D"
+loop_dev=3D$(_create_loop_device $loopfile)
+
+echo "=3D=3D=3D create loop device symlink =3D=3D=3D"
+ln -s $loop_dev $loop_symlink
+
+echo "loop device is $loop_dev"
+
+# These unmounted operations should fail
+
+echo "=3D=3D=3D xfs_growfs - unmounted device, command should be rejected =
=3D=3D=3D"
+$XFS_GROWFS_PROG $loop_dev 2>&1 | sed -e s:$loop_dev:LOOPDEV:
+
+echo "=3D=3D=3D xfs_growfs - check symlinked dev, unmounted =3D=3D=3D"
+$XFS_GROWFS_PROG $loop_symlink 2>&1 | sed -e s:$loop_symlink:LOOPSYMLINK:
+
+# These mounted operations should pass
+
+echo "=3D=3D=3D mount =3D=3D=3D"
+$MOUNT_PROG $loop_dev $mntdir || _fail "!!! failed to loopback mount"
+
+echo "=3D=3D=3D xfs_growfs - check device node =3D=3D=3D"
+$XFS_GROWFS_PROG -D 8192 $loop_dev > /dev/null
+
+echo "=3D=3D=3D xfs_growfs - check device symlink =3D=3D=3D"
+$XFS_GROWFS_PROG -D 12288 $loop_symlink > /dev/null
+
+echo "=3D=3D=3D unmount =3D=3D=3D"
+$UMOUNT_PROG $mntdir || _fail "!!! failed to unmount"
+
+echo "=3D=3D=3D mount device symlink =3D=3D=3D"
+$MOUNT_PROG $loop_symlink $mntdir || _fail "!!! failed to loopback mount"
+
+echo "=3D=3D=3D xfs_growfs - check device symlink =3D=3D=3D"
+$XFS_GROWFS_PROG -D 16384 $loop_symlink > /dev/null
+
+echo "=3D=3D=3D xfs_growfs - check device node =3D=3D=3D"
+$XFS_GROWFS_PROG -D 20480 $loop_dev > /dev/null
+
+# success, all done
+status=3D0
+exit
diff --git a/tests/xfs/148.out b/tests/xfs/148.out
new file mode 100644
index 00000000..d8e6f02d
--- /dev/null
+++ b/tests/xfs/148.out
@@ -0,0 +1,17 @@
+QA output created by 148
+=3D=3D=3D mkfs.xfs =3D=3D=3D
+=3D=3D=3D truncate =3D=3D=3D
+=3D=3D=3D create loop device =3D=3D=3D
+=3D=3D=3D create loop device symlink =3D=3D=3D
+loop device is /dev/loop0
+=3D=3D=3D xfs_growfs - unmounted device, command should be rejected =3D=3D=
=3D
+xfs_growfs: LOOPDEV is not a mounted XFS filesystem
+=3D=3D=3D xfs_growfs - check symlinked dev, unmounted =3D=3D=3D
+xfs_growfs: LOOPSYMLINK is not a mounted XFS filesystem
+=3D=3D=3D mount =3D=3D=3D
+=3D=3D=3D xfs_growfs - check device node =3D=3D=3D
+=3D=3D=3D xfs_growfs - check device symlink =3D=3D=3D
+=3D=3D=3D unmount =3D=3D=3D
+=3D=3D=3D mount device symlink =3D=3D=3D
+=3D=3D=3D xfs_growfs - check device symlink =3D=3D=3D
+=3D=3D=3D xfs_growfs - check device node =3D=3D=3D
diff --git a/tests/xfs/group b/tests/xfs/group
index f4ebcd8c..40a61b55 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -145,6 +145,7 @@
 145 dmapi
 146 dmapi
 147 dmapi
+148 quick auto growfs
 150 dmapi
 151 dmapi
 152 dmapi

