Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F04F7F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 07:00:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 357338F8035
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 05:00:44 -0700 (PDT)
Received: from mail-qc0-f172.google.com (mail-qc0-f172.google.com
	[209.85.216.172]) by cuda.sgi.com with ESMTP id
	5RZKx8SGE8ajtks2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 05:00:43 -0700 (PDT)
Received: by mail-qc0-f172.google.com with SMTP id l6so239046qcy.31
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 05:00:43 -0700 (PDT)
Date: Tue, 13 May 2014 08:00:39 -0400
From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [PATCH] loggen: fix build vs. newer xfsprogs headers
Message-ID: <20140513080039.239b0ad9@tlielax.poochiereds.net>
In-Reply-To: <1399982043-8693-1-git-send-email-jlayton@poochiereds.net>
References: <20140512230049.GO26353@dastard>
	<1399982043-8693-1-git-send-email-jlayton@poochiereds.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Tue, 13 May 2014 07:54:03 -0400
Jeff Layton <jlayton@poochiereds.net> wrote:

> commit cc085d770adb in xfsprogs removed some header files that are
> included by loggen.c. Add an autoconf test that checks to see whether
> xfs_log_format.h is present. If it is, include that instead of the
> deprecated headers and add an alias for XFS_TRANS_MAGIC since that
> value no longer exists.
> 
> W.ith this patch, xfstests builds on both f20 and rawhide (f21) boxes.
> 
> Signed-off-by: Jeff Layton <jlayton@poochiereds.net>
> ---
>  configure.ac | 9 ++++++---
>  src/loggen.c | 7 +++++++
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 43e6029193a6..e4680544ac82 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -26,14 +26,17 @@ AC_HEADER_STDC
>  			sys/types.h		\
>  			strings.h		\
>  			err.h			\
> -			linux/falloc.h
> -    ])
> -    AC_CHECK_HEADERS([	sys/fs/xfs_fsops.h	\
> +			linux/falloc.h		\
> +			sys/fs/xfs_fsops.h	\
>  			sys/fs/xfs_itable.h	\
>  			xfs/platform_defs.h	\
>  			btrfs/ioctl.h		\
>      ])
>  
> +AC_CHECK_HEADERS([xfs/xfs_log_format.h],,,[#include <xfs/platform_defs.h>
> +#include <xfs/xfs_types.h>
> +#include <xfs/xfs_fs.h>])
> +


Hmm now that I look closer, loggen.c just includes xfs/libxfs.h in
order to pull in all of the necessary includes. I guess we should do
that here instead of including these headers individually...

I'll respin and resend.

>  AC_PACKAGE_NEED_UUIDCOMPARE
>  
>  case $pkg_platform
> diff --git a/src/loggen.c b/src/loggen.c
> index 522c9178ee26..a3d99f8c915f 100644
> --- a/src/loggen.c
> +++ b/src/loggen.c
> @@ -25,9 +25,16 @@
>   *                                                  - dxm 29/09/00
>   */
>  
> +#include <config.h>
> +
>  #include <xfs/libxfs.h>
> +#ifdef HAVE_XFS_XFS_LOG_FORMAT_H
> +#include <xfs/xfs_log_format.h>
> +#define XFS_TRANS_MAGIC	XFS_TRANS_HEADER_MAGIC
> +#else /* HAVE_XFS_XFS_LOG_FORMAT_H */
>  #include <xfs/xfs_log.h>
>  #include <xfs/xfs_log_priv.h>
> +#endif /* HAVE_XFS_XFS_LOG_FORMAT_H */
>  
>  #ifndef ASSIGN_ANY_LSN_DISK
>  #define ASSIGN_ANY_LSN_DISK(lsn,cycle,block)  \


-- 
Jeff Layton <jlayton@poochiereds.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
