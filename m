Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56724 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752512AbdDHPIQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 8 Apr 2017 11:08:16 -0400
Date: Sat, 8 Apr 2017 23:08:12 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/4] xfstests: Add first statx test [ver #10]
Message-ID: <20170408150812.GX22845@eguan.usersys.redhat.com>
References: <149146774821.12770.3592235770964461857.stgit@warthog.procyon.org.uk>
 <149146775556.12770.11943651470996193921.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149146775556.12770.11943651470996193921.stgit@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Apr 06, 2017 at 09:35:55AM +0100, David Howells wrote:
...
> diff --git a/src/statx.h b/src/statx.h
> new file mode 100644
> index 0000000..711d1ba
> --- /dev/null
> +++ b/src/statx.h
> @@ -0,0 +1,166 @@
> +#ifndef STATX_H
> +#define STATX_H
> +
> +#include <unistd.h>
> +#include <linux/types.h>
> +
> +#ifndef AT_STATX_SYNC_TYPE
> +#define AT_STATX_SYNC_TYPE      0x6000  /* Type of synchronisation required from statx() */
> +#define AT_STATX_SYNC_AS_STAT   0x0000  /* - Do whatever stat() does */
> +#define AT_STATX_FORCE_SYNC     0x2000  /* - Force the attributes to be sync'd with the server */
> +#define AT_STATX_DONT_SYNC      0x4000  /* - Don't sync attributes with the server */
> +#endif
> +
> +#ifndef AT_NO_AUTOMOUNT
> +#define AT_NO_AUTOMOUNT		0x800	/* Suppress terminal automount traversal */
> +#endif
> +
> +#ifdef __i386__
> +#define __NR_statx 383
> +#elif defined (__ILP32__)
> +#define __NR_statx (__X32_SYSCALL_BIT + 332)
> +#else
> +#define __NR_statx 332
> +#endif

I gave it more tests today on ppc64 host, and test failed as

 QA output created by 422
 Test statx on a fifo
+/mnt/xfstests/mnt1/422-fifo: Bad file descriptor
+stat_test failed
 Test statx on a chardev
...

and strace showed it was calling into getpeername(2) (AT_FDCWD == -100)

getpeername(-100, 0x3fffd498f491, 0x100) = -1 EBADF (Bad file descriptor)

Perhaps we should add a new autoconf rule in configure.ac and define
HAVE_STATX if there's statx support, like what src/renameat2.c does?

Thanks,
Eryu
