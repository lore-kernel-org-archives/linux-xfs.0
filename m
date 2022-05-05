Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F47C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 23:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343831AbiEEX5s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 19:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238237AbiEEX5r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 19:57:47 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E32760AA5;
        Thu,  5 May 2022 16:54:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 616DD53461A;
        Fri,  6 May 2022 09:54:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nmlIJ-008VFj-95; Fri, 06 May 2022 09:54:03 +1000
Date:   Fri, 6 May 2022 09:54:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v7 1/1] xfstests: Add Log Attribute Replay test
Message-ID: <20220505235403.GD1949718@dread.disaster.area>
References: <20220223033751.97913-1-catherine.hoang@oracle.com>
 <20220223033751.97913-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223033751.97913-2-catherine.hoang@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6274639d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=NvEMR8aOJ-g6-ogDSJ8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 23, 2022 at 03:37:51AM +0000, Catherine Hoang wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds tests to exercise the log attribute error
> inject and log replay. These tests aim to cover cases where attributes
> are added, removed, and overwritten in each format (shortform, leaf,
> node). Error inject is used to replay these operations from the log.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  tests/xfs/543     | 176 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/543.out | 149 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 325 insertions(+)
>  create mode 100755 tests/xfs/543
>  create mode 100644 tests/xfs/543.out
> 
> diff --git a/tests/xfs/543 b/tests/xfs/543
> new file mode 100755
> index 00000000..06f16f21
> --- /dev/null
> +++ b/tests/xfs/543
> @@ -0,0 +1,176 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test 543
> +#
> +# Log attribute replay test
> +#
> +. ./common/preamble
> +_begin_fstest auto quick attr
> +
> +# get standard environment, filters and checks
> +. ./common/filter
> +. ./common/attr
> +. ./common/inject
> +
> +_cleanup()
> +{
> +	rm -rf $tmp.* $testdir
> +	test -w /sys/fs/xfs/debug/larp && \
> +		echo 0 > /sys/fs/xfs/debug/larp

This is problematic - I set larp=1 before I start running fstests
so all tests exercise the LARP paths. This will turn off LARP
unconditionally, so after this runs nothing will exercise the LARP
paths, even if that's what I want the tests to do.

Also, this does not replicate what the generic _cleanup() function
does.

Also, no need to remove $testdir - it's on the scratch device.

Also, don't call things "testdir" because "test directory" has
specific meaning - i.e. the *test device mount* - and this is too
easy to confuse when reading the test code.

> +}
> +
> +test_attr_replay()
> +{
> +	testfile=$testdir/$1
> +	attr_name=$2
> +	attr_value=$3
> +	flag=$4
> +	error_tag=$5
> +
> +	# Inject error
> +	_scratch_inject_error $error_tag
> +
> +	# Set attribute
> +	echo "$attr_value" | ${ATTR_PROG} -$flag "$attr_name" $testfile 2>&1 | \
> +			    _filter_scratch
> +
> +	# FS should be shut down, touch will fail
> +	touch $testfile 2>&1 | _filter_scratch
> +
> +	# Remount to replay log
> +	_scratch_remount_dump_log >> $seqres.full
> +
> +	# FS should be online, touch should succeed
> +	touch $testfile
> +
> +	# Verify attr recovery
> +	{ $ATTR_PROG -g $attr_name $testfile | md5sum; } 2>&1 | _filter_scratch
> +
> +	echo ""
> +}
> +
> +create_test_file()
> +{
> +	filename=$testdir/$1
> +	count=$2
> +	attr_value=$3
> +
> +	touch $filename
> +
> +	for i in `seq $count`
> +	do
> +		$ATTR_PROG -s "attr_name$i" -V $attr_value $filename >> \
> +			$seqres.full
> +	done
> +}
> +
> +# real QA test starts here
> +_supported_fs xfs
> +
> +_require_scratch
> +_require_attrs
> +_require_xfs_io_error_injection "larp"
> +_require_xfs_io_error_injection "da_leaf_split"
> +_require_xfs_io_error_injection "attr_leaf_to_node"
> +_require_xfs_sysfs debug/larp

These go first, before any code.

> +test -w /sys/fs/xfs/debug/larp || _notrun "larp knob not writable"

When is the sysfs not writeable?

> +# turn on log attributes
> +echo 1 > /sys/fs/xfs/debug/larp

Needs to store the previous value so it can be restored at cleanup.

> +attr16="0123456789ABCDEF"
> +attr64="$attr16$attr16$attr16$attr16"
> +attr256="$attr64$attr64$attr64$attr64"
> +attr1k="$attr256$attr256$attr256$attr256"
> +attr4k="$attr1k$attr1k$attr1k$attr1k"
> +attr8k="$attr4k$attr4k"
> +attr16k="$attr8k$attr8k"
> +attr32k="$attr16k$attr16k"
> +attr64k="$attr32k$attr32k"
> +
> +echo "*** mkfs"
> +_scratch_mkfs >/dev/null
> +
> +echo "*** mount FS"
> +_scratch_mount

There's no need for echo lines like this in the golden output - it's
obvious what failed from the diff...

> +testdir=$SCRATCH_MNT/testdir
> +mkdir $testdir

Why not just use $SCRATCH_MNT directly?

> +
> +# empty, inline
> +create_test_file empty_file1 0
> +test_attr_replay empty_file1 "attr_name" $attr64 "s" "larp"
> +test_attr_replay empty_file1 "attr_name" $attr64 "r" "larp"
> +
> +# empty, internal
> +create_test_file empty_file2 0
> +test_attr_replay empty_file2 "attr_name" $attr1k "s" "larp"
> +test_attr_replay empty_file2 "attr_name" $attr1k "r" "larp"
> +
> +# empty, remote
> +create_test_file empty_file3 0
> +test_attr_replay empty_file3 "attr_name" $attr64k "s" "larp"
> +test_attr_replay empty_file3 "attr_name" $attr64k "r" "larp"

single attr insert/remove. OK.

> +
> +# inline, inline
> +create_test_file inline_file1 1 $attr16
> +test_attr_replay inline_file1 "attr_name2" $attr64 "s" "larp"
> +test_attr_replay inline_file1 "attr_name2" $attr64 "r" "larp"

...

Insert/remove of a second attr and the format
conversions they cause. OK.

Doesn't check that the first xattr is retained and uncorrupted
anywhere.

> +# replace shortform
> +create_test_file sf_file 2 $attr64
> +test_attr_replay sf_file "attr_name2" $attr64 "s" "larp"

This only replaces with same size. We also need coverage
of replace with smaller size and larger size, as well as
replace causing sf -> leaf and sf -> remote attr format conversions.

> +# replace leaf
> +create_test_file leaf_file 2 $attr1k
> +test_attr_replay leaf_file "attr_name2" $attr1k "s" "larp"

Need replace causing leaf -> sf (smaller) and well as leaf -> remote
attr (larger). Also leaf w/ remote attr -> sf (much smaller!).

> +# replace node
> +create_test_file node_file 1 $attr64k
> +$ATTR_PROG -s "attr_name2" -V $attr1k $testdir/node_file \
> +		>> $seqres.full
> +test_attr_replay node_file "attr_name2" $attr1k "s" "larp"

Need node -> leaf, node -> sf and node w/ remote attr -> sf

> --- /dev/null
> +++ b/tests/xfs/543.out
> @@ -0,0 +1,149 @@
> +QA output created by 543
> +*** mkfs
> +*** mount FS
> +attr_set: Input/output error
> +Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
> +touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error

We don't really need to capture the error injection errors, all we
care about is that the recovered md5sum matches the expected md5sum:

> +21d850f99c43cc13abbe34838a8a3c8a  -

That's the recovered md5sum, what was the expected md5sum of the
original attr value that we stored? i.e. how do we validate taht we
got the correct attr value?

> +
> +attr_remove: Input/output error
> +Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file1
> +touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
> +attr_get: No data available
> +Could not get "attr_name" for SCRATCH_MNT/testdir/empty_file1
> +d41d8cd98f00b204e9800998ecf8427e  -

Why do we have md5sum output for an attr that does not exist? We
should be capturing the ENODATA error here, as that is the correct
response after recovery of a remove operation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
