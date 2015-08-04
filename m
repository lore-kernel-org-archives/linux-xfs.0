Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 294247FB1
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 17:58:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB8C6AC001
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 15:58:36 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4PVGBtRNDvdweNDc for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 15:58:32 -0700 (PDT)
Date: Wed, 5 Aug 2015 08:58:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug#793495: xfsprogs fails to build on debian ppc64el
Message-ID: <20150804225819.GV16638@dastard>
References: <55BB9271.6000300@gmx.net> <55BBEF4F.6070809@linux.vnet.ibm.com>
	<20150801225230.GR16638@dastard>
	<41BF7556-AAAB-4F22-B8C2-8991A0917DE2@gmx.net>
	<20150802221301.GO3902@dastard>
	<55C0D916.1010102@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55C0D916.1010102@linux.vnet.ibm.com>
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
To: Fernando Seiti Furusato <ferseiti@linux.vnet.ibm.com>
Cc: xfs@oss.sgi.com, 793495@bugs.debian.org, Breno Leitao <brenohl@br.ibm.com>, Daniel Bast <daniel.bast@gmx.net>

On Tue, Aug 04, 2015 at 12:24:06PM -0300, Fernando Seiti Furusato wrote:
> Hi Dave.
> 
> I have just noticed that for config.guess and config.sub to be updated, no
> autoreconf or dh_autotools-dev is needed, because of how Makefile was made.
> 
> In Makefile, @row 80:
> 
>  LIBTOOLIZE_INSTALL = `libtoolize -n -i >/dev/null 2>/dev/null && echo -i`
> 
>  configure:
>          libtoolize -c $(LIBTOOLIZE_INSTALL) -f
>          cp include/install-sh .
>          aclocal -I m4
>          autoconf
> 
> This runs libtoolize -c -i which updates those files.
> 
> The file debian/rules runs `make default`, which at some point calls the target
> above (`make configure`). But the file configure already exists, so it does not
> run.

Right. Intentionally so.

....

> diff -Nru xfsprogs-3.2.4/Makefile xfsprogs-3.2.4ppc64el1/Makefile
> --- xfsprogs-3.2.4/Makefile	2013-10-10 17:07:16.000000000 -0400
> +++ xfsprogs-3.2.4ppc64el1/Makefile	2015-08-04 11:06:40.000000000 -0400
> @@ -116,7 +116,7 @@
>  	$(Q)$(MAKE) $(MAKEOPTS) -C $* install-qa
>  
>  distclean: clean
> -	$(Q)rm -f $(LDIRT)
> +	$(Q)rm -f $(LDIRT) $(CONFIGURE)
>  
>  realclean: distclean
>  	$(Q)rm -f $(CONFIGURE) .gitcensus

That makes distclean do the same thing that realclean does and, as
that commit I pointed out previously, has been intentionally
separated in the build system. You could make the debian/rules file
simply call 'make realclean' rather than 'make distclean' to acheive
this without changing the main makefile. Either way, however, I
don't think that's the problem.

Darrick Wong noted on #xfs that his builds of xfsprogs on ppc64el
from a tarball don't fail at all. His libtool chain is:

>       host-triplet:     powerpc64le-unknown-linux-gnu
>       libtoolize:       (GNU libtool) 2.4.2 Debian-2.4.2-1.7ubuntu1
>       automake:         automake (GNU automake) 1.14.1
>       autoconf:         autoconf (GNU Autoconf) 2.69

Which is similar to mine, but libtoolize is slightly older (and I'm
on x86_64-pc-linux-gnu). It turns out that the reason the build
works on his machines is that someone had made a small manual change
to /usr/share/aclocal/libtool.m4:

--- a/libtool.m4       2014-02-11 04:58:49.000000000 -0800
+++ b/libtool.m4  2015-07-31 13:48:23.375432372 -0700
@@ -1312,7 +1312,7 @@
   rm -rf conftest*
   ;;

-x86_64-*kfreebsd*-gnu|x86_64-*linux*|powerpc*-*linux*| \
+x86_64-*kfreebsd*-gnu|x86_64-*linux*|ppc*-*linux*|powerpc*-*linux*| \
 s390*-*linux*|s390*-*tpf*|sparc*-*linux*)
   # Find out which ABI we are using.
   echo 'int i;' > conftest.$ac_ext

i.e. the problem looks to be that the libtool package shipped in
debian/unstable does not support ppc64el correctly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
