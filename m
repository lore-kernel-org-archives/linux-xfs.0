Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p43J077m025780 for <xfs@oss.sgi.com>; Tue, 3 May 2011 14:00:07 -0500
Received: from e33.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 628EA1E1AB1B
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 12:03:44 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id 68DzVyryQ7F7zj3R for
	<xfs@oss.sgi.com>; Tue, 03 May 2011 12:03:44 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p43IudC9007426
	for <xfs@oss.sgi.com>; Tue, 3 May 2011 12:56:39 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p43J3XFj138868 for <xfs@oss.sgi.com>; Tue, 3 May 2011 13:03:36 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p43J3DhM008646
	for <xfs@oss.sgi.com>; Tue, 3 May 2011 13:03:13 -0600
Message-ID: <4DC0516F.2040108@linux.vnet.ibm.com>
Date: Tue, 03 May 2011 12:03:11 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: clean up fallocate configuration tests
References: <4DBF492E.3040400@sandeen.net>
In-Reply-To: <4DBF492E.3040400@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 5/2/2011 5:15 PM, Eric Sandeen wrote:
> When I added fallocate support to fsx I inadvertently added
> a duplicate fallocate test.
>
> Consolidate them both into one test (the link test, not the
> compile test) and make all tests use "true" rather than "yes"
> to be more consistent with other tests.
>
> Signed-off-by: Eric Sandeen<sandeen@sandeen.net>
> ---
>
> diff --git a/aclocal.m4 b/aclocal.m4
> index 70ea0f3..168eb59 100644
> --- a/aclocal.m4
> +++ b/aclocal.m4
> @@ -18,27 +18,14 @@ AC_DEFUN([AC_PACKAGE_WANT_LINUX_FIEMAP_H],
>
>   AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
>     [ AC_MSG_CHECKING([for fallocate])
> -    AC_TRY_COMPILE([
> -#include<linux/falloc.h>
> -    ], [
> -         fallocate(0, 0, 0, 0);
> -    ], have_fallocate=true
> -       AC_MSG_RESULT(true),
> -       AC_MSG_RESULT(false))
> -    AC_SUBST(have_fallocate)
> -  ])
> -AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
> -  [ AC_MSG_CHECKING([for fallocate])
>       AC_TRY_LINK([
>   #define _GNU_SOURCE
>   #define _FILE_OFFSET_BITS 64
>   #include<fcntl.h>
> -#include<linux/falloc.h>
> -    ], [
> -         fallocate(0, 0, 0, 0);
> -    ], have_fallocate=yes
> -       AC_MSG_RESULT(yes),
> -       AC_MSG_RESULT(no))
> +#include<linux/falloc.h>  ],
> +      [ fallocate(0, 0, 0, 0); ],
> +      [ have_fallocate=true; AC_MSG_RESULT(yes) ],
> +      [ have_fallocate=false; AC_MSG_RESULT(no) ])
>       AC_SUBST(have_fallocate)
>     ])
>   m4_include([m4/multilib.m4])
> diff --git a/src/Makefile b/src/Makefile
> index 1162ee0..91088bf 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -31,7 +31,7 @@ ifeq ($(HAVE_FIEMAP), true)
>   LINUX_TARGETS += fiemap-tester
>   endif
>
> -ifeq ($(HAVE_FALLOCATE),yes)
> +ifeq ($(HAVE_FALLOCATE), true)
>   LCFLAGS += -DHAVE_FALLOCATE
>   endif
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Thanks Eric,

I tried it out and it looks like it works great.  I will back out the 
changes to the Makefile in my fsx patch.

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
