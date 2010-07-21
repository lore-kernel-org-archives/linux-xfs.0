Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LIUOWV092173 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 13:30:24 -0500
Subject: Re: xfsprogs: only absolute run-paths are allowed
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100721171319.GA17772@infradead.org>
References: <alpine.DEB.2.01.1007210408390.3964@bogon.housecafe.de>
	<20100721171319.GA17772@infradead.org>
Date: Wed, 21 Jul 2010 13:33:22 -0500
Message-ID: <1279737202.1816.16.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, 2010-07-21 at 13:13 -0400, Christoph Hellwig wrote:
> On Wed, Jul 21, 2010 at 04:31:01AM -0700, Christian Kujau wrote:
> > Hi,
> > 
> > I noticed that I can't use --prefix= any more for the ./configure script. 
> > Doing so makes libtool unhappy:
> > 
> > $ make configure
> > $ ./configure --prefix=/opt/xfsprogs
> > $ make
> > [...]
> > libtool: link: only absolute run-paths are allowed
> > make[2]: *** [libxfs.la] Error 1
> 
> The patch below should fix this issue.  Note that you need to do a
> 
> 	make realclean
> 	make configure
> 
> to regenerate the configure script first.

This looks OK to me.  Once you get confirmation
it works for Christian you can re-format your
description and commit it.  (I didn't see the
problem in my environment for some reason.)

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfsprogs-dev/configure.in
> ===================================================================
> --- xfsprogs-dev.orig/configure.in	2010-07-21 19:03:45.225494681 +0200
> +++ xfsprogs-dev/configure.in	2010-07-21 19:06:19.649494682 +0200
> @@ -65,12 +65,17 @@ esac
>  case $exec_prefix:$prefix in
>  NONE:NONE | NONE:/usr | /usr:*)
>    root_sbindir='/sbin'
> -  AC_SUBST([root_sbindir])
> -
>    root_libdir="/${base_libdir}"
> -  AC_SUBST([root_libdir])
> +  ;;
> +*)
> +  root_sbindir="${sbindir}"
> +  root_libdir="${libdir}"
> +  ;;
>  esac
>  
> +AC_SUBST([root_sbindir])
> +AC_SUBST([root_libdir])
> +
>  # Find localized files
>  LOCALIZED_FILES=""
>  for lfile in `find ${srcdir} -name '*.c' -type f || exit 1`; do
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
