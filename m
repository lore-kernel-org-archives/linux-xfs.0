Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF99C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 322AB61990
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhC2SGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230420AbhC2SGM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Mar 2021 14:06:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 379A261981;
        Mon, 29 Mar 2021 18:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617041171;
        bh=iCL9bca4XcSJcIX5ofPMZPSSSkLdz6bD7rK9Jq0Mfmc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mDOteM61UJSZOyg95evzPnNRDh2YLaGxyoaxQctubCBulccxzczTlnxIfwiyXh7nh
         NxlolUlKAnziigP2Lo2MjTZh6NolI7U31SEhVai15RPBnRlHoP4iY/7tRKpJWuytKi
         s21XaPiyhhICn76/XOuRtWzz2HVpw25RJ9hoRGDg29w0cqiNEa4C+BFBjELXA86AhR
         esF+py0edLWO9WUU9RYE4tAIY2rJsNcihgMiIcW2zKqS9oFoAL1bOfOLPuwckbWUi/
         8cNrHq1OqRBneCxqxHU5B7XDYGmfzJcGc+unoWetE4nSp2NRkJ0Z9Ud3u8Szk8Hhf9
         pwRSv19r5VueA==
Date:   Mon, 29 Mar 2021 11:06:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs/534: Fix test to execute in multi-block
 directory config
Message-ID: <20210329180609.GE4090233@magnolia>
References: <20210325140857.7145-1-chandanrlinux@gmail.com>
 <20210325140857.7145-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325140857.7145-5-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:38:56PM +0530, Chandan Babu R wrote:
> xfs/534 attempts to create $testfile after reduce_max_iextents error tag is
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

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/534     | 9 ++++++---
>  tests/xfs/534.out | 5 ++++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/xfs/534 b/tests/xfs/534
> index a8348526..338282ef 100755
> --- a/tests/xfs/534
> +++ b/tests/xfs/534
> @@ -45,9 +45,6 @@ bsize=$(_get_file_block_size $SCRATCH_MNT)
>  
>  testfile=${SCRATCH_MNT}/testfile
>  
> -echo "Inject reduce_max_iextents error tag"
> -_scratch_inject_error reduce_max_iextents 1
> -
>  nr_blks=15
>  
>  for io in Buffered Direct; do
> @@ -62,6 +59,9 @@ for io in Buffered Direct; do
>  		xfs_io_flag="-d"
>  	fi
>  
> +	echo "Inject reduce_max_iextents error tag"
> +	_scratch_inject_error reduce_max_iextents 1
> +
>  	echo "$io write to every other block of fallocated space"
>  	for i in $(seq 1 2 $((nr_blks - 1))); do
>  		$XFS_IO_PROG -f -s $xfs_io_flag -c "pwrite $((i * bsize)) $bsize" \
> @@ -76,6 +76,9 @@ for io in Buffered Direct; do
>  		exit 1
>  	fi
>  
> +	echo "Disable reduce_max_iextents error tag"
> +	_scratch_inject_error reduce_max_iextents 0
> +
>  	rm $testfile
>  done
>  
> diff --git a/tests/xfs/534.out b/tests/xfs/534.out
> index f7c0821b..0a0cd3a6 100644
> --- a/tests/xfs/534.out
> +++ b/tests/xfs/534.out
> @@ -1,11 +1,14 @@
>  QA output created by 534
>  Format and mount fs
> -Inject reduce_max_iextents error tag
>  * Buffered write to unwritten extent
>  Fallocate 15 blocks
> +Inject reduce_max_iextents error tag
>  Buffered write to every other block of fallocated space
>  Verify $testfile's extent count
> +Disable reduce_max_iextents error tag
>  * Direct write to unwritten extent
>  Fallocate 15 blocks
> +Inject reduce_max_iextents error tag
>  Direct write to every other block of fallocated space
>  Verify $testfile's extent count
> +Disable reduce_max_iextents error tag
> -- 
> 2.29.2
> 
