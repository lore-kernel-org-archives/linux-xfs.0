Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752172AbdJTLXt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:23:49 -0400
Date: Fri, 20 Oct 2017 07:23:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] db: increase metadump's default overly long extent
 discard threshold
Message-ID: <20171020112340.GA13669@bfoster.bfoster>
References: <150837629129.31583.8002405051612025341.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150837629129.31583.8002405051612025341.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>

On Wed, Oct 18, 2017 at 06:24:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Back in 88b8e1d6d7 ("Make xfs_metadump more robust against bad data"),
> metadump grew the ability to ignore a directory extent if it was longer
> than 20 blocks.  Presumably this was to protect metadump from dumping
> absurdly long extents resulting from bmbt corruption, but it's certainly
> possible to create a directory with an extent longer than 20 blocks.
> Hilariously, the discards happen with no warning unless the caller
> explicitly set -w.
> 
> This was raised to 1000 blocks in 7431d134fe8 ("Increase default maximum
> extent size for xfs_metadump when copying..."), but it's still possible
> to create a directory with an extent longer than 1000 blocks.
> 
> Increase the threshold to MAXEXTLEN blocks because it's totally valid
> for the filesystem to create extents up to that length.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  db/metadump.c           |    2 +-
>  man/man8/xfs_metadump.8 |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 6dd06c3..8ffb90f 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -32,7 +32,7 @@
>  #include "field.h"
>  #include "dir2.h"
>  
> -#define DEFAULT_MAX_EXT_SIZE	1000
> +#define DEFAULT_MAX_EXT_SIZE	MAXEXTLEN
>  

Perhaps we should just kill DEFAULT_MAX_EXT_SIZE and replace its use
with MAXEXTLEN..? Looks fine either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  /*
>   * It's possible that multiple files in a directory (or attributes
> diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
> index 3731d6a..7207c20 100644
> --- a/man/man8/xfs_metadump.8
> +++ b/man/man8/xfs_metadump.8
> @@ -114,7 +114,7 @@ copied.
>  .B \-m
>  Set the maximum size of an allowed metadata extent.  Extremely large metadata
>  extents are likely to be corrupt, and will be skipped if they exceed
> -this value.  The default size is 1000 blocks.
> +this value.  The default size is 2097151 blocks.
>  .TP
>  .B \-o
>  Disables obfuscation of file names and extended attributes.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
