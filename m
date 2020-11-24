Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBC7C64E75
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 16:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E4F206D8
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 16:53:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hCELUgOL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390584AbgKXQwu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 11:52:50 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43170 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731531AbgKXQwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 11:52:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOGmrUt181460;
        Tue, 24 Nov 2020 16:52:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4jf4amatsj2lieNy/ni30DNFsNjjBEkV8BKuAi2YL2E=;
 b=hCELUgOLjyRRSNzjtxjlowGXLaVDeARzggJaapCrjprM+bj+fzj/+PWsM5lcfIG3CzFy
 9ek9WIy1UckWJx3QPGBbYXUFbW3pgFwMw5cT8zXzeX4RpkFl8cbVMa3ZrOQAcQqV97U9
 VDN8TVIZuYytweTCz+zVbXlWHFlKwyovC+E+R3flhBonF4BM3TazRdAmX5wTv2Jl9faE
 NqkOLPhgiD5bGpJpxqNKIWGSNbgnt6yjGcbQRfDlurSjPPouVCOSYiXPqAhnuCCDieLt
 8s6LRN6JnH3u5hX7DbMJ1LKztCKvdXbva5wnIKvKvQpRbPw/wr4Fgc/Nj0h5ket+3BEH zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34xrdav0jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 16:52:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOGo0MM123979;
        Tue, 24 Nov 2020 16:52:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34ycfnjwjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 16:52:46 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AOGqjTY030908;
        Tue, 24 Nov 2020 16:52:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Nov 2020 08:52:45 -0800
Date:   Tue, 24 Nov 2020 08:52:44 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3] generic: add test for XFS forkoff miscalcution on
 32-bit platform
Message-ID: <20201124165244.GI7880@magnolia>
References: <20201123082047.2991878-1-hsiangkao@redhat.com>
 <20201124101145.3230728-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124101145.3230728-1-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9815 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9815 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240104
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 24, 2020 at 06:11:45PM +0800, Gao Xiang wrote:
> There is a regression that recent XFS_LITINO(mp) update causes
> xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.
> 
> Therefore, one result is
>   "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
> 
> Add a regression test in fstests generic to look after that since
> the testcase itself isn't xfs-specific.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> changes since v2:
>  - "_require_no_xfs_bug_on_assert" to avoid crashing the system (Darrick);
>  - refine a commit for more details (Darrick)
> 
>  tests/generic/618     | 75 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/618.out |  4 +++
>  tests/generic/group   |  1 +
>  3 files changed, 80 insertions(+)
>  create mode 100755 tests/generic/618
>  create mode 100644 tests/generic/618.out
> 
> diff --git a/tests/generic/618 b/tests/generic/618
> new file mode 100755
> index 00000000..f1c1605e
> --- /dev/null
> +++ b/tests/generic/618
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc. All Rights Reserved.
> +#
> +# FS QA Test 618
> +#
> +# Verify that forkoff can be returned as 0 properly if it isn't
> +# able to fit inline for XFS.
> +# However, this test is fs-neutral and can be done quickly so
> +# leave it in generic
> +# This test verifies the problem fixed in kernel with commit
> +# ada49d64fb35 ("xfs: fix forkoff miscalculation related to XFS_LITINO(mp)")
> +
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
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs generic
> +_require_scratch
> +_require_attrs user
> +
> +if [ $FSTYP = "xfs" ]; then
> +	# avoid crashing the system if possible
> +	_require_no_xfs_bug_on_assert
> +
> +	# Use fixed inode size 512, so both v4 and v5 can be tested,
> +	# and also make sure the issue can be triggered if the default
> +	# inode size is changed later.
> +	MKFS_OPTIONS="$MKFS_OPTIONS -i size=512"
> +fi
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount
> +
> +localfile="${SCRATCH_MNT}/testfile"
> +touch $localfile
> +
> +# value cannot exceed XFS_ATTR_SF_ENTSIZE_MAX (256) or it will turn into leaf
> +# form directly; the following combination can trigger the issue for both v4
> +# (XFS_LITINO = 412) & v5 (XFS_LITINO = 336) fses, in details the 2nd setattr
> +# causes an integer underflow that is incorrectly typecast, leading to the
> +# assert triggering.
> +"${SETFATTR_PROG}" -n user.0 -v "`seq 0 80`" "${localfile}"
> +"${SETFATTR_PROG}" -n user.1 -v "`seq 0 80`" "${localfile}"
> +
> +# Make sure that changes are written to disk
> +_scratch_cycle_mount
> +
> +# getfattr won't succeed with the expected result if fails
> +_getfattr --absolute-names -ebase64 -d $localfile | tail -n +2 | sort
> +
> +_scratch_unmount
> +status=0
> +exit
> diff --git a/tests/generic/618.out b/tests/generic/618.out
> new file mode 100644
> index 00000000..848fdc58
> --- /dev/null
> +++ b/tests/generic/618.out
> @@ -0,0 +1,4 @@
> +QA output created by 618
> +
> +user.0=0sMAoxCjIKMwo0CjUKNgo3CjgKOQoxMAoxMQoxMgoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAoyMQoyMgoyMwoyNAoyNQoyNgoyNwoyOAoyOQozMAozMQozMgozMwozNAozNQozNgozNwozOAozOQo0MAo0MQo0Mgo0Mwo0NAo0NQo0Ngo0Nwo0OAo0OQo1MAo1MQo1Mgo1Mwo1NAo1NQo1Ngo1Nwo1OAo1OQo2MAo2MQo2Mgo2Mwo2NAo2NQo2Ngo2Nwo2OAo2OQo3MAo3MQo3Mgo3Mwo3NAo3NQo3Ngo3Nwo3OAo3OQo4MA==
> +user.1=0sMAoxCjIKMwo0CjUKNgo3CjgKOQoxMAoxMQoxMgoxMwoxNAoxNQoxNgoxNwoxOAoxOQoyMAoyMQoyMgoyMwoyNAoyNQoyNgoyNwoyOAoyOQozMAozMQozMgozMwozNAozNQozNgozNwozOAozOQo0MAo0MQo0Mgo0Mwo0NAo0NQo0Ngo0Nwo0OAo0OQo1MAo1MQo1Mgo1Mwo1NAo1NQo1Ngo1Nwo1OAo1OQo2MAo2MQo2Mgo2Mwo2NAo2NQo2Ngo2Nwo2OAo2OQo3MAo3MQo3Mgo3Mwo3NAo3NQo3Ngo3Nwo3OAo3OQo4MA==
> diff --git a/tests/generic/group b/tests/generic/group
> index 94e860b8..eca9d619 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -620,3 +620,4 @@
>  615 auto rw
>  616 auto rw io_uring stress
>  617 auto rw io_uring stress
> +618 auto quick attr
> -- 
> 2.18.4
> 
