Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A66C43460
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 15:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9686F60FE8
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 15:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhDIPUE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 11:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233798AbhDIPUE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Apr 2021 11:20:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 566CC610CF;
        Fri,  9 Apr 2021 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617981591;
        bh=1apxkzNf0acG/HHOD7Z/jjYP1r3bOF+IErjH7QXWJ4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y9UC1a4ijIXDSpcpoEZoo1851m606P+ZSaI7BI6nkZwvN4IsfT1UzQ4vxVW5VvWAU
         0lKY1qHMScmL94SYP2yvAhDA8egQzL49WZ+TDl5X9WNy3+FIkPK2cuJZRJqq49Iu+H
         DRN233cvDvr7HxxcK3gp0Qx6BjZCIilWgZqpyIuRZbW35Czs5Dv9ilXOvtleo4eJBC
         eLC4ECubJyIsNN5fKJ9bmvarRLICTD9w3iQfRi2ZeYgSVfUTfeYkSRnRSFBkv8gXR8
         v80LaFY9EsnyqRpHbsp9Pz0OIVbEsU32KHxCOOM1i0ThbfEIULp03f5KIoxxWJZEJz
         mEhy8ybvfks6Q==
Date:   Fri, 9 Apr 2021 08:19:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fstests: Disable realtime inherit flag when executing
 xfs/{532,533,538}
Message-ID: <20210409151950.GE3957620@magnolia>
References: <20210409124903.23374-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409124903.23374-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 09, 2021 at 06:19:03PM +0530, Chandan Babu R wrote:
> The minimum length space allocator (i.e. xfs_bmap_exact_minlen_extent_alloc())
> depends on the underlying filesystem to be fragmented so that there are enough
> one block sized extents available to satify space allocation requests.
> 
> xfs/{532,533,538} tests issue space allocation requests for metadata (e.g. for
> blocks holding directory and xattr information). With realtime filesystem
> instances, these tests would end up fragmenting the space on realtime
> device. Hence minimum length space allocator fails since the regular
> filesystem space is not fragmented and hence there are no one block sized
> extents available.
> 
> Thus, this commit disables realtime inherit flag (if any) on root directory so
> that space on data device gets fragmented rather than realtime device.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Reported-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/532 | 4 ++++
>  tests/xfs/533 | 4 ++++
>  tests/xfs/538 | 4 ++++
>  3 files changed, 12 insertions(+)
> 
> diff --git a/tests/xfs/532 b/tests/xfs/532
> index 2bed574a..560af586 100755
> --- a/tests/xfs/532
> +++ b/tests/xfs/532
> @@ -45,6 +45,10 @@ echo "Format and mount fs"
>  _scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
>  _scratch_mount >> $seqres.full
>  
> +# Disable realtime inherit flag (if any) on root directory so that space on data
> +# device gets fragmented rather than realtime device.
> +$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> +
>  bsize=$(_get_block_size $SCRATCH_MNT)
>  
>  attr_len=255
> diff --git a/tests/xfs/533 b/tests/xfs/533
> index be909fcc..dd4cb4c4 100755
> --- a/tests/xfs/533
> +++ b/tests/xfs/533
> @@ -56,6 +56,10 @@ echo "Format and mount fs"
>  _scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
>  _scratch_mount >> $seqres.full
>  
> +# Disable realtime inherit flag (if any) on root directory so that space on data
> +# device gets fragmented rather than realtime device.
> +$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> +
>  echo "Consume free space"
>  fillerdir=$SCRATCH_MNT/fillerdir
>  nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> diff --git a/tests/xfs/538 b/tests/xfs/538
> index 90eb1637..97273b88 100755
> --- a/tests/xfs/538
> +++ b/tests/xfs/538
> @@ -42,6 +42,10 @@ echo "Format and mount fs"
>  _scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
>  _scratch_mount >> $seqres.full
>  
> +# Disable realtime inherit flag (if any) on root directory so that space on data
> +# device gets fragmented rather than realtime device.
> +$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> +
>  bsize=$(_get_file_block_size $SCRATCH_MNT)
>  
>  echo "Consume free space"
> -- 
> 2.29.2
> 
