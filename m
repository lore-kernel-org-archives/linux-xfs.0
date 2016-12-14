Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56161 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754954AbcLNKpL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2016 05:45:11 -0500
Date: Wed, 14 Dec 2016 02:44:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] duperemove: test presence of dedupe ioctl
Message-ID: <20161214104436.GB16862@infradead.org>
References: <20161209175645.GB16813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161209175645.GB16813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mfasheh@versity.com, xfs <linux-xfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Fri, Dec 09, 2016 at 09:56:45AM -0800, Darrick J. Wong wrote:
> Since a zero-length dedupe operation is guaranteed to succeed, use that
> to test whether or not this filesystem supports dedupe.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  file_scan.c |   47 +++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 37 insertions(+), 10 deletions(-)
> 
> diff --git a/file_scan.c b/file_scan.c
> index 617f166..a34453e 100644
> --- a/file_scan.c
> +++ b/file_scan.c
> @@ -45,11 +45,7 @@
>  #include "file_scan.h"
>  #include "dbfile.h"
>  #include "util.h"
> -
> -/* This is not in linux/magic.h */
> -#ifndef	XFS_SB_MAGIC
> -#define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
> -#endif
> +#include "btrfs-ioctl.h"
>  
>  static char path[PATH_MAX] = { 0, };
>  static char *pathp = path;
> @@ -189,6 +185,39 @@ static int walk_dir(const char *name)
>  	return ret;
>  }
>  
> +struct fake_btrfs_ioctl_same_args {
> +	struct btrfs_ioctl_same_args args;
> +	struct btrfs_ioctl_same_extent_info info;
> +};

Why does this need a fake structure here?
