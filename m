Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E10C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Apr 2022 01:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiDEBJl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 21:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiDEBJl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Apr 2022 21:09:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D316A3A4293
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 18:06:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A3B1B81B04
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 00:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDDAC2BBE4;
        Tue,  5 Apr 2022 00:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649120127;
        bh=PjXzTpso1bU8Z1veQH3vcWTRI2cOypmFMSBJQkZylOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i7M+hbmW/Dzi4u5rAF/aT2E8WGl223j4NzqUDhNYP0S3oP7+wWT7IWCGWxNtdOmfN
         tUVn1G3RtOiyDlkxSFibqZom3Q7qHJlnKIpMwhCfzeGda6Ej3b32c5O6cNpkZxRmOs
         OQ8G9ZYbtK6etr81IcrBBeyGedAZCENWeVFJGI/6xy7Wl1OasbFWexFUifUFRFFjXD
         mINlhsjXfYHMe7/DPRjygmk+qPSx4WQ49xT465tGJ3BU/M/JHReM6WxOZ5bMDZDCZu
         4lwrWc69e3YUerovsexPydgihrAQUB1qqrYz0DjPL6gvPwdWyJqhY1alfs/AmEjhJ+
         QRwxZWShB4w+Q==
Date:   Mon, 4 Apr 2022 17:55:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <esandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] mkfs: increase the minimum log size to 64MB when
 possible
Message-ID: <20220405005527.GQ27690@magnolia>
References: <a8bc42f2-98db-2f16-2879-9ed62415ba01@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8bc42f2-98db-2f16-2879-9ed62415ba01@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 04, 2022 at 06:08:28PM -0500, Eric Sandeen wrote:
> Recently, the upstream maintainers have been taking a lot of heat on
> account of writer threads encountering high latency when asking for log
> grant space when the log is small.  The reported use case is a heavily
> threaded indexing product logging trace information to a filesystem
> ranging in size between 20 and 250GB.  The meetings that result from the
> complaints about latency and stall warnings in dmesg both from this use
> case and also a large well known cloud product are now consuming 25% of
> the maintainer's weekly time and have been for months.
> 
> For small filesystems, the log is small by default because we have
> defaulted to a ratio of 1:2048 (or even less).  For grown filesystems,
> this is even worse, because big filesystems generate big metadata.
> However, the log size is still insufficient even if it is formatted at
> the larger size.
> 
> On a 220GB filesystem, the 99.95% latencies observed with a 200-writer
> file synchronous append workload running on a 44-AG filesystem (with 44
> CPUs) spread across 4 hard disks showed:
> 
> 	99.5%
> Log(MB)	Latency(ms)	BW (MB/s)	xlog_grant_head_wait
> 10	520		243		1875
> 20	220		308		540
> 40	140		360		6
> 80	92		363		0
> 160	86		364		0
> 
> For 4 NVME, the results were:
> 
> 10	201		409		898
> 20	177		488		144
> 40	122		550		0
> 80	120		549		0
> 160	121		545		0
> 
> This shows pretty clearly that we could reduce the amount of time that
> threads spend waiting on the XFS log by increasing the log size to at
> least 40MB regardless of size.  We then repeated the benchmark with a
> cloud system and an old machine to see if there were any ill effects on
> less stable hardware.
> 
> For cloudy iscsi block storage, the results were:
> 
> 10	390		176		2584
> 20	173		186		357
> 40	37		187		0
> 80	40		183		0
> 160	37		183		0
> 
> A decade-old machine w/ 24 CPUs and a giant spinning disk RAID6 array
> produced this:
> 
> 10	55		5.4		0
> 20	40		5.9		0
> 40	62		5.7		0
> 80	66		5.7		0
> 160	25		5.4		0
> 
> From the first three scenarios, it is clear that there are gains to be
> had by sizing the log somewhere between 40 and 80MB -- the long tail
> latency drops quite a bit, and programs are no longer blocking on the
> log's transaction space grant heads.  Split the difference and set the
> log size floor to 64MB.
> 
> Inspired-by: Darrick J. Wong <djwong@kernel.org>
> Commit-log-stolen-from: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> This is reworked, with dependencies on other patches removed; details in
> followup emails.
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
> index 96682f9a..e36c1083 100644
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
> @@ -3266,7 +3274,7 @@ calculate_log_size(
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_sb		*sbp = &mp->m_sb;
> -	int			min_logblocks;
> +	int			min_logblocks;	/* absolute minimum */
>  	struct xfs_mount	mount;
>  
>  	/* we need a temporary mount to calculate the minimum log size. */
> @@ -3308,28 +3316,17 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
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

Heh, I was going to apply this to any filesystem under 300MB (and then
cut everyone off at 300M) but I suppose if you'd rather set that at 512M
then I'm not going to complain... maybe we're better off not creating
absurd things like 20% of a tiny FS used for logs. :D

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
>  		/* Ensure the chosen size meets minimum log size requirements */
>  		cfg->logblocks = max(min_logblocks, cfg->logblocks);
> 
