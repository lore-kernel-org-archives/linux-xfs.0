Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247C1C3F68F
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 18:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5C7E222C2
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 18:00:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kWat1rxx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgAMSAo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 13:00:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43878 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgAMSAo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 13:00:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DHwSOa137836;
        Mon, 13 Jan 2020 18:00:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=Co1Dk9bCDrHARSxyySWsn5pWkbnOfs2yXAv3KVUZww0=;
 b=kWat1rxx26SIe4ELCS/JpBalb5NWMopSm2UYNbmDslENusrQZNpssyg03BW+YuGwiyrM
 VswElQf5Uo5kaIje/16QdQ83hJ5xa4pkgBJWSl4lCCCviit6BF2kRAbHl93eQyzh9q6h
 14B11LOfwJoOSKMOcmxXnaIaB6M92kcF8MO7Db9ElTJXGDDfvhwMx7DbcA143J6DwkMD
 hy/Hn/aV7H+t68wiMhKZOZXl/JBtDr8HrAhZPFBb1gf2thWPXP/dV1k0uQOn+XTZjrSb
 /0++Tt29UBS1bwMQD/HRxyyyX43s5us8tkfCnyHfAtxxr440h/7jdFsHk3J5fx1K9Bmf xQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xf73tgmxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 18:00:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00DHdQgA018352;
        Mon, 13 Jan 2020 18:00:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xfrgj4fcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 18:00:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00DI0cwK027025;
        Mon, 13 Jan 2020 18:00:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 10:00:37 -0800
Date:   Mon, 13 Jan 2020 10:00:36 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfstests: xfs mount option sanity test
Message-ID: <20200113180036.GH8247@magnolia>
References: <20191030103410.2239-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191030103410.2239-1-zlang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001130144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9499 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001130145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 06:34:10PM +0800, Zorro Lang wrote:
> XFS is changing to suit the new mount API, so add this case to make
> sure the changing won't bring in regression issue on xfs mount option
> parse phase, and won't change some default behaviors either.

This testcase examines the intersection of some mkfs options and a large
number of mount options, but it doesn't log any breadcrumbs of which
scenario it's testing at any given time.  When something goes wrong,
it's /very/ difficult to map that back to the do_mkfs/do_test call.

(FWIW I added this test as xfs/997 and attached the diff I needed to
debug the problem I complained about a month ago.)

> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> V2 did below changes:
> 1) Fix wrong output messages in _do_test function
> 2) Remove logbufs=N and logbsize=N default display test. Lastest upstream
>    kernel displays these options in /proc/mounts by default, but old kernel
>    doesn't show them except user indicate these options when mount xfs.
>    Refer to https://marc.info/?l=fstests&m=157199699615477&w=2
> 
> Thanks,
> Zorro
> 
>  tests/xfs/148     | 320 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/148.out |   6 +
>  tests/xfs/group   |   1 +
>  3 files changed, 327 insertions(+)
>  create mode 100755 tests/xfs/148
>  create mode 100644 tests/xfs/148.out
> 
> diff --git a/tests/xfs/148 b/tests/xfs/148
> new file mode 100755
> index 00000000..a662f6f7
> --- /dev/null
> +++ b/tests/xfs/148
> @@ -0,0 +1,320 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc. All Rights Reserved.
> +#
> +# FS QA Test 148
> +#
> +# XFS mount options sanity check, refer to 'man 5 xfs'.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	$UMOUNT_PROG $LOOP_MNT 2>/dev/null
> +	if [ -n "$LOOP_DEV" ];then
> +		_destroy_loop_device $LOOP_DEV 2>/dev/null
> +	fi
> +	if [ -n "$LOOP_SPARE_DEV" ];then
> +		_destroy_loop_device $LOOP_SPARE_DEV 2>/dev/null
> +	fi
> +	rm -f $LOOP_IMG
> +	rm -f $LOOP_SPARE_IMG
> +	rmdir $LOOP_MNT
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
> +LOOP_IMG=$TEST_DIR/$seq.dev
> +LOOP_SPARE_IMG=$TEST_DIR/$seq.logdev
> +LOOP_MNT=$TEST_DIR/$seq.mnt
> +
> +echo "** create loop device"
> +$XFS_IO_PROG -f -c "falloc 0 1g" $LOOP_IMG
> +LOOP_DEV=`_create_loop_device $LOOP_IMG`
> +
> +echo "** create loop log device"
> +$XFS_IO_PROG -f -c "falloc 0 512m" $LOOP_SPARE_IMG
> +LOOP_SPARE_DEV=`_create_loop_device $LOOP_SPARE_IMG`
> +
> +echo "** create loop mount point"
> +rmdir $LOOP_MNT 2>/dev/null
> +mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
> +
> +# avoid the effection from MKFS_OPTIONS
> +MKFS_OPTIONS=""
> +do_mkfs()
> +{

Please log what options we're passing.

> +	$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >$seqres.full 2>$tmp.mkfs

>>$seqres.full, because this otherwise obliterates seqres.full

> +	if [ "${PIPESTATUS[0]}" -ne 0 ]; then
> +		_fail "Fails on _mkfs_dev $* $LOOP_DEV"
> +	fi
> +	. $tmp.mkfs
> +}
> +
> +is_dev_mounted()
> +{
> +	findmnt --source $LOOP_DEV >/dev/null
> +	return $?
> +}
> +
> +get_mount_info()
> +{
> +	findmnt --source $LOOP_DEV -o OPTIONS -n
> +}
> +
> +force_unmount()
> +{
> +	$UMOUNT_PROG $LOOP_MNT >/dev/null 2>&1
> +}
> +
> +# _do_test <mount options> <should be mounted?> [<key string> <key should be found?>]
> +_do_test()
> +{
> +	local opts="$1"
> +	local mounted="$2"	# pass or fail
> +	local key="$3"
> +	local found="$4"	# true or false
> +	local rc
> +	local info
> +
> +	# mount test
> +	_mount $LOOP_DEV $LOOP_MNT $opts 2>/dev/null

Please capture the stderr output to seqres.full

> +	rc=$?
> +	if [ $rc -eq 0 ];then
> +		if [ "${mounted}" = "fail" ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: expect ${mounted}, but pass"

The wording of these error messages is a little weird, I'll fix that....

> +			return 1
> +		fi
> +		is_dev_mounted
> +		if [ $? -ne 0 ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: fs not mounted even mount return 0"
> +			return 1
> +		fi
> +	else
> +		if [ "${mount_ret}" = "pass" ];then

$mount_ret is not defined here, did you mean $mounted?

> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: expect ${mounted}, but fail"
> +			return 1
> +		fi
> +		is_dev_mounted
> +		if [ $? -eq 0 ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: fs is mounted even mount return non-zero"
> +			return 1
> +		fi
> +	fi
> +
> +	# Skip below checking if "$key" argument isn't specified
> +	if [ -z "$key" ];then
> +		return 0
> +	fi
> +	# Check the mount options after fs mounted.
> +	info=`get_mount_info`
> +	echo $info | grep -q "${key}"

echo "$info" so we can at least pretend to have proper string handling
;)

> +	rc=$?
> +	if [ $rc -eq 0 ];then
> +		if [ "$found" != "true" ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: expect there's not $key in $info, but not found"
> +			return 1
> +		fi
> +	else
> +		if [ "$found" != "false" ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: expect there's $key in $info, but found"

So earlier, I complained that I was seeing this error in the case where
the fs was formatted with rmapbt=1 and the mount options were "-o
logbsize=16k".  It turns out that formatting a 1G fs with an internal
log results in a log that is the minimum allowed size with the default
mount options.

When the test adds in the logbsize=16k argument, this increases the
kernel's expectation of minimum log size from 3273 to 3299 blocks, so
the mount fails.  The stderr output from mount is discarded, which
means one has to refer to dmesg to figure out that the mount failed.
The test leaves no mkfs/mount option breadcrumb trail, so it is
difficult even to figure out where we were in the test.

The erroneous $mount_ret logic allows the test to escape to the mount
info testing, which of course fails because the fs didn't mount, which
produced the broken-looking error message about "expect there's
logbsize=16k in  , but not found".

So ... I've fixed this test up enough to be (mostly) passable, but that
leaves the problem that a filesystem formatted with the minimum size log
fails to mount when one starts running with non-default mount options.
That alone might not be a big deal since we always advise to accept the
defaults unless a customer's workload proves that a non-default option
is better, however...

A filesystem formatted with the mininum log size is at high risk of
encountering mount failures in the future if we are not /exceedingly/
careful about changing things that cause perturbations in the log
reservation calculations.  I observed that at some point between 4.15
and 4.18 the minimum log size calculation decreased (when formatting
with reflink=1), though's only likely to affect people moving to an
older kernel, so we're probably ok for now.

I /think/ a solution here is to change mkfs to detect when the log size
it proposes to format is the same as the minimum log size and increase
it by (say) 10% to buffer the fs against these kinds of fluctuations.
Obviously if the user forces the log size to minimum then we'll continue
to respect that, but we don't have to format that way by default.

--D

> +			return 1
> +		fi
> +	fi
> +
> +	return 0
> +}
> +
> +do_test()
> +{

Please log what mount options we're testing here.

--D

> +	# force unmount before testing
> +	force_unmount
> +	_do_test "$@"
> +	# force unmount after testing
> +	force_unmount
> +}
> +
> +echo "** start xfs mount testing ..."
> +# Test allocsize=size
> +# Valid values for this option are page size (typically 4KiB) through to 1GiB
> +do_mkfs
> +if [ $dbsize -ge 1024 ];then
> +	blsize="$((dbsize / 1024))k"
> +fi
> +do_test "" pass "allocsize" "false"
> +do_test "-o allocsize=$blsize" pass "allocsize=$blsize" "true"
> +do_test "-o allocsize=1048576k" pass "allocsize=1048576k" "true"
> +do_test "-o allocsize=$((dbsize / 2))" fail
> +do_test "-o allocsize=2g" fail
> +
> +# Test attr2
> +do_mkfs -m crc=1
> +do_test "" pass "attr2" "true"
> +do_test "-o attr2" pass "attr2" "true"
> +do_test "-o noattr2" fail
> +do_mkfs -m crc=0
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
> +# Test logbufs=value. Valid numbers range from 2–8 inclusive.
> +# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_size)
> +# prints "logbufs=N" in /proc/mounts, but old kernel not. So the default
> +# 'display' about logbufs can't be expected, disable this test.
> +#do_test "" pass "logbufs" "false"
> +do_test "-o logbufs=8" pass "logbufs=8" "true"
> +do_test "-o logbufs=2" pass "logbufs=2" "true"
> +do_test "-o logbufs=1" fail
> +do_test "-o logbufs=9" fail
> +do_test "-o logbufs=99999999999999" fail
> +
> +# Test logbsize=value.
> +do_mkfs -m crc=1 -l version=2
> +# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_size)
> +# prints "logbsize=N" in /proc/mounts, but old kernel not. So the default
> +# 'display' about logbsize can't be expected, disable this test.
> +#do_test "" pass "logbsize" "false"
> +do_test "-o logbsize=16384" pass "logbsize=16k" "true"
> +do_test "-o logbsize=16k" pass "logbsize=16k" "true"
> +do_test "-o logbsize=32k" pass "logbsize=32k" "true"
> +do_test "-o logbsize=64k" pass "logbsize=64k" "true"
> +do_test "-o logbsize=128k" pass "logbsize=128k" "true"
> +do_test "-o logbsize=256k" pass "logbsize=256k" "true"
> +do_test "-o logbsize=8k" fail
> +do_test "-o logbsize=512k" fail
> +do_mkfs -m crc=0 -l version=1
> +# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_size)
> +# prints "logbsize=N" in /proc/mounts, but old kernel not. So the default
> +# 'display' about logbsize can't be expected, disable this test.
> +#do_test "" pass "logbsize" "false"
> +do_test "-o logbsize=16384" pass "logbsize=16k" "true"
> +do_test "-o logbsize=16k" pass "logbsize=16k" "true"
> +do_test "-o logbsize=32k" pass "logbsize=32k" "true"
> +do_test "-o logbsize=64k" fail
> +
> +# Test logdev
> +do_mkfs
> +do_test "" pass "logdev" "false"
> +do_test "-o logdev=$LOOP_SPARE_DEV" fail
> +do_mkfs -l logdev=$LOOP_SPARE_DEV
> +do_test "-o logdev=$LOOP_SPARE_DEV" pass "logdev=$LOOP_SPARE_DEV" "true"
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
> +# Test sunit=value and swidth=value
> +do_mkfs -d sunit=128,swidth=128
> +do_test "-o sunit=8,swidth=8" pass "sunit=8,swidth=8" "true"
> +do_test "-o sunit=8,swidth=64" pass "sunit=8,swidth=64" "true"
> +do_test "-o sunit=128,swidth=128" pass "sunit=128,swidth=128" "true"
> +do_test "-o sunit=256,swidth=256" pass "sunit=256,swidth=256" "true"
> +do_test "-o sunit=2,swidth=2" fail
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
> +status=0
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
> -- 
> 2.20.1
> 
