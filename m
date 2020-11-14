Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71545C63697
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 141D122258
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ljxyc/5t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgKNAIK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:08:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34124 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgKNAIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:08:09 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE03ra3022893;
        Sat, 14 Nov 2020 00:08:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=sBvcuevPREViU7kN9a5mWKPaYIklP+W1x4bfaAcmXLM=;
 b=Ljxyc/5tXtKscX49O+Ry1vbezZe9O9hQjPoKspG/d71JeFuiFkvJkohg/SHXZGhFrgGM
 6tu0s5w6nf/c0IuwzGBhruDm2E08X9TRl5yeJfd4bn9XWl9SvuQeip/SZXaDctkNUEtq
 9GcGA2Uq87Kp0ij3xUhS8Aa16Q1pbn1L/BxGtCeiPQzgXhcvaKImOZoHDHbp56g9DKj1
 wMdBOXU4n+RtmYcV795LKJxEo2gvf9Ltqa/VhKBiKC2vpXSjEx+ykejePotAkZOBlcKq
 AqWxCLOt9qs153V8lmZN/K+PrnrOyslXEOvK16pTTwGWw29bhJh8xKgm33CjofM4M7Bz BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72f2wuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 00:08:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0551L063975;
        Sat, 14 Nov 2020 00:06:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34p5g5q0pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:06:06 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AE065Q5004316;
        Sat, 14 Nov 2020 00:06:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 16:06:05 -0800
Date:   Fri, 13 Nov 2020 16:06:02 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: Stress test with with
 bmap_alloc_minlen_extent error tag enabled
Message-ID: <20201114000602.GZ9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-12-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113112704.28798-12-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=5 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130155
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 13, 2020 at 04:57:03PM +0530, Chandan Babu R wrote:
> This commit adds a stress test that executes fsstress with
> bmap_alloc_minlen_extent error tag enabled.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/531     | 85 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/531.out |  6 ++++
>  tests/xfs/group   |  1 +
>  3 files changed, 92 insertions(+)
>  create mode 100755 tests/xfs/531
>  create mode 100644 tests/xfs/531.out
> 
> diff --git a/tests/xfs/531 b/tests/xfs/531
> new file mode 100755
> index 00000000..e846cc0e
> --- /dev/null
> +++ b/tests/xfs/531
> @@ -0,0 +1,85 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 531
> +#
> +# Execute fsstress with bmap_alloc_minlen_extent error tag enabled.
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
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/inject
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full

Why is a 1G fs required?

> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +testfile=$SCRATCH_MNT/testfile
> +
> +echo "Consume free space"
> +dd if=/dev/zero of=${testfile} bs=${bsize} >> $seqres.full 2>&1
> +sync
> +
> +echo "Create fragmented filesystem"
> +$here/src/punch-alternating $testfile >> $seqres.full
> +sync
> +
> +echo "Inject bmap_alloc_minlen_extent error tag"
> +xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> +
> +echo "Execute fsstress in background"
> +$FSSTRESS_PROG -d $SCRATCH_MNT -p128 -n999999999 \

-n and -p ought to be computed from TIME_FACTOR and LOAD_FACTOR.

--D

> +		 -f bulkstat=0 \
> +		 -f bulkstat1=0 \
> +		 -f fiemap=0 \
> +		 -f getattr=0 \
> +		 -f getdents=0 \
> +		 -f getfattr=0 \
> +		 -f listfattr=0 \
> +		 -f mread=0 \
> +		 -f read=0 \
> +		 -f readlink=0 \
> +		 -f readv=0 \
> +		 -f stat=0 \
> +		 -f aread=0 \
> +		 -f dread=0 > /dev/null 2>&1 &
> +
> +fsstress_pid=$!
> +sleep 2m
> +
> +echo "Killing fsstress process $fsstress_pid ..." >> $seqres.full
> +kill $fsstress_pid >> $seqres.full
> +wait $fsstress_pid
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/531.out b/tests/xfs/531.out
> new file mode 100644
> index 00000000..e0a419c2
> --- /dev/null
> +++ b/tests/xfs/531.out
> @@ -0,0 +1,6 @@
> +QA output created by 531
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject bmap_alloc_minlen_extent error tag
> +Execute fsstress in background
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 81a15582..f4cb5af6 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -528,3 +528,4 @@
>  528 auto quick reflink
>  529 auto quick reflink
>  530 auto quick
> +531 auto stress
> -- 
> 2.28.0
> 
