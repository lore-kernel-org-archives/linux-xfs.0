Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF926CA9EBC
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 04:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5EC121928
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 04:47:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="La6VXPtr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408362AbfJXEr2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 00:47:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20526 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725811AbfJXEr2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 00:47:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571892445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zeiB/AJJWnZpMI6Wf5exg+Ey2tgYEfh1gZ4mMp6pcuc=;
        b=La6VXPtrOPUFI/PEk3MNpzHK0K3zrpOAwINLAq6PtfyLIm/AJ2VO6HkJDGHgSFQfsyaouv
        nVU+RBQgIqLV2xf2r6SyinTdQlPRM23Nq9WWRPnlFYjLGU6aWp8Aqxejurm1SO8+qVmlcV
        WJlcN1I9tUWQpQuHaMS+d1iQoNXWqWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-QMca1ie-Mo-REyQ-vz62Ig-1; Thu, 24 Oct 2019 00:47:21 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 093EC107AD31;
        Thu, 24 Oct 2019 04:47:21 +0000 (UTC)
Received: from donald.localdomain (vpn2-54-113.bne.redhat.com [10.64.54.113])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 77263600CC;
        Thu, 24 Oct 2019 04:47:20 +0000 (UTC)
Received: from localhost (localhost [IPv6:::1])
        by donald.localdomain (Postfix) with ESMTP id F0C3928013F;
        Thu, 24 Oct 2019 12:47:17 +0800 (AWST)
Message-ID: <b2056efe3bd3cb17811442ca4a8720b9d51e087d.camel@redhat.com>
Subject: Re: [PATCH] xfstests: xfs mount option sanity test
From:   Ian Kent <ikent@redhat.com>
To:     Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 24 Oct 2019 12:47:17 +0800
In-Reply-To: <20191022100118.18506-1-zlang@redhat.com>
References: <20191022100118.18506-1-zlang@redhat.com>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: QMca1ie-Mo-REyQ-vz62Ig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-10-22 at 18:01 +0800, Zorro Lang wrote:
> XFS is changing to suit the new mount API, so add this case to make
> sure the changing won't bring in regression issue on xfs mount option
> parse phase, and won't change some default behaviors either.

I think this isn't quite right:

[root@f30 xfstests-dev]# diff -u /home/raven/xfstests-dev/tests/xfs/148.out=
 /home/raven/xfstests-dev/results//xfs/148.out.bad
--- /home/raven/xfstests-dev/tests/xfs/148.out=092019-10-24 09:27:27.304929=
313 +0800
+++ /home/raven/xfstests-dev/results//xfs/148.out.bad=092019-10-24 10:42:40=
.739436223 +0800
@@ -3,4 +3,10 @@
 ** create loop log device
 ** create loop mount point
 ** start xfs mount testing ...
+[FAILED]: mount /dev/loop0 /mnt/test/148.mnt=20
+ERROR: expect there's logbufs in rw,relatime,seclabel,attr2,inode64,logbuf=
s=3D8,logbsize=3D32k,noquota, but not found
+[FAILED]: mount /dev/loop0 /mnt/test/148.mnt=20
+ERROR: expect there's logbsize in rw,relatime,seclabel,attr2,inode64,logbu=
fs=3D8,logbsize=3D32k,noquota, but not found
+[FAILED]: mount /dev/loop0 /mnt/test/148.mnt=20
+ERROR: expect there's logbsize in rw,relatime,seclabel,attr2,inode64,logbu=
fs=3D8,logbsize=3D32k,noquota, but not found
 ** end of testing

Above logbufs and logbsize are present in the options string but
an error is reported.

Ian

>=20
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  tests/xfs/148     | 315
> ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/148.out |   6 +
>  tests/xfs/group   |   1 +
>  3 files changed, 322 insertions(+)
>  create mode 100755 tests/xfs/148
>  create mode 100644 tests/xfs/148.out
>=20
> diff --git a/tests/xfs/148 b/tests/xfs/148
> new file mode 100755
> index 00000000..5c268f18
> --- /dev/null
> +++ b/tests/xfs/148
> @@ -0,0 +1,315 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc. All Rights Reserved.
> +#
> +# FS QA Test 148
> +#
> +# XFS mount options sanity check, refer to 'man 5 xfs'.
> +#
> +seq=3D`basename $0`
> +seqres=3D$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=3D`pwd`
> +tmp=3D/tmp/$$
> +status=3D1=09# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +=09cd /
> +=09rm -f $tmp.*
> +=09$UMOUNT_PROG $LOOP_MNT 2>/dev/null
> +=09if [ -n "$LOOP_DEV" ];then
> +=09=09_destroy_loop_device $LOOP_DEV 2>/dev/null
> +=09fi
> +=09if [ -n "$LOOP_SPARE_DEV" ];then
> +=09=09_destroy_loop_device $LOOP_SPARE_DEV 2>/dev/null
> +=09fi
> +=09rm -f $LOOP_IMG
> +=09rm -f $LOOP_SPARE_IMG
> +=09rmdir $LOOP_MNT
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_test
> +_require_loop
> +_require_xfs_io_command "falloc"
> +
> +LOOP_IMG=3D$TEST_DIR/$seq.dev
> +LOOP_SPARE_IMG=3D$TEST_DIR/$seq.logdev
> +LOOP_MNT=3D$TEST_DIR/$seq.mnt
> +
> +echo "** create loop device"
> +$XFS_IO_PROG -f -c "falloc 0 1g" $LOOP_IMG
> +LOOP_DEV=3D`_create_loop_device $LOOP_IMG`
> +
> +echo "** create loop log device"
> +$XFS_IO_PROG -f -c "falloc 0 512m" $LOOP_SPARE_IMG
> +LOOP_SPARE_DEV=3D`_create_loop_device $LOOP_SPARE_IMG`
> +
> +echo "** create loop mount point"
> +rmdir $LOOP_MNT 2>/dev/null
> +mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
> +
> +# avoid the effection from MKFS_OPTIONS
> +MKFS_OPTIONS=3D""
> +do_mkfs()
> +{
> +=09$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >$seqres.full
> 2>$tmp.mkfs
> +=09if [ "${PIPESTATUS[0]}" -ne 0 ]; then
> +=09=09_fail "Fails on _mkfs_dev $* $LOOP_DEV"
> +=09fi
> +=09. $tmp.mkfs
> +}
> +
> +is_dev_mounted()
> +{
> +=09findmnt --source $LOOP_DEV >/dev/null
> +=09return $?
> +}
> +
> +get_mount_info()
> +{
> +=09findmnt --source $LOOP_DEV -o OPTIONS -n
> +}
> +
> +force_unmount()
> +{
> +=09$UMOUNT_PROG $LOOP_MNT >/dev/null 2>&1
> +}
> +
> +# _do_test <mount options> <should be mounted?> [<key string> <key
> should be found?>]
> +_do_test()
> +{
> +=09local opts=3D"$1"
> +=09local mounted=3D"$2"=09# pass or fail
> +=09local key=3D"$3"
> +=09local found=3D"$4"=09# true or false
> +=09local rc
> +=09local info
> +
> +=09# mount test
> +=09_mount $LOOP_DEV $LOOP_MNT $opts 2>/dev/null
> +=09rc=3D$?
> +=09if [ $rc -eq 0 ];then
> +=09=09if [ "${mounted}" =3D "fail" ];then
> +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> $opts"
> +=09=09=09echo "ERROR: expect ${mounted}, but pass"
> +=09=09=09return 1
> +=09=09fi
> +=09=09is_dev_mounted
> +=09=09if [ $? -ne 0 ];then
> +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> $opts"
> +=09=09=09echo "ERROR: fs not mounted even mount return
> 0"
> +=09=09=09return 1
> +=09=09fi
> +=09else
> +=09=09if [ "${mount_ret}" =3D "pass" ];then
> +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> $opts"
> +=09=09=09echo "ERROR: expect ${mounted}, but fail"
> +=09=09=09return 1
> +=09=09fi
> +=09=09is_dev_mounted
> +=09=09if [ $? -eq 0 ];then
> +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> $opts"
> +=09=09=09echo "ERROR: fs is mounted even mount return
> non-zero"
> +=09=09=09return 1
> +=09=09fi
> +=09fi
> +
> +=09# Skip below checking if "$key" argument isn't specified
> +=09if [ -z "$key" ];then
> +=09=09return 0
> +=09fi
> +=09# Check the mount options after fs mounted.
> +=09info=3D`get_mount_info`
> +=09echo $info | grep -q "${key}"
> +=09rc=3D$?
> +=09if [ $rc -eq 0 ];then
> +=09=09if [ "$found" !=3D "true" ];then
> +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> $opts"
> +=09=09=09echo "ERROR: expect there's $key in $info, but
> not found"
> +=09=09=09return 1
> +=09=09fi
> +=09else
> +=09=09if [ "$found" !=3D "false" ];then
> +=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT
> $opts"
> +=09=09=09echo "ERROR: expect there's not $key in $info,
> but found"
> +=09=09=09return 1
> +=09=09fi
> +=09fi
> +
> +=09return 0
> +}
> +
> +do_test()
> +{
> +=09# force unmount before testing
> +=09force_unmount
> +=09_do_test "$@"
> +=09# force unmount after testing
> +=09force_unmount
> +}
> +
> +echo "** start xfs mount testing ..."
> +# Test allocsize=3Dsize
> +# Valid values for this option are page size (typically 4KiB)
> through to 1GiB
> +do_mkfs
> +if [ $dbsize -ge 1024 ];then
> +=09blsize=3D"$((dbsize / 1024))k"
> +fi
> +do_test "" pass "allocsize" "false"
> +do_test "-o allocsize=3D$blsize" pass "allocsize=3D$blsize" "true"
> +do_test "-o allocsize=3D1048576k" pass "allocsize=3D1048576k" "true"
> +do_test "-o allocsize=3D$((dbsize / 2))" fail
> +do_test "-o allocsize=3D2g" fail
> +
> +# Test attr2
> +do_mkfs -m crc=3D1
> +do_test "" pass "attr2" "true"
> +do_test "-o attr2" pass "attr2" "true"
> +do_test "-o noattr2" fail
> +do_mkfs -m crc=3D0
> +do_test "" pass "attr2" "true"
> +do_test "-o attr2" pass "attr2" "true"
> +do_test "-o noattr2" pass "attr2" "false"
> +
> +# Test discard
> +do_mkfs
> +do_test "" pass "discard" "false"
> +do_test "-o discard" pass "discard" "true"
> +do_test "-o nodiscard" pass "discard" "false"
> +
> +# Test grpid|bsdgroups|nogrpid|sysvgroups
> +do_test "" pass "grpid" "false"
> +do_test "-o grpid" pass "grpid" "true"
> +do_test "-o bsdgroups" pass "grpid" "true"
> +do_test "-o nogrpid" pass "grpid" "false"
> +do_test "-o sysvgroups" pass "grpid" "false"
> +
> +# Test filestreams
> +do_test "" pass "filestreams" "false"
> +do_test "-o filestreams" pass "filestreams" "true"
> +
> +# Test ikeep
> +do_test "" pass "ikeep" "false"
> +do_test "-o ikeep" pass "ikeep" "true"
> +do_test "-o noikeep" pass "ikeep" "false"
> +
> +# Test inode32|inode64
> +do_test "" pass "inode64" "true"
> +do_test "-o inode32" pass "inode32" "true"
> +do_test "-o inode64" pass "inode64" "true"
> +
> +# Test largeio
> +do_test "" pass "largeio" "false"
> +do_test "-o largeio" pass "largeio" "true"
> +do_test "-o nolargeio" pass "largeio" "false"
> +
> +# Test logbufs=3Dvalue. Valid numbers range from 2=E2=80=938 inclusive.
> +do_test "" pass "logbufs" "false"
> +do_test "-o logbufs=3D8" pass "logbufs=3D8" "true"
> +do_test "-o logbufs=3D2" pass "logbufs=3D2" "true"
> +do_test "-o logbufs=3D1" fail
> +###### but it gets logbufs=3D8 now, why? bug? #######
> +# do_test "-o logbufs=3D0" fail
> +do_test "-o logbufs=3D9" fail
> +do_test "-o logbufs=3D99999999999999" fail
> +
> +# Test logbsize=3Dvalue.
> +do_mkfs -m crc=3D1 -l version=3D2
> +do_test "" pass "logbsize" "false"
> +do_test "-o logbsize=3D16384" pass "logbsize=3D16k" "true"
> +do_test "-o logbsize=3D16k" pass "logbsize=3D16k" "true"
> +do_test "-o logbsize=3D32k" pass "logbsize=3D32k" "true"
> +do_test "-o logbsize=3D64k" pass "logbsize=3D64k" "true"
> +do_test "-o logbsize=3D128k" pass "logbsize=3D128k" "true"
> +do_test "-o logbsize=3D256k" pass "logbsize=3D256k" "true"
> +do_test "-o logbsize=3D8k" fail
> +do_test "-o logbsize=3D512k" fail
> +####### it's invalid, but it set to default size 32k
> +# do_test "-o logbsize=3D0" false
> +do_mkfs -m crc=3D0 -l version=3D1
> +do_test "" pass "logbsize" "false"
> +do_test "-o logbsize=3D16384" pass "logbsize=3D16k" "true"
> +do_test "-o logbsize=3D16k" pass "logbsize=3D16k" "true"
> +do_test "-o logbsize=3D32k" pass "logbsize=3D32k" "true"
> +do_test "-o logbsize=3D64k" fail
> +
> +# Test logdev
> +do_mkfs
> +do_test "" pass "logdev" "false"
> +do_test "-o logdev=3D$LOOP_SPARE_DEV" fail
> +do_mkfs -l logdev=3D$LOOP_SPARE_DEV
> +do_test "-o logdev=3D$LOOP_SPARE_DEV" pass "logdev=3D$LOOP_SPARE_DEV"
> "true"
> +do_test "" fail
> +
> +# Test noalign
> +do_mkfs
> +do_test "" pass "noalign" "false"
> +do_test "-o noalign" pass "noalign" "true"
> +
> +# Test norecovery
> +do_test "" pass "norecovery" "false"
> +do_test "-o norecovery,ro" pass "norecovery" "true"
> +do_test "-o norecovery" fail
> +
> +# Test nouuid
> +do_test "" pass "nouuid" "false"
> +do_test "-o nouuid" pass "nouuid" "true"
> +
> +# Test noquota
> +do_test "" pass "noquota" "true"
> +do_test "-o noquota" pass "noquota" "true"
> +
> +# Test uquota/usrquota/quota/uqnoenforce/qnoenforce
> +do_test "" pass "usrquota" "false"
> +do_test "-o uquota" pass "usrquota" "true"
> +do_test "-o usrquota" pass "usrquota" "true"
> +do_test "-o quota" pass "usrquota" "true"
> +do_test "-o uqnoenforce" pass "usrquota" "true"
> +do_test "-o qnoenforce" pass "usrquota" "true"
> +
> +# Test gquota/grpquota/gqnoenforce
> +do_test "" pass "grpquota" "false"
> +do_test "-o gquota" pass "grpquota" "true"
> +do_test "-o grpquota" pass "grpquota" "true"
> +do_test "-o gqnoenforce" pass "gqnoenforce" "true"
> +
> +# Test pquota/prjquota/pqnoenforce
> +do_test "" pass "prjquota" "false"
> +do_test "-o pquota" pass "prjquota" "true"
> +do_test "-o prjquota" pass "prjquota" "true"
> +do_test "-o pqnoenforce" pass "pqnoenforce" "true"
> +
> +# Test sunit=3Dvalue and swidth=3Dvalue
> +do_mkfs -d sunit=3D128,swidth=3D128
> +do_test "-o sunit=3D8,swidth=3D8" pass "sunit=3D8,swidth=3D8" "true"
> +do_test "-o sunit=3D8,swidth=3D64" pass "sunit=3D8,swidth=3D64" "true"
> +do_test "-o sunit=3D128,swidth=3D128" pass "sunit=3D128,swidth=3D128" "t=
rue"
> +do_test "-o sunit=3D256,swidth=3D256" pass "sunit=3D256,swidth=3D256" "t=
rue"
> +do_test "-o sunit=3D2,swidth=3D2" fail
> +
> +# Test swalloc
> +do_mkfs
> +do_test "" pass "swalloc" "false"
> +do_test "-o swalloc" pass "swalloc" "true"
> +
> +# Test wsync
> +do_test "" pass "wsync" "false"
> +do_test "-o wsync" pass "wsync" "true"
> +
> +echo "** end of testing"
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/xfs/148.out b/tests/xfs/148.out
> new file mode 100644
> index 00000000..a71d9231
> --- /dev/null
> +++ b/tests/xfs/148.out
> @@ -0,0 +1,6 @@
> +QA output created by 148
> +** create loop device
> +** create loop log device
> +** create loop mount point
> +** start xfs mount testing ...
> +** end of testing
> diff --git a/tests/xfs/group b/tests/xfs/group
> index f4ebcd8c..019aebad 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -145,6 +145,7 @@
>  145 dmapi
>  146 dmapi
>  147 dmapi
> +148 auto quick mount
>  150 dmapi
>  151 dmapi
>  152 dmapi

