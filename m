Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375DBC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiECW7C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbiECW67 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:58:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D2A1FA76
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:55:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3079C6173B
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 22:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9FDC385A4;
        Tue,  3 May 2022 22:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651618524;
        bh=hIAKHIQhKnrardfyjll7XaZoqPPiKHCSiXQBS4QGr6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wy0fOb4xYdgcCcLvO/5M97kNZrKJUeYU7FeCrBuPW127z9PGNuvga9y4ohOtoUcJC
         ZQ2BhsehnsAwC5UbbTn4AJuRZxQ4EFcLqarpcyRxwJcoDn0cHhDLjbA+EKMOgjeJZi
         Sv2wNrycspUI+ltqVqSSUem2l8saNOrxpXeWf+Es7HKPhVYfFQGn9wWo4M0psMykqi
         At9lCvTSyA3jdWNastwAY3k35xeRKWvYADFcdMHItrPpwqrmboeOxVOP2FCgc6L2+G
         hPqXSTBEP1voPiRKdKUfMEQYFq2KQ3JrvWs+pwZctbfF1YM3BB7gAYXx4bvol8Fs7B
         x+twvuKpyw6Gg==
Date:   Tue, 3 May 2022 15:55:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: validate inode fork size against fork format
Message-ID: <20220503225524.GG8265@magnolia>
References: <20220502082018.1076561-1-david@fromorbit.com>
 <20220502082018.1076561-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502082018.1076561-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 02, 2022 at 06:20:16PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_repair catches fork size/format mismatches, but the in-kernel
> verifier doesn't, leading to null pointer failures when attempting
> to perform operations on the fork. This can occur in the
> xfs_dir_is_empty() where the in-memory fork format does not match
> the size and so the fork data pointer is accessed incorrectly.
> 
> Note: this causes new failures in xfs/348 which is testing mode vs
> ftype mismatches. We now detect a regular file that has been changed
> to a directory or symlink mode as being corrupt because the data
> fork is for a symlink or directory should be in local form when
> there are only 3 bytes of data in the data fork. Hence the inode
> verify for the regular file now fires w/ -EFSCORRUPTED because
> the inode fork format does not match the format the corrupted mode
> says it should be in.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

/me wonders what the effect this is all going to have on the fuzz vs.
xfs_{scrub,repair} results, but I guess we'll find out in a few weeks.
:P

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 74b82ec80f8e..3b1b63f9d886 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -357,21 +357,38 @@ xfs_dinode_verify_fork(
>  {
>  	xfs_extnum_t		di_nextents;
>  	xfs_extnum_t		max_extents;
> +	mode_t			mode = be16_to_cpu(dip->di_mode);
> +	uint32_t		fork_size = XFS_DFORK_SIZE(dip, mp, whichfork);
> +	uint32_t		fork_format = XFS_DFORK_FORMAT(dip, whichfork);
>  
>  	di_nextents = xfs_dfork_nextents(dip, whichfork);
>  
> -	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
> +	/*
> +	 * For fork types that can contain local data, check that the fork
> +	 * format matches the size of local data contained within the fork.
> +	 *
> +	 * For all types, check that when the size says the should be in extent
> +	 * or btree format, the inode isn't claiming it is in local format.
> +	 */
> +	if (whichfork == XFS_DATA_FORK) {
> +		if (S_ISDIR(mode) || S_ISLNK(mode)) {
> +			if (be64_to_cpu(dip->di_size) <= fork_size &&
> +			    fork_format != XFS_DINODE_FMT_LOCAL)
> +				return __this_address;
> +		}
> +
> +		if (be64_to_cpu(dip->di_size) > fork_size &&
> +		    fork_format == XFS_DINODE_FMT_LOCAL)
> +			return __this_address;
> +	}
> +
> +	switch (fork_format) {
>  	case XFS_DINODE_FMT_LOCAL:
>  		/*
> -		 * no local regular files yet
> +		 * No local regular files yet.
>  		 */
> -		if (whichfork == XFS_DATA_FORK) {
> -			if (S_ISREG(be16_to_cpu(dip->di_mode)))
> -				return __this_address;
> -			if (be64_to_cpu(dip->di_size) >
> -					XFS_DFORK_SIZE(dip, mp, whichfork))
> -				return __this_address;
> -		}
> +		if (S_ISREG(mode) && whichfork == XFS_DATA_FORK)
> +			return __this_address;
>  		if (di_nextents)
>  			return __this_address;
>  		break;
> -- 
> 2.35.1
> 
