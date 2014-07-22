Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 401137F3F
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 16:10:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1EE6330406B
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 14:10:46 -0700 (PDT)
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
	by cuda.sgi.com with ESMTP id p2wfst6p1G08GU5U (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 22 Jul 2014 14:10:43 -0700 (PDT)
Date: Tue, 22 Jul 2014 16:09:51 -0500
From: scameron@beardog.cce.hp.com
Subject: Re: Problem building xfsprogs
Message-ID: <20140722210951.GE14599@beardog.cce.hp.com>
References: <20140722160641.GU17967@beardog.cce.hp.com>
	<20140722205605.GJ20518@dastard>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140722205605.GJ20518@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: scameron@beardog.cce.hp.com, fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 23, 2014 at 06:56:05AM +1000, Dave Chinner wrote:
> [cc xfs@oss.sgi.com - list for XFS issues]
> 
> On Tue, Jul 22, 2014 at 11:06:41AM -0500, scameron@beardog.cce.hp.com wrote:
> > 
> > I'm trying to build xfsprogs (in order to run xfstests), and I'm running into this:
> > 
> > [scameron@localhost xfsprogs]$ git log --oneline | head -1
> > ba24eb7 logprint: Fix printing of AGF and AGI buffers
> > [scameron@localhost xfsprogs]$ git pull
> > Already up-to-date.
> > [scameron@localhost xfsprogs]$ git diff
> > [scameron@localhost xfsprogs]$ ./configure
> > checking build system type... x86_64-unknown-linux-gnu
> > checking host system type... x86_64-unknown-linux-gnu
> > checking for gcc... gcc
> > checking for C compiler default output file name... a.out
> > 
> > [...snip...]
> > 
> > checking for library containing blkid_probe_all... -lblkid
> > checking for blkid_probe_get_topology... yes
> > checking for readdir... yes
> > checking size of long... 8
> > checking size of char *... 8
> > checking for __psint_t ... no
> > checking for __psunsigned_t ... no
> > checking for __u32 ... yes
> > checking for umode_t... yes
> > configure: creating ./config.status
> > config.status: creating include/builddefs
> > config.status: creating include/platform_defs.h
> > config.status: include/platform_defs.h is unchanged
> > config.status: executing libtool commands
> > [scameron@localhost xfsprogs]$ make
> > Building include
> 
> Nothing built in the include directory - is this a clean build area?

Well, it was originally clean, but I did try the build several
times (not sure why I thought trying it again might help, but
in any case I suppose the subsequent attempts may not have been
considered clean.)

So, I just tried a fresh checkout with the same results:

[relliott@msablackburn ~]$ rm -fr xfsprogs
[relliott@msablackburn ~]$ git clone git://oss.sgi.com/xfs/cmds/xfsprogs
Initialized empty Git repository in /home/relliott/xfsprogs/.git/
remote: Counting objects: 14359, done.
remote: Compressing objects: 100% (5042/5042), done.
remote: Total 14359 (delta 11622), reused 11396 (delta 9306)
Receiving objects: 100% (14359/14359), 4.43 MiB | 1.34 MiB/s, done.
Resolving deltas: 100% (11622/11622), done.
[relliott@msablackburn ~]$ cd xfsprogs
[relliott@msablackburn xfsprogs]$ make
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
checking for gcc... gcc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables... 
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
checking the maximum length of command line arguments... 1572864
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+="... yes
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for ar... ar
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
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
checking if gcc static flag -static works... no
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
checking for gmake... /usr/bin/gmake
checking for tar... /bin/tar
checking for gzip... /bin/gzip
checking whether gcc -MM is supported... yes
checking for awk... /bin/awk
checking for sort... /bin/sort
checking whether ln -s works... yes
checking for msgfmt... /usr/bin/msgfmt
checking for msgmerge... /usr/bin/msgmerge
checking for xgettext... /usr/bin/xgettext
checking for rpm... /bin/rpm
checking for rpmbuild... /usr/bin/rpmbuild
checking aio.h usability... yes
checking aio.h presence... yes
checking for aio.h... yes
checking for lio_listio... no
checking for lio_listio in -lrt... yes
checking uuid.h usability... yes
checking uuid.h presence... yes
checking for uuid.h... yes
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
checking for readdir... yes
checking size of long... 8
checking size of char *... 8
checking for __psint_t ... no
checking for __psunsigned_t ... no
checking for __u32 ... yes
checking for umode_t... yes
configure: creating ./config.status
config.status: creating include/builddefs
config.status: creating include/platform_defs.h
config.status: executing libtool commands
Building include
    [LN]     xfs
    [LN]     disk
Building libxfs
    [CC]     gen_crc32table
    [GENERATE] crc32table.h
    [TEST]    CRC32
CRC_LE_BITS = 32
crc32: tests passed, 225944 bytes in 173 usec
crc32c: tests passed, 225944 bytes in 167 usec
gmake[3]: *** No rule to make target `.ltdep', needed by `ltdepend'.  Stop.
gmake[2]: *** [libxfs] Error 2
make[1]: *** [default] Error 2
make: *** [default] Error 2
[relliott@msablackburn xfsprogs]$ 
[relliott@msablackburn xfsprogs]$ git log --oneline | head
ba24eb7 logprint: Fix printing of AGF and AGI buffers
a14d409 quota: fix NULL pointer dereference in report_f
ed350fc libxcmd: make all comparisons using realpath'd paths
6bf4721 repair: copy, don't clear, stripe geometry in backup SB
b6ad854 xfsprogs: update debian packaging for next release
1a05f91 xfsprogs: add a watch file into the debian packaging
642d23d xfsprogs: v3.2.1 release
fb3b519 xfsprogs: update polish translation
1fe7b0b repair: handle uncorrected corruptions in phase 2
cee99cf libxfs: clear the buffer error while the buffer is locked
[relliott@msablackburn xfsprogs]$ 



> 
> > Building libxfs
> > gmake[2]: *** No rule to make target `.ltdep', needed by `ltdepend'.  Stop.
> > gmake[1]: *** [libxfs] Error 2
> > make: *** [default] Error 2
> > 
> > Any ideas what's wrong here?
> 
> The automatic dependency generation failed to generate the .ltdep
> file. But it can't be a clean build area, because the libxfs build
> rule is:
> 
> default: crc32selftest ltdepend $(LTLIBRARY)
> 
> and I don't see the crc32selftest rule being executed before the
> dependencies are generated. It shoul dlook something like:
> 
> $ make
> ....
> configure: creating ./config.status
> config.status: creating include/builddefs
> config.status: creating include/platform_defs.h
> config.status: executing libtool commands
> Building include
>     [LN]     xfs
>     [LN]     disk
> Building libxfs
>     [CC]     gen_crc32table
>     [GENERATE] crc32table.h
>     [TEST]    CRC32
> CRC_LE_BITS = 32
> crc32: tests passed, 225944 bytes in 131 usec
> crc32c: tests passed, 225944 bytes in 131 usec
>     [CC]     cache.lo
> ....
> 
> So the first thing I'd do is run 'make realclean; make' 

That fails the same way for me.

> to restart
> the build for a clean workarea first. If that doesn't fix the
> problem, then I'll need to know versions of libtool, gcc, etc that
> you are using and you'll need to post the output of "make realclean;
> make Q=" so we can see the command line that is actually failing.

Ok.

[relliott@msablackburn xfsprogs]$ gcc --version
gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-4)
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

[relliott@msablackburn xfsprogs]$ libtool --version
ltmain.sh (GNU libtool) 2.2.6b
Written by Gordon Matzigkeit <gord@gnu.ai.mit.edu>, 1996

Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
[relliott@msablackburn xfsprogs]$ cat /etc/*-release
LSB_VERSION=base-4.0-amd64:base-4.0-noarch:core-4.0-amd64:core-4.0-noarch:graphics-4.0-amd64:graphics-4.0-noarch:printing-4.0-amd64:printing-4.0-noarch
Red Hat Enterprise Linux Server release 6.5 (Santiago)
Red Hat Enterprise Linux Server release 6.5 (Santiago)
[relliott@msablackburn xfsprogs]$ uname -a
Linux msablackburn.americas.hpqcorp.net 3.16.0-rc5+ #170 SMP Tue Jul 22 13:42:21 CDT 2014 x86_64 x86_64 x86_64 GNU/Linux
[relliott@msablackburn xfsprogs]$

[relliott@msablackburn xfsprogs]$ make realclean; make Q=
Cleaning include
Cleaning libxfs
Cleaning libxlog
Cleaning libxcmd
Cleaning libhandle
Cleaning libdisk
Cleaning copy
Cleaning db
Cleaning estimate
Cleaning fsck
Cleaning fsr
Cleaning growfs
Cleaning io
Cleaning logprint
Cleaning mkfs
Cleaning quota
Cleaning mdrestore
Cleaning repair
Cleaning rtcp
Cleaning m4
Cleaning man
Cleaning man3
Cleaning man5
Cleaning man8
Cleaning doc
Cleaning po
Cleaning debian
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
checking for gcc... gcc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables... 
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
checking the maximum length of command line arguments... 1572864
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+="... yes
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for ar... ar
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
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
checking if gcc static flag -static works... no
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
checking for gmake... /usr/bin/gmake
checking for tar... /bin/tar
checking for gzip... /bin/gzip
checking whether gcc -MM is supported... yes
checking for awk... /bin/awk
checking for sort... /bin/sort
checking whether ln -s works... yes
checking for msgfmt... /usr/bin/msgfmt
checking for msgmerge... /usr/bin/msgmerge
checking for xgettext... /usr/bin/xgettext
checking for rpm... /bin/rpm
checking for rpmbuild... /usr/bin/rpmbuild
checking aio.h usability... yes
checking aio.h presence... yes
checking for aio.h... yes
checking for lio_listio... no
checking for lio_listio in -lrt... yes
checking uuid.h usability... yes
checking uuid.h presence... yes
checking for uuid.h... yes
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
checking for readdir... yes
checking size of long... 8
checking size of char *... 8
checking for __psint_t ... no
checking for __psunsigned_t ... no
checking for __u32 ... yes
checking for umode_t... yes
configure: creating ./config.status
config.status: creating include/builddefs
config.status: creating include/platform_defs.h
config.status: executing libtool commands
make --no-print-directory Q= -C . default
/usr/bin/gmake --no-print-directory Q= include libxfs libxlog libxcmd libhandle libdisk copy db estimate fsck fsr growfs io logprint mkfs quota mdrestore repair rtcp m4 man doc po debian
Building include
/usr/bin/gmake --no-print-directory Q= -q -C include || /usr/bin/gmake --no-print-directory Q= -C include
    [LN]     xfs
ln -s . xfs
    [LN]     disk
ln -s . disk
Building libxfs
/usr/bin/gmake --no-print-directory Q= -q -C libxfs || /usr/bin/gmake --no-print-directory Q= -C libxfs
    [CC]     gen_crc32table
gcc -g -O2 -I. -g -O2 -DNDEBUG -DVERSION=\"3.2.1\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT   -o gen_crc32table gen_crc32table.c
    [GENERATE] crc32table.h
./gen_crc32table > crc32table.h
    [TEST]    CRC32
gcc -g -O2 -I. -g -O2 -DNDEBUG -DVERSION=\"3.2.1\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT   -D CRC32_SELFTEST=1 crc32.c -o crc32selftest
./crc32selftest
CRC_LE_BITS = 32
crc32: tests passed, 225944 bytes in 166 usec
crc32c: tests passed, 225944 bytes in 173 usec
gmake[3]: *** No rule to make target `.ltdep', needed by `ltdepend'.  Stop.
gmake[2]: *** [libxfs] Error 2
make[1]: *** [default] Error 2
make: *** [default] Error 2
[relliott@msablackburn xfsprogs]$ 


Thanks.

-- steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
