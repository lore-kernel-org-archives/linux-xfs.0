Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A1AC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73F4361989
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhC2SFb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230449AbhC2SFG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Mar 2021 14:05:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 989F96193A;
        Mon, 29 Mar 2021 18:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617041105;
        bh=48jFb7JEO3m4mivcSSK6OKcI+iBW29f7LU2MPoQK0l8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ol6u1v0PQRkWd107upng2a18v5wOtCwepr40Yrx4omACiiVdHrXVRM8bmp7ocG/+3
         qyw5oOxfBwOShJm7BG5+MBJ6Fs739adhVJ5KM3aEB9FB2LsLvmpneLbiEz0yGSLatI
         NqR5NhnRS/5IYM0de8CbU2JbNiUbJ7PvL9TUaStPwYbgUXnvgOmuoxJrl8gp9dBNqt
         GPjcwkm3tZaskvYQM6aJ2mWupSRzW/rrog2aLCBHUUDxkH95DObcNdD86OskYVaDNm
         8KbhUUIwSJZD2Lc228Sw2PG+tEBlU7iQ28+/PK3RfCI/HcsWokJ7xaPLuHAFELL2x6
         Tzf9/nHsVTyqw==
Date:   Mon, 29 Mar 2021 11:05:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs/531: Fix test to execute in multi-block
 directory config
Message-ID: <20210329180503.GC4090233@magnolia>
References: <20210325140857.7145-1-chandanrlinux@gmail.com>
 <20210325140857.7145-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325140857.7145-3-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:38:54PM +0530, Chandan Babu R wrote:
> xfs/531 attempts to create $testfile after reduce_max_iextents error tag is
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

Much better,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/531     | 11 ++++++++---
>  tests/xfs/531.out |  9 ++++++++-
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/xfs/531 b/tests/xfs/531
> index caec7848..935c52b0 100755
> --- a/tests/xfs/531
> +++ b/tests/xfs/531
> @@ -49,13 +49,15 @@ nr_blks=30
>  
>  testfile=$SCRATCH_MNT/testfile
>  
> -echo "Inject reduce_max_iextents error tag"
> -_scratch_inject_error reduce_max_iextents 1
> -
>  for op in fpunch finsert fcollapse fzero; do
>  	echo "* $op regular file"
>  
>  	echo "Create \$testfile"
> +	touch $testfile
> +
> +	echo "Inject reduce_max_iextents error tag"
> +	_scratch_inject_error reduce_max_iextents 1
> +
>  	$XFS_IO_PROG -f -s \
>  		     -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
>  		     $testfile  >> $seqres.full
> @@ -75,6 +77,9 @@ for op in fpunch finsert fcollapse fzero; do
>  		exit 1
>  	fi
>  
> +	echo "Disable reduce_max_iextents error tag"
> +	_scratch_inject_error reduce_max_iextents 0
> +
>  	rm $testfile
>  done
>  
> diff --git a/tests/xfs/531.out b/tests/xfs/531.out
> index f85776c9..6ac90787 100644
> --- a/tests/xfs/531.out
> +++ b/tests/xfs/531.out
> @@ -1,19 +1,26 @@
>  QA output created by 531
>  Format and mount fs
> -Inject reduce_max_iextents error tag
>  * fpunch regular file
>  Create $testfile
> +Inject reduce_max_iextents error tag
>  fpunch alternating blocks
>  Verify $testfile's extent count
> +Disable reduce_max_iextents error tag
>  * finsert regular file
>  Create $testfile
> +Inject reduce_max_iextents error tag
>  finsert alternating blocks
>  Verify $testfile's extent count
> +Disable reduce_max_iextents error tag
>  * fcollapse regular file
>  Create $testfile
> +Inject reduce_max_iextents error tag
>  fcollapse alternating blocks
>  Verify $testfile's extent count
> +Disable reduce_max_iextents error tag
>  * fzero regular file
>  Create $testfile
> +Inject reduce_max_iextents error tag
>  fzero alternating blocks
>  Verify $testfile's extent count
> +Disable reduce_max_iextents error tag
> -- 
> 2.29.2
> 
