Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DAE907F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 22:32:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65523AC00F
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 20:32:35 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Lg64gh8mxJfER4rB for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 20:32:32 -0700 (PDT)
Date: Wed, 23 Sep 2015 13:32:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/14] xfsprogs: Add statvfs64 for osx
Message-ID: <20150923033218.GP3902@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-12-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1442311164-12921-12-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 15, 2015 at 11:59:21AM +0200, Jan Tulak wrote:
> Simply rename statvfs64 to statfs with a #define.
> OSX version of statvfs is missing some members, so if the renaming
> is in effect (stavfs64 is defined), don't try to use them and go
> directly for the other member value.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  fsr/xfs_fsr.c        | 14 ++++++++++++++
>  include/builddefs.in |  2 +-
>  include/darwin.h     |  5 +++++
>  3 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index e1b7bd6..5f95cdc 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -36,6 +36,12 @@
>  #  include <mntent.h>
>  #endif
>  
> +#ifdef __APPLE__
> +//#  define statvfs64 statfs;
> +#  include <sys/param.h>
> +#  include <sys/mount.h>
> +#endif

Why is this here? We've included libxfs.h in this file, so we've
got access to the platform specific includes already, and later in
the patch you put the commented out define there...

> +
>  #ifndef XFS_XFLAG_NODEFRAG
>  #define XFS_XFLAG_NODEFRAG 0x00002000 /* src dependancy, remove later */
>  #endif
> @@ -948,7 +954,11 @@ fsrfile_common(
>  			fname, strerror(errno));
>  		return -1;
>  	}
> +#ifndef statvfs64
>  	bsize = vfss.f_frsize ? vfss.f_frsize : vfss.f_bsize;
> +#else
> +	bsize = vfss.f_bsize;
> +#endif

	bsize = platform_statvfs_bsize(&vfss);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
