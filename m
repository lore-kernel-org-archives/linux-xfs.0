Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36962 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752562AbeCZSJz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Mar 2018 14:09:55 -0400
Date: Mon, 26 Mar 2018 11:09:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_scrub: fix build with older kernel headers
Message-ID: <20180326180946.GT4818@magnolia>
References: <7ea1df02d0f2549b6249c8bee1f6ae02bf1251a9.1521925697.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ea1df02d0f2549b6249c8bee1f6ae02bf1251a9.1521925697.git.baruch@tkos.co.il>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-xfs@vger.kernel.org

On Sun, Mar 25, 2018 at 12:08:17AM +0300, Baruch Siach wrote:
> The OVERRIDE_SYSTEM_FSXATTR macro in include/linux.h is meant to
> override the linux/fs.h kernel header provided struct fsxattr for
> kernels older than v4.7. A few source files include linux/fs.h before
> the local linux.h, making this override ineffective. Remove these header
> includes from the source files, and rely on the linux.h include alone.
> 
> This fixes the following build failures:
> 
> In file included from ../include/xfs.h:37:0,
>                  from disk.c:40:
> ../include/xfs/linux.h:185:8: error: redefinition of 'struct fsxattr'
>  struct fsxattr {
>         ^~~~~~~
> 
> In file included from ../include/xfs.h:37:0,
>                  from ../include/project.h:22,
>                  from ../include/input.h:24,
>                  from phase1.c:38:
> ../include/xfs/linux.h:185:8: error: redefinition of 'struct fsxattr'
>  struct fsxattr {
>         ^~~~~~~
> 
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Looks ok, but I think this is already fixed by commit a440f8773794
("xfs_scrub: fix #include ordering to avoid build failure") in for-next.

--D

> ---
>  scrub/disk.c   | 1 -
>  scrub/phase1.c | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/scrub/disk.c b/scrub/disk.c
> index e12175c8656c..54d7a2a77c45 100644
> --- a/scrub/disk.c
> +++ b/scrub/disk.c
> @@ -28,7 +28,6 @@
>  #include <sys/ioctl.h>
>  #include <sys/statvfs.h>
>  #include <sys/vfs.h>
> -#include <linux/fs.h>
>  #ifdef HAVE_SG_IO
>  # include <scsi/sg.h>
>  #endif
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index 6cd544233c94..d15689e1b544 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -32,7 +32,6 @@
>  #include <stdbool.h>
>  #include <pthread.h>
>  #include <errno.h>
> -#include <linux/fs.h>
>  #include "libfrog.h"
>  #include "workqueue.h"
>  #include "input.h"
> -- 
> 2.16.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
