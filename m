Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbfD3VA2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Apr 2019 17:00:28 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 136BEC0AF78A
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2019 21:00:28 +0000 (UTC)
Date: Tue, 30 Apr 2019 16:00:13 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs_io: rework includes for statx structures
Message-ID: <20190430210013.GA30134@redhat.com>
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

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

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
