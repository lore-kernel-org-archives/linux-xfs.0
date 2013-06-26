Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EC8FB7F4E
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 21:41:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5CCA8F8049
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 19:41:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	uJ3dJ5BmXyy2TTmU for <xfs@oss.sgi.com>;
	Tue, 25 Jun 2013 19:41:36 -0700 (PDT)
Date: Wed, 26 Jun 2013 12:41:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: fix make deb
Message-ID: <20130626024133.GF29376@dastard>
References: <1371526854-15761-1-git-send-email-david@fromorbit.com>
	<20130625220123.GG20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130625220123.GG20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 25, 2013 at 05:01:23PM -0500, Ben Myers wrote:
> On Tue, Jun 18, 2013 at 01:40:53PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Commit 48212a30 ("xfsprogs: update 'make deb' to use tarball) fixed
> > a bunch of problems with making the source tarball for releases.
> > However, it broke the debian package builds in a way I hadn't
> > noticed until I rewrote my CI system build script.
> > 
> > I noticed that the CI system wasn't building from a pristine
> > workarea, and instead was just updating the old workarea and running
> > 'make deb'. I added a 'make realclean' to remove all previous state
> > from the workarea, and then 'make deb' started failing with errors
> > building the tarball because po/xfsprogs.pot didn't have a build
> > rule
> > 
> > The above commit removed the pre-build of the translations target,
> > and instead made the translation build target a dependency of
> > building the the tarball. Hence the lack of a build rule of the
> > translations causes the source tarball build to fail.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> My systems seem not to be having this problem.  They seem to be building
> xfsprogs.pot due to the dependancy through SRCDIR->SRCTAR->SRCTARINC.  Can you
> post the error?

It works on a single threaded build because there is implicit build
ordering as only a single subdirectory is built at a time, and the
po/xfsprogs.pot is built before it is required as a dependency.

If I do:

$ git clean -f -d
$ make realclean
$ make deb

The build works. If I parallelise the build, the dependency is no
longer satisfied because make parallelises across directories that
have no defined build dependencies. So if I do:

$ git clean -f -d
$ make realclean
$ make -j8 deb
libtoolize -c `libtoolize -n -i >/dev/null 2>/dev/null && echo -i` -f
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `.'.
libtoolize: copying file `./config.guess'
libtoolize: copying file `./config.sub'
libtoolize: copying file `./install-sh'
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
cp include/install-sh .
aclocal -I m4
autoconf
./configure $LOCAL_CONFIGURE_OPTIONS
checking build system type... x86_64-unknown-linux-gnu
checking host system type... x86_64-unknown-linux-gnu
checking how to print strings... printf
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for a sed that does not truncate output... /bin/sed
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for fgrep... /bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 3458764513820540925
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+="... yes
checking how to convert x86_64-unknown-linux-gnu file names to x86_64-unknown-linux-gnu format... func_convert_file_noop
checking how to convert x86_64-unknown-linux-gnu file names to toolchain format... func_convert_file_noop
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... @
checking for strip... strip
checking for ranlib... ranlib
checking for gawk... gawk
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for mt... mt
checking if mt is a manifest tool... no
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC -DPIC
checking if gcc PIC flag -fPIC -DPIC works... yes
checking if gcc static flag -static works... yes
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
checking for gcc... (cached) gcc
checking whether we are using the GNU C compiler... (cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to accept ISO C89... (cached) none needed
checking for gcc... (cached) gcc
checking whether we are using the GNU C compiler... (cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to accept ISO C89... (cached) none needed
checking for gmake... no
checking for make... /usr/bin/make
checking for tar... /bin/tar
checking for gzip... /bin/gzip
checking whether gcc -MM is supported... yes
checking for sort... /usr/bin/sort
checking whether ln -s works... yes
checking for msgfmt... /usr/bin/msgfmt
checking for msgmerge... /usr/bin/msgmerge
checking for xgettext... /usr/bin/xgettext
checking for rpm... /usr/bin/rpm
checking for rpmbuild... /usr/bin/rpmbuild
checking aio.h usability... yes
checking aio.h presence... yes
checking for aio.h... yes
checking for lio_listio... no
checking for lio_listio in -lrt... yes
checking uuid.h usability... no
checking uuid.h presence... no
checking for uuid.h... no
checking sys/uuid.h usability... no
checking sys/uuid.h presence... no
checking for sys/uuid.h... no
checking uuid/uuid.h usability... yes
checking uuid/uuid.h presence... yes
checking for uuid/uuid.h... yes
checking for uuid_compare... no
checking for uuid_compare in -luuid... yes
checking pthread.h usability... yes
checking pthread.h presence... yes
checking for pthread.h... yes
checking for pthread_mutex_init in -lpthread... yes
checking for fadvise ... yes
checking for madvise ... yes
checking for mincore ... yes
checking for sendfile ... yes
checking for getmntent ... yes
checking for getmntinfo ... no
checking for fallocate... yes
checking for fiemap... yes
checking for preadv... yes
checking for sync_file_range... yes
checking for library containing blkid_probe_all... -lblkid
checking for blkid_probe_get_topology... yes
checking size of long... 8
checking size of char *... 8
checking for __psint_t ... no
checking for __psunsigned_t ... no
checking for __u32 ... yes
configure: creating ./config.status
config.status: creating include/builddefs
config.status: creating include/platform_defs.h
config.status: executing libtool commands
make[2]: *** No rule to make target `po/xfsprogs.pot', needed by `xfsprogs-3.1.11.tar.gz'.  Stop.
make[2]: *** Waiting for unfinished jobs....
Building include
.....
$

The build fails because it tries to do a parallel build of something
has a dependency on po/xfsprogs.pot before it has been built. And
because po/xfsprogs.pot has no individual build rule, make cannot
built it to fulfill the parallel build dependency and so fails.

IOWs, building the srctar is dependent on first *compiling* the
translations, but there is no explicit rule that actually defines
that build dependency.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
