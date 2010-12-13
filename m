Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBDGI42q219134 for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 10:18:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ECA4D143FC59
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 08:19:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uY3KqALAYRz90O2J for
	<xfs@oss.sgi.com>; Mon, 13 Dec 2010 08:19:56 -0800 (PST)
Date: Mon, 13 Dec 2010 11:19:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: pwrite hang when writing from mmaped buffer of
	the same page
Message-ID: <20101213161954.GA23509@infradead.org>
References: <1292225083-17713-1-git-send-email-xin.zhong@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292225083-17713-1-git-send-email-xin.zhong@intel.com>
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
To: "Zhong, Xin" <xin.zhong@intel.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 13, 2010 at 03:24:43PM +0800, Zhong, Xin wrote:
> The problem is found in meego testing:
> http://bugs.meego.com/show_bug.cgi?id=6672
> Only btrfs has this problem so far. Other linux fs works well.

Thanks, the patch pretty good.  A few think I'd like to improved,
though:

> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +
> +TESTFILE=$TEST_DIR/test_file
> +TEST_PROG=$here/src/pwrite_mmap_blocked
> +
> +$TEST_PROG $TESTFILE

Please remove the test file after the test completed.  This is best done
in the cleanup function, as it's called both for sucessfull and error
exits.

> +QA output created by 248
> +pwrite 1 bytes from 2 to 3
> diff --git a/group b/group
> index 0f94dd9..0b4f514 100644
> --- a/group
> +++ b/group
> @@ -361,3 +361,4 @@ deprecated
>  245 auto quick dir
>  246 auto quick rw
>  247 auto quick rw
> +248 other

The test should also be part of the quick and rw groups.

> diff --git a/src/pwrite_mmap_blocked.c b/src/pwrite_mmap_blocked.c
> new file mode 100644
> index 0000000..40d7f7b
> --- /dev/null
> +++ b/src/pwrite_mmap_blocked.c
> @@ -0,0 +1,63 @@
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <time.h>
> +#include <sys/mman.h>
> +#include <sys/signal.h>
> +#include <sys/stat.h>

Please add a license header to the program, preferably GPLv2 or GPLv2 or
later.

> +
> +char *progname;
> +loff_t size;
> +int fd;
> +char *filename="./test_file";

The program is actually using the file name passed as the first
argument, and you're only using this variable for the error message,
please just remove it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
