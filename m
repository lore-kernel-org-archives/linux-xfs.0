Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF93C29E23
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 16:48:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A35C6304043
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 14:48:49 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	uZB3VtVUl1VVtZsB for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 14:48:48 -0800 (PST)
Date: Thu, 7 Nov 2013 09:48:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsdump: don't assume getdents exists
Message-ID: <20131106224844.GI6188@dastard>
References: <20131106213635.GC24712@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131106213635.GC24712@redacted.bos.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Kyle McMartin <kyle@redhat.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Wed, Nov 06, 2013 at 04:36:35PM -0500, Kyle McMartin wrote:
> New Linux ports are using a standard syscall list that does not include
> deprecated syscalls where 64-bit clean alternatives exist. As a result,
> on arm64, __NR_getdents is undefined, resulting in xfsdump failing to
> build.
> 
> To avoid that, in the case where __NR_getdents is unset in unistd.h,
> avoid building the fallback path entirely, since
> __ASSUME_GETDENTS64_SYSCALL will be true, the SYS_getdents64 case will
> be the primary (and only) path used.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> --- a/common/getdents.c
> +++ b/common/getdents.c

Oh, how that code makes my eyes bleed. :/

> @@ -70,6 +70,9 @@ extern int __have_no_getdents64;
>  # ifndef SYS_getdents64
>  #  define SYS_getdents64 __NR_getdents64
>  # endif
> +# ifndef __NR_getdents
> +#  define __ONLY_GETDENTS64_SYSCALL     1
> +# endif
>  #endif
>  
>  
> @@ -207,6 +210,13 @@ getdents_wrap (int fd, char *buf, size_t nbytes)
>  # endif
>      }
>  #endif
> +/* Newer Linux ports are not adding deprecated syscalls, so to avoid compile
> + * failures since SYS_getdents will be undefined, we check for that and only
> + * build the fall-back case if SYS_getdents is defined. We know that
> + * __ASSUME_GETDENTS64_SYSCALL is set, since __NR_getdents64 must exist on
> + * those platforms.
> + */
> +#ifndef __ONLY_GETDENTS64_SYSCALL
>    {
>      size_t red_nbytes;
>      struct kernel_dirent *skdp, *kdp;
> @@ -265,4 +275,5 @@ getdents_wrap (int fd, char *buf, size_t nbytes)
>      }
>  
>    return (char *) dp - buf;
> +#endif
>  }

It's not pretty - but that code has already broken the ugly stick so
it isn't making the situation any worse.

Acked-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
