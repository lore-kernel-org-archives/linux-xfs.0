Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E338BC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 23:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbiEXXof (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 19:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241080AbiEXXob (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 19:44:31 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22D875996A;
        Tue, 24 May 2022 16:44:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9E315534701;
        Wed, 25 May 2022 09:44:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nteCQ-00G15a-WD; Wed, 25 May 2022 09:44:27 +1000
Date:   Wed, 25 May 2022 09:44:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, Eryu Guan <guaneryu@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: test mkfs.xfs sizing of internal logs that
Message-ID: <20220524234426.GQ2306852@dread.disaster.area>
References: <Yo03mZ12X1nLGihK@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo03mZ12X1nLGihK@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=628d6ddd
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ItlZtdftdnIbX1GFPZQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 12:52:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test that exercises the mkfs.xfs code that creates
> log sizes that are very close to the AG size when stripe units are in
> play and/or when the log is forced to be in AG 0.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/843     |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/843.out |    2 ++
>  2 files changed, 58 insertions(+)
>  create mode 100755 tests/xfs/843
>  create mode 100644 tests/xfs/843.out
> 
> diff --git a/tests/xfs/843 b/tests/xfs/843
> new file mode 100755
> index 00000000..3384b1aa
> --- /dev/null
> +++ b/tests/xfs/843
> @@ -0,0 +1,56 @@
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
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $testfile
> +}

I'd omit this completely.

> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_require_test
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

What breakage are you trying to provoke? Just the log size
calculation? If so, why do we need to actually write the filesystem
to disk? Won't "-N" still calculate everything and fail if it's
broken or quit with success without needing to write anything to
disk?

> +}
> +
> +# First we try various small filesystems and stripe sizes.
> +for M in `seq 298 302` `seq 490 520`; do
> +	for S in `seq 32 4 64`; do
> +		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m
> +	done
> +done
> +
> +# log so large it pushes the root dir into AG 1
> +test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0
> +
> +# log end rounded beyond EOAG due to stripe unit
> +test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4
> +
> +echo Silence is golden

Put this at the top where the test is being set up (i.e. where you
define testfile). That tells the reader straight away that no output
is expected on a successful run before they start reading the test
code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
