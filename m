Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FB6C4727E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 20:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E80B9239EC
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 20:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tPsOrmzn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgIXUTo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 16:19:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36668 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIXUTo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 16:19:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OKJScp108186;
        Thu, 24 Sep 2020 20:19:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kd8unXUNvcqjlsAx1geqllfF2i2QxDG4GcegL7gzpnM=;
 b=tPsOrmzntXFy/waxz3UUqX7oC5z4F1iU3aQ6WOu7yPmBbDHzds62GEtgqUe5Q/KWBIhy
 LkFSkZub4bhfGuuST7Bgh/HZOa/9aDrgkM5DdsKMFhTNeBGptTIctXv65dMiv3Cz70zm
 yhe2VjMjWbZMqA2zPN8YJbxRWjhTUGTaJKm1mogHQxgre+TfWlOCgNlm2mM3uArIMuyq
 CbIdu/4X2PWmSWtvz5E7TRc+sRLOsnhjgaM/E3y1y9Mtq866R6mLjDNsRHkHMJuWiBUc
 7ZUxCSIBn4SLGhijmN4s+LuuEWjARhNKJTCmKuDsoGMkUZZ8A8MA7UxWMbDEyKmWedCj 6w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33q5rgrq7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 20:19:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OKFW7M108784;
        Thu, 24 Sep 2020 20:17:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33nux3cs1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 20:17:41 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08OKHeXu015819;
        Thu, 24 Sep 2020 20:17:40 GMT
Received: from localhost (/10.159.232.188)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Sep 2020 13:17:40 -0700
Date:   Thu, 24 Sep 2020 13:17:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic: test reflinked file corruption after short COW
Message-ID: <20200924201739.GJ7955@magnolia>
References: <b63354c6-795d-78e2-4002-83c08a373171@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b63354c6-795d-78e2-4002-83c08a373171@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9754 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9754 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 01:19:49PM -0500, Eric Sandeen wrote:
> This test essentially creates an existing COW extent which
> covers the first 1M, and then does another IO that overlaps it,
> but extends beyond it.  The bug was that we did not trim the
> new IO to the end of the existing COW extent, and so the IO
> extended past the COW blocks and corrupted the reflinked files(s).
> 
> The bug came and went upstream; it will be hopefully fixed in the
> 5.4.y stable series via:
> 
> https://lore.kernel.org/stable/e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com/
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/tests/generic/612 b/tests/generic/612
> new file mode 100755
> index 00000000..5a765a0c
> --- /dev/null
> +++ b/tests/generic/612
> @@ -0,0 +1,83 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 612
> +#
> +# Regression test for reflink corruption present as of:
> +# 78f0cc9d55cb "xfs: don't use delalloc extents for COW on files with extsize hints"
> +# and (inadvertently) fixed as of:
> +# 36adcbace24e "xfs: fill out the srcmap in iomap_begin"

This probably should list the name of the patch that fixes it for 5.4.

With that added,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

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
> +. ./common/reflink
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_test
> +_require_test_reflink
> +
> +DIR=$TEST_DIR/dir.$seq
> +mkdir -p $DIR
> +rm -f $DIR/a $DIR/b
> +
> +# This test essentially creates an existing COW extent which
> +# covers the first 1M, and then does another IO that overlaps it,
> +# but extends beyond it.  The bug was that we did not trim the
> +# new IO to the end of the existing COW extent, and so the IO
> +# extended past the COW blocks and corrupted the reflinked files(s).
> +
> +# Make all files w/ 1m hints; create original 2m file
> +$XFS_IO_PROG -c "extsize 1048576" $DIR | _filter_xfs_io
> +$XFS_IO_PROG -c "cowextsize 1048576" $DIR | _filter_xfs_io
> +
> +echo "Create file b"
> +$XFS_IO_PROG -f -c "pwrite -S 0x0 0 2m" -c fsync $DIR/b | _filter_xfs_io
> +
> +# Make a reflinked copy
> +echo "Reflink copy from b to a"
> +cp --reflink=always $DIR/b $DIR/a
> +
> +echo "Contents of b"
> +hexdump -C $DIR/b
> +
> +# Cycle mount to get stuff out of cache
> +_test_cycle_mount
> +
> +# Create a 1m-hinted IO at offset 0, then
> +# do another IO that overlaps but extends past the 1m hint
> +echo "Write to a"
> +$XFS_IO_PROG -c "pwrite -S 0xa 0k -b 4k 4k" \
> +       -c "pwrite -S 0xa 4k -b 1m 1m" \
> +       $DIR/a | _filter_xfs_io
> +
> +$XFS_IO_PROG -c fsync $DIR/a
> +
> +echo "Contents of b now:"
> +hexdump -C $DIR/b
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/612.out b/tests/generic/612.out
> new file mode 100644
> index 00000000..237a9638
> --- /dev/null
> +++ b/tests/generic/612.out
> @@ -0,0 +1,18 @@
> +QA output created by 612
> +Create file b
> +wrote 2097152/2097152 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +Reflink copy from b to a
> +Contents of b
> +00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> +*
> +00200000
> +Write to a
> +wrote 4096/4096 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 1048576/1048576 bytes at offset 4096
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +Contents of b now:
> +00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> +*
> +00200000
> diff --git a/tests/generic/group b/tests/generic/group
> index 4af4b494..bc115f21 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -614,3 +614,4 @@
>  609 auto quick rw
>  610 auto quick prealloc zero
>  611 auto quick attr
> +612 auto quick clone
> 
