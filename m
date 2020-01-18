Return-Path: <SRS0=0TO6=3H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E01C33CB7
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 17:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 609C5246A9
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jan 2020 17:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MqQsJrOT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgARRYe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jan 2020 12:24:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48802 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgARRYe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 12:24:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IHNFbI086477;
        Sat, 18 Jan 2020 17:24:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=AfL6ggTVXA6oskZKXgc3RRJ9WhQC8Pkz/mqb2B2C/2U=;
 b=MqQsJrOTSueR/rhClHrgkT1nJ/0YRedPV6vIOo3lJIiBTdJHpvPCx+Q/WYqnCHFDH56x
 pAGAVP28WKnNpXdzFfkvzkoLelObv6AO+KccWxI4tp+MK5NonAK6DzGf4Evi6CctVOc8
 5y4WVujaoUrdZyVAvLYa1LlNMq2RaOUvWlPFdcoUvNjZYFxeb0V8ViSYCBZ/3Kv8xSYC
 02dmHC36ixWtwlI+7cb8kVK2RDv5saRwV46iVQy0/oXw6j7JdAVoUBC0+7YmqxTgiefE
 HqWYOK/UymSCoa0ehtfxkUIEAg84oYLvyBwJePCyzCqgZqvySd+WvhdrbjGAJ2+Xh/6V 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnqse46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jan 2020 17:24:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IHOQ3M046405;
        Sat, 18 Jan 2020 17:24:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xksuun9hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jan 2020 17:24:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00IHNWjw000364;
        Sat, 18 Jan 2020 17:23:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 09:23:32 -0800
Date:   Sat, 18 Jan 2020 09:23:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfstests: xfs mount option sanity test
Message-ID: <20200118172330.GE2149943@magnolia>
References: <20200115081132.22710-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200115081132.22710-1-zlang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001180142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 04:11:32PM +0800, Zorro Lang wrote:
> XFS is changing to suit the new mount API, so add this case to make
> sure the changing won't bring in regression issue on xfs mount option
> parse phase, and won't change some default behaviors either.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> Thanks the suggestions from Darrick, v3 did below changes:
> 1) Add more debug info output in do_mkfs and do_test.
> 2) A new function filter_loop.
> 3) Update .out file content
> 
> I've simply run this case on RHEL-7, RHEL-8 and upstream 5.5-rc4 kernel,
> all passed.

Something else I noticed -- if for whatever reason the mount fails due
to log size checks, the kernel logs things like:

xfs: Bad value for 'logbufs'
XFS (loop0): Mounting V5 Filesystem
XFS (loop0): Log size 3273 blocks too small, minimum size is 3299 blocks
XFS (loop0): AAIEEE! Log failed size checks. Abort!
XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 706

Which is then picked up by the dmesg scanner in fstests.  Maybe we need
(a) _check_dmesg between each _do_test iteration, and/or (b) filter that
particular assertion so we don't fail the test?

--D

> Thanks,
> 
>  tests/xfs/512     | 335 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/512.out | 100 ++++++++++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 436 insertions(+)
>  create mode 100755 tests/xfs/512
>  create mode 100644 tests/xfs/512.out
> 
> diff --git a/tests/xfs/512 b/tests/xfs/512
> new file mode 100755
> index 00000000..4de07ab8
> --- /dev/null
> +++ b/tests/xfs/512
> @@ -0,0 +1,335 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc. All Rights Reserved.
> +#
> +# FS QA Test No. 512
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
> +filter_loop()
> +{
> +	sed -e "s,\B$LOOP_MNT,LOOP_MNT,g" \
> +	    -e "s,\B$LOOP_DEV,LOOP_DEV,g" \
> +	    -e "s,\B$LOOP_SPARE_DEV,LOOP_SPARE_DEV,g"
> +}
> +
> +# avoid the effection from MKFS_OPTIONS
> +MKFS_OPTIONS=""
> +do_mkfs()
> +{
> +	echo "FORMAT: $@" | filter_loop | tee -a $seqres.full
> +	$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >>$seqres.full 2>$tmp.mkfs
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
> +	_mount $LOOP_DEV $LOOP_MNT $opts 2>>$seqres.full
> +	rc=$?
> +	if [ $rc -eq 0 ];then
> +		if [ "${mounted}" = "fail" ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: expect mount to fail, but it succeeded"
> +			return 1
> +		fi
> +		is_dev_mounted
> +		if [ $? -ne 0 ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: fs not mounted even mount return 0"
> +			return 1
> +		fi
> +	else
> +		if [ "${mounted}" = "pass" ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: expect mount to succeed, but it failed"
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
> +	echo ${info} | grep -q "${key}"
> +	rc=$?
> +	if [ $rc -eq 0 ];then
> +		if [ "$found" != "true" ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: expected to find \"$key\" in mount info \"$info\""
> +			return 1
> +		fi
> +	else
> +		if [ "$found" != "false" ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: did not expect to find \"$key\" in \"$info\""
> +			return 1
> +		fi
> +	fi
> +
> +	return 0
> +}
> +
> +do_test()
> +{
> +	# Print each argument, include nil ones
> +	echo -n "TEST:" | tee -a $seqres.full
> +	for i in "$@";do
> +		echo -n " \"$i\"" | filter_loop | tee -a $seqres.full
> +	done
> +	echo | tee -a $seqres.full
> +
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
> diff --git a/tests/xfs/512.out b/tests/xfs/512.out
> new file mode 100644
> index 00000000..d583b5da
> --- /dev/null
> +++ b/tests/xfs/512.out
> @@ -0,0 +1,100 @@
> +QA output created by 512
> +** create loop device
> +** create loop log device
> +** create loop mount point
> +** start xfs mount testing ...
> +FORMAT: 
> +TEST: "" "pass" "allocsize" "false"
> +TEST: "-o allocsize=4k" "pass" "allocsize=4k" "true"
> +TEST: "-o allocsize=1048576k" "pass" "allocsize=1048576k" "true"
> +TEST: "-o allocsize=2048" "fail"
> +TEST: "-o allocsize=2g" "fail"
> +FORMAT: -m crc=1
> +TEST: "" "pass" "attr2" "true"
> +TEST: "-o attr2" "pass" "attr2" "true"
> +TEST: "-o noattr2" "fail"
> +FORMAT: -m crc=0
> +TEST: "" "pass" "attr2" "true"
> +TEST: "-o attr2" "pass" "attr2" "true"
> +TEST: "-o noattr2" "pass" "attr2" "false"
> +FORMAT: 
> +TEST: "" "pass" "discard" "false"
> +TEST: "-o discard" "pass" "discard" "true"
> +TEST: "-o nodiscard" "pass" "discard" "false"
> +TEST: "" "pass" "grpid" "false"
> +TEST: "-o grpid" "pass" "grpid" "true"
> +TEST: "-o bsdgroups" "pass" "grpid" "true"
> +TEST: "-o nogrpid" "pass" "grpid" "false"
> +TEST: "-o sysvgroups" "pass" "grpid" "false"
> +TEST: "" "pass" "filestreams" "false"
> +TEST: "-o filestreams" "pass" "filestreams" "true"
> +TEST: "" "pass" "ikeep" "false"
> +TEST: "-o ikeep" "pass" "ikeep" "true"
> +TEST: "-o noikeep" "pass" "ikeep" "false"
> +TEST: "" "pass" "inode64" "true"
> +TEST: "-o inode32" "pass" "inode32" "true"
> +TEST: "-o inode64" "pass" "inode64" "true"
> +TEST: "" "pass" "largeio" "false"
> +TEST: "-o largeio" "pass" "largeio" "true"
> +TEST: "-o nolargeio" "pass" "largeio" "false"
> +TEST: "-o logbufs=8" "pass" "logbufs=8" "true"
> +TEST: "-o logbufs=2" "pass" "logbufs=2" "true"
> +TEST: "-o logbufs=1" "fail"
> +TEST: "-o logbufs=9" "fail"
> +TEST: "-o logbufs=99999999999999" "fail"
> +FORMAT: -m crc=1 -l version=2
> +TEST: "-o logbsize=16384" "pass" "logbsize=16k" "true"
> +TEST: "-o logbsize=16k" "pass" "logbsize=16k" "true"
> +TEST: "-o logbsize=32k" "pass" "logbsize=32k" "true"
> +TEST: "-o logbsize=64k" "pass" "logbsize=64k" "true"
> +TEST: "-o logbsize=128k" "pass" "logbsize=128k" "true"
> +TEST: "-o logbsize=256k" "pass" "logbsize=256k" "true"
> +TEST: "-o logbsize=8k" "fail"
> +TEST: "-o logbsize=512k" "fail"
> +FORMAT: -m crc=0 -l version=1
> +TEST: "-o logbsize=16384" "pass" "logbsize=16k" "true"
> +TEST: "-o logbsize=16k" "pass" "logbsize=16k" "true"
> +TEST: "-o logbsize=32k" "pass" "logbsize=32k" "true"
> +TEST: "-o logbsize=64k" "fail"
> +FORMAT: 
> +TEST: "" "pass" "logdev" "false"
> +TEST: "-o logdev=LOOP_SPARE_DEV" "fail"
> +FORMAT: -l logdev=LOOP_SPARE_DEV
> +TEST: "-o logdev=LOOP_SPARE_DEV" "pass" "logdev=LOOP_SPARE_DEV" "true"
> +TEST: "" "fail"
> +FORMAT: 
> +TEST: "" "pass" "noalign" "false"
> +TEST: "-o noalign" "pass" "noalign" "true"
> +TEST: "" "pass" "norecovery" "false"
> +TEST: "-o norecovery,ro" "pass" "norecovery" "true"
> +TEST: "-o norecovery" "fail"
> +TEST: "" "pass" "nouuid" "false"
> +TEST: "-o nouuid" "pass" "nouuid" "true"
> +TEST: "" "pass" "noquota" "true"
> +TEST: "-o noquota" "pass" "noquota" "true"
> +TEST: "" "pass" "usrquota" "false"
> +TEST: "-o uquota" "pass" "usrquota" "true"
> +TEST: "-o usrquota" "pass" "usrquota" "true"
> +TEST: "-o quota" "pass" "usrquota" "true"
> +TEST: "-o uqnoenforce" "pass" "usrquota" "true"
> +TEST: "-o qnoenforce" "pass" "usrquota" "true"
> +TEST: "" "pass" "grpquota" "false"
> +TEST: "-o gquota" "pass" "grpquota" "true"
> +TEST: "-o grpquota" "pass" "grpquota" "true"
> +TEST: "-o gqnoenforce" "pass" "gqnoenforce" "true"
> +TEST: "" "pass" "prjquota" "false"
> +TEST: "-o pquota" "pass" "prjquota" "true"
> +TEST: "-o prjquota" "pass" "prjquota" "true"
> +TEST: "-o pqnoenforce" "pass" "pqnoenforce" "true"
> +FORMAT: -d sunit=128,swidth=128
> +TEST: "-o sunit=8,swidth=8" "pass" "sunit=8,swidth=8" "true"
> +TEST: "-o sunit=8,swidth=64" "pass" "sunit=8,swidth=64" "true"
> +TEST: "-o sunit=128,swidth=128" "pass" "sunit=128,swidth=128" "true"
> +TEST: "-o sunit=256,swidth=256" "pass" "sunit=256,swidth=256" "true"
> +TEST: "-o sunit=2,swidth=2" "fail"
> +FORMAT: 
> +TEST: "" "pass" "swalloc" "false"
> +TEST: "-o swalloc" "pass" "swalloc" "true"
> +TEST: "" "pass" "wsync" "false"
> +TEST: "-o wsync" "pass" "wsync" "true"
> +** end of testing
> diff --git a/tests/xfs/group b/tests/xfs/group
> index c7253cf1..a6b09a8d 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -509,3 +509,4 @@
>  509 auto ioctl
>  510 auto ioctl quick
>  511 auto quick quota
> +512 auto quick mount
> -- 
> 2.20.1
> 
