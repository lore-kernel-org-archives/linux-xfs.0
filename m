Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA9FC33CB2
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 08:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FABA24671
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 08:11:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D6VbDIl3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAOILo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 03:11:44 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50736 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728895AbgAOILo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 03:11:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579075903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YWkaZT2gQ+MW9PIDh5tQv2rUkQRnx1QrvifTmwvVkpk=;
        b=D6VbDIl37nV6Ail9gC/pFEzOE5vt8JHBp0CW1K5To4SLHggWSJQUbPr/FtyJmyuhbpBxjn
        LyZuEaLE8wIxR9hYSojOq1pNLJercVKS26XBYUaUWqqHebRDGvv6GObb3Vd+ncH7ZfCNpz
        wEbfH5+VSHGDfLsw2avR19ogKEiwwu8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-LjMfc2p7MSyGH6dXpybxjQ-1; Wed, 15 Jan 2020 03:11:40 -0500
X-MC-Unique: LjMfc2p7MSyGH6dXpybxjQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F13718A8C96;
        Wed, 15 Jan 2020 08:11:39 +0000 (UTC)
Received: from dhcp-13-153.nay.redhat.com (dhcp-13-153.nay.redhat.com [10.66.13.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCC6C5D9C5;
        Wed, 15 Jan 2020 08:11:37 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3] xfstests: xfs mount option sanity test
Date:   Wed, 15 Jan 2020 16:11:32 +0800
Message-Id: <20200115081132.22710-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS is changing to suit the new mount API, so add this case to make
sure the changing won't bring in regression issue on xfs mount option
parse phase, and won't change some default behaviors either.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

Thanks the suggestions from Darrick, v3 did below changes:
1) Add more debug info output in do_mkfs and do_test.
2) A new function filter_loop.
3) Update .out file content

I've simply run this case on RHEL-7, RHEL-8 and upstream 5.5-rc4 kernel,
all passed.

Thanks,

 tests/xfs/512     | 335 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/512.out | 100 ++++++++++++++
 tests/xfs/group   |   1 +
 3 files changed, 436 insertions(+)
 create mode 100755 tests/xfs/512
 create mode 100644 tests/xfs/512.out

diff --git a/tests/xfs/512 b/tests/xfs/512
new file mode 100755
index 00000000..4de07ab8
--- /dev/null
+++ b/tests/xfs/512
@@ -0,0 +1,335 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc. All Rights Reserved.
+#
+# FS QA Test No. 512
+#
+# XFS mount options sanity check, refer to 'man 5 xfs'.
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
+	$UMOUNT_PROG $LOOP_MNT 2>/dev/null
+	if [ -n "$LOOP_DEV" ];then
+		_destroy_loop_device $LOOP_DEV 2>/dev/null
+	fi
+	if [ -n "$LOOP_SPARE_DEV" ];then
+		_destroy_loop_device $LOOP_SPARE_DEV 2>/dev/null
+	fi
+	rm -f $LOOP_IMG
+	rm -f $LOOP_SPARE_IMG
+	rmdir $LOOP_MNT
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
+_supported_fs xfs
+_supported_os Linux
+_require_test
+_require_loop
+_require_xfs_io_command "falloc"
+
+LOOP_IMG=3D$TEST_DIR/$seq.dev
+LOOP_SPARE_IMG=3D$TEST_DIR/$seq.logdev
+LOOP_MNT=3D$TEST_DIR/$seq.mnt
+
+echo "** create loop device"
+$XFS_IO_PROG -f -c "falloc 0 1g" $LOOP_IMG
+LOOP_DEV=3D`_create_loop_device $LOOP_IMG`
+
+echo "** create loop log device"
+$XFS_IO_PROG -f -c "falloc 0 512m" $LOOP_SPARE_IMG
+LOOP_SPARE_DEV=3D`_create_loop_device $LOOP_SPARE_IMG`
+
+echo "** create loop mount point"
+rmdir $LOOP_MNT 2>/dev/null
+mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
+
+filter_loop()
+{
+	sed -e "s,\B$LOOP_MNT,LOOP_MNT,g" \
+	    -e "s,\B$LOOP_DEV,LOOP_DEV,g" \
+	    -e "s,\B$LOOP_SPARE_DEV,LOOP_SPARE_DEV,g"
+}
+
+# avoid the effection from MKFS_OPTIONS
+MKFS_OPTIONS=3D""
+do_mkfs()
+{
+	echo "FORMAT: $@" | filter_loop | tee -a $seqres.full
+	$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >>$seqres.full 2>$tmp.mkf=
s
+	if [ "${PIPESTATUS[0]}" -ne 0 ]; then
+		_fail "Fails on _mkfs_dev $* $LOOP_DEV"
+	fi
+	. $tmp.mkfs
+}
+
+is_dev_mounted()
+{
+	findmnt --source $LOOP_DEV >/dev/null
+	return $?
+}
+
+get_mount_info()
+{
+	findmnt --source $LOOP_DEV -o OPTIONS -n
+}
+
+force_unmount()
+{
+	$UMOUNT_PROG $LOOP_MNT >/dev/null 2>&1
+}
+
+# _do_test <mount options> <should be mounted?> [<key string> <key shoul=
d be found?>]
+_do_test()
+{
+	local opts=3D"$1"
+	local mounted=3D"$2"	# pass or fail
+	local key=3D"$3"
+	local found=3D"$4"	# true or false
+	local rc
+	local info
+
+	# mount test
+	_mount $LOOP_DEV $LOOP_MNT $opts 2>>$seqres.full
+	rc=3D$?
+	if [ $rc -eq 0 ];then
+		if [ "${mounted}" =3D "fail" ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: expect mount to fail, but it succeeded"
+			return 1
+		fi
+		is_dev_mounted
+		if [ $? -ne 0 ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: fs not mounted even mount return 0"
+			return 1
+		fi
+	else
+		if [ "${mounted}" =3D "pass" ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: expect mount to succeed, but it failed"
+			return 1
+		fi
+		is_dev_mounted
+		if [ $? -eq 0 ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: fs is mounted even mount return non-zero"
+			return 1
+		fi
+	fi
+
+	# Skip below checking if "$key" argument isn't specified
+	if [ -z "$key" ];then
+		return 0
+	fi
+	# Check the mount options after fs mounted.
+	info=3D`get_mount_info`
+	echo ${info} | grep -q "${key}"
+	rc=3D$?
+	if [ $rc -eq 0 ];then
+		if [ "$found" !=3D "true" ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: expected to find \"$key\" in mount info \"$info\""
+			return 1
+		fi
+	else
+		if [ "$found" !=3D "false" ];then
+			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+			echo "ERROR: did not expect to find \"$key\" in \"$info\""
+			return 1
+		fi
+	fi
+
+	return 0
+}
+
+do_test()
+{
+	# Print each argument, include nil ones
+	echo -n "TEST:" | tee -a $seqres.full
+	for i in "$@";do
+		echo -n " \"$i\"" | filter_loop | tee -a $seqres.full
+	done
+	echo | tee -a $seqres.full
+
+	# force unmount before testing
+	force_unmount
+	_do_test "$@"
+	# force unmount after testing
+	force_unmount
+}
+
+echo "** start xfs mount testing ..."
+# Test allocsize=3Dsize
+# Valid values for this option are page size (typically 4KiB) through to=
 1GiB
+do_mkfs
+if [ $dbsize -ge 1024 ];then
+	blsize=3D"$((dbsize / 1024))k"
+fi
+do_test "" pass "allocsize" "false"
+do_test "-o allocsize=3D$blsize" pass "allocsize=3D$blsize" "true"
+do_test "-o allocsize=3D1048576k" pass "allocsize=3D1048576k" "true"
+do_test "-o allocsize=3D$((dbsize / 2))" fail
+do_test "-o allocsize=3D2g" fail
+
+# Test attr2
+do_mkfs -m crc=3D1
+do_test "" pass "attr2" "true"
+do_test "-o attr2" pass "attr2" "true"
+do_test "-o noattr2" fail
+do_mkfs -m crc=3D0
+do_test "" pass "attr2" "true"
+do_test "-o attr2" pass "attr2" "true"
+do_test "-o noattr2" pass "attr2" "false"
+
+# Test discard
+do_mkfs
+do_test "" pass "discard" "false"
+do_test "-o discard" pass "discard" "true"
+do_test "-o nodiscard" pass "discard" "false"
+
+# Test grpid|bsdgroups|nogrpid|sysvgroups
+do_test "" pass "grpid" "false"
+do_test "-o grpid" pass "grpid" "true"
+do_test "-o bsdgroups" pass "grpid" "true"
+do_test "-o nogrpid" pass "grpid" "false"
+do_test "-o sysvgroups" pass "grpid" "false"
+
+# Test filestreams
+do_test "" pass "filestreams" "false"
+do_test "-o filestreams" pass "filestreams" "true"
+
+# Test ikeep
+do_test "" pass "ikeep" "false"
+do_test "-o ikeep" pass "ikeep" "true"
+do_test "-o noikeep" pass "ikeep" "false"
+
+# Test inode32|inode64
+do_test "" pass "inode64" "true"
+do_test "-o inode32" pass "inode32" "true"
+do_test "-o inode64" pass "inode64" "true"
+
+# Test largeio
+do_test "" pass "largeio" "false"
+do_test "-o largeio" pass "largeio" "true"
+do_test "-o nolargeio" pass "largeio" "false"
+
+# Test logbufs=3Dvalue. Valid numbers range from 2=E2=80=938 inclusive.
+# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_s=
ize)
+# prints "logbufs=3DN" in /proc/mounts, but old kernel not. So the defau=
lt
+# 'display' about logbufs can't be expected, disable this test.
+#do_test "" pass "logbufs" "false"
+do_test "-o logbufs=3D8" pass "logbufs=3D8" "true"
+do_test "-o logbufs=3D2" pass "logbufs=3D2" "true"
+do_test "-o logbufs=3D1" fail
+do_test "-o logbufs=3D9" fail
+do_test "-o logbufs=3D99999999999999" fail
+
+# Test logbsize=3Dvalue.
+do_mkfs -m crc=3D1 -l version=3D2
+# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_s=
ize)
+# prints "logbsize=3DN" in /proc/mounts, but old kernel not. So the defa=
ult
+# 'display' about logbsize can't be expected, disable this test.
+#do_test "" pass "logbsize" "false"
+do_test "-o logbsize=3D16384" pass "logbsize=3D16k" "true"
+do_test "-o logbsize=3D16k" pass "logbsize=3D16k" "true"
+do_test "-o logbsize=3D32k" pass "logbsize=3D32k" "true"
+do_test "-o logbsize=3D64k" pass "logbsize=3D64k" "true"
+do_test "-o logbsize=3D128k" pass "logbsize=3D128k" "true"
+do_test "-o logbsize=3D256k" pass "logbsize=3D256k" "true"
+do_test "-o logbsize=3D8k" fail
+do_test "-o logbsize=3D512k" fail
+do_mkfs -m crc=3D0 -l version=3D1
+# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_s=
ize)
+# prints "logbsize=3DN" in /proc/mounts, but old kernel not. So the defa=
ult
+# 'display' about logbsize can't be expected, disable this test.
+#do_test "" pass "logbsize" "false"
+do_test "-o logbsize=3D16384" pass "logbsize=3D16k" "true"
+do_test "-o logbsize=3D16k" pass "logbsize=3D16k" "true"
+do_test "-o logbsize=3D32k" pass "logbsize=3D32k" "true"
+do_test "-o logbsize=3D64k" fail
+
+# Test logdev
+do_mkfs
+do_test "" pass "logdev" "false"
+do_test "-o logdev=3D$LOOP_SPARE_DEV" fail
+do_mkfs -l logdev=3D$LOOP_SPARE_DEV
+do_test "-o logdev=3D$LOOP_SPARE_DEV" pass "logdev=3D$LOOP_SPARE_DEV" "t=
rue"
+do_test "" fail
+
+# Test noalign
+do_mkfs
+do_test "" pass "noalign" "false"
+do_test "-o noalign" pass "noalign" "true"
+
+# Test norecovery
+do_test "" pass "norecovery" "false"
+do_test "-o norecovery,ro" pass "norecovery" "true"
+do_test "-o norecovery" fail
+
+# Test nouuid
+do_test "" pass "nouuid" "false"
+do_test "-o nouuid" pass "nouuid" "true"
+
+# Test noquota
+do_test "" pass "noquota" "true"
+do_test "-o noquota" pass "noquota" "true"
+
+# Test uquota/usrquota/quota/uqnoenforce/qnoenforce
+do_test "" pass "usrquota" "false"
+do_test "-o uquota" pass "usrquota" "true"
+do_test "-o usrquota" pass "usrquota" "true"
+do_test "-o quota" pass "usrquota" "true"
+do_test "-o uqnoenforce" pass "usrquota" "true"
+do_test "-o qnoenforce" pass "usrquota" "true"
+
+# Test gquota/grpquota/gqnoenforce
+do_test "" pass "grpquota" "false"
+do_test "-o gquota" pass "grpquota" "true"
+do_test "-o grpquota" pass "grpquota" "true"
+do_test "-o gqnoenforce" pass "gqnoenforce" "true"
+
+# Test pquota/prjquota/pqnoenforce
+do_test "" pass "prjquota" "false"
+do_test "-o pquota" pass "prjquota" "true"
+do_test "-o prjquota" pass "prjquota" "true"
+do_test "-o pqnoenforce" pass "pqnoenforce" "true"
+
+# Test sunit=3Dvalue and swidth=3Dvalue
+do_mkfs -d sunit=3D128,swidth=3D128
+do_test "-o sunit=3D8,swidth=3D8" pass "sunit=3D8,swidth=3D8" "true"
+do_test "-o sunit=3D8,swidth=3D64" pass "sunit=3D8,swidth=3D64" "true"
+do_test "-o sunit=3D128,swidth=3D128" pass "sunit=3D128,swidth=3D128" "t=
rue"
+do_test "-o sunit=3D256,swidth=3D256" pass "sunit=3D256,swidth=3D256" "t=
rue"
+do_test "-o sunit=3D2,swidth=3D2" fail
+
+# Test swalloc
+do_mkfs
+do_test "" pass "swalloc" "false"
+do_test "-o swalloc" pass "swalloc" "true"
+
+# Test wsync
+do_test "" pass "wsync" "false"
+do_test "-o wsync" pass "wsync" "true"
+
+echo "** end of testing"
+# success, all done
+status=3D0
+exit
diff --git a/tests/xfs/512.out b/tests/xfs/512.out
new file mode 100644
index 00000000..d583b5da
--- /dev/null
+++ b/tests/xfs/512.out
@@ -0,0 +1,100 @@
+QA output created by 512
+** create loop device
+** create loop log device
+** create loop mount point
+** start xfs mount testing ...
+FORMAT:=20
+TEST: "" "pass" "allocsize" "false"
+TEST: "-o allocsize=3D4k" "pass" "allocsize=3D4k" "true"
+TEST: "-o allocsize=3D1048576k" "pass" "allocsize=3D1048576k" "true"
+TEST: "-o allocsize=3D2048" "fail"
+TEST: "-o allocsize=3D2g" "fail"
+FORMAT: -m crc=3D1
+TEST: "" "pass" "attr2" "true"
+TEST: "-o attr2" "pass" "attr2" "true"
+TEST: "-o noattr2" "fail"
+FORMAT: -m crc=3D0
+TEST: "" "pass" "attr2" "true"
+TEST: "-o attr2" "pass" "attr2" "true"
+TEST: "-o noattr2" "pass" "attr2" "false"
+FORMAT:=20
+TEST: "" "pass" "discard" "false"
+TEST: "-o discard" "pass" "discard" "true"
+TEST: "-o nodiscard" "pass" "discard" "false"
+TEST: "" "pass" "grpid" "false"
+TEST: "-o grpid" "pass" "grpid" "true"
+TEST: "-o bsdgroups" "pass" "grpid" "true"
+TEST: "-o nogrpid" "pass" "grpid" "false"
+TEST: "-o sysvgroups" "pass" "grpid" "false"
+TEST: "" "pass" "filestreams" "false"
+TEST: "-o filestreams" "pass" "filestreams" "true"
+TEST: "" "pass" "ikeep" "false"
+TEST: "-o ikeep" "pass" "ikeep" "true"
+TEST: "-o noikeep" "pass" "ikeep" "false"
+TEST: "" "pass" "inode64" "true"
+TEST: "-o inode32" "pass" "inode32" "true"
+TEST: "-o inode64" "pass" "inode64" "true"
+TEST: "" "pass" "largeio" "false"
+TEST: "-o largeio" "pass" "largeio" "true"
+TEST: "-o nolargeio" "pass" "largeio" "false"
+TEST: "-o logbufs=3D8" "pass" "logbufs=3D8" "true"
+TEST: "-o logbufs=3D2" "pass" "logbufs=3D2" "true"
+TEST: "-o logbufs=3D1" "fail"
+TEST: "-o logbufs=3D9" "fail"
+TEST: "-o logbufs=3D99999999999999" "fail"
+FORMAT: -m crc=3D1 -l version=3D2
+TEST: "-o logbsize=3D16384" "pass" "logbsize=3D16k" "true"
+TEST: "-o logbsize=3D16k" "pass" "logbsize=3D16k" "true"
+TEST: "-o logbsize=3D32k" "pass" "logbsize=3D32k" "true"
+TEST: "-o logbsize=3D64k" "pass" "logbsize=3D64k" "true"
+TEST: "-o logbsize=3D128k" "pass" "logbsize=3D128k" "true"
+TEST: "-o logbsize=3D256k" "pass" "logbsize=3D256k" "true"
+TEST: "-o logbsize=3D8k" "fail"
+TEST: "-o logbsize=3D512k" "fail"
+FORMAT: -m crc=3D0 -l version=3D1
+TEST: "-o logbsize=3D16384" "pass" "logbsize=3D16k" "true"
+TEST: "-o logbsize=3D16k" "pass" "logbsize=3D16k" "true"
+TEST: "-o logbsize=3D32k" "pass" "logbsize=3D32k" "true"
+TEST: "-o logbsize=3D64k" "fail"
+FORMAT:=20
+TEST: "" "pass" "logdev" "false"
+TEST: "-o logdev=3DLOOP_SPARE_DEV" "fail"
+FORMAT: -l logdev=3DLOOP_SPARE_DEV
+TEST: "-o logdev=3DLOOP_SPARE_DEV" "pass" "logdev=3DLOOP_SPARE_DEV" "tru=
e"
+TEST: "" "fail"
+FORMAT:=20
+TEST: "" "pass" "noalign" "false"
+TEST: "-o noalign" "pass" "noalign" "true"
+TEST: "" "pass" "norecovery" "false"
+TEST: "-o norecovery,ro" "pass" "norecovery" "true"
+TEST: "-o norecovery" "fail"
+TEST: "" "pass" "nouuid" "false"
+TEST: "-o nouuid" "pass" "nouuid" "true"
+TEST: "" "pass" "noquota" "true"
+TEST: "-o noquota" "pass" "noquota" "true"
+TEST: "" "pass" "usrquota" "false"
+TEST: "-o uquota" "pass" "usrquota" "true"
+TEST: "-o usrquota" "pass" "usrquota" "true"
+TEST: "-o quota" "pass" "usrquota" "true"
+TEST: "-o uqnoenforce" "pass" "usrquota" "true"
+TEST: "-o qnoenforce" "pass" "usrquota" "true"
+TEST: "" "pass" "grpquota" "false"
+TEST: "-o gquota" "pass" "grpquota" "true"
+TEST: "-o grpquota" "pass" "grpquota" "true"
+TEST: "-o gqnoenforce" "pass" "gqnoenforce" "true"
+TEST: "" "pass" "prjquota" "false"
+TEST: "-o pquota" "pass" "prjquota" "true"
+TEST: "-o prjquota" "pass" "prjquota" "true"
+TEST: "-o pqnoenforce" "pass" "pqnoenforce" "true"
+FORMAT: -d sunit=3D128,swidth=3D128
+TEST: "-o sunit=3D8,swidth=3D8" "pass" "sunit=3D8,swidth=3D8" "true"
+TEST: "-o sunit=3D8,swidth=3D64" "pass" "sunit=3D8,swidth=3D64" "true"
+TEST: "-o sunit=3D128,swidth=3D128" "pass" "sunit=3D128,swidth=3D128" "t=
rue"
+TEST: "-o sunit=3D256,swidth=3D256" "pass" "sunit=3D256,swidth=3D256" "t=
rue"
+TEST: "-o sunit=3D2,swidth=3D2" "fail"
+FORMAT:=20
+TEST: "" "pass" "swalloc" "false"
+TEST: "-o swalloc" "pass" "swalloc" "true"
+TEST: "" "pass" "wsync" "false"
+TEST: "-o wsync" "pass" "wsync" "true"
+** end of testing
diff --git a/tests/xfs/group b/tests/xfs/group
index c7253cf1..a6b09a8d 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -509,3 +509,4 @@
 509 auto ioctl
 510 auto ioctl quick
 511 auto quick quota
+512 auto quick mount
--=20
2.20.1

