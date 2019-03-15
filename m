Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44834 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfCOWCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Mar 2019 18:02:09 -0400
From: Allison Henderson <allison.henderson@oracle.com>
Subject: Re: [PATCH 02/36] configure: use sys/xattr.h for fsetxattr detection
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259743543.31886.18053722203157328922.stgit@magnolia>
Message-ID: <8edf9102-e497-dff8-cd94-e00bfe60bd9e@oracle.com>
Date: Fri, 15 Mar 2019 15:01:59 -0700
MIME-Version: 1.0
In-Reply-To: <155259743543.31886.18053722203157328922.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Looks ok to me.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 3/14/19 2:03 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The only user of fsetxattr and HAVE_FSETXATTR is fsr, which includes
> sys/xattr.h (from libc).  However, the m4 macro to detect fsetxattr
> support requires attr/xattr.h (from libattr).  libattr dropped xattr.h
> last year, so update the check.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   m4/package_libcdev.m4 |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 7ee4acdd..2c0c72ce 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -223,14 +223,14 @@ AC_DEFUN([AC_HAVE_FLS],
>     ])
>   
>   #
> -# Check if we have a fsetxattr call (Mac OS X)
> +# Check if we have a fsetxattr call
>   #
>   AC_DEFUN([AC_HAVE_FSETXATTR],
>     [ AC_CHECK_DECL([fsetxattr],
>          have_fsetxattr=yes,
>          [],
>          [#include <sys/types.h>
> -        #include <attr/xattr.h>]
> +        #include <sys/xattr.h>]
>          )
>       AC_SUBST(have_fsetxattr)
>     ])
> 
