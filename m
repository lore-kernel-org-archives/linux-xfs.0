Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3K4trU1000877 for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 23:55:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 611DE2D65E7
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 21:57:51 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	u5JOM5gHqjYZcUBv for <xfs@oss.sgi.com>;
	Mon, 19 Apr 2010 21:57:51 -0700 (PDT)
Date: Tue, 20 Apr 2010 14:57:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix compile issue with gdbm and
	--enable-lib64 warnnings
Message-ID: <20100420045748.GC15130@dastard>
References: <1270784882-8130-1-git-send-email-wezhang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270784882-8130-1-git-send-email-wezhang@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Wenming Zhang <wezhang@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 09, 2010 at 11:48:02AM +0800, Wenming Zhang wrote:
> fix couldn't be compiled with gdbm lib issue
> and clear warnings while configure with  --enable-lib64 
> 
> Signed-off-by: Wenming Zhang <wezhang@redhat.com>
> ---
>  configure.in |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/configure.in b/configure.in
> index 45b7fd1..92e2711 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -10,6 +10,7 @@ AC_HEADER_STDC
>  			errno.h			\
>  			malloc.h		\
>  			uuid.h			\
> +			gdbm.h			\
>  			uuid/uuid.h		\
>  			sys/uuid.h		\
>  			sys/file.h		\

I'm not sure why this is needed - we don't directly include gdbm.h.
We check for gdbm/ndbm.h (or gdbm-ndbm.h on debian in a a patch
I have), the presence of which implies that gdbm.h exists on the
system.

Even if it is necessary to check for this, the check needs to go
into the GDBM package checks (m4/package_gdbmdev.m4) to
enable/disable the have_db variable so that it simply isn't used if
it is not present.


> @@ -44,6 +45,12 @@ in
>  		;;
>  	*)
>  		AC_MULTILIB($enable_lib64)
> +		AC_ARG_ENABLE([lib64], [AS_HELP_STRING([--enable-lib64],
> +                			[enable lib64 support (default is no)])],
> +				[enable_lib64=$withval],
> +				[enable_lib64=no]
> +		)
> +

I don't think this is right - yes, it will suppress the warning,
but I don't think it works correctly. The argument needs to be enabled
and evaluated before it is used, and IIRC the AC_ARG_ENABLE result
is put into $enableval not $withval.

So shouldn't it be something like this (untested):

		AC_ARG_ENABLE(lib64,
			AS_HELP_STRING([--enable-lib64],
				[enable lib64 support (default=no)]
			enable_lib64=$enableval,
			enable_lib64=no)
		AC_SUBST(enable_lib64)
		AC_MULTILIB($enable_lib64)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
