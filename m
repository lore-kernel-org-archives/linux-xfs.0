Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42422 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbeCPFZ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Mar 2018 01:25:28 -0400
Date: Thu, 15 Mar 2018 22:25:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs_scrub: add missing paths header
Message-ID: <20180316052519.GA1757@magnolia>
References: <c05fc32d43b3870b63539c57428e1c52e3e7c3cd.1521177696.git.baruch@tkos.co.il>
 <27747dcbfbde8a767b1a873716fce1d3aaf17c2f.1521177696.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27747dcbfbde8a767b1a873716fce1d3aaf17c2f.1521177696.git.baruch@tkos.co.il>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-xfs@vger.kernel.org

On Fri, Mar 16, 2018 at 07:21:36AM +0200, Baruch Siach wrote:
> Fix the following build failure with musl libc:
> 
> xfs_scrub.c: In function ‘main’:
> xfs_scrub.c:670:11: error: ‘_PATH_MOUNTED’ undeclared (first use in this function)
>     mtab = _PATH_MOUNTED;
>            ^~~~~~~~~~~~~
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  scrub/xfs_scrub.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index ab26e6335948..eedbe34ec7b3 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -21,6 +21,7 @@
>  #include <pthread.h>
>  #include <stdbool.h>
>  #include <stdlib.h>
> +#include <paths.h>
>  #include <sys/time.h>
>  #include <sys/resource.h>
>  #include <sys/statvfs.h>
> -- 
> 2.16.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
