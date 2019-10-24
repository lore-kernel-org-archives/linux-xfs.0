Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD65CA9EBC
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 04:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA0C621925
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 04:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iyxI6uCk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406616AbfJXEwO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 00:52:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33740 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfJXEwO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 00:52:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9O4nXp6087722;
        Thu, 24 Oct 2019 04:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=D86G79K9s9/7971GwIzFZC91QrznxheLFioXcWmQ+cQ=;
 b=iyxI6uCkMeJdThun5PAtNxraZzqC6QSXWLl8pDwzWNThWGjjhWpsnSc14CIWxx/QFqsl
 e0xFsLhEKAyzQtlPAwOK1ltmS3Xe8voR0Zc7nYnukqpzHjt8H2uMq1B4wFcwuOmr6gXD
 mAa7Xvcnw6/ZWDLnEAH+sR6CS4Ri8JwcfIXV3peaUAu+KwvzkuViADrEtf40uHC3BcZv
 244ElyhRl/CJ9mOwiswvAalfi2DwuvknGmmr8a79DcRR6GmLUzlYjJTRLSogk0L4bjin
 C/RWWZRz9WYpOWz9PekONMfCrz5y1eZ0hcruxESdbrpdKWC1tmZuRjmHdwlntss1PFBe vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vqu4r0ya3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 04:52:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9O4nViS044083;
        Thu, 24 Oct 2019 04:52:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vu0fne695-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 04:52:10 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9O4q87k018019;
        Thu, 24 Oct 2019 04:52:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Oct 2019 21:52:08 -0700
Date:   Wed, 23 Oct 2019 21:52:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: make sure the kernel and repair tools catch
 bad names
Message-ID: <20191024045207.GF6706@magnolia>
References: <157170897992.1172383.2128928990011336996.stgit@magnolia>
 <157170899277.1172383.10473571682266133494.stgit@magnolia>
 <20191024003106.GD6706@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024003106.GD6706@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240044
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240044
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 23, 2019 at 05:31:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we actually catch bad names in the kernel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix various things as pointed out by Eryu

Self NAK, I found some bugs in this test and withdraw this patch.

--D

> ---
>  tests/xfs/749     |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/749.out |    3 ++
>  tests/xfs/group   |    1 +
>  3 files changed, 110 insertions(+)
>  create mode 100755 tests/xfs/749
>  create mode 100644 tests/xfs/749.out
> 
> diff --git a/tests/xfs/749 b/tests/xfs/749
> new file mode 100755
> index 00000000..e8371351
> --- /dev/null
> +++ b/tests/xfs/749
> @@ -0,0 +1,106 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-newer
> +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 749
> +#
> +# See if we catch corrupt directory names or attr names with nulls or slashes
> +# in them.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	$UMOUNT_PROG $mntpt > /dev/null 2>&1
> +	test -n "$loopdev" && _destroy_loop_device $loopdev > /dev/null 2>&1
> +	rm -r -f $imgfile $mntpt $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_test
> +_require_attrs
> +
> +rm -f $seqres.full
> +
> +imgfile=$TEST_DIR/img-$seq
> +mntpt=$TEST_DIR/mount-$seq
> +testdir=$mntpt/testdir
> +testfile=$mntpt/testfile
> +nullstr="too_many_beans"
> +slashstr="are_bad_for_you"
> +
> +# Format image file
> +$XFS_IO_PROG -f -c 'truncate 40m' $imgfile
> +loopdev=$(_create_loop_device $imgfile)
> +_mkfs_dev $loopdev >> $seqres.full
> +
> +# Mount image file
> +mkdir -p $mntpt
> +_mount $loopdev $mntpt
> +
> +# Create directory entries
> +mkdir -p $testdir
> +touch $testdir/$nullstr
> +touch $testdir/$slashstr
> +
> +# Create attrs
> +touch $testfile
> +$ATTR_PROG -s $nullstr -V heh $testfile >> $seqres.full
> +$ATTR_PROG -s $slashstr -V heh $testfile >> $seqres.full
> +
> +# Corrupt the entries
> +$UMOUNT_PROG $mntpt
> +_destroy_loop_device $loopdev
> +cp $imgfile $imgfile.old
> +sed -b \
> +	-e "s/$nullstr/too_many\x00beans/g" \
> +	-e "s/$slashstr/are_bad\/for_you/g" \
> +	-i $imgfile
> +test "$(md5sum < $imgfile)" != "$(md5sum < $imgfile.old)" ||
> +	_fail "sed failed to change the image file?"
> +rm -f $imgfile.old
> +loopdev=$(_create_loop_device $imgfile)
> +_mount $loopdev $mntpt
> +
> +# Try to access the corrupt metadata
> +ls $testdir >> $seqres.full 2> $tmp.err
> +$ATTR_PROG -l $testfile >> $seqres.full 2>> $tmp.err
> +cat $tmp.err >> $seqres.full
> +cat $tmp.err | _filter_test_dir | sed -e '/Could not list/d'
> +
> +# Does scrub complain about this?
> +if _supports_xfs_scrub $mntpt $loopdev; then
> +	$XFS_SCRUB_PROG -n $mntpt >> $seqres.full 2>&1
> +	res=$?
> +	test $((res & 1)) -eq 0 && \
> +		echo "scrub failed to report corruption ($res)"
> +fi
> +
> +# Does repair complain about this?
> +$UMOUNT_PROG $mntpt
> +$XFS_REPAIR_PROG -n $loopdev >> $seqres.full 2>&1
> +res=$?
> +test $res -eq 1 || \
> +	echo "repair failed to report corruption ($res)"
> +
> +_destroy_loop_device $loopdev
> +loopdev=
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/749.out b/tests/xfs/749.out
> new file mode 100644
> index 00000000..db3b1beb
> --- /dev/null
> +++ b/tests/xfs/749.out
> @@ -0,0 +1,3 @@
> +QA output created by 749
> +ls: cannot access 'TEST_DIR/mount-749/testdir': Structure needs cleaning
> +attr_list: Structure needs cleaning
> diff --git a/tests/xfs/group b/tests/xfs/group
> index f4ebcd8c..9600cb4e 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -507,3 +507,4 @@
>  509 auto ioctl
>  510 auto ioctl quick
>  511 auto quick quota
> +749 auto quick fuzzers
