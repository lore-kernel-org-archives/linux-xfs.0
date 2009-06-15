Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5FKBqiW123668 for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 15:11:53 -0500
Subject: Re: xfs_io: fix test for fallocate on 32bit boxes
References: <4A36A448.4060406@sandeen.net>
From: Olaf Weber <olaf@sgi.com>
Date: Mon, 15 Jun 2009 22:12:13 +0200
In-Reply-To: <4A36A448.4060406@sandeen.net> (Eric Sandeen's message of "Mon,
	15 Jun 2009 14:43:04 -0500")
Message-ID: <bzyocspdzoi.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Looks good.


Reviewed-by: Olaf Weber <olaf@sgi.com>



Eric Sandeen writes:

> xfs_io: fix test for fallocate on 32bit boxes
> As per Red Hat bug 500487, fallocate64 is missing in glibc,
> so attempts to build with fallocate and _FILE_OFFSET_BITS=64
> will fail.

> So, change the config to test the way we will build, and
> it'll fail properly on x86 until glibc gets fixed.

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index 1ac4666..1c1859d 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -105,6 +105,9 @@ AC_DEFUN([AC_HAVE_GETMNTINFO],
>  AC_DEFUN([AC_HAVE_FALLOCATE],
>    [ AC_MSG_CHECKING([for fallocate])
>      AC_TRY_LINK([
> +#define _GNU_SOURCE
> +#define _FILE_OFFSET_BITS 64
> +#include <fcntl.h>
>  #include <linux/falloc.h>
>      ], [
>           fallocate(0, 0, 0, 0);


> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
