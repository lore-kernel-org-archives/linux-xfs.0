Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5621CCA473
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 15:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbiFFPkv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 11:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240929AbiFFPku (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 11:40:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A12A5000A;
        Mon,  6 Jun 2022 08:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5AEE61585;
        Mon,  6 Jun 2022 15:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4731AC385A9;
        Mon,  6 Jun 2022 15:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654530048;
        bh=w9q/4uGWop59/YIjcGpVDumy0qIxzhCDhXOuc85q8Cg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=us23WqVNS6yZTpMZSqHz7Y+2kfsc3hIUoS5Zdjro+E3mY59w+kGwBOe994zs60C7D
         MQNXyLjgo08m1hE2jhm/+jJSWR6NEp+dzspzzRD+wi7Qg1Lx6hsOJbmWWSKPOW8uuq
         5McmlscamHHnh0m0HtOug/jwqCSjaYgCndcLGRVkJvr4u5FgSSk8SXMyf2fEVmp33l
         eAiRhU549VA0DRtbbBPV/Rxia7YpNH5hJzsv7jb30cBQZeC4HxxJ4mRWXvMuThA6F0
         z0i/pfHOmpTChO6fijS43s1Ju4tu6nAAcLx+Sw7xAfU6ROQvUJmU2c3klQoBfKv6Ti
         4bq7HKTLE7pIA==
Date:   Mon, 6 Jun 2022 08:40:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/547: Verify that the correct inode extent
 counters are updated with/without nrext64
Message-ID: <Yp4f/yalwFunfEgz@magnolia>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-4-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606124101.263872-4-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 06:11:00PM +0530, Chandan Babu R wrote:
> This commit adds a new test to verify if the correct inode extent counter
> fields are updated with/without nrext64 mkfs option.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  tests/xfs/547     | 91 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/547.out | 13 +++++++
>  2 files changed, 104 insertions(+)
>  create mode 100755 tests/xfs/547
>  create mode 100644 tests/xfs/547.out
> 
> diff --git a/tests/xfs/547 b/tests/xfs/547
> new file mode 100755
> index 00000000..d5137ca7
> --- /dev/null
> +++ b/tests/xfs/547
> @@ -0,0 +1,91 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 547
> +#
> +# Verify that correct inode extent count fields are populated with and without
> +# nrext64 feature.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick metadata
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +. ./common/inject
> +. ./common/populate
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_scratch_xfs_nrext64
> +_require_attrs
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +for nrext64 in 0 1; do
> +	echo "* Verify extent counter fields with nrext64=${nrext64} option"
> +
> +	_scratch_mkfs -i nrext64=${nrext64} -d size=$((512 * 1024 * 1024)) \
> +		      >> $seqres.full
> +	_scratch_mount >> $seqres.full
> +
> +	bsize=$(_get_file_block_size $SCRATCH_MNT)
> +
> +	testfile=$SCRATCH_MNT/testfile
> +
> +	nr_blks=20
> +
> +	echo "Add blocks to test file's data fork"
> +	$XFS_IO_PROG -f -c "pwrite 0 $((nr_blks * bsize))" $testfile \
> +		     >> $seqres.full
> +	$here/src/punch-alternating $testfile
> +
> +	echo "Consume free space"
> +	fillerdir=$SCRATCH_MNT/fillerdir
> +	nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> +	nr_free_blks=$((nr_free_blks * 90 / 100))
> +
> +	_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 \
> +		 >> $seqres.full 2>&1
> +
> +	echo "Create fragmented filesystem"
> +	for dentry in $(ls -1 $fillerdir/); do
> +		$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
> +	done
> +
> +	echo "Inject bmap_alloc_minlen_extent error tag"
> +	_scratch_inject_error bmap_alloc_minlen_extent 1
> +
> +	echo "Add blocks to test file's attr fork"
> +	attr_len=255
> +	nr_attrs=$((nr_blks * bsize / attr_len))
> +	for i in $(seq 1 $nr_attrs); do
> +		attr="$(printf "trusted.%0247d" $i)"
> +		$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
> +		[[ $? != 0 ]] && break
> +	done
> +
> +	testino=$(stat -c '%i' $testfile)
> +
> +	_scratch_unmount >> $seqres.full
> +
> +	dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
> +	acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")

Note: For any test requiring functionality added after 5.10, you can use
the xfs_db path command to avoid this sort of inode number saving:

dcnt=$(_scratch_xfs_get_metadata_field core.nextents "path /testfile")

Up to you if you want to change the test to do that; otherwise,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
> +	if (( $dcnt != 10 )); then
> +		echo "Invalid data fork extent count: $dextcnt"
> +		exit 1
> +	fi
> +
> +	if (( $acnt < 10 )); then
> +		echo "Invalid attr fork extent count: $aextcnt"
> +		exit 1
> +	fi
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/547.out b/tests/xfs/547.out
> new file mode 100644
> index 00000000..49fcc3c2
> --- /dev/null
> +++ b/tests/xfs/547.out
> @@ -0,0 +1,13 @@
> +QA output created by 547
> +* Verify extent counter fields with nrext64=0 option
> +Add blocks to test file's data fork
> +Consume free space
> +Create fragmented filesystem
> +Inject bmap_alloc_minlen_extent error tag
> +Add blocks to test file's attr fork
> +* Verify extent counter fields with nrext64=1 option
> +Add blocks to test file's data fork
> +Consume free space
> +Create fragmented filesystem
> +Inject bmap_alloc_minlen_extent error tag
> +Add blocks to test file's attr fork
> -- 
> 2.35.1
> 
