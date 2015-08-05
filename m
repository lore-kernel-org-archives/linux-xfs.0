Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF0E27FAE
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 08:47:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B67EAC004
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 06:47:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7KJDOXY1G029shfu for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 06:47:43 -0700 (PDT)
Date: Wed, 5 Aug 2015 23:47:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug#793495: xfsprogs fails to build on debian ppc64el
Message-ID: <20150805134729.GX16638@dastard>
References: <55BB9271.6000300@gmx.net> <55BBEF4F.6070809@linux.vnet.ibm.com>
	<20150801225230.GR16638@dastard>
	<41BF7556-AAAB-4F22-B8C2-8991A0917DE2@gmx.net>
	<20150802221301.GO3902@dastard>
	<55C0D916.1010102@linux.vnet.ibm.com>
	<20150804225819.GV16638@dastard>
	<55C208D2.4060907@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55C208D2.4060907@linux.vnet.ibm.com>
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

On Wed, Aug 05, 2015 at 10:00:02AM -0300, Fernando Seiti Furusato wrote:
> On 08/04/2015 07:58 PM, Dave Chinner wrote:
> 
> >That makes distclean do the same thing that realclean does and, as
> >that commit I pointed out previously, has been intentionally
> >separated in the build system. You could make the debian/rules file
> >simply call 'make realclean' rather than 'make distclean' to acheive
> >this without changing the main makefile. Either way, however, I
> >don't think that's the problem.
> Yes, except I tried changing debian/rules to use realclean before coming up
> with that idea and it broke the build.
> 
>  make[1]: Entering directory '/home/xfsprogs/xfsprogs-3.2.4'
>  ./configure $LOCAL_CONFIGURE_OPTIONS
>  configure: error: cannot find install-sh, install.sh, or shtool in . "."/.
>  Makefile:89: recipe for target 'include/builddefs' failed
>  make[1]: *** [include/builddefs] Error 1
>  make[1]: Leaving directory '/home/xfsprogs/xfsprogs-3.2.4'
>  debian/rules:36: recipe for target '.census' failed
>  make: *** [.census] Error 2

make realclean also removes the .census file, so it appears that
the debian package build has a dependency on it. Still, that's a
side issue, because we still don't exactly what is causing the
configure script to fail.

> >Darrick Wong noted on #xfs that his builds of xfsprogs on ppc64el
> >from a tarball don't fail at all. His libtool chain is:
> When I build xfsprog on ppc64el from a tarball, it does not fail at all either.
> But in my case, specifically, it is because the tarball does not come with
> a configure file (which would solve the problem I pointed out), so Makefile
> generates it and runs libtoolize -c -i which updates the configuration files
> needed.

You seem to be talking about 2 different tarballs here.  The
tarballs I release most definitely have a configure script in them:

$ tar tfv xfsprogs-4.2.0-rc1.tar.gz |grep configure
-rw-r--r-- dave/dave      3098 2015-08-04 11:16 xfsprogs-4.2.0-rc1/configure.ac
-rwxr-xr-x dave/dave    469084 2015-08-04 14:25 xfsprogs-4.2.0-rc1/configure

So I don't know where you are getting xfsprogs tarballs without
configure scripts from.

To clear up any confusion, can you please explain exactly what you
are building (step by step for the dummies in the audience like me)
so we all understand exactly what context the build is failing in?

> >>       host-triplet:     powerpc64le-unknown-linux-gnu
> >>       libtoolize:       (GNU libtool) 2.4.2 Debian-2.4.2-1.7ubuntu1
> >>       automake:         automake (GNU automake) 1.14.1
> >>       autoconf:         autoconf (GNU Autoconf) 2.69
> >
> >Which is similar to mine, but libtoolize is slightly older (and I'm
> >on x86_64-pc-linux-gnu). It turns out that the reason the build
> >works on his machines is that someone had made a small manual change
> >to /usr/share/aclocal/libtool.m4:
> >
> >--- a/libtool.m4       2014-02-11 04:58:49.000000000 -0800
> >+++ b/libtool.m4  2015-07-31 13:48:23.375432372 -0700
> >@@ -1312,7 +1312,7 @@
> >    rm -rf conftest*
> >    ;;
> >
> >-x86_64-*kfreebsd*-gnu|x86_64-*linux*|powerpc*-*linux*| \
> >+x86_64-*kfreebsd*-gnu|x86_64-*linux*|ppc*-*linux*|powerpc*-*linux*| \
> >  s390*-*linux*|s390*-*tpf*|sparc*-*linux*)
> >    # Find out which ABI we are using.
> >    echo 'int i;' > conftest.$ac_ext
> >
> >i.e. the problem looks to be that the libtool package shipped in
> >debian/unstable does not support ppc64el correctly....
> 
> Actually powerpc*-*linux* covers the triplet for ppc64el, as seen in:
> >>        host-triplet:     powerpc64le-unknown-linux-gnu
> So ppc*-*linux* does not make difference for  ppc64el, if that is what you
> refer to.

Did you actually try it? 

Sure, it may not be the reason that it builds correctly on Darrick's
machine, but the fact is that Darricks' environment successfully
builds packages from the official xfsprogs tarballs without
problems and yours doesn't. The above change is the only thing that
is non-standard in Darrick's environment, so it's an obvious change
to try even if it makes no sense to you.

And it still doesn't change the situation: we can't fix the problem
until we understand what is causing it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
