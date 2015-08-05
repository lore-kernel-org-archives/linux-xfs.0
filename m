Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1BAC37FA8
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 08:00:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0842E304064
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 06:00:11 -0700 (PDT)
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85]) by
	cuda.sgi.com with ESMTP id JdO73D89yuQBwu7s (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 06:00:10 -0700 (PDT)
Received: from /spool/local
	by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <ferseiti@linux.vnet.ibm.com>;
	Wed, 5 Aug 2015 10:00:08 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id D3004352006E
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 08:58:58 -0400 (EDT)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
	by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
	t75CwRKr27263362
	for <xfs@oss.sgi.com>; Wed, 5 Aug 2015 09:58:27 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
	by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	t75D03KK020507 for <xfs@oss.sgi.com>; Wed, 5 Aug 2015 10:00:04 -0300
Message-ID: <55C208D2.4060907@linux.vnet.ibm.com>
Date: Wed, 05 Aug 2015 10:00:02 -0300
From: Fernando Seiti Furusato <ferseiti@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: Bug#793495: xfsprogs fails to build on debian ppc64el
References: <55BB9271.6000300@gmx.net> <55BBEF4F.6070809@linux.vnet.ibm.com>
	<20150801225230.GR16638@dastard>
	<41BF7556-AAAB-4F22-B8C2-8991A0917DE2@gmx.net>
	<20150802221301.GO3902@dastard>
	<55C0D916.1010102@linux.vnet.ibm.com>
	<20150804225819.GV16638@dastard>
In-Reply-To: <20150804225819.GV16638@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, 793495@bugs.debian.org, Breno Leitao <brenohl@br.ibm.com>, Daniel Bast <daniel.bast@gmx.net>

On 08/04/2015 07:58 PM, Dave Chinner wrote:

> That makes distclean do the same thing that realclean does and, as
> that commit I pointed out previously, has been intentionally
> separated in the build system. You could make the debian/rules file
> simply call 'make realclean' rather than 'make distclean' to acheive
> this without changing the main makefile. Either way, however, I
> don't think that's the problem.
Yes, except I tried changing debian/rules to use realclean before coming up
with that idea and it broke the build.

  make[1]: Entering directory '/home/xfsprogs/xfsprogs-3.2.4'
  ./configure $LOCAL_CONFIGURE_OPTIONS
  configure: error: cannot find install-sh, install.sh, or shtool in . "."/.
  Makefile:89: recipe for target 'include/builddefs' failed
  make[1]: *** [include/builddefs] Error 1
  make[1]: Leaving directory '/home/xfsprogs/xfsprogs-3.2.4'
  debian/rules:36: recipe for target '.census' failed
  make: *** [.census] Error 2

> Darrick Wong noted on #xfs that his builds of xfsprogs on ppc64el
> from a tarball don't fail at all. His libtool chain is:
When I build xfsprog on ppc64el from a tarball, it does not fail at all either.
But in my case, specifically, it is because the tarball does not come with
a configure file (which would solve the problem I pointed out), so Makefile
generates it and runs libtoolize -c -i which updates the configuration files
needed.

>
>>        host-triplet:     powerpc64le-unknown-linux-gnu
>>        libtoolize:       (GNU libtool) 2.4.2 Debian-2.4.2-1.7ubuntu1
>>        automake:         automake (GNU automake) 1.14.1
>>        autoconf:         autoconf (GNU Autoconf) 2.69
>
> Which is similar to mine, but libtoolize is slightly older (and I'm
> on x86_64-pc-linux-gnu). It turns out that the reason the build
> works on his machines is that someone had made a small manual change
> to /usr/share/aclocal/libtool.m4:
>
> --- a/libtool.m4       2014-02-11 04:58:49.000000000 -0800
> +++ b/libtool.m4  2015-07-31 13:48:23.375432372 -0700
> @@ -1312,7 +1312,7 @@
>     rm -rf conftest*
>     ;;
>
> -x86_64-*kfreebsd*-gnu|x86_64-*linux*|powerpc*-*linux*| \
> +x86_64-*kfreebsd*-gnu|x86_64-*linux*|ppc*-*linux*|powerpc*-*linux*| \
>   s390*-*linux*|s390*-*tpf*|sparc*-*linux*)
>     # Find out which ABI we are using.
>     echo 'int i;' > conftest.$ac_ext
>
> i.e. the problem looks to be that the libtool package shipped in
> debian/unstable does not support ppc64el correctly....

Actually powerpc*-*linux* covers the triplet for ppc64el, as seen in:
 >>        host-triplet:     powerpc64le-unknown-linux-gnu
So ppc*-*linux* does not make difference for  ppc64el, if that is what you
refer to.

IMHO, if the debian src package xfsprogs came just like it comes in 
git://oss.sgi.com/xfs/cmds/xfsprogs, ie clean, the build would not fail.

Thanks and regards.
-- 

Fernando Seiti Furusato
IBM Linux Technology Center

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
