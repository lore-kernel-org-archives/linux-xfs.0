Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BC3C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E49E361989
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhC2SGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhC2SG3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Mar 2021 14:06:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD76E6193A;
        Mon, 29 Mar 2021 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617041189;
        bh=4dfUi5KTE651a/r6R+BDUU29dqguFqPF95guEmZfvvc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oBBm0Hwq81MayPwcI1PNj3e/nqB6VYSMPX649Ql6eg2H9UpvHpAX92wmAzA9xXUl5
         N/h5NFrgJyGDKfGY24QyHxD3nZ7mxCNB8jSrgjibYvKntbXC/qj4nkNmTLm6eMp5rX
         z5hN/QRQ0mW2NVQejYTv5pK83Kd/ZTb6FSFmzsReorULAa53VRBo8zCSJ22CgiNfa5
         Bn9n1pl74WPWRExlvYG/D7TarPUFLDRsDUpNeNRfAncP8BDZybKNFJtM3zaQfIx3v2
         dOOyvTNaXUogT07kAPqy7k4cjj2WmvnIRL+1Q/VGnFat8DqdWNYEBXfAKqm2cTxucf
         XuzBIRLdxfuyA==
Date:   Mon, 29 Mar 2021 11:06:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs/535: Fix test to execute in multi-block
 directory config
Message-ID: <20210329180627.GF4090233@magnolia>
References: <20210325140857.7145-1-chandanrlinux@gmail.com>
 <20210325140857.7145-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325140857.7145-6-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:38:57PM +0530, Chandan Babu R wrote:
> xfs/535 attempts to create $srcfile and $dstfile after reduce_max_iextents
> error tag is injected. Creation of these files fails when using a multi-block
> directory test configuration because,
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
> This commit fixes the issue by creating $srcfile and $dstfile before injecting
> reduce_max_iextents error tag.
> 
> Reported-by: Darrick J. Wong <djwong@kernel.org>
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Now on to the xfs/538 regressions! ;)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/535     | 11 +++++++++++
>  tests/xfs/535.out |  2 ++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/tests/xfs/535 b/tests/xfs/535
> index 2d82624c..f2a8a3a5 100755
> --- a/tests/xfs/535
> +++ b/tests/xfs/535
> @@ -51,6 +51,9 @@ nr_blks=15
>  srcfile=${SCRATCH_MNT}/srcfile
>  dstfile=${SCRATCH_MNT}/dstfile
>  
> +touch $srcfile
> +touch $dstfile
> +
>  echo "Inject reduce_max_iextents error tag"
>  _scratch_inject_error reduce_max_iextents 1
>  
> @@ -77,10 +80,18 @@ if (( $nextents > 10 )); then
>  	exit 1
>  fi
>  
> +echo "Disable reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 0
> +
>  rm $dstfile
>  
>  echo "* Funshare shared extent"
>  
> +touch $dstfile
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
>  echo "Share the extent with \$dstfile"
>  _reflink $srcfile $dstfile >> $seqres.full
>  
> diff --git a/tests/xfs/535.out b/tests/xfs/535.out
> index 4383e921..8f600272 100644
> --- a/tests/xfs/535.out
> +++ b/tests/xfs/535.out
> @@ -6,7 +6,9 @@ Create a $srcfile having an extent of length 15 blocks
>  Share the extent with $dstfile
>  Buffered write to every other block of $dstfile's shared extent
>  Verify $dstfile's extent count
> +Disable reduce_max_iextents error tag
>  * Funshare shared extent
> +Inject reduce_max_iextents error tag
>  Share the extent with $dstfile
>  Funshare every other block of $dstfile's shared extent
>  Verify $dstfile's extent count
> -- 
> 2.29.2
> 
