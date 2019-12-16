Return-Path: <SRS0=k6ZN=2G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C51C2D0BF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 09:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92702206D3
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 09:28:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D0oEwN+X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfLPJ2A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Dec 2019 04:28:00 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21835 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727264AbfLPJ17 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 04:27:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576488477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uuoOhsCJZyZczlVZW6ScXKB3j3Tv//1fDl8bpcDD9Yw=;
        b=D0oEwN+XD0JENttq6ZnswXcR5gHrnIdxAP2s6gVOZmreO1qW2bd/j2rH8LrSy+PcsOpPWf
        FGfoHp9Dq83mOPmm3tBGjMWN/b4n7mmz65bZGPpRmk/BiICIWcqwPnGnHnaafFg1zQfXQi
        o2aZRdEi1BPE+05vWYZ0zi9jrW4NUSo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-dH18tqcPM4G_vfk8-mvmOg-1; Mon, 16 Dec 2019 04:27:48 -0500
X-MC-Unique: dH18tqcPM4G_vfk8-mvmOg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E42C1005510;
        Mon, 16 Dec 2019 09:27:47 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44D3CA4B84;
        Mon, 16 Dec 2019 09:27:46 +0000 (UTC)
Date:   Mon, 16 Dec 2019 17:36:08 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfstests: xfs mount option sanity test
Message-ID: <20191216093607.GD14328@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20191030103410.2239-1-zlang@redhat.com>
 <20191030163922.GB15224@magnolia>
 <20191030232453.GD3802@dhcp-12-102.nay.redhat.com>
 <20191211064216.GA14328@dhcp-12-102.nay.redhat.com>
 <381504a191f867dc53702454103b138eae94d61f.camel@themaw.net>
 <20191216091707.GC14328@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191216091707.GC14328@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 16, 2019 at 05:17:07PM +0800, Zorro Lang wrote:
> On Wed, Dec 11, 2019 at 04:33:20PM +0800, Ian Kent wrote:
> > On Wed, 2019-12-11 at 14:42 +0800, Zorro Lang wrote:
> > > On Thu, Oct 31, 2019 at 07:24:53AM +0800, Zorro Lang wrote:
> > > > On Wed, Oct 30, 2019 at 09:39:22AM -0700, Darrick J. Wong wrote:
> > > > > On Wed, Oct 30, 2019 at 06:34:10PM +0800, Zorro Lang wrote:
> > > > > > XFS is changing to suit the new mount API, so add this case t=
o
> > > > > > make
> > > > > > sure the changing won't bring in regression issue on xfs moun=
t
> > > > > > option
> > > > > > parse phase, and won't change some default behaviors either.
> > > > > >=20
> > > > > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > > > > ---
> > > > > >=20
> > > > > > Hi,
> > > > > >=20
> > > > > > V2 did below changes:
> > > > > > 1) Fix wrong output messages in _do_test function
> > > > >=20
> > > > > Hmm, I still see this on 5.4-rc4:
> > > > >=20
> > > > > +[FAILED]: mount /dev/loop0 /mnt/148.mnt -o logbsize=3D16384
> > > > > +ERROR: expect there's logbsize=3D16k in , but found
> > > >                                              ^^^
> > > >                                              not
> > > >=20
> > > > > +[FAILED]: mount /dev/loop0 /mnt/148.mnt -o logbsize=3D16k
> > > > > +ERROR: expect there's logbsize=3D16k in , but found
> > > >                                              ^^^
> > > >                                              not
> > > >=20
> > > > Sorry for this typo, I'll fix it.
> > > >=20
> > > > > Oh, right, you're stripping out MKFS_OPTIONS and formatting a
> > > > > loop
> > > > > device, which on my system means you get rmapbt=3D1 by default =
and
> > > > > whatnot.
> > > >=20
> > > > Hmm...  why rmapbt=3D1 cause logbsize=3D16k can't be displayed in
> > > > /proc/mounts?
> > > >=20
> > > > Actually set MKFS_OPTIONS=3D"" is not helpful for this case, due =
to I
> > > > run
> > > > "$MKFS_XFS_PROG -f $* $LOOP_DEV" directly. I strip out
> > > > MKFS_OPTIONS,
> > > > because I use SCRACH_DEV at first :)
> > > >=20
> > > > > I think the larger problem here might be that now we have to
> > > > > figure out
> > > > > the special-casing of some of these options.
> > > >=20
> > > > Maybe we should avoid the testing about those behaviors can't be
> > > > sure, if we
> > > > can't make it have a fixed output.
> > >=20
> > > It's been long time passed. I still don't have a proper way to
> > > reproduce and
> > > avoid this failure you hit. Does anyone has a better idea for this
> > > case?
> >=20
> > I think I understand the problem but correct me if I'm wrong.
> >=20
> > Couldn't you cover both cases, pass an additional parameter that
> > says what the default is if it isn't specified as an option and
> > don't fail if it is present in the options.
> >=20
> > You could check kernel versions to decide whether to pass the
> > third parameter and so decide if you need to allow for a default
> > option to account for the differing behaviour.
>=20
> Hi Ian,
>=20
> It's not a issue about displaying default mount options. It's:
>=20
> # mount $dev_xfs $mnt -o logbsize=3D16k
> # findmnt --source $dev_xfs -o OPTIONS -n |grep "logbsize=3D16k"
> <nothing output>
>=20
> The case expects there's "logbsize=3D16k", but it can't find that optio=
n.
>=20
> I don't know how to reproduce it.

Hi Darrick,

Can you still reproduce this failure? Would you mind telling me how to re=
produce
it or how to correct my case :-P

The xfs_fs_show_options() function shows:

        if (mp->m_logbsize > 0)
                seq_printf(m, ",logbsize=3D%dk", mp->m_logbsize >> 10);

I think the logbsize should be printed if we set '-o logbsize=3D16k'.

Thanks,
Zorro

>=20
> Thanks,
> Zorro
>=20
> >=20
> > Ian
> > >=20
> > > Thanks,
> > > Zorro
> > >=20
> > > > Thanks,
> > > > Zorro
> > > >=20
> > > > > --D
> > > > >=20
> > > > > > 2) Remove logbufs=3DN and logbsize=3DN default display test.
> > > > > > Lastest upstream
> > > > > >    kernel displays these options in /proc/mounts by default,
> > > > > > but old kernel
> > > > > >    doesn't show them except user indicate these options when
> > > > > > mount xfs.
> > > > > >    Refer to https://marc.info/?l=3Dfstests&m=3D15719969961547=
7&w=3D2
> > > > > >=20
> > > > > > Thanks,
> > > > > > Zorro
> > > > > >=20
> > > > > >  tests/xfs/148     | 320
> > > > > > ++++++++++++++++++++++++++++++++++++++++++++++
> > > > > >  tests/xfs/148.out |   6 +
> > > > > >  tests/xfs/group   |   1 +
> > > > > >  3 files changed, 327 insertions(+)
> > > > > >  create mode 100755 tests/xfs/148
> > > > > >  create mode 100644 tests/xfs/148.out
> > > > > >=20
> > > > > > diff --git a/tests/xfs/148 b/tests/xfs/148
> > > > > > new file mode 100755
> > > > > > index 00000000..a662f6f7
> > > > > > --- /dev/null
> > > > > > +++ b/tests/xfs/148
> > > > > > @@ -0,0 +1,320 @@
> > > > > > +#! /bin/bash
> > > > > > +# SPDX-License-Identifier: GPL-2.0
> > > > > > +# Copyright (c) 2019 Red Hat, Inc. All Rights Reserved.
> > > > > > +#
> > > > > > +# FS QA Test 148
> > > > > > +#
> > > > > > +# XFS mount options sanity check, refer to 'man 5 xfs'.
> > > > > > +#
> > > > > > +seq=3D`basename $0`
> > > > > > +seqres=3D$RESULT_DIR/$seq
> > > > > > +echo "QA output created by $seq"
> > > > > > +
> > > > > > +here=3D`pwd`
> > > > > > +tmp=3D/tmp/$$
> > > > > > +status=3D1	# failure is the default!
> > > > > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > > > > +
> > > > > > +_cleanup()
> > > > > > +{
> > > > > > +	cd /
> > > > > > +	rm -f $tmp.*
> > > > > > +	$UMOUNT_PROG $LOOP_MNT 2>/dev/null
> > > > > > +	if [ -n "$LOOP_DEV" ];then
> > > > > > +		_destroy_loop_device $LOOP_DEV 2>/dev/null
> > > > > > +	fi
> > > > > > +	if [ -n "$LOOP_SPARE_DEV" ];then
> > > > > > +		_destroy_loop_device $LOOP_SPARE_DEV
> > > > > > 2>/dev/null
> > > > > > +	fi
> > > > > > +	rm -f $LOOP_IMG
> > > > > > +	rm -f $LOOP_SPARE_IMG
> > > > > > +	rmdir $LOOP_MNT
> > > > > > +}
> > > > > > +
> > > > > > +# get standard environment, filters and checks
> > > > > > +. ./common/rc
> > > > > > +. ./common/filter
> > > > > > +
> > > > > > +# remove previous $seqres.full before test
> > > > > > +rm -f $seqres.full
> > > > > > +
> > > > > > +# real QA test starts here
> > > > > > +_supported_fs xfs
> > > > > > +_supported_os Linux
> > > > > > +_require_test
> > > > > > +_require_loop
> > > > > > +_require_xfs_io_command "falloc"
> > > > > > +
> > > > > > +LOOP_IMG=3D$TEST_DIR/$seq.dev
> > > > > > +LOOP_SPARE_IMG=3D$TEST_DIR/$seq.logdev
> > > > > > +LOOP_MNT=3D$TEST_DIR/$seq.mnt
> > > > > > +
> > > > > > +echo "** create loop device"
> > > > > > +$XFS_IO_PROG -f -c "falloc 0 1g" $LOOP_IMG
> > > > > > +LOOP_DEV=3D`_create_loop_device $LOOP_IMG`
> > > > > > +
> > > > > > +echo "** create loop log device"
> > > > > > +$XFS_IO_PROG -f -c "falloc 0 512m" $LOOP_SPARE_IMG
> > > > > > +LOOP_SPARE_DEV=3D`_create_loop_device $LOOP_SPARE_IMG`
> > > > > > +
> > > > > > +echo "** create loop mount point"
> > > > > > +rmdir $LOOP_MNT 2>/dev/null
> > > > > > +mkdir -p $LOOP_MNT || _fail "cannot create loopback mount
> > > > > > point"
> > > > > > +
> > > > > > +# avoid the effection from MKFS_OPTIONS
> > > > > > +MKFS_OPTIONS=3D""
> > > > > > +do_mkfs()
> > > > > > +{
> > > > > > +	$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs
> > > > > > >$seqres.full 2>$tmp.mkfs
> > > > > > +	if [ "${PIPESTATUS[0]}" -ne 0 ]; then
> > > > > > +		_fail "Fails on _mkfs_dev $* $LOOP_DEV"
> > > > > > +	fi
> > > > > > +	. $tmp.mkfs
> > > > > > +}
> > > > > > +
> > > > > > +is_dev_mounted()
> > > > > > +{
> > > > > > +	findmnt --source $LOOP_DEV >/dev/null
> > > > > > +	return $?
> > > > > > +}
> > > > > > +
> > > > > > +get_mount_info()
> > > > > > +{
> > > > > > +	findmnt --source $LOOP_DEV -o OPTIONS -n
> > > > > > +}
> > > > > > +
> > > > > > +force_unmount()
> > > > > > +{
> > > > > > +	$UMOUNT_PROG $LOOP_MNT >/dev/null 2>&1
> > > > > > +}
> > > > > > +
> > > > > > +# _do_test <mount options> <should be mounted?> [<key string=
>
> > > > > > <key should be found?>]
> > > > > > +_do_test()
> > > > > > +{
> > > > > > +	local opts=3D"$1"
> > > > > > +	local mounted=3D"$2"	# pass or fail
> > > > > > +	local key=3D"$3"
> > > > > > +	local found=3D"$4"	# true or false
> > > > > > +	local rc
> > > > > > +	local info
> > > > > > +
> > > > > > +	# mount test
> > > > > > +	_mount $LOOP_DEV $LOOP_MNT $opts 2>/dev/null
> > > > > > +	rc=3D$?
> > > > > > +	if [ $rc -eq 0 ];then
> > > > > > +		if [ "${mounted}" =3D "fail" ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: expect ${mounted}, but
> > > > > > pass"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +		is_dev_mounted
> > > > > > +		if [ $? -ne 0 ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: fs not mounted even mount
> > > > > > return 0"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +	else
> > > > > > +		if [ "${mount_ret}" =3D "pass" ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: expect ${mounted}, but
> > > > > > fail"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +		is_dev_mounted
> > > > > > +		if [ $? -eq 0 ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: fs is mounted even mount
> > > > > > return non-zero"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +	fi
> > > > > > +
> > > > > > +	# Skip below checking if "$key" argument isn't
> > > > > > specified
> > > > > > +	if [ -z "$key" ];then
> > > > > > +		return 0
> > > > > > +	fi
> > > > > > +	# Check the mount options after fs mounted.
> > > > > > +	info=3D`get_mount_info`
> > > > > > +	echo $info | grep -q "${key}"
> > > > > > +	rc=3D$?
> > > > > > +	if [ $rc -eq 0 ];then
> > > > > > +		if [ "$found" !=3D "true" ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: expect there's not $key in
> > > > > > $info, but not found"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +	else
> > > > > > +		if [ "$found" !=3D "false" ];then
> > > > > > +			echo "[FAILED]: mount $LOOP_DEV
> > > > > > $LOOP_MNT $opts"
> > > > > > +			echo "ERROR: expect there's $key in
> > > > > > $info, but found"
> > > > > > +			return 1
> > > > > > +		fi
> > > > > > +	fi
> > > > > > +
> > > > > > +	return 0
> > > > > > +}
> > > > > > +
> > > > > > +do_test()
> > > > > > +{
> > > > > > +	# force unmount before testing
> > > > > > +	force_unmount
> > > > > > +	_do_test "$@"
> > > > > > +	# force unmount after testing
> > > > > > +	force_unmount
> > > > > > +}
> > > > > > +
> > > > > > +echo "** start xfs mount testing ..."
> > > > > > +# Test allocsize=3Dsize
> > > > > > +# Valid values for this option are page size (typically 4KiB=
)
> > > > > > through to 1GiB
> > > > > > +do_mkfs
> > > > > > +if [ $dbsize -ge 1024 ];then
> > > > > > +	blsize=3D"$((dbsize / 1024))k"
> > > > > > +fi
> > > > > > +do_test "" pass "allocsize" "false"
> > > > > > +do_test "-o allocsize=3D$blsize" pass "allocsize=3D$blsize" =
"true"
> > > > > > +do_test "-o allocsize=3D1048576k" pass "allocsize=3D1048576k=
"
> > > > > > "true"
> > > > > > +do_test "-o allocsize=3D$((dbsize / 2))" fail
> > > > > > +do_test "-o allocsize=3D2g" fail
> > > > > > +
> > > > > > +# Test attr2
> > > > > > +do_mkfs -m crc=3D1
> > > > > > +do_test "" pass "attr2" "true"
> > > > > > +do_test "-o attr2" pass "attr2" "true"
> > > > > > +do_test "-o noattr2" fail
> > > > > > +do_mkfs -m crc=3D0
> > > > > > +do_test "" pass "attr2" "true"
> > > > > > +do_test "-o attr2" pass "attr2" "true"
> > > > > > +do_test "-o noattr2" pass "attr2" "false"
> > > > > > +
> > > > > > +# Test discard
> > > > > > +do_mkfs
> > > > > > +do_test "" pass "discard" "false"
> > > > > > +do_test "-o discard" pass "discard" "true"
> > > > > > +do_test "-o nodiscard" pass "discard" "false"
> > > > > > +
> > > > > > +# Test grpid|bsdgroups|nogrpid|sysvgroups
> > > > > > +do_test "" pass "grpid" "false"
> > > > > > +do_test "-o grpid" pass "grpid" "true"
> > > > > > +do_test "-o bsdgroups" pass "grpid" "true"
> > > > > > +do_test "-o nogrpid" pass "grpid" "false"
> > > > > > +do_test "-o sysvgroups" pass "grpid" "false"
> > > > > > +
> > > > > > +# Test filestreams
> > > > > > +do_test "" pass "filestreams" "false"
> > > > > > +do_test "-o filestreams" pass "filestreams" "true"
> > > > > > +
> > > > > > +# Test ikeep
> > > > > > +do_test "" pass "ikeep" "false"
> > > > > > +do_test "-o ikeep" pass "ikeep" "true"
> > > > > > +do_test "-o noikeep" pass "ikeep" "false"
> > > > > > +
> > > > > > +# Test inode32|inode64
> > > > > > +do_test "" pass "inode64" "true"
> > > > > > +do_test "-o inode32" pass "inode32" "true"
> > > > > > +do_test "-o inode64" pass "inode64" "true"
> > > > > > +
> > > > > > +# Test largeio
> > > > > > +do_test "" pass "largeio" "false"
> > > > > > +do_test "-o largeio" pass "largeio" "true"
> > > > > > +do_test "-o nolargeio" pass "largeio" "false"
> > > > > > +
> > > > > > +# Test logbufs=3Dvalue. Valid numbers range from 2=E2=80=938=
 inclusive.
> > > > > > +# New kernel (refer to 4f62282a3696 xfs: cleanup
> > > > > > xlog_get_iclog_buffer_size)
> > > > > > +# prints "logbufs=3DN" in /proc/mounts, but old kernel not. =
So
> > > > > > the default
> > > > > > +# 'display' about logbufs can't be expected, disable this
> > > > > > test.
> > > > > > +#do_test "" pass "logbufs" "false"
> > > > > > +do_test "-o logbufs=3D8" pass "logbufs=3D8" "true"
> > > > > > +do_test "-o logbufs=3D2" pass "logbufs=3D2" "true"
> > > > > > +do_test "-o logbufs=3D1" fail
> > > > > > +do_test "-o logbufs=3D9" fail
> > > > > > +do_test "-o logbufs=3D99999999999999" fail
> > > > > > +
> > > > > > +# Test logbsize=3Dvalue.
> > > > > > +do_mkfs -m crc=3D1 -l version=3D2
> > > > > > +# New kernel (refer to 4f62282a3696 xfs: cleanup
> > > > > > xlog_get_iclog_buffer_size)
> > > > > > +# prints "logbsize=3DN" in /proc/mounts, but old kernel not.=
 So
> > > > > > the default
> > > > > > +# 'display' about logbsize can't be expected, disable this
> > > > > > test.
> > > > > > +#do_test "" pass "logbsize" "false"
> > > > > > +do_test "-o logbsize=3D16384" pass "logbsize=3D16k" "true"
> > > > > > +do_test "-o logbsize=3D16k" pass "logbsize=3D16k" "true"
> > > > > > +do_test "-o logbsize=3D32k" pass "logbsize=3D32k" "true"
> > > > > > +do_test "-o logbsize=3D64k" pass "logbsize=3D64k" "true"
> > > > > > +do_test "-o logbsize=3D128k" pass "logbsize=3D128k" "true"
> > > > > > +do_test "-o logbsize=3D256k" pass "logbsize=3D256k" "true"
> > > > > > +do_test "-o logbsize=3D8k" fail
> > > > > > +do_test "-o logbsize=3D512k" fail
> > > > > > +do_mkfs -m crc=3D0 -l version=3D1
> > > > > > +# New kernel (refer to 4f62282a3696 xfs: cleanup
> > > > > > xlog_get_iclog_buffer_size)
> > > > > > +# prints "logbsize=3DN" in /proc/mounts, but old kernel not.=
 So
> > > > > > the default
> > > > > > +# 'display' about logbsize can't be expected, disable this
> > > > > > test.
> > > > > > +#do_test "" pass "logbsize" "false"
> > > > > > +do_test "-o logbsize=3D16384" pass "logbsize=3D16k" "true"
> > > > > > +do_test "-o logbsize=3D16k" pass "logbsize=3D16k" "true"
> > > > > > +do_test "-o logbsize=3D32k" pass "logbsize=3D32k" "true"
> > > > > > +do_test "-o logbsize=3D64k" fail
> > > > > > +
> > > > > > +# Test logdev
> > > > > > +do_mkfs
> > > > > > +do_test "" pass "logdev" "false"
> > > > > > +do_test "-o logdev=3D$LOOP_SPARE_DEV" fail
> > > > > > +do_mkfs -l logdev=3D$LOOP_SPARE_DEV
> > > > > > +do_test "-o logdev=3D$LOOP_SPARE_DEV" pass
> > > > > > "logdev=3D$LOOP_SPARE_DEV" "true"
> > > > > > +do_test "" fail
> > > > > > +
> > > > > > +# Test noalign
> > > > > > +do_mkfs
> > > > > > +do_test "" pass "noalign" "false"
> > > > > > +do_test "-o noalign" pass "noalign" "true"
> > > > > > +
> > > > > > +# Test norecovery
> > > > > > +do_test "" pass "norecovery" "false"
> > > > > > +do_test "-o norecovery,ro" pass "norecovery" "true"
> > > > > > +do_test "-o norecovery" fail
> > > > > > +
> > > > > > +# Test nouuid
> > > > > > +do_test "" pass "nouuid" "false"
> > > > > > +do_test "-o nouuid" pass "nouuid" "true"
> > > > > > +
> > > > > > +# Test noquota
> > > > > > +do_test "" pass "noquota" "true"
> > > > > > +do_test "-o noquota" pass "noquota" "true"
> > > > > > +
> > > > > > +# Test uquota/usrquota/quota/uqnoenforce/qnoenforce
> > > > > > +do_test "" pass "usrquota" "false"
> > > > > > +do_test "-o uquota" pass "usrquota" "true"
> > > > > > +do_test "-o usrquota" pass "usrquota" "true"
> > > > > > +do_test "-o quota" pass "usrquota" "true"
> > > > > > +do_test "-o uqnoenforce" pass "usrquota" "true"
> > > > > > +do_test "-o qnoenforce" pass "usrquota" "true"
> > > > > > +
> > > > > > +# Test gquota/grpquota/gqnoenforce
> > > > > > +do_test "" pass "grpquota" "false"
> > > > > > +do_test "-o gquota" pass "grpquota" "true"
> > > > > > +do_test "-o grpquota" pass "grpquota" "true"
> > > > > > +do_test "-o gqnoenforce" pass "gqnoenforce" "true"
> > > > > > +
> > > > > > +# Test pquota/prjquota/pqnoenforce
> > > > > > +do_test "" pass "prjquota" "false"
> > > > > > +do_test "-o pquota" pass "prjquota" "true"
> > > > > > +do_test "-o prjquota" pass "prjquota" "true"
> > > > > > +do_test "-o pqnoenforce" pass "pqnoenforce" "true"
> > > > > > +
> > > > > > +# Test sunit=3Dvalue and swidth=3Dvalue
> > > > > > +do_mkfs -d sunit=3D128,swidth=3D128
> > > > > > +do_test "-o sunit=3D8,swidth=3D8" pass "sunit=3D8,swidth=3D8=
" "true"
> > > > > > +do_test "-o sunit=3D8,swidth=3D64" pass "sunit=3D8,swidth=3D=
64" "true"
> > > > > > +do_test "-o sunit=3D128,swidth=3D128" pass "sunit=3D128,swid=
th=3D128"
> > > > > > "true"
> > > > > > +do_test "-o sunit=3D256,swidth=3D256" pass "sunit=3D256,swid=
th=3D256"
> > > > > > "true"
> > > > > > +do_test "-o sunit=3D2,swidth=3D2" fail
> > > > > > +
> > > > > > +# Test swalloc
> > > > > > +do_mkfs
> > > > > > +do_test "" pass "swalloc" "false"
> > > > > > +do_test "-o swalloc" pass "swalloc" "true"
> > > > > > +
> > > > > > +# Test wsync
> > > > > > +do_test "" pass "wsync" "false"
> > > > > > +do_test "-o wsync" pass "wsync" "true"
> > > > > > +
> > > > > > +echo "** end of testing"
> > > > > > +# success, all done
> > > > > > +status=3D0
> > > > > > +exit
> > > > > > diff --git a/tests/xfs/148.out b/tests/xfs/148.out
> > > > > > new file mode 100644
> > > > > > index 00000000..a71d9231
> > > > > > --- /dev/null
> > > > > > +++ b/tests/xfs/148.out
> > > > > > @@ -0,0 +1,6 @@
> > > > > > +QA output created by 148
> > > > > > +** create loop device
> > > > > > +** create loop log device
> > > > > > +** create loop mount point
> > > > > > +** start xfs mount testing ...
> > > > > > +** end of testing
> > > > > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > > > > index f4ebcd8c..019aebad 100644
> > > > > > --- a/tests/xfs/group
> > > > > > +++ b/tests/xfs/group
> > > > > > @@ -145,6 +145,7 @@
> > > > > >  145 dmapi
> > > > > >  146 dmapi
> > > > > >  147 dmapi
> > > > > > +148 auto quick mount
> > > > > >  150 dmapi
> > > > > >  151 dmapi
> > > > > >  152 dmapi
> > > > > > --=20
> > > > > > 2.20.1
> > > > > >=20
> >=20

