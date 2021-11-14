Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB74C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 13:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DFA360FE8
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Nov 2021 13:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhKNNbz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Nov 2021 08:31:55 -0500
Received: from out20-50.mail.aliyun.com ([115.124.20.50]:43174 "EHLO
        out20-50.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhKNNbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Nov 2021 08:31:53 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436282|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0786755-0.000649582-0.920675;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=guan@eryu.me;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.LsfTo6b_1636896533;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.LsfTo6b_1636896533)
          by smtp.aliyun-inc.com(10.147.40.233);
          Sun, 14 Nov 2021 21:28:53 +0800
Date:   Sun, 14 Nov 2021 21:28:53 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v3 1/1] xfstests: Add Log Attribute Replay test
Message-ID: <YZEPFSCGjgmYmoes@desktop>
References: <20211111000644.74562-1-catherine.hoang@oracle.com>
 <20211111000644.74562-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111000644.74562-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 11, 2021 at 12:06:44AM +0000, Catherine Hoang wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds tests to exercise the log attribute error
> inject and log replay. These tests aim to cover cases where attributes
> are added, removed, and overwritten in each format (shortform, leaf,
> node). Error inject is used to replay these operations from the log.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Some comments from fstests' perspective of view below

> ---
>  tests/xfs/542     | 175 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/542.out | 150 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 325 insertions(+)
>  create mode 100755 tests/xfs/542
>  create mode 100755 tests/xfs/542.out
> 
> diff --git a/tests/xfs/542 b/tests/xfs/542
> new file mode 100755
> index 00000000..28342166
> --- /dev/null
> +++ b/tests/xfs/542
> @@ -0,0 +1,175 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test 542
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
> +	echo "*** unmount"
> +	_scratch_unmount 2>/dev/null

No need to umount scratch dev, the test harness will umount it.

> +	rm -f $tmp.*
> +	echo 0 > /sys/fs/xfs/debug/larp
> +}
> +
> +_test_attr_replay()

The leading underscore can be removed, that's for common helper
functions.

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
> +	$ATTR_PROG -g $attr_name $testfile | md5sum

Should do _filter_scratch on stderr as well, otherwise it prints the raw
$SCRATCH_MNT into golden output on error.

> +
> +	echo ""
> +}
> +
> +_create_test_file()
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
> +_require_xfs_io_error_injection "leaf_split"
> +_require_xfs_io_error_injection "leaf_to_node"
> +_require_xfs_sysfs debug/larp
> +
> +# turn on log attributes
> +echo 1 > /sys/fs/xfs/debug/larp
> +
> +_scratch_unmount >/dev/null 2>&1

No need to umount, scratch dev is not mounted at the start of each test.

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
> +_scratch_mkfs_xfs >/dev/null

Just _scratch_mkfs should be fine.

> +
> +echo "*** mount FS"
> +_scratch_mount
> +
> +# empty, inline
> +_create_test_file empty_file1 0
> +_test_attr_replay empty_file1 "attr_name" $attr64 "s" "larp"
> +_test_attr_replay empty_file1 "attr_name" $attr64 "r" "larp"
> +
> +# empty, internal
> +_create_test_file empty_file2 0
> +_test_attr_replay empty_file2 "attr_name" $attr1k "s" "larp"
> +_test_attr_replay empty_file2 "attr_name" $attr1k "r" "larp"
> +
> +# empty, remote
> +_create_test_file empty_file3 0
> +_test_attr_replay empty_file3 "attr_name" $attr64k "s" "larp"
> +_test_attr_replay empty_file3 "attr_name" $attr64k "r" "larp"
> +
> +# inline, inline
> +_create_test_file inline_file1 1 $attr16
> +_test_attr_replay inline_file1 "attr_name2" $attr64 "s" "larp"
> +_test_attr_replay inline_file1 "attr_name2" $attr64 "r" "larp"
> +
> +# inline, internal
> +_create_test_file inline_file2 1 $attr16
> +_test_attr_replay inline_file2 "attr_name2" $attr1k "s" "larp"
> +_test_attr_replay inline_file2 "attr_name2" $attr1k "r" "larp"
> +
> +# inline, remote
> +_create_test_file inline_file3 1 $attr16
> +_test_attr_replay inline_file3 "attr_name2" $attr64k "s" "larp"
> +_test_attr_replay inline_file3 "attr_name2" $attr64k "r" "larp"
> +
> +# extent, internal
> +_create_test_file extent_file1 1 $attr1k
> +_test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
> +_test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
> +
> +# extent, inject error on split
> +_create_test_file extent_file2 3 $attr1k
> +_test_attr_replay extent_file2 "attr_name4" $attr1k "s" "leaf_split"
> +
> +# extent, inject error on fork transition
> +_create_test_file extent_file3 3 $attr1k
> +_test_attr_replay extent_file3 "attr_name4" $attr1k "s" "leaf_to_node"
> +
> +# extent, remote
> +_create_test_file extent_file4 1 $attr1k
> +_test_attr_replay extent_file4 "attr_name2" $attr64k "s" "larp"
> +_test_attr_replay extent_file4 "attr_name2" $attr64k "r" "larp"
> +
> +# remote, internal
> +_create_test_file remote_file1 1 $attr64k
> +_test_attr_replay remote_file1 "attr_name2" $attr1k "s" "larp"
> +_test_attr_replay remote_file1 "attr_name2" $attr1k "r" "larp"
> +
> +# remote, remote
> +_create_test_file remote_file2 1 $attr64k
> +_test_attr_replay remote_file2 "attr_name2" $attr64k "s" "larp"
> +_test_attr_replay remote_file2 "attr_name2" $attr64k "r" "larp"
> +
> +# replace shortform
> +_create_test_file sf_file 2 $attr64
> +_test_attr_replay sf_file "attr_name2" $attr64 "s" "larp"
> +
> +# replace leaf
> +_create_test_file leaf_file 2 $attr1k
> +_test_attr_replay leaf_file "attr_name2" $attr1k "s" "larp"
> +
> +# replace node
> +_create_test_file node_file 1 $attr64k
> +$ATTR_PROG -s "attr_name2" -V $attr1k $SCRATCH_MNT/node_file \
> +		>> $seqres.full
> +_test_attr_replay node_file "attr_name2" $attr1k "s" "larp"
> +
> +echo "*** done"
> +status=0
> +exit
> diff --git a/tests/xfs/542.out b/tests/xfs/542.out
> new file mode 100755
> index 00000000..5f1ebc67
> --- /dev/null
> +++ b/tests/xfs/542.out
> @@ -0,0 +1,150 @@
> +QA output created by 542
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
> +Could not get "attr_name" for /mnt/scratch/empty_file1

There're some places in the .out file that $SCRATCH_MNT is not filtered
properly like above.

Thanks,
Eryu

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
> +Could not get "attr_name" for /mnt/scratch/empty_file2
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
> +Could not get "attr_name" for /mnt/scratch/empty_file3
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
> +Could not get "attr_name2" for /mnt/scratch/inline_file1
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
> +Could not get "attr_name2" for /mnt/scratch/inline_file2
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
> +Could not get "attr_name2" for /mnt/scratch/inline_file3
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
> +Could not get "attr_name2" for /mnt/scratch/extent_file1
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
> +Could not get "attr_name2" for /mnt/scratch/extent_file4
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
> +Could not get "attr_name2" for /mnt/scratch/remote_file1
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
> +Could not get "attr_name2" for /mnt/scratch/remote_file2
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
> +*** unmount
> -- 
> 2.25.1
