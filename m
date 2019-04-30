Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51574 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfD3UPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Apr 2019 16:15:52 -0400
Date: Tue, 30 Apr 2019 13:15:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_io: rework includes for statx structures
Message-ID: <20190430201533.GI5207@magnolia>
References: <cec15436-c098-c59f-2663-a6a189e46a0c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cec15436-c098-c59f-2663-a6a189e46a0c@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Apr 30, 2019 at 03:02:56PM -0500, Eric Sandeen wrote:
> Only include the kernel's linux/stat.h headers if we haven't
> already picked up statx bits from glibc, to avoid redefinition.
> 
> Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> Tested-by: Bill O'Donnell <billodo@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

We'll never have problems again!! :D

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(I built it on Ubuntu 18.04 LTS if anyone cares)

--D

> ---
> 
> diff --git a/io/stat.c b/io/stat.c
> index 517be66..37c0b2e 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -6,9 +6,6 @@
>   * Portions of statx support written by David Howells (dhowells@redhat.com)
>   */
>  
> -/* Try to pick up statx definitions from the system headers. */
> -#include <linux/stat.h>
> -
>  #include "command.h"
>  #include "input.h"
>  #include "init.h"
> diff --git a/io/statx.h b/io/statx.h
> index 4f40eaa..c6625ac 100644
> --- a/io/statx.h
> +++ b/io/statx.h
> @@ -33,7 +33,14 @@
>  # endif
>  #endif
>  
> +
> +#ifndef STATX_TYPE
> +/* Pick up kernel definitions if glibc didn't already provide them */
> +#include <linux/stat.h>
> +#endif
> +
>  #ifndef STATX_TYPE
> +/* Local definitions if glibc & kernel headers didn't already provide them */
>  
>  /*
>   * Timestamp structure for the timestamps in struct statx.
> 
