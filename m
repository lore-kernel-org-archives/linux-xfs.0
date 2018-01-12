Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36634 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753186AbeALAci (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 19:32:38 -0500
Date: Thu, 11 Jan 2018 16:32:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 25/27] xfs_scrub: progress indicator
Message-ID: <20180112003232.GO5602@magnolia>
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520364805.2027.13223468870890083511.stgit@magnolia>
 <4e784dc2-f24e-bd9d-f0c4-c0997a7ad793@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e784dc2-f24e-bd9d-f0c4-c0997a7ad793@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 05:27:54PM -0600, Eric Sandeen wrote:
> On 1/5/18 7:54 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> 
> > +#define NSEC_PER_SEC	(1000000000)
> > +static void *
> > +progress_report_thread(void *arg)
> > +{
> > +	struct timespec		abstime;
> > +	int			ret;
> > +
> > +	pthread_mutex_lock(&pt.lock);
> > +	while (1) {
> > +		/* Every half second. */
> > +		ret = clock_gettime(CLOCK_REALTIME, &abstime);
> 
> 
> My manpage says "link with -rt" and to include <time.h>, this got me
> going:
> 
> diff --git a/scrub/Makefile b/scrub/Makefile
> index 3e6f690..0094d9d 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -67,7 +67,7 @@ xfs_scrub.c
>  
>  LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUNISTRING)
>  LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG) $(LIBUNISTRING)
> -LLDFLAGS = -static
> +LLDFLAGS = -static -lrt

I added $(LIBRT) to the end of LLDLIBS/LTDEPENDENCIES since we already
defined it elsewhere in the autoconf goo for benefit of the other
programs.

>  
>  ifeq ($(HAVE_MALLINFO),yes)
>  LCFLAGS += -DHAVE_MALLINFO
> diff --git a/scrub/progress.c b/scrub/progress.c
> index 30b2152..61b9c60 100644
> --- a/scrub/progress.c
> +++ b/scrub/progress.c
> @@ -22,6 +22,7 @@
>  #include <dirent.h>
>  #include <pthread.h>
>  #include <sys/statvfs.h>
> +#include <time.h>

Fixed.

--D

>  #include "../repair/threads.h"
>  #include "path.h"
>  #include "disk.h"
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
