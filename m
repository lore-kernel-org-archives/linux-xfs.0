Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB25EC55ABD
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6BF12225D
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:42:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nv8oygR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgKNAmi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:42:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgKNAmi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:42:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0ZrKb035084;
        Sat, 14 Nov 2020 00:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PLba4zl4GjGhEN0KMGuG8vcGlrHK13ZJnisekkvrMWc=;
 b=Nv8oygR6RVWpkaJEHhHJqBdb9RVg4xQC1DEgqUTKGzICR7ZBZjbyQcqU69YJXzpn9I9/
 HTrRg2qYaHualLOqPVLsH8pKXbshM/HCdlOjKBGiJieTPjl/tt+FX3dvDQ5UdyqFAJVa
 JAnUHYOpGWd2IktSbs+3QgK2qymBTTCs2PosaduNdPcXFGSWOym3UyMQMvCzw5et9b+Q
 R5WXSexsUDlgW7WF9Yl0C+pOb4zvzz/WiQq1kXU/Y9mhOYaGWr13AbRlTZKQsye3efFB
 /Is/7451rcLao03Bkn2JWAKgCRcuuGuaXCDZbOBeH7lWkP06k/uWCdHTBpmtkI8d8/Kc 3g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34nkhmcrsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 00:42:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0ZIJc011498;
        Sat, 14 Nov 2020 00:42:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34rt58tagu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:42:35 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AE0gYcG027535;
        Sat, 14 Nov 2020 00:42:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 16:42:34 -0800
Date:   Fri, 13 Nov 2020 16:42:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: Check for extent overflow when moving extent
 from cow to data fork
Message-ID: <20201114004232.GI9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-9-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113112704.28798-9-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 13, 2020 at 04:57:00PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when writing to a shared extent.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/528     | 87 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/528.out |  8 +++++
>  tests/xfs/group   |  1 +
>  3 files changed, 96 insertions(+)
>  create mode 100755 tests/xfs/528
>  create mode 100644 tests/xfs/528.out
> 
> diff --git a/tests/xfs/528 b/tests/xfs/528
> new file mode 100755
> index 00000000..0d39f05e
> --- /dev/null
> +++ b/tests/xfs/528
> @@ -0,0 +1,87 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 528
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# writing to a shared extent.
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
> +. ./common/inject
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_scratch_reflink
> +_require_xfs_debug
> +_require_xfs_io_command "reflink"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "* Write to shared extent"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)

Now that we're playing with regular files again -- should this be
_get_file_block_size ?  I think the same question applies to patches 2,
3, and 4, and perhaps the next one too.

(Note that regular files can have cluster sizes that aren't the same as
the fs block size if I set MKFS_OPTIONS="-d rtinherit=1 -r extsize=64k".)

--D

> +
> +srcfile=${SCRATCH_MNT}/srcfile
> +dstfile=${SCRATCH_MNT}/dstfile
> +
> +nr_blks=15
> +
> +echo "Create a \$srcfile having an extent of length $nr_blks blocks"
> +xfs_io -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> +       -c fsync $srcfile  >> $seqres.full
> +
> +echo "Share the extent with \$dstfile"
> +xfs_io -f -c "reflink $srcfile" $dstfile >> $seqres.full
> +
> +echo "Inject reduce_max_iextents error tag"
> +xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +echo "Buffered write to every other block of \$dstfile's shared extent"
> +for i in $(seq 1 2 $((nr_blks - 1))); do
> +	xfs_io -f -c "pwrite $((i * bsize)) $bsize" -c fsync $dstfile \
> +	       >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +ino=$(stat -c "%i" $dstfile)
> +
> +_scratch_unmount >> $seqres.full
> +
> +echo "Verify \$dstfile's extent count"
> +
> +nextents=$(_scratch_get_iext_count $ino data || \
> +		_fail "Unable to obtain inode fork's extent count")
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> + 
> diff --git a/tests/xfs/528.out b/tests/xfs/528.out
> new file mode 100644
> index 00000000..8666488b
> --- /dev/null
> +++ b/tests/xfs/528.out
> @@ -0,0 +1,8 @@
> +QA output created by 528
> +* Write to shared extent
> +Format and mount fs
> +Create a $srcfile having an extent of length 15 blocks
> +Share the extent with $dstfile
> +Inject reduce_max_iextents error tag
> +Buffered write to every other block of $dstfile's shared extent
> +Verify $dstfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 627813fe..c85aac6b 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -525,3 +525,4 @@
>  525 auto quick attr
>  526 auto quick dir hardlink symlink
>  527 auto quick
> +528 auto quick reflink
> -- 
> 2.28.0
> 
