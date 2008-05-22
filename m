Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 May 2008 06:22:46 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4MDMiDS003252
	for <xfs@oss.sgi.com>; Thu, 22 May 2008 06:22:44 -0700
Date: Thu, 22 May 2008 09:23:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] allow mkfs to make larger logs
Message-ID: <20080522132333.GB4972@infradead.org>
References: <20080522061222.GQ173056135@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522061222.GQ173056135@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 22, 2008 at 04:12:22PM +1000, David Chinner wrote:
> ===================================================================
> --- xfs-cmds.orig/xfsprogs/include/xfs_fs.h	2008-05-15 16:32:52.929462025 +1000
> +++ xfs-cmds/xfsprogs/include/xfs_fs.h	2008-05-15 18:50:19.494520368 +1000
> @@ -248,10 +248,13 @@ typedef struct xfs_fsop_resblks {
>   * Minimum and maximum sizes need for growth checks
>   */
>  #define XFS_MIN_AG_BLOCKS	64
> -#define XFS_MIN_LOG_BLOCKS	512
> -#define XFS_MAX_LOG_BLOCKS	(64 * 1024)
> -#define XFS_MIN_LOG_BYTES	(256 * 1024)
> -#define XFS_MAX_LOG_BYTES	(128 * 1024 * 1024)
> +#define XFS_MIN_LOG_BLOCKS	512ULL
> +#define XFS_MAX_LOG_BLOCKS	(1024 * 1024ULL)
> +#define XFS_MIN_LOG_BYTES	(10 * 1024 * 1024ULL)
> +
> +/* keep the maximum size under 2^31 by a small amount */
> +#define XFS_MAX_LOG_BYTES \
> +	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)

This file is a copy for the kernel, so please update it there aswell,
once we get changes to these files in both xfs-cmds and the kernel tree
merging will become a complete nightmare.

Except for that the patch looks good to me.
