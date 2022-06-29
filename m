Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30015C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 04:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiF2ESM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 00:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiF2ESK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 00:18:10 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2CA2220;
        Tue, 28 Jun 2022 21:18:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D7FD410E7B66;
        Wed, 29 Jun 2022 14:18:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6P9T-00CKnO-Nt; Wed, 29 Jun 2022 14:18:07 +1000
Date:   Wed, 29 Jun 2022 14:18:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/9] xfs: test mkfs.xfs sizing of internal logs that
Message-ID: <20220629041807.GP1098723@dread.disaster.area>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644769450.1045534.8663346508633304230.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644769450.1045534.8663346508633304230.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62bbd281
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ItlZtdftdnIbX1GFPZQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:21:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test that exercises the mkfs.xfs code that creates
> log sizes that are very close to the AG size when stripe units are in
> play and/or when the log is forced to be in AG 0.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/843     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/843.out |    2 ++
>  2 files changed, 53 insertions(+)
>  create mode 100755 tests/xfs/843
>  create mode 100644 tests/xfs/843.out
> 
> 
> diff --git a/tests/xfs/843 b/tests/xfs/843
> new file mode 100755
> index 00000000..5bb4bfb4
> --- /dev/null
> +++ b/tests/xfs/843
> @@ -0,0 +1,51 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 843
> +#
> +# Now that we've increased the default log size calculation, test mkfs with
> +# various stripe units and filesystem sizes to see if we can provoke mkfs into
> +# breaking.
> +#
> +. ./common/preamble
> +_begin_fstest auto mkfs
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_require_test
> +echo Silence is golden
> +
> +testfile=$TEST_DIR/a
> +rm -f $testfile
> +
> +test_format() {
> +	local tag="$1"
> +	shift
> +
> +	echo "$tag" >> $seqres.full
> +	$MKFS_XFS_PROG $@ -d file,name=$testfile &>> $seqres.full
> +	local res=$?
> +	test $res -eq 0 || echo "$tag FAIL $res" | tee -a $seqres.full
> +}
> +
> +# First we try various small filesystems and stripe sizes.
> +for M in `seq 298 302` `seq 490 520`; do
> +	for S in `seq 32 4 64`; do
> +		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m -N
> +	done
> +done
> +
> +# Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
> +# because this check only occurs after the root directory has been allocated,
> +# which mkfs -N doesn't do.
> +test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0 -N

Why are you passing "-N" to the test if it can't be used to test
this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
