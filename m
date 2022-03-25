Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882E6C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 22:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbiCYWJh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbiCYWJh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 18:09:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231161637C9
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 15:08:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1C3A612C6
        for <linux-xfs@vger.kernel.org>; Fri, 25 Mar 2022 22:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCC6C2BBE4;
        Fri, 25 Mar 2022 22:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648246081;
        bh=uijFSbxcfsm47BBZacL1kusGN0DyFLLDhknM5oeutyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bPimKychzGdR6CDv+7Nuowjy69/ORszhYrpJR52f+0reWGn6AoDidWf7nRJ3RUTHd
         hk6TA9/9razmTbMaJ5ZfJaQNaB36BCBUx7jn2dngwmDT7IYc/2bBEmuDVmvgz7KCCs
         akAnKylgOfTHKPdV2wMsOsSbm4jb2nghLYM2oDv+qcKFVztHcTMrAcJe4tQxscZEkX
         wyVGBkwY7L85xE7FSzJfXzG/upYIJW9YBJdMLzyvI142GB8OlH840Upfmo+XM1ruku
         5mZi38FC4zicdDJowPQxy83hTRMcfO2t3D0uPpkU1nmEKlviQUdrjsqiFbuN/UwIvG
         9BYfqYxs4yCsQ==
Date:   Fri, 25 Mar 2022 15:08:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/5] mkfs: increase the minimum log size to 64MB when
 possible
Message-ID: <20220325220800.GV8224@magnolia>
References: <164738660248.3191861.2400129607830047696.stgit@magnolia>
 <164738661924.3191861.13544747266285023363.stgit@magnolia>
 <bdb3d82d-23f7-8f52-299f-5913c79fde93@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdb3d82d-23f7-8f52-299f-5913c79fde93@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 25, 2022 at 07:48:08AM -1000, Eric Sandeen wrote:
> Darrick, it bugged me a bit that the way this patch worked was to go through
> one set of calculations to sort out a log size, then throw in a new heuristic
> or two to change that result.  And TBH the 7/8 bit seems very ad hoc when
> we already had the prior 95% heuristic.
> 
> While I know that most of this goes away by the last patch, I'm considering
> deferring patches 4 & 5 for the next release because of the impact on
> fstests, so would like to land somewhere clean by patch 3.
> 
> What do you think of this patch as a replacement for this patch 3/5? It's a
> bit clearer to me, and results in (almost) the same net results as your patch,
> with minor differences around 512MB filesystems due to the removal of the
> 7/8 limit.
> 
> Depending on what you think, I can tweak your commit log as needed, leave
> your authorship, and add a:
> 
> [sandeen: consolidate heuristics into something a bit more clear]
> 
> or something like that... or, claim authorship (and all ensuing bugs) ;)

Man, my email is slow today!

This looks ok to me, though at this point you've basically reauthored
the whole thing.  You might as well own it and add:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> 
> Thanks,
> -Eric
> 
> diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
> index a16a9fe2..ef4443b0 100644
> --- a/include/xfs_multidisk.h
> +++ b/include/xfs_multidisk.h
> @@ -17,8 +17,6 @@
>  #define	XFS_MIN_INODE_PERBLOCK	2		/* min inodes per block */
>  #define	XFS_DFL_IMAXIMUM_PCT	25		/* max % of space for inodes */
>  #define	XFS_MIN_REC_DIRSIZE	12		/* 4096 byte dirblocks (V2) */
> -#define	XFS_DFL_LOG_FACTOR	5		/* default log size, factor */
> -						/* with max trans reservation */
>  #define XFS_MAX_INODE_SIG_BITS	32		/* most significant bits in an
>  						 * inode number that we'll
>  						 * accept w/o warnings
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index ad776492..cf1d64a2 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -18,6 +18,14 @@
>  #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
>  #define MEGABYTES(count, blog)	((uint64_t)(count) << (20 - (blog)))
>  
> +/*
> + * Realistically, the log should never be smaller than 64MB.  Studies by the
> + * kernel maintainer in early 2022 have shown a dramatic reduction in long tail
> + * latency of the xlog grant head waitqueue when running a heavy metadata
> + * update workload when the log size is at least 64MB.
> + */
> +#define XFS_MIN_REALISTIC_LOG_BLOCKS(blog)	(MEGABYTES(64, (blog)))
> +
>  /*
>   * Use this macro before we have superblock and mount structure to
>   * convert from basic blocks to filesystem blocks.
> @@ -3297,7 +3305,7 @@ calculate_log_size(
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_sb		*sbp = &mp->m_sb;
> -	int			min_logblocks;
> +	int			min_logblocks;	/* absolute minimum */
>  	struct xfs_mount	mount;
>  
>  	/* we need a temporary mount to calculate the minimum log size. */
> @@ -3339,29 +3347,19 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
>  
>  	/* internal log - if no size specified, calculate automatically */
>  	if (!cfg->logblocks) {
> -		if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
> -			/* tiny filesystems get minimum sized logs. */
> -			cfg->logblocks = min_logblocks;
> -		} else if (cfg->dblocks < GIGABYTES(16, cfg->blocklog)) {
> +		/* Use a 2048:1 fs:log ratio for most filesystems */
> +		cfg->logblocks = (cfg->dblocks << cfg->blocklog) / 2048;
> +		cfg->logblocks = cfg->logblocks >> cfg->blocklog;
>  
> -			/*
> -			 * For small filesystems, we want to use the
> -			 * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
> -			 * at all possible, ramping up to 128MB at 256GB.
> -			 */
> -			cfg->logblocks = min(XFS_MIN_LOG_BYTES >> cfg->blocklog,
> -					min_logblocks * XFS_DFL_LOG_FACTOR);
> -		} else {
> -			/*
> -			 * With a 2GB max log size, default to maximum size
> -			 * at 4TB. This keeps the same ratio from the older
> -			 * max log size of 128M at 256GB fs size. IOWs,
> -			 * the ratio of fs size to log size is 2048:1.
> -			 */
> -			cfg->logblocks = (cfg->dblocks << cfg->blocklog) / 2048;
> -			cfg->logblocks = cfg->logblocks >> cfg->blocklog;
> -		}
> +		/* But don't go below a reasonable size */
> +		cfg->logblocks = max(cfg->logblocks,
> +				XFS_MIN_REALISTIC_LOG_BLOCKS(cfg->blocklog));
> +
> +		/* And for a tiny filesystem, use the absolute minimum size */
> +		if (cfg->dblocks < MEGABYTES(512, cfg->blocklog))
> +			cfg->logblocks = min_logblocks;
>  
> +		/* Enforce min/max limits */
>  		clamp_internal_log_size(cfg, mp, min_logblocks);
>  
>  		validate_log_size(cfg->logblocks, cfg->blocklog, min_logblocks);
> 
> 
