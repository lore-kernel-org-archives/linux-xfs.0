Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC68CC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5606193A
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhC2SGg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhC2SGA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Mar 2021 14:06:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6348661920;
        Mon, 29 Mar 2021 18:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617041160;
        bh=Bdqgehq28GilCU3F7Jjl2HZQg1haqUTGwmJmzPKfDmc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SI6w2kaFHc5GK9cbD9Jb8T5XLyJ3BxemrcciXsSApj/1cSh09oA85z5JNjgJwy8Lk
         8s90Z7C6OEAt9IosZORYKSowwHI+Emz+O81yjI1OWikXZXT0XDiugqPGS1JTlcdajP
         fHQ9QgycVcYQb7W21n101WktlCkkJpY3M7x7OCTVOOElAdHzrtHaKobUlh3MWgaxmV
         6FHHq/Ki6KdhBySJtN7W9pk8nWug/1QpfI13MjLtWa0RDqNmUkkkwliDqhTUb2GOXW
         8TTUES4MgIm10lb9eigNVKIZ971CVMM+J3GG3049VjyI6YopPp3AMqVahMHHnTD0J5
         U4vNOvgyL71VQ==
Date:   Mon, 29 Mar 2021 11:05:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs/532: Fix test to execute in multi-block
 directory config
Message-ID: <20210329180559.GD4090233@magnolia>
References: <20210325140857.7145-1-chandanrlinux@gmail.com>
 <20210325140857.7145-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325140857.7145-4-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:38:55PM +0530, Chandan Babu R wrote:
> xfs/532 attempts to create $testfile after reduce_max_iextents error tag is
> injected. Creation of $testfile fails when using a multi-block directory test
> configuration because,
> 1. A directory can have a pseudo maximum extent count of 10.
> 2. In the worst case a directory entry creation operation can consume
>    (XFS_DA_NODE_MAXDEPTH + 1 + 1) * (Nr fs blocks in a single directory block)
>    extents.
>    With 1k fs block size and 4k directory block size, this evaluates to,
>    (5 + 1 + 1) * 4
>    = 7 * 4
>    = 28
>    > 10 (Pseudo maximum inode extent count).
> 
> This commit fixes the issue by creating $testfile before injecting
> reduce_max_iextents error tag.
> 
> Reported-by: Darrick J. Wong <djwong@kernel.org>
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks ok (and like Eryu says, this could all have been one large patch),
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/532     | 17 ++++++++++-------
>  tests/xfs/532.out |  6 +++---
>  2 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/tests/xfs/532 b/tests/xfs/532
> index 1c789217..2bed574a 100755
> --- a/tests/xfs/532
> +++ b/tests/xfs/532
> @@ -63,9 +63,6 @@ for dentry in $(ls -1 $fillerdir/); do
>  	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
>  done
>  
> -echo "Inject reduce_max_iextents error tag"
> -_scratch_inject_error reduce_max_iextents 1
> -
>  echo "Inject bmap_alloc_minlen_extent error tag"
>  _scratch_inject_error bmap_alloc_minlen_extent 1
>  
> @@ -74,6 +71,9 @@ echo "* Set xattrs"
>  echo "Create \$testfile"
>  touch $testfile
>  
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
>  echo "Create xattrs"
>  nr_attrs=$((bsize * 20 / attr_len))
>  for i in $(seq 1 $nr_attrs); do
> @@ -90,6 +90,9 @@ if (( $naextents > 10 )); then
>  	exit 1
>  fi
>  
> +echo "Disable reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 0
> +
>  echo "Remove \$testfile"
>  rm $testfile
>  
> @@ -98,9 +101,6 @@ echo "* Remove xattrs"
>  echo "Create \$testfile"
>  touch $testfile
>  
> -echo "Disable reduce_max_iextents error tag"
> -_scratch_inject_error reduce_max_iextents 0
> -
>  echo "Create initial xattr extents"
>  
>  naextents=0
> @@ -132,7 +132,10 @@ if [[ $? == 0 ]]; then
>  	exit 1
>  fi
>  
> -rm $testfile && echo "Successfully removed \$testfile"
> +echo "Disable reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 0
> +
> +rm $testfile
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/532.out b/tests/xfs/532.out
> index 8e19d7bc..db52108f 100644
> --- a/tests/xfs/532.out
> +++ b/tests/xfs/532.out
> @@ -2,17 +2,17 @@ QA output created by 532
>  Format and mount fs
>  Consume free space
>  Create fragmented filesystem
> -Inject reduce_max_iextents error tag
>  Inject bmap_alloc_minlen_extent error tag
>  * Set xattrs
>  Create $testfile
> +Inject reduce_max_iextents error tag
>  Create xattrs
>  Verify $testfile's naextent count
> +Disable reduce_max_iextents error tag
>  Remove $testfile
>  * Remove xattrs
>  Create $testfile
> -Disable reduce_max_iextents error tag
>  Create initial xattr extents
>  Inject reduce_max_iextents error tag
>  Remove xattr to trigger -EFBIG
> -Successfully removed $testfile
> +Disable reduce_max_iextents error tag
> -- 
> 2.29.2
> 
