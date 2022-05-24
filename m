Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D067C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 03:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbiEXDqu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 23:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbiEXDqt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 23:46:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9263C56429
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 20:46:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEF2A61362
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 03:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9CEC385A9;
        Tue, 24 May 2022 03:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653364005;
        bh=tvusbwx3aWpd4dKwrq4mfmmO8E8XgabyK2WPpUdULwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eyBqBeHvzws9kr7Fxlt75wceUNugL1hiGWaiE+YKe5ukS0+1p4m+olY+sMWrmRjFy
         wdaxTJ66xGpNqukViPfzC0/f0tXF9XzbLmWu4ap3cUBzk4Qapd3JuPjKE//AsIDo7A
         gS2HJPLoCm+n1D0bD6inuFI85HjzHYmeN4E3kOwfn0DB3emgGZCkuhDDEMh9Pd3s1h
         lTnfuJNcmjwE6ylMIHFu81pMWEDl+dxEzLKTR7IGt69zUjKooxNx3kKAujKnyLj9oR
         oE9Pu6+2Mc45jQPpFXeXXxmhKA48UItGvFCjRMlQPtSfVm3wPVGQp2tNFllKguKiCe
         vQaNM7tX3rQDw==
Date:   Mon, 23 May 2022 20:46:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: avoid unnecessary runtime sibling pointer
 endian conversions
Message-ID: <YoxVJPOvjjBRUBs7@magnolia>
References: <20220524022158.1849458-1-david@fromorbit.com>
 <20220524022158.1849458-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524022158.1849458-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 12:21:56PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit dc04db2aa7c9 has caused a small aim7 regression, showing a
> small increase in CPU usage in __xfs_btree_check_sblock() as a
> result of the extra checking.
> 
> This is likely due to the endian conversion of the sibling poitners
> being unconditional instead of relying on the compiler to endian
> convert the NULL pointer at compile time and avoiding the runtime
> conversion for this common case.
> 
> Rework the checks so that endian conversion of the sibling pointers
> is only done if they are not null as the original code did.
> 
> .... and these need to be "inline" because the compiler completely
> fails to inline them automatically like it should be doing.
> 
> $ size fs/xfs/libxfs/xfs_btree.o*
>    text	   data	    bss	    dec	    hex	filename
>   51874	    240	      0	  52114	   cb92 fs/xfs/libxfs/xfs_btree.o.orig
>   51562	    240	      0	  51802	   ca5a fs/xfs/libxfs/xfs_btree.o.inline
> 
> Just when you think the tools have advanced sufficiently we don't
> have to care about stuff like this anymore, along comes a reminder
> that *our tools still suck*.
> 
> Fixes: dc04db2aa7c9 ("xfs: detect self referencing btree sibling pointers")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c | 47 +++++++++++++++++++++++++++------------
>  1 file changed, 33 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 2aa300f7461f..786ec1cb1bba 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -51,16 +51,31 @@ xfs_btree_magic(
>  	return magic;
>  }
>  
> -static xfs_failaddr_t
> +/*
> + * These sibling pointer checks are optimised for null sibling pointers. This
> + * happens a lot, and we don't need to byte swap at runtime if the sibling
> + * pointer is NULL.
> + *
> + * These are explicitly marked at inline because the cost of calling them as
> + * functions instead of inlining them is about 36 bytes extra code per call site
> + * on x86-64. Yes, gcc-11 fails to inline them, and explicit inlining of these
> + * two sibling check functions reduces the compiled code size by over 300
> + * bytes.
> + */
> +static inline xfs_failaddr_t
>  xfs_btree_check_lblock_siblings(
>  	struct xfs_mount	*mp,
>  	struct xfs_btree_cur	*cur,
>  	int			level,
>  	xfs_fsblock_t		fsb,
> -	xfs_fsblock_t		sibling)
> +	__be64			dsibling)
>  {
> -	if (sibling == NULLFSBLOCK)
> +	xfs_fsblock_t		sibling;
> +
> +	if (dsibling == cpu_to_be64(NULLFSBLOCK))
>  		return NULL;
> +
> +	sibling = be64_to_cpu(dsibling);
>  	if (sibling == fsb)
>  		return __this_address;
>  	if (level >= 0) {
> @@ -74,17 +89,21 @@ xfs_btree_check_lblock_siblings(
>  	return NULL;
>  }
>  
> -static xfs_failaddr_t
> +static inline xfs_failaddr_t
>  xfs_btree_check_sblock_siblings(
>  	struct xfs_mount	*mp,
>  	struct xfs_btree_cur	*cur,
>  	int			level,
>  	xfs_agnumber_t		agno,
>  	xfs_agblock_t		agbno,
> -	xfs_agblock_t		sibling)
> +	__be32			dsibling)
>  {
> -	if (sibling == NULLAGBLOCK)
> +	xfs_agblock_t		sibling;
> +
> +	if (dsibling == cpu_to_be32(NULLAGBLOCK))
>  		return NULL;
> +
> +	sibling = be32_to_cpu(dsibling);
>  	if (sibling == agbno)
>  		return __this_address;
>  	if (level >= 0) {
> @@ -136,10 +155,10 @@ __xfs_btree_check_lblock(
>  		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
>  
>  	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
> -			be64_to_cpu(block->bb_u.l.bb_leftsib));
> +			block->bb_u.l.bb_leftsib);
>  	if (!fa)
>  		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
> -				be64_to_cpu(block->bb_u.l.bb_rightsib));
> +				block->bb_u.l.bb_rightsib);
>  	return fa;
>  }
>  
> @@ -204,10 +223,10 @@ __xfs_btree_check_sblock(
>  	}
>  
>  	fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno, agbno,
> -			be32_to_cpu(block->bb_u.s.bb_leftsib));
> +			block->bb_u.s.bb_leftsib);
>  	if (!fa)
>  		fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno,
> -				 agbno, be32_to_cpu(block->bb_u.s.bb_rightsib));
> +				 agbno, block->bb_u.s.bb_rightsib);
>  	return fa;
>  }
>  
> @@ -4523,10 +4542,10 @@ xfs_btree_lblock_verify(
>  	/* sibling pointer verification */
>  	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
>  	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
> -			be64_to_cpu(block->bb_u.l.bb_leftsib));
> +			block->bb_u.l.bb_leftsib);
>  	if (!fa)
>  		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
> -				be64_to_cpu(block->bb_u.l.bb_rightsib));
> +				block->bb_u.l.bb_rightsib);
>  	return fa;

The next thing I wanna do is make __xfs_btree_check_[sl]block actually
print out the failaddr_t returned to it.

I half wonder if it would be *even faster* to pass in a *pointer* to the
sibling fields and use be64_to_cpup, but the time savings will probably
be eaten up on regrokking asm code, so

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  }
>  
> @@ -4580,10 +4599,10 @@ xfs_btree_sblock_verify(
>  	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
>  	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
>  	fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
> -			be32_to_cpu(block->bb_u.s.bb_leftsib));
> +			block->bb_u.s.bb_leftsib);
>  	if (!fa)
>  		fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
> -				be32_to_cpu(block->bb_u.s.bb_rightsib));
> +				block->bb_u.s.bb_rightsib);
>  	return fa;
>  }
>  
> -- 
> 2.35.1
> 
