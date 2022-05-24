Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CC3C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 23:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238840AbiEXXr6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 19:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiEXXr6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 19:47:58 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6527B62120;
        Tue, 24 May 2022 16:47:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 906D510E6A5D;
        Wed, 25 May 2022 09:47:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nteFh-00G17b-P2; Wed, 25 May 2022 09:47:49 +1000
Date:   Wed, 25 May 2022 09:47:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, Zorro Lang <zlang@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs: test xfs_copy doesn't do cached read before
 libxfs_mount
Message-ID: <20220524234749.GR2306852@dread.disaster.area>
References: <Yo027/k+vAYsUt4U@magnolia>
 <Yo036Y+er/WaT2IH@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo036Y+er/WaT2IH@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=628d6eac
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=aJ4HfYzmX00VigcfFO8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 12:54:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for an xfs_copy fix that ensures that it
> doesn't perform a cached read of an XFS filesystem prior to initializing
> libxfs, since the xfs_mount (and hence the buffer cache) isn't set up
> yet.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/844     |   37 +++++++++++++++++++++++++++++++++++++
>  tests/xfs/844.out |    3 +++
>  3 files changed, 40 insertions(+), 1 deletion(-)
>  create mode 100755 tests/xfs/844
>  create mode 100644 tests/xfs/844.out
> 
> diff --git a/tests/xfs/844 b/tests/xfs/844
> new file mode 100755
> index 00000000..720f45bb
> --- /dev/null
> +++ b/tests/xfs/844
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 844
> +#
> +# Regression test for xfsprogs commit:
> +#
> +# XXXXXXXX ("xfs_copy: don't use cached buffer reads until after libxfs_mount")
> +#
> +. ./common/preamble
> +_begin_fstest auto copy
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $TEST_DIR/$seq.*
> +}

Not necessary - $TEST_DIR/$seq.* are sparse files that take up no space.

> +
> +# Import common functions.
> +# . ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_xfs_copy
> +_require_test
> +

rm -f $TEST_DIR/$seq.*

To set up known initial state prior to starting the test.

Otherwise looks OK.

Cheers,

Dave.

> +truncate -s 100m $TEST_DIR/$seq.a
> +truncate -s 100m $TEST_DIR/$seq.b
> +
> +$XFS_COPY_PROG $TEST_DIR/$seq.a $TEST_DIR/$seq.b
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/844.out b/tests/xfs/844.out
> new file mode 100644
> index 00000000..dbefde1c
> --- /dev/null
> +++ b/tests/xfs/844.out
> @@ -0,0 +1,3 @@
> +QA output created by 844
> +bad magic number
> +xfs_copy: couldn't read superblock, error=22
> 

-- 
Dave Chinner
david@fromorbit.com
