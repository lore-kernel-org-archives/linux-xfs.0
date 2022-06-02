Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF48C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 16:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbiFBQfl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 12:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbiFBQfj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 12:35:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1D32A5D57;
        Thu,  2 Jun 2022 09:35:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E72A5615C9;
        Thu,  2 Jun 2022 16:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E19C385A5;
        Thu,  2 Jun 2022 16:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654187734;
        bh=jSKD9OK5ig9SOd+JKrDieot9PWhWGR57KeKMy1RpnMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PgbasxEQSVnQ5cuxdeHKnQOkvB0U7NS8dy9Zaw/6PRm727oxU0QQh59dsXoFEZBQJ
         ofNFYQMHQTiSLz5cnRKrz91ey05Q1vfIQjhlagdMu5qWGjkSBo78qjyU0GIt1ACH1k
         l0bF7+Ufo6A+1hEdy60lXbHosRSavjoyfl9rL6kRMPzSLIGmhRDXONyw6rJ9UY4gQn
         ejHzT1/bW99XbyAx56Z6+h1huig8zJlOvyw4dOO6nye+k9EgU6DYDernxEx2EZV0I8
         zEq5X7l1vb1nJpqEKORuuIvAIVmmnnPWGreBlmmmrcR1YxClvYuA3S2ON6iALOdOrL
         drDAh8r3tVm+Q==
Date:   Thu, 2 Jun 2022 09:35:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        xuyang2018.jy@fujitsu.com
Subject: Re: [PATCH] xfs: corrupted xattr should not block removexattr
Message-ID: <Ypjm1WbL/Mu7hBUQ@magnolia>
References: <20220528094715.309876-1-zlang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220528094715.309876-1-zlang@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 28, 2022 at 05:47:15PM +0800, Zorro Lang wrote:
> After we corrupted an attr leaf block (under node block), getxattr
> might hit EFSCORRUPTED in xfs_attr_node_get when it does
> xfs_attr_node_hasname. A known bug cause xfs_attr_node_get won't do
> xfs_buf_trans release job, then a subsequent removexattr will hang.
> 
> This case covers a1de97fe296c ("xfs: Fix the free logic of state in
> xfs_attr_node_hasname")
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
> 
> Hi,
> 
> It's been long time past, since Yang Xu tried to cover a regression bug
> by changing xfs/126 (be Nacked):
> https://lore.kernel.org/fstests/1642407736-3898-1-git-send-email-xuyang2018.jy@fujitsu.com/
> 
> As we (Red Hat) need to cover this regression issue too, and have waited so
> long time. I think no one is doing this job now, so I'm trying to write a new one
> case to cover it. If Yang has completed his test case but forgot to send out,
> feel free to tell me :)
> 
> Thanks,
> Zorro
> 
>  tests/xfs/999     | 80 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |  2 ++
>  2 files changed, 82 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 00000000..65d99883
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,80 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 999
> +#
> +# This's a regression test for:
> +#   a1de97fe296c ("xfs: Fix the free logic of state in xfs_attr_node_hasname")
> +#
> +# After we corrupted an attr leaf block (under node block), getxattr might hit
> +# EFSCORRUPTED in xfs_attr_node_get when it does xfs_attr_node_hasname. A bug
> +# cause xfs_attr_node_get won't do xfs_buf_trans release job, then a subsequent
> +# removexattr will hang.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick attr
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +. ./common/populate
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_fixed_by_kernel_commit a1de97fe296c \
> +       "xfs: Fix the free logic of state in xfs_attr_node_hasname"
> +
> +_require_scratch_nocheck
> +# Only test with v5 xfs on-disk format
> +_require_scratch_xfs_crc
> +_require_attrs
> +_require_populate_commands
> +_require_xfs_db_blocktrash_z_command
> +
> +_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> +source $tmp.mkfs
> +_scratch_mount
> +
> +# This case will use 10 bytes xattr namelen and 11+ bytes valuelen, so:
> +#   sizeof(xfs_attr_leaf_name_local) = 2 + 1 + 10 + 11 = 24,
> +#   sizeof(xfs_attr_leaf_entry) = 8
> +# So count in the header, if I create more than $((dbsize / 32)) xattr entries,
> +# it will out of a leaf block (not much), then get one node block and two or
> +# more leaf blocks, that's the testing need.

I think this last sentence could be clearer:

"Create more than $((dbsize / 32)) xattr entries to force the creation
of a node block, which we need for this test."

> +nr_xattr="$((dbsize / 32))"
> +localfile="${SCRATCH_MNT}/attrfile"
> +touch $localfile
> +for ((i=0; i<nr_xattr; i++));do
> +	$SETFATTR_PROG -n user.x$(printf "%.09d" "$i") -v "aaaaaaaaaaaaaaaa" $localfile
> +done
> +inumber="$(stat -c '%i' $localfile)"

Though I also wonder, could you just steal this line:

__populate_create_attr "${SCRATCH_MNT}/ATTR.FMT_NODE" "$((8 * blksz / 40))"

from _scratch_xfs_populate?

> +_scratch_unmount
> +
> +# Expect the ablock 0 is a node block, later ablocks(>=1) are leaf blocks, then corrupt
> +# the last leaf block. (Don't corrupt node block, or can't reproduce the bug)
> +magic=$(_scratch_xfs_get_metadata_field "hdr.info.hdr.magic" "inode $inumber" "ablock 0")
> +level=$(_scratch_xfs_get_metadata_field "hdr.level" "inode $inumber" "ablock 0")
> +count=$(_scratch_xfs_get_metadata_field "hdr.count" "inode $inumber" "ablock 0")
> +if [ "$magic" = "0x3ebe" -a "$level" = "1" ];then
> +	# Corrupt the last leaf block
> +	_scratch_xfs_db -x -c "inode ${inumber}" -c "ablock $count" -c "stack" \
> +		-c "blocktrash -x 32 -y $((dbsize*8)) -3 -z" >> $seqres.full
> +else
> +	_fail "The ablock 0 isn't a root node block, maybe case issue"

Might want to capture the magic and level here so that we can diagnose
test setup failures.

> +fi
> +
> +# This's the real testing, expect removexattr won't hang or panic.
> +if _try_scratch_mount >> $seqres.full 2>&1; then
> +	for ((i=0; i<nr_xattr; i++));do
> +		$GETFATTR_PROG -n user.x$(printf "%.09d" "$i") $localfile >/dev/null 2>&1
> +		$SETFATTR_PROG -x user.x$(printf "%.09d" "$i") $localfile 2>/dev/null
> +	done
> +else
> +	_notrun "XFS refused to mount with this xattr corrutpion, test skipped"

When does mount fail?  Or is this a precaution?

--D

> +fi
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 00000000..3b276ca8
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +Silence is golden
> -- 
> 2.31.1
> 
