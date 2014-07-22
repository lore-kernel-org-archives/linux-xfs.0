Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7874B7F47
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 16:47:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6467C8F8033
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 14:47:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	FEMnLEGToCynDnRf for <xfs@oss.sgi.com>;
	Tue, 22 Jul 2014 14:47:30 -0700 (PDT)
Date: Wed, 23 Jul 2014 07:47:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem building xfsprogs
Message-ID: <20140722214727.GP4453@dastard>
References: <20140722160641.GU17967@beardog.cce.hp.com>
	<20140722205605.GJ20518@dastard>
	<20140722210951.GE14599@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140722210951.GE14599@beardog.cce.hp.com>
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
To: scameron@beardog.cce.hp.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 22, 2014 at 04:09:51PM -0500, scameron@beardog.cce.hp.com wrote:
> On Wed, Jul 23, 2014 at 06:56:05AM +1000, Dave Chinner wrote:
> > Nothing built in the include directory - is this a clean build area?
> 
> Well, it was originally clean, but I did try the build several
> times (not sure why I thought trying it again might help, but
> in any case I suppose the subsequent attempts may not have been
> considered clean.)
> 
> So, I just tried a fresh checkout with the same results:
> 
> [relliott@msablackburn ~]$ rm -fr xfsprogs
> [relliott@msablackburn ~]$ git clone git://oss.sgi.com/xfs/cmds/xfsprogs
> Initialized empty Git repository in /home/relliott/xfsprogs/.git/
> remote: Counting objects: 14359, done.
> remote: Compressing objects: 100% (5042/5042), done.
> remote: Total 14359 (delta 11622), reused 11396 (delta 9306)
> Receiving objects: 100% (14359/14359), 4.43 MiB | 1.34 MiB/s, done.
> Resolving deltas: 100% (11622/11622), done.
> [relliott@msablackburn ~]$ cd xfsprogs
> [relliott@msablackburn xfsprogs]$ make
....
> checking for gmake... /usr/bin/gmake
> checking for tar... /bin/tar
> checking for gzip... /bin/gzip
> checking whether gcc -MM is supported... yes

So, the $MAKEDEP variable should be fine....

> [relliott@msablackburn xfsprogs]$ make realclean; make Q=
...
> aclocal -I m4
> autoconf
> ./configure $LOCAL_CONFIGURE_OPTIONS
> checking build system type... x86_64-unknown-linux-gnu
> checking host system type... x86_64-unknown-linux-gnu
> checking for gcc... gcc
> checking for C compiler default output file name... a.out
> checking whether the C compiler works... yes
> checking whether we are cross compiling... no
> checking for suffix of executables... 
> checking for suffix of object files... o
> checking whether we are using the GNU C compiler... yes
> checking whether gcc accepts -g... yes
> checking for gcc option to accept ISO C89... none needed
> checking for a sed that does not truncate output... /bin/sed
> checking for grep that handles long lines and -e... /bin/grep
> checking for egrep... /bin/grep -E
> checking for fgrep... /bin/grep -F
> checking for ld used by gcc... /usr/bin/ld
> checking if the linker (/usr/bin/ld) is GNU ld... yes
> checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
> checking the name lister (/usr/bin/nm -B) interface... BSD nm
> checking whether ln -s works... yes
> checking the maximum length of command line arguments... 1572864
> checking whether the shell understands some XSI constructs... yes
> checking whether the shell understands "+="... yes
> checking for /usr/bin/ld option to reload object files... -r
> checking for objdump... objdump
> checking how to recognize dependent libraries... pass_all
> checking for ar... ar
> checking for strip... strip
> checking for ranlib... ranlib
> checking command to parse /usr/bin/nm -B output from gcc object... ok
> checking how to run the C preprocessor... gcc -E
> checking for ANSI C header files... yes
> checking for sys/types.h... yes
> checking for sys/stat.h... yes
> checking for stdlib.h... yes
> checking for string.h... yes
> checking for memory.h... yes
> checking for strings.h... yes
> checking for inttypes.h... yes
> checking for stdint.h... yes
> checking for unistd.h... yes
> checking for dlfcn.h... yes
> checking for objdir... .libs
> checking if gcc supports -fno-rtti -fno-exceptions... no
> checking for gcc option to produce PIC... -fPIC -DPIC
> checking if gcc PIC flag -fPIC -DPIC works... yes
> checking if gcc static flag -static works... no
> checking if gcc supports -c -o file.o... yes
> checking if gcc supports -c -o file.o... (cached) yes
> checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
> checking whether -lc should be explicitly linked in... no
> checking dynamic linker characteristics... GNU/Linux ld.so
> checking how to hardcode library paths into programs... immediate
> checking whether stripping libraries is possible... yes
> checking if libtool supports shared libraries... yes
> checking whether to build shared libraries... yes
> checking whether to build static libraries... yes
> checking for gcc... (cached) gcc
> checking whether we are using the GNU C compiler... (cached) yes
> checking whether gcc accepts -g... (cached) yes
> checking for gcc option to accept ISO C89... (cached) none needed
> checking for gcc... (cached) gcc
> checking whether we are using the GNU C compiler... (cached) yes
> checking whether gcc accepts -g... (cached) yes
> checking for gcc option to accept ISO C89... (cached) none needed
> checking for gmake... /usr/bin/gmake
> checking for tar... /bin/tar
> checking for gzip... /bin/gzip
> checking whether gcc -MM is supported... yes
> checking for awk... /bin/awk
> checking for sort... /bin/sort
> checking whether ln -s works... yes
> checking for msgfmt... /usr/bin/msgfmt
> checking for msgmerge... /usr/bin/msgmerge
> checking for xgettext... /usr/bin/xgettext
> checking for rpm... /bin/rpm
> checking for rpmbuild... /usr/bin/rpmbuild
> checking aio.h usability... yes
> checking aio.h presence... yes
> checking for aio.h... yes
> checking for lio_listio... no
> checking for lio_listio in -lrt... yes
> checking uuid.h usability... yes
> checking uuid.h presence... yes
> checking for uuid.h... yes
> checking sys/uuid.h usability... no
> checking sys/uuid.h presence... no
> checking for sys/uuid.h... no
> checking uuid/uuid.h usability... yes
> checking uuid/uuid.h presence... yes
> checking for uuid/uuid.h... yes
> checking for uuid_compare... no
> checking for uuid_compare in -luuid... yes
> checking pthread.h usability... yes
> checking pthread.h presence... yes
> checking for pthread.h... yes
> checking for pthread_mutex_init in -lpthread... yes
> checking for fadvise ... yes
> checking for madvise ... yes
> checking for mincore ... yes
> checking for sendfile ... yes
> checking for getmntent ... yes
> checking for getmntinfo ... no
> checking for fallocate... yes
> checking for fiemap... yes
> checking for preadv... yes
> checking for sync_file_range... yes
> checking for library containing blkid_probe_all... -lblkid
> checking for blkid_probe_get_topology... yes
> checking for readdir... yes
> checking size of long... 8
> checking size of char *... 8
> checking for __psint_t ... no
> checking for __psunsigned_t ... no
> checking for __u32 ... yes
> checking for umode_t... yes
> configure: creating ./config.status
> config.status: creating include/builddefs
> config.status: creating include/platform_defs.h
> config.status: executing libtool commands
> make --no-print-directory Q= -C . default
> /usr/bin/gmake --no-print-directory Q= include libxfs libxlog libxcmd libhandle libdisk copy db estimate fsck fsr growfs io logprint mkfs quota mdrestore repair rtcp m4 man doc po debian
> Building include
> /usr/bin/gmake --no-print-directory Q= -q -C include || /usr/bin/gmake --no-print-directory Q= -C include
>     [LN]     xfs
> ln -s . xfs
>     [LN]     disk
> ln -s . disk
> Building libxfs
> /usr/bin/gmake --no-print-directory Q= -q -C libxfs || /usr/bin/gmake --no-print-directory Q= -C libxfs
>     [CC]     gen_crc32table
> gcc -g -O2 -I. -g -O2 -DNDEBUG -DVERSION=\"3.2.1\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT   -o gen_crc32table gen_crc32table.c
>     [GENERATE] crc32table.h
> ./gen_crc32table > crc32table.h

But it's not running the dependency generation rule here, which is
what generates the .ltdep file.

Can you please attach the built include/builddefs and
include/platform_defs.h files that autoconf built?

Also, what version of autoconf are you running?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
