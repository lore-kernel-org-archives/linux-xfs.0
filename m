Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE632C3F2D4
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 15:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240916AbiFFPgO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 11:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241123AbiFFPfW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 11:35:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63AC139823;
        Mon,  6 Jun 2022 08:35:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 004FD6150E;
        Mon,  6 Jun 2022 15:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594ECC34115;
        Mon,  6 Jun 2022 15:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654529720;
        bh=YfhYxd0KW2EX3cqQwW/XmmCJopVcYnjBZToBDLNd3Eo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D00wBxSEb/HqBaHNP7sFfqKZ/j8NL0t0IivlWtAUgNr2ybahR+4+bSsr8EaCQlHSI
         UkCHmR7DrVaea3LhX37oWTEfssYXuwkhrpNnYtEZbNM4T4FLdiQWMwGzwLkO6k06ga
         b1x4hbPXUMXfOEFOQFvoYdcy7j0jx/ohPRuJtY3YFqDvag51DSuWGHBYsMYm5D8+52
         F+emZdxwq7IB+v57PZeBbndv600j49llRqIKIHgFyogd8/ScfhPzQbZW9/uK+MQQCo
         iKdLL6QtxcfymN/2rxjw53YRqpYrXVSeKiq6NNr3CqgO/HvKiASimIw7liUWGHlhPs
         Eel5Mppf0mLhA==
Date:   Mon, 6 Jun 2022 08:35:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs/548: Verify correctness of upgrading an fs to
 support large extent counters
Message-ID: <Yp4etwsUF/B6aSbe@magnolia>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-5-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606124101.263872-5-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 06:11:01PM +0530, Chandan Babu R wrote:
> This commit adds a test to verify upgrade of an existing V5 filesystem to
> support large extent counters.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  tests/xfs/548     | 109 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/548.out |  12 +++++
>  2 files changed, 121 insertions(+)
>  create mode 100755 tests/xfs/548
>  create mode 100644 tests/xfs/548.out
> 
> diff --git a/tests/xfs/548 b/tests/xfs/548
> new file mode 100755
> index 00000000..6c577584
> --- /dev/null
> +++ b/tests/xfs/548
> @@ -0,0 +1,109 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 548
> +#
> +# Test to verify upgrade of an existing V5 filesystem to support large extent
> +# counters.
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
> +_scratch_mkfs -d size=$((512 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +
> +testfile=$SCRATCH_MNT/testfile
> +
> +nr_blks=20
> +
> +echo "Add blocks to file's data fork"
> +$XFS_IO_PROG -f -c "pwrite 0 $((nr_blks * bsize))" $testfile \
> +	     >> $seqres.full
> +$here/src/punch-alternating $testfile
> +
> +echo "Consume free space"
> +fillerdir=$SCRATCH_MNT/fillerdir
> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> +nr_free_blks=$((nr_free_blks * 90 / 100))
> +
> +_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 \
> +	 >> $seqres.full 2>&1
> +
> +echo "Create fragmented filesystem"
> +for dentry in $(ls -1 $fillerdir/); do
> +	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
> +done
> +
> +echo "Inject bmap_alloc_minlen_extent error tag"
> +_scratch_inject_error bmap_alloc_minlen_extent 1
> +
> +echo "Add blocks to file's attr fork"
> +nr_blks=10
> +attr_len=255
> +nr_attrs=$((nr_blks * bsize / attr_len))
> +for i in $(seq 1 $nr_attrs); do
> +	attr="$(printf "trusted.%0247d" $i)"
> +	$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
> +	[[ $? != 0 ]] && break
> +done
> +
> +testino=$(stat -c '%i' $testfile)
> +
> +echo "Unmount filesystem"
> +_scratch_unmount >> $seqres.full
> +
> +orig_dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
> +orig_acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
> +
> +echo "Upgrade filesystem to support large extent counters"
> +_scratch_xfs_admin -O nrext64=1 >> $seqres.full 2>&1
> +if [[ $? != 0 ]]; then
> +	_notrun "Filesystem geometry is not suitable for upgrading"
> +fi
> +
> +
> +echo "Mount filesystem"
> +_scratch_mount >> $seqres.full
> +
> +echo "Modify inode core"
> +touch $testfile
> +
> +echo "Unmount filesystem"
> +_scratch_unmount >> $seqres.full
> +
> +dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
> +acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
> +
> +echo "Verify inode extent counter values after fs upgrade"

Is there a scenario where the inode counters would become corrupt after
enabling the superblock feature bit?  IIRC repair doesn't rewrite the
inodes during the upgrade... so is this test merely being cautious?  Or
is this covering a failure you found somewhere while writing the feature?

--D

> +
> +if [[ $orig_dcnt != $dcnt ]]; then
> +	echo "Corrupt data extent counter"
> +	exit 1
> +fi
> +
> +if [[ $orig_acnt != $acnt ]]; then
> +	echo "Corrupt attr extent counter"
> +	exit 1
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/548.out b/tests/xfs/548.out
> new file mode 100644
> index 00000000..19a7f907
> --- /dev/null
> +++ b/tests/xfs/548.out
> @@ -0,0 +1,12 @@
> +QA output created by 548
> +Add blocks to file's data fork
> +Consume free space
> +Create fragmented filesystem
> +Inject bmap_alloc_minlen_extent error tag
> +Add blocks to file's attr fork
> +Unmount filesystem
> +Upgrade filesystem to support large extent counters
> +Mount filesystem
> +Modify inode core
> +Unmount filesystem
> +Verify inode extent counter values after fs upgrade
> -- 
> 2.35.1
> 
