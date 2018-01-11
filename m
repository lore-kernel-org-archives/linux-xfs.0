Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35000 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752747AbeAKX1z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 18:27:55 -0500
Subject: Re: [PATCH 25/27] xfs_scrub: progress indicator
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520364805.2027.13223468870890083511.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4e784dc2-f24e-bd9d-f0c4-c0997a7ad793@sandeen.net>
Date: Thu, 11 Jan 2018 17:27:54 -0600
MIME-Version: 1.0
In-Reply-To: <151520364805.2027.13223468870890083511.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/5/18 7:54 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>


> +#define NSEC_PER_SEC	(1000000000)
> +static void *
> +progress_report_thread(void *arg)
> +{
> +	struct timespec		abstime;
> +	int			ret;
> +
> +	pthread_mutex_lock(&pt.lock);
> +	while (1) {
> +		/* Every half second. */
> +		ret = clock_gettime(CLOCK_REALTIME, &abstime);


My manpage says "link with -rt" and to include <time.h>, this got me
going:

diff --git a/scrub/Makefile b/scrub/Makefile
index 3e6f690..0094d9d 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -67,7 +67,7 @@ xfs_scrub.c
 
 LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUNISTRING)
 LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG) $(LIBUNISTRING)
-LLDFLAGS = -static
+LLDFLAGS = -static -lrt
 
 ifeq ($(HAVE_MALLINFO),yes)
 LCFLAGS += -DHAVE_MALLINFO
diff --git a/scrub/progress.c b/scrub/progress.c
index 30b2152..61b9c60 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -22,6 +22,7 @@
 #include <dirent.h>
 #include <pthread.h>
 #include <sys/statvfs.h>
+#include <time.h>
 #include "../repair/threads.h"
 #include "path.h"
 #include "disk.h"

