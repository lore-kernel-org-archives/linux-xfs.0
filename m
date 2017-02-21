Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53988 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753561AbdBUSQ0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Feb 2017 13:16:26 -0500
Subject: Re: [PATCH] include: don't collide __bitwise definitions in 4.10
References: <20170221180525.GG5846@birch.djwong.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <c9d0ac33-43df-1062-e71d-1df071dbba60@redhat.com>
Date: Tue, 21 Feb 2017 12:16:24 -0600
MIME-Version: 1.0
In-Reply-To: <20170221180525.GG5846@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 2/21/17 12:05 PM, Darrick J. Wong wrote:
> Linux 4.10 changed the definition of __bitwise in such a way that
> xfsprogs' definition is no longer a strict match for it.  This causes
> gcc to complain, so only #define it here if the system hasn't already
> done it for us.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Makes sense, thanks for catching this.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/xfs_arch.h |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/xfs_arch.h b/include/xfs_arch.h
> index 6e3172c..12cd43e 100644
> --- a/include/xfs_arch.h
> +++ b/include/xfs_arch.h
> @@ -25,10 +25,14 @@
>  #endif
>  
>  #ifdef __CHECKER__
> -#define __bitwise		__attribute__((bitwise))
> +# ifndef __bitwise
> +#  define __bitwise		__attribute__((bitwise))
> +# endif
>  #define __force			__attribute__((force))
>  #else
> -#define __bitwise
> +# ifndef __bitwise
> +#  define __bitwise
> +# endif
>  #define __force
>  #endif
>  
> 

