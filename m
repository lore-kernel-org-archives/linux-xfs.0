Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VKwgMZ235568 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 15:58:42 -0500
Date: Wed, 31 Oct 2012 17:00:31 -0400 (EDT)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1066591451.20029469.1351717231452.JavaMail.root@redhat.com>
In-Reply-To: <20121031192545.662795881@sgi.com>
Subject: Re: [patch 1/4] xfstests: update version and changelog
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

They all look good to me, thanks Ben.  One minor thought,
for future updates...

----- Original Message -----
> ...
> Index: b/VERSION
> ===================================================================
> --- a/VERSION	2012-10-31 13:44:44.931946786 -0500
> +++ b/VERSION	2012-10-31 13:44:50.832006406 -0500
> @@ -3,5 +3,5 @@
>  #
>  PKG_MAJOR=1
>  PKG_MINOR=1
> -PKG_REVISION=0
> +PKG_REVISION=1
>  PKG_BUILD=1
> Index: b/configure.ac
> ===================================================================
> --- a/configure.ac	2012-10-31 13:45:41.661946816 -0500
> +++ b/configure.ac	2012-10-31 13:45:48.072005921 -0500
> @@ -1,4 +1,4 @@
> -AC_INIT([xfstests], [1.1.0])
> +AC_INIT([xfstests], [1.1.1])
>  AC_PREREQ(2.50)
>  AC_CONFIG_SRCDIR([src/xfsctl.c])
>  AC_PACKAGE_GLOBALS(xfstests)

I wonder if generating the VERSION file from configure makes
sense, since we are duplicating that info nowadays?

Oh, feel free to add Reviewed-by me for all of these patches,
if you like.

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
