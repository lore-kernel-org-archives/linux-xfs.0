Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6853C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91C9C64F06
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 21:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhBXVr2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 16:47:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236074AbhBXVr2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 16:47:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F1D364EFA;
        Wed, 24 Feb 2021 21:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614203207;
        bh=ykwgLyk0QxbdVRQxmlVZZD+vjXNMw4bf19CQ0k7kniA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CqNM9IuD28IF1V98mdFDFnZKznA2k603Mo/H8z91dzAv5LOS0xQxY/AzM4IjUeK8m
         FOMRc0OpI+6VgEkQ+U7rDBq0Lx/83msvamKHQj8KhuWx/zeSleLZqKUmSE8RJDc1bh
         VOo1BacwazYeNKocrjTbJW62D+4c5XxlaHpawKN9vw0xYC857FaSfdfi+jIY8ANU0+
         gJJHXh3h2bRZIwR7WF/kmn5wihHgI0Bck73KUcKSarCAedCUOpVm/wayex+5Ww4TZ/
         myHef8nZ3j8smjqxBIRIjf/X3GZZ0u9OIq0kmyynl1xYTUoaMhAre+jHIMkGxe77Y4
         o5EpmIfxMZFRA==
Date:   Wed, 24 Feb 2021 13:46:46 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: type verification is expensive
Message-ID: <20210224214646.GC7272@magnolia>
References: <20210223054748.3292734-1-david@fromorbit.com>
 <20210223054748.3292734-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223054748.3292734-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 04:47:46PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> From a concurrent rm -rf workload:
> 
>   41.04%  [kernel]  [k] xfs_dir3_leaf_check_int
>    9.85%  [kernel]  [k] __xfs_dir3_data_check
>    5.60%  [kernel]  [k] xfs_verify_ino
>    5.32%  [kernel]  [k] xfs_agino_range
>    4.21%  [kernel]  [k] memcpy
>    3.06%  [kernel]  [k] xfs_errortag_test
>    2.57%  [kernel]  [k] xfs_dir_ino_validate
>    1.66%  [kernel]  [k] xfs_dir2_data_get_ftype
>    1.17%  [kernel]  [k] do_raw_spin_lock
>    1.11%  [kernel]  [k] xfs_verify_dir_ino
>    0.84%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
>    0.83%  [kernel]  [k] xfs_buf_find
>    0.64%  [kernel]  [k] xfs_log_commit_cil
> 
> THere's an awful lot of overhead in just range checking inode
> numbers in that, but each inode number check is not a lot of code.
> The total is a bit over 14.5% of the CPU time is spent validating
> inode numbers.
> 
> The problem is that they deeply nested global scope functions so the
> overhead here is all in function call marshalling.
> 
>    text	   data	    bss	    dec	    hex	filename
>    2077	      0	      0	   2077	    81d fs/xfs/libxfs/xfs_types.o.orig
>    2197	      0	      0	   2197	    895	fs/xfs/libxfs/xfs_types.o
> 
> There's a small increase in binary size by inlining all the local
> nested calls in the verifier functions, but the same workload now
> profiles as:
> 
>   40.69%  [kernel]  [k] xfs_dir3_leaf_check_int
>   10.52%  [kernel]  [k] __xfs_dir3_data_check
>    6.68%  [kernel]  [k] xfs_verify_dir_ino
>    4.22%  [kernel]  [k] xfs_errortag_test
>    4.15%  [kernel]  [k] memcpy
>    3.53%  [kernel]  [k] xfs_dir_ino_validate
>    1.87%  [kernel]  [k] xfs_dir2_data_get_ftype
>    1.37%  [kernel]  [k] do_raw_spin_lock
>    0.98%  [kernel]  [k] xfs_buf_find
>    0.94%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
>    0.73%  [kernel]  [k] xfs_log_commit_cil
> 
> Now we only spend just over 10% of the time validing inode numbers
> for the same workload. Hence a few "inline" keyworks is good enough
> to reduce the validation overhead by 30%...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks fine I guess,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_types.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index b254fbeaaa50..04801362e1a7 100644
> --- a/fs/xfs/libxfs/xfs_types.c
> +++ b/fs/xfs/libxfs/xfs_types.c
> @@ -13,7 +13,7 @@
>  #include "xfs_mount.h"
>  
>  /* Find the size of the AG, in blocks. */
> -xfs_agblock_t
> +inline xfs_agblock_t
>  xfs_ag_block_count(
>  	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno)
> @@ -29,7 +29,7 @@ xfs_ag_block_count(
>   * Verify that an AG block number pointer neither points outside the AG
>   * nor points at static metadata.
>   */
> -bool
> +inline bool
>  xfs_verify_agbno(
>  	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
> @@ -49,7 +49,7 @@ xfs_verify_agbno(
>   * Verify that an FS block number pointer neither points outside the
>   * filesystem nor points at static AG metadata.
>   */
> -bool
> +inline bool
>  xfs_verify_fsbno(
>  	struct xfs_mount	*mp,
>  	xfs_fsblock_t		fsbno)
> @@ -85,7 +85,7 @@ xfs_verify_fsbext(
>  }
>  
>  /* Calculate the first and last possible inode number in an AG. */
> -void
> +inline void
>  xfs_agino_range(
>  	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
> @@ -116,7 +116,7 @@ xfs_agino_range(
>   * Verify that an AG inode number pointer neither points outside the AG
>   * nor points at static metadata.
>   */
> -bool
> +inline bool
>  xfs_verify_agino(
>  	struct xfs_mount	*mp,
>  	xfs_agnumber_t		agno,
> @@ -146,7 +146,7 @@ xfs_verify_agino_or_null(
>   * Verify that an FS inode number pointer neither points outside the
>   * filesystem nor points at static AG metadata.
>   */
> -bool
> +inline bool
>  xfs_verify_ino(
>  	struct xfs_mount	*mp,
>  	xfs_ino_t		ino)
> @@ -162,7 +162,7 @@ xfs_verify_ino(
>  }
>  
>  /* Is this an internal inode number? */
> -bool
> +inline bool
>  xfs_internal_inum(
>  	struct xfs_mount	*mp,
>  	xfs_ino_t		ino)
> @@ -190,7 +190,7 @@ xfs_verify_dir_ino(
>   * Verify that an realtime block number pointer doesn't point off the
>   * end of the realtime device.
>   */
> -bool
> +inline bool
>  xfs_verify_rtbno(
>  	struct xfs_mount	*mp,
>  	xfs_rtblock_t		rtbno)
> @@ -215,7 +215,7 @@ xfs_verify_rtext(
>  }
>  
>  /* Calculate the range of valid icount values. */
> -void
> +inline void
>  xfs_icount_range(
>  	struct xfs_mount	*mp,
>  	unsigned long long	*min,
> -- 
> 2.28.0
> 
