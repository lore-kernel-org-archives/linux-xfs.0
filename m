Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1134C352A1
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Dec 2022 17:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiLFRSl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Dec 2022 12:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbiLFRSh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 12:18:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588CF32B94;
        Tue,  6 Dec 2022 09:18:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8D39617EB;
        Tue,  6 Dec 2022 17:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407BEC433C1;
        Tue,  6 Dec 2022 17:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670347115;
        bh=GQju5I9rsYzVvmL969kniUvvyfbZHoiE0A6orRASmwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M7MpIJxk1QWtUojIhe0IN8pRTHKd4EQPrNJV8gjPBBD3reY5b8a1rAH3AODZ6z+3R
         0OGwDRkWhd4bNPf5xS4fW7p/8Q+tFMUmp4+jg/Di1qzpby15Ro9IMVz8s0/k7cwNAN
         fbJvFX0n+741Ia/E9UV1TouZopn85+cficjzeDuW2RfvP+NSJmd3IroRvD28prMzzi
         9Hw7Uk1yzRUFha1ijNyyBgv3peTzfJnF1Hwt/DY7avgKXuyMMycfGNsWCkF4Jzh4GI
         zvL4Yb8OL1rZnlmOYJJX+pgSNAEgFdCVwZY1C3IljgcRTp9VTtrqcT+azfDi2bCUiU
         9pfbCLn7+b4Bg==
Date:   Tue, 6 Dec 2022 09:18:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        hsiangkao@linux.alibaba.com, allison.henderson@oracle.com
Subject: Re: [PATCH V3 1/2] common/xfs: Add a helper to export inode core size
Message-ID: <Y495anewPlIsLf11@magnolia>
References: <20221206100517.1369625-1-ZiyangZhang@linux.alibaba.com>
 <20221206100517.1369625-2-ZiyangZhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206100517.1369625-2-ZiyangZhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 06, 2022 at 06:05:16PM +0800, Ziyang Zhang wrote:
> Some xfs test cases need the number of bytes reserved for only the inode
> record, excluding the immediate fork areas. Now the value is hard-coded
> and it is not a good chioce. Add a helper in common/xfs to export the
> inode core size.
> 
> Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/xfs    | 7 +++++++
>  tests/xfs/335 | 3 ++-
>  tests/xfs/336 | 3 ++-
>  tests/xfs/337 | 3 ++-
>  tests/xfs/341 | 3 ++-
>  tests/xfs/342 | 3 ++-
>  6 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 8ac1964e..5180b9d3 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1486,3 +1486,10 @@ _require_xfsrestore_xflag()
>  	$XFSRESTORE_PROG -h 2>&1 | grep -q -e '-x' || \
>  			_notrun 'xfsrestore does not support -x flag.'
>  }
> +
> +# Number of bytes reserved for only the inode record, excluding the
> +# immediate fork areas.
> +_xfs_inode_core_bytes()
> +{
> +	echo 176
> +}
> diff --git a/tests/xfs/335 b/tests/xfs/335
> index ccc508e7..624a8fd1 100755
> --- a/tests/xfs/335
> +++ b/tests/xfs/335
> @@ -31,7 +31,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
>  echo "Create a three-level rtrmapbt"
>  # inode core size is at least 176 bytes; btree header is 56 bytes;
>  # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
> -i_ptrs=$(( (isize - 176) / 56 ))
> +i_core_size="$(_xfs_inode_core_bytes)"
> +i_ptrs=$(( (isize - i_core_size) / 56 ))
>  bt_ptrs=$(( (blksz - 56) / 56 ))
>  bt_recs=$(( (blksz - 56) / 32 ))
>  
> diff --git a/tests/xfs/336 b/tests/xfs/336
> index b1de8e5f..e601632d 100755
> --- a/tests/xfs/336
> +++ b/tests/xfs/336
> @@ -42,7 +42,8 @@ rm -rf $metadump_file
>  echo "Create a three-level rtrmapbt"
>  # inode core size is at least 176 bytes; btree header is 56 bytes;
>  # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
> -i_ptrs=$(( (isize - 176) / 56 ))
> +i_core_size="$(_xfs_inode_core_bytes)"
> +i_ptrs=$(( (isize - i_core_size) / 56 ))
>  bt_ptrs=$(( (blksz - 56) / 56 ))
>  bt_recs=$(( (blksz - 56) / 32 ))
>  
> diff --git a/tests/xfs/337 b/tests/xfs/337
> index a2515e36..5d5ec8dc 100755
> --- a/tests/xfs/337
> +++ b/tests/xfs/337
> @@ -33,7 +33,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
>  
>  # inode core size is at least 176 bytes; btree header is 56 bytes;
>  # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
> -i_ptrs=$(( (isize - 176) / 56 ))
> +i_core_size="$(_xfs_inode_core_bytes)"
> +i_ptrs=$(( (isize - i_core_size) / 56 ))
>  bt_ptrs=$(( (blksz - 56) / 56 ))
>  bt_recs=$(( (blksz - 56) / 32 ))
>  
> diff --git a/tests/xfs/341 b/tests/xfs/341
> index f026aa37..45afd407 100755
> --- a/tests/xfs/341
> +++ b/tests/xfs/341
> @@ -33,7 +33,8 @@ rtextsz_blks=$((rtextsz / blksz))
>  
>  # inode core size is at least 176 bytes; btree header is 56 bytes;
>  # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
> -i_ptrs=$(( (isize - 176) / 56 ))
> +i_core_size="$(_xfs_inode_core_bytes)"
> +i_ptrs=$(( (isize - i_core_size) / 56 ))
>  bt_recs=$(( (blksz - 56) / 32 ))
>  
>  blocks=$((i_ptrs * bt_recs + 1))
> diff --git a/tests/xfs/342 b/tests/xfs/342
> index 1ae414eb..d4f54168 100755
> --- a/tests/xfs/342
> +++ b/tests/xfs/342
> @@ -30,7 +30,8 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
>  
>  # inode core size is at least 176 bytes; btree header is 56 bytes;
>  # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
> -i_ptrs=$(( (isize - 176) / 56 ))
> +i_core_size="$(_xfs_inode_core_bytes)"
> +i_ptrs=$(( (isize - i_core_size) / 56 ))
>  bt_recs=$(( (blksz - 56) / 32 ))
>  
>  blocks=$((i_ptrs * bt_recs + 1))
> -- 
> 2.18.4
> 
