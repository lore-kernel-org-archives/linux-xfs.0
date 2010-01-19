Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9EXew179885 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:14:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 943D4173625
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:15:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bs6Q82SlAy2JOJLZ for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:15:33 -0800 (PST)
Date: Tue, 19 Jan 2010 04:15:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfsprogs: Do not remove configure information on clean
Message-ID: <20100119091531.GA29269@infradead.org>
References: <1263861186-13589-1-git-send-email-david@fromorbit.com>
	<1263861186-13589-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263861186-13589-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 19, 2010 at 11:33:05AM +1100, Dave Chinner wrote:
> ??ormal packaging practice is to remove the configure scripts
> on a 'make distclean' so that a 'make clean' doesn't result in
> having to rerun the configure scripts. Change the clean targets
> in the top level makefile to only clear configure files on
> a distclean.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 2d394e4..a7615ca 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -15,7 +15,7 @@ SRCTAR = $(PKG_NAME)-$(PKG_VERSION).tar.gz
>  CONFIGURE = aclocal.m4 configure config.guess config.sub install-sh ltmain.sh
>  LSRCFILES = configure.in release.sh README VERSION $(CONFIGURE)
>  
> -LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
> +DISTDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
>  	built .census install.* install-dev.* *.gz autom4te.cache/* libtool \
>  	include/builddefs include/platform_defs.h

But this isn't all configure stuff, is it?  install.* install-dev.* *.gz
is from the install process, and .dep is part of make dep.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
