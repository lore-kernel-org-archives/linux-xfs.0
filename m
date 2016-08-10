Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7DE757CA1
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 21:20:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 518C5304051
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 19:20:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5Uw7JfA6OGdFQNSl for <xfs@oss.sgi.com>;
	Tue, 09 Aug 2016 19:20:31 -0700 (PDT)
Date: Wed, 10 Aug 2016 12:19:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH xfsprogs] libxcmd: link against used libs
Message-ID: <20160810021918.GK19025@dastard>
References: <20160809144343.2228-1-vapier@gentoo.org>
	<20160809214910.GI19025@dastard>
	<20160810015236.GD30544@vapier.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160810015236.GD30544@vapier.lan>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: xfs@oss.sgi.com

On Wed, Aug 10, 2016 at 09:52:36AM +0800, Mike Frysinger wrote:
> On 10 Aug 2016 07:49, Dave Chinner wrote:
> > On Tue, Aug 09, 2016 at 10:43:43PM +0800, Mike Frysinger wrote:
> > > Since this lib uses symbols from libxfs (platform_findsizes) and many
> > > symbols from libblkid, link against both.  Otherwise, the resulting
> > > shared lib has missing symbols which makes linking against annoying.
> > 
> > libxcmd is an internal library, linked directly into the xfsprogs
> > binaries. It is never shipped or used outside xfsprogs, so what is
> > trying to use libxcmd as a shared library that doesn't also link
> > against libblkid or libxfs?
> 
> shouldn't internal libs still have coherent linkage ?  otherwise you
> cause problems even internally for xfs -- any other libs or progs that
> link against libxcmd have to list all the libs that libxcmd happen to
> use itself.

AFAIK, only if the libs or progs actually call the functions that
result in those dependencies being needed, right? i.e. it's not
dynamically linked, so functions that aren't called are culled by
the linker and so the undefined references to libxfs and libblkid
are culled and don't need to be resolved. Hence the program only
needs to be linked against libblkid/libxfs if they are required,
right?

See, for example, xfs_quota. quota/Makefile defines:

LLDLIBS = $(LIBXCMD)
LTDEPENDENCIES = $(LIBXCMD)
LLDFLAGS = -static

and the built binary:

$ ldd quota/xfs_quota
	linux-vdso.so.1 (0x00007ffc0dae6000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fdf92114000)
	/lib64/ld-linux-x86-64.so.2 (0x00005640768d0000)
$

i.e. it has no link-time or run-time dependency on libxfs or
libblkid, because it doesn't use any functions from libxcmd that
require those libraries to be linked in.

> otherwise not guaranteed.  e.g. just because you say libxfs needs to
> use libblkid doesn't mean the linker must put that after libxcmd in
> the link list.

No, but link order is defined by the order of libraries on the
linker command line and we control that directly. See the ld man
page:

...
-l namespec
....

	The linker will search an archive only once, at the location
	where it is specified on the command line.  If the archive
	defines a symbol which was undefined in some object which
	appeared before the archive on the command line, the linker
	will include the appropriate file(s) from the archive.
	However, an undefined symbol in an object appearing later on
	the command line will not cause the linker to search the
	archive again.

	See the -( option for a way to force the linker to search archives
	multiple times.
.....
-( archives -)
.....
	The specified archives are searched repeatedly until no new
	undefined references are created. [....]
.....

So we can define the link order exactly as we need it on the linker
command line, or we can just say "just search everything" if we
have cyclic dependencies that need to be resolved.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
