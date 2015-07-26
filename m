Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E5AF87F9D
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 11:34:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB3B18F8035
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 09:34:39 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id hJ4y0kGDyUgH3Uv2 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 09:34:38 -0700 (PDT)
Date: Sun, 26 Jul 2015 09:34:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/4] xfsprogs: OS X partial support
Message-ID: <20150726163438.GD16659@infradead.org>
References: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
	<1437397018-12864-5-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1437397018-12864-5-git-send-email-jtulak@redhat.com>
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

I think this needs to be split into one patch per issue.  A few comments
below:

> -#include <malloc.h>


malloc and friends need to be in stdlib.h per Posix, so the right
fix is to drop every include of malloc.h and mae sure we include
stdlib.h where needed.

> -#include <mntent.h>
>  #include <syslog.h>
>  #include <signal.h>
>  #include <sys/ioctl.h>
>  #include <sys/wait.h>
> -#include <sys/vfs.h>

sys/vfs.h is jsut an alias for sys/stafs.h, ut given that
this file doesn't even use statfs we can simply drop the include
unconditionally.

> +#ifndef PLATFORM_HAS_NO_MNTENT_H
> +#  include <mntent.h>
> +#endif

Why aren't you using the standard autoconf-generate include checks?

> +#ifdef _DIRENT_HAVE_D_RECLEN
>  		*total += dirent->d_reclen;
> +#endif
>  		count++;
>  
>  		if (dump) {
>  			dump_dirent(offset, dirent);
> +#ifdef _DIRENT_HAVE_D_OFF
>  			offset = dirent->d_off;
> +#endif

I'm pretty sure autoconf has a standard macro for this, try looking it
up in the autoconf manual.

> diff --git a/libxcmd/paths.c b/libxcmd/paths.c
> index c0b1ddb..b360617 100644
> --- a/libxcmd/paths.c
> +++ b/libxcmd/paths.c
> @@ -364,7 +364,7 @@ fs_table_initialise_mounts(
>  			continue;
>  		if (!realpath(stats[i].f_mntfromname, rmntfromname))
>  			continue;
> -		if (!realpath(stats[i].f_mntonname, rmnttomname)))
> +		if (!realpath(stats[i].f_mntonname, rmntonname))

I don't understand this change.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
