Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:47291 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751787AbdI0KDe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Sep 2017 06:03:34 -0400
Received: by mail-wm0-f51.google.com with SMTP id r136so16284932wmf.2
        for <linux-xfs@vger.kernel.org>; Wed, 27 Sep 2017 03:03:33 -0700 (PDT)
Date: Wed, 27 Sep 2017 12:03:30 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] db: increase metadump's default overly long extent
 discard threshold
Message-ID: <20170927100330.7sz7gkwwq4lsl534@hades.localdomain>
References: <20170927023410.GO5020@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170927023410.GO5020@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Wed, Sep 27, 2017 at 02:34:10AM +0000, Darrick J. Wong wrote:
> Back in 88b8e1d6d7 ("Make xfs_metadump more robust against bad data"),
> metadump grew the ability to ignore a directory extent if it was longer
> than 20 blocks.  Presumably this was to protect metadump from dumping
> absurdly long extents resulting from bmbt corruption, but it's certainly
> possible to create a directory with an extent longer than 20 blocks.
> Hilariously, the discards happen with no warning unless the caller
> explicitly set -w.
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> This was raised to 1000 blocks in 7431d134fe8 ("Increase default maximum
> extent size for xfs_metadump when copying..."), but it's still possible
> to create a directory with an extent longer than 1000 blocks.
> 
> Increase the threshold to MAXEXTLEN blocks because it's totally valid
> for the filesystem to create extents up to that length.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: update manpage
> ---
>  db/metadump.c           |    2 +-
>  man/man8/xfs_metadump.8 |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
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
>  /*
>   * It's possible that multiple files in a directory (or attributes
> diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
> index 3731d6a..b6af4b6 100644
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
