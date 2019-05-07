Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39818 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfEGAMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 May 2019 20:12:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4709HPu150659
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:59 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2s94b0hrpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 00:11:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x470Axun054997
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2s94b961gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 00:11:58 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x470BvTe019025
        for <linux-xfs@vger.kernel.org>; Tue, 7 May 2019 00:11:57 GMT
Subject: Re: [PATCH 4/4] xfs_restore: support fallocate when reserving space
 for a file
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
 <155085406431.5141.9035398131483539445.stgit@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <55ae004d-9ba4-0a92-b3e5-b71e8182ed1f@oracle.com>
Date: Mon, 6 May 2019 17:11:56 -0700
MIME-Version: 1.0
In-Reply-To: <155085406431.5141.9035398131483539445.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 2/22/19 9:47 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Update the file creation helper to try fallocate when restoring a
> filesystem before it tries RESVSP.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   configure.ac          |    2 ++
>   include/builddefs.in  |    1 +
>   m4/Makefile           |    1 +
>   m4/package_libcdev.m4 |   15 +++++++++++++++
>   restore/Makefile      |    4 ++++
>   restore/dirattr.c     |   11 +++++++++++
>   6 files changed, 34 insertions(+)
>   create mode 100644 m4/package_libcdev.m4
> 
> 
> diff --git a/configure.ac b/configure.ac
> index a77054c..73dedd7 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -84,6 +84,8 @@ AC_PACKAGE_NEED_ATTRIBUTES_H
>   AC_PACKAGE_NEED_ATTRIBUTES_MACROS
>   AC_PACKAGE_NEED_ATTRGET_LIBATTR
>   
> +AC_HAVE_FALLOCATE
> +
>   AC_MANUAL_FORMAT
>   
>   AC_CONFIG_FILES([include/builddefs])
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 269c928..1c7e12f 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -69,6 +69,7 @@ ENABLE_SHARED	= @enable_shared@
>   ENABLE_GETTEXT	= @enable_gettext@
>   
>   HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
> +HAVE_FALLOCATE = @have_fallocate@
>   
>   GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
>   #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
> diff --git a/m4/Makefile b/m4/Makefile
> index 9a35056..ae452f7 100644
> --- a/m4/Makefile
> +++ b/m4/Makefile
> @@ -16,6 +16,7 @@ LSRCFILES = \
>   	manual_format.m4 \
>   	package_attrdev.m4 \
>   	package_globals.m4 \
> +	package_libcdev.m4 \
>   	package_ncurses.m4 \
>   	package_pthread.m4 \
>   	package_utilies.m4 \
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> new file mode 100644
> index 0000000..050f82c
> --- /dev/null
> +++ b/m4/package_libcdev.m4
> @@ -0,0 +1,15 @@
> +#
> +# Check if we have a fallocate libc call (Linux)
> +#
> +AC_DEFUN([AC_HAVE_FALLOCATE],
> +  [ AC_MSG_CHECKING([for fallocate])
> +    AC_TRY_LINK([
> +#include <fcntl.h>
> +#include <linux/falloc.h>
> +    ], [
> +         fallocate(0, 0, 0, 0);
> +    ], have_fallocate=yes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    AC_SUBST(have_fallocate)
> +  ])
> diff --git a/restore/Makefile b/restore/Makefile
> index 20c870a..ac3f8c8 100644
> --- a/restore/Makefile
> +++ b/restore/Makefile
> @@ -102,6 +102,10 @@ LTDEPENDENCIES = $(LIBRMT)
>   
>   LCFLAGS = -DRESTORE
>   
> +ifeq ($(HAVE_FALLOCATE),yes)
> +LCFLAGS += -DHAVE_FALLOCATE
> +endif
> +
>   default: depend $(LTCOMMAND)
>   
>   include $(BUILDRULES)
> diff --git a/restore/dirattr.c b/restore/dirattr.c
> index 3fa8fb6..82eb1de 100644
> --- a/restore/dirattr.c
> +++ b/restore/dirattr.c
> @@ -75,6 +75,17 @@ create_filled_file(
>   	if (fd < 0)
>   		return fd;
>   
> +#ifdef HAVE_FALLOCATE
> +	ret = fallocate(fd, 0, 0, size);
> +	if (ret && (errno != EOPNOTSUPP && errno != ENOTTY))
> +		mlog(MLOG_VERBOSE | MLOG_NOTE,
> +_("attempt to reserve %lld bytes for %s using %s failed: %s (%d)\n"),
> +				size, pathname, "fallocate",
> +				strerror(errno), errno);
> +	if (ret == 0)
> +		goto done;
This is the goto I referenced in patch 1.  Otherwise I think the rest is ok.

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> +#endif
> +
>   	ret = ioctl(fd, XFS_IOC_RESVSP64, &fl);
>   	if (ret && (errno != EOPNOTSUPP && errno != ENOTTY))
>   		mlog(MLOG_VERBOSE | MLOG_NOTE,
> 
