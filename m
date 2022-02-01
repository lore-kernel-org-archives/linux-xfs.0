Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543BFC433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 20:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbiBAUNT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 15:13:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36778 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbiBAUNT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 15:13:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF8A0B82F80;
        Tue,  1 Feb 2022 20:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C618C340EB;
        Tue,  1 Feb 2022 20:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643746396;
        bh=UF0ahPpiQxbj9XJ8VnKeqs4gwoqRqmk6bEpYramj2kw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PIaCJJUPbR1NT77b6KCe1OBge1SdNMX/ywvvMHwPeCkj5g0hNEHeb6EFJHhBsAjEh
         06LRQVbDlh+Gqzd7YUR9pXlhBFVhTkDCjLgZh6UtOdzWeiLhxfSL95C6jTKjPTpx7W
         pCMXdHjZeB0CP00VDVSqekAISEsi04a7WaYOJAD1MQLFCUotq7rsNJEE6hKh6JmAXh
         giFeGeLLn+UrGgjjFZKZS1RnXJITuQP6U04I57UM+pzT4vgI8zqF8ybUEmbMP4F7BU
         UcBMecOUW5yJDqqTEro/XpfzXTc0J2E7hn4sxhvc7GiU5SJ4UVwWwiKo42/j2yhWyo
         5x6fxMsVKiyFQ==
Date:   Tue, 1 Feb 2022 12:13:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v6 1/1] xfstests: Add Log Attribute Replay test
Message-ID: <20220201201315.GQ8313@magnolia>
References: <20220201170952.22443-1-catherine.hoang@oracle.com>
 <20220201170952.22443-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201170952.22443-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 01, 2022 at 05:09:52PM +0000, Catherine Hoang wrote:
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
>  tests/xfs/543     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/543.out | 149 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 320 insertions(+)
>  create mode 100755 tests/xfs/543
>  create mode 100644 tests/xfs/543.out
> 
> diff --git a/tests/xfs/543 b/tests/xfs/543
> new file mode 100755
> index 00000000..ae955660
> --- /dev/null
> +++ b/tests/xfs/543
> @@ -0,0 +1,171 @@
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
> +	rm -f $tmp.*
> +	echo 0 > /sys/fs/xfs/debug/larp

Cleanup functions can run even if the _require functions decide to
_notrun the test, so I think this ought to be:

	test -w /sys/fs/xfs/debug/larp && \
		echo 0 > /sys/fs/xfs/debug/larp
> +}
> +
> +test_attr_replay()
> +{
> +	testfile=$SCRATCH_MNT/$1
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
> +	filename=$SCRATCH_MNT/$1
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
> +_require_xfs_io_error_injection "larp_leaf_to_node"
> +_require_xfs_sysfs debug/larp

This only tests that the sysfs control file exists, not that it's
writable.  Granted, debug knobs are writable by default, but we should
be careful here and:

test -w /sys/fs/xfs/debug/larp || _notrun "larp knob not writable"

So this test won't fail if (say) someone has chmod a-w the debug knob
since the module loaded.

With that fixed, I think this test will be ready to go the next time
around.

--D

> +
> +# turn on log attributes
> +echo 1 > /sys/fs/xfs/debug/larp
> +
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
> +
> +# inline, inline
> +create_test_file inline_file1 1 $attr16
> +test_attr_replay inline_file1 "attr_name2" $attr64 "s" "larp"
> +test_attr_replay inline_file1 "attr_name2" $attr64 "r" "larp"
> +
> +# inline, internal
> +create_test_file inline_file2 1 $attr16
> +test_attr_replay inline_file2 "attr_name2" $attr1k "s" "larp"
> +test_attr_replay inline_file2 "attr_name2" $attr1k "r" "larp"
> +
> +# inline, remote
> +create_test_file inline_file3 1 $attr16
> +test_attr_replay inline_file3 "attr_name2" $attr64k "s" "larp"
> +test_attr_replay inline_file3 "attr_name2" $attr64k "r" "larp"
> +
> +# extent, internal
> +create_test_file extent_file1 1 $attr1k
> +test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
> +test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
> +
> +# extent, inject error on split
> +create_test_file extent_file2 3 $attr1k
> +test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
> +
> +# extent, inject error on fork transition
> +create_test_file extent_file3 3 $attr1k
> +test_attr_replay extent_file3 "attr_name4" $attr1k "s" "larp_leaf_to_node"
> +
> +# extent, remote
> +create_test_file extent_file4 1 $attr1k
> +test_attr_replay extent_file4 "attr_name2" $attr64k "s" "larp"
> +test_attr_replay extent_file4 "attr_name2" $attr64k "r" "larp"
> +
> +# remote, internal
> +create_test_file remote_file1 1 $attr64k
> +test_attr_replay remote_file1 "attr_name2" $attr1k "s" "larp"
> +test_attr_replay remote_file1 "attr_name2" $attr1k "r" "larp"
> +
> +# remote, remote
> +create_test_file remote_file2 1 $attr64k
> +test_attr_replay remote_file2 "attr_name2" $attr64k "s" "larp"
> +test_attr_replay remote_file2 "attr_name2" $attr64k "r" "larp"
> +
> +# replace shortform
> +create_test_file sf_file 2 $attr64
> +test_attr_replay sf_file "attr_name2" $attr64 "s" "larp"
> +
> +# replace leaf
> +create_test_file leaf_file 2 $attr1k
> +test_attr_replay leaf_file "attr_name2" $attr1k "s" "larp"
> +
> +# replace node
> +create_test_file node_file 1 $attr64k
> +$ATTR_PROG -s "attr_name2" -V $attr1k $SCRATCH_MNT/node_file \
> +		>> $seqres.full
> +test_attr_replay node_file "attr_name2" $attr1k "s" "larp"
> +
> +echo "*** done"
> +status=0
> +exit
> diff --git a/tests/xfs/543.out b/tests/xfs/543.out
> new file mode 100644
> index 00000000..075eecb3
> --- /dev/null
> +++ b/tests/xfs/543.out
> @@ -0,0 +1,149 @@
> +QA output created by 543
> +*** mkfs
> +*** mount FS
> +attr_set: Input/output error
> +Could not set "attr_name" for SCRATCH_MNT/empty_file1
> +touch: cannot touch 'SCRATCH_MNT/empty_file1': Input/output error
> +db6747306e971b6e3fd474aae10159a1  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name" for SCRATCH_MNT/empty_file1
> +touch: cannot touch 'SCRATCH_MNT/empty_file1': Input/output error
> +attr_get: No data available
> +Could not get "attr_name" for SCRATCH_MNT/empty_file1
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name" for SCRATCH_MNT/empty_file2
> +touch: cannot touch 'SCRATCH_MNT/empty_file2': Input/output error
> +d489897d7ba99c2815052ae7dca29097  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name" for SCRATCH_MNT/empty_file2
> +touch: cannot touch 'SCRATCH_MNT/empty_file2': Input/output error
> +attr_get: No data available
> +Could not get "attr_name" for SCRATCH_MNT/empty_file2
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name" for SCRATCH_MNT/empty_file3
> +touch: cannot touch 'SCRATCH_MNT/empty_file3': Input/output error
> +0ba8b18d622a11b5ff89336761380857  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name" for SCRATCH_MNT/empty_file3
> +touch: cannot touch 'SCRATCH_MNT/empty_file3': Input/output error
> +attr_get: No data available
> +Could not get "attr_name" for SCRATCH_MNT/empty_file3
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/inline_file1
> +touch: cannot touch 'SCRATCH_MNT/inline_file1': Input/output error
> +49f4f904e12102a3423d8ab3f845e6e8  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/inline_file1
> +touch: cannot touch 'SCRATCH_MNT/inline_file1': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/inline_file1
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/inline_file2
> +touch: cannot touch 'SCRATCH_MNT/inline_file2': Input/output error
> +6a0bd8b5aaa619bcd51f2ead0208f1bb  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/inline_file2
> +touch: cannot touch 'SCRATCH_MNT/inline_file2': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/inline_file2
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/inline_file3
> +touch: cannot touch 'SCRATCH_MNT/inline_file3': Input/output error
> +3276329baa72c32f0a4a5cb0dbf813df  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/inline_file3
> +touch: cannot touch 'SCRATCH_MNT/inline_file3': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/inline_file3
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/extent_file1
> +touch: cannot touch 'SCRATCH_MNT/extent_file1': Input/output error
> +8c6a952b2dbecaa5a308a00d2022e599  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/extent_file1
> +touch: cannot touch 'SCRATCH_MNT/extent_file1': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/extent_file1
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name4" for SCRATCH_MNT/extent_file2
> +touch: cannot touch 'SCRATCH_MNT/extent_file2': Input/output error
> +c5ae4d474e547819a8807cfde66daba2  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name4" for SCRATCH_MNT/extent_file3
> +touch: cannot touch 'SCRATCH_MNT/extent_file3': Input/output error
> +17bae95be35ce7a0e6d4327b67da932b  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/extent_file4
> +touch: cannot touch 'SCRATCH_MNT/extent_file4': Input/output error
> +d17d94c39a964409b8b8173a51f8e951  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/extent_file4
> +touch: cannot touch 'SCRATCH_MNT/extent_file4': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/extent_file4
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/remote_file1
> +touch: cannot touch 'SCRATCH_MNT/remote_file1': Input/output error
> +4104e21da013632e636cdd044884ca94  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/remote_file1
> +touch: cannot touch 'SCRATCH_MNT/remote_file1': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/remote_file1
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/remote_file2
> +touch: cannot touch 'SCRATCH_MNT/remote_file2': Input/output error
> +9ac16e37ecd6f6c24de3f724c49199a8  -
> +
> +attr_remove: Input/output error
> +Could not remove "attr_name2" for SCRATCH_MNT/remote_file2
> +touch: cannot touch 'SCRATCH_MNT/remote_file2': Input/output error
> +attr_get: No data available
> +Could not get "attr_name2" for SCRATCH_MNT/remote_file2
> +d41d8cd98f00b204e9800998ecf8427e  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/sf_file
> +touch: cannot touch 'SCRATCH_MNT/sf_file': Input/output error
> +33bc798a506b093a7c2cdea122a738d7  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/leaf_file
> +touch: cannot touch 'SCRATCH_MNT/leaf_file': Input/output error
> +dec146c586813046f4b876bcecbaa713  -
> +
> +attr_set: Input/output error
> +Could not set "attr_name2" for SCRATCH_MNT/node_file
> +touch: cannot touch 'SCRATCH_MNT/node_file': Input/output error
> +e97ce3d15f9f28607b51f76bf8b7296c  -
> +
> +*** done
> -- 
> 2.25.1
> 
